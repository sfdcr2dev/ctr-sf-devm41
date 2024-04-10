/**
 * @author Oktana
 * @description test class for ContentDocumentLinkHandler
 */
@isTest
public with sharing class ContentDocumentLinkHandlerTest {
    /**
     * @given a service to record Notification Files
     * @when a File is attached to a notification
     * @then a new Notification File is recorded
     */
    @isTest
    static void testCreateNotificationFile() {
        List<Notification_File__c> initialNotificationFiles = getNotificationFiles();

        Notification__c notification = createTestData();
        ContentVersion content = [SELECT Id, ContentDocumentId FROM ContentVersion];

        ContentDocumentLink documentLink = new ContentDocumentLink(
            LinkedEntityId = notification.Id,
            ContentDocumentId = content.ContentDocumentId,
            ShareType = 'V'
        );

        Test.startTest();
        insert documentLink;
        Test.stopTest();

        List<Notification_File__c> finalNotificationFiles = getNotificationFiles();

        System.assertEquals(
            initialNotificationFiles.size() + 1,
            finalNotificationFiles.size(),
            'A new Notification File should have been created'
        );
    }

    /**
     * @given a service to record Notification Files
     * @when a File is attached to a record that's not a notification
     * @then no new Notification File is recorded
     */
    @isTest
    static void testDoNotCreateNotificationFile() {
        List<Notification_File__c> initialNotificationFiles = getNotificationFiles();

        Order__c order = new Order__c(Name = '12345678');
        insert order;
        Notification__c notification = createTestData();
        ContentVersion content = [SELECT Id, ContentDocumentId FROM ContentVersion];

        ContentDocumentLink documentLink = new ContentDocumentLink(
            LinkedEntityId = order.Id,
            ContentDocumentId = content.ContentDocumentId,
            ShareType = 'V'
        );

        Test.startTest();
        insert documentLink;
        Test.stopTest();

        List<Notification_File__c> finalNotificationFiles = getNotificationFiles();

        System.assertEquals(
            initialNotificationFiles.size(),
            finalNotificationFiles.size(),
            'No new Notification File should have been created'
        );
    }

    private static List<Notification_File__c> getNotificationFiles() {
        return [SELECT Id FROM Notification_File__c];
    }

    private static Notification__c createTestData() {
        Notification__c notification = new Notification__c(Name = '12345678', Notification_Number__c = '12345678');

        insert notification;

        ContentVersion content = new ContentVersion(
            Title = 'TestFile',
            PathOnClient = '/TestFile.jpg',
            VersionData = Blob.valueOf('Unit Test ContentVersion Body'),
            origin = 'H'
        );

        insert content;

        return notification;
    }
}