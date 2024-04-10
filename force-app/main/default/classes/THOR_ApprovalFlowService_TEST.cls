@isTest
public with sharing class THOR_ApprovalFlowService_TEST {
    @TestSetup
    static void makeData() {
        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName, Form_Code__c
            FROM Checked_Sheet_Pointer__mdt
            WHERE DeveloperName LIKE '%Tank%'
            LIMIT 1
        ];
        
        Checked_Sheet_Pointer__mdt enmm_001 = [
            SELECT Id, MasterLabel, DeveloperName, Form_Code__c
            FROM Checked_Sheet_Pointer__mdt
            WHERE Form_Code__c = 'EQCC-ENMM-001'
            LIMIT 1
        ];
        Checked_Sheet_Pointer__mdt enrm_002 = [
            SELECT Id, MasterLabel, DeveloperName, Form_Code__c
            FROM Checked_Sheet_Pointer__mdt
            WHERE Form_Code__c = 'EQCC-ENRM-002'
            LIMIT 1
        ];
        Checked_Sheet_Pointer__mdt enrm_006 = [
            SELECT Id, MasterLabel, DeveloperName, Form_Code__c
            FROM Checked_Sheet_Pointer__mdt
            WHERE Form_Code__c = 'EQCC-ENRM-006'
            LIMIT 1
        ];
        
        // DGMO
        Checked_Sheet_Pointer__mdt enem_4005 = [
            SELECT Id, MasterLabel, DeveloperName, Form_Code__c
            FROM Checked_Sheet_Pointer__mdt
            WHERE Form_Code__c like 'ENEM-QFR-4005'
            LIMIT 1
        ];
        
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;
        
        Master_Map__c mm = new Master_Map__c();
        mm.Name = 'ENMA-E';
        mm.Code__c = 'ENMA-E';
        mm.Description__c = 'TPX ELECTRICAL AREA-F';
        mm.Type__c = 'Main Work Center';
        mm.Master_Map_Set__c = mms.Id;
        insert mm;
        
        Master_Map__c mm2 = new Master_Map__c();
        mm2.Name = '1200';
        mm2.Code__c = '1200';
        mm2.Description__c = 'TOP Sriracha Refinery';
        mm2.Type__c = 'Plant';
        mm2.Master_Map_Set__c = mms.Id;
        insert mm2;
        
        Functional_Location__c fl = new Functional_Location__c();
        fl.Name = '1234';
        fl.PlantSection__c = 'T1';
        fl.MainWorkCenter__c = mm.Id;
        fl.Maintenance_Plant__c = mm2.Id;
        insert fl;

        Equipment__c eq = new Equipment__c();
        eq.Name = '1234';
        eq.plantSection__c = 'T1';
        eq.mainWorkCenter__c = mm.Id;
        eq.maintenancePlant__c = mm2.Id;
        insert eq;
        
        EQCC_Header__c header = new EQCC_Header__c();
        header.FunctionalLocation__c = fl.Id;
        insert header;
        
        EQCC_Header__c header1 = new EQCC_Header__c();
        header1.FunctionalLocation__c = fl.Id;
        insert header1;
        
        EQCC_Header__c header2 = new EQCC_Header__c();
        header2.Equipment__c = eq.Id;
        insert header2;

        EQCC_Checked_Sheet__c checkedSheetToSubmit = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval',
            Form_Type__c = formType.DeveloperName,
            Sheet_Code__c = formType.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmit;

        EQCC_Checked_Sheet__c checkedSheetToApprove = new EQCC_Checked_Sheet__c(
            Name = 'Approve EQCC',
            Form_Type__c = formType.DeveloperName,
            Sheet_Code__c = formType.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheetToApprove;

        EQCC_Checked_Sheet__c checkedSheetToReject = new EQCC_Checked_Sheet__c(
            Name = 'Reject EQCC',
            Form_Type__c = formType.DeveloperName,
            Sheet_Code__c = formType.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheetToReject;

        EQCC_Checked_Sheet__c checkedSheetToSubmit1 = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval1',
            Form_Type__c = 'EQCC-ENRM-007',
            Sheet_Code__c = 'EQCC-ENRM-007',
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmit1;
        /*EQCC_Checked_Sheet__c checkedSheetToApprove1 = new EQCC_Checked_Sheet__c(
            Name = 'Approve EQCC2',
            Form_Type__c = 'EQCC-ENRM-007',
            Sheet_Code__c = 'EQCC-ENRM-007'
        );
        insert checkedSheetToApprove1;

        EQCC_Checked_Sheet__c checkedSheetToReject1 = new EQCC_Checked_Sheet__c(
            Name = 'Reject EQCC2',
            Form_Type__c = 'EQCC-ENRM-007',
            Sheet_Code__c = 'EQCC-ENRM-007'
        );
        insert checkedSheetToReject1;*/
        
        EQCC_Checked_Sheet__c checkedSheetToSubmit2 = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval2',
            Form_Type__c = enrm_002.DeveloperName,
            Sheet_Code__c = enrm_002.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmit2;
        EQCC_Checked_Sheet__c checkedSheetToApprove2 = new EQCC_Checked_Sheet__c(
            Name = 'Approve EQCC2',
            Form_Type__c = enrm_002.DeveloperName,
            Sheet_Code__c = enrm_002.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheetToApprove2;

        EQCC_Checked_Sheet__c checkedSheetToReject2 = new EQCC_Checked_Sheet__c(
            Name = 'Reject EQCC2',
            Form_Type__c = enrm_002.DeveloperName,
            Sheet_Code__c = enrm_002.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheetToReject2;
        
        EQCC_Checked_Sheet__c checkedSheetToSubmit9 = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval9',
            Form_Type__c = enrm_006.DeveloperName,
            Sheet_Code__c = enrm_006.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmit9;
        
        EQCC_Checked_Sheet__c checkedSheetToApprove9 = new EQCC_Checked_Sheet__c(
            Name = 'Approve EQCC9',
            Form_Type__c = enrm_006.DeveloperName,
            Sheet_Code__c = enrm_006.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheetToApprove9;

        EQCC_Checked_Sheet__c checkedSheetToReject9 = new EQCC_Checked_Sheet__c(
            Name = 'Reject EQCC9',
            Form_Type__c = enrm_006.DeveloperName,
            Sheet_Code__c = enrm_006.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheetToReject9;
        
        EQCC_Checked_Sheet__c checkedSheetToSubmitForm001 = new EQCC_Checked_Sheet__c(
            Name = 'Submit form ENMM-001',
            Form_Type__c = enmm_001.DeveloperName,
            Sheet_Code__c = enmm_001.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmitForm001;
        
        // DGMO
        EQCC_Checked_Sheet__c checkedSheet4005 = new EQCC_Checked_Sheet__c(
            Name = 'Submit for 4005',
            Form_Type__c = enem_4005.DeveloperName,
            Sheet_Code__c = enem_4005.Form_Code__c,
            Form_Questions__c = 1
        );
        insert checkedSheet4005;
        
        EQCC_Checked_Sheet__c checkedSheetToSubmit3 = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval3',
            Form_Type__c = 'ENIM-QFR-006',
            Sheet_Code__c = 'ENIM-QFR-006',
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmit3;
        
        
        EQCC_Checked_Sheet__c checkedSheetToSubmit4 = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval4',
            Form_Type__c = 'EQCC-ENRM-004',
            Sheet_Code__c = 'EQCC-ENRM-004',
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmit4;
        
        EQCC_Checked_Sheet__c checkedSheetToSubmit5 = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval5',
            Form_Type__c = 'ENEM-QFR-9050-GNR',
            Sheet_Code__c = 'ENEM-QFR-9050-GNR',
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmit5;
        
        EQCC_Checked_Sheet__c checkedSheetToSubmit6 = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval6',
            Form_Type__c = 'ENSA-QFR-01',
            Sheet_Code__c = 'ENSA-QFR-01',
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmit6;
        
        EQCC_Checked_Sheet__c checkedSheetToSubmit7 = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval7',
            Form_Type__c = 'ENEM-QFR-2604-REL',
            Sheet_Code__c = 'ENEM-QFR-2604-REL',
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmit7;
        
        EQCC_Checked_Sheet__c checkedSheetToSubmit8 = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval8',
            Form_Type__c = 'EQCC-ENRM-001',
            Sheet_Code__c = 'EQCC-ENRM-001',
            Form_Questions__c = 1
        );
        insert checkedSheetToSubmit8;

		List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>{
            new Header_Sheet__c(Header__c = header.Id, Sheet__c = checkedSheetToSubmit.Id),
            new Header_Sheet__c(Header__c = header.Id, Sheet__c = checkedSheetToApprove.Id),
            new Header_Sheet__c(Header__c = header.Id, Sheet__c = checkedSheetToReject.Id),
            new Header_Sheet__c(Header__c = header1.Id, Sheet__c = checkedSheetToSubmit9.Id),
            new Header_Sheet__c(Header__c = header1.Id, Sheet__c = checkedSheetToApprove9.Id),
            new Header_Sheet__c(Header__c = header1.Id, Sheet__c = checkedSheetToReject9.Id),
            new Header_Sheet__c(Header__c = header2.Id, Sheet__c = checkedSheetToSubmit2.Id),
            new Header_Sheet__c(Header__c = header2.Id, Sheet__c = checkedSheetToApprove2.Id),
            new Header_Sheet__c(Header__c = header2.Id, Sheet__c = checkedSheetToReject2.Id),
            new Header_Sheet__c(Header__c = header.Id, Sheet__c = checkedSheet4005.Id) // DGMO
        };
        insert headerSheets;        

        List<EQCC_Step__c> steps = new List<EQCC_Step__c>();

        EQCC_Step__c submitStep = new EQCC_Step__c();
        submitStep.Name = 'submit';
        submitStep.Header_Sheet__c = headerSheets[0].Id;
        submitStep.Step_Number__c = 1;
        submitStep.Form_Code__c = formType.Form_Code__c;
        submitStep.Is_Current__c = true;
        submitStep.Status__c = 'Pending for approval';
        steps.add(submitStep);
        
        EQCC_Step__c submitStep1 = new EQCC_Step__c();
        submitStep1.Name = 'submit1';
        submitStep1.Header_Sheet__c = headerSheets[0].Id;
        submitStep1.Step_Number__c = 1;
        submitStep1.Form_Code__c = 'EQCC-ENRM-007';
        submitStep1.Is_Current__c = true;
        submitStep1.Status__c = 'Pending for approval';
        steps.add(submitStep1);
        
        EQCC_Step__c submitStep2 = new EQCC_Step__c();
        submitStep2.Name = 'submit2';
        submitStep2.Header_Sheet__c = headerSheets[0].Id;
        submitStep2.Step_Number__c = 1;
        submitStep2.Form_Code__c = 'EQCC-ENRM-002';
        submitStep2.Is_Current__c = true;
        submitStep2.Status__c = 'Pending for approval';
        steps.add(submitStep2);
        
        EQCC_Step__c submitStep3 = new EQCC_Step__c();
        submitStep3.Name = 'submit3';
        submitStep3.Header_Sheet__c = headerSheets[0].Id;
        submitStep3.Step_Number__c = 1;
        submitStep3.Form_Code__c = 'ENIM-QFR-006';
        submitStep3.Is_Current__c = true;
        submitStep3.Status__c = 'Pending for approval';
        steps.add(submitStep3);
        
        EQCC_Step__c submitStep4 = new EQCC_Step__c();
        submitStep4.Name = 'submit4';
        submitStep4.Header_Sheet__c = headerSheets[0].Id;
        submitStep4.Step_Number__c = 1;
        submitStep4.Form_Code__c = 'EQCC-ENRM-004';
        submitStep4.Is_Current__c = true;
        submitStep4.Status__c = 'Pending for approval';
        steps.add(submitStep4);
        
        EQCC_Step__c submitStep5 = new EQCC_Step__c();
        submitStep5.Name = 'submit5';
        submitStep5.Header_Sheet__c = headerSheets[0].Id;
        submitStep5.Step_Number__c = 1;
        submitStep5.Form_Code__c = 'ENEM-QFR-9050-GNR';
        submitStep5.Is_Current__c = true;
        submitStep5.Status__c = 'Pending for approval';
        steps.add(submitStep5);
        
        EQCC_Step__c submitStep6 = new EQCC_Step__c();
        submitStep6.Name = 'submit6';
        submitStep6.Header_Sheet__c = headerSheets[0].Id;
        submitStep6.Step_Number__c = 1;
        submitStep6.Form_Code__c = 'ENSA-QFR-01';
        submitStep6.Is_Current__c = true;
        submitStep6.Status__c = 'Pending for approval';
        steps.add(submitStep6);
        
        EQCC_Step__c submitStep7 = new EQCC_Step__c();
        submitStep7.Name = 'submit7';
        submitStep7.Header_Sheet__c = headerSheets[0].Id;
        submitStep7.Step_Number__c = 1;
        submitStep7.Form_Code__c = 'ENEM-QFR-2604-REL';
        submitStep7.Is_Current__c = true;
        submitStep7.Status__c = 'Pending for approval';
        steps.add(submitStep7);
        
        EQCC_Step__c submitStep8 = new EQCC_Step__c();
        submitStep8.Name = 'submit8';
        submitStep8.Header_Sheet__c = headerSheets[0].Id;
        submitStep8.Step_Number__c = 1;
        submitStep8.Form_Code__c = 'EQCC-ENRM-001';
        submitStep8.Is_Current__c = true;
        submitStep8.Status__c = 'Pending for approval';
        steps.add(submitStep8);
        
        EQCC_Step__c submitStep9 = new EQCC_Step__c();
        submitStep9.Name = 'submit9';
        submitStep9.Header_Sheet__c = headerSheets[3].Id;
        submitStep9.Step_Number__c = 1;
        submitStep9.Form_Code__c = 'EQCC-ENRM-006';
        submitStep9.Is_Current__c = true;
        submitStep9.Status__c = 'Pending for approval';
        steps.add(submitStep9);
        
        // DGMO
        EQCC_Step__c submit4005 = new EQCC_Step__c();
        submit4005.Name = 'submit4005';
        submit4005.Header_Sheet__c = headerSheets[9].Id;
        submit4005.Step_Number__c = 1;
        submit4005.Form_Code__c = 'ENEM-QFR-4005';
        submit4005.Is_Current__c = true;
        submit4005.Status__c = 'Pending for approval';
        steps.add(submit4005);
        
        // DGMO
        EQCC_Step__c submit4005_2 = new EQCC_Step__c();
        submit4005_2.Name = 'submit4005';
        submit4005.Header_Sheet__c = headerSheets[9].Id;
        submit4005_2.Step_Number__c = 2;
        submit4005_2.Form_Code__c = 'ENEM-QFR-4005';
        submit4005_2.Is_Current__c = true;
        submit4005_2.Status__c = 'Pending for approval';
        steps.add(submit4005_2);
        
        EQCC_Step__c approveStep = new EQCC_Step__c();
        approveStep.Name = 'approve';
        approveStep.Header_Sheet__c = headerSheets[1].Id;
        approveStep.Step_Number__c = 1;
        approveStep.Form_Code__c = formType.Form_Code__c;
        approveStep.Is_Current__c = true;
        approveStep.Status__c = 'Pending for approval';
        steps.add(approveStep);

        EQCC_Step__c rejectStep = new EQCC_Step__c();
        rejectStep.Name = 'reject';
        rejectStep.Header_Sheet__c = headerSheets[2].Id;
        rejectStep.Step_Number__c = 1;
        rejectStep.Form_Code__c = formType.Form_Code__c;
        rejectStep.Is_Current__c = true;
        rejectStep.Status__c = 'Pending for approval';
        steps.add(rejectStep);

        insert steps;

        EQCC_Step__c stepToApprove = [
            SELECT Id, Header_Sheet__c, Form_Code__c
            FROM EQCC_Step__c
            WHERE Header_Sheet__r.Sheet__r.Name LIKE 'Approve EQCC'
            LIMIT 1
        ];
        
        EQCC_Step__c stepToApprove2 = [
            SELECT Id, Header_Sheet__c, Form_Code__c
            FROM EQCC_Step__c
            WHERE Form_Code__c = 'EQCC-ENRM-006'
            LIMIT 1
        ];
        
        EQCC_Step__c secondStep = new EQCC_Step__c(
            Name = 'Test Approve',
            Step_Number__c = 2,
            Header_Sheet__c = stepToApprove.Header_Sheet__c,
            Form_Code__c = stepToApprove.Form_Code__c,
            Is_Current__c = false
        );
        insert secondStep;
        
        EQCC_Step__c secondStep2 = new EQCC_Step__c(
            Name = 'Test Approve2',
            Step_Number__c = 1,
            Header_Sheet__c = stepToApprove2.Header_Sheet__c,
            Form_Code__c = stepToApprove2.Form_Code__c,
            Is_Current__c = false
        );
        insert secondStep2;
        
        OPP_Application__c app = new OPP_Application__c();
        app.Name = 'THOR';
        insert app;
    }
    /**
     * @given Approval Process 'THOR_EQCC_Step_ApprovalProcess' and an existing EQCC Step
     * @when the EQCC Step is submitted for approval
     * @then a new process is started for the EQCC Step with Pending status
     */
    /*20221207*/
    @isTest
    static void testStepSubmittedForApproval() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-I/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStepSubmittedForApprovalWithUser() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-I/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];
        
        Test.startTest();
        System.runAs(me) {
            User lead = [SELECT Id FROM User WHERE UserRole.Name LIKE '%APU-A%Team Lead%ENMA-I/%TOC-1%' AND isActive = TRUE LIMIT 1
        ];
            THOR_ApprovalFlowService.submitForApproval(step.Id, lead.Id);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStepSubmittedForApproval1() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit1'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];
        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    
  //20221207  
    @isTest
    static void testStep2SubmittedForApproval1() {
        
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit1'];
        
        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            step.Step_Number__c = 2;
        	update step;
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }

   /*
    @isTest
    static void testStepSubmittedForApproval2() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit2'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
  
    @isTest
    static void testStep2SubmittedForApproval2() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit2'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            step.Step_Number__c = 2;
            update step;
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
   
    @isTest
    static void testStep3SubmittedForApproval2() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit2'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            step.Step_Number__c = 3;
            update step;
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
   */ //20221207
    @isTest
    static void testStepSubmittedForApproval9() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit9'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-2%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id,me.id);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStep2SubmittedForApproval9() {
        String stepId = '';
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit9'];
        
        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-2%' AND isActive = TRUE
            LIMIT 1
        ];
        
        stepId = step.id;
        
        
        Test.startTest(); 
        System.runAs(me) {
            EQCC_Step__c updatedStep = new EQCC_Step__c(id =step.id);
            updatedStep.Step_Number__c = 2;
            update updatedStep;
            system.debug('me.id---'+me.id);
            system.debug('stepId---'+stepId);
            THOR_ApprovalFlowService.submitForApproval(stepId,null);
            //THOR_ApprovalFlowService.submitForApproval(step.Id,me.id);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStep3SubmittedForApproval9() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit9'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-2%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            step.Step_Number__c = 3;
            update step;
            THOR_ApprovalFlowService.submitForApproval(step.Id,me.id);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStepSubmittedForApproval3() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit3'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-I/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStepSubmittedForApproval4() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit4'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStep2SubmittedForApproval4() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit4'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            step.Step_Number__c = 2;
            update step;
            THOR_ApprovalFlowService.submitForApproval(step.Id, me.Id);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStepSubmittedForApproval5() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit5'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-E/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStepSubmittedForApproval6() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit6'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testCoStepSubmittedForApproval6() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit6'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%Team-ENRM-Inspection%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testCoENTSStepSubmittedForApproval6() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit6'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%ENTS Working Team-ENTS%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStepSubmittedForApproval7() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit7'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStepSubmittedForApproval4_2() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit4'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStepSubmittedForApproval4_3() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit4'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            step.Step_Number__c = 2;
        	update step;
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    @isTest
    static void testStepSubmittedForApproval8() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit8'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];

        System.assert(pis.size() > 0, 'Process Instance should exist after submitting for approval.');
    }
    /**
     * @given an EQCC Step submitted for approval
     * @when the EQCC Step is resubmitted for approval
     * @then an exception should prevent resubmitting the EQCC Step for approval
     */
    @isTest
    static void testStepTwiceSubmittedForApproval() {
        EQCC_Step__c stepToSubmit = [
            SELECT Id,Header_Sheet__c,Header_Sheet__r.Sheet__r.Group__c
            FROM EQCC_Step__c
            WHERE Header_Sheet__r.Sheet__r.Name LIKE 'Submit for approval'
            LIMIT 1
        ];
        
        Header_Sheet__c header = [select RequesterId__c from Header_Sheet__c where id =: stepToSubmit.Header_Sheet__c];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            try {
                THOR_ApprovalFlowService.submitForApproval(stepToSubmit.Id, null);
                THOR_ApprovalFlowService.submitForApproval(stepToSubmit.Id, null);
                THOR_ApprovalFlowService.handleFinalApproverAlert(header, stepToSubmit);
                System.assert(false, 'An exception should have been thrown');
            } catch (Exception ex) {
                System.assertEquals(
                    'System.AuraHandledException',
                    ex.getTypeName(),
                    'An exception should have prevented the Step to be resubmitted for approval'
                );
            }
        }
        Test.stopTest();
    }
    @isTest
    static void testStepTwiceSubmittedForApproval22() {
        EQCC_Step__c stepToSubmit = [
            SELECT Id,Header_Sheet__c,Header_Sheet__r.Sheet__r.Group__c
            FROM EQCC_Step__c
            WHERE Header_Sheet__r.Sheet__r.Name LIKE 'Submit for approval'
            LIMIT 1
        ];
        
        Header_Sheet__c header = [select RequesterId__c from Header_Sheet__c where id =: stepToSubmit.Header_Sheet__c];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            try {
                //THOR_ApprovalFlowService.submitForApproval(stepToSubmit.Id, null);
                THOR_ApprovalFlowService.resolveAPUFGroupName('Fabshop');
                
                THOR_ApprovalFlowService.handleFinalApproverAlert(header, stepToSubmit);
                
                
                //System.assert(false, 'An exception should have been thrown');
            } catch (Exception ex) {
                
            }
        }
        Test.stopTest();
    }
    @isTest
    static void testStepTwiceSubmittedForApproval23() {
        

        Test.startTest();
        THOR_ApprovalFlowService.resolveAPUFGroupName('TOP THOR ENRM Team Lead-ENRM-Inspection/RCA/Project/APU-D');
        Test.stopTest();
    }
    static void testStepTwiceSubmittedForApproval1() {
        EQCC_Step__c stepToSubmit = [
            SELECT Id
            FROM EQCC_Step__c
            WHERE Header_Sheet__r.Sheet__r.Name LIKE 'Submit for approval1'
            LIMIT 1
        ];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            try {
                THOR_ApprovalFlowService.submitForApproval(stepToSubmit.Id,me.id);
                THOR_ApprovalFlowService.submitForApproval(stepToSubmit.Id,me.id);
                System.assert(false, 'An exception should have been thrown');
            } catch (Exception ex) {
                System.assertEquals(
                    'System.AuraHandledException',
                    ex.getTypeName(),
                    'An exception should have prevented the Step to be resubmitted for approval'
                );
            }
        }
        Test.stopTest();
    }
    @isTest
    static void testStepTwiceSubmittedForApproval2() {
        EQCC_Step__c stepToSubmit = [
            SELECT Id
            FROM EQCC_Step__c
            WHERE Header_Sheet__r.Sheet__r.Name LIKE 'Submit for approval2'
            LIMIT 1
        ];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            try {
                
                THOR_ApprovalFlowService.submitForApproval(stepToSubmit.Id, null);
                THOR_ApprovalFlowService.submitForApproval(stepToSubmit.Id, null);
                System.assert(false, 'An exception should have been thrown');
            } catch (Exception ex) {
                System.assertEquals(
                    'System.AuraHandledException',
                    ex.getTypeName(),
                    'An exception should have prevented the Step to be resubmitted for approval'
                );
            }
        }
        Test.stopTest();
    }
    @isTest
    static void testStepTwiceSubmittedForApproval9() {
        EQCC_Step__c stepToSubmit = [
            SELECT Id
            FROM EQCC_Step__c
            WHERE Header_Sheet__r.Sheet__r.Name LIKE 'Submit for approval9'
            LIMIT 1
        ];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            try {
                THOR_ApprovalFlowService.submitForApproval(stepToSubmit.Id, null);
                THOR_ApprovalFlowService.submitForApproval(stepToSubmit.Id, null);
                System.assert(false, 'An exception should have been thrown');
            } catch (Exception ex) {
                /*System.assertEquals(
                    'System.AuraHandledException',
                    ex.getTypeName(),
                    'An exception should have prevented the Step to be resubmitted for approval'
                );*/
            }
        }
        Test.stopTest();
    }
    /**
     * @given a started process for an EQCC Step
     * @when process is Approved
     * @then the next Header Sheet EQCC Step is marked as current
     */    
    @isTest
    static void testStepApprovedMarkNextStepAsCurrent() {
        EQCC_Step__c stepToApprove = [
            SELECT Id, Header_Sheet__c, Form_Code__c, Step_Number__c, Is_Current__c, Status__c
            FROM EQCC_Step__c
            WHERE Name = 'approve' AND Step_Number__c = 1
            LIMIT 1
        ];
        EQCC_Step__c secondStep = [
            SELECT Id, Header_Sheet__c, Form_Code__c, Step_Number__c, Is_Current__c, Status__c
            FROM EQCC_Step__c
            WHERE Name = 'Test Approve' AND Step_Number__c = 2
            LIMIT 1
        ];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-I/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];
        User coord = [SELECT Id FROM User WHERE UserRole.Name LIKE '%APU-A%rdinat%ENMA-E%' AND isActive = TRUE LIMIT 1];
        System.debug([SELECT SubmittedBy.Id FROM ProcessInstance]);
        Test.startTest();
        //Current Approval Process has three steps
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(stepToApprove.Id, null);
        }
        System.runAs(coord) {
            THOR_ApprovalFlowService.approveOrReject(stepToApprove.Id, 'Approve', '');
        }
        Test.stopTest();

        ProcessInstance approvedStep = [
            SELECT TargetObjectId, Status
            FROM ProcessInstance
            WHERE TargetObjectId = :stepToApprove.Id
            LIMIT 1
        ];

        System.assertEquals(Constants.PROCESS.STATUS_APPROVED, approvedStep.Status, 'Step should have been Approved');

        EQCC_Step__c updatedSecondStep = [SELECT Id, Is_Current__c FROM EQCC_Step__c WHERE Id = :secondStep.Id];
        System.assert(updatedSecondStep.Is_Current__c, 'The next Header Sheet Step should have been marked as current');
    }
    /**
     * @given a started process for an EQCC Step
     * @when process is Approved and Header Sheet has no more Steps
     * @then the Header Sheet is marked as Approved
     */
    @isTest
    static void testStepApprovedMarkHeaderSheetAsApproved() {
        EQCC_Step__c stepToApprove = [
            SELECT Id, Header_Sheet__r.Sheet__c
            FROM EQCC_Step__c
            WHERE Name = 'submit'
            LIMIT 1
        ];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-I/TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];
        User coord = [SELECT Id FROM User WHERE UserRole.Name LIKE '%APU-A%rdinat%ENMA-E%' AND isActive = TRUE LIMIT 1];
        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(stepToApprove.Id, null);
        }
        System.runAs(coord) {
            THOR_ApprovalFlowService.approveOrReject(stepToApprove.Id, 'Approve', '');
        }
        Test.stopTest();

        ProcessInstance approvedStep = [
            SELECT TargetObjectId, Status
            FROM ProcessInstance
            WHERE TargetObjectId = :stepToApprove.Id
            LIMIT 1
        ];
        System.assertEquals(Constants.PROCESS.STATUS_APPROVED, approvedStep.Status, 'Step should have been Approved');

        Header_Sheet__c headerSheet = [
            SELECT Id, Status__c
            FROM Header_Sheet__c
            WHERE Id = :stepToApprove.Header_Sheet__c
        ];

        System.assertEquals(
            Constants.CHECKED_SHEETS.STATUS_APPROVED,
            headerSheet.Status__c,
            'Header Sheet should have been marked as Approved'
        );
    }
    /*
    @isTest
    static void testStepApprovedMarkHeaderSheetAsApproved2() {
        EQCC_Step__c stepToApprove = [
            SELECT Id, Header_Sheet__r.Sheet__c
            FROM EQCC_Step__c
            WHERE Name = 'submit2'
            LIMIT 1
        ];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-M/TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];
        User lead = [SELECT Id FROM User WHERE UserRole.Name LIKE '%APU-A%Team Lead%ENMA-M%' AND isActive = TRUE LIMIT 1];
        Test.startTest();

        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(stepToApprove.Id, null);
        }
        System.runAs(lead) {
            THOR_ApprovalFlowService.approveOrReject(stepToApprove.Id, 'Approve', '');
        }
        Test.stopTest();

        ProcessInstance approvedStep = [
            SELECT TargetObjectId, Status
            FROM ProcessInstance
            WHERE TargetObjectId = :stepToApprove.Id
            LIMIT 1
        ];

        Header_Sheet__c headerSheet = [
            SELECT Id, Status__c
            FROM Header_Sheet__c
            WHERE Id = :stepToApprove.Header_Sheet__c
        ];
    }
    */
    /**
     * @given a started process for an EQCC Step
     * @when process is rejected
     * @then //TODO ask what to do in this case (update service in consequence)
     */
    @isTest
    static void testStepRejected() {
        EQCC_Step__c stepToReject = [SELECT Id FROM EQCC_Step__c WHERE Name LIKE 'reject' LIMIT 1];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-I/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];
        User oper = [SELECT Id FROM User WHERE UserRole.Name LIKE '%APU-A%rdinat%ENMA-E%' AND isActive = TRUE LIMIT 1];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(stepToReject.Id, null);
        }
        System.runAs(oper) {
            THOR_ApprovalFlowService.approveOrReject(stepToReject.Id, 'Reject', '');
        }
        Test.stopTest();

        ProcessInstance rejectedStep = [
            SELECT TargetObjectId, Status
            FROM ProcessInstance
            WHERE TargetObjectId = :stepToReject.Id
            LIMIT 1
        ];
        System.assertEquals(Constants.PROCESS.STATUS_REJECTED, rejectedStep.Status, 'Step should have been Rejected');
    }
    @isTest
    static void testStepSubmittedForApprovalRecall() {
        EQCC_Step__c step = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit'];

        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-I/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, null);
            THOR_ApprovalFlowService.recallForApproval(step.Id);
            THOR_ApprovalFlowService.getIgnorSpecialSubmit(step.Id);
        }
        Test.stopTest();

        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step.Id];
    }
    @isTest
    static void testAlert() {
        
        Header_Sheet__c header = [select id,RequesterId__c from Header_Sheet__c limit 1];
        EQCC_Step__c step = [select id,Header_Sheet__r.Sheet__r.Group__c,Form_Code__c from EQCC_Step__c where Header_Sheet__c =: header.id limit 1];
        
        Test.startTest();
        THOR_ApprovalFlowService.handleFinalApproverAlert(header,step);
           
        Test.stopTest();

    }
    /* DGMO
    @isTest
    static void testStepApproved4005() {
        EQCC_Step__c step1 = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit4005' AND Step_Number__c = 1 LIMIT 1];
        EQCC_Step__c step2 = [SELECT Id FROM EQCC_Step__c WHERE Name = 'submit4005' AND Step_Number__c = 2 LIMIT 1];
        
        createHeirarchyUsers();
        User Co = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE 'TOP THOR ENEM Co-Ordinator-ENEM-Workshop/Thai oil group' AND isActive = TRUE
            LIMIT 1
        ];
        User manager = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE 'TOP THOR ENEM Manager' AND isActive = TRUE
            LIMIT 1
        ];
        
        Test.startTest();
        System.runAs(Co) {
            THOR_ApprovalFlowService.submitForApproval(step1.Id, null);
        }
        System.runAs(manager) {
            THOR_ApprovalFlowService.approveOrReject(step1.Id, 'Approve', '');
        }
        Test.stopTest();
        List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :step2.Id];
    }*/
    
    private static void createHeirarchyUsers() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueOf(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        /*User ouser = new User(
            FirstName = 'test',
            LastName = 'user',
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Operator%' LIMIT 1]
            .Id
        );
        insert ouser;*/

        randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        uniqueName = orgId + dateString + randomInt;
        User cuser = new User(
            FirstName = 'test',
            LastName = 'user',
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%rdinat%ENMA-E%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%APU-A%rdinat%ENMA-E%' LIMIT 1]
            .Name
        );
        insert cuser;

        randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        uniqueName = orgId + dateString + randomInt;
        User luser = new User(
            FirstName = 'test',
            LastName = 'user',
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' LIMIT 1]
            .Name
        );
        insert luser;
        
        randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        uniqueName = orgId + dateString + randomInt;
        User luser2 = new User(
            FirstName = 'test2',
            LastName = 'user2',
            Email = uniqueName + '@test2' + orgId + '.org',
            Username = uniqueName + '@test2' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%TOP THOR ENRM Manager%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%TOP THOR ENRM Manager%' LIMIT 1]
            .Name
        );
        insert luser2;
        
        User lFuser = new User(
            FirstName = 'testF',
            LastName = 'userF',
            Email = uniqueName + 'F@test' + orgId + '.org',
            Username = uniqueName + 'F@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = 'F'+uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-F%Team Lead%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%APU-F%Team Lead%' LIMIT 1]
            .Name
        );
        insert lFuser;
        
        User coUser = new User(
            FirstName = 'testCo',
            LastName = 'userCo',
            Email = uniqueName + 'Co@test' + orgId + '.org',
            Username = uniqueName + 'Co@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = 'co'+uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%Team-ENRM-Inspection%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%Team-ENRM-Inspection%' LIMIT 1]
            .Name
        );
        insert coUser;
        
        User coENTSUser = new User(
            FirstName = 'testCoENTS',
            LastName = 'userCoENTS',
            Email = uniqueName + 'CoENTS@test' + orgId + '.org',
            Username = uniqueName + 'CoENTS@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = 'E'+uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%ENTS Working Team-ENTS%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%ENTS Working Team-ENTS%' LIMIT 1]
            .Name
        );
        insert coENTSUser;

        randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        uniqueName = orgId + dateString + randomInt;
        User muser = new User(
            FirstName = 'test',
            LastName = 'user',
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%APU-A%Working Team-ENMA-M/%TOC-1%' LIMIT 1]
            .Name
        );
        insert muser;
        
        User muser2 = new User(
            FirstName = 'test2',
            LastName = 'user2',
            Email = uniqueName + '@test2' + orgId + '.org',
            Username = uniqueName + '@test2' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Working Team-ENMA-M/TOC-2%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%APU-A%Working Team-ENMA-M/TOC-2%' LIMIT 1]
            .Name
        );
        insert muser2;
        
        User iuser = new User(
            FirstName = 'testi',
            LastName = 'useri',
            Email = uniqueName + '@testi' + orgId + '.org',
            Username = uniqueName + '@testi' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Working Team-ENMA-I/%TOC-1%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%APU-A%Working Team-ENMA-I/%TOC-1%' LIMIT 1]
            .Name
        );
        insert iuser;
        
        User euser = new User(
            FirstName = 'teste',
            LastName = 'usere',
            Email = uniqueName + '@teste' + orgId + '.org',
            Username = uniqueName + '@teste' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Working Team-ENMA-E/%TOC-1%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%APU-A%Working Team-ENMA-E/%TOC-1%' LIMIT 1]
            .Name
        );
        insert euser;
        
        User leaduser = new User(
            FirstName = 'testl',
            LastName = 'userl',
            Email = uniqueName + '@testl' + orgId + '.org',
            Username = uniqueName + '@testl' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Team Lead-ENMA-M/%TOC-1%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%APU-A%Team Lead-ENMA-M/%TOC-1%' LIMIT 1]
            .Name
        );
        insert leaduser;
        
        User leaduser1 = new User(
            FirstName = 'testl1',
            LastName = 'userl1',
            Email = uniqueName + '@testl1' + orgId + '.org',
            Username = uniqueName + '@testl1' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Team Lead-ENMA-I/%TOC-1%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%APU-A%Team Lead-ENMA-I/%TOC-1%' LIMIT 1]
            .Name
        );
        insert leaduser1;
        
        User leaduser2 = new User(
            FirstName = 'testl2',
            LastName = 'userl2',
            Email = uniqueName + '@testl2' + orgId + '.org',
            Username = uniqueName + '@testl2' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Team Lead-ENMA-M/TOC-2%' LIMIT 1]
            .Id,
            Role_Approve_process__c = [SELECT Id,Name FROM UserRole WHERE Name LIKE '%APU-A%Team Lead-ENMA-M/TOC-2%' LIMIT 1]
            .Name
        );
        insert leaduser2;
        //return muser;
    }
}