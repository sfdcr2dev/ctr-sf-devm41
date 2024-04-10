@isTest
public with sharing class THOR_ApprovalStepsController_Test {
    @TestSetup
    static void makeData() {
        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName, Form_Code__c
            FROM Checked_Sheet_Pointer__mdt
            WHERE DeveloperName LIKE '%Tank%'
            LIMIT 1
        ];

        EQCC_Header__c header = new EQCC_Header__c();
        insert header;

        EQCC_Checked_Sheet__c checkedSheetToSubmit = new EQCC_Checked_Sheet__c(
            Name = 'Submit for approval',
            Form_Type__c = formType.DeveloperName,
            Sheet_Code__c = formType.Form_Code__c,
            Form_Questions__c = 50
        );
        insert checkedSheetToSubmit;

        EQCC_Checked_Sheet__c checkedSheetToApprove = new EQCC_Checked_Sheet__c(
            Name = 'Approve EQCC',
            Form_Type__c = formType.DeveloperName,
            Sheet_Code__c = formType.Form_Code__c,
            Form_Questions__c = 50
        );
        insert checkedSheetToApprove;

        EQCC_Checked_Sheet__c checkedSheetToReject = new EQCC_Checked_Sheet__c(
            Name = 'Reject EQCC',
            Form_Type__c = formType.DeveloperName,
            Sheet_Code__c = formType.Form_Code__c,
            Form_Questions__c = 50
        );
        insert checkedSheetToReject;

        List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>{
            new Header_Sheet__c(Header__c = header.Id, Sheet__c = checkedSheetToSubmit.Id),
            new Header_Sheet__c(Header__c = header.Id, Sheet__c = checkedSheetToApprove.Id),
            new Header_Sheet__c(Header__c = header.Id, Sheet__c = checkedSheetToReject.Id)
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
        EQCC_Step__c secondStep = new EQCC_Step__c(
            Name = 'Test Approve',
            Step_Number__c = 2,
            Header_Sheet__c = stepToApprove.Header_Sheet__c,
            Form_Code__c = stepToApprove.Form_Code__c,
            Is_Current__c = false
        );

        insert secondStep;

        OPP_Application__c app = new OPP_Application__c();
        app.Name = 'THOR';
        insert app;
    }

    private static User createHeirarchyUsers() {
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
            .Id
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
            .Id
        );
        insert luser;

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
            UserRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%APU-A%Working Team%-E/%TOC-1%' LIMIT 1]
            .Id
        );
        insert muser;
        return muser;
    }
@isTest
    public static void recallForApproval() {
        EQCC_Step__c step = [SELECT Id, Form_Code__c FROM EQCC_Step__c WHERE Name = 'submit'];
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-I/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];
 		System.runAs(me) {
            THOR_ApprovalFlowService.recallForApproval(step.Id);
            THOR_ApprovalFlowService.getIgnorSpecialSubmit(step.Id);
            THOR_ApprovalFlowService.handleReviseAlert(step.Id);
            THOR_ApprovalFlowService.getStepById(step.Id);
            THOR_ApprovalFlowService.resolveENSAEngineer();
            THOR_ApprovalFlowService.resolveEngineer('APU-A');
            THOR_ApprovalFlowService.resolveQAEngineer('APU-A');
            THOR_ApprovalFlowService.resolveManager('APU-A');
            //THOR_ApprovalFlowService.approveOrReject(step.Id,'Approve','');
            //THOR_ApprovalFlowService.approveOrReject(step.Id,'Reject','');
        }
    }
    
    @isTest
    public static void givenAnAprovalProcessStepIdRetrievesTheInformationAboutIt() {
        EQCC_Step__c step = [SELECT Id, Form_Code__c FROM EQCC_Step__c WHERE Name = 'submit'];
        createHeirarchyUsers();
        User me = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Working Team-ENMA-I/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        User teamLead = [
            SELECT Id
            FROM User
            WHERE UserRole.Name LIKE '%APU-A%Team Lead%-E/%TOC-1%' AND isActive = TRUE
            LIMIT 1
        ];

        System.runAs(me) {
            THOR_ApprovalFlowService.submitForApproval(step.Id, teamLead.Id);
        }

        ProcessInstanceStep processInstanceStep = [
            SELECT Id
            FROM ProcessInstanceStep
            WHERE ProcessInstance.TargetObjectId = :step.Id
        ][0];
		
        /*List<THOR_ObjectCardDTO> eqccRetrievedSteps = THOR_ApprovalStepsController.retrieveProcessInstanceSteps(
            processInstanceStep.Id
        );*/
        
        THOR_ApprovalStepsController.retrieveProcessInstanceSteps(
            processInstanceStep.Id
        );

        THOR_ApprovalStepsController.checkPrivilege(step.Id);

        //System.assert(eqccRetrievedSteps.size() == 1, 'Controller did not returned elements');
        //System.assertEquals(step.Form_Code__c, eqccRetrievedSteps[0].dropableBody[0].value, 'Name does not match');
    }

	@isTest
	static void testReverseEQCCStepList() {
		Test.startTest();
		THOR_ApprovalStepsController.reverseEQCCStepList([SELECT Id FROM EQCC_Step__c LIMIT 1]?.Id);
		Test.stopTest();
	}
}