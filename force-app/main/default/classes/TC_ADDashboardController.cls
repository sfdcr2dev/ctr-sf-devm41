/* Test Class for ADDashboardController */
@isTest
public class TC_ADDashboardController {

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
    
    public static TestMethod void ADDashboardControllerWP1() {
        
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
            Proj.Status__c = 'Completed';
            insert(Proj);
            
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            ADDashboard.ChooseYear = '2020';
            ADDashboard.SearchProjectByYear();
            
            ADDashboardController.ProjectByPMWrapper PW1 = new ADDashboardController.ProjectByPMWrapper();
            PW1.PMName = 'A';
            PW1.TotalProject = 1;
            
            ADDashboardController.ProjectByPMWrapper PW2 = new ADDashboardController.ProjectByPMWrapper();
            PW2.PMName = 'A';
            PW1.TotalProject = 2;
            
            PW1.sortByTotalProject(PW2);
            
            PW1.compareTo(PW2);
            
            ADDashboardController.ProjectByPMWrapper PW = new ADDashboardController.ProjectByPMWrapper(1);
            
            ADDashboard.GetWorkProcessName(1);
            string thai = ADDashboard.LanguageThai;
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP2() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Start_Plan__c = date.today();
            WP1.End_Plan__c = date.today();
            WP1.Actual_Start_Date__c = date.today();
            WP1.Actual_End_Date__c = date.today();
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP3() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP4() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP5() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Service_Requisition__c = 'EPC';
            update(WP4);
            
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP6() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP7() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP8() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c, Work_Process_Status__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP9() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Service_Requisition__c = 'EPC';
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c, Work_Process_Status__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c, Work_Process_Status__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP12() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c, Work_Process_Status__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c, Work_Process_Status__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c, Work_Process_Status__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
    
            
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP13() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c, Work_Process_Status__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c, Work_Process_Status__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c, Work_Process_Status__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
            
            Engineering_Standard__c WP12 = [select id, Project__c, Work_Process_Status__c from Engineering_Standard__c where Project__c =: Proj.Id];
            WP12.Work_Process_Status__c = 'Completed';
            update(WP12);
    
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP14() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c, Work_Process_Status__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c, Work_Process_Status__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c, Work_Process_Status__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
            
            Engineering_Standard__c WP12 = [select id, Project__c, Work_Process_Status__c from Engineering_Standard__c where Project__c =: Proj.Id];
            WP12.Work_Process_Status__c = 'Completed';
            update(WP12);
            
            Deliverable_List__c WP13 = [select id, Project__c, Work_Process_Status__c from Deliverable_List__c where Project__c =: Proj.Id];
            WP13.Work_Process_Status__c = 'Completed';
            update(WP13);
    
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP15() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c, Work_Process_Status__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c, Work_Process_Status__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c, Work_Process_Status__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
            
            Engineering_Standard__c WP12 = [select id, Project__c, Work_Process_Status__c from Engineering_Standard__c where Project__c =: Proj.Id];
            WP12.Work_Process_Status__c = 'Completed';
            update(WP12);
            
            Deliverable_List__c WP13 = [select id, Project__c, Work_Process_Status__c from Deliverable_List__c where Project__c =: Proj.Id];
            WP13.Work_Process_Status__c = 'Completed';
            update(WP13);
            
            Document_Distribution_Matrix__c WP14 = [select id, Project__c, Work_Process_Status__c from Document_Distribution_Matrix__c where Project__c =: Proj.Id];
            WP14.Work_Process_Status__c = 'Completed';
            update(WP14);
    
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    /* public static TestMethod void ADDashboardControllerWP16() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c, Work_Process_Status__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c, Work_Process_Status__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c, Work_Process_Status__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
            
            Engineering_Standard__c WP12 = [select id, Project__c, Work_Process_Status__c from Engineering_Standard__c where Project__c =: Proj.Id];
            WP12.Work_Process_Status__c = 'Completed';
            update(WP12);
            
            Deliverable_List__c WP13 = [select id, Project__c, Work_Process_Status__c from Deliverable_List__c where Project__c =: Proj.Id];
            WP13.Work_Process_Status__c = 'Completed';
            update(WP13);
            
            Document_Distribution_Matrix__c WP14 = [select id, Project__c, Work_Process_Status__c from Document_Distribution_Matrix__c where Project__c =: Proj.Id];
            WP14.Work_Process_Status__c = 'Completed';
            update(WP14);
            
            Design_Safety_Standard__c WP15 = [select id, Project__c, Work_Process_Status__c from Design_Safety_Standard__c where Project__c =: Proj.Id];
            WP15.Work_Process_Status__c = 'Completed';
            update(WP15);
    
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    }
    
    public static TestMethod void ADDashboardControllerWP17() {
        
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
            
            Project_Charter__c WP1 = [select id, Project__c, Work_Process_Status__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c, Work_Process_Status__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c, Work_Process_Status__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c, Work_Process_Status__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c, Work_Process_Status__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c, Work_Process_Status__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
            
            Engineering_Standard__c WP12 = [select id, Project__c, Work_Process_Status__c from Engineering_Standard__c where Project__c =: Proj.Id];
            WP12.Work_Process_Status__c = 'Completed';
            update(WP12);
            
            Deliverable_List__c WP13 = [select id, Project__c, Work_Process_Status__c from Deliverable_List__c where Project__c =: Proj.Id];
            WP13.Work_Process_Status__c = 'Completed';
            update(WP13);
            
            Document_Distribution_Matrix__c WP14 = [select id, Project__c, Work_Process_Status__c from Document_Distribution_Matrix__c where Project__c =: Proj.Id];
            WP14.Work_Process_Status__c = 'Completed';
            update(WP14);
            
            Design_Safety_Standard__c WP15 = [select id, Project__c, Work_Process_Status__c from Design_Safety_Standard__c where Project__c =: Proj.Id];
            WP15.Work_Process_Status__c = 'Completed';
            update(WP15);
            
            Cost_Estimate__c WP16 = [select id, Project__c, Work_Process_Status__c from Cost_Estimate__c where Project__c =: Proj.Id];
            WP16.Work_Process_Status__c = 'Completed';
            update(WP16);
    
            PageReference pageRef = Page.ADDashboard;   
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                   
            ADDashboardController ADDashboard = new ADDashboardController(); 
            
            test.stopTest();
            
        }
        
        
    } */
    
    
}