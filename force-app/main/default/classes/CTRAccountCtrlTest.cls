@isTest
public without sharing class CTRAccountCtrlTest {
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success"}');
            return res;
        }
    }

    @TestSetup
    static void setup()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        //RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'Initial'];
        Id initialAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Initial').getRecordTypeId();
        Account testAccount1 = new Account(
            Name = 'Test Duplicate 2', 
            TaxCode1__c = '0123456789000',
            SupplierNumber__c = '1234',
            RecordTypeId = initialAccountRecordTypeId,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            AccountNumber__c = '1234',
            Email__c = 'abc@abc.com'
        );
        insert testAccount1;

        Profile profileTOP = [SELECT Id FROM Profile WHERE Name = 'TOP'];

        User userTOP = new User(
            ProfileId = profileTOP.Id,
            Username = 'testusertop@example.com',
            Email = 'testusertop@example.com',
            Alias = 'topuser',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestUser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert userTOP;
        
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB'
        );
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            Status__c= 'New',
            Customer__c = testAccount1.Id,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            CTRRequestFormHeader__c = reqHeader.Id
        );
        insert reqItem;
    }

    @isTest
    static void testCheckDuplicateAccount_Initial1() {
        User userTOP = [SELECT Id, ProfileId FROM User WHERE Email = 'testusertop@example.com'];

        System.runAs(userTOP) {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            
            test.startTest();
            List<CTRShippingCountry__c> shpctList = new List<CTRShippingCountry__c>();
            CTRShippingCountry__c obj1 = new CTRShippingCountry__c(ShippingCountry__c = 'TH - Thailand');
            shpctList.add(obj1);

            List<CTRShareholder__c> shrhdList = new List<CTRShareholder__c>();
            CTRShareholder__c obj3 = new CTRShareholder__c(Name = 'Test');
            shrhdList.add(obj3);
            
            Id initialAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Initial').getRecordTypeId();
            Id TOPLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TOP').getRecordTypeId();
            //RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'Initial'];
            
            Account testAccount1 = new Account(
                Name = 'Test Duplicate 1',
                TaxCode1__c = '02342303899',
                SupplierNumber__c = '',
                RecordTypeId = initialAccountRecordTypeId,
                InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
                AccountNumber__c = '',
                Email__c = 'abc@abc.com'
            );

            Account testAccount2 = new Account(
                Name = 'Test Duplicate 2', 
                TaxCode1__c = '0123456789000',
                SupplierNumber__c = '',
                RecordTypeId = initialAccountRecordTypeId,
                InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
                AccountNumber__c = '',
                Email__c = 'abc@abc.com'
            );

            //Account mAccount = CTRLeadConvert.convertedAccount(testAccount1.Id)[0];
            //Account mAccount2 = CTRLeadConvert.convertedAccount(testAccount2.Id)[0];
            CTRAccountCtrl.checkDuplicateAccount(testAccount1, shpctList, shrhdList, null);
            CTRAccountCtrl.checkDuplicateAccount(testAccount2, shpctList, shrhdList, null);
            test.stopTest();

        }
    }

    @isTest
    static void testCheckDuplicateAccount_InitialNoDup() {
        User userTOP = [SELECT Id, ProfileId FROM User WHERE Email = 'testusertop@example.com'];

        System.runAs(userTOP) {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

            test.startTest();
            List<CTRShippingCountry__c> shpctList = new List<CTRShippingCountry__c>();
            CTRShippingCountry__c obj1 = new CTRShippingCountry__c(ShippingCountry__c = 'TH - Thailand');
            shpctList.add(obj1);

            List<CTRShareholder__c> shrhdList = new List<CTRShareholder__c>();
            CTRShareholder__c obj3 = new CTRShareholder__c(Name = 'Test');
            shrhdList.add(obj3);
            
            Id initialAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Initial').getRecordTypeId();
            Id TOPLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TOP').getRecordTypeId();
            //RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'Initial'];
            
            Account testAccount1 = new Account(
                Name = 'Test Duplicate 1',
                TaxCode1__c = '1232303832',
                SupplierNumber__c = '',
                RecordTypeId = initialAccountRecordTypeId,
                InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
                AccountNumber__c = '',
                Email__c = 'abc@abc.com'
            );
            insert testAccount1;
            Account testAccount2 = new Account(
                Name = 'Test Duplicate 2', 
                TaxCode1__c = '4213456789012',
                SupplierNumber__c = '',
                RecordTypeId = initialAccountRecordTypeId,
                InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
                AccountNumber__c = '',
                Email__c = 'abc@abc.com'
            );
            insert testAccount2;
            Account mAccount = CTRLeadConvert.convertedAccount(testAccount1.Id)[0];
            Account mAccount2 = CTRLeadConvert.convertedAccount(testAccount2.Id)[0];
            CTRAccountCtrl.checkDuplicateAccount(mAccount, shpctList, shrhdList, null);
            CTRAccountCtrl.checkDuplicateAccount(mAccount2, shpctList, shrhdList, null);
            test.stopTest();

        }
    }

    @isTest
    static void testCheckDuplicateAccount_ConvertedLeadTOP() {
        User userTOP = [SELECT Id, ProfileId FROM User WHERE Email = 'testusertop@example.com'];

        System.runAs(userTOP) {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

            test.startTest();
            List<CTRShippingCountry__c> shpctList = new List<CTRShippingCountry__c>();
            CTRShippingCountry__c obj1 = new CTRShippingCountry__c(ShippingCountry__c = 'TH - Thailand');
            shpctList.add(obj1);

            List<CTRShareholder__c> shrhdList = new List<CTRShareholder__c>();
            CTRShareholder__c obj3 = new CTRShareholder__c(Name = 'Test');
            shrhdList.add(obj3);
            
            Id initialAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Initial').getRecordTypeId();
            Id TOPLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TOP').getRecordTypeId();
            //RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'Initial'];
            Lead testLead1 = new Lead(
            Company = 'Test Company',
            TaxNumber__c = '01234567890220',
            FormerNameofCompany__c = 'Former Name',
            Email = 'test@example.com',
            RegisteredasCustomer__c  = true,
            RegisteredasSupplier__c  = true,
            RecordTypeId = TOPLeadRecordTypeId,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
            FirstName = 'Test',
            LastName = 'Test'
            );
            insert testLead1;
            Account testAccount1 = new Account(
                Name = 'Test Duplicate 1',
                TaxCode1__c = '02342303834',
                SupplierNumber__c = '',
                RecordTypeId = initialAccountRecordTypeId,
                InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
                AccountNumber__c = '',
                Email__c = 'abc@abc.com',
                LeadName__c =testLead1.Id
            );
            insert testAccount1;
            Account testAccount2 = new Account(
                Name = 'Test Duplicate 2', 
                TaxCode1__c = '0123456789012',
                SupplierNumber__c = '',
                RecordTypeId = initialAccountRecordTypeId,
                InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
                AccountNumber__c = '',
                Email__c = 'abc@abc.com',
                LeadName__c =testLead1.Id
            );
            insert testAccount2;
            
            Account mAccount = CTRLeadConvert.convertedAccount(testAccount1.Id)[0];
            Account mAccount2 = CTRLeadConvert.convertedAccount(testAccount2.Id)[0];
            CTRAccountCtrl.checkDuplicateAccount(mAccount, shpctList, shrhdList, testLead1.Id);
            CTRAccountCtrl.checkDuplicateAccount(mAccount2, shpctList, shrhdList, testLead1.Id);
            test.stopTest();

        }
    }

    @isTest
    static void testCheckDuplicateAccount_ConvertedLeadTXCust() {
        User userTOP = [SELECT Id, ProfileId FROM User WHERE Email = 'testusertop@example.com'];

        System.runAs(userTOP) {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

            test.startTest();
            List<CTRShippingCountry__c> shpctList = new List<CTRShippingCountry__c>();
            CTRShippingCountry__c obj1 = new CTRShippingCountry__c(ShippingCountry__c = 'TH - Thailand');
            shpctList.add(obj1);

            List<CTRShareholder__c> shrhdList = new List<CTRShareholder__c>();
            CTRShareholder__c obj3 = new CTRShareholder__c(Name = 'Test');
            shrhdList.add(obj3);
           

            Id initialAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Initial').getRecordTypeId();
            Id TxLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TX Customer').getRecordTypeId();
            //RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'Initial'];
            Lead testLead1 = new Lead(
            Company = 'Test Company',
            TaxNumber__c = '01234567890220',
            FormerNameofCompany__c = 'Former Name',
            Email = 'test@example.com',
            RegisteredasCustomer__c  = true,
            RegisteredasSupplier__c  = true,
            RecordTypeId = TxLeadRecordTypeId,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
            FirstName = 'Test',
            LastName = 'Test'
            );
            insert testLead1;
            Account testAccount1 = new Account(
                Name = 'Test Duplicate 1',
                TaxCode1__c = '02342303834',
                SupplierNumber__c = '',
                RecordTypeId = initialAccountRecordTypeId,
                InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
                AccountNumber__c = '',
                Email__c = 'abc@abc.com',
                LeadName__c =testLead1.Id
            );
            insert testAccount1;
            Account testAccount2 = new Account(
                Name = 'Test Duplicate 2', 
                TaxCode1__c = '0123456789012',
                SupplierNumber__c = '',
                RecordTypeId = initialAccountRecordTypeId,
                InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
                AccountNumber__c = '',
                Email__c = 'abc@abc.com',
                LeadName__c =testLead1.Id
            );
            insert testAccount2;
            
            Account mAccount = CTRLeadConvert.convertedAccount(testAccount1.Id)[0];
            Account mAccount2 = CTRLeadConvert.convertedAccount(testAccount2.Id)[0];
            CTRAccountCtrl.checkDuplicateAccount(mAccount, shpctList, shrhdList, testLead1.Id);
            CTRAccountCtrl.checkDuplicateAccount(mAccount2, shpctList, shrhdList, testLead1.Id);
            test.stopTest();

        }
    }

    @isTest
    static void testCheckDuplicateAccount_ConvertedLeadTXSup() {
        User userTOP = [SELECT Id, ProfileId FROM User WHERE Email = 'testusertop@example.com'];

        System.runAs(userTOP) {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

            test.startTest();
            List<CTRShippingCountry__c> shpctList = new List<CTRShippingCountry__c>();
            CTRShippingCountry__c obj1 = new CTRShippingCountry__c(ShippingCountry__c = 'TH - Thailand');
            shpctList.add(obj1);

            List<CTRShareholder__c> shrhdList = new List<CTRShareholder__c>();
            CTRShareholder__c obj3 = new CTRShareholder__c(Name = 'Test');
            shrhdList.add(obj3);
            
            Id initialAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Initial').getRecordTypeId();
            Id TxLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TX Supplier').getRecordTypeId();
            //RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'Initial'];
            Lead testLead1 = new Lead(
            Company = 'Test Company',
            TaxNumber__c = '01234567890220',
            FormerNameofCompany__c = 'Former Name',
            Email = 'test@example.com',
            RegisteredasCustomer__c  = true,
            RegisteredasSupplier__c  = true,
            RecordTypeId = TxLeadRecordTypeId,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
            FirstName = 'Test',
            LastName = 'Test'
            );
            insert testLead1;
            Account testAccount1 = new Account(
                Name = 'Test Duplicate 1',
                TaxCode1__c = '02342303834',
                SupplierNumber__c = '',
                RecordTypeId = initialAccountRecordTypeId,
                InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
                AccountNumber__c = '',
                Email__c = 'abc@abc.com',
                LeadName__c =testLead1.Id
            );
            insert testAccount1;
            Account testAccount2 = new Account(
                Name = 'Test Duplicate 2', 
                TaxCode1__c = '0123456789012',
                SupplierNumber__c = '',
                RecordTypeId = initialAccountRecordTypeId,
                InterestedProductTypeAsCustomerTOP__c = 'Crude', 
                InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
                InterestedProductTypeAsCustomerTX__c = 'Lube', 
                InterestedProductTypeAsSupplierTX__c = 'LAB',
                AccountNumber__c = '',
                Email__c = 'abc@abc.com',
                LeadName__c =testLead1.Id
            );
            insert testAccount2;
            
            Account mAccount = CTRLeadConvert.convertedAccount(testAccount1.Id)[0];
            Account mAccount2 = CTRLeadConvert.convertedAccount(testAccount2.Id)[0];
            CTRAccountCtrl.checkDuplicateAccount(mAccount, shpctList, shrhdList, testLead1.Id);
            CTRAccountCtrl.checkDuplicateAccount(mAccount2, shpctList, shrhdList, testLead1.Id);
            test.stopTest();

        }
    }
}