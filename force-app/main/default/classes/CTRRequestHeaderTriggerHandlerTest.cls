@isTest
public class CTRRequestHeaderTriggerHandlerTest {
    
    @isTest
    static void testTrigger(){
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

        mRequestHeader.Name = 'Edit Name';
        update mRequestHeader;

        delete mRequestHeader;
    }
}