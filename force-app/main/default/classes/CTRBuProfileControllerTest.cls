@isTest
public class CTRBuProfileControllerTest {

    @isTest
    static void testCheckBusinessUnitFromProfileForBUNotFound() {
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.test',
            Username = 'testuser@example.test',
            ProfileId = testProfile.Id,
            Alias = 'tuser',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'Asia/Bangkok',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        RecordType recordType = [SELECT Id FROM RecordType WHERE Name = 'New Customer'];

        CTRRequestFormItem__c testRecord = new CTRRequestFormItem__c(
            SalesOrganization__c = '1100',
            RecordTypeId = recordType.Id
        );
        insert testRecord;

        Test.startTest();
        CTRBuProfile__mdt result1 = CTRBuProfileController.checkBusinessUnitFromProfile(testUser.Id, testRecord.Id);
        Test.stopTest();

        System.assertNotEquals(null, result1, 'Record Found');
    }

    @isTest
    static void testCheckBusinessUnitFromProfileForInitialCustomer() {
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.test',
            Username = 'testuser@example.test',
            ProfileId = testProfile.Id,
            Alias = 'tuser',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'Asia/Bangkok',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        RecordType recordType = [SELECT Id FROM RecordType WHERE Name = 'New Customer'];

        CTRRequestFormItem__c testRecord = new CTRRequestFormItem__c(
            SalesOrganization__c = '1100',
            RecordTypeId = recordType.Id
        );
        insert testRecord;

        Test.startTest();
        CTRBuProfile__mdt result1 = CTRBuProfileController.checkBusinessUnitFromProfile(testUser.Id, testRecord.Id);
        CTRBuProfile__mdt result2 = CTRBuProfileController.checkBusinessUnitFromProfile(testUser.Id, null);
        Test.stopTest();

        System.assertNotEquals(null, result1, 'Record Found');
    }

    @isTest
    static void testCheckBusinessUnitFromProfileForInitialSupplier() {
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.test',
            Username = 'testuser@example.test',
            ProfileId = testProfile.Id,
            Alias = 'tuser',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'Asia/Bangkok',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        RecordType recordType = [SELECT Id FROM RecordType WHERE Name = 'New Supplier'];

        CTRRequestFormItem__c testRecord = new CTRRequestFormItem__c(
            // SalesOrganization__c = '1100',
            PurchasingOrganization__c = '1100',
            RecordTypeId = recordType.Id
        );
        insert testRecord;

        Test.startTest();
        CTRBuProfile__mdt result1 = CTRBuProfileController.checkBusinessUnitFromProfile(testUser.Id, testRecord.Id);
        Test.stopTest();

        System.assertNotEquals(null, result1, 'Record Found');
    }

    @isTest
    static void testGetReportToPIS() {
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

        Test.startTest();
        PISUsers__c result = CTRBuProfileController.getReportToPIS(testUser1.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Record Found');
    }

    @isTest
    static void testGetMap(){

        Test.startTest();
        Map<String, String> result = CTRBuProfileController.mapPurchasingOrgWithCompanyCode();
        Map<String, String> result2 = CTRBuProfileController.mapSalesOrgWithBU();
        CTRBuProfile__mdt result3 = CTRBuProfileController.coverScenarioBuProfile();
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertNotEquals(null, result2);
        System.assertNotEquals(null, result3);
    }
}