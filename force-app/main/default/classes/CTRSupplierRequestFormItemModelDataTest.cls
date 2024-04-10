@isTest
public class CTRSupplierRequestFormItemModelDataTest {
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success"}');
            return res;
        }
    }

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
        reqItemConditionTrue.PurchasingOrganization__c = '1100';
            insert reqItemConditionTrue;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

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
                                                    TradingPartner__c,
                                                    StreetEN__c,
                                                    Street2EN__c,
                                                    Street3EN__c,
                                                    Street4EN__c,
                                                    GroupKeyAccountKeyofBank__c,
                                                    Street5EN__c FROM CTRRequestFormHeader__c LIMIT 1];
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
                                                Recty1__c,
                                                Recty2__c,
                                                Chkdoubleinv__c
                                                FROM CTRRequestFormItem__c LIMIT 1];
        Test.startTest();
        CTRSupplierRequestFormItemModelData.SetupJsonForSupplierDataModel(mRequestHeader, mRequestItem, 'General', 'TX','Test');
        Test.stopTest();

    }
}