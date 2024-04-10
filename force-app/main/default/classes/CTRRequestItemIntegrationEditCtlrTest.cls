@isTest
public class CTRRequestItemIntegrationEditCtlrTest {
   
    @isTest
    static void testSetupJsonForCTRDataModel(){
        Account mAccount = new Account();
        mAccount.Name = 'Test Initial Account';
        mAccount.AccountNumber__c = '0001';
        mAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Initial').getRecordTypeId();
        insert mAccount;

        List<Master_Map__c> Master = new List<Master_Map__c>();
        Master_Map__c m1 = new Master_Map__c(Code__c='ZTH0245', Type__c='Transportation Zone');
        Master.add(m1);
        Master_Map__c m2 = new Master_Map__c(Code__c='TH', Type__c='Country');
        Master.add(m2);
        Master_Map__c m3 = new Master_Map__c(Code__c='TH-Bangkok', Name ='TH-Bangkok',  Type__c='Province');
        Master.add(m3);
        Master_Map__c m4 = new Master_Map__c(Code__c='mg1', Type__c='Material Group');
        Master.add(m4);
        Master_Map__c m5 = new Master_Map__c(Code__c='ZA00001', Type__c ='Payment Term');   
        Master.add(m5);
        
        insert Master;

        CTRRequestFormHeader__c mRequestHeader = new CTRRequestFormHeader__c();
        mRequestHeader.Name = 'Initial Account Request Header';
        mRequestHeader.Status__c = 'New';
        mRequestHeader.Customer__c = mAccount.Id;
        mRequestHeader.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        insert mRequestHeader;

        CTRRequestFormItem__c tmp_mRequestItem = new CTRRequestFormItem__c();
        tmp_mRequestItem.Name = 'Initial Account Request Item - 1';
        tmp_mRequestItem.Status__c = 'New';
        tmp_mRequestItem.CTRRequestFormHeader__c = mRequestHeader.Id;
        tmp_mRequestItem.Customer__c = mAccount.Id;
        tmp_mRequestItem.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        tmp_mRequestItem.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();
        insert tmp_mRequestItem;

        // CTRRequestFormItem__c tmp_mRequestItem2 = new CTRRequestFormItem__c();
        // tmp_mRequestItem2.Name = 'Initial Account Request Item - 2';
        // tmp_mRequestItem2.Status__c = 'New';
        // tmp_mRequestItem2.CTRRequestFormHeader__c = mRequestHeader.Id;
        // tmp_mRequestItem2.Customer__c = mAccount.Id;
        // tmp_mRequestItem2.InternalEditField__c = '[{"Label":"Country","Api":"TaxClassification__c","Value":"'+ Master[1].Id +'"}]';
        // tmp_mRequestItem2.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();
        // insert tmp_mRequestItem2;

        // CTRRequestFormItem__c tmp_mRequestItemSupplierInitial = new CTRRequestFormItem__c();
        // tmp_mRequestItemSupplierInitial.Name = 'Initial Account Request Item - 1';
        // tmp_mRequestItemSupplierInitial.Status__c = 'New';
        // tmp_mRequestItemSupplierInitial.CTRRequestFormHeader__c = mRequestHeader.Id;
        // tmp_mRequestItemSupplierInitial.Customer__c = mAccount.Id;
        // tmp_mRequestItemSupplierInitial.InternalEditField__c = '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        // tmp_mRequestItemSupplierInitial.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierInitial').getRecordTypeId();
        // insert tmp_mRequestItemSupplierInitial;


        // CTRRequestFormItem__c tmp_mRequestItemSupplierInitial2 = new CTRRequestFormItem__c();
        // tmp_mRequestItemSupplierInitial2.Name = 'Initial Account Request Item - 2';
        // tmp_mRequestItemSupplierInitial2.Status__c = 'New';
        // tmp_mRequestItemSupplierInitial2.CTRRequestFormHeader__c = mRequestHeader.Id;
        // tmp_mRequestItemSupplierInitial2.Customer__c = mAccount.Id;
        // tmp_mRequestItemSupplierInitial2.InternalEditField__c = '[{"Label":"Country","Api":"TaxClassification__c","Value":"'+ Master[1].Id +'"}]';
        // tmp_mRequestItemSupplierInitial2.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierInitial').getRecordTypeId();
        // insert tmp_mRequestItemSupplierInitial2;

        List<CTRRequestFormItem__c> mRequestItemList = [SELECT ID,Name,Status__c,CTRRequestFormHeader__c,Customer__c,RecordType.DeveloperName,GatewayId__c,SalesOrganization__c,DistributionChannel__c,Division__c,Customer__r.AccountNumber__c,
        Incoterms__c,Incoterms2__c,Currency__c,AccountAssignmentGroup__c,TermofPayment__r.Code__c,PaymentGuaranteeProcedure__c,CreditControlArea__c,SalesDistrict__c,SalesOffice__c,SalesGroup__c,OrderProbability__c,ExchangeRateType__c,CustPriceProc__c,CustStatGroup__c,DeliveryPriority__c,ShippingConditions__c,DeliveryPlant__c,OrderCombination__c,PartialDeliveriesperitem__c,MaxPartialDeliveries__c,UnderdeliveryTolerance__c,OverdeliveryTolerance__c,Rebate__c,IsPriceDetermin__c,PriceGroup__c,SortKey__c,ReconAccount__c,CashManagementGroup__c,PaymentHistoryRecord__c,Authorization__c,InternalEditField__c,Customer__r.SupplierNumber__c FROM CTRRequestFormItem__c
        WHERE RecordTypeId =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId()];


        List<CTRRequestFormItem__c> mRequestItemList2 = [SELECT ID,Name,Status__c,CTRRequestFormHeader__c,Customer__c,RecordType.DeveloperName,GatewayId__c,SalesOrganization__c,DistributionChannel__c,Division__c,Customer__r.AccountNumber__c,
        Incoterms__c,Incoterms2__c,Currency__c,AccountAssignmentGroup__c,TermofPayment__r.Code__c,PaymentGuaranteeProcedure__c,CreditControlArea__c,SalesDistrict__c,SalesOffice__c,SalesGroup__c,OrderProbability__c,ExchangeRateType__c,CustPriceProc__c,CustStatGroup__c,DeliveryPriority__c,ShippingConditions__c,DeliveryPlant__c,OrderCombination__c,PartialDeliveriesperitem__c,MaxPartialDeliveries__c,UnderdeliveryTolerance__c,OverdeliveryTolerance__c,Rebate__c,IsPriceDetermin__c,PriceGroup__c,SortKey__c,ReconAccount__c,CashManagementGroup__c,PaymentHistoryRecord__c,Authorization__c,InternalEditField__c,Customer__r.SupplierNumber__c FROM CTRRequestFormItem__c
        WHERE RecordTypeId =: Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierInitial').getRecordTypeId()];
        List<CTRIntegrationMapping__mdt> mAllMappingList = [SELECT Id, BusinessUnit__c, IntegrationType__c, JsonMapping__c, RecordType__c, ViewName__c, SupportIntegrationType__c FROM CTRIntegrationMapping__mdt];
        
        Test.startTest();

        CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModel(mAllMappingList, mRequestHeader, mRequestItemList[0], 'Customer', 'TX', '');
        CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModel(mAllMappingList, mRequestHeader, mRequestItemList[0], 'Customer', 'TX', '');

        // CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModel(mRequestHeader, mRequestItemList2[0], 'Supplier', 'TX', '');
        // CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModel(mRequestHeader, mRequestItemList2[1], 'Supplier', 'TX', '');

        // String fields =  '[{"Label":"Country","Api":"Country__c","Value":"'+ Master[1].Id +'"},{"Label":"TransportationZone","Api":"TransportationZone__c","Value":"'+ Master[0].Id +'"},{"Label":"CityLocal","Api":"CityLocal__c","Value":"'+ Master[2].Id +'"}]';
        // CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModelTest(fields, fields, 'Customer', 'TOP', 'Customer');
        // CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModelTest(fields, fields, 'Customer', 'TX', 'Customer');

        // CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModelTest(fields, fields, 'Supplier', 'TOP', 'Supplier');
        // CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModelTest(fields, fields, 'Supplier', 'TX', 'Supplier');
        
        // String fields2 =  '[{"Label":"Country","Api":"TaxClassification__c","Value":"'+ Master[1].Id +'"}}]';
        // CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModelTest(fields2, fields2, 'Customer', 'TX', 'Customer');
        
        Test.stopTest();
    }

    @isTest
    static void testSetupJsonForCTRDataModelTax(){
        Account mAccount = new Account();
        mAccount.Name = 'Test Initial Account';
        mAccount.AccountNumber__c = '0001';
        mAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Initial').getRecordTypeId();
        insert mAccount;

        CTRRequestFormHeader__c mRequestHeader = new CTRRequestFormHeader__c();
        mRequestHeader.Name = 'Initial Account Request Header';
        mRequestHeader.Status__c = 'New';
        mRequestHeader.Customer__c = mAccount.Id;
        mRequestHeader.InternalEditField__c ='[{"Level":"Header","Label":"TaxClassification","Api":"TaxClassification__c"},{"Level":"Item","Label":"SortKey","Api":"SortKey__c"},{"Level":"Item","Label":"ReconciliationAccount","Api":"ReconAccount__c"}]';
        insert mRequestHeader;

        CTRRequestFormItem__c tmp_mRequestItem = new CTRRequestFormItem__c();
        tmp_mRequestItem.Name = 'Initial Account Request Item - 1';
        tmp_mRequestItem.Status__c = 'New';
        tmp_mRequestItem.CTRRequestFormHeader__c = mRequestHeader.Id;
        tmp_mRequestItem.Customer__c = mAccount.Id;
        tmp_mRequestItem.InternalEditField__c ='[{"Level":"Header","Label":"TaxClassification","Api":"TaxClassification__c"},{"Level":"Item","Label":"SortKey","Api":"SortKey__c"},{"Level":"Item","Label":"ReconciliationAccount","Api":"ReconAccount__c"}]';
        tmp_mRequestItem.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();
        insert tmp_mRequestItem;

        List<CTRRequestFormItem__c> mRequestItemList = [SELECT ID,Name,Status__c,CTRRequestFormHeader__c,Customer__c,RecordType.DeveloperName,GatewayId__c,SalesOrganization__c,DistributionChannel__c,Division__c,Customer__r.AccountNumber__c,
        Incoterms__c,Incoterms2__c,Currency__c,AccountAssignmentGroup__c,TermofPayment__r.Code__c,PaymentGuaranteeProcedure__c,CreditControlArea__c,SalesDistrict__c,SalesOffice__c,SalesGroup__c,OrderProbability__c,ExchangeRateType__c,CustPriceProc__c,CustStatGroup__c,DeliveryPriority__c,ShippingConditions__c,DeliveryPlant__c,OrderCombination__c,PartialDeliveriesperitem__c,MaxPartialDeliveries__c,UnderdeliveryTolerance__c,OverdeliveryTolerance__c,Rebate__c,IsPriceDetermin__c,PriceGroup__c,SortKey__c,ReconAccount__c,CashManagementGroup__c,PaymentHistoryRecord__c,Authorization__c,InternalEditField__c FROM CTRRequestFormItem__c];

        String fields = '[{"Level":"Header","Label":"TaxClassification","Api":"TaxClassification__c"},{"Level":"Item","Label":"SortKey","Api":"SortKey__c"},{"Level":"Item","Label":"ReconciliationAccount","Api":"ReconAccount__c"}]';
        List<CTRIntegrationMapping__mdt> mAllMappingList = [SELECT Id, BusinessUnit__c, IntegrationType__c, JsonMapping__c, RecordType__c, ViewName__c, SupportIntegrationType__c FROM CTRIntegrationMapping__mdt];
        
        Test.startTest();
        CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModel(mAllMappingList, mRequestHeader, mRequestItemList[0], 'Customer', 'TX', '');
        // CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModelTest(fields, fields, 'Customer', 'TOP', 'Customer');
        Test.stopTest();
    }

    @isTest
    static void testSetupJsonForCTRDataModelSalesData(){
        Account mAccount = new Account();
        mAccount.Name = 'Test Initial Account';
        mAccount.AccountNumber__c = '0001';
        mAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Initial').getRecordTypeId();
        insert mAccount;

        CTRRequestFormHeader__c mRequestHeader = new CTRRequestFormHeader__c();
        mRequestHeader.Name = 'Initial Account Request Header';
        mRequestHeader.Status__c = 'New';
        mRequestHeader.Customer__c = mAccount.Id;
        mRequestHeader.InternalEditField__c ='[{"Level":"Item","Label":"Incoterms","Api":"Incoterms__c"},{"Level":"Item","Label":"Incoterms2","Api":"Incoterms2__c"},{"Level":"Item","Label":"Currencies","Api":"Currency__c"},{"Level":"Item","Label":"AccountAssignmentGroup","Api":"AccountAssignmentGroup__c"}]';
        insert mRequestHeader;

        CTRRequestFormItem__c tmp_mRequestItem = new CTRRequestFormItem__c();
        tmp_mRequestItem.Name = 'Initial Account Request Item - 1';
        tmp_mRequestItem.Status__c = 'New';
        tmp_mRequestItem.CTRRequestFormHeader__c = mRequestHeader.Id;
        tmp_mRequestItem.Customer__c = mAccount.Id;
        tmp_mRequestItem.InternalEditField__c ='[{"Level":"Item","Label":"Incoterms","Api":"Incoterms__c"},{"Level":"Item","Label":"Incoterms2","Api":"Incoterms2__c"},{"Level":"Item","Label":"Currencies","Api":"Currency__c"},{"Level":"Item","Label":"AccountAssignmentGroup","Api":"AccountAssignmentGroup__c"}]';
        tmp_mRequestItem.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();
        insert tmp_mRequestItem;

        List<CTRRequestFormItem__c> mRequestItemList = [SELECT ID,Name,Status__c,CTRRequestFormHeader__c,Customer__c,RecordType.DeveloperName,GatewayId__c,SalesOrganization__c,DistributionChannel__c,Division__c,Customer__r.AccountNumber__c,
        Incoterms__c,Incoterms2__c,Currency__c,AccountAssignmentGroup__c,TermofPayment__r.Code__c,PaymentGuaranteeProcedure__c,CreditControlArea__c,SalesDistrict__c,SalesOffice__c,SalesGroup__c,OrderProbability__c,ExchangeRateType__c,CustPriceProc__c,CustStatGroup__c,DeliveryPriority__c,ShippingConditions__c,DeliveryPlant__c,OrderCombination__c,PartialDeliveriesperitem__c,MaxPartialDeliveries__c,UnderdeliveryTolerance__c,OverdeliveryTolerance__c,Rebate__c,IsPriceDetermin__c,PriceGroup__c,SortKey__c,ReconAccount__c,CashManagementGroup__c,PaymentHistoryRecord__c,Authorization__c,InternalEditField__c FROM CTRRequestFormItem__c];

        String fields = '[{"Level":"Item","Label":"Incoterms","Api":"Incoterms__c"},{"Level":"Item","Label":"Incoterms2","Api":"Incoterms2__c"},{"Level":"Item","Label":"Currencies","Api":"Currency__c"},{"Level":"Item","Label":"AccountAssignmentGroup","Api":"AccountAssignmentGroup__c"}]';
        List<CTRIntegrationMapping__mdt> mAllMappingList = [SELECT Id, BusinessUnit__c, IntegrationType__c, JsonMapping__c, RecordType__c, ViewName__c, SupportIntegrationType__c FROM CTRIntegrationMapping__mdt];
        
        Test.startTest();
        CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModel(mAllMappingList, mRequestHeader, mRequestItemList[0], 'Customer', 'TX', '');
        // CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModelTest(fields, fields, 'Customer', 'TOP', 'Customer');
        Test.stopTest();
    }
        

}