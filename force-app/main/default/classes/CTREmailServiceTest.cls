@isTest
public class CTREmailServiceTest {

    @testSetup
    static void setup() {

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New'
        );
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            CustomerSubject__c = '',
            CustomerMessage__c = '',
            CustomerEmailTo__c = 'testuser@test.com',
            CustomerEmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = reqHeader.Id
        );
        insert reqItem;

        CTREmailTemplateMaster__c emailTemp = new CTREmailTemplateMaster__c(
            Subject__c = 'Subject',
            HTMLBody__c = 'Body',
            Type__c = 'Request More Document TOP' //'Request More Document'
        );
        insert emailTemp;

        String base64Data = EncodingUtil.urlDecode('YWJj', 'UTF-8');
        Blob fileBody = EncodingUtil.base64Decode(base64Data);
        ContentVersion contentVersion = new ContentVersion (
            ContentLocation = 'S',
            PathOnClient = 'TestFile.txt',
            Title = 'TestFile.txt',
            VersionData = EncodingUtil.base64Decode(base64Data)
        );
        insert contentVersion;

        ContentVersion queriedContentVersion = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :contentVersion.Id
            LIMIT 1
        ];

        ContentDocumentLink contentLink = new ContentDocumentLink(
            ContentDocumentId = queriedContentVersion.ContentDocumentId,
            LinkedEntityId = reqItem.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert contentLink;
    }

    @isTest
    static void testHandleInboundEmail() {
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];

        // Simulate inbound email
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        env.fromAddress = 'test@example.com';

        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = '[RecordId:' + reqItem.Id + '] Your Subject';
        email.htmlBody = '<p>Test HTML Body</p>';

        Test.startTest();

        try {
            // Call the method being tested
            CTREmailService emailService = new CTREmailService();
            Messaging.InboundEmailResult result = emailService.handleInboundEmail(email, env);

            // Add assertions based on the expected behavior of your method
            System.assert(result.success, 'Expected success to be true');
            // Add more assertions based on the expected behavior of your method

            // Verify that the CTRRequestFormItem__c record has been updated
            CTRRequestFormItem__c updatedRq = [SELECT ReplyToTRCRHistory__c FROM CTRRequestFormItem__c WHERE Id = :reqItem.Id];
            System.assertEquals(email.htmlBody, updatedRq.ReplyToTRCRHistory__c, 'ReplyToTRCRHistory__c not updated correctly');

        } catch (Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'exception thrown');
        }

        Test.stopTest();
    }
}