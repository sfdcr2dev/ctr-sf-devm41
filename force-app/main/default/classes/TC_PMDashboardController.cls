/* Test class PMDashboardController Class */
@isTest
public class TC_PMDashboardController {

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
    
    public static testMethod void PMDashboardController() {
        
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
        
            PageReference pageRef = Page.PMDashboard;  
            Test.setCurrentPage(PageRef);
            
            test.startTest();
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
                                         
            PMDashboardController PMDashboard = new PMDashboardController(); 
            PMDashboard.sortByProjectNo();
            PMDashboard.sortByDescProjectNo();
            PMDashboard.sortByProjectName();
            PMDashboard.sortByDescProjectName();
            PMDashboard.sortByProjectStatus();
            PMDashboard.sortByDescProjectStatus();
            PMDashboard.sortByCompleted();
            PMDashboard.sortByDescCompleted();
            PMDashboard.sortByCurrentStep();
            PMDashboard.sortByDescCurrentStep();
            PMDashboard.FirstPage();
            PMDashboard.LastPage();
            PMDashboard.next();
            PMDashboard.previous();
            boolean prev = PMDashboard.getprev();
            boolean nxt = PMDashboard.getnxt();
            
            PMDashboardController.ProjectWrapper PW1 = new PMDashboardController.ProjectWrapper();
            PW1.ProjectName = 'ABC';
            PW1.ProjectNo = '1';
            
            PMDashboardController.ProjectWrapper PW2 = new PMDashboardController.ProjectWrapper();
            PW2.ProjectName = 'ABC';
            PW1.ProjectNo = '2';
            
            PW1.sortByProjectNo(PW2);
            
            PW1.compareTo(PW2);
            
            PMDashboardController.ProjectWrapper PW3 = new PMDashboardController.ProjectWrapper('1','Test Proejct', 'Ongoing', 1, 1);
            
            test.stopTest();
        }        
    }
    
    public static testMethod void PMDashboardSortController() {
        
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
        
            PageReference pageRef = Page.PMDashboard;  
            Test.setCurrentPage(PageRef);
            
            test.startTest();
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
                                         
            PMDashboardController PMDashboard = new PMDashboardController(); 
            PMDashboard.sortByProjectNo();
            PMDashboard.sortByDescProjectNo();
            PMDashboard.sortByProjectName();
            PMDashboard.sortByDescProjectName();
            PMDashboard.sortByProjectStatus();
            PMDashboard.sortByDescProjectStatus();
            PMDashboard.sortByCompleted();
            PMDashboard.sortByDescCompleted();
            PMDashboard.sortByCurrentStep();
            PMDashboard.sortByDescCurrentStep();
            PMDashboard.FirstPage();
            PMDashboard.LastPage();
            PMDashboard.next();
            PMDashboard.previous();
            boolean prev = PMDashboard.getprev();
            boolean nxt = PMDashboard.getnxt();
            
            PMDashboardController.ProjectWrapper PW1 = new PMDashboardController.ProjectWrapper();
            PW1.ProjectName = 'ABC';
            PW1.ProjectNo = '1';
            
            PMDashboardController.ProjectWrapper PW2 = new PMDashboardController.ProjectWrapper();
            PW2.ProjectName = 'ABC';
            PW1.ProjectNo = '2';
            
            PW1.sortByProjectNo(PW2);
            PW1.sortByProjectNoDesc(PW2);
            PW1.sortByProjectName(PW2);
            PW1.sortByProjectNameDesc(PW2);
            PW1.sortByStatus(PW2);
            PW1.sortByStatusDesc(PW2);
            PW1.sortByCompleted(PW2);
            PW1.sortByCompletedDesc(PW2);
            PW1.sortByStep(PW2);
            PW1.sortByStepDesc(PW2);
            
            PW1.compareTo(PW2);
            
            test.stopTest();
        }        
    }
    
    public static testMethod void PMDashboardControllerSearch() {
        
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
        
        Project__c Proj = new Project__c();
        
        System.runAs(u) {
            

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
            
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            PMDashboard.searchProject = 'Test';
            PMDashboard.SearchProject();
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerPM() {
        
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
            
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                    
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();	
            
        }
        
    }
    
    public static testMethod void PMDashboardControllerPMSearch() {
        
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
            
            PageReference pageRef = Page.PMDashboard; 
            Test.setCurrentPage(PageRef);
            
            test.startTest();
                                 
            PMDashboardController PMDashboard = new PMDashboardController(); 
            PMDashboard.searchProject = 'Test';
            PMDashboard.SearchProject();
            test.stopTest();	
            
        }
        
    }
    
    public static testMethod void PMDashboardControllerWP2() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Not Start';
            update(WP2);
            
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP3() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Not Start';
            update(WP3);
            
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP4EPOwner() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Not Start';
            update(WP4);
            
            
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP4EPC() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Not Start';
            WP4.Service_Requisition__c = 'EPC';
            update(WP4);
            
            
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP4E() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Not Start';
            WP4.Service_Requisition__c = 'E';
            update(WP4);
            
            
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP5() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP6() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
        
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP7() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP8() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
                 
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP9() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
                 
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP10() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
            
            ITB_Standard__c WP10 = [select id, Project__c from ITB_Standard__c where Project__c =: Proj.Id];
            WP10.Work_Process_Status__c = 'Completed';
            update(WP10);
                 
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP11() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
            
            ITB_Standard__c WP10 = [select id, Project__c from ITB_Standard__c where Project__c =: Proj.Id];
            WP10.Work_Process_Status__c = 'Completed';
            update(WP10);
            
            CCE_Approval_Process__c WP11 = [select id, Project__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            WP11.Work_Process_Status__c = 'Completed';
            update(WP11);
                 
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP12() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
            
            ITB_Standard__c WP10 = [select id, Project__c from ITB_Standard__c where Project__c =: Proj.Id];
            WP10.Work_Process_Status__c = 'Completed';
            update(WP10);
            
            CCE_Approval_Process__c WP11 = [select id, Project__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            WP11.Work_Process_Status__c = 'Completed';
            update(WP11);
            
            Engineering_Standard__c WP12 = [select id, Project__c from Engineering_Standard__c where Project__c =: Proj.Id];
            WP12.Work_Process_Status__c = 'Completed';
            update(WP12);
                 
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    /* public static testMethod void PMDashboardControllerWP13() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
            
            ITB_Standard__c WP10 = [select id, Project__c from ITB_Standard__c where Project__c =: Proj.Id];
            WP10.Work_Process_Status__c = 'Completed';
            update(WP10);
            
            CCE_Approval_Process__c WP11 = [select id, Project__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            WP11.Work_Process_Status__c = 'Completed';
            update(WP11);
            
            Engineering_Standard__c WP12 = [select id, Project__c from Engineering_Standard__c where Project__c =: Proj.Id];
            WP12.Work_Process_Status__c = 'Completed';
            update(WP12);
            
            Deliverable_List__c WP13 = [select id, Project__c from Deliverable_List__c where Project__c =: Proj.Id];
            WP13.Work_Process_Status__c = 'Completed';
            update(WP13);
                 
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    }
    
    public static testMethod void PMDashboardControllerWP14() {
        
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
        
            PageReference pageRef = Page.PMDashboard;     
            Test.setCurrentPage(PageRef);
            
            Project_Charter__c WP1 = [select id, Project__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Work_Process_Status__c = 'Completed';
            update(WP1);
            
            Project_Organization__c WP2 = [select id, Project__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Work_Process_Status__c = 'Completed';
            update(WP2);
            
            Lesson_Learnt_Review__c WP3 = [select id, Project__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Work_Process_Status__c = 'Completed';
            update(WP3);
            
            Project_Execution_Plan__c WP4 = [select id, Project__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Work_Process_Status__c = 'Completed';
            update(WP4);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Work_Process_Status__c = 'Completed';
            update(WP5);
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Work_Process_Status__c = 'Completed';
            update(WP6);
            
            Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Work_Process_Status__c = 'Completed';
            update(WP7);
            
            Project_Status_Control__c WP8 = [select id, Project__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Work_Process_Status__c = 'Completed';
            update(WP8);
            
            Budget_Phasing__c WP9 = [select id, Project__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Work_Process_Status__c = 'Completed';
            update(WP9);
            
            ITB_Standard__c WP10 = [select id, Project__c from ITB_Standard__c where Project__c =: Proj.Id];
            WP10.Work_Process_Status__c = 'Completed';
            update(WP10);
            
            CCE_Approval_Process__c WP11 = [select id, Project__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            WP11.Work_Process_Status__c = 'Completed';
            update(WP11);
            
            Engineering_Standard__c WP12 = [select id, Project__c from Engineering_Standard__c where Project__c =: Proj.Id];
            WP12.Work_Process_Status__c = 'Completed';
            update(WP12);
            
            Deliverable_List__c WP13 = [select id, Project__c from Deliverable_List__c where Project__c =: Proj.Id];
            WP13.Work_Process_Status__c = 'Completed';
            update(WP13);
            
            Document_Distribution_Matrix__c  WP14 = [select id, Project__c from Document_Distribution_Matrix__c  where Project__c =: Proj.Id];
            WP14.Work_Process_Status__c = 'Completed';
            update(WP14);
                 
            test.startTest();
                                   
            PMDashboardController PMDashboard = new PMDashboardController(); 
            
            test.stopTest();
        }
    } */
    
}