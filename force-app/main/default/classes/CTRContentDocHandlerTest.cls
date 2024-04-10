@isTest
public class CTRContentDocHandlerTest {
    
    @isTest
    static void testGetTitleFile() {
        createTestData();
        List<ContentDocument> document = getDocument();

        Test.startTest();
        CTRContentDocHandler.getTitleFile(document);
        try {
            CTRContentDocHandler.getTitleFile(null);
        } catch (Exception ex) {
            System.assertNotEquals(null, ex.getMessage());
        }
        Test.stopTest();
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
    
    private static List<ContentDocument> getDocument() {
        return [SELECT Id, Title FROM ContentDocument];
    }
}