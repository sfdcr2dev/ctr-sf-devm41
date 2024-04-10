/* 
    ESS_ProbationAdminReminderBatchable ProbationAdminReminder = new ESS_ProbationAdminReminderBatchable();
    string cronExp1 = '0 0 12 1 * ? *';
    system.schedule('ESS - Probation Admin Reminder', cronExp1, ProbationAdminReminder);
	
	Run on every day when there is an employee date at 151 days
	For Test '0 0 8 * * ? *'
*/
global class ESS_ProbationAdminReminderController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    private static string orgId = UserInfo.getOrganizationId();
    public date todayDate = system.Date.today();
    public string data = 'IN';
    public string query = 'select id, Employee_ID__c, Employee_Date_Joined__c, Probationary_Date__c, Probation_Section_Head_Id__c, ' +
        					'Probation_Section_Head_Name__c, Probation_Section_Head_Position__c, Probation_VP_Id__c, Probation_VP_Name__c, ' +
        					'Probation_VP_Position__c, CEP__c, Probation_Section_Head_TH__c from ESS_Master_Employee__c where data__c =: data AND Employee_Date_Joined__c != null AND Need_Probation__c = true AND Probation_Completed__c = false limit 1'; //Probationary_Date__c >=: todayDate
         
	global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ESS_Master_Employee__c> Masters) {
        
        date todayDate = system.Date.today();
        string data = 'IN';
        
        List<ESS_Master_Employee__c> Employees = new List<ESS_Master_Employee__c>();
        List<ESS_Probationary_DTO.ProbationaryListDTO> results = new List<ESS_Probationary_DTO.ProbationaryListDTO>();
        
        Set<string> employeeIds = new Set<string>();
        List<ESS_Probationary__c> Probationaries = [select id, employee_id__c from ESS_Probationary__c];
        
        if(Probationaries.size() > 0) {
            for(ESS_Probationary__c Probation : Probationaries) {
                employeeIds.add(Probation.Employee_Id__c);
            }
        }
        
        string query = 'select id, Employee_ID__c, Employee_Date_Joined__c, Probationary_Date__c, Probation_Section_Head_Id__c, Probation_Section_Head_Name__c, Probation_Section_Head_Position__c, Probation_VP_Id__c, Probation_VP_Name__c, Probation_VP_Position__c, CEP__c, Probation_Section_Head_TH__c, Probation_VP_TH__c from ESS_Master_Employee__c where data__c =: data AND Employee_Date_Joined__c != null AND Need_Probation__c = true AND Probation_Completed__c = false AND employee_id__c NOT IN: employeeIds';
         
        Employees = database.query(query);
        
        List<ESS_Probationary__c> allProbations = allProbations();
            
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND User__c != null];
            
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
        
        if(Masters.size() > 0){
            boolean isExactDate = false;
            for(ESS_Master_Employee__c Master : Employees) {
                if(Master.Probationary_Date__c == todayDate) {
                    isExactDate = true;
                }
            }
            if(isExactDate) {
                for(ESS_Master_Employee__c Master : Employees) {
                    ESS_Probationary_DTO.ProbationaryListDTO assign = new ESS_Probationary_DTO.ProbationaryListDTO();
                    assign = assignToProbationaryListDTO(Master, mapPOSIDPISUsers, mapPISUsers, allProbations);
                    if(string.isNotEmpty(assign.employeeid)) {
                        results.add(assign);
                    }
            	}
                //Send Email to Personel Admin for Probationary
                if(results.size() > 0) {
                    SendEmail(results);
                }
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){    
    }
    
    public static void SendEmail(List<ESS_Probationary_DTO.ProbationaryListDTO> Probations) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/one/one.app#/alohaRedirect/apex/ESS_Probationary_List?parent=HOME';
        
        List<PISUsers__c> PISUsers = ESS_Global.assignToPersonelAdminPISUser();
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Probation_Personel_Admin_Reminder'];
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
             
        string probationDetail = '';
        if(Probations.size() > 0) {
            
            for(ESS_Probationary_DTO.ProbationaryListDTO Probation : Probations) {
                probationDetail = probationDetail+ '<tr>' + 
                    			  '<td style="border: 1px solid black;"> ' + Probation.employeeId + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.employeeName + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.level + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.dateJoinedCompany + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.dateCompletedProbation + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.sectionHeadName + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.departmentHeadName + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.cep + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.function + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.department + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.section + '</td>' +
                    			  '<td style="border: 1px solid black;"> ' + Probation.unit + '</td>' +
                    			  '</tr>';
            }
        }
        
        string probationTable = '';
        probationTable = '<table style="width:100%; border: 1px solid black;">' +
						 '<tr>' + 
                         '<th style="border: 1px solid black;">Employee ID</th> '+
                         '<th style="border: 1px solid black;">Employee Name</th>  '+ 
                         '<th style="border: 1px solid black;">Level</th>  '+
                         '<th style="border: 1px solid black;">Date Joined Company</th> '+
                         '<th style="border: 1px solid black;">Date Completed Probation</th> '+
                         '<th style="border: 1px solid black;">Immediate Line / Section Head</th> '+
                         '<th style="border: 1px solid black;">Department Head</th> '+
                         '<th style="border: 1px solid black;">CEP</th> '+
                         '<th style="border: 1px solid black;">Function</th> '+
                         '<th style="border: 1px solid black;">Department</th> '+
                         '<th style="border: 1px solid black;">Section</th> '+
                         '<th style="border: 1px solid black;">Unit</th> '+
                         '</tr>' +
            			 probationDetail +
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
                htmlBody = htmlBody.replace('{!ProbationaryList}', probationTable);
        		htmlBody = htmlBody.replace('{!NoOfEmployee}', String.ValueOf(Probations.size()));
            	htmlBody = htmlBody.replace('{!Link}', LinkURL(URL, 'Employee Probation Date Confirmation'));
                htmlBody = htmlBody.replace(']]>', '');
                
                String plainBody = emailTemplate.Body;
                plainBody = plainBody.replace('{!ProbationaryList}', probationTable);
        		plainBody = plainBody.replace('{!NoOfEmployee}', String.ValueOf(Probations.size()));
            	plainBody = plainBody.replace('{!DocumentLink}', LinkURL(URL, 'Employee Probation Date Confirmation'));
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
    private static ESS_Probationary_DTO.ProbationaryListDTO assignToProbationaryListDTO(ESS_Master_Employee__c Employee, Map<string, PISUsers__c> mapPOSIDPISUsers, Map<string, PISUsers__c> mapPISUsers, List<ESS_Probationary__c> Probations) {
    
        string employeeId = '';
        string employeeName = '';
        string employeeNameTH = '';
        string function = '';
        string department = '';
        string section = '';
        string unit = '';
        string sectionHead = '';
        string departmentHead = '';
        string level = '';
        string userId = '';
        string sectionHeadName = '';
        string sectionHeadNameTH = '';
        string departmentHeadName = '';
        string departmentHeadNameTH = '';
        string sectionHeadPosition = '';
        string departmentHeadPosition = '';
        string companyName = '';
        string cep = '';
        
        ESS_Probationary_DTO.ProbationaryListDTO ProbationaryList = new ESS_Probationary_DTO.ProbationaryListDTO();
        boolean isMap = false;
        
        if(mapPISUsers.size() > 0) {
            
            PISUsers__c PISUser = mapPISUsers.get(Employee.Employee_ID__c);
            
            if(PISUser != null) {
                userId = PISUser.User__c;
                employeeId = PISUser.EMPLOYEEID__c;
                employeeName = PISUser.EN_Fullname__c;
                employeeNameTH = PISUser.TH_Fullname__c;
                function = PISUser.FUNCTION__c;
                department = PISUser.DEPARTMENT__c;
                section = PISUser.SECTIONS__c;
                
                if(string.isNotEmpty(PISUser.UNITS__c)) {
                    unit = PISUser.UNITS__c;
                }
                
                level = PISUser.Level__c;
                
                if(PISUser.HOME_COMP__c == '1100') {
                    companyName = 'TOP';
                }
                else if(PISUser.HOME_COMP__c == '1600') {
                    companyName = 'TES';
                }
                
                ESS_Probationary_DTO.ProbationaryApproverDTO ProbationApprover = new ESS_Probationary_DTO.ProbationaryApproverDTO();
                ProbationApprover = ESS_Global.GetSectionHeadDepartmentHeadProbation(PISUser, mapPOSIDPISUsers);
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_Id__c)) {
                    sectionHead = Employee.Probation_Section_Head_Id__c;
                }
                else {
                    sectionHead = ProbationApprover.sectionHeadId;
                }
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_Name__c)) {
                    sectionHeadName = Employee.Probation_Section_Head_Name__c;
                }
                else {
                    sectionHeadName = ProbationApprover.sectionHeadName;
                }
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_TH__c)) {
                    sectionHeadNameTH = Employee.Probation_Section_Head_TH__c;
                }
                else {
                    sectionHeadNameTH = ProbationApprover.sectionHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_Position__c)) {
                    sectionHeadPosition = Employee.Probation_Section_Head_Position__c;
                }
                else {
                    sectionHeadPosition = ProbationApprover.sectionHeadPosition;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_Id__c)) {
                    departmentHead = Employee.Probation_VP_Id__c;
                }
                else {
                    departmentHead = ProbationApprover.departmentHeadId;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_Name__c)) {
                    departmentHeadName = Employee.Probation_VP_Name__c;
                }
                else {
                    departmentHeadName = ProbationApprover.departmentHeadName;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_TH__c)) {
                    departmentHeadNameTH = Employee.Probation_VP_TH__c;
                }
                else {
                    departmentHeadNameTH = ProbationApprover.departmentHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_Position__c)) {
                    departmentHeadPosition = Employee.Probation_VP_Position__c;
                }
                else {
                    departmentHeadPosition = ProbationApprover.departmentHeadPosition;
                }
                
                isMap = true;
            }
        }
        
        ProbationaryList.ownerId = userId;
        ProbationaryList.employeeId = employeeId;
        ProbationaryList.employeeName = employeeNameTH;
        ProbationaryList.companyName = companyName;
        ProbationaryList.dateJoinedCompany = Employee.Employee_Date_Joined__c;
        ProbationaryList.dateCompletedProbation = Employee.Employee_Date_Joined__c.addDays(180);
        ProbationaryList.function = function;
        ProbationaryList.department = department;
        ProbationaryList.section = section;
        ProbationaryList.unit = unit;
        ProbationaryList.level = level;
        ProbationaryList.sectionHead = sectionHead;
        ProbationaryList.departmentHead = departmentHead;
        ProbationaryList.sectionHeadName = sectionHeadName;
        ProbationaryList.departmentHeadname = departmentHeadName;
        ProbationaryList.sectionHeadPosition = sectionHeadPosition;
        ProbationaryList.departmentHeadPosition = departmentHeadPosition;
        
        //Decode CEP
        if(string.isNotEmpty(Employee.CEP__c)) {
            Blob blobValue = EncodingUtil.convertFromHex(Employee.CEP__c);
            ProbationaryList.cep = blobValue.toString();
        }
        else {
            ProbationaryList.cep = '';
        }
        
        if(!isMap) {
            //ProbationaryList.employeeId = Employee.Employee_ID__c;
        }
        
        ProbationaryList.isDisable = false;
        //Check isDisable
        if(Probations.size() > 0) {
            for(ESS_Probationary__c Probation : Probations) {
                if(Probation.Employee_ID__c == employeeId) {
                    ProbationaryList.isDisable = true;
                    break;
                }
            }
        }
        
        
        return ProbationaryList;
    
    }
    
    public static string LinkURL(string URL, string documentNo) {
        string returnURL = '<a href=\'' + URL + '\'>' + documentNo + '</a>';
        return returnURL;
    }
    
}