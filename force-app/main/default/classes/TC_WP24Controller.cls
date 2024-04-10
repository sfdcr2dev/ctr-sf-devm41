/* Test class for WorkProcess 24 */
@isTest
public class TC_WP24Controller {

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
            
            Master_Data_Detail__c MDD0 = new Master_Data_Detail__c();
            MDD0.Work_Process_No__c = 0;
            MDD0.Group__c = 10;
            MDD0.Name = 'Project Risk Assessment And Quality Assurance';
            MDD0.Work_Process_Group__c = '1';
            MDD0.Master_Data__c = MD.Id;
            MDD0.SME__c = SMEUser.Id;
            MDDs.add(MDD0);
            
            Master_Data_Detail__c MDD1 = new Master_Data_Detail__c();
            MDD1.Work_Process_No__c = 1;
            MDD1.Group__c = 10;
            MDD1.Name = 'Project Charter';
            MDD1.Work_Process_Group__c = '1';
            MDD1.Master_Data__c = MD.Id;
            MDD1.SME__c = SMEUser.Id;
            MDDs.add(MDD1);
            
            Master_Data_Detail__c MDD2 = new Master_Data_Detail__c();
            MDD2.Work_Process_No__c = 2;
            MDD2.Group__c = 10;
            MDD2.Name = 'Project Organization';
            MDD2.Work_Process_Group__c = '1';
            MDD2.Master_Data__c = MD.Id;
            MDD2.SME__c = SMEUser.Id;
            MDDs.add(MDD2);
            
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
            
            Master_Data_Detail__c MDD5 = new Master_Data_Detail__c();
            MDD5.Work_Process_No__c = 5;
            MDD5.Group__c = 10;
            MDD5.Name = 'Project Procurement Plan';
            MDD5.Work_Process_Group__c = '1';
            MDD5.Master_Data__c = MD.Id;
            MDD5.SME__c = SMEUser.Id;
            MDDs.add(MDD5);
            
            Master_Data_Detail__c MDD6 = new Master_Data_Detail__c();
            MDD6.Work_Process_No__c = 6;
            MDD6.Group__c = 10;
            MDD6.Name = 'WBS and CBS';
            MDD6.Work_Process_Group__c = '1';
            MDD6.Master_Data__c = MD.Id;
            MDD6.SME__c = SMEUser.Id;
            MDDs.add(MDD6);
            
            Master_Data_Detail__c MDD7 = new Master_Data_Detail__c();
            MDD7.Work_Process_No__c = 7;
            MDD7.Group__c = 10;
            MDD7.Name = 'Schedule';
            MDD7.Work_Process_Group__c = '1';
            MDD7.Master_Data__c = MD.Id;
            MDD7.SME__c = SMEUser.Id;
            MDDs.add(MDD7);
            
            Master_Data_Detail__c MDD8 = new Master_Data_Detail__c();
            MDD8.Work_Process_No__c = 8;
            MDD8.Group__c = 10;
            MDD8.Name = 'Project Status Control';
            MDD8.Work_Process_Group__c = '1';
            MDD8.Master_Data__c = MD.Id;
            MDD8.SME__c = SMEUser.Id;
            MDDs.add(MDD8);
            
            Master_Data_Detail__c MDD9 = new Master_Data_Detail__c();
            MDD9.Work_Process_No__c = 9;
            MDD9.Group__c = 10;
            MDD9.Name = 'Budget Phasing';
            MDD9.Work_Process_Group__c = '1';
            MDD9.Master_Data__c = MD.Id;
            MDD9.SME__c = SMEUser.Id;
            MDDs.add(MDD9);
            
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
            
            Master_Data_Detail__c MDD12 = new Master_Data_Detail__c();
            MDD12.Work_Process_No__c = 12;
            MDD12.Group__c = 10;
            MDD12.Name = 'Engineering Standard';
            MDD12.Work_Process_Group__c = '1';
            MDD12.Master_Data__c = MD.Id;
            MDD12.SME__c = SMEUser.Id;
            MDDs.add(MDD12);
            
            Master_Data_Detail__c MDD13 = new Master_Data_Detail__c();
            MDD13.Work_Process_No__c = 13;
            MDD13.Group__c = 10;
            MDD13.Name = 'Deliverable List';
            MDD13.Work_Process_Group__c = '1';
            MDD13.Master_Data__c = MD.Id;
            MDD13.SME__c = SMEUser.Id;
            MDDs.add(MDD13);
            
