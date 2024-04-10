@isTest
public without sharing class CTRFileUploaderControllerTest {

    @testSetup
    static void setup() {
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New'
        );
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            SummarizeReportSubject__c = 'subject',
            SummarizeReportMessage__c = 'message',
            SummarizeReportEmailTo__c = 'testuser@test.com',
            SummarizeReportEmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = reqHeader.Id
        );
        insert reqItem;

        String base64Data = EncodingUtil.urlDecode('YWJj', 'UTF-8');
        Blob fileBody = EncodingUtil.base64Decode(base64Data);
        ContentVersion contentVersion = new ContentVersion (
            ContentLocation = 'S',
            PathOnClient = 'TestFile.txt',
            Title = 'TestFile.txt',
            VersionData = EncodingUtil.base64Decode(base64Data)
        );
        insert contentVersion;

        ContentVersion queriedContentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];

        ContentDocumentLink contentLink = new ContentDocumentLink(
            ContentDocumentId = queriedContentVersion.ContentDocumentId,
            LinkedEntityId = reqItem.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert contentLink;
    }

    @isTest
    static void testSaveFiles() {
        Test.startTest();
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        Id parentId = reqItem.Id;
        String fileName = 'TestFile.txt';
        String base64Data = EncodingUtil.base64Encode(Blob.valueOf('YWJj'));

        Id contentVersionId = CTRFileUploaderController.saveFiles(parentId, fileName, base64Data);
        Test.stopTest();
    }

    @isTest
    static void testGetAttachments() {
        Test.startTest();
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        List<ContentDocument> results = CTRFileUploaderController.getAttachments(reqItem.Id, 'TestFile2.txt');
        System.assertEquals(0, results.size());
        
        results = CTRFileUploaderController.getAttachments(reqItem.Id, 'TestFile.txt');
        System.assertEquals(1, results.size());
        Test.stopTest();
    }

    @isTest
    static void testGetAttachmentDetails() {
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        Test.startTest();
        List<ContentDocument> results = CTRFileUploaderController.getAttachmentDetails(reqItem.Id, 'TestFile.txt',false);
        List<ContentDocument> resultsById = CTRFileUploaderController.getAttachmentDetails(reqItem.Id, 'TestFile.txt',true);
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals(0, resultsById.size());

    }

    @isTest
    static void testDeleteAttachments() {
        Test.startTest();
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        List<Id> attachmentIds = new List<Id>();
        List<ContentVersion> contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion];
        for (ContentVersion ctv : contentVersion) {
            attachmentIds.add(ctv.ContentDocumentId);
        }
        CTRFileUploaderController.deleteAttachments(attachmentIds);
        Test.stopTest();
    }

}