/* Test class for WorkProcess 3 */
@isTest
public class TC_WP3Controller {

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
            
            Master_Data_Detail__c MDD3 = new Master_Data_Detail__c();
            MDD3.Work_Process_No__c = 3;
            MDD3.Group__c = 10;
            MDD3.Name = 'Lesson Learnt';
            MDD3.Work_Process_Group__c = '1';
            MDD3.Master_Data__c = MD.Id;
            MDD3.SME__c = SMEUser.Id;
            MDDs.add(MDD3);
            
            Master_Data_Detail__c MDD4 = new Master_Data_Detail__c();
            MDD4.Work_Process_No__c = 4;
            MDD4.Group__c = 10;
            MDD4.Name = 'Project Execution';
            MDD4.Work_Process_Group__c = '1';
            MDD4.Master_Data__c = MD.Id;
            MDD4.SME__c = SMEUser.Id;
            MDDs.add(MDD4);
            
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
    
    public static TestMethod void WP3Controller() {
        
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
            Proj.Project_Number__c = 'Test WP3';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
            
            List<Id> ProjIds = new List<Id>();
            ProjIds.add(Proj.Id);
            
            string completedStatus = 'Completed';
            string waitingStatus = 'Waiting for Previous Step';
            
            Lesson_Learnt_Review__c currentWP = [select id, Project__c, Work_Process_Status__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            currentWP.Work_Process_Status__c = completedStatus;
            update(currentWP);
            
            Project_Execution_Plan__c previousWP = [select id, Project__c, Work_Process_Status__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            previousWP.Work_Process_Status__c = waitingStatus;
            update(previousWP);
            
        	WP3Controller.UpdateWorkProcess4FromWaitingForPreviousStep(ProjIds);
        }
    }
    
}