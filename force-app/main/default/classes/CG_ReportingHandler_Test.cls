@isTest
public class CG_ReportingHandler_Test {

    public static testMethod void CGReportingHandlerTest() {
        
        List<User> Users = new List<User>();
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com.icr',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        Users.add(testUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'VP';
        thaninthon.ORGID__c = '00000818';
        thaninthon.POSID__c = '00000544';
        thaninthon.ENFIRSTNAME__c = 'Test';
        thaninthon.ENLASTNAME__c = 'Test';
        thaninthon.HOLDERPOSITION__c = '00000544';
        thaninthon.EMAIL__c = 'test@thaioilgroup.com';
        thaninthon.User__c = testUser.Id;
        thaninthon.ReportToPOS__c = '00001365';
        thaninthon.ReportToID__c = '00000598';
        thaninthon.ReportToEmail__c = 'test@thaioilgroup.com';
        thaninthon.ReportToUser__c = testUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        thaninthon.LineManagerUser__c = testUser.Id;
        thaninthon.FUNCTION__c = 'EVPC';
        thaninthon.DEPARTMENT__c = 'EVPO';
        thaninthon.SECTIONS__c = 'SCSE';
        thaninthon.UNITS__c = 'ABCD';
        insert(thaninthon);
        
        //Insert Opp Noti
        OPP_Application__c App = new OPP_Application__c();
        App.Name = 'CG Reporting';
        insert(App);
        
        string COINewEmployeeRTId;
        string COIAnnualRTId;
        List<RecordType> CGReportingRTs = [select id, developername from RecordType where sobjectType = 'CG_Reporting__c'];
        
        for(RecordType CGReportRT : CGReportingRTs) {
            if(CGReportRT.DeveloperName == 'CG_COI_New_Employee') {
                COINewEmployeeRTId = CGReportRT.Id;
            }
            else if(CGReportRT.DeveloperName == 'CG_COI_Annual') {
                COIAnnualRTId = CGReportRT.Id;
            }
        }
        
        EmailTemplate COINewEmployeeTemplate = new EmailTemplate();
        List<EmailTemplate> EmailTemplates = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate ];
        
        for(EmailTemplate ET : EmailTemplates) {
            if(ET.developername == 'COI_New_Employee_User') {
                COINewEmployeeTemplate = ET;
            }
        }
        
        
        Test.startTest();  
        
        System.runAs(testUser) {
            
            CG_Config__c CGConfig = new CG_Config__c();
            CGConfig.Year__c = '2022';
            CGConfig.COI_New_User_Running_No__c = '0';
            CGConfig.COI_Incident_Running_No__c = '0';
            CGConfig.COI_Annual_Running_No__c = '0';
            CGConfig.CG_New_User_Running_No__c = '0';
            CGConfig.CG_Manual_Running_No__c = '0';
            CGConfig.CG_Annual_Running_No__c = '0';
            CGConfig.Gift_Running_No__c = '0';
            insert(CGConfig);
                
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.OwnerId = testUser.Id;
            CGReporting.Start_Duration__c = date.today().addDays(-1);
            CGReporting.End_Duration__c = date.today().addDays(1);
            CGReporting.Submitted_Date__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIIncident);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":null}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            CGReporting.Supervisor_Action_Date__c = date.today();
            CGReporting.GLGC_Action_Date__c = date.today();
            CGReporting.GLVP_Action_Date__c = date.today();
            insert(CGReporting);
            CGReports.add(CGReporting);
            
            RecordType RT = [select id, developername from RecordType where sobjectType = 'CG_Setting__c' AND developerName = 'Annual'];
            CG_Setting__c CGSetting = new CG_Setting__c();
            CGSetting.Type__c = 'Annual';
            CGSetting.RecordTypeId = RT.Id;
            CGSetting.Start_Date__c = system.Datetime.now().addDays(1);
            CGSetting.End_Date__c = system.Datetime.now().addDays(2);
            CGSetting.Duration_JSON__c = '[{"startDate":"2022-10-10T17:45:00.000Z","endDate":"2022-10-17T13:15:00.000Z"}]';
            insert(CGSetting);
            
            CG_Setting_Items__c CGSettingItem = new CG_Setting_Items__c();
            CGSettingItem.CG_Setting__c = CGSetting.Id;
            CGSettingItem.Start_Date__c = system.Datetime.now().addDays(1);
            CGSettingItem.End_Date__c = system.Datetime.now().addDays(2);
            insert(CGSettingItem);
            
            RecordType COIMassRT = [select id, developername from RecordType where sobjectType = 'CG_Setting__c' AND developerName = 'COI_Mass'];
            CG_Setting__c CGSettingCOIMass = new CG_Setting__c();
            CGSettingCOIMass.Type__c = String.ValueOf('COIMassAcknowledge');
            CGSettingCOIMass.RecordTypeId = COIMassRT.Id;
            CGSettingCOIMass.Start_Date__c = system.Datetime.now().addDays(1);
            CGSettingCOIMass.End_Date__c = system.Datetime.now().addDays(2);
            CGSettingCOIMass.Duration_JSON__c = '[{"startDate":"2022-10-10T17:45:00.000Z","endDate":"2022-10-17T13:15:00.000Z"}]';
            insert(CGSettingCOIMass);
            
