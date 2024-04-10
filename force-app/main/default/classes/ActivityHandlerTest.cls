/**
 * @author Oktana
 * @description test class for ActivityHandler
 */
@isTest
public with sharing class ActivityHandlerTest {
    /**
     * @given a new Activity__c
     * @when Activity is inserted
     * @then field ItemActivity__c should be populated with
     * Activity's Item's Notification + Item_No + Activity_No
     */
    @isTest
    static void testPopulateItemActivity() {
        Notification__c testNotification = new Notification__c(Notification_Number__c = '12345');
        insert testNotification;

        Item__c testItem = new Item__c(Notification__c = testNotification.Id, Item_No__c = '123');
        insert testItem;

        List<Activity__c> actList = new List<Activity__c>();
        for (Integer i = 0; i < 5; i++) {
            actList.add(new Activity__c(Notification__C = testNotification.Id, Item__c = testItem.Id));
        }

        Test.startTest();
        insert actList;
        Test.stopTest();

        actList = getActivities();

        Integer i = 1;
        for (Activity__c act : actList) {
            System.assertEquals(
                String.valueOf(i),
                act.Activity_No__c,
                'Acitivity_No__c should have been autopopulated'
            );
            i++;
            System.assertEquals(
                act.Notification__c +
                act.Item__r.Item_No__c +
                act.Activity_No__c,
                act.ItemActivity__c,
                'ItemActivity__c should have been populated'
            );
        }
    }

    /**
     * @given existing Activities
     * @when a new Activity is inserted
     * @then field ItemActivity__c should be populated with
     * Activity's Item's Notification + Item_No + Activity_No
     */
    @isTest
    static void testPopulateItemActivityWithExistingActivities() {
        Notification__c testNotification = new Notification__c(Notification_Number__c = '12345');
        insert testNotification;

        Item__c testItem = new Item__c(Notification__c = testNotification.Id, Item_No__c = '123');
        insert testItem;

        List<Activity__c> actList = new List<Activity__c>();
        for (Integer i = 0; i < 5; i++) {
            actList.add(new Activity__c(Notification__C = testNotification.Id, Item__c = testItem.Id));
        }
        insert actList;

        Activity__c newAct = new Activity__c(Notification__C = testNotification.Id, Item__c = testItem.Id);
        Test.startTest();
        insert newAct;
        Test.stopTest();

        newAct = getActivityById(newAct.Id);

        System.assertEquals('6', newAct.Activity_No__c, 'Acitivity_No__c should have been autopopulated');
        System.assertEquals(
            newAct.Notification__c +
            newAct.Item__r.Item_No__c +
            newAct.Activity_No__c,
            newAct.ItemActivity__c,
            'ItemActivity__c should have been populated'
        );
    }

    private static List<Activity__c> getActivities() {
        return [
            SELECT Id, Notification__c, Item__c, Activity_No__c, Item__r.Item_No__c, ItemActivity__c
            FROM Activity__c
        ];
    }

    private static Activity__c getActivityById(Id activityId) {
        return [
            SELECT Id, Notification__c, Item__c, Activity_No__c, Item__r.Item_No__c, ItemActivity__c
            FROM Activity__c
            WHERE Id = :activityId
        ];
    }
}