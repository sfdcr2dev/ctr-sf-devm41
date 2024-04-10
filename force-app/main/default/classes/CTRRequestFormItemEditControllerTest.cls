@isTest
public class CTRRequestFormItemEditControllerTest {

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
            Type__c = 'Committee TOP' //'Request More Document'
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

        insert new Lead(
            FirstName='Mock', 
            LastName='Test', 
            Company='Test Company',
            RegisteredasCustomer__c = true,
            RegisteredasSupplier__c = true);
    }

    @isTest
    static void testOnloadEditPage_Success() {

        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];

        Test.startTest();

        CTRRequestFormItemEditController.mResultWrapper result = CTRRequestFormItemEditController.onloadEditPage(reqItem.Id);

        Test.stopTest();

        //System.assertEquals('Success', result.mResult);
    }

    @isTest
    static void testOnloadEditPage_Fail() {
        
        CTRRequestFormItem__c reqItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];

        Test.startTest();

        CTRRequestFormItemEditController.mResultWrapper result = CTRRequestFormItemEditController.onloadEditPage(null);

        Test.stopTest();

        System.assertEquals('Failed', result.mResult);
    }
}