            CG_Setting_Items__c CGSettingItemCOIMass = new CG_Setting_Items__c();
            CGSettingItemCOIMass.CG_Setting__c = CGSettingCOIMass.Id;
            CGSettingItemCOIMass.Start_Date__c = system.Datetime.now().addDays(1);
            CGSettingItemCOIMass.End_Date__c = system.Datetime.now().addDays(2);
            insert(CGSettingItemCOIMass);
            
            
            RecordType ResendAnnualRT = [select id, developername from RecordType where sobjectType = 'CG_Setting__c' AND developerName = 'Resend_Annual'];
            
            CG_Setting__c CGSettingResendAnnual = new CG_Setting__c();
            CGSettingResendAnnual.Type__c = String.ValueOf('ResendAnnual');
            CGSettingResendAnnual.RecordTypeId = ResendAnnualRT.Id;
            CGSettingResendAnnual.Start_Date__c = system.Datetime.now().addDays(1);
            CGSettingResendAnnual.End_Date__c = system.Datetime.now().addDays(2);
            CGSettingResendAnnual.Duration_JSON__c = '[{"startDate":"2022-10-10T17:45:00.000Z","endDate":"2022-10-17T13:15:00.000Z"}]';
            insert(CGSettingResendAnnual);
            
            CG_Setting_Items__c CGSettingItemResendAnnual = new CG_Setting_Items__c();
            CGSettingItemResendAnnual.CG_Setting__c = CGSettingResendAnnual.Id;
            CGSettingItemResendAnnual.Start_Date__c = system.Datetime.now().addDays(1);
            CGSettingItemResendAnnual.End_Date__c = system.Datetime.now().addDays(2);
            insert(CGSettingItemResendAnnual);
            
            CG_ReportingHandler.CGSettingDuration('Annual');
            CG_ReportingHandler.CGSettingSaveDuration('Annual');
            
            //CustomNoti                            
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'CG_Notification'];

            //OppNotiApp
            OPP_Application__c CGApp = [select id, name from OPP_Application__c where Name =: 'CG Reporting'];

            CG_ReportingHandler.COI_New_Employee(thaninthon, COINewEmployeeRTId, COINewEmployeeTemplate, Users, CGConfig.COI_New_User_Running_No__c, notificationType, CGApp);
            CG_ReportingHandler.COI_Annual(thaninthon, COIAnnualRTId, COINewEmployeeTemplate, CGSetting, Users, CGConfig.COI_Annual_Running_No__c);
            CG_ReportingHandler.CG_Manual_New_Employee(thaninthon, COIAnnualRTId, COINewEmployeeTemplate, CGSetting, Users, CGConfig.CG_New_User_Running_No__c, notificationType, CGApp);
            CG_ReportingHandler.CG_Manual_Annual(thaninthon, COIAnnualRTId, COINewEmployeeTemplate, CGSetting, Users, CGConfig.CG_Annual_Running_No__c);
            CG_ReportingHandler.CG_Manual(thaninthon, COIAnnualRTId, COINewEmployeeTemplate, CGSetting, Users, CGConfig.CG_Manual_Running_No__c, notificationType, CGApp);
            CG_ReportingHandler.Annual(thaninthon, COIAnnualRTId, COIAnnualRTId, COINewEmployeeTemplate, CGSetting, Users, CGConfig, notificationType, CGApp);
            CG_ReportingHandler.COI_Incident(thaninthon, CGReporting);
            CG_ReportingHandler.GiftRegistration(thaninthon, CGReporting);
            CG_ReportingHandler.COIReminderEmail(testUser.Id, CGReporting);
            CG_ReportingHandler.COINewEmployeeSupervisorEmail(testUser.Id, CGReporting);
            CG_ReportingHandler.COIIncidentSupervisorEmail(testUser.Id, CGReporting);
            CG_ReportingHandler.COIAnnualSupervisorEmail(testUser.Id, CGReporting);
            CG_ReportingHandler.COIUserRejectedEmail(testUser.Id, CGReporting);
            CG_ReportingHandler.COIMassAcknowledgeEmail('Supervisor', COINewEmployeeTemplate, testUser.Id, 10);
            CG_ReportingHandler.COIGLVPEmail(testUser.Id, CGReporting);
            CG_ReportingHandler.CGReminderEmail(testUser.Id, CGReporting);
            CG_ReportingHandler.AnnualReminderEmail(testUser.Id, true, true, CGReporting, CGReporting, COINewEmployeeTemplate, Users);
            CG_ReportingHandler.GiftRegistrationSupervisorEmail(testUser.Id, CGReporting);
            CG_ReportingHandler.GiftRegistrationGLGCEmail(testUser.Id, CGReporting);
            CG_ReportingHandler.GiftRegistrationGLVPEmail(testUser.Id, CGReporting);
            
            CG_ReportingHandler.CGReportingStatuses();
            CG_ReportingHandler.CGReportingTypes();
            CG_ReportingHandler.CGReportingCOIDisclosure();
            
            List<CG_Setting__c> CGSettings = new List<CG_Setting__c>();
            CGSettings.add(CGSettingResendAnnual);
            
            CG_SettingHandler SettingHandler = new CG_SettingHandler();
            SettingHandler.CreateAndDeleteJobSchedule(CGSettings);
            
            update(CGReporting);
            delete(CGReporting);
            
            update(CGSetting);
            update(CGSettingItem);
            delete(CGSetting);
            delete(CGSettingItem);
            
        }
        
        
    }
    
}