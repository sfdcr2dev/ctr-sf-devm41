/**
 * @author Oktana Team
 * @description test class for SetNotificationHelper
 */
@isTest
public class SetFirstNotificationHelper_Test {

    @testSetup
    static void setup() {
        Order__c existingOrder = new Order__c(
          Order_Number__c = '90015123',
          Integration_Status__c = 'Success'
        );
        insert existingOrder;
    }

    /**
     * @given an existing Order with empty Notification field
     * @when a Notification is created and related to the Order
     * @then Notification field should be populated in the Order
     */
    @isTest
    static void testNotificationFieldPopulatedOnOrder() {
        Order__c existingOrder = getOrder();

        List<Notification__c> notifications;
        Test.startTest();
        notifications = createNotifications(5, existingOrder.Id);
        Test.stopTest();

        Order__c updatedOrder = getOrder();
        System.assertNotEquals(
            null,
            updatedOrder.Notification__c,
            'Order\'s Notification field should have been populated'
        );
        System.assertEquals(
            notifications.get(0).Id,
            updatedOrder.Notification__c,
            'Order\'s Notification field should be populated with the Notification\'s Id'
        );
    }

    /**
     * @given an existing Order with Notification field populated
     * @when a Notification is created and related to the Order (not Sub Order)
     * @then Notification field should not be updated
     */
    @isTest
    static void testNotificationFieldNotUpdated() {
        Order__c existingOrder = getOrder();
        Notification__c firstNotification = createNotifications(1, existingOrder.Id).get(0);

        Notification__c secondNotification;
        Test.startTest();
        secondNotification = createNotifications(1, existingOrder.Id).get(0);
        Test.stopTest();

        Order__c updatedOrder = getOrder();
        System.assertNotEquals(
            null,
            updatedOrder.Notification__c,
            'Order\'s Notification field should have been populated'
        );
        System.assertEquals(
            firstNotification.Id,
            updatedOrder.Notification__c,
            'Order\'s Notification field should be populated with the first related Notification\'s Id'
        );
    }

    /**
     * @given an existing Sub Order with empty Notification field
     * @when a Notification is created and related to the Sub Order
     * @then Notification field should not be populated in the Sub Order
     */
    @isTest
    static void testNotificationFieldNotPopulatedOnSubOrder() {
        Order__c existingOrder = getOrder();
        Order__c subOrder = createSubOrder(existingOrder.Id);

        Notification__c notification;
        Test.startTest();
        notification = createNotifications(1, subOrder.Id).get(0);
        Test.stopTest();

        Order__c updatedOrder = getOrder();
        System.assertEquals(
            null,
            updatedOrder.Notification__c,
            'Sub Order\'s Notification field should not have been populated'
        );
    }

    private static List<Notification__c> createNotifications(Integer amount, Id orderId) {
        List<Notification__c> notifications = new List<Notification__c>();

        for (Integer i = 0; i < amount; i++) {
            Notification__c notification = new Notification__c(
                Description__c = 'Test Notification',
                AssignedTo__c = UserInfo.getUserId(),
                Order__c = orderId
            );

            notifications.add(notification);
        }
        insert notifications;

        return notifications;
    }

     private static Order__c createSubOrder(Id orderId) {
        Order__c subOrder = new Order__c(
            Super_Order__c = orderId,
            Order_Number__c = '9001512124',
            Integration_Status__c = 'Success'
        );

        insert subOrder;

        return subOrder;
    }

    private static Order__c getOrder() {
        return [SELECT Id, Notification__c FROM Order__c LIMIT 1];
    }
}