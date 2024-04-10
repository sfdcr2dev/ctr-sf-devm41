@isTest
public without sharing class CTRFileUploadControllerTest {

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
    static void testGetFileUploadInfo(){
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];

        Test.startTest();
        Object obj = CTRFileUploadController.getFileUploadInfo('CTRRequestFormItem__c', 'SummarizeReportSubject__c', reqItem.Id);
        Test.stopTest();

        System.assertNotEquals(null, obj);
    }

    @isTest
    static void testUpdateFileUploadInfo(){
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];

        Test.startTest();
        CTRFileUploadController.updateFileUploadInfo('CTRRequestFormItem__c', 'SummarizeReportSubject__c', reqItem.Id,'Update subject');
        Test.stopTest();

        CTRRequestFormItem__c newReqItem = [SELECT Id,SummarizeReportSubject__c FROM CTRRequestFormItem__c LIMIT 1];
        System.assertNotEquals('subject', newReqItem.SummarizeReportSubject__c);
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
        CTRFileUploadController.deleteAttachments(attachmentIds);
        Test.stopTest();
    }

}