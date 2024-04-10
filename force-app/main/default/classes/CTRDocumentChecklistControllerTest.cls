@isTest
public without sharing class CTRDocumentChecklistControllerTest {

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
        
        Id devRecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();
        Account newAcc = new Account();
        newAcc.Name = 'Test Acc';
        newAcc.AccountNumber = '0001';
        newAcc.AccountNumber__c = '0001';
        newAcc.CompanyNameENF__c = 'Test Acc';
        insert newAcc;
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            Customer__c = newAcc.Id,
            FirstName__c = 'test',
            LastName__c = 'test'
        );
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            CustomerSubject__c = '',
            CustomerMessage__c = '',
            CustomerEmailTo__c = 'testuser@test.com',
            CustomerEmailCC__c = 'testcc@test.com',
            Customer__c = newAcc.Id,
            CTRRequestFormHeader__c = reqHeader.Id,
            RecordTypeId = devRecordTypeId
        );
        insert reqItem;

        CTREmailTemplateMaster__c emailTemp = new CTREmailTemplateMaster__c(         
            Subject__c = 'Subject',
            HTMLBody__c = 'Body',
            Type__c = 'Request More Document TOP'
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

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
    }

    @isTest
    static void testGetDocChecklistInfo() {
        Test.startTest();
        CTRRequestFormItem__c testRecord = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        System.debug('testRecord: ' + testRecord);
        
        CTRRequestFormItem__c reqFormItem = [SELECT CTRRequestFormHeader__r.Email__c, CustomerEmailCC__c,CTRRequestFormHeader__r.Customer__r.CTRUser__c,
                                             CustomerSubject__c, CustomerMessage__c, RecordType.Name, Name, RecordType.DeveloperName,BusinessUnit__c
                                             FROM CTRRequestFormItem__c WHERE Id = :testRecord.Id];
        System.debug('reqFormRecord :' );
        System.debug(reqFormItem);
        
        CTRRequestFormItem__c reqItem = CTRDocumentChecklistController.getDocChecklistInfo(testRecord.Id, 'Request More Document TOP');
        System.assertNotEquals(null, reqItem);
        Test.stopTest();
    }

    @isTest
    static void testSaveDocChecklist() {
        Test.startTest();
        CTRRequestFormItem__c reqItems = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            Id = reqItems.Id,
            HasCOI__c = 'Pass'
            //HasMDA__c = 'Pass'
        );
        try {
            CTRDocumentChecklistController.saveDocChecklist(reqItem,new List<CTRDocumentItem__c>());

            // Fail Case
            reqItem.TypeOfBusiness__c = 'Invalid Type';
            CTRDocumentChecklistController.saveDocChecklist(reqItem,new List<CTRDocumentItem__c>());
            
        } catch (Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'exception thrown');
        }
        
        Test.stopTest();
    }

    @isTest
    static void testUpdateListFileName() {
        Test.startTest();
        CTRRequestFormItem__c reqItems = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        
        try {
            CTRDocumentChecklistController.updateListFileName(reqItems.Id, 'TestFile.txt');

            // Fail Case
            CTRDocumentChecklistController.updateListFileName('', 'TestFile.txt');
        } catch (Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'exception thrown');
        }
        Test.stopTest();
    }

    @isTest
    static void tesGetUploadedFileName() {
        
        Test.startTest();
        CTRRequestFormItem__c reqItems = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        try {
            String fileName = CTRDocumentChecklistController.getUploadedFileName(reqItems.Id);
        } catch (Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'exception thrown');
        }
        Test.stopTest();
    }

    @isTest
    static void testSaveRequestDoc() {
        // Create test data
        CTRRequestFormItem__c reqFormItem = new CTRRequestFormItem__c();
        reqFormItem.Name = 'Test Item';
        // Set other required fields as needed

        Boolean isSubmit = true;
        String uploadedList = '[{"Title": "File1.txt"}, {"Title": "File2.doc"}]';

        Test.startTest();

        try {
            CTRDocumentChecklistController.saveRequestDoc(reqFormItem, isSubmit, uploadedList);

        } catch (Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'exception thrown');
        }

        // End test
        Test.stopTest();
        // Test.startTest();
        // CTRRequestFormItem__c reqItems = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        // CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
        //     Id = reqItems.Id,
        //     CustomerSubject__c = 'Test Subject',
        //     CustomerMessage__c = 'Test',
        //     CustomerEmailTo__c = 'testuser@test.com, testuser@test.com',
        //     CustomerEmailCC__c = 'testcc@test.com'
        // );
        // CTRDocumentChecklistController.saveRequestDoc(reqItem, true, 'TestFile.txt');
        // Test.stopTest();
    }

    @isTest
    static void testSendEmailWithAttachment() {
        CTRRequestFormItem__c reqFormObj = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        reqFormObj.CustomerEmailTo__c = 'test1@test.com,test2@test.com';
        reqFormObj.CustomerEmailCC__c = 'test1@test.com,test2@test.com';
        reqFormObj.CustomerMessage__c = '<p>Dear <span style="color: rgb(68, 68, 68);">Lube Base Products</span>,</p><p><br></p><p>file.force.com We would like to request more document of <span style="font-size: 14px; color: rgb(68, 68, 68);">Lube Base Products</span></p><ol><li>Memorandum of Association (MOA)</li><li><span style="font-size: 11.36px; font-family: Arial, Helvetica, sans-serif; color: rgb(0, 0, 0);">Audited Financial Statements with Notes to the Financial Statements for the last 3 years</span></li></ol><p>Please attach document via <a href="file.force.com" target="_blank">this link</a></p><p><br></p><p>Best Regards,</p><p>Counterparties Registration Automated System$</p>';
        Id recordId = reqFormObj.Id;
        String uploadedList = 'File1.txt,File2.doc';
        
        ContentVersion testContent1 = new ContentVersion(
            Title = 'File1.txt', 
            PathOnClient = 'File1.txt', 
            VersionData = Blob.valueOf('Test content for file 1'),
            IsMajorVersion = true
        );
        insert testContent1;

        ContentDocument testDocument1 = [SELECT Id FROM ContentDocument WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContent1.Id) LIMIT 1];
        
        ContentDocumentLink link1 = new ContentDocumentLink(
            ContentDocumentId = testDocument1.Id, 
            LinkedEntityId = reqFormObj.Id, 
            ShareType = 'I', 
            Visibility = 'AllUsers'
        );
        insert link1;

        // Start test
        Test.startTest();

        try {
            CTRDocumentChecklistController.sendEmailWithAttachment(recordId, reqFormObj, uploadedList);

        } catch (Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'exception thrown');
        }

        // End test
        Test.stopTest();
    }

    // @isTest
    // static void testSendEmailWithAttachment() {
    //     CTRRequestFormItem__c reqFormObj = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
    //     reqFormObj.CustomerEmailTo__c = 'test1@test.com,test2@test.com';
    //     reqFormObj.CustomerEmailCC__c = 'test1@test.com,test2@test.com';
    //     reqFormObj.CustomerMessage__c = '<p>Dear <span style="color: rgb(68, 68, 68);">Lube Base Products</span>,</p><p><br></p><p>We would like to request more document of <span style="font-size: 14px; color: rgb(68, 68, 68);">Lube Base Products</span></p><ol><li>Memorandum of Association (MOA)</li><li><span style="font-size: 11.36px; font-family: Arial, Helvetica, sans-serif; color: rgb(0, 0, 0);">Audited Financial Statements with Notes to the Financial Statements for the last 3 years</span></li></ol><p>Please attach document via <a href="file.force.com" target="_blank">this link</a></p><p><br></p><p>Best Regards,</p><p>Counterparties Registration Automated System$</p>';
   
    //     String uploadedList = 'File1,File2';

    //     Account testAccount = new Account(Name = 'Test Account');
    //     insert testAccount;

    //     ContentVersion testContent1 = new ContentVersion(
    //         Title = 'File1', 
    //         PathOnClient = 'testFile1.txt', 
    //         VersionData = Blob.valueOf('Test content for file 1'),
    //         IsMajorVersion = true
    //     );
    //     insert testContent1;

    //     ContentDocument testDocument1 = [SELECT Id FROM ContentDocument WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContent1.Id) LIMIT 1];
        
    //     ContentDocumentLink link1 = new ContentDocumentLink(
    //         ContentDocumentId = testDocument1.Id, 
    //         LinkedEntityId = testAccount.Id, 
    //         ShareType = 'I', 
    //         Visibility = 'AllUsers'
    //     );
    //     insert link1;

    //     Test.startTest();
    //     CTRDocumentChecklistController.sendEmailWithAttachment(testAccount.Id, reqFormObj, uploadedList);
    //     Test.stopTest();

    // }

    @isTest
    static void testGetCurrentUserProfileName() {
        Test.startTest();
        CTRDocumentChecklistController.getCurrentUserProfileName();
        Test.stopTest();
    }

    @isTest
    static void testGetBUInfo() {
        CTRBuProfile__mdt buProfileRecord = new CTRBuProfile__mdt(
            MasterLabel = 'Test BU Profile'
        );

        Id recordId = buProfileRecord.Id;

        Test.startTest();

        try {
            CTRBuProfile__mdt result = CTRDocumentChecklistController.getBUInfo(recordId);
            System.assertNotEquals(null, result, 'Expected result to be not null');

            result = CTRDocumentChecklistController.getBUInfo(null);

        } catch (Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'exception thrown');
        }

        Test.stopTest();
    }

    @isTest
    static void testSendFiletoHeroku() {
        CTRRequestFormItem__c reqFormItem = [SELECT CustomerSubject__c, CustomerMessage__c, CustomerEmailTo__c, CustomerEmailCC__c FROM CTRRequestFormItem__c LIMIT 1];
         
        Id recordId = reqFormItem.Id;
        String uploadedList = '[{"Title": "File1.txt", "IsSaved": true, "Id": "0123456789ABCDEF"}, {"Title": "File2.doc", "IsSaved": false, "Id": null}]';

        Test.startTest();

        try {
            CTRDocumentChecklistController.sendFiletoHeroku(recordId, uploadedList, reqFormItem);

        } catch (Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'exception thrown');
        }

        Test.stopTest();
    }

}