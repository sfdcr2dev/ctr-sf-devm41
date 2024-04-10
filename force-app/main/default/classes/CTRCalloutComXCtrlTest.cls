@isTest
public class CTRCalloutComXCtrlTest {
    private class MyMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            res.setBody('{"Success": true}');
            return res;
        }
    }

    private class MyMock2 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            res.setBody('{"Error": true}');
            return res;
        }
    }

    private class MyMock3 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(400);
            res.setBody('{"Error": true}');
            return res;
        }
    }

    @isTest
    static void testCallSoapApiUpdate() {
        Test.startTest();
        
        String sapCode = 'testSapCode';
        String ctrCode = 'testCtrCode';
        String name = 'testName';
        String type = 'testType';
        String extId = 'testExtId';

        CTRCalloutComXCtrl.callSoapApiUpdate(sapCode, ctrCode, name, type, extId);
        // System.assert(exception == null, 'Expected no exception');
        
        Test.stopTest();
    }

    @isTest
    static void testCallSoapApiUpdateTestMockCallout() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMock());
        String sapCode = 'testSapCode';
        String ctrCode = 'testCtrCode';
        String name = 'testName';
        String type = 'testType';
        String extId = 'testExtId';

        CTRCalloutComXCtrl.callSoapApiUpdate(sapCode, ctrCode, name, type, extId);
        // System.assert(exception == null, 'Expected no exception');
        
        Test.stopTest();
    }

    @isTest
    static void testCallSoapApiUpdateTestMockCallout2() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMock2());
        String sapCode = 'testSapCode';
        String ctrCode = 'testCtrCode';
        String name = 'testName';
        String type = 'testType';
        String extId = 'testExtId';

        CTRCalloutComXCtrl.callSoapApiUpdate(sapCode, ctrCode, name, type, extId);
        // System.assert(exception == null, 'Expected no exception');
        
        Test.stopTest();
    }

    @isTest
    static void testCallSoapApiUpdateTestMockCallout3() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMock3());
        String sapCode = 'testSapCode';
        String ctrCode = 'testCtrCode';
        String name = 'testName';
        String type = 'testType';
        String extId = 'testExtId';

        CTRCalloutComXCtrl.callSoapApiUpdate(sapCode, ctrCode, name, type, extId);
        // System.assert(exception == null, 'Expected no exception');
        
        Test.stopTest();
    }

    @isTest
    static void testPickOutData() {
        Account testAccount = new Account(
            Name = 'Test Account',
            CustomerNameLocal1__c = 'Customer Name Local 1',
            CustomerNameLocal2__c = 'Customer Name Local 2',
            AccountNumber__c = '1234567890'
        );
        insert testAccount;

        RecordType reqItemRTCus = [SELECT Id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial'];

        CTRRequestFormItem__c testRequestItem = new CTRRequestFormItem__c(
            Name = 'Test Request Item',
            SAPStatus__c = 'Send Sales/Purchasing View To SAP',
            RecordTypeId = reqItemRTCus.Id,
            Customer__c = testAccount.Id,
            Approval_TRCRSubmitDate__c = Date.today(),
            Approval_TraderSubmitDate__c = Date.today() 
        );
        insert testRequestItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemOldMap = new Map<Id, CTRRequestFormItem__c>();
        mRequestItemOldMap.put(testRequestItem.Id, testRequestItem);

        testRequestItem.SAPStatus__c = 'SAP Confirmed Sales/Purchasing View';
        update testRequestItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemNewMap = new Map<Id, CTRRequestFormItem__c>();
        mRequestItemNewMap.put(testRequestItem.Id, testRequestItem);

        Test.startTest();
        CTRCalloutComXCtrl.pickOutData(mRequestItemOldMap, mRequestItemNewMap);
        Test.stopTest();

    }

    @isTest
    static void testPickOutData2() {
        Account testAccount = new Account(
            Name = 'Test Account',
            CustomerNameLocal1__c = 'Customer Name Local 1',
            CustomerNameLocal2__c = 'Customer Name Local 2',
            AccountNumber__c = '1234567890'
        );
        insert testAccount;

        RecordType reqItemRTSup = [SELECT Id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'SupplierInitial'];

        CTRRequestFormItem__c testRequestItem = new CTRRequestFormItem__c(
            Name = 'Test Request Item',
            SAPStatus__c = 'Send Sales/Purchasing View To SAP',
            RecordTypeId = reqItemRTSup.Id,
            Customer__c = testAccount.Id,
            Approval_TRCRSubmitDate__c = Date.today(),
            Approval_TraderSubmitDate__c = Date.today() 
        );
        insert testRequestItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemOldMap = new Map<Id, CTRRequestFormItem__c>();
        mRequestItemOldMap.put(testRequestItem.Id, testRequestItem);

        testRequestItem.SAPStatus__c = 'SAP Confirmed Sales/Purchasing View';
        update testRequestItem;

        Map<Id, CTRRequestFormItem__c> mRequestItemNewMap = new Map<Id, CTRRequestFormItem__c>();
        mRequestItemNewMap.put(testRequestItem.Id, testRequestItem);

        Test.startTest();
        CTRCalloutComXCtrl.pickOutData(mRequestItemOldMap, mRequestItemNewMap);
        Test.stopTest();
    }

    @isTest
    static void testCallRestApiCreate() {
        Test.setMock(HttpCalloutMock.class, new MyMock());
        Test.startTest();
        CTRCalloutComXCtrl.callRestApiCreate('Type', 'WrapperListRequest', 'ExtId');
        Test.stopTest();
    }

    @isTest
    static void testCallRestApiCreate2() {
        Test.setMock(HttpCalloutMock.class, new MyMock2());
        Test.startTest();
        CTRCalloutComXCtrl.callRestApiCreate('Type', 'WrapperListRequest', 'ExtId');
        Test.stopTest();
    }

    @isTest
    static void testCallRestApiCreate3() {
        Test.setMock(HttpCalloutMock.class, new MyMock3());
        Test.startTest();
        CTRCalloutComXCtrl.callRestApiCreate('Type', 'WrapperListRequest', 'ExtId');
        Test.stopTest();
    }

    @isTest
    static void testCallRestApiCreate4() {
        Test.startTest();
        CTRCalloutComXCtrl.callRestApiCreate('Type', 'WrapperListRequest', 'ExtId');
        Test.stopTest();
    }

    /*
    @isTest
    static void testOrganizeData() {
        Account testAccount = new Account(
            Name = 'Test Account',
            CustomerNameLocal1__c = 'Customer Name Local 1',
            CustomerNameLocal2__c = 'Customer Name Local 2',
            AccountNumber__c = '1234567890'
        );
        insert testAccount;

        RecordType reqItemRTCus = [SELECT Id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial'];

        CTRRequestFormItem__c testRequestItem = new CTRRequestFormItem__c(
            Name = 'Test Request Item',
            SAPStatus__c = 'Send Sales/Purchasing View To SAP',
            RecordTypeId = reqItemRTCus.Id,
            Customer__c = testAccount.Id,
            Approval_TRCRSubmitDate__c = Date.today(),
            Approval_TraderSubmitDate__c = Date.today()
        );
        insert testRequestItem;

        Test.startTest();
        Map<Id, CTRRequestFormItem__c> testData = new Map<Id, CTRRequestFormItem__c>();
        testData.put(reqItemRTCus.Id,testRequestItem);
        CTRCalloutComXCtrl.organizeData(testData);
        Test.stopTest();
    }
    
    @isTest
    static void testOrganizeData2() {
        Account testAccount = new Account(
            Name = 'Test Account',
            CustomerNameLocal1__c = 'Customer Name Local 1',
            CustomerNameLocal2__c = 'Customer Name Local 2',
            AccountNumber__c = '1234567890'
        );
        insert testAccount;

        RecordType reqItemRTCus = [SELECT Id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'SupplierInitial'];

        CTRRequestFormItem__c testRequestItem = new CTRRequestFormItem__c(
            Name = 'Test Request Item',
            SAPStatus__c = 'Send Sales/Purchasing View To SAP',
            RecordTypeId = reqItemRTCus.Id,
            Customer__c = testAccount.Id,
            Approval_TRCRSubmitDate__c = Date.today(),
            Approval_TraderSubmitDate__c = Date.today()
        );
        insert testRequestItem;
        
        Test.startTest();
        Map<Id, CTRRequestFormItem__c> testData = new Map<Id, CTRRequestFormItem__c>();
        testData.put(reqItemRTCus.Id,testRequestItem);
        CTRCalloutComXCtrl.organizeData(testData);
        Test.stopTest();
    }
    */
    @isTest
    static void testOrganizeData() {
        Account testAccount = new Account(
            Name = 'Test Account',
            CustomerNameLocal1__c = 'Customer Name Local 1',
            CustomerNameLocal2__c = 'Customer Name Local 2',
            AccountNumber__c = '1234567890'
        );
        insert testAccount;

        RecordType reqItemRTCus = [SELECT Id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerInitial'];

        CTRRequestFormItem__c testRequestItem = new CTRRequestFormItem__c(
            Name = 'Test Request Item',
            SAPStatus__c = 'Send Sales/Purchasing View To SAP',
            RecordTypeId = reqItemRTCus.Id,
            Customer__c = testAccount.Id,
            Approval_TRCRSubmitDate__c = Date.today(),
            Approval_TraderSubmitDate__c = Date.today()
        );
        insert testRequestItem;

        Test.startTest();
        CTRCalloutComXCtrl.organizeData(testRequestItem.Id);
        Test.stopTest();
    }

    @isTest
    static void testOrganizeData2() {
        Account testAccount = new Account(
            Name = 'Test Account',
            CustomerNameLocal1__c = 'Customer Name Local 1',
            CustomerNameLocal2__c = 'Customer Name Local 2',
            AccountNumber__c = '1234567890'
        );
        insert testAccount;

        RecordType reqItemRTCus = [SELECT Id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'SupplierInitial'];

        CTRRequestFormItem__c testRequestItem = new CTRRequestFormItem__c(
            Name = 'Test Request Item',
            SAPStatus__c = 'Send Sales/Purchasing View To SAP',
            RecordTypeId = reqItemRTCus.Id,
            Customer__c = testAccount.Id,
            Approval_TRCRSubmitDate__c = Date.today(),
            Approval_TraderSubmitDate__c = Date.today()
        );
        insert testRequestItem;
        
        Test.startTest();
        CTRCalloutComXCtrl.organizeData(String.valueOf(testRequestItem.Id));
        Test.stopTest();
    }


    // @isTest
    // static void testCustomerWrapperInitialization() {
    //     // Arrange
    //     CTRCalloutComXCtrl.CustomerWrapper customerWrapper = new CTRCalloutComXCtrl.CustomerWrapper();

    //     // Act - No action required for initialization

    //     // Assert
    //     System.assertNotEquals(null, customerWrapper, 'CustomerWrapper should not be null');
    //     System.assertNotEquals(null, customerWrapper.Cust, 'Cust should not be null');
    //     System.assertNotEquals(null, customerWrapper.CustDetail, 'CustDetail should not be null');
    // }

    // @isTest
    // static void testVendorWrapperInitialization() {
    //     // Arrange
    //     CTRCalloutComXCtrl.VendorWrapper vendorWrapper = new CTRCalloutComXCtrl.VendorWrapper();

    //     // Act - No action required for initialization

    //     // Assert
    //     System.assertNotEquals(null, vendorWrapper, 'VendorWrapper should not be null');
    //     System.assertNotEquals(null, vendorWrapper.vendor, 'vendor should not be null');
    //     System.assertNotEquals(null, vendorWrapper.vendorData, 'vendorData should not be null');
    // }

    @isTest
    static void testCustomerWrapperWithData() {
        // Arrange
        CTRCalloutComXCtrl.CustomerWrapper customerWrapper = new CTRCalloutComXCtrl.CustomerWrapper();
        customerWrapper.Cust = new CTRCalloutComXCtrl.Cust();
        customerWrapper.CustDetail = new CTRCalloutComXCtrl.CustDetail();

        // Act - No action required

        // Assert
        System.assertEquals(null, customerWrapper.Cust.MCT_CUST_NUM, 'MCT_CUST_NUM should be null initially');
        System.assertEquals(null, customerWrapper.Cust.MCT_STATUS, 'MCT_STATUS should be null initially');
        System.assertEquals(null, customerWrapper.Cust.MCT_CREATE_TYPE, 'MCT_CREATE_TYPE should be null initially');
        System.assertEquals(null, customerWrapper.Cust.MCT_CREATED_DATE, 'MCT_CREATED_DATE should be null initially');
        System.assertEquals(null, customerWrapper.Cust.MCT_UPDATED_DATE, 'MCT_UPDATED_DATE should be null initially');
        System.assertEquals(null, customerWrapper.Cust.MCT_UPDATED_BY, 'MCT_UPDATED_BY should be null initially');
        System.assertEquals(null, customerWrapper.Cust.MCT_CREATED_BY, 'MCT_CREATED_BY should be null initially');

        System.assertEquals(null, customerWrapper.CustDetail.MCD_FK_CUS, 'MCD_FK_CUS should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_FK_COMPANY, 'MCD_FK_COMPANY should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_NATION, 'MCD_NATION should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_NAME_1, 'MCD_NAME_1 should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_NAME_2, 'MCD_NAME_2 should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_CITY, 'MCD_CITY should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_DISTRICT, 'MCD_DISTRICT should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_CITY_POS_CODE, 'MCD_CITY_POS_CODE should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_STREET, 'MCD_STREET should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_HOUSE_NUM, 'MCD_HOUSE_NUM should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_COUNT_KEY1, 'MCD_COUNT_KEY1 should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_PHONE_NO_DIALLING, 'MCD_PHONE_NO_DIALLING should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_TAX_NUMBER_1, 'MCD_TAX_NUMBER_1 should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_NAME_PER_CREAT, 'MCD_NAME_PER_CREAT should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_KTOKD, 'MCD_KTOKD should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_STATUS, 'MCD_STATUS should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_CREATED_DATE, 'MCD_CREATED_DATE should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_CREATED_BY, 'MCD_CREATED_BY should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_UPDATED_BY, 'MCD_UPDATED_BY should be null initially');
        System.assertEquals(null, customerWrapper.CustDetail.MCD_UPDATED_DATE, 'MCD_UPDATED_DATE should be null initially');
    }

    @isTest
    static void testVendorWrapperWithData() {
        // Arrange
        CTRCalloutComXCtrl.VendorWrapper vendorWrapper = new CTRCalloutComXCtrl.VendorWrapper();
        vendorWrapper.vendor = new CTRCalloutComXCtrl.Vendor();
        vendorWrapper.vendorData = new CTRCalloutComXCtrl.VendorData();

        // Act - No action required

        // Assert
        System.assertEquals(null, vendorWrapper.vendor.vnD_ACC_NUM_VENDOR, 'vnD_ACC_NUM_VENDOR should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_NAME1, 'vnD_NAME1 should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_NAME2, 'vnD_NAME2 should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_CITY, 'vnD_CITY should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_DISTRICT, 'vnD_DISTRICT should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_POSTAL_CODE, 'vnD_POSTAL_CODE should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_HOUSE_NUM_STREET, 'vnD_HOUSE_NUM_STREET should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_STATUS, 'vnD_STATUS should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_CREATED_DATE, 'vnD_CREATED_DATE should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_CREATED_BY, 'vnD_CREATED_BY should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_UPDATED_DATE, 'vnD_UPDATED_DATE should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_UPDATED_BY, 'vnD_UPDATED_BY should be null initially');
        System.assertEquals(null, vendorWrapper.vendor.vnD_CREATE_TYPE, 'vnD_CREATE_TYPE should be null initially');
        
        System.assertEquals(null, vendorWrapper.vendorData.mvD_FK_COMPANY, 'mvD_FK_COMPANY should be null initially');
        System.assertEquals(null, vendorWrapper.vendorData.mvD_FK_VENDOR, 'mvD_FK_VENDOR should be null initially');
        System.assertEquals(null, vendorWrapper.vendorData.mvD_STATUS, 'mvD_STATUS should be null initially');
        System.assertEquals(null, vendorWrapper.vendorData.mvD_CREATED_DATE, 'mvD_CREATED_DATE should be null initially');
        System.assertEquals(null, vendorWrapper.vendorData.mvD_CREATED_BY, 'mvD_CREATED_BY should be null initially');
        System.assertEquals(null, vendorWrapper.vendorData.mvD_UPDATED_BY, 'mvD_UPDATED_BY should be null initially');
        System.assertEquals(null, vendorWrapper.vendorData.mvD_UPDATED_DATE, 'mvD_UPDATED_DATE should be null initially');
    }

    @isTest
    static void testOrganizeData3() {
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
                LastName = 'Test',
                Email = 'test@thaioilgroup.com',
                Username = 'test@thaioilgroup.com.icr',
                CompanyName = 'TOP',
                Alias = 'test',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
                );
            insert(testUser);

        Account testAccount = new Account(
            Name = 'Test Account',
            CustomerNameLocal1__c = 'Customer Name Local 1',
            CustomerNameLocal2__c = 'Customer Name Local 2',
            AccountNumber__c = '1234567890'
        );
        insert testAccount;

        List<Master_Map__c> Master = new List<Master_Map__c>();
        Master_Map__c m = new Master_Map__c(Code__c='TH', Type__c='Country');
        Master.add(m);
        insert Master;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            InterestedProductCustomer__c = 'Petroleum Products;Lube Base Products;LABIX Products',
            InterestedProductSupplier__c = 'LABIX Products',
            Name = 'TEST',
            CompanyNameLocal__c = 'testCompanyNameTH__c',
            CompanyNameENF__c = 'testCompanyNameENF__c',
            Country__c = Master[0].Id,
            DistrictLocalText__c = 'BangSue',
            PostalCodeLocalText__c = '10100',
            StreetLocal__c = 'taopoon road',
            HousenoLocal__c = '67/43',
            Phone__c = '0978657877',
            TaxCode1__c = '1111111111111',
            AccountGroup__c = 'TOPG'

        );
        insert reqHeader;

        RecordType reqItemRTCus = [SELECT Id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'SupplierInitial'];

        CTRRequestFormItem__c testRequestItem = new CTRRequestFormItem__c(
            Name = 'Test Request Item',
            SAPStatus__c = 'Send Sales/Purchasing View To SAP',
            RecordTypeId = reqItemRTCus.Id,
            Customer__c = testAccount.Id,
            Approval_TRCRSubmitDate__c = Date.today(),
            Approval_TraderSubmitDate__c = Date.today(),
            ApproveDueDiligenceBy__c = testUser.Id,
            SalesOrganization__c = '1100',
            CTRRequestFormHeader__c = reqHeader.Id
        );
        insert testRequestItem;
        
        Test.startTest();
        CTRCalloutComXCtrl.organizeData(String.valueOf(testRequestItem.Id));
        Test.stopTest();
    }

}