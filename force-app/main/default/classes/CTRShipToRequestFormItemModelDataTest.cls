@isTest
public class CTRShipToRequestFormItemModelDataTest {
   
    @TestSetup
    static void makeData(){
        Account mAccount = new Account();
        mAccount.Name = 'Test Initial Account';
        mAccount.AccountNumber__c = '0001';
        mAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Initial').getRecordTypeId();
        insert mAccount;

        Master_Map__c m1 = new Master_Map__c(Code__c='TSV', Type__c='Trading Partner');
        insert m1;

        CTRRequestFormHeader__c mRequestHeader = new CTRRequestFormHeader__c();
        mRequestHeader.Name = 'Initial Account Request Header';
        mRequestHeader.Status__c = 'New';
        mRequestHeader.Customer__c = mAccount.Id;
        mRequestHeader.TradingPartner__c = m1.Id;
        insert mRequestHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'SupplierInitial' limit 1];
        CTRRequestFormItem__c reqItemConditionTrue = new CTRRequestFormItem__c();
        reqItemConditionTrue.Name = 'TestConditionTrue Item';
        reqItemConditionTrue.CTRRequestFormHeader__c = mRequestHeader.Id;
        reqItemConditionTrue.RecordTypeId = rt.Id;
        reqItemConditionTrue.EmailTo__c = 'testemailto@test.com';
        reqItemConditionTrue.EmailCC__c = 'testemailcc@test.com';
        reqItemConditionTrue.PurchasingOrganization__c = 'H100';
        insert reqItemConditionTrue;
    }

    @isTest
    public static void testSetupJsonForSupplierDataModel(){

        CTRRequestFormHeader__c mRequestHeader = [SELECT ID,Customer__c,
                                                    AccountGroup__c,
                                                    TaxCode1__c,
                                                    CoName__c,
                                                    CustomerNameLocal1__c,
                                                    CustomerNameLocal2__c,
                                                    CityStateLocal__r.Description__c,
                                                    DistrictLocalText__c,
                                                    PostalCodeLocalText__c,
                                                    BuildingCodeLocal__c,
                                                    RoomLocal__c,
                                                    FloorLocal__c,
                                                    HousenoLocal__c,
                                                    StreetLocal__c,
                                                    Street2Local__c,
                                                    Street3Local__c,
                                                    Street4Local__c,
                                                    Street5Local__c,
                                                    Country__r.Code__c,
                                                    Language__c,
                                                    SupplierSearchTermLocal__c,
                                                    SupplierSearchTermEN__c,
                                                    PhoneCountryCode__c,
                                                    Phone__c,
                                                    PhoneExtension__c,
                                                    FaxCountryCode__c,
                                                    Fax__c,
                                                    FaxExtension__c,
                                                    Email__c,
                                                    MobileCountryCode__c,
                                                    MobilePhone__c,
                                                    CustomerNameEN1__c,
                                                    CustomerNameEN2__c,
                                                    DistrictENText__c,
                                                    StreetEN__c,
                                                    Street2EN__c,
                                                    Street3EN__c,
                                                    Street4EN__c,
                                                    Street5EN__c,
                                                    SortKey__c,
                                                    ReconAccount__c,
                                                    CashManagementGroup__c,
                                                    Authorization__c,
                                                    TradingPartner__c,
                                                    RegionSAP__c,
                                                    TimeZone__c,
                                                    CustomerSearchTermLocal__c,
                                                    CustomerSearchTermEN__c,
                                                    TAXClassification__c,
                                                    SubDistrictLocalText__c,TypeOfBusinessBranch__c,CustomerTypeSAP__c,Industry__c,
                                                    TradingPartner__r.Code__c
                                                    FROM CTRRequestFormHeader__c LIMIT 1];
        CTRRequestFormItem__c mRequestItem = [SELECT ID, GatewayId__c,Customer__r.SupplierNumber__c,PurchasingOrganization__c,
                                                Incoterms__c,
                                                Incoterms2__c,
                                                Currency__c,
                                                TermOfPayment__r.Code__c,
                                                GRBasedInvVerif__c,
                                                VendorName__c,
                                                VendorPhone__c,
                                                ShippingConditions__c,
                                                SalesOrganization__c,
                                                ReconAccount__c,
                                                PaymentMethod__c,
                                                AccigClerk__c,
                                                CashManagementGroup__c,
                                                SortKey__c,
                                                WHTaxCountry__c,
                                                Chkdoubleinv__c,
                                                DistributionChannel__c,
                                                Division__c,
                                                RecordType.DeveloperName,
                                                CreditControlArea__c,
                                                SalesDistrict__c,
                                                SalesOffice__c,
                                                SalesGroup__c,
                                                OrderProbability__c,
                                                ExchangeRateType__c,
                                                CustPriceProc__c,
                                                CustStatGroup__c,
                                                DeliveryPriority__c,
                                                DeliveryPlant__c,
                                                OrderCombination__c,
                                                PartialDeliveriesperitem__c,
                                                MaxPartialDeliveries__c,
                                                UnderdeliveryTolerance__c,
                                                OverdeliveryTolerance__c,
                                                Rebate__c,
                                                IsPriceDetermin__c,
                                                PriceGroup__c,
                                                AccountAssignmentGroup__c,
                                                PaymentGuaranteeProcedure__c,PaymentHistoryRecord__c
                                                FROM CTRRequestFormItem__c LIMIT 1];
        Test.startTest();
        CTRShipToRequestFormItemModelData.SetupJsonForShipToDataModel(mRequestHeader, mRequestItem, 'General', 'TX', 'UUID');
        CTRShipToRequestFormItemModelData.SetupJsonForShipToDataModel(mRequestHeader, mRequestItem, 'Sale', 'TX', 'UUID');
        Test.stopTest();

    }
}