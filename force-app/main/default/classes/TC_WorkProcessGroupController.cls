/* Test class for WorkProcessGroupController Class */
@isTest
public class TC_WorkProcessGroupController {

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
    
    public static TestMethod void WorkProcessGroupController() {
        
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
        
            PageReference pageRef = Page.WorkProcessGroup_VFPage;
            pageRef.getParameters().put('ProjectId',Proj.Id);        
            Test.setCurrentPage(PageRef);
            
            test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(Proj);                         
            WorkProcessGroupController WorkProcessGroup = new WorkProcessGroupController(); 
            
            test.stopTest();
        }
    }
    
}