            Master_Data_Detail__c MDD14 = new Master_Data_Detail__c();
            MDD14.Work_Process_No__c = 14;
            MDD14.Group__c = 10;
            MDD14.Name = 'Document Distribution Matrix';
            MDD14.Work_Process_Group__c = '1';
            MDD14.Master_Data__c = MD.Id;
            MDD14.SME__c = SMEUser.Id;
            MDDs.add(MDD14);
            
            Master_Data_Detail__c MDD15 = new Master_Data_Detail__c();
            MDD15.Work_Process_No__c = 15;
            MDD15.Group__c = 10;
            MDD15.Name = 'Design Safety Standard';
            MDD15.Work_Process_Group__c = '1';
            MDD15.Master_Data__c = MD.Id;
            MDD15.SME__c = SMEUser.Id;
            MDDs.add(MDD15);
            
            Master_Data_Detail__c MDD16 = new Master_Data_Detail__c();
            MDD16.Work_Process_No__c = 16;
            MDD16.Group__c = 10;
            MDD16.Name = 'Cost Estimate';
            MDD16.Work_Process_Group__c = '1';
            MDD16.Master_Data__c = MD.Id;
            MDD16.SME__c = SMEUser.Id;
            MDDs.add(MDD16);
            
            Master_Data_Detail__c MDD17 = new Master_Data_Detail__c();
            MDD17.Work_Process_No__c = 17;
            MDD17.Group__c = 10;
            MDD17.Name = 'Engineering Data Book and 3D Model';
            MDD17.Work_Process_Group__c = '1';
            MDD17.Master_Data__c = MD.Id;
            MDD17.SME__c = SMEUser.Id;
            MDDs.add(MDD17);
            
            Master_Data_Detail__c MDD18 = new Master_Data_Detail__c();
            MDD18.Work_Process_No__c = 18;
            MDD18.Group__c = 10;
            MDD18.Name = 'ITB Standard';
            MDD18.Work_Process_Group__c = '1';
            MDD18.Master_Data__c = MD.Id;
            MDD18.SME__c = SMEUser.Id;
            MDDs.add(MDD18);
            
            Master_Data_Detail__c MDD19 = new Master_Data_Detail__c();
            MDD19.Work_Process_No__c = 19;
            MDD19.Group__c = 10;
            MDD19.Name = 'CCE Approval Process';
            MDD19.Work_Process_Group__c = '1';
            MDD19.Master_Data__c = MD.Id;
            MDD19.SME__c = SMEUser.Id;
            MDDs.add(MDD19);
            
            Master_Data_Detail__c MDD20 = new Master_Data_Detail__c();
            MDD20.Work_Process_No__c = 20;
            MDD20.Group__c = 10;
            MDD20.Name = 'Project Procurement and Contract Management';
            MDD20.Work_Process_Group__c = '1';
            MDD20.Master_Data__c = MD.Id;
            MDD20.SME__c = SMEUser.Id;
            MDDs.add(MDD20);
            
            Master_Data_Detail__c MDD21 = new Master_Data_Detail__c();
            MDD21.Work_Process_No__c = 21;
            MDD21.Group__c = 10;
            MDD21.Name = 'Vendor Data Management';
            MDD21.Work_Process_Group__c = '1';
            MDD21.Master_Data__c = MD.Id;
            MDD21.SME__c = SMEUser.Id;
            MDDs.add(MDD21);
            
            Master_Data_Detail__c MDD22 = new Master_Data_Detail__c();
            MDD22.Work_Process_No__c = 22;
            MDD22.Group__c = 10;
            MDD22.Name = 'Material Inspection (FAT/SAT)';
            MDD22.Work_Process_Group__c = '1';
            MDD22.Master_Data__c = MD.Id;
            MDD22.SME__c = SMEUser.Id;
            MDDs.add(MDD22);
            
            Master_Data_Detail__c MDD23 = new Master_Data_Detail__c();
            MDD23.Work_Process_No__c = 23;
            MDD23.Group__c = 10;
            MDD23.Name = 'Material and Spare-Part Management';
            MDD23.Work_Process_Group__c = '1';
            MDD23.Master_Data__c = MD.Id;
            MDD23.SME__c = SMEUser.Id;
            MDDs.add(MDD23);
            
            Master_Data_Detail__c MDD24 = new Master_Data_Detail__c();
            MDD24.Work_Process_No__c = 24;
            MDD24.Group__c = 10;
            MDD24.Name = 'Construction Management';
            MDD24.Work_Process_Group__c = '1';
            MDD24.Master_Data__c = MD.Id;
            MDD24.SME__c = SMEUser.Id;
            MDDs.add(MDD24);
            
