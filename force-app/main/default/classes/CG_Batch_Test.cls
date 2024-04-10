@isTest
public class CG_Batch_Test {

    public static String CRON_EXP = '0 0 0 * * ? *';
    
    public static PISUsers__c InsertPISUser() {
        
        User TestUser1 = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'Test',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(TestUser1);
        
        InsertUserToGroup(TestUser1.Id);
        
        User TestUser2 = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'Test2',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(TestUser2);
        
        PISUsers__c PISUser = new PISUsers__c();
        PISUser.Active__c = true;
        PISUser.MAINPOSITION__c = true;
        PISUser.New_Employee__c = true;
        PISUser.EMPLOYEEID__c = '00000001';
        PISUser.New_Employee__c = true;
        PISUser.LEVEL__c = 'VP';
        PISUser.OBJENFULLNAME__c = 'TEST OBJ EN';
        PISUser.OBJTHFULLNAME__c = 'TEST OBJ TH';
        PISUser.THTITLE__c = 'นาย';
        PISUser.THFIRSTNAME__c = 'ชื่อ';
        PISUser.THLASTNAME__c = 'นามสกุล';
        PISUser.ENFIRSTNAME__c = 'FirstName';
        PISUser.ENLASTNAME__c = 'LastName';
        PISUser.EMAIL__c = 'test@thaioilgroup.com';
        PISUser.Name = 'TEST1';
        PISUser.User__c = TestUser1.Id;
        
        PISUser.ReportToName__c = 'Test 2';
        PISUser.ReportToEmail__c = 'test2@thaioilgroup.com';
        PISUser.ReportToID__c = TestUser2.Id;
        insert(PISUser);

        return PISUser;
    }
    
    public static testMethod void COINewEmployeeTest() {
        
        Test.startTest();
        
    	PISUsers__c PISUser = CG_Batch_Test.InsertPISUser();   
        
        //Insert Opp Noti
        OPP_Application__c App = new OPP_Application__c();
        App.Name = 'CG Reporting';
        insert(App);
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        // Schedule the test job
        String jobId = System.schedule('COI New Employee',
                                       CRON_EXP, 
                                       new CG_COINewEmployeeSchedule());     
        Test.stopTest();
        
    }
    
    public static testMethod void ManualCOINewEmployeeTest() {
        
        Test.startTest();
        
    	PISUsers__c PISUser = CG_Batch_Test.InsertPISUser();   
        
        //Insert Opp Noti
        OPP_Application__c App = new OPP_Application__c();
        App.Name = 'CG Reporting';
        insert(App);
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        Set<string> PISIds = new Set<string>();
        PISIds.add(PISUser.Id);
        CG_Batch.ManualCOINewEmployee(PISIds);
        
        Test.stopTest();
        
    }
    
    public static testMethod void COIAnnualTest() {
        
        Test.startTest();
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'COI Annual' AND sobjectType = 'CG_Setting__c'];
        
    	PISUsers__c PISUser = CG_Batch_Test.InsertPISUser();   
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = date.today();
        CGSetting.End_Date__c = date.today();
        CGSetting.Type__c = 'COIAnnual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        // Schedule the test job
        String jobId = System.schedule('CG COI Annual',
                                       CRON_EXP, 
                                       new CG_COIAnnualSchedule()); 
        
