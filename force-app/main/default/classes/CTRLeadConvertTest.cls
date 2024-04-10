@isTest
public with sharing class CTRLeadConvertTest {
    @TestSetup
    static void setup(){
        Account testAccount1 = new Account(
            Name = 'Test Account', 
            InterestedProductTypeCustomer__c = 'Petroleum Products', 
            InterestedProductTypeSupplier__c = 'B100/Ethanal'
        );
        insert testAccount1;

        Account testAccount2 = new Account(
            Name = 'Test Company', 
            TaxCode1__c = '0123456789000',
            FormerNameofCompany__c = 'Former Name',
            InterestedProductTypeCustomer__c = 'Petroleum Products', 
            InterestedProductTypeSupplier__c = 'B100/Ethanal'
        );
        insert testAccount2;

        Lead testLead1 = new Lead(
            Company = 'Test Company',
            TaxNumber__c = '0123456789000',
            FormerNameofCompany__c = 'Former Name',
            Email = 'test@example.com',
            InterestedProductTypeasCustomer__c = 'Petroleum Products',
            InterestedProductTypeasSupplier__c = 'Crude',
            FirstName = 'Test',
            LastName = 'Test',
            RegisteredasCustomer__c = true,
            RegisteredasSupplier__c = true
        );
        insert testLead1;

        OrgWideEmailAddress orgWide = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName = 'Commercial Team' LIMIT 1];

        CTRConfig__c setting = new CTRConfig__c();
        setting.Name = 'Test Setting';
        setting.EmailService__c = 'test@test.com';
        setting.OrgWideEmailAddress__c = orgWide.Address;
        insert setting;
    }

    @isTest
    static void testAssignLeads() {

        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'TX' LIMIT 1];
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

        Test.startTest();
        Lead testLead1 = [SELECT Id FROM Lead LIMIT 1];

        List<CTRLeadConvert.ConvertResults> results = CTRLeadConvert.assignLeads(new List<Id>{testLead1.Id});
        System.runAs(testUser) {
        results = CTRLeadConvert.assignLeads(new List<Id>{testLead1.Id});
        }
        Test.stopTest();
    }
}