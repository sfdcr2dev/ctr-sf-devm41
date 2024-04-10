@isTest
private class C360_ReplicatedSAP_CCATest {

    @testSetup
    static void setup() {
        Account customer = new Account(
            Name='test',
            AccountNumber__c='510001'
        );
        insert customer;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New'
        );
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            CustomerSubject__c = '',
            CustomerMessage__c = '',
            CustomerEmailTo__c = 'testuser@test.com',
            CustomerEmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = reqHeader.Id,
            SAPStatus__c = 'Queue CCA', //'Pending CCA'
            SalesOrganization__c = '1100',
            Customer__c = customer.Id
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
    static void testParse() {
        
        String json = '{"CCALIST": [{"CCA" : "1100", "SAPCODE" : "510001"}]}'; 
        
        Test.startTest();
        
        C360_ReplicatedSAP_CCA.dto_response response = C360_ReplicatedSAP_CCA.parse(json);
        
        Test.stopTest();
    }

    @isTest
    static void testExecute() {
        
        Map<String, Object> requestBody = new Map<String, Object>{
            'gateway_id' => 'sample_gateway_id',
            'body' => '{"CCALIST": [{"CCA" : "1100", "SAPCODE" : "510001"}]}' 
        };
        RestRequest request = new RestRequest(); 
        
        Test.startTest();
        
        C360_ReplicatedSAP_CCA.dto_response response = C360_ReplicatedSAP_CCA.execute(requestBody, request);
        
        requestBody = new Map<String, Object>{
            'gateway_id' => 'sample_gateway_id',
            'body' => '{"key": "invalid"}' 
        };
        response = C360_ReplicatedSAP_CCA.execute(requestBody, request);
        
        Test.stopTest();
    }

    @isTest
    static void testParseJSONInputs() {
        
        String body = '{"CCALIST": [{"CCA" : "1100", "SAPCODE" : "510001"}]}'; 
        
        Test.startTest();
        
        C360_ReplicatedSAP_CCA.parseJSONInputs(body);
        
        Test.stopTest();
    }

    @isTest
    static void testStringToDate() {
        
        Test.startTest();
        
        Date result = C360_ReplicatedSAP_CCA.StringToDate('2023-01-30');
        System.assertNotEquals(null, result);
        
        Test.stopTest();
    }
}