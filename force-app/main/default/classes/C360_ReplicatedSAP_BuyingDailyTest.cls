@isTest
public class C360_ReplicatedSAP_BuyingDailyTest 
{
    @testSetup
    public static void setupDate()
    {
        Account acc = new Account();
        acc.Name = 'Test Acc';
        insert acc;
        
        Account party = new Account();
        party.Name = '0000000027';
        insert party;
        
        C360_Product__c cproduct = new C360_Product__c();
        cproduct.MaterialCode__c = 'P001';
        insert cproduct;                                     
    }
    

    
    @IsTest
	static void testWebService() {
		Test.startTest();
		C360_ReplicatedSAP_BuyingDaily.dto_response dto = new C360_ReplicatedSAP_BuyingDaily.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/c360/replicated/sap/buyingdaily';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
                        'body' => '{\"DLIST\":[{\"SALES_ORGANIZATION\":\"1400\",\"DISTRIBUTION_CHANNEL\":\"14\",\"BILLING_DATE\":\"2016-01-20\",\"PRICING_DATE\":\"2016-01-20\",\"BILLING_TYPE\":\"Z3F2\",\"BILLING_DOCUMENT\":\"3310000254\",\"ITEM\":\"000010\",\"INVOICE_NO\":\"01120001\",\"SOLD_TO_PARTY\":\"0000000027\",\"NAME1\":\"PTTPublicCompanyLimited\",\"SEARCH_TERM\":\"\",\"SHIPPING_POINT\":\"42SH\",\"CANCELLED\":\"\",\"MATERIAL\":\"P001\",\"MATERIAL_DESCRIPTION\":\"BASEOIL150BS\",\"PLANT\":\"4200\",\"PLANT_NAME\":\"TLBSriracha\",\"BILLED_QUANTITY\":1759.954,\"SALES_UNIT\":\"MT\",\"LITRE_30\":2049234.0,\"BBL_15\":12756.0,\"MTON\":1759.954,\"SALES_PRICE_ZPR1\":131473.6,\"SALES_PRICE_ZPR2\":0.0,\"UNIT_PRICE\":0.0,\"FREIGHT_USD\":0.0,\"EXCISE_DUTY_ZEX1\":0.0,\"EXCISE_DUTY_ZEX2\":0.0,\"AMOUNT_BF_VAT\":2313874.88,\"TAX_AMOUNT\":161971.24,\"TOTAL\":2475846.12,\"PO_INTERCOMPANY\":0.0,\"ADDITIONAL_QUANTITY_LITRE\":1759.954,\"DELIVERY_ORDER_NO\":\"3220000385\",\"DELIVERY_ORDER_ITEM\":\"0000\",\"SHIP_TO\":\"Test Acc\",\"SHIP_TO_NAME\":\"Test Acc\",\"SHIP_TO_COUNTRY\":\"TH\",\"EXPORT_INVOICE_NO\":\"testexportinvoiceno.\",\"VESSEL_NAME\":\"BPP19fullname\",\"MATERIAL_GROUP_2\":\"\",\"AMOUNT_VAT_THB_USD\":64080.81,\"TAX_AMOUNT_THB_USD\":4485.66,\"TOTAL_THX_USD\":68566.47,\"EXCHANGE_RATE\":36.1087,\"FREIGHT_USD_THB\":0.0,\"EXCISE_DUTY_CURR_ZEX1\":\"\",\"EXCISE_DUTY_CURR_ZEX2\":\"\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		C360_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
    
    @IsTest
	static void testWebService_Error() {
		Test.startTest();
		C360_ReplicatedSAP_BuyingDaily.dto_response dto = new C360_ReplicatedSAP_BuyingDaily.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/c360/replicated/sap/buyingdaily';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
                        'body' => '{\"DLIST\":[{\"SALES_ORGANIZATION\":\"1400000\",\"DISTRIBUTION_CHANNEL\":\"14\",\"BILLING_DATE\":\"2016-01-20\",\"PRICING_DATE\":\"2016-01-20\",\"BILLING_TYPE\":\"Z3F2\",\"BILLING_DOCUMENT\":\"3310000254\",\"ITEM\":\"000010\",\"INVOICE_NO\":\"01120001\",\"SOLD_TO_PARTY\":\"0000000027\",\"NAME1\":\"PTTPublicCompanyLimited\",\"SEARCH_TERM\":\"\",\"SHIPPING_POINT\":\"42SH\",\"CANCELLED\":\"\",\"MATERIAL\":\"P001\",\"MATERIAL_DESCRIPTION\":\"BASEOIL150BS\",\"PLANT\":\"4200\",\"PLANT_NAME\":\"TLBSriracha\",\"BILLED_QUANTITY\":1759.954,\"SALES_UNIT\":\"MT\",\"LITRE_30\":2049234.0,\"BBL_15\":12756.0,\"MTON\":1759.954,\"SALES_PRICE_ZPR1\":131473.6,\"SALES_PRICE_ZPR2\":0.0,\"UNIT_PRICE\":0.0,\"FREIGHT_USD\":0.0,\"EXCISE_DUTY_ZEX1\":0.0,\"EXCISE_DUTY_ZEX2\":0.0,\"AMOUNT_BF_VAT\":2313874.88,\"TAX_AMOUNT\":161971.24,\"TOTAL\":2475846.12,\"PO_INTERCOMPANY\":0.0,\"ADDITIONAL_QUANTITY_LITRE\":1759.954,\"DELIVERY_ORDER_NO\":\"3220000385\",\"DELIVERY_ORDER_ITEM\":\"0000\",\"SHIP_TO\":\"Test Acc\",\"SHIP_TO_NAME\":\"Test Acc\",\"SHIP_TO_COUNTRY\":\"TH\",\"EXPORT_INVOICE_NO\":\"testexportinvoiceno.\",\"VESSEL_NAME\":\"BPP19fullname\",\"MATERIAL_GROUP_2\":\"\",\"AMOUNT_VAT_THB_USD\":64080.81,\"TAX_AMOUNT_THB_USD\":4485.66,\"TOTAL_THX_USD\":68566.47,\"EXCHANGE_RATE\":36.1087,\"FREIGHT_USD_THB\":0.0,\"EXCISE_DUTY_CURR_ZEX1\":\"\",\"EXCISE_DUTY_CURR_ZEX2\":\"\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		C360_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
}