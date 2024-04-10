@isTest
public class CTRComplianceCheckControllerTest {
    @isTest
    static void testGetPicklistValue() {
        String fieldAPI = 'FieldName'; 
        String sObjAPI = 'ObjectName'; 
        
        // Call the method
        Test.startTest();
        List<Map<String, String>> picklistValues = CTRComplianceCheckController.getPicklistValue(fieldAPI, sObjAPI);
        Test.stopTest();
        
        System.assertNotEquals(null, picklistValues, 'Returned picklist values should not be null');
    }

    @isTest
    static void testCreateRelatedShiptoAndShareholder() {
        String shiptoJSON = '[{"Name":"TestShipto1", "Field1__c":"Value1"}, {"Name":"TestShipto2", "Field1__c":"Value2"}]';
        String shareholderJSON = '[{"Name":"TestShareholder1", "Field2__c":"Value3"}, {"Name":"TestShareholder2", "Field2__c":"Value4"}]';
        
        Test.startTest();
        String result = CTRComplianceCheckController.createRelatedShiptoAndShareholder(shiptoJSON, shareholderJSON);

        try {
            result = CTRComplianceCheckController.createRelatedShiptoAndShareholder('Invalid JSON', 'Invalid JSON');
        } catch (Exception ex) {
            System.assertNotEquals(null, ex.getMessage());
        }
        Test.stopTest();
        
        System.assertEquals('success', result, 'Expected result should be success');
    }

    @isTest
    static void testRejectRequestForm() {
        CTRRequestFormItem__c testRecord = new CTRRequestFormItem__c();
        insert testRecord;

        Test.startTest();
        String result = CTRComplianceCheckController.rejectRequestForm(testRecord.Id);

        try {
            result = CTRComplianceCheckController.rejectRequestForm('xxx');
        } catch (Exception ex) {
            System.assertNotEquals(null, ex.getMessage());
        }
        Test.stopTest();
        
        System.assertEquals('success', result, 'Expected result should be success');
        CTRRequestFormItem__c updatedRecord = [SELECT Id, Status__c FROM CTRRequestFormItem__c WHERE Id = :testRecord.Id];
        System.assertEquals('Rejected', updatedRecord.Status__c, 'Record status should be set to Rejected');
    }
}