/**
 * @author Oktana
 * @description test class for THOR_CmpReqRecordDisplayController
 */
@isTest
public with sharing class THOR_CmpReqRecordDisplayControllerTest {
    @testSetup
    static void setup() {
        Spare_Part__c part = new Spare_Part__c();
        part.Material_Number__c = '1234';
        insert part;

        Spare_Part_Stock__c stock = new Spare_Part_Stock__c();
        stock.Spare_Part__c = part.Id;
        insert stock;

        Order__c order = new Order__c(Name = 'orderTest');
        insert order;

        Order_Operation__c orderOperation = new Order_Operation__c(
            Operation_Text__c = 'orderOpTest',
            Order__c = order.Id
        );
        insert orderOperation;

        Spare_Part_Request__c componentRequest = new Spare_Part_Request__c();
        componentRequest.IC__c = 'M';
        componentRequest.Spare_Part_Stock__c = stock.Id;
        componentRequest.Order__c = order.Id;
        componentRequest.Order_Operation__c = orderOperation.Id;
        componentRequest.Spare_Part__c = part.Id;

        insert componentRequest;
    }

    /**
     * @given a Spare Part Request
     * @when method THOR_CmpReqRecordDisplayController.retrieveComponentRequest is invoked with
     *       the Spare Part Request Id
     * @then the Spare Part Request is passed to the Aura Component
     */
    @isTest
    static void retrieveComponentRequestTest() {
        Spare_Part_Request__c componentRequest = getComponentRequest();

        Test.startTest();
        Spare_Part_Request__c retrievedComponent = THOR_CmpReqRecordDisplayController.retrieveComponentRequest(
            componentRequest.Id
        );
        Test.stopTest();

        System.assertNotEquals(null, retrievedComponent, 'A Spare Part Request should have been retrieved');
        System.assertEquals('M', retrievedComponent.IC__c, 'IC does not match');
        System.assertEquals(
            '1234',
            retrievedComponent.Spare_Part_Stock__r.Spare_Part__r.Material_Number__c,
            'Material_Number__c does not match'
        );
    }

    /**
     * @given a Spare Part Request
     * @when method THOR_CmpReqRecordDisplayController.retrieveComponentRequest is invoked with
     *       a nonexistent Id
     * @then an Exception is thrown
     * @and no Spare Part Request is passed to the Aura Component
     */
    @isTest
    static void retrieveComponentRequestWithBadIdTest() {
        Spare_Part_Request__c componentRequest = getComponentRequest();

        Test.startTest();
        try {
            Spare_Part_Request__c retrievedComponent = THOR_CmpReqRecordDisplayController.retrieveComponentRequest(
                null
            );
            System.assert(false, 'An exception should have been thrown');
        } catch (Exception ex) {
            System.assertEquals(
                'System.AuraHandledException',
                ex.getTypeName(),
                'AuraHandledException should have been thrown'
            );
        }
        Test.stopTest();
    }

    private static Spare_Part_Request__c getComponentRequest() {
        return [
            SELECT Id, IC__c, Spare_Part_Stock__r.Spare_Part__r.Material_Number__c
            FROM Spare_Part_Request__c
            LIMIT 1
        ];
    }
}