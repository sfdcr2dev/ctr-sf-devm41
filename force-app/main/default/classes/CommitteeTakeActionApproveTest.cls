@isTest
public with sharing class CommitteeTakeActionApproveTest {

    @TestSetup
    static void makeData(){
        OrgWideEmailAddress orgWide = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName = 'Commercial Team' LIMIT 1];

        CTRConfig__c setting = new CTRConfig__c();
        setting.Name = 'Test Setting';
        setting.EmailService__c = 'test@test.com';
        setting.OrgWideEmailAddress__c = orgWide.Address;
        insert setting;
        // Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        // User testUser1 = new User(
        //     FirstName = 'Test',
        //     LastName = 'User 1',
        //     Email = 'testuser1@example.test',
        //     Username = 'testuser1@example.test',
        //     ProfileId = testProfile.Id,
        //     Alias = 'tuser1',
        //     CommunityNickname = 'testuser1',
        //     TimeZoneSidKey = 'Asia/Bangkok',
        //     LocaleSidKey = 'en_US',
        //     EmailEncodingKey = 'UTF-8',
        //     LanguageLocaleKey = 'en_US'
        // );
        // insert testUser1;

        // CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        // reqHeader.Name = 'Test Header';
        // insert reqHeader;

        // RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerExtend' limit 1];
        // CTRRequestFormItem__c reqItemConditionTrue = new CTRRequestFormItem__c();
        // reqItemConditionTrue.Name = 'TestConditionTrue Item';
        // reqItemConditionTrue.CTRRequestFormHeader__c = reqHeader.Id;
        // reqItemConditionTrue.RecordTypeId = rt.Id;
        // reqItemConditionTrue.EmailTo__c = 'testemailto@test.com';
        // reqItemConditionTrue.EmailCC__c = 'testemailcc@test.com';
        // reqItemConditionTrue.CommitteeOwner__c = testUser1.Id;
        // insert reqItemConditionTrue;

        // CTRRequestFormItem__c reqItemConditionFalse = new CTRRequestFormItem__c();
        // reqItemConditionFalse.Name = 'TestConditionFalse Item';
        // reqItemConditionFalse.CTRRequestFormHeader__c = reqHeader.Id;
        // reqItemConditionFalse.RecordTypeId = rt.Id;
        // reqItemConditionFalse.EmailTo__c = 'testemailto@test.com';
        // reqItemConditionFalse.EmailCC__c = 'testemailcc@test.com';
        // reqItemConditionFalse.CommitteeOwner__c = testUser1.Id;
        // insert reqItemConditionFalse;

        // CTRCommitteeApproval__c ctrApproveConditionTrue = new CTRCommitteeApproval__c();
        // ctrApproveConditionTrue.Name = 'TestConditionTrue Approve';
        // ctrApproveConditionTrue.ApprovalResult__c = 'Submit to Committee';
        // ctrApproveConditionTrue.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        // ctrApproveConditionTrue.ApproverName__c = testUser1.Id;
        // insert ctrApproveConditionTrue;

        // CTRCommitteeApproval__c ctrApproveConditionTrue2 = new CTRCommitteeApproval__c();
        // ctrApproveConditionTrue2.Name = 'TestConditionTrue Approve2';
        // ctrApproveConditionTrue2.ApprovalResult__c = 'Submit to Committee';
        // ctrApproveConditionTrue2.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        // ctrApproveConditionTrue2.ApproverName__c = testUser1.Id;
        // insert ctrApproveConditionTrue2;

        // CTRCommitteeApproval__c ctrApproveConditionFalse = new CTRCommitteeApproval__c();
        // ctrApproveConditionFalse.Name = 'TestConditionFalse Approve';
        // ctrApproveConditionFalse.ApprovalResult__c = 'Submit to Committee';
        // ctrApproveConditionFalse.CTRRequestFormItem__c = reqItemConditionFalse.Id;
        // ctrApproveConditionFalse.ApproverName__c = testUser1.Id;
        // insert ctrApproveConditionFalse;
    }

    @isTest
    public static void submitProcrssApprovalRequestConditionTrueTest() {
        
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

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name = 'Test Header';
        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerExtend' limit 1];
        CTRRequestFormItem__c reqItemConditionTrue = new CTRRequestFormItem__c();
        reqItemConditionTrue.Name = 'TestConditionTrue Item';
        reqItemConditionTrue.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionTrue.RecordTypeId = rt.Id;
        reqItemConditionTrue.EmailTo__c = 'testemailto@test.com';
        reqItemConditionTrue.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionTrue.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionTrue;

        CTRRequestFormItem__c reqItemConditionFalse = new CTRRequestFormItem__c();
        reqItemConditionFalse.Name = 'TestConditionFalse Item';
        reqItemConditionFalse.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionFalse.RecordTypeId = rt.Id;
        reqItemConditionFalse.EmailTo__c = 'testemailto@test.com';
        reqItemConditionFalse.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionFalse.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionFalse;

        CTRCommitteeApproval__c ctrApproveConditionTrue = new CTRCommitteeApproval__c();
        ctrApproveConditionTrue.Name = 'TestConditionTrue Approve';
        ctrApproveConditionTrue.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionTrue.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        ctrApproveConditionTrue.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionTrue;

        CTRCommitteeApproval__c ctrApproveConditionTrue2 = new CTRCommitteeApproval__c();
        ctrApproveConditionTrue2.Name = 'TestConditionTrue Approve2';
        ctrApproveConditionTrue2.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionTrue2.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        ctrApproveConditionTrue2.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionTrue2;

        CTRCommitteeApproval__c ctrApproveConditionFalse = new CTRCommitteeApproval__c();
        ctrApproveConditionFalse.Name = 'TestConditionFalse Approve';
        ctrApproveConditionFalse.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionFalse.CTRRequestFormItem__c = reqItemConditionFalse.Id;
        ctrApproveConditionFalse.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionFalse;

        Test.startTest();

        String appreovalAction = 'Approved';
        String remark = 'Approved it';
        Boolean sendFormSFDC = true;
        // User testUser1 = [SELECT Id FROM User WHERE FirstName = 'Test' LIMIT 1];
        System.runAs(testUser1) {
            CommitteeTakeActionApprove.submitProcrssApprovalRequest(reqItemConditionTrue.Id, appreovalAction, remark, sendFormSFDC);

            String result = CommitteeTakeActionApprove.getCTRCommitteeApprovalId(reqItemConditionTrue.Id);

            result = CommitteeTakeActionApprove.getActionButton(reqItemConditionTrue.Id);
            System.assertNotEquals(null, result);
        }
        Test.stopTest();
    }

    @isTest
    public static void submitProcrssApprovalRequestConditionFalseTest() {

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

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name = 'Test Header';
        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerExtend' limit 1];
        CTRRequestFormItem__c reqItemConditionTrue = new CTRRequestFormItem__c();
        reqItemConditionTrue.Name = 'TestConditionTrue Item';
        reqItemConditionTrue.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionTrue.RecordTypeId = rt.Id;
        reqItemConditionTrue.EmailTo__c = 'testemailto@test.com';
        reqItemConditionTrue.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionTrue.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionTrue;

        CTRRequestFormItem__c reqItemConditionFalse = new CTRRequestFormItem__c();
        reqItemConditionFalse.Name = 'TestConditionFalse Item';
        reqItemConditionFalse.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionFalse.RecordTypeId = rt.Id;
        reqItemConditionFalse.EmailTo__c = 'testemailto@test.com';
        reqItemConditionFalse.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionFalse.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionFalse;

        CTRCommitteeApproval__c ctrApproveConditionTrue = new CTRCommitteeApproval__c();
        ctrApproveConditionTrue.Name = 'TestConditionTrue Approve';
        ctrApproveConditionTrue.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionTrue.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        ctrApproveConditionTrue.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionTrue;

        CTRCommitteeApproval__c ctrApproveConditionTrue2 = new CTRCommitteeApproval__c();
        ctrApproveConditionTrue2.Name = 'TestConditionTrue Approve2';
        ctrApproveConditionTrue2.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionTrue2.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        ctrApproveConditionTrue2.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionTrue2;

        CTRCommitteeApproval__c ctrApproveConditionFalse = new CTRCommitteeApproval__c();
        ctrApproveConditionFalse.Name = 'TestConditionFalse Approve';
        ctrApproveConditionFalse.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionFalse.CTRRequestFormItem__c = reqItemConditionFalse.Id;
        ctrApproveConditionFalse.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionFalse;
        // CTRCommitteeApproval__c reqItemConditionFalse = [SELECT Id FROM CTRCommitteeApproval__c WHERE Name ='TestConditionFalse Approve'];
        
        Test.startTest();
        String appreovalAction = 'Approved';
        String remark = 'Approved it';
        Boolean sendFormSFDC = false;
        // User testUser1 = [SELECT Id FROM User WHERE FirstName = 'Test' LIMIT 1];
        System.runAs(testUser1) {
            CommitteeTakeActionApprove.submitProcrssApprovalRequest(ctrApproveConditionFalse.Id, appreovalAction, remark, sendFormSFDC);
        }
        
        Test.stopTest();
    }


    @isTest
    public static void submitReplyToReplyTRCRest() {
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

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name = 'Test Header';
        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerExtend' limit 1];
        CTRRequestFormItem__c reqItemConditionTrue = new CTRRequestFormItem__c();
        reqItemConditionTrue.Name = 'TestConditionTrue Item';
        reqItemConditionTrue.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionTrue.RecordTypeId = rt.Id;
        reqItemConditionTrue.EmailTo__c = 'testemailto@test.com';
        reqItemConditionTrue.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionTrue.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionTrue;

        CTRRequestFormItem__c reqItemConditionFalse = new CTRRequestFormItem__c();
        reqItemConditionFalse.Name = 'TestConditionFalse Item';
        reqItemConditionFalse.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionFalse.RecordTypeId = rt.Id;
        reqItemConditionFalse.EmailTo__c = 'testemailto@test.com';
        reqItemConditionFalse.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionFalse.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionFalse;

        CTRCommitteeApproval__c ctrApproveConditionTrue = new CTRCommitteeApproval__c();
        ctrApproveConditionTrue.Name = 'TestConditionTrue Approve';
        ctrApproveConditionTrue.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionTrue.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        ctrApproveConditionTrue.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionTrue;

        CTRCommitteeApproval__c ctrApproveConditionTrue2 = new CTRCommitteeApproval__c();
        ctrApproveConditionTrue2.Name = 'TestConditionTrue Approve2';
        ctrApproveConditionTrue2.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionTrue2.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        ctrApproveConditionTrue2.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionTrue2;

        CTRCommitteeApproval__c ctrApproveConditionFalse = new CTRCommitteeApproval__c();
        ctrApproveConditionFalse.Name = 'TestConditionFalse Approve';
        ctrApproveConditionFalse.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionFalse.CTRRequestFormItem__c = reqItemConditionFalse.Id;
        ctrApproveConditionFalse.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionFalse;

        CTRCommitteeApproval__c ctrApprove = [SELECT Id FROM CTRCommitteeApproval__c WHERE Name ='TestConditionTrue Approve'];
        String message = 'Message Test ReplyTRCR';
        String actionButton = 'ReplyTRCR';
        Test.startTest();
        CommitteeTakeActionApprove.submitReplyTo(ctrApproveConditionTrue.Id, message, actionButton);
        Test.stopTest();
    }

    @isTest
    public static void submitReplyToReplyFARest() {
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

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name = 'Test Header';
        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerExtend' limit 1];
        CTRRequestFormItem__c reqItemConditionTrue = new CTRRequestFormItem__c();
        reqItemConditionTrue.Name = 'TestConditionTrue Item';
        reqItemConditionTrue.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionTrue.RecordTypeId = rt.Id;
        reqItemConditionTrue.EmailTo__c = 'testemailto@test.com';
        reqItemConditionTrue.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionTrue.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionTrue;

        CTRRequestFormItem__c reqItemConditionFalse = new CTRRequestFormItem__c();
        reqItemConditionFalse.Name = 'TestConditionFalse Item';
        reqItemConditionFalse.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionFalse.RecordTypeId = rt.Id;
        reqItemConditionFalse.EmailTo__c = 'testemailto@test.com';
        reqItemConditionFalse.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionFalse.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionFalse;

        CTRCommitteeApproval__c ctrApproveConditionTrue = new CTRCommitteeApproval__c();
        ctrApproveConditionTrue.Name = 'TestConditionTrue Approve';
        ctrApproveConditionTrue.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionTrue.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        ctrApproveConditionTrue.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionTrue;

        CTRCommitteeApproval__c ctrApproveConditionTrue2 = new CTRCommitteeApproval__c();
        ctrApproveConditionTrue2.Name = 'TestConditionTrue Approve2';
        ctrApproveConditionTrue2.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionTrue2.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        ctrApproveConditionTrue2.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionTrue2;

        CTRCommitteeApproval__c ctrApproveConditionFalse = new CTRCommitteeApproval__c();
        ctrApproveConditionFalse.Name = 'TestConditionFalse Approve';
        ctrApproveConditionFalse.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionFalse.CTRRequestFormItem__c = reqItemConditionFalse.Id;
        ctrApproveConditionFalse.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionFalse;

        CTRCommitteeApproval__c ctrApprove = [SELECT Id FROM CTRCommitteeApproval__c WHERE Name ='TestConditionTrue Approve2'];
        String message = 'Message Test ReplyFA';
        String actionButton = 'ReplyFA';
        Test.startTest();
        CommitteeTakeActionApprove.submitReplyTo(ctrApproveConditionTrue2.Id, message, actionButton);
        Test.stopTest();
    }

    @isTest
    public static void checkPermissionBeforeShowModalTest() {
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

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name = 'Test Header';
        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerExtend' limit 1];
        CTRRequestFormItem__c reqItemConditionTrue = new CTRRequestFormItem__c();
        reqItemConditionTrue.Name = 'TestConditionTrue Item';
        reqItemConditionTrue.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionTrue.RecordTypeId = rt.Id;
        reqItemConditionTrue.EmailTo__c = 'testemailto@test.com';
        reqItemConditionTrue.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionTrue.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionTrue;

        CTRRequestFormItem__c reqItemConditionFalse = new CTRRequestFormItem__c();
        reqItemConditionFalse.Name = 'TestConditionFalse Item';
        reqItemConditionFalse.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionFalse.RecordTypeId = rt.Id;
        reqItemConditionFalse.EmailTo__c = 'testemailto@test.com';
        reqItemConditionFalse.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionFalse.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionFalse;

        CTRCommitteeApproval__c ctrApproveConditionTrue = new CTRCommitteeApproval__c();
        ctrApproveConditionTrue.Name = 'TestConditionTrue Approve';
        ctrApproveConditionTrue.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionTrue.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        ctrApproveConditionTrue.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionTrue;

        CTRCommitteeApproval__c ctrApproveConditionTrue2 = new CTRCommitteeApproval__c();
        ctrApproveConditionTrue2.Name = 'TestConditionTrue Approve2';
        ctrApproveConditionTrue2.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionTrue2.CTRRequestFormItem__c = reqItemConditionTrue.Id;
        ctrApproveConditionTrue2.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionTrue2;

        CTRCommitteeApproval__c ctrApproveConditionFalse = new CTRCommitteeApproval__c();
        ctrApproveConditionFalse.Name = 'TestConditionFalse Approve';
        ctrApproveConditionFalse.ApprovalResult__c = 'Submit to Committee';
        ctrApproveConditionFalse.CTRRequestFormItem__c = reqItemConditionFalse.Id;
        ctrApproveConditionFalse.ApproverName__c = testUser1.Id;
        insert ctrApproveConditionFalse;
        
        
        Test.startTest();
        // CTRRequestFormItem__c reqItemConditionTrue = [SELECT Id, EmailTo__c, EmailCC__c FROM CTRRequestFormItem__c WHERE Name = 'TestConditionTrue Item'];
        CommitteeTakeActionApprove.checkPermissionBeforeShowModal(reqItemConditionTrue.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetRecordType(){

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

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name = 'Test Header';
        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerExtend' limit 1];
        CTRRequestFormItem__c reqItemConditionTrue = new CTRRequestFormItem__c();
        reqItemConditionTrue.Name = 'TestConditionTrue Item';
        reqItemConditionTrue.CTRRequestFormHeader__c = reqHeader.Id;
        reqItemConditionTrue.RecordTypeId = rt.Id;
        reqItemConditionTrue.EmailTo__c = 'testemailto@test.com';
        reqItemConditionTrue.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionTrue.CommitteeOwner__c = testUser1.Id;
        insert reqItemConditionTrue;


        Test.startTest();
        String result = CommitteeTakeActionApprove.getRecordType(reqItemConditionTrue.Id);
        System.assertNotEquals(null, result);

        Test.stopTest();
    }
}