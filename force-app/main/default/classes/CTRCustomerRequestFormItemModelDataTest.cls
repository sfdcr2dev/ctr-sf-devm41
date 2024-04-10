@isTest
public class CTRCustomerRequestFormItemModelDataTest {
    
    @testSetup static void setupData()
    {
        Account mAccount = new Account();
        mAccount.Name = 'Test Initial Account';
        mAccount.AccountNumber__c = '0001';
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

    @isTest static void testSetupJsonForCustomerDataModel() 
    {
        Test.startTest();
        CTRRequestFormHeader__c mRequestHeader = [SELECT Id FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        CTRCommitteeSendToSap.wrapperResultData mResultLogin = CTRCommitteeSendToSap.getDefaultData(mRequestItem.Id);
        CTRCustomerRequestFormItemModelData.SetupJsonForCustomerDataModel(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'General','TX','test');
        CTRCustomerRequestFormItemModelData.SetupJsonForCustomerDataModel(mResultLogin.mRequestHeader, mResultLogin.mRequestItem, 'Sale','TX','test');
        Test.stopTest();
    }
}