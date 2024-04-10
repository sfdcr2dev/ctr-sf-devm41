public class CG_Batch {

    public static string CheckEnvironment() {
        
        CG_Config__c Config = [select environment__c from CG_Config__c];
        
        return Config.Environment__c;
        
    }
    
    public static Set<string> CheckingContract() {
        
        Set<string> contracts = new Set<string>();
        
        StaticResource sr= [select id,body from StaticResource Where Name = 'CG_Contract'];
        
        List<CG_DTO.ContractDTO> allContracts = (List<CG_DTO.ContractDTO>)JSON.deserialize(sr.body.toString(), List<CG_DTO.ContractDTO>.class);

        for(CG_DTO.ContractDTO Contract : allContracts) {
            if(Contract.Status == false) {
                contracts.add(Contract.ContractID);
            }
        }

		return contracts;        
    }
    
    public static Set<Id> CheckContractWithPISUser() {
        Set<Id> pisUserIds = new Set<Id>();
        Set<string> excludeContracts = CheckingContract();
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        PISUsers = [select id, name, contract__c, new_employee__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
        								ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                        Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                      	where Active__c = true AND MAINPOSITION__c = true AND User__c != null];
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                if(PISUser.Contract__c != null) {
                    boolean contactMoreThanOne = PISUser.Contract__c.contains(';');
                    string userContract;
                    if(contactMoreThanOne) {
                        List<string> contracts = PISUser.Contract__c.split(';');
                        integer size = contracts.size();
                        userContract = contracts[size-1];
                    }
                    else {
                        userContract = PISUser.CONTRACT__c;
                    }
                    
                    boolean isExcludeContract = excludeContracts.contains(userContract);
                    if(!isExcludeContract) {
                        pisUserIds.add(PISUser.User__c);
                    }
                }
                else {
                    pisUserIds.add(PISUser.User__c);
                }
            }
        }

        return pisUserIds;
    }
    
    public static void ManualCOINewEmployee(Set<string> PISIds) {
        
        //Set<string> contracts = CheckingContract();
        Set<Id> pisUserIds = CheckContractWithPISUser();
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        PISUsers = [select id, name, contract__c, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
        								ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                        Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                      	where new_employee__c = true AND COINewEmployeeGenerated__c = false AND Active__c = true AND MAINPOSITION__c = true AND 
                    					User__c != null AND User__c IN :pisUserIds AND Id IN :PISIds];
        
        if(PISUsers.size() > 0) {
            
        	Id COINewEmployeeRTId = [select id, name from RecordType where name = 'CG COI New Employee' AND sobjecttype = 'CG_Reporting__c'].Id;
        
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_New_Employee_User'];
            
            List<User> Users = AllUsers();
            
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            
        	List<string> ReportTypes = new List<string> { String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
            //Delete Existing COI New Employee
            List<CG_Reporting__c> CGReports = [select id, isDisable__c from CG_Reporting__c where Type_Of_Report__c IN: ReportTypes AND Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)];
        
            if(CGReports.size() > 0) {
                for(CG_Reporting__c CGReport : CGReports) {
                    CGReport.isDisable__c = true;
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
                }
                
                update(CGReports);
            }
            
            //Running No
       	 	CG_Config__c CGConfig = [select Year__c, COI_New_User_Running_No__c, COI_Incident_Running_No__c, COI_Annual_Running_No__c ,
										CG_New_User_Running_No__c, CG_Manual_Running_No__c, CG_Annual_Running_No__c, Gift_Running_No__c from CG_Config__c];
 
            //CustomNoti                            
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'CG_Notification'];

            //OppNotiApp
            OPP_Application__c CGApp = [select id, name from OPP_Application__c where Name =: 'CG Reporting'];

            List<Opp_Notification__c> OppNotis = new List<Opp_Notification__c>();
            
            for(PISUsers__c PISUser : PISUsers) {
                
                //Generate COI New Employee and send to user
                CGConfig = CG_ReportingHandler.GenerateRunningNo('COINewEmployee', CGConfig);
                CG_DTO.BatchDTO batchDTO = CG_ReportingHandler.COI_New_Employee(PISUser, COINewEmployeeRTId, emailTemplate, Users, CGConfig.COI_New_User_Running_No__c, notificationType, CGApp);
                
                //Send Email
                sendEmails.add(batchDTO.sendEmail);
                //Send BellNoti
                CG_NotiController.SendBellNoti(batchDTO.bellNoti, notificationType);
                //Send OppNoti
                OppNotis.add(CG_NotiController.SaveOppNoti(batchDTO.oppNoti));
                
                //Update Generated Flag
                PISUser.COINewEmployeeGenerated__c = true;
                
            }
            
            //Update CGConfig
            database.update(CGConfig, true);
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
                
                if(OppNotis.size() > 0) {
                    database.insert(OppNotis, true);
                }
            }
            
            update(PISUsers);
                
        }
        
    }
    
    public static void COINewEmployee() {
        
        string env = CheckEnvironment();
        //Set<string> contracts = CheckingContract();
        Set<Id> pisUserIds = CheckContractWithPISUser();
        
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        PISUsers = [select id, name, contract__c, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
        								ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                        Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                      	where new_employee__c = true AND COINewEmployeeGenerated__c = false AND Active__c = true AND MAINPOSITION__c = true AND 
                    					User__c != null AND User__c IN: pisUserIds LIMIT 50];
        
        if(PISUsers.size() > 0) {
            
        	Id COINewEmployeeRTId = [select id, name from RecordType where name = 'CG COI New Employee' AND sobjecttype = 'CG_Reporting__c'].Id;
        
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_New_Employee_User'];
            
            List<User> Users = AllUsers();
            
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            
        	List<string> ReportTypes = new List<string> { String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
            //Delete Existing COI New Employee
            List<CG_Reporting__c> CGReports = [select id, isDisable__c from CG_Reporting__c where Type_Of_Report__c IN: ReportTypes AND Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)];
        
            if(CGReports.size() > 0) {
                for(CG_Reporting__c CGReport : CGReports) {
                    CGReport.isDisable__c = true;
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
                }
                
                update(CGReports);
            }
            
            //Running No
       	 	CG_Config__c CGConfig = [select Year__c, COI_New_User_Running_No__c, COI_Incident_Running_No__c, COI_Annual_Running_No__c ,
										CG_New_User_Running_No__c, CG_Manual_Running_No__c, CG_Annual_Running_No__c, Gift_Running_No__c from CG_Config__c];
 
            //CustomNoti                            
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'CG_Notification'];

            //OppNotiApp
            OPP_Application__c CGApp = [select id, name from OPP_Application__c where Name =: 'CG Reporting'];

            List<Opp_Notification__c> OppNotis = new List<Opp_Notification__c>();
            
            for(PISUsers__c PISUser : PISUsers) {
                
                //Generate COI New Employee and send to user
                CGConfig = CG_ReportingHandler.GenerateRunningNo('COINewEmployee', CGConfig);
                CG_DTO.BatchDTO batchDTO = CG_ReportingHandler.COI_New_Employee(PISUser, COINewEmployeeRTId, emailTemplate, Users, CGConfig.COI_New_User_Running_No__c, notificationType, CGApp);
                system.debug(batchDTO.sendEmail.toaddresses);
                //Send Email
                sendEmails.add(batchDTO.sendEmail);
                //Send BellNoti
                CG_NotiController.SendBellNoti(batchDTO.bellNoti, notificationType);
                //Send OppNoti
                OppNotis.add(CG_NotiController.SaveOppNoti(batchDTO.oppNoti));
                                
                //Update Generated Flag
                PISUser.COINewEmployeeGenerated__c = true;
                
            }
            
            //Update CG Config
            database.update(CGConfig, true);
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
                
                if(OppNotis.size() > 0) {
                    database.insert(OppNotis, true);
                }
            }
            
            update(PISUsers);
                
        }
        
    }
    
    public static void COIAnnual() {
        
        string env = CheckEnvironment();
        //Set<string> contracts = CheckingContract();
        Set<Id> pisUserIds = CheckContractWithPISUser();
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
		if(env.toLowerCase() == 'dev') {
        
            Group TestGroup = [select id, developername from Group where developername =: 'CG_Test'];
            List<GroupMember> TestUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: TestGroup.Id];
            
            List<Id> UserIds = new List<Id>();
            for(GroupMember Test : TestUsers) {
                UserIds.add(Test.userorgroupid);
            }
            
            userIds.add('0052v00000hBj7lAAC');
            
            PISUsers = [select id, name, contract__c, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
                                            ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                            Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                            where User__c IN: UserIds AND MAINPOSITION__c = true AND Active__c = true];
            
        }
        else {
            
            PISUsers = [select id, name, contract__c, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
                                            ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                            Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                            where User__c != null AND User__c IN :pisUserIds AND MAINPOSITION__c = true AND Active__c = true];
            
        }
        
        
        //Expired COI Annual that is not Submit
        List<string> ReportTypes = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual) };
        List<CG_Reporting__c> CGReports = [select id, isDisable__c from CG_Reporting__c where Type_Of_Report__c IN: ReportTypes AND Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)];
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                CGReport.isDisable__c = true;
                CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
            }
            
            update(CGReports);
        }
        
        if(PISUsers.size() > 0) {
            
            //From CG Setting
            CG_Setting__c CGSetting = [select id, name, type__c, start_date__c, end_date__c from CG_Setting__c where RecordType.Name = 'COI Annual'];
            
            Id COIAnnualRTId = [select id, name from RecordType where name = 'CG COI Annual' AND sobjecttype = 'CG_Reporting__c'].Id;
        	
            List<User> Users = AllUsers();
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_Annual'];
            
            boolean isCOIInDuration = CG_ReportingHandler.CGSettingDuration('COI Annual');
        	
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            
            //Running No
       	 	CG_Config__c CGConfig = [select Year__c, COI_New_User_Running_No__c, COI_Incident_Running_No__c, COI_Annual_Running_No__c ,
										CG_New_User_Running_No__c, CG_Manual_Running_No__c, CG_Annual_Running_No__c, Gift_Running_No__c from CG_Config__c];
 
            integer count = 0;
            for(PISUsers__c PISUser : PISUsers) {
                count++;
                System.debug(count);
                if(isCOIInDuration) {
                    //Generate COI Annual and send to user
                    CGConfig = CG_ReportingHandler.GenerateRunningNo('COIAnnual', CGConfig);
                	Messaging.SingleEmailMessage sendEmail = CG_ReportingHandler.COI_Annual(PISUser, COIAnnualRTId, emailTemplate, CGSetting, Users, CGConfig.COI_Annual_Running_No__c);      
                    sendEmails.add(sendEmail);
                }

            }
            
            //Update CGConfig
            database.update(CGConfig, false);
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
            
            if(isCOIInDuration) {
                //Update Duration in CG Setting
                CG_ReportingHandler.CGSettingSaveDuration('COI Annual');
            }
            
        }
        
    }
    
    public static void ManualCGNewEmployee(Set<string> PISIds) {
        
        //Set<string> contracts = CheckingContract();
        Set<Id> pisUserIds = CheckContractWithPISUser();
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
		PISUsers = [select id, name, contract__c, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
        								ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                        Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                      	where User__c != null AND User__c IN :pisUserIds AND new_employee__c = true AND CGNewEmployeeGenerated__c = false AND Active__c = true AND 
                    					MAINPOSITION__c = true AND Id IN :PISIds];
            
        if(PISUsers.size() > 0) {
            
            List<string> ReportTypes = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) };
            //Delete Existing CG New Employee
            List<CG_Reporting__c> CGReports = [select id, isDisable__c from CG_Reporting__c where Type_Of_Report__c IN: ReportTypes AND Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)];
            
            if(CGReports.size() > 0) {
                for(CG_Reporting__c CGReport : CGReports) {
                    CGReport.isDisable__c = true;
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
                }
                
                update(CGReports);
            }
            
            //From CG Setting
            CG_Setting__c CGSetting = [select id, name, type__c, start_date__c, end_date__c, duration_json__c from CG_Setting__c where RecordType.Name = 'CG New Employee'];
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CG_New_Employee_User'];
            
            List<User> Users = AllUsers();
            
        	Id ManualNewEmployeeRTId = [select id, name from RecordType where name = 'CG Manual New Employee' AND sobjecttype = 'CG_Reporting__c'].Id;
        
            //Check CG Setting Duration
            boolean isInDuration = CG_ReportingHandler.CGSettingDuration('CG New Employee');
            
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            
            //Running No
       	 	CG_Config__c CGConfig = [select Year__c, COI_New_User_Running_No__c, COI_Incident_Running_No__c, COI_Annual_Running_No__c ,
										CG_New_User_Running_No__c, CG_Manual_Running_No__c, CG_Annual_Running_No__c, Gift_Running_No__c from CG_Config__c];
 
            //CustomNoti                            
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'CG_Notification'];

            //OppNotiApp
            OPP_Application__c CGApp = [select id, name from OPP_Application__c where Name =: 'CG Reporting'];

            List<Opp_Notification__c> OppNotis = new List<Opp_Notification__c>();
            
            for(PISUsers__c PISUser : PISUsers) {
                //Generate CG New Employee and send to user
				CGConfig = CG_ReportingHandler.GenerateRunningNo('CGNewEmployee', CGConfig);
                CG_DTO.BatchDTO batchDTO = CG_ReportingHandler.CG_Manual_New_Employee(PISUser, ManualNewEmployeeRTId, emailTemplate, CGSetting, Users, CGConfig.CG_New_User_Running_No__c, notificationType, CGApp);
                
                //Send Email
                sendEmails.add(batchDTO.sendEmail);
                //Send BellNoti
                CG_NotiController.SendBellNoti(batchDTO.bellNoti, notificationType);
                //Send OppNoti
                OppNotis.add(CG_NotiController.SaveOppNoti(batchDTO.oppNoti));
                    
                //Update Generated flag
                PISUser.CGNewEmployeeGenerated__c = true;
            }
            
            //Update CGConfig
            database.update(CGConfig, true);
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
                
                if(OppNotis.size() > 0) {
                    database.insert(OppNotis,true);
                }
            }
            
            update(PISUsers);
            
            //Update Duration in CG Setting
            //CG_ReportingHandler.CGSettingSaveDuration('CG New Employee');
            
        }
    }
    
    public static void CGNewEmployee() {
        
        //Set<string> contracts = CheckingContract();
        Set<Id> pisUserIds = CheckContractWithPISUser();
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
		PISUsers = [select id, name, contract__c, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
        								ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                        Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                      	where User__c != null AND User__c IN :pisUserIds AND new_employee__c = true AND CGNewEmployeeGenerated__c = false AND Active__c = true AND 
                    					MAINPOSITION__c = true limit 50];
            
        if(PISUsers.size() > 0) {
            
            List<string> ReportTypes = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) };
            //Delete Existing CG New Employee
            List<CG_Reporting__c> CGReports = [select id, isDisable__c from CG_Reporting__c where Type_Of_Report__c IN: ReportTypes AND Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)];
            
            if(CGReports.size() > 0) {
                for(CG_Reporting__c CGReport : CGReports) {
                    CGReport.isDisable__c = true;
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
                }
                
                update(CGReports);
            }
            
            //From CG Setting
            CG_Setting__c CGSetting = [select id, name, type__c, start_date__c, end_date__c, duration_json__c from CG_Setting__c where RecordType.Name = 'CG New Employee'];
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CG_New_Employee_User'];
            
            List<User> Users = AllUsers();
            
        	Id ManualNewEmployeeRTId = [select id, name from RecordType where name = 'CG Manual New Employee' AND sobjecttype = 'CG_Reporting__c'].Id;
        
            //Check CG Setting Duration
            boolean isInDuration = CG_ReportingHandler.CGSettingDuration('CG New Employee');
            
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            
            //Running No
       	 	CG_Config__c CGConfig = [select Year__c, COI_New_User_Running_No__c, COI_Incident_Running_No__c, COI_Annual_Running_No__c ,
										CG_New_User_Running_No__c, CG_Manual_Running_No__c, CG_Annual_Running_No__c, Gift_Running_No__c from CG_Config__c];
 
            //CustomNoti                            
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'CG_Notification'];

            //OppNotiApp
            OPP_Application__c CGApp = [select id, name from OPP_Application__c where Name =: 'CG Reporting'];

            List<Opp_Notification__c> OppNotis = new List<Opp_Notification__c>();
            
            for(PISUsers__c PISUser : PISUsers) {
                //Generate CG New Employee and send to user
				CGConfig = CG_ReportingHandler.GenerateRunningNo('CGNewEmployee', CGConfig);
                CG_DTO.BatchDTO batchDTO = CG_ReportingHandler.CG_Manual_New_Employee(PISUser, ManualNewEmployeeRTId, emailTemplate, CGSetting, Users, CGConfig.CG_New_User_Running_No__c, notificationType, CGApp);
                
                //Send Email
                sendEmails.add(batchDTO.sendEmail);
                //Send BellNoti
                CG_NotiController.SendBellNoti(batchDTO.bellNoti, notificationType);
                //Send OppNoti
                OppNotis.add(CG_NotiController.SaveOppNoti(batchDTO.oppNoti));
                   
                //Update Generated flag
                PISUser.CGNewEmployeeGenerated__c = true;
            }
            
            //Update CGConfig
            database.update(CGConfig, true);
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
                
                if(OppNotis.size() > 0) {
                    database.insert(OppNotis, true);
                }
            }
            
            update(PISUsers);
            
            //Update Duration in CG Setting
            //CG_ReportingHandler.CGSettingSaveDuration('CG New Employee');
            
        }
        
    }
    
    public static void CGAnnual() {
        
        string env = CheckEnvironment();
        //Set<string> contracts = CheckingContract();
        Set<Id> pisUserIds = CheckContractWithPISUser();
        
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
		if(env.toLowerCase() == 'dev') {
            
            Group TestGroup = [select id, developername from Group where developername =: 'CG_Test'];
            List<GroupMember> TestUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: TestGroup.Id];
            
            List<Id> UserIds = new List<Id>();
            for(GroupMember Test : TestUsers) {
                UserIds.add(Test.userorgroupid);
            }
            
            //userIds = new List<Id>();
            userIds.add('0052v00000hBj7lAAC');
            
            PISUsers = [select id, name, contract__c, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
                                            ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                            Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                            where User__c IN: UserIds AND MAINPOSITION__c = true AND Active__c = true];
                        
        }
        else {
            
            PISUsers = [select id, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
                                            ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                            Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                            where User__c != null AND User__c IN :pisUserIds AND MAINPOSITION__c = true AND Active__c = true];
            
        }
        
        if(PISUsers.size() > 0) {
            
            //From CG Setting
            CG_Setting__c CGSetting = [select id, name, type__c, start_date__c, end_date__c, duration_json__c from CG_Setting__c where RecordType.Name = 'CG Annual'];
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CG_Annual'];
            
        	Id ManualAnnualRTId = [select id, name from RecordType where name = 'CG Manual Annual' AND sobjecttype = 'CG_Reporting__c'].Id;
        
            List<User> Users = AllUsers();
            
            //Check CG Setting Duration
            boolean isCGInDuration = CG_ReportingHandler.CGSettingDuration('CG Annual');
            
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
			
            //Expired CG Annual that is not Submit
            List<string> ReportTypes = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGAnnual) };
            List<CG_Reporting__c> CGReports = [select id, isDisable__c from CG_Reporting__c where Type_Of_Report__c IN: ReportTypes AND Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)];
            
            if(CGReports.size() > 0) {
                for(CG_Reporting__c CGReport : CGReports) {
                    CGReport.isDisable__c = true;
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
                }
                
                update(CGReports);
            }
            
            //Running No
       	 	CG_Config__c CGConfig = [select Year__c, COI_New_User_Running_No__c, COI_Incident_Running_No__c, COI_Annual_Running_No__c ,
										CG_New_User_Running_No__c, CG_Manual_Running_No__c, CG_Annual_Running_No__c, Gift_Running_No__c from CG_Config__c];
 
            for(PISUsers__c PISUser : PISUsers) {
                
                if(isCGInDuration) {
                    //Generate CG Annual and send to user
					CGConfig = CG_ReportingHandler.GenerateRunningNo('CGAnnual', CGConfig);
                    Messaging.SingleEmailMessage sendEmail = CG_ReportingHandler.CG_Manual_Annual(PISUser, ManualAnnualRTId, emailTemplate, CGSetting, Users, CGConfig.CG_Annual_Running_No__c);   
                    sendEmails.add(sendEmail);
                }
                
            }
            
            //Update CGConfig
            database.update(CGConfig, true);
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
            
            if(isCGInDuration) {
                //Update Duration in CG Setting
                CG_ReportingHandler.CGSettingSaveDuration('CG Annual');
            }
            
        }
        
    }
    
    public static void CGManual() {
        
        string env = CheckEnvironment();
        //Set<string> contracts = CheckingContract();
        Set<Id> pisUserIds = CheckContractWithPISUser();
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
		if(env.toLowerCase() == 'dev') {
            
            Group TestGroup = [select id, developername from Group where developername =: 'CG_Test'];
            List<GroupMember> TestUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: TestGroup.Id];
            
            List<Id> UserIds = new List<Id>();
            for(GroupMember Test : TestUsers) {
                UserIds.add(Test.userorgroupid);
            }
            
            PISUsers = [select id, name, contract__c, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
                                            ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                            Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                            where User__c IN: UserIds AND MAINPOSITION__c = true AND Active__c = true];
            
        }
        else {
            
            PISUsers = [select id, name, contract__c, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
                                            ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                            Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                            where User__c != null AND User__c IN :pisUserIds AND MAINPOSITION__c = true AND Active__c = true];
            
        }
        
        if(PISUsers.size() > 0) {
            
            //From CG Setting
            CG_Setting__c CGSetting = [select id, name, type__c, start_date__c, end_date__c, duration_json__c from CG_Setting__c where RecordType.Name = 'CG Manual'];
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CG_Manual'];
            
        	Id ManualRTId = [select id, name from RecordType where name = 'CG Manual' AND sobjecttype = 'CG_Reporting__c'].Id;
        
            List<User> Users = AllUsers();
            
            //Check CG Setting Duration
            boolean isCGInDuration = CG_ReportingHandler.CGSettingDuration('CG Manual');
            
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();

            //Expired CG Manual that is not Submit
            List<string> ReportTypes = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGManual) };
            List<CG_Reporting__c> CGReports = [select id, isDisable__c from CG_Reporting__c where Type_Of_Report__c IN: ReportTypes AND Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)];
            
            if(CGReports.size() > 0) {
                for(CG_Reporting__c CGReport : CGReports) {
                    CGReport.isDisable__c = true;
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
                }
                
                update(CGReports);
            }
            
            //Running No
            CG_Config__c CGConfig = [select Year__c, COI_New_User_Running_No__c, COI_Incident_Running_No__c, COI_Annual_Running_No__c ,
                                     CG_New_User_Running_No__c, CG_Manual_Running_No__c, CG_Annual_Running_No__c, Gift_Running_No__c from CG_Config__c];
            
            //CustomNoti                            
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'CG_Notification'];

            //OppNotiApp
            OPP_Application__c CGApp = [select id, name from OPP_Application__c where Name =: 'CG Reporting'];

            List<Opp_Notification__c> OppNotis = new List<Opp_Notification__c>();
            
            integer count = 0;
            for(PISUsers__c PISUser : PISUsers) {
                count++;
                if(isCGInDuration) {
                    //Generate CG Manual and send to user
					CGConfig = CG_ReportingHandler.GenerateRunningNo('CGManual', CGConfig);
       				CG_DTO.BatchDTO batchDTO = CG_ReportingHandler.CG_Manual(PISUser, ManualRTId, emailTemplate, CGSetting, Users, CGConfig.CG_Manual_Running_No__c, notificationType, CGApp);   
                    
                    //Send Email
                    sendEmails.add(batchDTO.sendEmail);
                    //Send BellNoti
                    CG_NotiController.SendBellNoti(batchDTO.bellNoti, notificationType);
                    //Send OppNoti
                    OppNotis.add(CG_NotiController.SaveOppNoti(batchDTO.oppNoti));
                      
                }
                
            }
            
            //Update CGConfig
            database.update(CGConfig, true);
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
                
                if(OppNotis.size() > 0) {
                    database.insert(OppNotis, true);
                }
            }
            
            if(isCGInDuration) {
                //Update Duration in CG Setting
                CG_ReportingHandler.CGSettingSaveDuration('CG Manual');
            }
            
        }
        
    }
    
    public static void COICGAnnual() {
        
        string env = CheckEnvironment();
        //Set<string> contracts = CheckingContract();
        Set<Id> pisUserIds = CheckContractWithPISUser();
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
		if(env.toLowerCase() == 'dev') {
            
            Group TestGroup = [select id, developername from Group where developername =: 'CG_Test'];
            List<GroupMember> TestUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: TestGroup.Id];
            
            List<Id> UserIds = new List<Id>();
            for(GroupMember Test : TestUsers) {
                UserIds.add(Test.userorgroupid);
            }
            
            userIds.add('0052v00000hBj7lAAC');
            
            PISUsers = [select id, name, contract__c, new_employee__c, EMPLOYEEID__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
                                            ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                            Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, OwnerId, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c from pisusers__c 
                                            where User__c != null AND User__c IN: UserIds AND MAINPOSITION__c = true AND Active__c = true AND
                       						COIAnnualGenerated__c = false AND CGAnnualGenerated__c = false ];
           
        }
        else {
            
            PISUsers = [select id, name, contract__c, employeeid__c, new_employee__c, User__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c,
                                            ENFIRSTNAME__c, ENLASTNAME__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, LineManagerUser__c, EN_Fullname__c,
                                            Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, OwnerId, COMPANYNAME__c, COMPANYNAME_HOST__c, COMPANYCODE__c, COIAnnualGenerated__c, CGAnnualGenerated__c from pisusers__c 
                                            where User__c != null AND User__c IN: pisUserIds AND MAINPOSITION__c = true AND Active__c = true AND
                        					COIAnnualGenerated__c = false AND CGAnnualGenerated__c = false order by employeeid__c asc LIMIT 100];
            
        }
        
        if(PISUsers.size() > 0) {
            
            List<string> ReportTypes = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), 
                											String.ValueOf(CG_Enum.CGReportType.CGAnnual) };
            
            /* List<CG_Reporting__c> CGReports = [select id, isDisable__c from CG_Reporting__c where Type_Of_Report__c IN: ReportTypes AND Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) AND send_email__c = false];
            
            if(CGReports.size() > 0) {
                for(CG_Reporting__c CGReport : CGReports) {
                    CGReport.isDisable__c = true;
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
                }
                
                update(CGReports);
            } */
            
            //From CG Setting
            CG_Setting__c CGSetting = [select id, name, type__c, start_date__c, end_date__c from CG_Setting__c where RecordType.Name = 'Annual'];
            
            Id COIAnnualRTId = [select id, name from RecordType where name = 'CG COI Annual' AND sobjecttype = 'CG_Reporting__c'].Id;
        	Id CGAnnualRTId = [select id, name from RecordType where name = 'CG Manual Annual' AND sobjecttype = 'CG_Reporting__c'].Id;
        	
            List<User> Users = AllUsers();
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Annual'];
            
            //boolean isAnnualInDuration = CG_ReportingHandler.CGSettingDuration('Annual');
        	
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            
            //Running No
            CG_Config__c CGConfig = [select Year__c, COI_New_User_Running_No__c, COI_Incident_Running_No__c, COI_Annual_Running_No__c ,
                                     CG_New_User_Running_No__c, CG_Manual_Running_No__c, CG_Annual_Running_No__c, Gift_Running_No__c from CG_Config__c];
            
            //CustomNoti                            
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'CG_Notification'];

            //OppNotiApp
            OPP_Application__c CGApp = [select id, name from OPP_Application__c where Name =: 'CG Reporting'];

            List<Opp_Notification__c> OppNotis = new List<Opp_Notification__c>();
            
            integer count = 0;
            
            List<CG_Reporting__c> COIAnnualReports = new List<CG_Reporting__c>();
            List<CG_Reporting__c> CGAnnualReports = new List<CG_Reporting__c>();
            
            for(PISUsers__c PISUser : PISUsers) {
                count++;
                
                CG_Reporting__c CGReport = new CG_Reporting__c();
                
                //Insert COI Annual
                CGConfig = CG_ReportingHandler.GenerateRunningNo('COIAnnual', CGConfig);
                CGReport = CG_ReportingHandler.InsertCGReporting(PISUser, COIAnnualRTId, 'COIAnnual', CGSetting, CGConfig.COI_Annual_Running_No__c);
                COIAnnualReports.add(CGReport);
                
                //Insert CG Annual
                CGReport = new CG_Reporting__c();
                CGConfig = CG_ReportingHandler.GenerateRunningNo('CGAnnual', CGConfig);
                CGReport = CG_ReportingHandler.InsertCGReporting(PISUser, CGAnnualRTId, 'CGAnnual', CGSetting, CGConfig.CG_Annual_Running_No__c);
                CGAnnualReports.add(CGReport);
                
            }
            
            //Update Config
            database.update(CGConfig);
            
            //COIAnnualReports
            if(COIAnnualReports.size() > 0) {
                database.insert(COIAnnualReports, true);
            }
            
            //CGAnnualReports
            if(CGAnnualReports.size() > 0) {
                database.insert(CGAnnualReports, true);
            }
            
            //Update PISUser flag
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    PISUser.CGAnnualGenerated__c = true;
                    PISUser.COIAnnualGenerated__c = true;
                }
                
                database.update(PISUsers, true);
            }
        }
        
    }
    
    public static void SendEmailAndNotiForCOICGAnnual() {
        
        string status = 'WaitingForSubmit';
        List<string> typeOfReports = new List<string> {'COIAnnual', 'CGAnnual'};
        List<CG_Reporting__c> COIAnnuals = new List<CG_Reporting__c>();
        List<CG_Reporting__c> CGAnnuals = new List<CG_Reporting__c>();
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        //CustomNoti                            
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                                                   WHERE DeveloperName = 'CG_Notification'];

        //OppNotiApp
        OPP_Application__c CGApp = [select id, name from OPP_Application__c where Name =: 'CG Reporting'];
        List<Opp_Notification__c> OppNotis = new List<Opp_Notification__c>();
        
        //EmailTemplate
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Annual'];
            
        //All Users
        List<User> Users = AllUsers();
          
        Set<Id> PISUserIds = new Set<Id>();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        
        List<PISUsers__c> PISUsers = [select id, User__c, EN_Fullname__c, ENFIRSTNAME__c, ENLASTNAME__c, Email__c from PISUsers__c where Active__c = true AND Mainposition__c = true AND User__c != null
                                     AND COIAnnualGenerated__c = true AND CGAnnualGenerated__c = true AND COICGAnnualSendEmail__c = false order by employeeid__c asc LIMIT 100];
        
        if(PISUsers.size() > 0) {
            
            for(PISUsers__c PISUser : PISUsers) {
                PISUserIds.add(PISUser.User__c);
            }
            
            if(PISUserIds.size() > 0) {
                CGReports = [select id, OwnerId, Type_Of_Report__c, Running_No__c, Reported_By_EN__c from CG_Reporting__c where OwnerId IN :PISUserIds AND type_of_report__c IN :typeOfReports AND Send_Email__c = false AND status__c = :status order by running_no__c asc];
            
                if(CGReports.size() > 0) {
                    for(CG_Reporting__c CGReport : CGReports) {
                        if(CGReport.Type_of_Report__c == 'COIAnnual') {
                            COIAnnuals.add(CGReport);
                        }
                        else if(CGReport.Type_of_Report__c == 'CGAnnual') {
                            CGAnnuals.add(CGReport);
                        }
                    }
                }
            }
            
            for(PISUsers__c PISUser : PISUsers) {
                
                CG_Reporting__c existCOIAnnual = new CG_Reporting__c();
                CG_Reporting__c existCGAnnual = new CG_Reporting__c();
                
                //COIAnnuals
                for(CG_Reporting__c COIAnnual : COIAnnuals) {
                    if(COIAnnual.OwnerId == PISUser.User__c) {
                        
                        existCOIAnnual = COIAnnual;
                        
                        //BellNoti
                        string Title = 'Please report COI Annual Report';
                        string Body = 'Please submit your Conflict of Interest (Annual) : ' + COIAnnual.Running_No__c;
                        string PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + COIAnnual.Id + '&parent=coiReporting\'}}';
                        CG_DTO.BellNotiDTO BellNotiDTO = CG_ReportingHandler.GenerateBellNoti(COIAnnual, Title, Body, PageRef);
                        CG_NotiController.SendBellNoti(BellNotiDTO, notificationType);
                        
                        //OppNoti
                        string Subject = 'Please report COI Annual report';
                        string Description = 'Please submit your Conflict of Interest (Annual) : ' + COIAnnual.Running_No__c;
                        string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + COIAnnual.Id + '&parent=coiReporting';
                        CG_DTO.OppNotiDTO OppNotiDTO = CG_ReportingHandler.GenerateOppNoti(COIAnnual, CGApp, Subject, Description, URL);
                        OppNotis.add(CG_NotiController.SaveOppNoti(OppNotiDTO));
                    }
                }
                
                //CGAnnuals
                for(CG_Reporting__c CGAnnual : CGAnnuals) {
                    if(CGAnnual.OwnerId == PISUser.User__c) {
                        
                        existCGAnnual = CGAnnual;
                        
                        //BellNoti
                        string Title = 'Please acknowledge CG Annual';
                        string Body = 'Please submit your annual report for CG Manual Acknowledgement : ' + CGAnnual.Running_No__c;
                        string PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGAnnual.Id + '&parent=cgManualReporting\'}}';
                        CG_DTO.BellNotiDTO BellNotiDTO = CG_ReportingHandler.GenerateBellNoti(CGAnnual, Title, Body, PageRef);
                        CG_NotiController.SendBellNoti(BellNotiDTO, notificationType);
                        
                        //OppNoti
                        string Subject = 'Please acknowledge CG Annual';
                        string Description = 'Please submit your annual report for CG Manual Acknowledgement : ' + CGAnnual.Running_No__c;
                        string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGAnnual.Id + '&parent=cgManualReporting';
                        CG_DTO.OppNotiDTO OppNotiDTO = CG_ReportingHandler.GenerateOppNoti(CGAnnual, CGApp, Subject, Description, URL);
                        OppNotis.add(CG_NotiController.SaveOppNoti(OppNotiDTO));
                    }
                }
                
                Messaging.SingleEmailMessage sendEmail = CG_ReportingHandler.AnnualEmail(PISUser, existCOIAnnual, existCGAnnual, emailTemplate, Users);
                sendEmails.add(sendEmail);
            }
            
            if(sendEmails.size() > 0) {
                //Send All Email
                Messaging.sendEmail(sendEmails);
                
                //Insert Opp Notis
                if(OppNotis.size() > 0) {
                    database.insert(OppNotis, true);
                }
                
                //Update Send Email flag in CGReport
                for(CG_Reporting__c CGReport : CGReports) {
                    CGReport.Send_Email__c = true;
                }
                database.update(CGReports, true);
                
                //Update Send Email flag in PISUser
                for(PISUsers__c PISUser : PISUsers) {
                    PISUser.COICGAnnualSendEmail__c = true;
                }
                database.update(PISUsers, true);
            }
        }
        
    }
    
    //approverRole Supervisor or GLVP
    public static void COIMassAcknowledge(string approverRole) {
        
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual),
            									String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
        
        string status = '';
        
        if(approverRole == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
            status = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
        }
        else if(approverRole == String.ValueOf(CG_Enum.ApproverRole.GLVP)) {
            status = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
        }
                                                    
        List<CG_Reporting__c> CGReports = [select id, type_of_report__c, running_no__c, status__c, Supervisor_Approver_Status__c, User__c, OwnerId,
                                           Submitted_Date__c, status_json__c from CG_Reporting__c where type_of_report__c IN: RTs AND status__c =: status];
        
        SYstem.debug(CGReports.size());
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                              
                    //Send email to Supervisor for reminder
                    if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                    	CG_ReportingHandler.COIAnnualSupervisorEmail(CGReport.User__c, CGReport);
                    }
                    else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
            			CG_ReportingHandler.COINewEmployeeSupervisorEmail(CGReport.User__c, CGReport);
                    }
                    
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                    
                    //Send email to GLVP for reminder
                    List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
                    if(GLVPPISUsers.size() > 0) {
                        for(PISUsers__c GLVP : GLVPPISUsers) {
                            
                            CG_ReportingHandler.COIGLVPEmail(GLVP.User__c, CGReport);
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    public static void COIMassAcknowledgeCount(string approverRole) {
        
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual),
            									String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
        
        string status = '';
        
        if(approverRole == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
            status = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
        }
        else if(approverRole == String.ValueOf(CG_Enum.ApproverRole.GLVP)) {
            status = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
        }
              
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_Mass_Acknowledge'];
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
                                     
        List<CG_Reporting__c> CGReports = [select id, type_of_report__c, running_no__c, status__c, Supervisor_Approver_Status__c, User__c, OwnerId,
                                           Submitted_Date__c, status_json__c from CG_Reporting__c where type_of_report__c IN: RTs AND status__c =: status ];
        
        if(CGReports.size() > 0) {
            
            Set<Id> supervisorIds = new Set<Id>();
        	integer glvpReportCount = 0;
            
            for(CG_Reporting__c CGReport : CGReports) {
                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                    supervisorIds.add(CGReport.User__c);
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                    glvpReportCount++;
                }
            }
            
            //Supervisor
            if(supervisorIds.size() > 0) {
                for(Id supervisorId : supervisorIds) {
                    
                    integer reportCount = 0;
                    
                    for(CG_Reporting__c CGReport : CGReports) {
                        if(CGReport.User__c == supervisorId && CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                            reportCount++;
                        }
                    }
                    
                    if(reportCount > 0) {
                        Messaging.SingleEmailMessage sendEmail = CG_ReportingHandler.COIMassAcknowledgeEmail(approverRole, emailTemplate, supervisorId, reportCount);   
                        sendEmails.add(sendEmail);
                    }
                }
            }
            
            //GLVP
            if(glvpReportCount > 0) {
                List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
                if(GLVPPISUsers.size() > 0) {
                    for(PISUsers__c GLVP : GLVPPISUsers) {
                        Messaging.SingleEmailMessage sendEmail = CG_ReportingHandler.COIMassAcknowledgeEmail(approverRole, emailTemplate, GLVP.User__c, glvpReportCount);   
                        sendEmails.add(sendEmail);
                    }
                }
            }
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
            
        }
    }
    
    public static void AnnualResend() {
        
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual),
            									String.ValueOf(CG_Enum.CGReportType.CGAnnual) };
        
        string status = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
        
        List<CG_Reporting__c> CGReports = [select id, status__c, ownerId, type_of_report__c, annualresendemail__c from CG_Reporting__c where type_of_report__c IN: RTs AND status__c =: status AND annualresendemail__c = false LIMIT 200];

        List<User> Users = AllUsers();
        
        boolean isAnnualInDuration = CG_ReportingHandler.CGSettingDuration('Resend Annual');
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        Set<Id> OwnerIds = new Set<Id>();
        
        if(CGReports.size() > 0) {
            
            for(CG_Reporting__c CGReport : CGReports) {
                OwnerIds.add(CGReport.OwnerId);
            }

			Map<string,PISUsers__c> pisUsers = CG_Global.assignAllToMapPISUsers();
            
            EmailTemplate emailTemplateAnnual = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Annual'];
            EmailTemplate emailTemplateCOI = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_Annual'];
            EmailTemplate emailTemplateCG = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CG_Annual'];
                    
            for(Id OwnerId : OwnerIds) {
                
                PISUsers__c PISUser = pisUsers.get(OwnerId);
                
                if(PISUser != null) {
                    boolean isCOIAnnual = false;
                    boolean isCGAnnual = false;
                    
                    CG_Reporting__c COIAnnualReport = new CG_Reporting__c();
                    CG_Reporting__c CGAnnualReport = new CG_Reporting__c();
                    
                    for(CG_Reporting__c CGReport : CGReports) {
                        if(CGReport.OwnerId == OwnerId && CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                            isCOIAnnual = true;
                            COIAnnualReport = CGReport;
                            CGReport.annualresendemail__c = true;
                        }
                        else if(CGReport.OwnerId == OwnerId && CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
                            isCGAnnual = true;
                            CGAnnualReport = CGReport;
                            CGReport.annualresendemail__c = true;
                        }
                    }
                    
                    if(isAnnualInDuration) {
                        Messaging.SingleEmailMessage sendEmail = new Messaging.SingleEmailMessage();
                        //Send email to user
                        if(isCOIAnnual && isCGAnnual) {
                            sendEmail = CG_ReportingHandler.AnnualEmail(PISUser, COIAnnualReport, CGAnnualReport, emailTemplateAnnual, Users);
                            sendEmails.add(sendEmail);
                        }
                        else if(isCOIAnnual && !isCGAnnual) {
                            sendEmail = CG_ReportingHandler.COIAnnualEmail(PISUser, COIAnnualReport, emailTemplateCOI, Users);
                            sendEmails.add(sendEmail);
                        }
                        else if(!isCOIAnnual && isCGAnnual) {
                            sendEmail = CG_ReportingHandler.CGAnnualEmail(PISUser, CGAnnualReport, emailTemplateCG, Users);
                            sendEmails.add(sendEmail);
                        }
                        
                    }
                }
            }
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
            
            if(isAnnualInDuration) {
                //Update Duration in CG Setting
                CG_ReportingHandler.CGSettingSaveDuration('Resend Annual');
            }
            
            //Update AnnualResendEmail flag in CG Report
            database.update(CGReports,true);
        }        
                                                    
    }
    
    public static void AnnualResendManual(integer queryLimit) {
        
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual),
            									String.ValueOf(CG_Enum.CGReportType.CGAnnual) };
        
        string status = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
        
        List<CG_Reporting__c> CGReports = [select id, status__c, ownerId, type_of_report__c, annualresendemail__c from CG_Reporting__c where type_of_report__c IN: RTs AND status__c =: status AND annualresendemail__c = false order by owner.name asc LIMIT :queryLimit];

        List<User> Users = AllUsers();
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        Set<Id> OwnerIds = new Set<Id>();
        
        if(CGReports.size() > 0) {
            
            for(CG_Reporting__c CGReport : CGReports) {
                OwnerIds.add(CGReport.OwnerId);
            }

			Map<string,PISUsers__c> pisUsers = CG_Global.assignAllToMapPISUsers();
            
            EmailTemplate emailTemplateAnnual = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Annual'];
            EmailTemplate emailTemplateCOI = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_Annual'];
            EmailTemplate emailTemplateCG = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CG_Annual'];
                    
            for(Id OwnerId : OwnerIds) {
                
                PISUsers__c PISUser = pisUsers.get(OwnerId);
                
                if(PISUser != null) {
                    
                    boolean isCOIAnnual = false;
                    boolean isCGAnnual = false;
                    
                    CG_Reporting__c COIAnnualReport = new CG_Reporting__c();
                    CG_Reporting__c CGAnnualReport = new CG_Reporting__c();
                    
                    for(CG_Reporting__c CGReport : CGReports) {
                        if(CGReport.OwnerId == OwnerId && CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                            isCOIAnnual = true;
                            COIAnnualReport = CGReport;
                            CGReport.AnnualResendEmail__c = true;
                        }
                        else if(CGReport.OwnerId == OwnerId && CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
                            isCGAnnual = true;
                            CGAnnualReport = CGReport;
                            CGReport.AnnualResendEmail__c = true;
                        }
                    }
                    
                    Messaging.SingleEmailMessage sendEmail = new Messaging.SingleEmailMessage();
                
                    //Send email to user
                    if(isCOIAnnual && isCGAnnual) {                        
                        sendEmail = CG_ReportingHandler.AnnualEmail(PISUser, COIAnnualReport, CGAnnualReport, emailTemplateAnnual, Users);
                        sendEmails.add(sendEmail);
                    }
                    else if(isCOIAnnual && !isCGAnnual) {
                        
                        sendEmail = CG_ReportingHandler.COIAnnualEmail(PISUser, COIAnnualReport, emailTemplateCOI, Users);
                        sendEmails.add(sendEmail);
                    }
                    else if(!isCOIAnnual && isCGAnnual) {
                        
                        sendEmail = CG_ReportingHandler.CGAnnualEmail(PISUser, CGAnnualReport, emailTemplateCG, Users);
                        sendEmails.add(sendEmail);
                    }
                }
            }
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
            
            //Update AnnualResendEmail flag
            database.update(CGReports, true);
        }        
                                                    
    }
    
    //COI
    public static void DeleteCOIAnnualReport() {
        
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual)};
                                               
        List<CG_Reporting__c> CGReports = [select id from CG_Reporting__c where Type_Of_Report__c IN: RTs];
        
        if(CGReports.size() > 0) {
            delete(CGReports);
        }
        
    }    
    
    public static void DeleteCOIIncidentReport() {
        
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIIncident) };
                              
        List<CG_Reporting__c> CGReports = [select id from CG_Reporting__c where Type_Of_Report__c IN: RTs];
        
        if(CGReports.size() > 0) {
            delete(CGReports);
        }
        
    }    
    
    public static void DeleteCOINewEmployeeReport() {
        
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
                                                      
        List<CG_Reporting__c> CGReports = [select id from CG_Reporting__c where Type_Of_Report__c IN: RTs];
        
        if(CGReports.size() > 0) {
            delete(CGReports);
        }
        
    }    

	//CG    
    public static void DeleteCGNewEmployeeReport() {
        
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) };
                                    
        List<CG_Reporting__c> CGReports = [select id from CG_Reporting__c where Type_Of_Report__c IN: RTs];
        
        if(CGReports.size() > 0) {
            delete(CGReports);
        }
        
    }    
        
    public static void DeleteCGAnnaulReport() {
        
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGAnnual) };
                                                        
        List<CG_Reporting__c> CGReports = [select id from CG_Reporting__c where Type_Of_Report__c IN: RTs];
        
        if(CGReports.size() > 0) {
            delete(CGReports);
        }
        
    }    
    
    public static void DeleteCGManualReport() {
        
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGManual) };
                                                                
        List<CG_Reporting__c> CGReports = [select id from CG_Reporting__c where Type_Of_Report__c IN: RTs];
        
        if(CGReports.size() > 0) {
            delete(CGReports);
        }
        
    }    
    
    //Gift
    public static void DeleteGiftReport() {
        
        List<string> RTs = new List<string> { 'GiftRegistration' };
           
        List<CG_Reporting__c> CGReports = [select id from CG_Reporting__c where Type_Of_Report__c IN: RTs];
        
        if(CGReports.size() > 0) {
            delete(CGReports);
        }
        
    }   
    
    //All
    public static void DeleteAllReport() {
        
        List<CG_Reporting__c> CGReports = [select id from CG_Reporting__c];
        
        if(CGReports.size() > 0) {
            delete(CGReports);
            
            List<CG_Setting__c> CGSettings = [select id, duration_json__c from CG_Setting__c];
            
            if(CGSettings.size() > 0) {
                for(CG_Setting__c CGSetting : CGSettings) {
                    CGSetting.Duration_JSON__c = '';
                }
                
                update(CGSettings);
            }
        }
        
    }     
    
    //Reset All CG Setting
    public static void ResetCGSetting() {
        
        List<CG_Setting__c> CGSettings = new List<CG_Setting__c>();
        string query = 'select id, start_date__c, end_date__c, duration_json__c from cg_setting__c';
        
        CGSettings = database.query(query);
        
        if(CGSettings.size() > 0) {
            for(CG_Setting__c CGSetting : CGSettings) {
                CGSetting.Start_Date__c = null;
                CGSetting.End_Date__c = null;
                CGSetting.Duration_JSON__c = null;
            }
            
            update(CGSettings);
            
            //Reset in CG Setting Items as well
            List<CG_Setting_Items__c> CGSettingItems = [select start_date__c, end_date__c from CG_Setting_Items__c];
            
            if(CGSettingItems.size() > 0) {
                delete(CGSettingItems);
            }
        }
        
    }
    
    //Expire All CG Report in Previous Year
    public static void ExpirePreviousYearCGReport() {
        
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit),
        												String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor),
        												String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP), 
        												String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC) };
    
    	Date SD = Date.newInstance( date.today().year(), 1, 1 );
    	Date ED = Date.newInstance( date.today().year(), 12, 31 );
                                                                
    	string query = 'select id, start_duration__c, status__c, isDisable__c from CG_Reporting__c where status__c IN: statuses AND ' +
        					'start_duration__c >=: SD AND start_duration__c <=: ED';
    
        CGReports = database.query(query);
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                CGReport.isDisable__c = true;
                CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Expired);
            }
            
            database.update(CGReports,false);
        }
        
    }
    
    //Delete Duration JSON in CG Setting
    //CGAnnual , ResendAnnual, COIMassAcknowledge, COIAnnual, CGEmployee, CGManual, Annual
    public static void DeleteDurationJSON(string cgSettingType) {
        
        CG_Setting__c CGSetting = [select id, name, duration_json__c from CG_Setting__c where type__c =: cgSettingType];
        CGSetting.Duration_JSON__c = '';
        update(CGSetting);
        
        List<CG_Setting_Items__c> CGSettingItems = [select id, CG_Setting__c from CG_Setting_Items__c where CG_Setting__c =: CGSetting.Id];
        
        if(CGSettingItems.size() > 0) {
            delete(CGSettingItems);
        }
        
    }
    
    //COI Send Email Reminder to User for End Duration
    public static void EndDurationCOIReminder() {
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_New_Employee_User'];

        List<User> Users = AllUsers();
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)};
    
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
        
    	Date currentDate = Date.newInstance( date.today().year(), date.today().month(), date.today().day() );
                                                                
    	string query = 'select id, Running_No__c, type_of_report__c, end_duration__c, status__c, OwnerId from CG_Reporting__c where status__c IN: statuses AND ' +
        					'end_duration__c =: currentDate AND type_of_report__c IN: RTs';
    
        CGReports = database.query(query);
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                Messaging.SingleEmailMessage sendEmail = CG_ReportingHandler.COINewEmployeeEmail(CGReport.OwnerId, CGReport, emailTemplate, Users);
                sendEmails.add(sendEmail);
            }
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
        }
        
    }
    
    //CG Send Email Reminder to User for End Duration
    public static void EndDurationCGReminder() {
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CG_New_Employee_User'];
            
        List<User> Users = AllUsers();
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)};
    
        List<string> RTs = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) };
        
    	Date currentDate = Date.newInstance( date.today().year(), date.today().month(), date.today().day() );
                                                                
    	string query = 'select id, Running_No__c, end_duration__c, status__c, type_of_report__c, OwnerId, start_duration__c from CG_Reporting__c where status__c IN: statuses AND ' +
        					'end_duration__c =: currentDate AND type_of_report__c IN: RTs';
    
        CGReports = database.query(query);
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                Messaging.SingleEmailMessage sendEmail = CG_ReportingHandler.CGNewEmployeeEmail(CGReport.OwnerId, CGReport, emailTemplate, Users);
                sendEmails.add(sendEmail);
            }
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
        }
        
    }
    
    public static void FixedLineManagerInReporting() {
        
        List<string> typeOfReports = new List<string> {
            CG_Enum.COIReportType.COIAnnual.name(), 
            CG_Enum.COIReportType.COINewEmployee.name(),
            CG_Enum.COIReportType.COIIncident.name()};
        
        List<string> statuses = new List<string> {
            CG_Enum.ReportStatus.WaitingForSubmit.name(),       
            CG_Enum.ReportStatus.WaitingSupervisor.name()};
        
        Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
        Map<string, PISUsers__c> mapUserIdPISUsers = new Map<string, PISUsers__c>();
        List<PISUsers__c> PISUsers = [select id, name, user__c, linemanageruser__c, employeeid__c from PISUsers__c where active__c = true AND mainposition__c = true AND user__c != null order by name asc];
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                mapPISUsers.put(PISUser.EMPLOYEEID__c, PISUser);
                mapUserIdPISUsers.put(PISUser.User__c, PISUser);
            }
        }        
        
        List<CG_Reporting__c> CGReports = [select id, user__c, status__c, type_of_report__c, debug_log__c, Employee_Id__c from CG_Reporting__c where type_of_report__c IN :typeOfReports AND status__c IN :statuses];
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                PISUsers__c Supervisor = mapPISUsers.get(CGReport.Employee_Id__c);
                CGReport.Debug_Log__c = '';
                if(Supervisor != null) {
                    if(Supervisor.LineManagerUser__c != null) {
                        PISUsers__c oldSupervisor = mapUserIdPISUsers.get(CGReport.User__c);
                        CGReport.Debug_Log__c += oldSupervisor.Name; //Old Supervisor
                        CGReport.User__c = Supervisor.LineManagerUser__c;
                        PISUsers__c newSupervisor = mapUserIdPISUsers.get(Supervisor.LineManagerUser__c);
                        CGReport.Debug_Log__c += ' > ' + newSupervisor.Name; //New Supervisor
                    }
                }
            }
            
            update(CGReports);
        }
        
    }
    
    public static List<User> AllUsers() {
        
    	List<User> Users = [select id, email, firstname, lastname from User];
        
        return Users;
    }
    
}