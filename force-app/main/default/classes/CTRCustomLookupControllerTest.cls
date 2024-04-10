@isTest
public without sharing class CTRCustomLookupControllerTest {
    @TestSetup
    static void setup(){
        Account testAccount = new Account (
            Name = 'Test Account'
        );
        insert testAccount;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c (
            Status__c = 'New',
            Customer__c = testAccount.Id
        );
        insert reqHeader;

        PISUsers__c pisUsers = new PISUsers__c (
            Name = 'Test',
            EMAIL__c  = 'test@test.com',
            Active__c  = true
        );
        insert pisUsers;
    }

    @isTest
    static void testSearchRecords() {
        Test.startTest();
        Account account = [SELECT Id FROM Account LIMIT 1];
        CTRCustomLookupController.searchRecords('Account', 'Name', '');
        CTRCustomLookupController.searchRecords('Account', 'Name', 'Id = \'' + account.Id + '\'');
        Test.stopTest();
    }

    @isTest
    static void testGetLookupValue() {
        Test.startTest();
        Account account = [SELECT Id FROM Account LIMIT 1];
        CTRCustomLookupController.getLookupValue('Account', account.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetEmailUsers() {
        Test.startTest();
        List<Map<String, String>> userList = CTRCustomLookupController.getEmailUsers();
        Test.stopTest();
    }

    @isTest
    static void testFetchLookUpValues() {
        Test.startTest();
        List<Object> results = CTRCustomLookupController.fetchLookUpValues('Test', 'Account', 'AND Name <> null');


        try {
            results = CTRCustomLookupController.fetchLookUpValues('Test', 'Account', 'Invalid condition');
        } catch (Exception ex) {
            System.assertNotEquals(null, ex.getMessage());
        }
        
        Test.stopTest();
    }

    

}