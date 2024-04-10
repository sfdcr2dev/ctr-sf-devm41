/* Test Class for MCRFSUController Class */
@isTest
public class TC_MCRFSUChart {

    public static void MasterDataInfo() {
        //Master Data
        User SMEUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'SME'].Id,
            UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI AD&SME'].Id,
            LastName = 'last',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(SMEUser);
        
        System.runAs(SMEUser) {
            Master_Data__c MD = new Master_Data__c();
            MD.Name = 'SME and Guideline';
            insert(MD);
            
            List<Master_Data_Detail__c> MDDs = new List<Master_Data_Detail__c>();
            
            Master_Data_Detail__c MDD1 = new Master_Data_Detail__c();
            MDD1.Work_Process_No__c = 0;
            MDD1.Group__c = 10;
            MDD1.Name = 'Project Risk Assessment';
            MDD1.Work_Process_Group__c = '10';
            MDD1.Master_Data__c = MD.Id;
            MDD1.SME__c = SMEUser.Id;
            MDDs.add(MDD1);
            
            insert(MDDs);
        }
    }
    
    public static testMethod void MCRFSUChart() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
        LastName = 'last',
        Email = 'test@thaioilgroup.com',
        Username = 'test@thaioilgroup.com' + System.currentTimeMillis(),
        CompanyName = 'Thaioil',
        Alias = 'test',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US'
    	);
        insert(u);
        
        System.runAs(u) {
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
        
            Punch_List_Management_System__c WP27 = [select id, Project__c from Punch_List_Management_System__c where Project__c =: Proj.Id];
            
            MC_RSFU__c MCRFSU = [select id from MC_RSFU__c where Project__c =: Proj.Id];
            
            DateTime dT = System.now();
            Date todayDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            Handover__c Handover = new Handover__c();
            Handover.MC__c = todayDate;
            Handover.RSFU__c = todayDate;
            Handover.Punch_List_Management_System__c = WP27.Id;
            insert(Handover);
            
            PageReference pageRef = Page.WorkProcess28Chart;
            //pageRef.getParameters().put('WorkProcessNo','1');        
            Test.setCurrentPage(PageRef);
            
            test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(MCRFSU);                         
            MCRFSUChart Chart = new MCRFSUChart(sc); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void MCRFSUChartMC() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
        LastName = 'last',
        Email = 'test@thaioilgroup.com',
        Username = 'test@thaioilgroup.com' + System.currentTimeMillis(),
        CompanyName = 'Thaioil',
        Alias = 'test',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US'
    	);
        insert(u);
        
        System.runAs(u) {
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
        
            Punch_List_Management_System__c WP27 = [select id, Project__c from Punch_List_Management_System__c where Project__c =: Proj.Id];
            
            MC_RSFU__c MCRFSU = [select id from MC_RSFU__c where Project__c =: Proj.Id];
            
            DateTime dT = System.now();
            Date todayDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            Handover__c Handover = new Handover__c();
            Handover.Punch_List_Management_System__c = WP27.Id;
            insert(Handover);
            
            PageReference pageRef = Page.WorkProcess28Chart;
            //pageRef.getParameters().put('WorkProcessNo','1');        
            Test.setCurrentPage(PageRef);
            
            test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(MCRFSU);                         
            MCRFSUChart Chart = new MCRFSUChart(sc); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void MCRFSUChartRSFU() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
        LastName = 'last',
        Email = 'test@thaioilgroup.com',
        Username = 'test@thaioilgroup.com' + System.currentTimeMillis(),
        CompanyName = 'Thaioil',
        Alias = 'test',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US'
    	);
        insert(u);
        
        System.runAs(u) {
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
        
            Punch_List_Management_System__c WP27 = [select id, Project__c from Punch_List_Management_System__c where Project__c =: Proj.Id];
            
            MC_RSFU__c MCRFSU = [select id from MC_RSFU__c where Project__c =: Proj.Id];
            
            DateTime dT = System.now();
            Date todayDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            Handover__c Handover = new Handover__c();
            Handover.MC__c = todayDate;
            Handover.Punch_List_Management_System__c = WP27.Id;
            insert(Handover);
            
            PageReference pageRef = Page.WorkProcess28Chart;
            //pageRef.getParameters().put('WorkProcessNo','1');        
            Test.setCurrentPage(PageRef);
            
            test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(MCRFSU);                         
            MCRFSUChart Chart = new MCRFSUChart(sc); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void MCRFSUChartNoHandover() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
        LastName = 'last',
        Email = 'test@thaioilgroup.com',
        Username = 'test@thaioilgroup.com' + System.currentTimeMillis(),
        CompanyName = 'Thaioil',
        Alias = 'test',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US'
    	);
        insert(u);
        
        System.runAs(u) {
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
        
            Punch_List_Management_System__c WP27 = [select id, Project__c from Punch_List_Management_System__c where Project__c =: Proj.Id];
            
            MC_RSFU__c MCRFSU = [select id from MC_RSFU__c where Project__c =: Proj.Id];
            
            PageReference pageRef = Page.WorkProcess28Chart;
            //pageRef.getParameters().put('WorkProcessNo','1');        
            Test.setCurrentPage(PageRef);
            
            test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(MCRFSU);                         
            MCRFSUChart Chart = new MCRFSUChart(sc); 
            
            test.stopTest();
        }
    }
}