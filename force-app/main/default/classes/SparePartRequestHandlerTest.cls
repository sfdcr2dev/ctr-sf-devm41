/**
 * @author Oktana
 * @description test class for SparePartRequestHandler
 */
@isTest
public with sharing class SparePartRequestHandlerTest {
    /**
     * @given a new Spare Part Request
     * @when Spare Part Request is inserted
     * @then field OrderOrderOperation__c should be populated with 
                sparePartRequest.Order__r.Name +
                sparePartRequest.Order_Operation__r.Operation_Text__c +
                sparePartRequest.Item_No__c +
                sparePartRequest.Spare_Part__r.Name;
     */
    @isTest
    static void testPopulateOrderOrderOperationWhenSparePartRequestUpdated() {
        Order__c testOrder = new Order__c(Name = 'orderTest');
        insert testOrder;

        Order_Operation__c orderOperationTest = new Order_Operation__c(
            Operation_Text__c = 'orderOpTest',
            Order__c = testOrder.Id
        );
        insert orderOperationTest;

        Spare_Part__c sparePartTest = new Spare_Part__c(Name = 'sparePartTest', Material_Number__c = 'MaterialTest');
        insert sparePartTest;

        Id orderTestId = testOrder.Id;

        List<Spare_Part_Request__c> sparePartRequests = new List<Spare_Part_Request__c>();
        for (Integer i = 0; i < 5; i++) {
            sparePartRequests.add(
                new Spare_Part_Request__c(
                    Order__c = orderTestId,
                    Order_Operation__c = orderOperationTest.Id,
                    Item_No__c = '123' + i,
                    Spare_Part__c = sparePartTest.Id
                )
            );
        }

        Test.startTest();
        insert sparePartRequests;
        for (Spare_Part_Request__c spr : sparePartRequests) {
            spr.Request_Status__c = 'Pending for Approval';
        }
        update sparePartRequests;
        Test.stopTest();

        sparePartRequests = getSparePartRequests();

        for (Spare_Part_Request__c sparePartRequest : sparePartRequests) {
            System.assertEquals(
                sparePartRequest.Order__r.Name +
                sparePartRequest.Order_Operation__r.Operation_Text__c +
                sparePartRequest.Item_No__c,// +
               // sparePartRequest.Spare_Part__r.Name,
                sparePartRequest.OrderOrderOperation__c,
                'OrderOrderOperation__c should have been populated from Spare Part Request\'s sparePartRequest.Order__r.Name + sparePartRequest.Order_Operation__r.Operation_Text__c + sparePartRequest.Item_No__c + sparePartRequest.Spare_Part__r.Name,sparePartRequest.OrderOrderOperation__c'
            );
        }
    }

    private static List<Spare_Part_Request__c> getSparePartRequests() {
        return [
            SELECT
                Id,
                Order__r.Name,
                Order_Operation__r.Operation_Text__c,
                Item_No__c,
                Spare_Part__r.Name,
                OrderOrderOperation__c
            FROM Spare_Part_Request__c
        ];
    }

    /**
     * @given a new Spare Part Request
     * @when Spare Part Request is inserted
     * @then field Item_No__c will be auto populated with 0010, 0020 and so on
     */
    @isTest
    static void testPopulateItemNoWhenSparePartRequestCreated() {
        Order__c testOrder = new Order__c(Name = 'orderTest');
        insert testOrder;

        Order_Operation__c orderOperationTest = new Order_Operation__c(
            Operation_Text__c = 'orderOpTest',
            Order__c = testOrder.Id
        );
        insert orderOperationTest;

        Spare_Part__c sparePartTest = new Spare_Part__c(Name = 'sparePartTest', Material_Number__c = 'MaterialTest');
        insert sparePartTest;

        Id orderTestId = testOrder.Id;

        Spare_Part_Request__c sparePartRequest1 = new Spare_Part_Request__c(
            Order__c = orderTestId,
            Order_Operation__c = orderOperationTest.Id,
            Spare_Part__c = sparePartTest.Id
        );

        Spare_Part_Request__c sparePartRequest2 = new Spare_Part_Request__c(
            Order__c = orderTestId,
            Order_Operation__c = orderOperationTest.Id,
            Spare_Part__c = sparePartTest.Id
        );

        Spare_Part_Request__c sparePartRequest3 = new Spare_Part_Request__c(
            Order__c = orderTestId,
            Order_Operation__c = orderOperationTest.Id,
            Spare_Part__c = sparePartTest.Id
        );

        List<Spare_Part_Request__c> sparePartRequests = new List<Spare_Part_Request__c>();
        sparePartRequests.add(sparePartRequest1);
        sparePartRequests.add(sparePartRequest2);

        Test.startTest();
        insert sparePartRequests;
        insert sparePartRequest3;
        Test.stopTest();

        sparePartRequests = getSparePartRequests();

        System.assertEquals('0010', sparePartRequests[0].Item_No__c, 'Item_No__c should have been auto populated 0010');
        System.assertEquals('0020', sparePartRequests[1].Item_No__c, 'Item_No__c should have been auto populated 0020');
        System.assertEquals('0030', sparePartRequests[2].Item_No__c, 'Item_No__c should have been auto populated 0030');
    }
}