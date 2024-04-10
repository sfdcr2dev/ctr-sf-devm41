/* 
    ESS_RetirementAdminReminderController RetirementAdminReminder = new ESS_RetirementAdminReminderController();
    string cronExp1 = '0 0 12 1 * ? *';
    system.schedule('ESS - Retirement Admin Reminder', cronExp1, RetirementAdminReminder);
	
	Run on 1 Feb
	For Test '0 0 8 * * ? *'
*/
global class ESS_RetirementAdminReminderController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    private static string orgId = UserInfo.getOrganizationId();
    
    integer currentYear = system.Datetime.now().year();
    integer year = Integer.ValueOf(currentYear + 1);
    integer twoYear = Integer.ValueOf(currentYear + 2);
    date retirementStartDate = Date.newInstance(year, 1, 2);
    date retirementEndDate = Date.newInstance(twoYear, 1, 1);
    
    string data = 'IN';
    string query = 'select id, Employee_ID__c, Name_Emp_EN_FN__c, Employee_Retirement_Date__c, Employee_DOB__c, Retirement_Section_Head_Skip__c, ' +
        'Retirement_Section_Head_Id__c , Retirement_Section_Head_Name__c, Retirement_VP_Id__c, Retirement_VP_Name__c, Retirement_Section_Head_Position__c, ' +
        'Retirement_Section_Head_Position_TH__c, Retirement_VP_Position__c, Retirement_VP_Position_TH__c, Retirement_Section_Head_TH__c, Retirement_VP_TH__c from ESS_Master_Employee__c ' +
        'where data__c =: data AND (Employee_Retirement_Date__c >=: retirementStartDate AND Employee_Retirement_Date__c <=: retirementEndDate) order by employee_id__c asc';
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ESS_Master_Employee__c> Masters) {
        
        List<ESS_Retirement_DTO.RetirementListDTO> results = new List<ESS_Retirement_DTO.RetirementListDTO>();
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c, Retirement_Selection__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, MAINPOSITION__c from PISUsers__c where User__c != null AND Active__c = true]; //AND CompanyName__c = 'TOP' AND Retirement_Selection__c = true
        
        Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
        Map<string, PISUsers__c> mapPOSIDPISUsers = new Map<string, PISUsers__c>();
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                mapPOSIDPISUsers.put(PISUser.POSID__c, PISUser);
                
                if(PISUser.MAINPOSITION__c) {
                    mapPISUsers.put(PISUser.EMPLOYEEID__c, PISUser);
                }
            }    
        } 
            
        List<ESS_Retirement__c> allRetirements = allRetirements();
            
        List<ESS_Master_Employee__c> finalEmployees = new List<ESS_Master_Employee__c>();
        if(Masters.size() > 0) {
            for(ESS_Master_Employee__c Master : Masters) {
                PISUsers__c PISUser = mapPISUsers.get(Master.Employee_ID__c);
                if(PISUser != null) {
                    finalEmployees.add(Master);
                }
            }        
        } 
        if(finalEmployees.size() > 0) {
            for(ESS_Master_Employee__c Master : finalEmployees) {
                ESS_Retirement_DTO.RetirementListDTO assign = new ESS_Retirement_DTO.RetirementListDTO();
                assign = assignToRetirementListDTO(Master, mapPOSIDPISUsers, mapPISUsers, allRetirements);
                if(string.isNotEmpty(assign.employeeid) && !assign.isDisable) {
                    //Check show only TOP user
                    PISUsers__c PISUser = mapPISUsers.get(Master.Employee_ID__c);
                    if(PISUser.COMPANYNAME__c == 'TOP' && PISUser.Retirement_Selection__c) {
                		//Check Employee DOB
                        List<string> dobYears = new List<string> {string.Valueof(Integer.valueOf(currentYear) - 59), string.valueOf(Integer.valueOf(currentYear) - 54)};
                        integer employeeDOBYear = Master.Employee_DOB__c.Year();
                		boolean existed = dobYears.contains(String.ValueOf(employeeDOBYear));
                        if(existed) {
                			results.add(assign);                         
                        }
                    }
                }
                
            }     
        }
        
        //Send Email to Personel Admin for Retirement
        if(results.size() > 0) {
            SendEmail(results);
        }
        
    }
    
    global void finish(Database.BatchableContext BC){    
    }
    
    public static void SendEmail(List<ESS_Retirement_DTO.RetirementListDTO> Retirements) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/one/one.app#/alohaRedirect/apex/ESS_Retirement_List?parent=HOME';
        
        List<PISUsers__c> PISUsers = ESS_Global.assignToPersonelAdminPISUser();
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Retirement_Personel_Admin_Reminder'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
             
        string retirementDetail = '';
        if(Retirements.size() > 0) {
            
            for(ESS_Retirement_DTO.RetirementListDTO Retirement : Retirements) {
                retirementDetail = retirementDetail+ '<tr>' + 
                    			  '<td style="border: 1px solid black;"> ' + Retirement.employeeId + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Retirement.employeeName + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Retirement.birthDate + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Retirement.age + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Retirement.function + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Retirement.department + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Retirement.section + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Retirement.level + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Retirement.sectionHeadName + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Retirement.departmentHeadName + '</td>' +
                    			  '</tr>';
            }
        }
        
        string retirementTable = '';
        retirementTable = '<table style="width:100%; border: 1px solid black;">' +
						 '<tr>' + 
                         '<th style="border: 1px solid black;">Employee ID</th> '+
                         '<th style="border: 1px solid black;">Employee Name</th>  '+ 
                         '<th style="border: 1px solid black;">Birth Date</th>  '+
                         '<th style="border: 1px solid black;">Age</th> '+
                         '<th style="border: 1px solid black;">Function</th> '+
                         '<th style="border: 1px solid black;">Department</th> '+
                         '<th style="border: 1px solid black;">Section</th> '+
                         '<th style="border: 1px solid black;">Level</th> '+
                         '<th style="border: 1px solid black;">Immediate Line / Section Head</th> '+
                         '<th style="border: 1px solid black;">Department Head</th> '+
                         '</tr>' +
            			 retirementDetail +
            			 '</table>';
        
        if(PISUsers.size() > 0) {
            
            for(PISUsers__c Receiver : PISUsers) {
                
                string createdDate;
                string submittedDate;
                
                //Send email
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false); 
                string subject = emailTemplate.Subject;
                    
                string htmlBody = emailTemplate.HtmlValue;
                htmlBody = htmlBody.replace('{!RetirementList}', retirementTable);
        		htmlBody = htmlBody.replace('{!NoOfEmployee}', String.ValueOf(Retirements.size()));
                htmlBody = htmlBody.replace('{!Link}', LinkURL(URL, 'Employee Retirement Date Confirmation'));
                htmlBody = htmlBody.replace(']]>', '');
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!RetirementList}', retirementTable);
        		plainBody = plainBody.replace('{!NoOfEmployee}', String.ValueOf(Retirements.size()));
                plainBody = plainBody.replace('{!Link}', LinkURL(URL, 'Employee Retirement Date Confirmation'));
                plainBody = plainBody.replace(']]>', '');
                
                message.setTargetObjectId(Receiver.User__c); 
                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(Receiver.User__c);
                message.setSubject(subject);
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                
                message.toAddresses = new String[] { Receiver.Email__c };
                
                //For testing only
                List<string> ccEmails = new List<string> { 'atittaya@softever.co.th', 'sarocha@softever.co.th' };
                message.setCcAddresses(ccEmails);
                
                if(orgId == '00D9D0000000MjyUAE' || orgId == '00D0k000000EL5rEAG') {
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'puttipat@softever.co.th'];
                    message.setOrgWideEmailAddressId(owea[0].Id);
                }
                else {
                    message.setSenderDisplayName('i-Link+');
                }
                
                sendEmails.add(message);
                
            }
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
        }
        
    }
    
    private static List<ESS_Probationary__c> allProbations() {
        List<ESS_Probationary__c> Probations = [select id, employee_id__c from ESS_Probationary__c];
        return Probations;
    }
    
    //Assign to DTO section
    private static ESS_Retirement_DTO.RetirementListDTO assignToRetirementListDTO(ESS_Master_Employee__c Employee, Map<string, PISUsers__c> mapPOSIDPISUsers, Map<string, PISUsers__c> mapPISUsers, List<ESS_Retirement__c> Retirements) {
    
        string employeeId = '';
        string employeeName = '';
        string employeeTitle = '';
        string employeeNameTH = '';
        string function = '';
        string department = '';
        string section = '';
        string position = '';
        string level = '';
        string sectionHead = '';
        string departmentHead = '';
        string userId = '';
        string sectionHeadName = '';
        string sectionHeadNameTH = '';
        string departmentHeadName = '';
        string departmentHeadNameTH = '';
        string sectionHeadPosition = '';
        string departmentHeadPosition = '';
        
    	ESS_Retirement_DTO.RetirementListDTO RetirementList = new ESS_Retirement_DTO.RetirementListDTO();
        boolean isMap = false;
        
        if(mapPISUsers.size() > 0) {
            
            PISUsers__c PISUser = mapPISUsers.get(Employee.Employee_ID__c);
            
            if(PISUser != null) {
                userId = PISUser.User__c;
                employeeId = PISUser.EMPLOYEEID__c;
                employeeName = PISUser.EN_Fullname__c;
                employeeTitle = PISUser.THTITLE__c;
                employeeNameTH = PISUser.TH_Fullname__c;
                function = PISUser.FUNCTION__c;
                department = PISUser.DEPARTMENT__c;
                section = PISUser.SECTIONS__c;
                position = PISUser.OBJENFULLNAME__c;
                level = PISUser.LEVEL__c;
                
                ESS_Retirement_DTO.RetirementApproverDTO RetirementApprover = new ESS_Retirement_DTO.RetirementApproverDTO();
                RetirementApprover = ESS_Global.GetSectionHeadDepartmentHead(PISUser, mapPOSIDPISUsers);
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Id__c)) {
                    sectionHead = Employee.Retirement_Section_Head_Id__c;
                }
                else {
                    sectionHead = RetirementApprover.sectionHeadId;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Name__c)) {
                    sectionHeadName = Employee.Retirement_Section_Head_Name__c;
                }
                else {
                    sectionHeadName = RetirementApprover.sectionHeadName;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_TH__c)) {
                    sectionHeadNameTH = Employee.Retirement_Section_Head_TH__c;
                }
                else {
                    sectionHeadNameTH = RetirementApprover.sectionHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Position__c)) {
                    sectionHeadPosition = Employee.Retirement_Section_Head_Position__c;
                }
                else {
                    sectionHeadPosition = RetirementApprover.sectionHeadPosition;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Id__c)) {
                    departmentHead = Employee.Retirement_VP_Id__c;
                }
                else {
                    departmentHead = RetirementApprover.departmentHeadId;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Name__c)) {
                    departmentHeadName = Employee.Retirement_VP_Name__c;
                }
                else {
                    departmentHeadName = RetirementApprover.departmentHeadName;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_TH__c)) {
                    departmentHeadNameTH = Employee.Retirement_VP_TH__c;
                }
                else {
                    departmentHeadNameTH = RetirementApprover.departmentHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Position__c)) {
                    departmentHeadPosition = Employee.Retirement_VP_Position__c;
                }
                else {
                    departmentHeadPosition = RetirementApprover.departmentHeadPosition;
                }
                
                isMap = true;
                
                //break;
            }
        }
        
        RetirementList.userId = userId;
        RetirementList.employeeId = employeeId;
        RetirementList.employeeName = employeeName;
        RetirementList.employeeTitle = employeeTitle;
        RetirementList.employeeNameTH = employeeNameTH;
        RetirementList.birthDate = Employee.Employee_DOB__c;
        
        RetirementList.age = '';
        
        if(Employee.Employee_DOB__c != null) {
            RetirementList.age = findAge(Date.ValueOf(Employee.Employee_DOB__c), date.today());
        }
        
        RetirementList.function = function;
        RetirementList.department = department;
        RetirementList.section = section;
        RetirementList.position = position;
        RetirementList.level = level;
        RetirementList.sectionHead = sectionHead;
        RetirementList.sectionHeadTH = sectionHeadNameTH;
        RetirementList.sectionHeadName = sectionHeadName;
        RetirementList.sectionHeadPosition = sectionHeadPosition;
        if(Employee.Retirement_Section_Head_Skip__c) {
            RetirementList.sectionHead = '';
            RetirementList.sectionHeadTH = '';
            RetirementList.sectionHeadName = '';
            RetirementList.sectionHeadPosition = '';
        }
        RetirementList.departmentHead = departmentHead;
        RetirementList.departmentHeadTH = departmentHeadNameTH;
        RetirementList.departmentHeadname = departmentHeadName;
        RetirementList.departmentHeadPosition = departmentHeadPosition;
        
        if(!isMap) {
            //RetirementList.employeeId = Employee.Employee_ID__c;
        }
        
        RetirementList.isDisable = false;
        //Check isDisable
        if(Retirements.size() > 0) {
            for(ESS_Retirement__c Retirement : Retirements) {
                if(Retirement.Employee_ID__c == employeeId) {
                    RetirementList.isDisable = true;
                    break;
                }
            }
        }
        
        return RetirementList;
    
    }
    
    private static List<ESS_Retirement__c> allRetirements() {
        List<ESS_Retirement__c> Retirements = [select id, employee_id__c from ESS_Retirement__c];
        return Retirements;
    }
    
    private static string findAge(date birthDate, date todayDate) {
        
        string age = '';
        
        integer diffDay = birthDate.daysBetween(todayDate);
        decimal remainDay = Decimal.ValueOf(diffDay)/365;
        
        string year = String.ValueOf(Integer.ValueOf(remainDay));
        String month = String.ValueOf(remainDay.setScale(1)).substringAfter('.');
        
        age = year + 'ปี ' + month + 'เดือน';
        
        return age;
        
    }
    
    public static string LinkURL(string URL, string documentNo) {
        string returnURL = '<a href=\'' + URL + '\'>' + documentNo + '</a>';
        return returnURL;
    }

}