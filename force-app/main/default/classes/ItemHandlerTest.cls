/**
 * @author Oktana
 * @description test class for ItemHandler
 */
@isTest
public with sharing class ItemHandlerTest {
    /**
     * @given a new Item
     * @when Item is inserted
     * @then field NotiItem__c should be populated with Item's Notification + Item_No
     */
    @isTest
    static void testPopulateNotiItemWhenItemCreated() {
        Notification__c testNotification = new Notification__c(Notification_Number__c = '12345');
        insert testNotification;

        List<Item__c> items = new List<Item__c>();
        for (Integer i = 0; i < 5; i++) {
            items.add(new Item__c(Notification__c = testNotification.Id));
        }

        Test.startTest();
        insert items;
        Test.stopTest();

        items = getItems();

        for (Item__c item : items) {
            System.assert(String.isNotBlank(item.Item_No__c), 'Item_No__c should have been populated');
            System.assertEquals(
                item.Notification__c + item.Item_No__c,
                item.NotiItem__c,
                'NotiItem should have been populated from Item\'s Notification and Item_No fields'
            );
        }
    }

    private static List<Item__c> getItems() {
        return [SELECT Id, Notification__c, Item_No__c, NotiItem__c FROM Item__c];
    }
}