/**
 * @author Oktana
 * @description test class for EQCCStepHandler
 */
@isTest
public with sharing class EQCCStepHandlerTest {
    @testSetup
    static void setup() {
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
            Form_Type__c = formType.DeveloperName
        );
        insert checkedSheetToSubmit;

        Header_Sheet__c headerSheet = new Header_Sheet__c(Header__c = header.Id, Sheet__c = checkedSheetToSubmit.Id);
        insert headerSheet;
    }

    /**
     * @given an EQCC Step related to a Header Sheet
     * @when the Step Status is updated
     * @then the Header Sheet Status is also updated
     */
    @isTest
    static void testUpdateHeaderSheetWhenStepUpdated() {
        EQCC_Step__c step = getEQCCStep();

        step.Status__c = Constants.PROCESS.STATUS_PENDING_APPROVAL;
        Test.startTest();
        update step;
        Test.stopTest();

        EQCC_Step__c updatedStep = getEQCCStepById(step.Id);
        System.assertNotEquals(
            step.Header_Sheet__r.Status__c,
            updatedStep.Header_Sheet__r.Status__c,
            'The Header Sheet Status should have been updated'
        );
        System.assertEquals(
            Constants.PROCESS.STATUS_PENDING_APPROVAL,
            updatedStep.Header_Sheet__r.Status__c,
            'The Header Sheet Status should have been updated to the same value than the Step Status'
        );
    }

    private static EQCC_Step__c getEQCCStep() {
        return [SELECT Id, Status__c, Header_Sheet__r.Status__c FROM EQCC_Step__c WITH SECURITY_ENFORCED];
    }

    private static EQCC_Step__c getEQCCStepById(Id stepId) {
        return [
            SELECT Id, Status__c, Header_Sheet__r.Status__c
            FROM EQCC_Step__c
            WHERE Id = :stepId
            WITH SECURITY_ENFORCED
        ];
    }
}