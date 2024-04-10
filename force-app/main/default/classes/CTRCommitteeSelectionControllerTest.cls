@isTest
public without sharing class CTRCommitteeSelectionControllerTest {
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success"}');
            return res;
        }
    }

    @TestSetup
    static void setup(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser1 = new User(
            FirstName = 'Test',
            LastName = 'User 1',
            Email = 'testuser1@example.test',
            Username = 'testuser1@example.test',
            ProfileId = testProfile.Id,
            Alias = 'tuser1',
            CommunityNickname = 'testuser1',
            TimeZoneSidKey = 'Asia/Bangkok',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser1;

        User testUser2 = new User(
            FirstName = 'Test',
            LastName = 'User 2',
            Email = 'testuser2@example.test',
            Username = 'testuser2@example.test',
            ProfileId = testProfile.Id,
            Alias = 'tuser2',
            CommunityNickname = 'testuser2',
            TimeZoneSidKey = 'Asia/Bangkok',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;

        PISUsers__c testPISUser1 = new PISUsers__c(
            User__c = testUser1.Id,
            ENFIRSTNAME__c = 'Test User 1',
            EMPLOYEEID__c = '1001',
            ReportToID__c = '1002',
            ReportToPOS__c = 'P1002',
            POSID__c = 'P1001',
            Name = 'Test User 2'
        );
        insert testPISUser1;

        PISUsers__c testPISUser2 = new PISUsers__c(
            User__c = testUser2.Id,
            ENFIRSTNAME__c = 'Test User 2',
            EMPLOYEEID__c = '1002',
            ReportToID__c = '1003',
            ReportToPOS__c = 'P1003',
            POSID__c = 'P1002',
            Name = 'Test User 2'
        );
        insert testPISUser2;

        Account newAcc = new Account();
        newAcc.Name = 'Test Acc';
        newAcc.AccountNumber = '0001';
        newAcc.AccountNumber__c = '0001';
        newAcc.CompanyNameENF__c = 'Test Acc';
        insert newAcc;

        RecordType reqItemRTCus = [SELECT Id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial'];
        RecordType reqItemRTSup = [SELECT Id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'SupplierInitial'];

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            Customer__c = newAcc.id
        );
        insert reqHeader;

        CTRRequestFormItem__c reqItem1 = new CTRRequestFormItem__c(
            Name = 'Test Request Form Item 1',
            Subject__c = '',
            Message__c = '',
            EmailTo__c = 'testuser@test.com',
            EmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = reqHeader.Id,
            CommitteeOwner__c = testUser1.Id,
            RecordTypeId = reqItemRTCus.Id
        );
        insert reqItem1;

        CTRRequestFormItem__c reqItem2 = new CTRRequestFormItem__c(
            Name = 'Test Request Form Item 2',
            Subject__c = '',
            Message__c = '',
            EmailTo__c = 'testuser@test.com',
            EmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = reqHeader.Id,
            CommitteeOwner__c = testUser1.Id,
            RecordTypeId = reqItemRTSup.Id
        );
        insert reqItem2;

        CTREmailTemplateMaster__c emailTemp1 = new CTREmailTemplateMaster__c(
            Subject__c = 'Subject',
            HTMLBody__c = 'Body',
            Type__c = 'Committee TOP'
        );
        insert emailTemp1;

        CTREmailTemplateMaster__c emailTemp2 = new CTREmailTemplateMaster__c(
            Subject__c = 'Subject',
            HTMLBody__c = 'Body',
            Type__c = 'Committee TX'
        );
        insert emailTemp2;

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
            LinkedEntityId = reqItem1.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert contentLink;

        Profile profileTOP = [SELECT Id FROM Profile WHERE Name = 'TOP'];
        User userTOP = new User(
            ProfileId = profileTOP.Id,
            Username = 'testusertop@example.com',
            Email = 'testusertop@example.com',
            Alias = 'topuser',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'TOP',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert userTOP;

        CTRCommitteeApproval__c newCommAppr = new CTRCommitteeApproval__c(
            CTRRequestFormItem__c = reqItem1.Id,
            ApprovalDate__c = Date.today(),
            ApprovalResult__c = 'Waiting Section Head Review',
            ApproverName__c = userTOP.Id,
            Remark__c = ''
        );
        insert newCommAppr;

        CTRConfig__c config = new CTRConfig__c();
        config.RemindDate__c = 3;
        insert config;

        C360Integration__c c360Integration = new C360Integration__c(
            SharePoint_TenantName__c = 'testTenant',
            SharePoint_SiteName__c = 'testSite',
            SharePoint_Document_Folder__c = 'testFolder',
            SharePointMainFolderDuringCreate__c = 'AccountDev'
        );
        insert c360Integration;
    }

    @isTest
    static void testGetGroupedCommittees() {
        Test.startTest();
        CTRCommitteeSelectionController.getGroupedCommittees();
        Test.stopTest();
    }

    @isTest
    static void testGetCommitteeInfo() {
        Test.startTest();
        List<CTRRequestFormItem__c> testRecord = [SELECT Id FROM CTRRequestFormItem__c];
        CTRCommitteeSelectionController.getCommitteeInfo(testRecord[0].Id, 'Committee TOP');
        //CTRCommitteeSelectionController.getCommitteeInfo(testRecord[1].Id, 'Committee TOP');
        Test.stopTest();
    }

    @isTest
    static void testSaveReqFormItem() {
        CTRRequestFormItem__c testRecord = [SELECT Id, Name, Subject__c, Message__c, EmailTo__c, EmailCC__c, CommitteeName__c FROM CTRRequestFormItem__c LIMIT 1];
        testRecord.Subject__c = 'subject';
        testRecord.Message__c = 'message';
        testRecord.EmailTo__c = 'testuser@test.com';
        testRecord.EmailCC__c = 'testcc@test.com';
        testRecord.CommitteeName__c = 'TOP User';

        update testRecord;

        Test.startTest();
        CTRCommitteeSelectionController.saveReqFormItem(testRecord.Id, testRecord, true, '[{"Title":"File1.txt"}, {"Title":"File2.txt"}]', 'Committee TOP', 'TOP');
        Test.stopTest();

        CTRRequestFormItem__c updatedRecord = [SELECT Id, Status__c, Approval_Step__c, RemindDate__c, CommitteeStatus__c FROM CTRRequestFormItem__c WHERE Id = :testRecord.Id LIMIT 1];
        System.assertEquals('Approval In Progress', updatedRecord.Status__c, 'Status: "Approval In Progress"');
        System.assertEquals('Waiting for Approval', updatedRecord.Approval_Step__c, 'Approval Step:: "Waiting for Approval"');
        System.assertNotEquals(null, updatedRecord.RemindDate__c, 'Remind Date: Not NULL');
        System.assertEquals('Submitted', updatedRecord.CommitteeStatus__c, 'Committee Status: "Submitted"');
    }

    @isTest
    static void testSaveReqFormItemProfileTX() {
        CTRRequestFormItem__c testRecord = [SELECT Id, Name, Subject__c, Message__c, EmailTo__c, EmailCC__c, CommitteeName__c FROM CTRRequestFormItem__c LIMIT 1];
        testRecord.Subject__c = 'subject';
        testRecord.Message__c = 'message';
        testRecord.EmailTo__c = 'testuser@test.com';
        testRecord.EmailCC__c = 'testcc@test.com';
        testRecord.CommitteeName__c = 'TOP User';
        update testRecord;


        Test.startTest();
        CTRCommitteeSelectionController.saveReqFormItem(testRecord.Id, testRecord, true, '[{"Title":"File1.txt"}, {"Title":"File2.txt"}]', 'Committee TOP', 'TX');
        Test.stopTest();

        CTRRequestFormItem__c updatedRecord = [SELECT Id, Status__c, Approval_Step__c, RemindDate__c, CommitteeStatus__c FROM CTRRequestFormItem__c WHERE Id = :testRecord.Id LIMIT 1];
        System.assertEquals('Approval In Progress', updatedRecord.Status__c, 'Status: "Approval In Progress"');
        System.assertEquals('Waiting for Approval', updatedRecord.Approval_Step__c, 'Approval Step:: "Waiting for Approval"');
        System.assertNotEquals(null, updatedRecord.RemindDate__c, 'Remind Date: Not NULL');
        System.assertEquals('Submitted', updatedRecord.CommitteeStatus__c, 'Committee Status: "Submitted"');
    }

    @isTest
    static void testSaveReqFormItemAndSubmitToSH() {
        CTRCommittee__mdt committee = [SELECT Id, DeveloperName FROM CTRCommittee__mdt LIMIT 1];
        CTRRequestFormItem__c testRecord = [SELECT Id, Name, Subject__c, Message__c, EmailTo__c, EmailCC__c, CommitteeName__c FROM CTRRequestFormItem__c LIMIT 1];
        testRecord.Subject__c = 'subject';
        testRecord.Message__c = 'message';
        testRecord.EmailTo__c = 'testuser@test.com';
        testRecord.EmailCC__c = 'testcc@test.com';
        testRecord.CommitteeName__c = committee.DeveloperName;
        update testRecord;

        Test.startTest();
        CTRCommitteeSelectionController.saveReqFormItemAndSubmitToSH(testRecord.Id, testRecord, true, '[{"Title":"File1.txt"}, {"Title":"File2.txt"}]', 'Committee TOP', 'TOP');
        Test.stopTest();

        // Assertions
        CTRRequestFormItem__c updatedRecord = [SELECT Id, RevertedTRCRSH__c, CommitteeStatus__c FROM CTRRequestFormItem__c WHERE Id = :testRecord.Id LIMIT 1];
        System.assertEquals(false, updatedRecord.RevertedTRCRSH__c, 'RevertedTRCRSH: false');
        System.assertEquals('Waiting Section Head Review', updatedRecord.CommitteeStatus__c, 'CommitteeStatus: "Waiting Section Head Review"');
    }

    @isTest
    static void testRevertToTRCR() {
        List<CTRRequestFormItem__c> testRecord = [SELECT Id FROM CTRRequestFormItem__c];
        Test.startTest();
        CTRCommitteeSelectionController.revertToTRCR(testRecord[0].Id, 'Please, revise credit condition');
        Test.stopTest();
    }

    @isTest
    static void testSendFiletoHeroku() {
        CTRRequestFormItem__c testRecord = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        String uploadedList = '[{"Title": "File1.txt", "Id": "1"}, {"Title": "File2.txt", "Id": "2"}]';

        Test.startTest();
        CTRCommitteeSelectionController.sendFiletoHeroku(testRecord.Id, uploadedList);
        Test.stopTest();

        CTRRequestFormItem__c updatedRecord = [SELECT CommitteeAttachment__c FROM CTRRequestFormItem__c WHERE Id = :testRecord.Id LIMIT 1];
        System.assertEquals(null, updatedRecord.CommitteeAttachment__c, 'CommitteeAttachment__c should be blank');
    }

    @isTest
    static void testGetTRCR() {
        CTRRequestFormItem__c testRecord = [SELECT Id, Name, Subject__c, Message__c, EmailTo__c, EmailCC__c, CommitteeName__c,SalesOrganizationTX__c,SalesOrganization__c FROM CTRRequestFormItem__c LIMIT 1];
        testRecord.SalesOrganizationTX__c = '1100';
        testRecord.SalesOrganization__c = '1100';

        Test.startTest();
        CTRCommitteeSelectionController.getTRCR('TLB', 'Customer', 'International','','No');
        Test.stopTest();
    }
}