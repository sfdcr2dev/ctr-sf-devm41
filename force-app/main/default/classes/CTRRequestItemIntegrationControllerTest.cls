@isTest
public  class CTRRequestItemIntegrationControllerTest {
    
    @isTest
    static void testSetupJsonForCTRDataModel(){
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

        CTRRequestFormItem__c tmp_mRequestItem = new CTRRequestFormItem__c();
        tmp_mRequestItem.Name = 'Initial Account Request Item - 1';
        tmp_mRequestItem.Status__c = 'New';
        tmp_mRequestItem.CTRRequestFormHeader__c = mRequestHeader.Id;
        tmp_mRequestItem.Customer__c = mAccount.Id;
        tmp_mRequestItem.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();
        insert tmp_mRequestItem;

        Test.startTest();
        CTRRequestFormItem__c mRequestItem = [SELECT ID,Name,Status__c,CTRRequestFormHeader__c,Customer__c,RecordType.DeveloperName,GatewayId__c,SalesOrganization__c,DistributionChannel__c,Division__c,Customer__r.AccountNumber__c,
        Incoterms__c,Incoterms2__c,Currency__c,AccountAssignmentGroup__c,TermofPayment__r.Code__c,PaymentGuaranteeProcedure__c,CreditControlArea__c,SalesDistrict__c,SalesOffice__c,SalesGroup__c,OrderProbability__c,ExchangeRateType__c,CustPriceProc__c,CustStatGroup__c,DeliveryPriority__c,ShippingConditions__c,DeliveryPlant__c,OrderCombination__c,PartialDeliveriesperitem__c,MaxPartialDeliveries__c,UnderdeliveryTolerance__c,OverdeliveryTolerance__c,Rebate__c,IsPriceDetermin__c,PriceGroup__c,SortKey__c,ReconAccount__c,CashManagementGroup__c,PaymentHistoryRecord__c,Authorization__c FROM CTRRequestFormItem__c LIMIT 1 ];
        // CTRRequestItemIntegrationController.test();
        CTRRequestItemIntegrationController.SetupJsonForCTRDataModel(mRequestHeader, mRequestItem, 'General', 'TX','1234');
        CTRRequestItemIntegrationController.SetupJsonForCTRDataModel(mRequestHeader, mRequestItem, 'Sale', 'TX','5678');
        Test.stopTest();
    }
}