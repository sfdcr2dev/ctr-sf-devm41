/* Class for Project from Trigger */
public with sharing class CPEM_ProjectForTriggerController {

    public static void CreateProject(Project__c proj) {
        
        Id SMEWP1;
        Id SMEWP2;
        Id SMEWP3;
        Id SMEWP4;
        Id SMEWP5;
        Id SMEWP6;
        Id SMEWP7;
        Id SMEWP8;
        Id SMEWP9;
        Id SMEWP10;
        Id SMEWP11;
        Id SMEWP12;
        Id SMEWP13;
        Id SMEWP14;
        Id SMEWP15;
        Id SMEWP16;
        Id SMEWP17;
        Id SMEWP18;
        Id SMEWP19;
        Id SMEWP20;
        Id SMEWP21;
        Id SMEWP22;
        Id SMEWP23;
        Id SMEWP24;
        Id SMEWP25;
        Id SMEWP26;
        Id SMEWP27;
        Id SMEWP28;
        Id SMEWP29;
        Id SMEWP30;
        Id SMEWP31;
        Id SMEWP32;
        Id SMEWP00;
        
        Id BRTWP1;
        Id BRTWP2;
        Id BRTWP3;
        Id BRTWP4;
        Id BRTWP5;
        Id BRTWP6;
        Id BRTWP7;
        Id BRTWP8;
        Id BRTWP9;
        Id BRTWP10;
        Id BRTWP11;
        Id BRTWP12;
        Id BRTWP13;
        Id BRTWP14;
        Id BRTWP15;
        Id BRTWP16;
        Id BRTWP17;
        Id BRTWP18;
        Id BRTWP19;
        Id BRTWP20;
        Id BRTWP21;
        Id BRTWP22;
        Id BRTWP23;
        Id BRTWP24;
        Id BRTWP25;
        Id BRTWP26;
        Id BRTWP27;
        Id BRTWP28;
        Id BRTWP29;
        Id BRTWP30;
        Id BRTWP31;
        Id BRTWP32;
        Id BRTWP00;
        
        List<Project__c> existedProjects = [select id, name from Project__c where (Name =: proj.Name OR Project_Number__c =: proj.Project_Number__c)];
        
        if(existedProjects.size() > 1) {
            proj.addError('Please check your Project Name or Project Number, The following Project Name or Project Number has been used.');
        }
        
        //Get After Record Type
        List<RecordType> BETs = [select id, name, developername from RecordType where DeveloperName like '%Before_Submit%'];
        for(RecordType BET : BETs) {
            if(BET.Name == 'Step 1 : Before Submit') {
                BRTWP1 = BET.Id;
            }
            if(BET.Name == 'Step 2 : Before Submit') {
                BRTWP2 = BET.Id;
            }
            if(BET.Name == 'Step 3 : Before Submit') {
                BRTWP3 = BET.Id;
            }
            if(BET.Name == 'Step 4 : Before Submit') {
                BRTWP4 = BET.Id;
            }
            if(BET.Name == 'Step 5 : Before Submit') {
                BRTWP5 = BET.Id;
            }
            if(BET.Name == 'Step 6 : Before Submit') {
                BRTWP6 = BET.Id;
            }
            if(BET.Name == 'Step 7 : Before Submit') {
                BRTWP7 = BET.Id;
            }
            if(BET.Name == 'Step 8 : Before Submit') {
                BRTWP8 = BET.Id;
            }
            if(BET.Name == 'Step 9 : Before Submit') {
                BRTWP9 = BET.Id;
            }
            if(BET.Name == 'Step 10 : Before Submit') {
                BRTWP10 = BET.Id;
            }
            if(BET.Name == 'Step 11 : Before Submit') {
                BRTWP11 = BET.Id;
            }
            if(BET.Name == 'Step 12 : Before Submit') {
                BRTWP12 = BET.Id;
            }
            if(BET.Name == 'Step 13 : Before Submit') {
                BRTWP13 = BET.Id;
            }
            if(BET.Name == 'Step 14 : Before Submit') {
                BRTWP14 = BET.Id;
            }
            if(BET.Name == 'Step 15 : Before Submit') {
                BRTWP15 = BET.Id;
            }
            if(BET.Name == 'Step 16 : Before Submit') {
                BRTWP16 = BET.Id;
            }
            if(BET.Name == 'Step 17 : Before Submit') {
                BRTWP17 = BET.Id;
            }
            if(BET.Name == 'Step 18 : Before Submit') {
                BRTWP18 = BET.Id;
            }
            if(BET.Name == 'Step 19 : Before Submit') {
                BRTWP19 = BET.Id;
            }
            if(BET.Name == 'Step 20 : Before Submit') {
                BRTWP20 = BET.Id;
            }
            if(BET.Name == 'Step 21 : Before Submit') {
                BRTWP21 = BET.Id;
            }
            if(BET.Name == 'Step 22 : Before Submit') {
                BRTWP22 = BET.Id;
            }
            if(BET.Name == 'Step 23 : Before Submit') {
                BRTWP23 = BET.Id;
            }
            if(BET.Name == 'Step 24 : Before Submit') {
                BRTWP24 = BET.Id;
            }
            if(BET.Name == 'Step 25 : Before Submit') {
                BRTWP25 = BET.Id;
            }
            if(BET.Name == 'Step 26 : Before Submit') {
                BRTWP26 = BET.Id;
            }
            if(BET.Name == 'Step 27 : Before Submit') {
                BRTWP27 = BET.Id;
            }
            if(BET.Name == 'Step 28 : Before Submit') {
                BRTWP28 = BET.Id;
            }
            if(BET.Name == 'Step 29 : Before Submit') {
                BRTWP29 = BET.Id;
            }
            if(BET.Name == 'Step 30 : Before Submit') {
                BRTWP30 = BET.Id;
            }
            if(BET.Name == 'Step 31 : Before Submit') {
                BRTWP31 = BET.Id;
            }
            if(BET.Name == 'Step 32 : Before Submit') {
                BRTWP32 = BET.Id;
            }
            if(BET.Name == 'Step 00 : Before Submit') {
                BRTWP00 = BET.Id;
            }
        }
        
        //Get SME from Master Data
        Master_Data__c MD = [select id from Master_Data__c where Name = 'SME and Guideline'];
        List<Master_Data_Detail__c> MDDs = [select id, Work_Process_No__c , SME__c from Master_Data_Detail__c where Master_Data__c =: MD.Id];
        
        for(Master_Data_Detail__c MDD : MDDs) {
            if(MDD.Work_Process_No__c == 0) {
                SMEWP00 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 1) {
                SMEWP1 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 2) {
                SMEWP2 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 3) {
                SMEWP3 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 4) {
                SMEWP4 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 5) {
                SMEWP5 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 6) {
                SMEWP6 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 7) {
                SMEWP7 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 8) {
                SMEWP8 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 9) {
                SMEWP9 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 10) {
                SMEWP10 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 11) {
                SMEWP11 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 12) {
                SMEWP12 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 13) {
                SMEWP13 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 14) {
                SMEWP14 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 15) {
                SMEWP15 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 16) {
                SMEWP16 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 17) {
                SMEWP17 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 18) {
                SMEWP18 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 19) {
                SMEWP19 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 20) {
                SMEWP20 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 21) {
                SMEWP21 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 22) {
                SMEWP22 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 23) {
                SMEWP23 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 24) {
                SMEWP24 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 25) {
                SMEWP25 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 26) {
                SMEWP26 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 27) {
                SMEWP27 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 28) {
                SMEWP28 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 29) {
                SMEWP29 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 30) {
                SMEWP30 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 31) {
                SMEWP31 = MDD.SME__c;
            }
            if(MDD.Work_Process_No__c == 32) {
                SMEWP32 = MDD.SME__c;
            }
        }
        
        //Create Work Process 1
        Project_Charter__c WP1 = new Project_Charter__c();
        WP1.Project__c = proj.Id;
        //WP1.Name = 'Project Charter';
        WP1.SME__c = SMEWP1;
        WP1.RecordTypeId = BRTWP1;
        insert(WP1);
        
        //Create Work Process 2
        Project_Organization__c WP2 = new Project_Organization__c();
        WP2.Project__c = proj.Id;
        //WP2.Name = 'Project Organization';
        WP2.SME__c = SMEWP2;
        WP2.RecordTypeId = BRTWP2;
        insert(WP2);
        
        //Create Work Process 3
        Lesson_Learnt_Review__c WP3 = new Lesson_Learnt_Review__c();
        WP3.Project__c = proj.Id;
        //WP3.Name = 'Lesson Learnt Review';
        WP3.SME__c = SMEWP3;
        WP3.RecordTypeId = BRTWP3;
        insert(WP3);
        
        //Create Work Process 4
        Project_Execution_Plan__c WP4 = new Project_Execution_Plan__c();
        WP4.Project__c = proj.Id;
        //WP4.Name = 'Project Execution Plan';
        WP4.SME__c = SMEWP4;
        WP4.RecordTypeId = BRTWP4;
        insert(WP4);
        
        //Create Work Process 5
        Project_Procurement_Plan__c WP5 = new Project_Procurement_Plan__c();
        WP5.Project__c = proj.Id;
        //WP5.Name = 'Project Procurement Plan';
        WP5.SME__c = SMEWP5;
        WP5.RecordTypeId = BRTWP5;
        insert(WP5);
        
        //Create Work Process 6
        WBS_CBS__c WP6 = new WBS_CBS__c();
        WP6.Project__c = proj.Id;
        //WP6.Name = 'WBS and CBS';
        WP6.SME__c = SMEWP6;
        WP6.RecordTypeId = BRTWP6;
        insert(WP6);
        
        //Work Process 7
        Schedule__c WP7 = new Schedule__c();
        WP7.Project__c = proj.Id;
        //WP7.Name = 'Schedule';
        WP7.SME__c = SMEWP7;
        WP7.RecordTypeId = BRTWP7;
        insert(WP7);
        
        //Work Process 8
        Project_Status_Control__c WP8 = new Project_Status_Control__c();
        WP8.Project__c = proj.Id;
        //WP8.Name = 'Project Status Control';
        WP8.SME__c = SMEWP8;
        WP8.RecordTypeId = BRTWP8;
        insert(WP8);
        
        //Work Process 9
        Budget_Phasing__c WP9 = new Budget_Phasing__c();
        WP9.Project__c = proj.Id;
        //WP9.Name = 'Budget Phasing';
        WP9.SME__c = SMEWP9;
        WP9.RecordTypeId = BRTWP9;
        insert(WP9);
        
        //Work Process 10
        ITB_Standard__c WP10 = new ITB_Standard__c();
        WP10.Project__c = proj.Id;
        //WP10.Name = 'ITB Standard';
        WP10.SME__c = SMEWP10;
        WP10.RecordTypeId = BRTWP10;
        insert(WP10);
        
        //Work Process 11
        CCE_Approval_Process__c WP11 = new CCE_Approval_Process__c();
        WP11.Project__c = proj.Id;
        //WP11.Name = 'CCE Approval Process';
        WP11.SME__c = SMEWP11;
        WP11.RecordTypeId = BRTWP11;
        insert(WP11);
        
        //Work Process 12
        Engineering_Standard__c WP12 = new Engineering_Standard__c();
        WP12.Project__c = proj.Id;
        //WP12.Name = 'Engineering Standard';
        WP12.SME__c = SMEWP12;
        WP12.RecordTypeId = BRTWP12;
        insert(WP12);
        
        //Work Process 13
        Deliverable_List__c WP13 = new Deliverable_List__c();
        WP13.Project__c = proj.Id;
        //WP13.Name = 'Deliverable List';
        WP13.SME__c = SMEWP13;
        WP13.RecordTypeId = BRTWP13;
        insert(WP13);
        
        //Work Process 14
        Document_Distribution_Matrix__c WP14 = new Document_Distribution_Matrix__c();
        WP14.Project__c = proj.Id;
        //WP14.Name = 'Document Distribution Matrix';
        WP14.SME__c = SMEWP14;
        WP14.RecordTypeId = BRTWP14;
        insert(WP14);
        
        //Work Process 15
        Design_Safety_Standard__c WP15 = new Design_Safety_Standard__c ();
        WP15.Project__c = proj.Id;
        //WP15.Name = 'Design Safety Standard';
        WP15.SME__c = SMEWP15;
        WP15.RecordTypeId = BRTWP15;
        insert(WP15);
        
        //Work Process 16
        Cost_Estimate__c WP16 = new Cost_Estimate__c();
        WP16.Project__c = proj.Id;
        //WP16.Name = 'Cost Estimate';
        WP16.SME__c = SMEWP16;
        WP16.RecordTypeId = BRTWP16;
        insert(WP16);
        
        //Work Process 17
        Engineering_Data_Book_and_3D_Model__c WP17 = new Engineering_Data_Book_and_3D_Model__c();
        WP17.Project__c = proj.Id;
        //WP17.Name = 'Engineering Data Book & 3D Model';
        WP17.SME__c = SMEWP17;
        WP17.RecordTypeId = BRTWP17;
        insert(WP17);
        
        //Work Process 18
        ITB_Standard_18__c WP18 = new ITB_Standard_18__c();
        WP18.Project__c = proj.Id;
        //WP18.Name = 'ITB Standard';
        WP18.SME__c = SMEWP18;
        WP18.RecordTypeId = BRTWP18;
        insert(WP18);
        
        //Work Process 19
        CCE_Approval_Process_19__c WP19 = new CCE_Approval_Process_19__c();
        WP19.Project__c = proj.Id;
        //WP19.Name = 'CCE Approval Process';
        WP19.SME__c = SMEWP19;
        WP19.RecordTypeId = BRTWP19;
        insert(WP19);
        
        //Work Process 20
        Project_Procurement_Contract_Mgmt__c WP20 = new Project_Procurement_Contract_Mgmt__c();
        WP20.Project__c = proj.Id;
        //WP20.Name = 'Project Procurement Contract Management';
        WP20.SME__c = SMEWP20;
        WP20.RecordTypeId = BRTWP20;
        insert(WP20);
        
        //Work Process 21
        Vendor_Data_Management__c WP21 = new Vendor_Data_Management__c();
        WP21.Project__c = proj.Id;
        //WP21.Name = 'Vendor Data Management';
        WP21.SME__c = SMEWP21;
        WP21.RecordTypeId = BRTWP21;
        insert(WP21);
        
        //Work Process 22
        Material_Inspection_FAT_SAT__c WP22 = new Material_Inspection_FAT_SAT__c ();
        WP22.Project__c = proj.Id;
        //WP22.Name = 'Material Inspection (FAT/SAT)';
        WP22.SME__c = SMEWP22;
        WP22.RecordTypeId = BRTWP22;
        insert(WP22);
        
        //Work Process 23
        Surplus_Spar_part_Management__c WP23 = new Surplus_Spar_part_Management__c();
        WP23.Project__c = proj.Id;
        //WP23.Name = 'Surplus & Spar-part Management';
        WP23.SME__c = SMEWP23;
        WP23.RecordTypeId = BRTWP23;
        //WP23.Two_Year_Spare_Part_Spir__c = false;
        //WP23.Initial_and_Commissioning__c = false;
        insert(WP23);
        
        //Work Process 24
        Construction_Management__c WP24 = new Construction_Management__c();
        WP24.Project__c = proj.Id;
        //WP24.Name = 'Construction Management';
        WP24.SME__c = SMEWP24;
        WP24.RecordTypeId = BRTWP24;
        insert(WP24);
        
        //Work Process 25
        Budget_Change_Control__c WP25 = new Budget_Change_Control__c();
        WP25.Project__c = proj.Id;
        //WP25.Name = 'Budget & Change Control';
        WP25.SME__c = SMEWP25;
        WP25.RecordTypeId = BRTWP25;
        insert(WP25);
        
        //Work Process 26
        System_Test_Pack_Identification__c WP26 = new System_Test_Pack_Identification__c();
        WP26.Project__c = proj.Id;
        //WP26.Name = 'System & Test-Pack Identification';
        WP26.SME__c = SMEWP26;
        WP26.RecordTypeId = BRTWP26;
        insert(WP26);
        
        //Work Process 27
        Punch_List_Management_System__c WP27 = new Punch_List_Management_System__c();
        WP27.Project__c = proj.Id;
        //WP27.Name = 'Punch List Management System';
        WP27.SME__c = SMEWP27;
        WP27.RecordTypeId = BRTWP27;
        insert(WP27);
        
        //Work Process 28
        MC_RSFU__c WP28 = new MC_RSFU__c();
        WP28.Project__c = proj.Id;
        //WP28.Name = 'MC & RSFU';
        WP28.SME__c = SMEWP28;
        WP28.RecordTypeId = BRTWP28;
        insert(WP28);
        
        //Work Process 29
        MCA__c WP29 = new MCA__c();
        WP29.Project__c = proj.Id;
        WP29.SME__c = SMEWP29;
        //WP29.Name = 'MCA';
        WP29.RecordTypeId = BRTWP29;
        insert(WP29);
        
        //Work Process 30
        Close_Out_Report_Lesson_Learnt__c WP30 = new Close_Out_Report_Lesson_Learnt__c();
        WP30.Project__c = proj.Id;
        //WP30.Name = 'Close Out Report and Lesson Learnt';
        WP30.SME__c = SMEWP30;
        WP30.RecordTypeId = BRTWP30;
        insert(WP30);
        
        //Work Process 31
        Close_Out_Database__c WP31 = new Close_Out_Database__c();
        WP31.Project__c = proj.Id;
        //WP31.Name = 'Close Out Database';
        WP31.SME__c = SMEWP31;
        WP31.RecordTypeId = BRTWP31;
        insert(WP31);
        
        //Work Process 32
        CR_Completion_Report__c WP32 = new CR_Completion_Report__c();
        WP32.Project__c = proj.Id;
        //WP32.Name = 'CR (Completion Report)';
        WP32.SME__c = SMEWP32;
        WP32.RecordTypeId = BRTWP32;
        insert(WP32);
        
        //Work Process 00
        Project_Risk_Assessment__c WP00 = new Project_Risk_Assessment__c();
        WP00.Project__c = proj.Id;
        //WP00.Name = 'Project Risk Assessment';
        WP00.SME__c = SMEWP00;
        WP00.RecordTypeId = BRTWP00;
        insert(WP00);
        
        //Update Project
        Project__c updateProject = [select id, BE_WP1_ID__c, BE_WP2_ID__c, BE_WP3_ID__c, BE_WP4_ID__c, BE_WP5_ID__c, BE_WP6_ID__c, BE_WP7_ID__c,
                                    BE_WP8_ID__c, BE_WP9_ID__c, BE_WP10_ID__c, BE_WP11_ID__c, BE_WP12_ID__c, BE_WP13_ID__c, BE_WP14_ID__c, BE_WP15_ID__c,
                                    BE_WP16_ID__c, BE_WP17_ID__c, BE_WP18_ID__c, BE_WP19_ID__c, BE_WP20_ID__c, BE_WP21_ID__c, BE_WP22_ID__c, BE_WP23_ID__c,
                                    BE_WP24_ID__c, BE_WP25_ID__c, BE_WP26_ID__c, BE_WP27_ID__c, BE_WP28_ID__c, BE_WP29_ID__c, BE_WP30_ID__c,
                                    BE_WP31_ID__c, BE_WP32_ID__c from Project__c where Id =: proj.Id];
        
        updateProject.BE_WP1_ID__c = WP1.Id;
        updateProject.BE_WP2_ID__c = WP2.Id;
        updateProject.BE_WP3_ID__c = WP3.Id;
        updateProject.BE_WP4_ID__c = WP4.Id;
        updateProject.BE_WP5_ID__c = WP5.Id;
        updateProject.BE_WP6_ID__c = WP6.Id;
        updateProject.BE_WP7_ID__c = WP7.Id;
        updateProject.BE_WP8_ID__c = WP8.Id;
        updateProject.BE_WP9_ID__c = WP9.Id;
        updateProject.BE_WP10_ID__c = WP10.Id;
        updateProject.BE_WP11_ID__c = WP11.Id;
        updateProject.BE_WP12_ID__c = WP12.Id;
        updateProject.BE_WP13_ID__c = WP13.Id;
        updateProject.BE_WP14_ID__c = WP14.Id;
        updateProject.BE_WP15_ID__c = WP15.Id;
        updateProject.BE_WP16_ID__c = WP16.Id;
        updateProject.BE_WP17_ID__c = WP17.Id;
        updateProject.BE_WP18_ID__c = WP18.Id;
        updateProject.BE_WP19_ID__c = WP19.Id;
        updateProject.BE_WP20_ID__c = WP20.Id;
        updateProject.BE_WP21_ID__c = WP21.Id;
        updateProject.BE_WP22_ID__c = WP22.Id;
        updateProject.BE_WP23_ID__c = WP23.Id;
        updateProject.BE_WP24_ID__c = WP24.Id;
        updateProject.BE_WP25_ID__c = WP25.Id;
        updateProject.BE_WP26_ID__c = WP26.Id;
        updateProject.BE_WP27_ID__c = WP27.Id;
        updateProject.BE_WP28_ID__c = WP28.Id;
        updateProject.BE_WP29_ID__c = WP29.Id;
        updateProject.BE_WP30_ID__c = WP30.Id;
        updateProject.BE_WP31_ID__c = WP31.Id;
        updateProject.BE_WP32_ID__c = WP32.Id;
        update(updateProject);
    }
}