@isTest
public without sharing class CTRSummarizeReportControllerTest {
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success"}');
            return res;
        }
    }
    
    @testSetup
    static void setup() {
        C360Integration__c c360Integration = new C360Integration__c(
            SharePoint_TenantName__c = 'testTenant',
            SharePoint_SiteName__c = 'testSite',
            SharePoint_Document_Folder__c = 'testFolder',
            SharePointMainFolderDuringCreate__c = 'AccountDev'
        );
        insert c360Integration;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New'
        );
        insert reqHeader;

        user userRunTest =  [SELECT Id,Email FROM User WHERE Id = :UserInfo.getUserId() Limit 1];
        System.debug('userRunTest ---> '+ userRunTest);

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Id recordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            SummarizeReportSubject__c = '',
            SummarizeReportMessage__c = '',
            SummarizeReportEmailTo__c = 'testuser@test.com',
            SummarizeReportEmailCC__c = 'testcc@test.com',
            Customer__c = acc.Id,
            FinCrCond__c = 'Open Account',
            FinPaymentCond__c = 'Test',
            SalesOrganization__c = '1100',
            recordTypeId = recordTypeId,
            InterestedProductTypeAsCustomerTOP__c = 'Crude',
            CTRRequestFormHeader__c = reqHeader.Id,
            OwnerId = userRunTest.Id
        );
        insert reqItem;

        CTREmailTemplateMaster__c emailTemp = new CTREmailTemplateMaster__c(
            Subject__c = 'Subject',
            HTMLBody__c = '<p><span style="font-size: 13px;">Dear All,</span></p><p><br></p><p><span style="font-size: 13px;"> We would like to inform that {$AccountName$} was Approved by Commitee-CMVP with the following condition.</span></p><p><span style="font-size: 13px;"> Company Name: {$AccountName$}</span></p><p><span style="font-size: 13px;"> Interested to be: Customer: {$ProductName$}</span></p><p><span style="font-size: 13px;"> Credit Condition: {$Credit_Condition$}: {$PaymentCondition$}</span></p><p><br></p><p><span style="font-size: 13px;"> Please see the details and proceed via this link.</span></p><p><br></p><p><span style="font-size: 13px;">Best Regards,</span></p><p><span style="font-size: 13px;">Conterparties Registration Automated System</span></p><p><span style="font-size: 13px;">This is an automatic generated email. Please do not reply to this address.</span></p>',
            Type__c = 'Summarize Report TOP'
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
    static void testGetSummarizeReportInfo() {
        CTRRequestFormItem__c testRecord = [SELECT Id,OwnerId,Owner.Email FROM CTRRequestFormItem__c LIMIT 1];
        System.debug('testRecord: ' + testRecord);
        System.debug('Email: ' + testRecord.Owner.Email);
        
        Test.startTest();
        CTRRequestFormItem__c result = CTRSummarizeReportController.getSummarizeReportInfo(testRecord.Id, 'Summarize Report TOP');
        Test.stopTest();
        System.debug('result records : ' + result);
    }

    @isTest
    static void testUpdateListFileName() {
        Test.startTest();
        CTRRequestFormItem__c testRecord = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        CTRSummarizeReportController.updateListFileName(testRecord.Id, 'TestFile.txt');
        Test.stopTest();
    }

    @isTest
    static void testGetUploadedFileName() {
        Test.startTest();
        CTRRequestFormItem__c testRecord = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        CTRSummarizeReportController.getUploadedFileName(testRecord.Id);
        Test.stopTest();
    }

    @isTest
    static void testSaveSummarizeReport() {
        CTRRequestFormItem__c reqItems = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            Id = reqItems.Id,
            SummarizeReportSubject__c = 'Test Subject',
            SummarizeReportMessage__c = 'Test',
            SummarizeReportEmailTo__c = 'testuser@test.com, testuser@test.com',
            SummarizeReportEmailCC__c = 'testcc@test.com'
        );

        System.debug('reqItem ---->' + reqItem);

        // Run test code as the test user
        user userRunTest =  [SELECT Id,Email FROM User WHERE Id = :UserInfo.getUserId() Limit 1];
        Test.startTest();
        CTRSummarizeReportController.saveSummarizeReport(reqItem, false, '[{"Title": "TestFile.txt"}]','');
        CTRSummarizeReportController.saveSummarizeReport(reqItem, true,  '[{"Title": "TestFile.txt"}]','');
        Test.stopTest();

        CTRRequestFormItem__c updatedResult = [SELECT Id,SummarizeReportSubject__c,SummarizeReportMessage__c FROM CTRRequestFormItem__c LIMIT 1];
        System.assertEquals(updatedResult.SummarizeReportSubject__c, 'Test Subject');
        System.assertEquals(updatedResult.SummarizeReportMessage__c, 'Test');
    }
    
    @isTest
    static void testsendFiletoHeroku() {
        CTRRequestFormItem__c testRecord = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];

        Test.startTest();
        CTRSummarizeReportController.sendFiletoHeroku(testRecord.Id,'[{"Title": "TestFile.txt","IsSaved": false}]');
        Test.stopTest();
    }

    @isTest
    static void testGetCurrentUserProfileName() {
        CTRRequestFormItem__c testRecord = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        Test.startTest();
        CTRSummarizeReportController.getCurrentUserProfileName(testRecord.Id);
        Test.stopTest();
    }
}