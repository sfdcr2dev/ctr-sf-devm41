/**
 * @author Oktana
 * @description test class for PB 'Update Order Number When none Provided'
 */
@isTest
public with sharing class UpdateOrderNumberTest {

    /**
     * @given a new Order with no Order Number
     * @when order is inserted
     * @then the Order Number is updated with the Order Name
     */
    /*
    @isTest
    static void testOrderNumberPopulatedOnInsert() {
        Test.startTest();
        Order__c order = createOrder();
        Test.stopTest();
        
        Order__c updatedOrder = getOrder(order.Id);

        System.assertEquals(
            updatedOrder.Name,
            updatedOrder.Order_Number__c,
            'Order Number should have been updated with the Order Name'
        );
    }
    */
    /**
     * @given an Order with no Order Number
     * @when order is updated with a new Name
     * @then the Order Number is updated with the Order Name
     */
    /*
    @isTest
    static void testOrderNumberPopulatedOnUpdate() {
        Order__c order = createOrder();
        order.Name = 'New Name';
        order.Order_Number__c = null;
        
        Test.startTest();
        update order;
        Test.stopTest();
        
        Order__c updatedOrder = getOrder(order.Id);

        System.assertEquals(
            updatedOrder.Name,
            updatedOrder.Order_Number__c,
            'Order Number should have been updated with the Order Name'
        );
    }
    */
    /**
     * @given an Order with Order Number
     * @when order is updated with a new Name
     * @then the Order Number should not be updated
     */
    @isTest
    static void testOrderNumberNotChangeOnUpdate() {
        Order__c order = createOrder();
        order.Order_Number__c = '123456789';
        update order;
        order.Name = 'New Name';
        
        Test.startTest();
        update order;
        Test.stopTest();
        
        Order__c updatedOrder = getOrder(order.Id);
        System.assertEquals(
            '123456789',
            updatedOrder.Order_Number__c,
            'Order Number should not have been updated'
        );
    }
    
    private static Order__c createOrder() {
        Order__c order = new Order__c();
        insert order;
        return order;
    }
    
    private static Order__c getOrder(Id orderId) {
        return [SELECT Id, Order_Number__c, Name FROM Order__c WHERE Id = :orderId];
    }
}