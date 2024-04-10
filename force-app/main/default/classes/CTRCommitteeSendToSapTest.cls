@isTest
public class CTRCommitteeSendToSapTest 
{

    public class ResponseFailedMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'text/json');
            response.setBody('{"status": "error", "token": null}');
            response.setStatusCode(400);
            return response; 
        }
    }

    @testSetup static void setupData()
    {
        Account mAccount = new Account();
        mAccount.Name = 'Test Initial Account';
        mAccount.AccountNumber__c = '0001';
        mAccount.SupplierNumber__c = '1001';
        mAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Initial').getRecordTypeId();
        insert mAccount;

        CTRRequestFormHeader__c mRequestHeader = new CTRRequestFormHeader__c();
        mRequestHeader.Name = 'Initial Account Request Header';
        mRequestHeader.Status__c = 'New';
        mRequestHeader.Customer__c = mAccount.Id;
        insert mRequestHeader;

        CTRRequestFormItem__c mRequestItem = new CTRRequestFormItem__c();
        mRequestItem.Name = 'Initial Account Request Item - 1';
        mRequestItem.Status__c = 'New';
        mRequestItem.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItem.Customer__c = mAccount.Id;
        mRequestItem.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();
        insert mRequestItem;

        CTRRequestFormItem__c mRequestItemCustomerInitial = new CTRRequestFormItem__c();
        mRequestItemCustomerInitial.Name = 'Initial Account Request Item - 1';
        mRequestItemCustomerInitial.Status__c = 'New';
        mRequestItemCustomerInitial.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItemCustomerInitial.Customer__c = mAccount.Id;
        mRequestItemCustomerInitial.SAPStatus__c = 'SAP Confirmed Sales/Purchasing View';
        mRequestItemCustomerInitial.LatestIntegrationName__c = 'Initial Customer Additional Information';
        mRequestItemCustomerInitial.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();
        insert mRequestItemCustomerInitial;
        
        CTRRequestFormItem__c mRequestItemCustomerInitial2 = new CTRRequestFormItem__c();
        mRequestItemCustomerInitial2.Name = 'Initial Account Request Item - 1';
        mRequestItemCustomerInitial2.Status__c = 'New';
        mRequestItemCustomerInitial2.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItemCustomerInitial2.Customer__c = mAccount.Id;
        mRequestItemCustomerInitial2.SAPStatus__c = 'Send General View To SAP';
        mRequestItemCustomerInitial2.LatestIntegrationName__c = 'Initial Customer Additional Information';
        mRequestItemCustomerInitial2.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();
        insert mRequestItemCustomerInitial2;

        CTRRequestFormItem__c mRequestItemCustomerBlock = new CTRRequestFormItem__c();
        mRequestItemCustomerBlock.Name = 'Initial Account Request Item - Block';
        mRequestItemCustomerBlock.Status__c = 'New';
        mRequestItemCustomerBlock.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItemCustomerBlock.Customer__c = mAccount.Id;
        mRequestItemCustomerBlock.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerBlock').getRecordTypeId();
        insert mRequestItemCustomerBlock;

        CTRRequestFormItem__c mRequestItemSupplierBlock = new CTRRequestFormItem__c();
        mRequestItemSupplierBlock.Name = 'Initial Account Request Item - Block';
        mRequestItemSupplierBlock.Status__c = 'New';
        mRequestItemSupplierBlock.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItemSupplierBlock.Customer__c = mAccount.Id;
        mRequestItemSupplierBlock.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierBlock').getRecordTypeId();
        insert mRequestItemSupplierBlock;

        CTRRequestFormItem__c mRequestItemCustomerEditInfo = new CTRRequestFormItem__c();
        mRequestItemCustomerEditInfo.Name = 'Initial Account Request Item - Edit';
        mRequestItemCustomerEditInfo.Status__c = 'New';
        mRequestItemCustomerEditInfo.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItemCustomerEditInfo.Customer__c = mAccount.Id;
        mRequestItemCustomerEditInfo.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerEditInfo').getRecordTypeId();
        insert mRequestItemCustomerEditInfo;

        CTRRequestFormItem__c mRequestItemCustomerEditInfo2 = new CTRRequestFormItem__c();
        mRequestItemCustomerEditInfo2.Name = 'Initial Account Request Item - Edit';
        mRequestItemCustomerEditInfo2.Status__c = 'New';
        mRequestItemCustomerEditInfo2.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItemCustomerEditInfo2.Customer__c = mAccount.Id;
        mRequestItemCustomerEditInfo2.SAPStatus__c = 'SAP Confirmed Sales/Purchasing View';
        mRequestItemCustomerEditInfo2.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerEditInfo').getRecordTypeId();
        insert mRequestItemCustomerEditInfo2;

        CTRRequestFormItem__c mRequestItemSupplierEditInfo = new CTRRequestFormItem__c();
        mRequestItemSupplierEditInfo.Name = 'Initial Account Request Item - 1';
        mRequestItemSupplierEditInfo.Status__c = 'New';
        mRequestItemSupplierEditInfo.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItemSupplierEditInfo.Customer__c = mAccount.Id;
        mRequestItemSupplierEditInfo.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierEditInfo').getRecordTypeId();
        insert mRequestItemSupplierEditInfo;

        CTRRequestFormItem__c mRequestItemSupplierInitial = new CTRRequestFormItem__c();
        mRequestItemSupplierInitial.Name = 'Initial Account Request Item - SupplierInitial';
        mRequestItemSupplierInitial.Status__c = 'New';
        mRequestItemSupplierInitial.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItemSupplierInitial.Customer__c = mAccount.Id;
        mRequestItemSupplierInitial.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierInitial').getRecordTypeId();
        insert mRequestItemSupplierInitial;

        CTRRequestFormItem__c mRequestItemShipToEdit = new CTRRequestFormItem__c();
        mRequestItemShipToEdit.Name = 'Initial Account Request Item - ShipToEdit';
        mRequestItemShipToEdit.Status__c = 'New';
        mRequestItemShipToEdit.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItemShipToEdit.Customer__c = mAccount.Id;
        mRequestItemShipToEdit.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('ShipToEdit').getRecordTypeId();
        insert mRequestItemShipToEdit;

        CTRRequestFormItem__c mRequestItemShipToCreate = new CTRRequestFormItem__c();
        mRequestItemShipToCreate.Name = 'Initial Account Request Item - ShipToCreate';
        mRequestItemShipToCreate.Status__c = 'New';
        mRequestItemShipToCreate.CTRRequestFormHeader__c = mRequestHeader.Id;
        mRequestItemShipToCreate.Customer__c = mAccount.Id;
        mRequestItemShipToCreate.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('ShipToCreate').getRecordTypeId();
        insert mRequestItemShipToCreate;

        
        

        CTRUser__c mCTRUser = new CTRUser__c();
        mCTRUser.Username__c = 'test@gmail.com';
        mCTRUser.Email__c = 'test@gmail.com';
        mCTRUser.Password__c = 'Test';
        mCTRUser.RecordTypeId = Schema.SObjectType.CTRUser__c.getRecordTypeInfosByDeveloperName().get('Administrator').getRecordTypeId();
        insert mCTRUser;

        CTRConfig__c mCTRConfig = new CTRConfig__c();
        mCTRConfig.Heroku_Authen_Endpoint__c = 'https://ctr-api-dev-00b55ca925a8.herokuapp.com/c360/m4-1/api/user/login';
        mCTRConfig.HerokuDomain__c = 'https://ctr-front-dev-3ee5b7960f48.herokuapp.com';
        insert mCTRConfig;

        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User mUser = new User();
        mUser.ProfileId = profile.Id;
        mUser.Username = 'testuseradmin@example.com';
        mUser.Email = 'testuseradmin@example.com';
        mUser.Alias = 'tuadmin';
        mUser.EmailEncodingKey = 'UTF-8';
        mUser.LastName = 'TestUser';
        mUser.LanguageLocaleKey = 'en_US';
        mUser.LocaleSidKey = 'en_US';
        mUser.TimeZoneSidKey = 'America/Los_Angeles';
        insert mUser;

    }

    @isTest static void Test_SendToSAP_Customer() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
            CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
            String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'Customer');
        Test.stopTest();
    }

    @isTest static void Test_SendToSAP_Supplier() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierInitial').getRecordTypeId()  LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'Supplier');
        Test.stopTest();
    }

    @isTest static void Test_SendToSAP_CustomerInitial() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId()  LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'CustomerInitial');
        Test.stopTest();
    }

    @isTest static void Test_SendToSAP_CustomerBlock() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerBlock').getRecordTypeId()  LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'CustomerBlock');
        Test.stopTest();
    }

    @isTest static void Test_SendToSAP_SupplierBlock() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierBlock').getRecordTypeId()  LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'SupplierBlock');
        Test.stopTest();
    }

    @isTest static void Test_SendToSAP_SupplierInitial() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierInitial').getRecordTypeId()  LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'SupplierInitial');
        Test.stopTest();
    }

    @isTest static void Test_SendToSAP_SupplierEditInfo() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierEditInfo').getRecordTypeId()  LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'SupplierEditInfo');
        Test.stopTest();
    }

    @isTest static void Test_SendToSAP_CustomerEditInfo() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerEditInfo').getRecordTypeId() AND SAPStatus__c = 'SAP Confirmed Sales/Purchasing View'];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'CustomerEditInfo');

        mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerEditInfo').getRecordTypeId() AND SAPStatus__c <> 'SAP Confirmed Sales/Purchasing View'];
        mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'CustomerEditInfo');
        Test.stopTest();
    }
    
    @isTest static void Test_SendToSAP_Block() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'Supplier');
        Test.stopTest();
    }
    
    @isTest static void Test_SendToSAP_ShipToCreate() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('ShipToCreate').getRecordTypeId()  LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'ShipToCreate');
        Test.stopTest();
    }
    
    @isTest static void Test_SendToSAP_ShipToEdit() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('ShipToEdit').getRecordTypeId()  LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'ShipToEdit');
        Test.stopTest();
    }
    
    @isTest static void Test_SendToSAP_Fail() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CTRCommitteeSendToSapTest.ResponseFailedMock());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('ShipToEdit').getRecordTypeId()  LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'ShipToEdit');
        Test.stopTest();
    }

    @isTest static void Test_SendToSAP_Supplier_Queueable() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        System.enqueueJob(new CTRCommitteeSendToSapQueueable(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'Supplier'));
        Test.stopTest();
    }

    @isTest static void Test_EmailInformCCA()
    {
        Test.startTest();
        List<CTRRequestFormItem__c> requestList = [SELECT Id, Customer__r.AccountNumber__c, RecordType.Name FROM CTRRequestFormItem__c];
        User user = [SELECT Id FROM User LIMIT 1];
        Set<Id> userIds = new Set<Id>();
        userIds.add(user.Id); 
        CTRCommitteeSendToSap.EmailInformCCA(requestList);
        Test.stopTest();
    }
    
    @isTest static void Test_SendToSAP_Other_SAP_STATUS() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c WHERE RecordType.Id =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId() AND  SAPStatus__c = 'Send General View To SAP'  LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        String mSendResult = CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'CustomerInitial');
        Test.stopTest();
    }
}