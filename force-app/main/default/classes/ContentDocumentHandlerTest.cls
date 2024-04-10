@isTest
public with sharing class ContentDocumentHandlerTest {
    /**
     * @given a File attached to a Notification
     * @when the file is renamed
     * @then the Notification File File_Name__c is updated
     */
    @isTest
    static void testNotificationFileRenamed() {
        createTestData();
        ContentDocument document = getDocument();
        List<Notification_File__c> nFile = getNotificationFileByFileId(document.Id);

        Test.startTest();
        THOR_FileUploadActionController.updateFiles(document.Id, 'NEW NAME');
        Test.stopTest();

        List<Notification_File__c> updatedNFile = getNotificationFileByFileId(document.Id);
        System.assertNotEquals(
            nFile.get(0).File_Name__c,
            updatedNFile.get(0).File_Name__c,
            'File Name should have been updated'
        );
        System.assertEquals('NEW NAME', updatedNFile.get(0).File_Name__c, 'File Name new value should be NEW NAME');
    }

    /**
     * @given a File attached to a Notification
     * @when the file is deleted
     * @then the Notification File record associated is deleted
     */
    @isTest
    static void testNotificationFileDeleted() {
        createTestData();
        ContentDocument document = getDocument();
        List<Notification_File__c> nFile = getNotificationFileByFileId(document.Id);

        Test.startTest();
        delete document;
        Test.stopTest();

        List<Notification_File__c> finalNFiles = getNotificationFileByFileId(document.Id);
        System.assertEquals(nFile.size() - 1, finalNFiles.size(), 'Notification File should have been deleted');
    }

    private static void createTestData() {
        Notification__c notification = new Notification__c(Name = '12345678', Notification_Number__c = '12345678');

        insert notification;

        ContentVersion content = new ContentVersion(
            Title = 'TestFile',
            PathOnClient = '/TestFile.jpg',
            VersionData = Blob.valueOf('Unit Test ContentVersion Body'),
            origin = 'H'
        );

        insert content;

        content = [SELECT Id, ContentDocumentId FROM ContentVersion];

        ContentDocumentLink documentLink = new ContentDocumentLink(
            LinkedEntityId = notification.Id,
            ContentDocumentId = content.ContentDocumentId,
            ShareType = 'V'
        );

        insert documentLink;
    }

    private static ContentDocument getDocument() {
        return [SELECT Id, Title FROM ContentDocument WITH SECURITY_ENFORCED LIMIT 1];
    }

    private static List<Notification_File__c> getNotificationFileByFileId(Id documentId) {
        return [
            SELECT Id, File_Name__c
            FROM Notification_File__c
            WHERE File_Id__c = :documentId
            WITH SECURITY_ENFORCED
        ];
    }
}