/* Test class for CPEMController Class */
@isTest
public class TC_CPEMController {

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
    
    public static TestMethod void GetWorkProcessName() {
        
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
        
            CPEMController CPEM = new CPEMController();
            CPEM.GetWorkProcessName(1);
        }
        
    }
    
    public static TestMethod void UpdateProjectCompletedStatus() {
        
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
        
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateProjectCompletedStatus(Proj.Id);
        
        }
    }
    
    public static TestMethod void UpdateActualStartDateWP1() {
        
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
            Proj.Actual_Start_Date__c = date.today();
            insert(Proj);
        
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateActualStartDateWP1(Proj.Id);
        }
        
    }
    
    public static TestMethod void UpdateActualEndDateWP1() {
        
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
            Proj.Actual_Start_Date__c = date.today();
            Proj.Actual_End_Date__c = date.today();
            insert(Proj);
            
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateActualEndDateWP1(Proj.Id);
        }
        
    }
    
    public static TestMethod void SendMailToAssignUser() {
        
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
        
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            
            CPEMController CPEM = new CPEMController();
            CPEM.SendMailToAssignUser(WP1.Id, 1, u.Id, 'Step 1');
        }
        
    }
    
    public static TestMethod void UpdateSMEForWorkProcess0() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(0, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess1() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(1, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess2() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(2, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess3() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(3, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess4() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(4, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess5() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(5, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess6() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(6, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess7() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(7, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess8() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(8, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess9() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(9, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess10() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(10, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess11() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(11, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess12() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(12, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess13() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(13, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess14() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(14, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess15() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(15, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess16() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(16, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess17() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(17, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess18() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(18, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess19() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(19, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess20() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(20, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess28() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(28, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess29() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(29, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess30() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(30, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess31() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(31, u1.Id);
        }
        
    }
    public static TestMethod void UpdateSMEForWorkProcess32() {
        
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
        
        }
        
        User u1 = new User(
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
        insert(u1);
        
        System.runAs(u1) {
            CPEMController CPEM = new CPEMController();
            CPEM.UpdateSMEForWorkProcess(32, u1.Id);
        }
        
    }
    
}