        Test.stopTest();
        
    }
    
    public static testMethod void CGAnnualTest() {
        
        Test.startTest();
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'CG Annual' AND sobjectType = 'CG_Setting__c'];
        
    	PISUsers__c PISUser = CG_Batch_Test.InsertPISUser();   
        
        //Insert Opp Noti
        OPP_Application__c App = new OPP_Application__c();
        App.Name = 'CG Reporting';
        insert(App);
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = date.today();
        CGSetting.End_Date__c = date.today();
        CGSetting.Type__c = 'CGAnnual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        // Schedule the test job
        String jobId = System.schedule('CG Annual',
                                       CRON_EXP, 
                                       new CG_CGAnnualSchedule());     
        Test.stopTest();
        
    }
    
    public static testMethod void CGNewEmployeeTest() {
        
        Test.startTest();
        
        //Insert Opp Noti
        OPP_Application__c App = new OPP_Application__c();
        App.Name = 'CG Reporting';
        insert(App);
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'CG New Employee' AND sobjectType = 'CG_Setting__c'];
        
    	PISUsers__c PISUser = CG_Batch_Test.InsertPISUser();   
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = date.today();
        CGSetting.End_Date__c = date.today();
        CGSetting.Type__c = 'CGNewEmployee';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        // Schedule the test job
        String jobId = System.schedule('CG New Employee',
                                       CRON_EXP, 
                                       new CG_CGNewEmployeeSchedule());     
        Test.stopTest();
        
    }
    
    public static testMethod void ManualCGNewEmployeeTest() {
        
        Test.startTest();
        
        //Insert Opp Noti
        OPP_Application__c App = new OPP_Application__c();
        App.Name = 'CG Reporting';
        insert(App);
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'CG New Employee' AND sobjectType = 'CG_Setting__c'];
        
    	PISUsers__c PISUser = CG_Batch_Test.InsertPISUser();   
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = date.today();
        CGSetting.End_Date__c = date.today();
        CGSetting.Type__c = 'CGNewEmployee';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        Set<string> PISIds = new Set<string>();
        PISIds.add(PISUser.Id);
        CG_Batch.ManualCGNewEmployee(PISIds);
        
        Test.stopTest();
        
    }
    
    public static testMethod void CGManualTest() {
        
        Test.startTest();
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'CG Manual' AND sobjectType = 'CG_Setting__c'];
        
    	PISUsers__c PISUser = CG_Batch_Test.InsertPISUser();   
        
        //Insert Opp Noti
        OPP_Application__c App = new OPP_Application__c();
        App.Name = 'CG Reporting';
        insert(App);
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = date.today();
        CGSetting.End_Date__c = date.today();
        CGSetting.Type__c = 'CGManual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        // Schedule the test job
        String jobId = System.schedule('CG Manual',
                                       CRON_EXP, 
                                       new CG_CGManualSchedule());     
        Test.stopTest();
        
    }
    
    public static testMethod void COICGAnnualTest() {
        
        Test.startTest();
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'Annual' AND sobjectType = 'CG_Setting__c'];
        
    	PISUsers__c PISUser = CG_Batch_Test.InsertPISUser();   
        
        //Insert Opp Noti
        OPP_Application__c App = new OPP_Application__c();
        App.Name = 'CG Reporting';
        insert(App);
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = date.today();
        CGSetting.End_Date__c = date.today();
        CGSetting.Type__c = 'Annual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        // Schedule the test job
        String jobId = System.schedule('COICG Annual',
                                       CRON_EXP, 
                                       new CG_COICGAnnualSchedule());  
        
        Test.stopTest();
        
    }
    
    public static testMethod void COIMassAcknowledgeTest() {
        
        Test.startTest();
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'Annual' AND sobjectType = 'CG_Setting__c'];
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = date.today();
        CGSetting.End_Date__c = date.today();
        CGSetting.Type__c = 'Annual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'Junior';
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
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
            
        System.runAs(testUser) {
            
        InsertUserToGroup(TestUser.Id);
        
            //Insert Opp Noti
            OPP_Application__c App = new OPP_Application__c();
            App.Name = 'CG Reporting';
            insert(App);
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            CGReporting.GLVP_Id__c = testUser.Id;
            insert(CGReporting);
            
        }
        
        // Schedule the test job
        String jobId = System.schedule('COIMassAcknowledge',
                                       CRON_EXP, 
                                       new CG_COIMassAcknowledgeSchedule());     
        Test.stopTest();
        
        CG_Batch.EndDurationCOIReminder();
        
    }
    
    public static testMethod void ResendAnnualTest() {
        
        Test.startTest();
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'Resend Annual' AND sobjectType = 'CG_Setting__c'];
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Type__c = 'ResendAnnual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        CG_Setting_Items__c CGSettingItem = new CG_Setting_Items__c();
        CGSettingItem.Start_Date__c = date.today();
        CGSettingItem.CG_Setting__c = CGSetting.Id;
        insert(CGSettingItem);
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'Junior';
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
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
            
        InsertUserToGroup(TestUser.Id);
        
        System.runAs(testUser) {
            
            //Insert Opp Noti
            OPP_Application__c App = new OPP_Application__c();
            App.Name = 'CG Reporting';
            insert(App);
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIAnnual);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            insert(CGReporting);
            
        }
        
        // Schedule the test job
        String jobId = System.schedule('ResendAnnual',
                                       CRON_EXP, 
                                       new CG_ResendAnnualSchedule());     
        Test.stopTest();
        
    }
    
    public static testMethod void ApproveRoleSupervisor() {
        
        Test.startTest();
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'Annual' AND sobjectType = 'CG_Setting__c'];
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = date.today();
        CGSetting.End_Date__c = date.today();
        CGSetting.Type__c = 'Annual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'Junior';
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
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
            
        InsertUserToGroup(TestUser.Id);
        
        System.runAs(testUser) {
            
            //Insert Opp Noti
            OPP_Application__c App = new OPP_Application__c();
            App.Name = 'CG Reporting';
            insert(App);
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            CGReporting.Submitted_Date__c = date.today();
            insert(CGReporting);
            
        }
        
        CG_Batch.FixedLineManagerInReporting();
        CG_Batch.COIMassAcknowledge('Supervisor');
        CG_Batch.COIMassAcknowledgeCount('Supervisor');
        CG_Batch.ResetCGSetting();
        
        Test.stopTest();
        
        
    }
    
    public static testMethod void ApproveRoleGLVP() {
        
        Test.startTest();
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'Annual' AND sobjectType = 'CG_Setting__c'];
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = date.today();
        CGSetting.End_Date__c = date.today();
        CGSetting.Type__c = 'Annual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'Junior';
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
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
            
        InsertUserToGroup(TestUser.Id);
        
        System.runAs(testUser) {
            
            //Insert Opp Noti
            OPP_Application__c App = new OPP_Application__c();
            App.Name = 'CG Reporting';
            insert(App);
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            CGReporting.Submitted_Date__c = date.today();
            insert(CGReporting);
            
        }
        
        CG_Batch.COIMassAcknowledge('GLVP');
        CG_Batch.COIMassAcknowledgeCount('GLVP');
        
        Test.stopTest();
        
    }
    
    public static testMethod void AnnualResend() {
        
        Test.startTest();
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'Resend Annual' AND sobjectType = 'CG_Setting__c'];
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        //CGSetting.Start_Date__c = date.today().addDays(-1);
        //CGSetting.End_Date__c = date.today().addDays(1);
        CGSetting.Type__c = 'ResendAnnual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        CG_Setting_Items__c CGSettingItem = new CG_Setting_Items__c();
        CGSettingItem.Start_Date__c = date.today();
        CGSettingItem.CG_Setting__c = CGSetting.Id;
        insert(CGSettingItem);
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'Junior';
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
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
            
        InsertUserToGroup(TestUser.Id);
        
        System.runAs(testUser) {
            
            //Insert Opp Noti
            OPP_Application__c App = new OPP_Application__c();
            App.Name = 'CG Reporting';
            insert(App);
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIAnnual);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            CGReporting.Submitted_Date__c = date.today();
            insert(CGReporting);
            
        }
        
        CG_Batch.AnnualResend();
        CG_Batch.AnnualResendManual(200);
        CG_Batch.DeleteAllReport();
        
        Test.stopTest();
        
    }
    
    public static testMethod void DeleteCGReport() {
        
        Test.startTest();
        
        //RecordType
        RecordType RT = [select id, name, sobjectType from RecordType where name = 'Annual' AND sobjectType = 'CG_Setting__c'];
        
        CG_Config__c CGConfig = new CG_Config__c();
        CGConfig.Year__c = '2022';
        CGConfig.COI_New_User_Running_No__c = '0';
        CGConfig.COI_Incident_Running_No__c = '0';
        CGConfig.COI_Annual_Running_No__c = '0';
        CGConfig.CG_New_User_Running_No__c = '0';
        CGConfig.CG_Manual_Running_No__c = '0';
        CGConfig.CG_Annual_Running_No__c = '0';
        CGConfig.Gift_Running_No__c = '0';
        CGConfig.Environment__c = 'dev';
        insert(CGConfig);
        
        CG_Setting__c CGSetting = new CG_Setting__c();
        CGSetting.Start_Date__c = date.today();
        CGSetting.End_Date__c = date.today();
        CGSetting.Type__c = 'Annual';
        CGSetting.RecordTypeId = RT.Id;
        insert(CGSetting);
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        //Senior
        User VatcharaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'vatchara',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(VatcharaUser);
        
        //Section Head
        User ChaiyarUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'chaiyar',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(ChaiyarUser);
        
        //VP
        User NarongsakUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'narongsak',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(NarongsakUser);
        
        //EVP Upward
        User RungnapaUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'rungnapa',
            Email = Math.Random() + '@thaioilgroup.com',
            Username = Math.Random() + '@thaioilgroup.com',
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(RungnapaUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'Junior';
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
        thaninthon.ReportToUser__c = VatcharaUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = VatcharaUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.ReportToUser__c = ChaiyarUser.Id;
        insert(vatchara);
        
        PISUsers__c chaiyar = new PISUsers__c();
        chaiyar.EMPLOYEEID__c = '00000506';
        chaiyar.Name = 'CHAIYAR';
        chaiyar.LEVEL__c = 'Section Head';
        chaiyar.ORGID__c = '00000225';
        chaiyar.POSID__c = '00001348';
        chaiyar.ENFIRSTNAME__c = 'Chaiyar';
        chaiyar.ENLASTNAME__c = 'Hranpattanakij';
        chaiyar.HOLDERPOSITION__c = '00001348';
        chaiyar.EMAIL__c = 'chaiyar@thaioilgroup.com';
        chaiyar.User__c = ChaiyarUser.Id;
        chaiyar.ReportToPOS__c = '00000784';
        chaiyar.ReportToID__c = '00000965';
        chaiyar.ReportToEmail__c = 'narongsak@thaioilgroup.com';
        chaiyar.ReportToUser__c = NarongsakUser.Id;
        insert(chaiyar);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.EMPLOYEEID__c = '00000965';
        narongsak.Name = 'NARONGSAK';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000013';
        narongsak.POSID__c = '00000784';
        narongsak.ENFIRSTNAME__c = 'Narongsak';
        narongsak.ENLASTNAME__c = 'Chaviengpob';
        narongsak.HOLDERPOSITION__c = '00000784';
        narongsak.EMAIL__c = 'narongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakUser.Id;
        narongsak.ReportToPOS__c = '60001197';
        narongsak.ReportToID__c = '00000871';
        narongsak.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        narongsak.ReportToUser__c = RungnapaUser.Id;
        insert(narongsak);
        
        PISUsers__c rungnapa = new PISUsers__c();
        rungnapa.EMPLOYEEID__c = '00000871';
        rungnapa.Name = 'RUNGNAPA';
        rungnapa.LEVEL__c = 'EVP Upward';
        rungnapa.ORGID__c = '60000529';
        rungnapa.POSID__c = '60001197';
        rungnapa.ENFIRSTNAME__c = 'Rungnapa';
        rungnapa.ENLASTNAME__c = 'Janchookiat';
        rungnapa.HOLDERPOSITION__c = '00001231,60001197';
        rungnapa.EMAIL__c = 'rungnapa@thaioilgroup.com';
        rungnapa.User__c = Rungnapa.Id;
        //rungnapa.ReportToPOS__c = '00000762';
        //rungnapa.ReportToID__c = '00000816';
        //rungnapa.ReportToEmail__c = 'rungnapa@thaioilgroup.com';
        //rungnapa.ReportToUser__c = RungnapaUser.Id;
        insert(rungnapa);
            
        InsertUserToGroup(TestUser.Id);
        
        System.runAs(testUser) {
            
            //Insert Opp Noti
            OPP_Application__c App = new OPP_Application__c();
            App.Name = 'CG Reporting';
            insert(App);
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c COIAnnual = new CG_Reporting__c();
            COIAnnual.Running_No__c = 'COI-2022-01-0001';
            COIAnnual.OwnerId = testUser.Id;
            COIAnnual.User__c = testUser.Id;
            COIAnnual.Start_Duration__c = date.today();
            COIAnnual.End_Duration__c = date.today();
            COIAnnual.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIAnnual);
            COIAnnual.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            COIAnnual.GenerateFromBatch__c = true;
            COIAnnual.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COIAnnual.COI_Detail__c = 'Test Detail';
            COIAnnual.COI_Action__c = 'Test Action';
            COIAnnual.COI_Disclosure__c = 'Yes';
            COIAnnual.Supervisor_Approver_Status__c = 'Acknowledged';
            COIAnnual.Submitted_Date__c = date.today();
            insert(COIAnnual);
            
            CG_Reporting__c COINewEmployee = new CG_Reporting__c();
            COINewEmployee.Running_No__c = 'COI-2022-02-0001';
            COINewEmployee.OwnerId = testUser.Id;
            COINewEmployee.User__c = testUser.Id;
            COINewEmployee.Start_Duration__c = date.today();
            COINewEmployee.End_Duration__c = date.today();
            COINewEmployee.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            COINewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            COINewEmployee.GenerateFromBatch__c = true;
            COINewEmployee.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COINewEmployee.COI_Detail__c = 'Test Detail';
            COINewEmployee.COI_Action__c = 'Test Action';
            COINewEmployee.COI_Disclosure__c = 'Yes';
            COINewEmployee.Supervisor_Approver_Status__c = 'Acknowledged';
            COINewEmployee.Submitted_Date__c = date.today();
            insert(COINewEmployee);
            
            CG_Reporting__c COIIncident = new CG_Reporting__c();
            COIIncident.Running_No__c = 'COI-2022-03-0001';
            COIIncident.OwnerId = testUser.Id;
            COIIncident.User__c = testUser.Id;
            COIIncident.Start_Duration__c = date.today();
            COIIncident.End_Duration__c = date.today();
            COIIncident.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIIncident);
            COIIncident.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            COIIncident.GenerateFromBatch__c = true;
            COIIncident.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            COIIncident.COI_Detail__c = 'Test Detail';
            COIIncident.COI_Action__c = 'Test Action';
            COIIncident.COI_Disclosure__c = 'Yes';
            COIIncident.Supervisor_Approver_Status__c = 'Acknowledged';
            COIIncident.Submitted_Date__c = date.today();
            insert(COIIncident);
            
            CG_Reporting__c CGNewEmployee = new CG_Reporting__c();
            CGNewEmployee.Running_No__c = 'CG-2022-01-0001';
            CGNewEmployee.OwnerId = testUser.Id;
            CGNewEmployee.User__c = testUser.Id;
            CGNewEmployee.Start_Duration__c = date.today();
            CGNewEmployee.End_Duration__c = date.today();
            CGNewEmployee.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGNewEmployee);
            CGNewEmployee.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGNewEmployee.GenerateFromBatch__c = true;
            CGNewEmployee.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGNewEmployee.Submitted_Date__c = date.today();
            insert(CGNewEmployee);
            
            //CG_Batch.assignGLVPWhenSupervisorSubmit('Acknowledged','', CGNewEmployee.OwnerId, CGNewEmployee.Status_JSON__c);
        	CG_Batch.EndDurationCGReminder();
            
            CG_Reporting__c CGAnnual = new CG_Reporting__c();
            CGAnnual.Running_No__c = 'CG-2022-02-0001';
            CGAnnual.OwnerId = testUser.Id;
            CGAnnual.User__c = testUser.Id;
            CGAnnual.Start_Duration__c = date.today();
            CGAnnual.End_Duration__c = date.today();
            CGAnnual.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGAnnual);
            CGAnnual.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGAnnual.GenerateFromBatch__c = true;
            CGAnnual.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            insert(CGAnnual);
            
            CG_Reporting__c CGManual = new CG_Reporting__c();
            CGManual.Running_No__c = 'CG-2022-03-0001';
            CGManual.OwnerId = testUser.Id;
            CGManual.User__c = testUser.Id;
            CGManual.Start_Duration__c = date.today();
            CGManual.End_Duration__c = date.today();
            CGManual.Type_of_Report__c = String.ValueOf(CG_Enum.CGReportType.CGManual);
            CGManual.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGManual.GenerateFromBatch__c = true;
            CGManual.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            insert(CGManual);
            
            CG_Reporting__c Gift = new CG_Reporting__c();
            Gift.Running_No__c = 'GIFT-2022-0001';
            Gift.OwnerId = testUser.Id;
            Gift.User__c = testUser.Id;
            Gift.Start_Duration__c = date.today();
            Gift.End_Duration__c = date.today();
            Gift.Type_of_Report__c = 'GiftRegistration';
            Gift.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            Gift.GenerateFromBatch__c = true;
            Gift.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            insert(Gift);
            
        }
        
        CG_Batch.ExpirePreviousYearCGReport();
        CG_Batch.DeleteCOIAnnualReport();
        CG_Batch.DeleteCOIIncidentReport();
        CG_Batch.DeleteCOINewEmployeeReport();
        CG_Batch.DeleteCGNewEmployeeReport();
        CG_Batch.DeleteCGAnnaulReport();
        CG_Batch.DeleteCGManualReport();
        CG_Batch.DeleteGiftReport();
        
        CG_Batch.DeleteDurationJSON('Annual');
        
        Test.stopTest();
        
    }
    
    @future
    private static void InsertUserToGroup(string userId)
    {
        //CG Admin
        Group approverAdminGroup = [select id from Group where developername = 'CG_Admin'];
        GroupMember memberAdmin = new GroupMember();
        memberAdmin.UserOrGroupId = userId;
        memberAdmin.GroupId = approverAdminGroup.Id;
        insert(memberAdmin);
        
        //CG GLVP
        Group approverGLVPGroup = [select id from Group where developername = 'CG_GLVP'];
        GroupMember memberGLVP = new GroupMember();
        memberGLVP.UserOrGroupId = userId;
        memberGLVP.GroupId = approverGLVPGroup.Id;
        insert(memberGLVP);
        
        //CG GLGC
        Group approverGLGCGroup = [select id from Group where developername = 'CG_GLGC'];
        GroupMember memberGLGC = new GroupMember();
        memberGLGC.UserOrGroupId = userId;
        memberGLGC.GroupId = approverGLGCGroup.Id;
        insert(memberGLGC);
        
        //CG Test
        Group testGroup = [select id from Group where developername = 'CG_Test'];
        GroupMember memberTest = new GroupMember();
        memberTest.UserOrGroupId = userId;
        memberTest.GroupId = testGroup.Id;
        insert(memberTest);
    }
}