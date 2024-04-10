/* Test class for WorkProcess 4 */
@isTest
public class TC_WP4Controller {

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
            MDD1.Work_Process_No__c = 1;
            MDD1.Group__c = 10;
            MDD1.Name = 'Project Charter';
            MDD1.Work_Process_Group__c = '1';
            MDD1.Master_Data__c = MD.Id;
            MDD1.SME__c = SMEUser.Id;
            MDDs.add(MDD1);
            
            Master_Data_Detail__c MDD4 = new Master_Data_Detail__c();
            MDD4.Work_Process_No__c = 4;
            MDD4.Group__c = 10;
            MDD4.Name = 'Project Execution';
            MDD4.Work_Process_Group__c = '1';
            MDD4.Master_Data__c = MD.Id;
            MDD4.SME__c = SMEUser.Id;
            MDDs.add(MDD4);
            
            Master_Data_Detail__c MDD5 = new Master_Data_Detail__c();
            MDD5.Work_Process_No__c = 5;
            MDD5.Group__c = 10;
            MDD5.Name = 'Project Procurement Plan';
            MDD5.Work_Process_Group__c = '1';
            MDD5.Master_Data__c = MD.Id;
            MDD5.SME__c = SMEUser.Id;
            MDDs.add(MDD5);
            
            Master_Data_Detail__c MDD10 = new Master_Data_Detail__c();
            MDD10.Work_Process_No__c = 10;
            MDD10.Group__c = 10;
            MDD10.Name = 'ITB Standard';
            MDD10.Work_Process_Group__c = '1';
            MDD10.Master_Data__c = MD.Id;
            MDD10.SME__c = SMEUser.Id;
            MDDs.add(MDD10);
            
            Master_Data_Detail__c MDD11 = new Master_Data_Detail__c();
            MDD11.Work_Process_No__c = 11;
            MDD11.Group__c = 10;
            MDD11.Name = 'CCE Approval Process';
            MDD11.Work_Process_Group__c = '1';
            MDD11.Master_Data__c = MD.Id;
            MDD11.SME__c = SMEUser.Id;
            MDDs.add(MDD11);
            
            insert(MDDs);
        }
    }
    
    public static TestMethod void WP4Controller() {
        
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
            Proj.Project_Number__c = 'Test WP4';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
            
            List<Id> ProjIds = new List<Id>();
            ProjIds.add(Proj.Id);
            
            string completedStatus = 'Completed';
            string waitingStatus = 'Waiting for Previous Step';
            
            Project_Execution_Plan__c currentWP = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            currentWP.Work_Process_Status__c = completedStatus;
            update(currentWP);
            
            Project_Procurement_Plan__c previousWP = [select id, Project__c, Work_Process_Status__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            previousWP.Work_Process_Status__c = waitingStatus;
            update(previousWP);
            
        	WP4Controller.UpdateWorkProcess5FromWaitingForPreviousStep(ProjIds);
        }
    }
    
}