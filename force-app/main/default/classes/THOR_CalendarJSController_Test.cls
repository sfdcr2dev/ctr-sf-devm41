@isTest
public with sharing class THOR_CalendarJSController_Test {
    @TestSetup
    static void makeData() {
        List<Notification__c> insertme = new List<Notification__c>();
        Id userId = UserInfo.getUserId();
        for (Integer i = 0; i < 10; i++) {
            insertme.add(new Notification__c(AssignedTo__c = userId, Description__c = 'Test ' + String.valueOf(i)));
        }
        insert insertme;
    }

    @isTest
    static void testGetNotifications() {
        Test.startTest();
        List<Notification__c> testme = THOR_CalendarJSController.getNotifications();
        Test.stopTest();

        System.assertEquals(10, testme.size(), 'Test Failed');
    }

    @isTest
    static void testGetIsMobile() {
        Test.startTest();
        Boolean testme = THOR_CalendarJSController.getIsMobile();
        Test.stopTest();

        System.assertEquals(false, testme, 'Test Failed');
    }
}