            Master_Data_Detail__c MDD25 = new Master_Data_Detail__c();
            MDD25.Work_Process_No__c = 25;
            MDD25.Group__c = 10;
            MDD25.Name = 'Budget & Change Control';
            MDD25.Work_Process_Group__c = '1';
            MDD25.Master_Data__c = MD.Id;
            MDD25.SME__c = SMEUser.Id;
            MDDs.add(MDD25);
            
            Master_Data_Detail__c MDD26 = new Master_Data_Detail__c();
            MDD26.Work_Process_No__c = 26;
            MDD26.Group__c = 10;
            MDD26.Name = 'System & Test-Pack Identification';
            MDD26.Work_Process_Group__c = '1';
            MDD26.Master_Data__c = MD.Id;
            MDD26.SME__c = SMEUser.Id;
            MDDs.add(MDD26);
            
            Master_Data_Detail__c MDD27 = new Master_Data_Detail__c();
            MDD27.Work_Process_No__c = 27;
            MDD27.Group__c = 10;
            MDD27.Name = 'Punch List Management System';
            MDD27.Work_Process_Group__c = '1';
            MDD27.Master_Data__c = MD.Id;
            MDD27.SME__c = SMEUser.Id;
            MDDs.add(MDD27);
            
            Master_Data_Detail__c MDD28 = new Master_Data_Detail__c();
            MDD28.Work_Process_No__c = 28;
            MDD28.Group__c = 10;
            MDD28.Name = 'MC & RSFU';
            MDD28.Work_Process_Group__c = '1';
            MDD28.Master_Data__c = MD.Id;
            MDD28.SME__c = SMEUser.Id;
            MDDs.add(MDD28);
            
            Master_Data_Detail__c MDD29 = new Master_Data_Detail__c();
            MDD29.Work_Process_No__c = 29;
            MDD29.Group__c = 10;
            MDD29.Name = 'MCA & Final Document Handover';
            MDD29.Work_Process_Group__c = '1';
            MDD29.Master_Data__c = MD.Id;
            MDD29.SME__c = SMEUser.Id;
            MDDs.add(MDD29);
            
            Master_Data_Detail__c MDD30 = new Master_Data_Detail__c();
            MDD30.Work_Process_No__c = 30;
            MDD30.Group__c = 10;
            MDD30.Name = 'Close Out Report/Lesson Learnt';
            MDD30.Work_Process_Group__c = '1';
            MDD30.Master_Data__c = MD.Id;
            MDD30.SME__c = SMEUser.Id;
            MDDs.add(MDD30);
            
            Master_Data_Detail__c MDD31 = new Master_Data_Detail__c();
            MDD31.Work_Process_No__c = 31;
            MDD31.Group__c = 10;
            MDD31.Name = 'Close Out Statistic';
            MDD31.Work_Process_Group__c = '1';
            MDD31.Master_Data__c = MD.Id;
            MDD31.SME__c = SMEUser.Id;
            MDDs.add(MDD31);
            
            Master_Data_Detail__c MDD32 = new Master_Data_Detail__c();
            MDD32.Work_Process_No__c = 32;
            MDD32.Group__c = 10;
            MDD32.Name = 'CR: Completion Report';
            MDD32.Work_Process_Group__c = '1';
            MDD32.Master_Data__c = MD.Id;
            MDD32.SME__c = SMEUser.Id;
            MDDs.add(MDD32);
            
            insert(MDDs);
        }
    }

    public static TestMethod void WP24Controller() {
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
            Proj.Project_Number__c = 'Test WP24';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
            
            List<Id> ProjIds = new List<Id>();
            ProjIds.add(Proj.Id);
            
            string completedStatus = 'Completed';
            string waitingStatus = 'Waiting for Previous Step';
            
            Construction_Management__c currentWP = [select id, Project__c, Work_Process_Status__c from Construction_Management__c where Project__c =: Proj.Id];
            currentWP.Work_Process_Status__c = completedStatus;
            update(currentWP);
            
            Budget_Change_Control__c previousWP = [select id, Project__c, Work_Process_Status__c from Budget_Change_Control__c where Project__c =: Proj.Id];
            previousWP.Work_Process_Status__c = waitingStatus;
            update(previousWP);
            
        	WP24Controller.UpdateWorkProcess25FromWaitingForPreviousStep(ProjIds);
        }
    }
    
}