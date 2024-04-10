/* Test class for All Work Processes. */
@isTest
public class TC_TRG_AllWorkProcesses {

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
    
    public static TestMethod void AllWorkProcesses1To15() {
        
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
        
            Assigned_User__c AU = new Assigned_User__c();
            AU.Project__c = Proj.Id;
            AU.User__c = u.Id;
            insert(AU);
        
            //WP1
            Project_Charter__c WP1 = [select id, Project__c, Assigned_User__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Assigned_User__c = AU.Id;
            update(WP1);
            
            //WP2
            Project_Organization__c WP2 = [select id, Project__c, Assigned_User__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Assigned_User__c = AU.Id;
            update(WP2);
            
            //WP3
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Assigned_User__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Assigned_User__c = AU.Id;
            update(WP3);
            
            //WP4
            Project_Execution_Plan__c WP4 = [select id, Project__c, Assigned_User__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Assigned_User__c = AU.Id;
            update(WP4);
            
            //WP5
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Assigned_User__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Assigned_User__c = AU.Id;
            update(WP5);
            
            //WP6
            WBS_CBS__c WP6 = [select id, Project__c, Assigned_User__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Assigned_User__c = AU.Id;
            update(WP6);
            
            //WP7
            Schedule__c WP7 = [select id, Project__c, Assigned_User__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Assigned_User__c = AU.Id;
            update(WP7);
            
            //WP8
            Project_Status_Control__c WP8 = [select id, Project__c, Assigned_User__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Assigned_User__c = AU.Id;
            update(WP8);
            
            //WP9
            Budget_Phasing__c WP9 = [select id, Project__c, Assigned_User__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Assigned_User__c = AU.Id;
            update(WP9);
            
            //WP10
            ITB_Standard__c WP10 = [select id, Project__c, Assigned_User__c from ITB_Standard__c where Project__c =: Proj.Id];
            WP10.Assigned_User__c = AU.Id;
            update(WP10);
            
            //WP11
            CCE_Approval_Process__c WP11 = [select id, Project__c, Assigned_User__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            WP11.Assigned_User__c = AU.Id;
            update(WP11);
            
            //WP12
            Engineering_Standard__c WP12 = [select id, Project__c, Assigned_User__c from Engineering_Standard__c where Project__c =: Proj.Id];
            WP12.Assigned_User__c = AU.Id;
            update(WP12);
            
            //WP13
            Deliverable_List__c WP13 = [select id, Project__c, Assigned_User__c from Deliverable_List__c where Project__c =: Proj.Id];
            WP13.Assigned_User__c = AU.Id;
            update(WP13);
            
            //WP14
            Document_Distribution_Matrix__c WP14 = [select id, Project__c, Assigned_User__c from Document_Distribution_Matrix__c where Project__c =: Proj.Id];
            WP14.Assigned_User__c = AU.Id;
            update(WP14);
            
            //WP15
            Design_Safety_Standard__c WP15 = [select id, Project__c, Assigned_User__c from Design_Safety_Standard__c where Project__c =: Proj.Id];
            WP15.Assigned_User__c = AU.Id;
            update(WP15);
                    } 
        
    }
    
    public static TestMethod void AllWorkProcesses1To15ForServiceRequisition() {
        
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
            
            Assigned_User__c AU = new Assigned_User__c();
            AU.Project__c = Proj.Id;
            AU.User__c = u.Id;
            insert(AU);
        
            
            //WP1
            Project_Charter__c WP1 = [select id, Project__c, Assigned_User__c from Project_Charter__c where Project__c =: Proj.Id];
            WP1.Assigned_User__c = AU.Id;
            update(WP1);
            
            //WP2
            Project_Organization__c WP2 = [select id, Project__c, Assigned_User__c from Project_Organization__c where Project__c =: Proj.Id];
            WP2.Assigned_User__c = AU.Id;
            update(WP2);
            
            //WP3
            Lesson_Learnt_Review__c WP3 = [select id, Project__c, Assigned_User__c from Lesson_Learnt_Review__c where Project__c =: Proj.Id];
            WP3.Assigned_User__c = AU.Id;
            update(WP3);
            
            //WP4
            Project_Execution_Plan__c WP4 = [select id, Project__c, Assigned_User__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Assigned_User__c = AU.Id;
            WP4.Service_Requisition__c = 'EPC';
            update(WP4);
            
            //WP5
            Project_Procurement_Plan__c WP5 = [select id, Project__c, Assigned_User__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            WP5.Assigned_User__c = AU.Id;
            update(WP5);
            
            //WP6
            WBS_CBS__c WP6 = [select id, Project__c, Assigned_User__c from WBS_CBS__c where Project__c =: Proj.Id];
            WP6.Assigned_User__c = AU.Id;
            update(WP6);
            
            //WP7
            Schedule__c WP7 = [select id, Project__c, Assigned_User__c from Schedule__c where Project__c =: Proj.Id];
            WP7.Assigned_User__c = AU.Id;
            update(WP7);
            
            //WP8
            Project_Status_Control__c WP8 = [select id, Project__c, Assigned_User__c from Project_Status_Control__c where Project__c =: Proj.Id];
            WP8.Assigned_User__c = AU.Id;
            update(WP8);
            
            //WP9
            Budget_Phasing__c WP9 = [select id, Project__c, Assigned_User__c from Budget_Phasing__c where Project__c =: Proj.Id];
            WP9.Assigned_User__c = AU.Id;
            update(WP9);
            
            //WP10
            ITB_Standard__c WP10 = [select id, Project__c, Assigned_User__c from ITB_Standard__c where Project__c =: Proj.Id];
            WP10.Assigned_User__c = AU.Id;
            update(WP10);
            
            //WP11
            CCE_Approval_Process__c WP11 = [select id, Project__c, Assigned_User__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            WP11.Assigned_User__c = AU.Id;
            update(WP11);
            
            //WP12
            Engineering_Standard__c WP12 = [select id, Project__c, Assigned_User__c from Engineering_Standard__c where Project__c =: Proj.Id];
            WP12.Assigned_User__c = AU.Id;
            update(WP12);
            
            //WP13
            Deliverable_List__c WP13 = [select id, Project__c, Assigned_User__c from Deliverable_List__c where Project__c =: Proj.Id];
            WP13.Assigned_User__c = AU.Id;
            update(WP13);
            
            //WP14
            Document_Distribution_Matrix__c WP14 = [select id, Project__c, Assigned_User__c from Document_Distribution_Matrix__c where Project__c =: Proj.Id];
            WP14.Assigned_User__c = AU.Id;
            update(WP14);
            
            //WP15
            Design_Safety_Standard__c WP15 = [select id, Project__c, Assigned_User__c from Design_Safety_Standard__c where Project__c =: Proj.Id];
            WP15.Assigned_User__c = AU.Id;
            update(WP15);
                    } 
        
    }
    
    public static TestMethod void AllWorkProcesses16To32() {
        
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
            
            Assigned_User__c AU = new Assigned_User__c();
            AU.Project__c = Proj.Id;
            AU.User__c = u.Id;
            insert(AU);
        
            //WP16
            Cost_Estimate__c WP16 = [select id, Project__c, Assigned_User__c from Cost_Estimate__c where Project__c =: Proj.Id];
            WP16.Assigned_User__c = AU.Id;
            update(WP16);
            
            //WP17
            Engineering_Data_Book_and_3D_Model__c WP17 = [select id, Project__c, Assigned_User__c from Engineering_Data_Book_and_3D_Model__c where Project__c =: Proj.Id];
            WP17.Assigned_User__c = AU.Id;
            update(WP17);
            
            //WP18
            ITB_Standard_18__c WP18 = [select id, Project__c, Assigned_User__c from ITB_Standard_18__c where Project__c =: Proj.Id];
            WP18.Assigned_User__c = AU.Id;
            update(WP18);
            
            //WP19
            CCE_Approval_Process_19__c WP19 = [select id, Project__c, Assigned_User__c from CCE_Approval_Process_19__c where Project__c =: Proj.Id];
            WP19.Assigned_User__c = AU.Id;
            update(WP19);
            
            //WP20
            Project_Procurement_Contract_Mgmt__c WP20 = [select id, Project__c, Assigned_User__c from Project_Procurement_Contract_Mgmt__c where Project__c =: Proj.Id];
            WP20.Assigned_User__c = AU.Id;
            update(WP20);
            
            //WP21
            Vendor_Data_Management__c WP21 = [select id, Project__c, Assigned_User__c from Vendor_Data_Management__c where Project__c =: Proj.Id];
            WP21.Assigned_User__c = AU.Id;
            update(WP21);
            
            //WP22
            Material_Inspection_FAT_SAT__c WP22 = [select id, Project__c, Assigned_User__c from Material_Inspection_FAT_SAT__c where Project__c =: Proj.Id];
            WP22.Assigned_User__c = AU.Id;
            update(WP22);
            
            //WP23
            Surplus_Spar_part_Management__c WP23 = [select id, Project__c, Assigned_User__c from Surplus_Spar_part_Management__c where Project__c =: Proj.Id];
            WP23.Assigned_User__c = AU.Id;
            update(WP23);
            
            //WP24
            Construction_Management__c WP24 = [select id, Project__c, Assigned_User__c from Construction_Management__c where Project__c =: Proj.Id];
            WP24.Assigned_User__c = AU.Id;
            update(WP24);
            
            //WP25
            Budget_Change_Control__c WP25 = [select id, Project__c, Assigned_User__c from Budget_Change_Control__c where Project__c =: Proj.Id];
            WP25.Assigned_User__c = AU.Id;
            update(WP25);
            
            //WP26
            System_Test_Pack_Identification__c WP26 = [select id, Project__c, Assigned_User__c from System_Test_Pack_Identification__c where Project__c =: Proj.Id];
            WP26.Assigned_User__c = AU.Id;
            update(WP26);
            
            //WP27
            Punch_List_Management_System__c WP27 = [select id, Project__c, Assigned_User__c from Punch_List_Management_System__c where Project__c =: Proj.Id];
            WP27.Assigned_User__c = AU.Id;
            update(WP27);
            
            //WP28
            MC_RSFU__c WP28 = [select id, Project__c, Assigned_User__c from MC_RSFU__c where Project__c =: Proj.Id];
            WP28.Assigned_User__c = AU.Id;
            update(WP28);
            
            //WP29
            MCA__c WP29 = [select id, Project__c, Assigned_User__c from MCA__c where Project__c =: Proj.Id];
            WP29.Assigned_User__c = AU.Id;
            update(WP29);
            
            //WP30
            Close_Out_Report_Lesson_Learnt__c WP30 = [select id, Project__c, Assigned_User__c from Close_Out_Report_Lesson_Learnt__c where Project__c =: Proj.Id];
            WP30.Assigned_User__c = AU.Id;
            update(WP30);
            
            //WP31
            Close_Out_Database__c WP31 = [select id, Project__c, Assigned_User__c from Close_Out_Database__c where Project__c =: Proj.Id];
            WP31.Assigned_User__c = AU.Id;
            update(WP31);
            
            //WP32
            CR_Completion_Report__c WP32 = [select id, Project__c, Assigned_User__c from CR_Completion_Report__c where Project__c =: Proj.Id];
            WP32.Assigned_User__c = AU.Id;
            update(WP32);
            
            //WP00
            Project_Risk_Assessment__c WP00 = [select id, Project__c, Assigned_User__c from Project_Risk_Assessment__c where Project__c =: Proj.Id];
            WP00.Assigned_User__c = AU.Id;
            update(WP00);
            
        } 
        
    }
        
    public static TestMethod void AllWorkProcesses16To32ForServiceRequisition() {
        
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
        
            Assigned_User__c AU = new Assigned_User__c();
            AU.Project__c = Proj.Id;
            AU.User__c = u.Id;
            insert(AU);
        
            
            //WP4
            Project_Execution_Plan__c WP4 = [select id, Project__c, Assigned_User__c from Project_Execution_Plan__c where Project__c =: Proj.Id];
            WP4.Assigned_User__c = AU.Id;
            WP4.Service_Requisition__c = 'EPC';
            update(WP4);
            
            //WP16
            Cost_Estimate__c WP16 = [select id, Project__c, Assigned_User__c from Cost_Estimate__c where Project__c =: Proj.Id];
            WP16.Assigned_User__c = AU.Id;
            update(WP16);
            
            //WP17
            Engineering_Data_Book_and_3D_Model__c WP17 = [select id, Project__c, Assigned_User__c from Engineering_Data_Book_and_3D_Model__c where Project__c =: Proj.Id];
            WP17.Assigned_User__c = AU.Id;
            update(WP17);
            
            //WP18
            ITB_Standard_18__c WP18 = [select id, Project__c, Assigned_User__c from ITB_Standard_18__c where Project__c =: Proj.Id];
            WP18.Assigned_User__c = AU.Id;
            update(WP18);
            
            //WP19
            CCE_Approval_Process_19__c WP19 = [select id, Project__c, Assigned_User__c from CCE_Approval_Process_19__c where Project__c =: Proj.Id];
            WP19.Assigned_User__c = AU.Id;
            update(WP19);
            
            //WP20
            Project_Procurement_Contract_Mgmt__c WP20 = [select id, Project__c, Assigned_User__c from Project_Procurement_Contract_Mgmt__c where Project__c =: Proj.Id];
            WP20.Assigned_User__c = AU.Id;
            update(WP20);
            
            //WP21
            Vendor_Data_Management__c WP21 = [select id, Project__c, Assigned_User__c from Vendor_Data_Management__c where Project__c =: Proj.Id];
            WP21.Assigned_User__c = AU.Id;
            update(WP21);
            
            //WP22
            Material_Inspection_FAT_SAT__c WP22 = [select id, Project__c, Assigned_User__c from Material_Inspection_FAT_SAT__c where Project__c =: Proj.Id];
            WP22.Assigned_User__c = AU.Id;
            update(WP22);
            
            //WP23
            Surplus_Spar_part_Management__c WP23 = [select id, Project__c, Assigned_User__c from Surplus_Spar_part_Management__c where Project__c =: Proj.Id];
            WP23.Assigned_User__c = AU.Id;
            update(WP23);
            
            //WP24
            Construction_Management__c WP24 = [select id, Project__c, Assigned_User__c from Construction_Management__c where Project__c =: Proj.Id];
            WP24.Assigned_User__c = AU.Id;
            update(WP24);
            
            //WP25
            Budget_Change_Control__c WP25 = [select id, Project__c, Assigned_User__c from Budget_Change_Control__c where Project__c =: Proj.Id];
            WP25.Assigned_User__c = AU.Id;
            update(WP25);
            
            //WP26
            System_Test_Pack_Identification__c WP26 = [select id, Project__c, Assigned_User__c from System_Test_Pack_Identification__c where Project__c =: Proj.Id];
            WP26.Assigned_User__c = AU.Id;
            update(WP26);
            
            //WP27
            Punch_List_Management_System__c WP27 = [select id, Project__c, Assigned_User__c from Punch_List_Management_System__c where Project__c =: Proj.Id];
            WP27.Assigned_User__c = AU.Id;
            update(WP27);
            
            //WP28
            MC_RSFU__c WP28 = [select id, Project__c, Assigned_User__c from MC_RSFU__c where Project__c =: Proj.Id];
            WP28.Assigned_User__c = AU.Id;
            update(WP28);
            
            //WP29
            MCA__c WP29 = [select id, Project__c, Assigned_User__c from MCA__c where Project__c =: Proj.Id];
            WP29.Assigned_User__c = AU.Id;
            update(WP29);
            
            //WP30
            Close_Out_Report_Lesson_Learnt__c WP30 = [select id, Project__c, Assigned_User__c from Close_Out_Report_Lesson_Learnt__c where Project__c =: Proj.Id];
            WP30.Assigned_User__c = AU.Id;
            update(WP30);
            
            //WP31
            Close_Out_Database__c WP31 = [select id, Project__c, Assigned_User__c from Close_Out_Database__c where Project__c =: Proj.Id];
            WP31.Assigned_User__c = AU.Id;
            update(WP31);
            
            //WP32
            CR_Completion_Report__c WP32 = [select id, Project__c, Assigned_User__c from CR_Completion_Report__c where Project__c =: Proj.Id];
            WP32.Assigned_User__c = AU.Id;
            update(WP32);
            
            //WP00
            Project_Risk_Assessment__c WP00 = [select id, Project__c, Assigned_User__c from Project_Risk_Assessment__c where Project__c =: Proj.Id];
            WP00.Assigned_User__c = AU.Id;
            update(WP00);
            
        } 
        
    }
    
}