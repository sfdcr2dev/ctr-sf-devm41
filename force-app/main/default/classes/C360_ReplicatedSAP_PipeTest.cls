@isTest
public class C360_ReplicatedSAP_PipeTest {
    @testSetup
    public static void setupdate()
    {
        C360_Product__c Pro = new C360_Product__c();
        Pro.MaterialCode__c = 'YLPG';
        	insert Pro;
    }
    
    @IsTest
	static void testWebService() {
		Test.startTest();
		C360_ReplicatedSAP_Pipe.dto_response dto = new C360_ReplicatedSAP_Pipe.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/c360/replicated/sap/pipe';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"PLIST\":[{\"SALES_ORG\":\"1400\",\"DISTRIBUTION_CHANNEL\":\"10\",\"TRIP_NO\":\"0987654321\",\"DELIVERY_DATE\":\"2021-01-15\",\"PERIOD\":\"2022.01\",\"START\":\"\",\"COMPLETE\":\"\",\"CUSTOMER\":\"aaaaa\",\"NAME1\":\"LabixCompanyLimited\",\"NAME2\":\"\",\"MATERIAL\":\"\",\"MATERIAL_DESCRIPTION\":\"bbbbb\",\"PAY\":\"M\",\"CHECK\":\"M\",\"FROM\":\"580-FI-901\",\"TO\":\"580-FI-902\",\"PAY_L15\":2605841.0,\"PAY_L30\":2644351.0,\"PAY_BBL\":16399.0,\"PAY_MT\":2051.185,\"PAY_KG\":2051185.0,\"CHECK_L15\":1.0,\"CHECK_L30\":1.0,\"CHECK_BBL\":1.0,\"CHECK_MT\":1.0,\"CHECK_KG\":1.0,\"QTY_L_G_L15\":1.0,\"PERCENT_L_G_L15\":1.0,\"QTY_L_G_L30\":1.0,\"PERCENT_L_G_L30\":1.0,\"QTY_L_G_BBL\":1.0,\"PERCENT_L_G_BBL\":1.0,\"QTY_L_G_MT\":1.0,\"PERCENT_L_G_MT\":1.0,\"QTY_L_G_KG\":1.0,\"PERCENT_L_G_KG\":1.0,\"PAY_TANK_NO\":\"\",\"CHECK_TANK_NO\":\"\",\"SALES_UNIT\":\"\",\"TIME_BEFORE_AFTER\":\"\",\"SOURCE_TANK_METER\":\"\",\"SOURCE_TYPE_PAY_RECIEVE\":\"\"},{\"SALES_ORG\":\"1500\",\"DISTRIBUTION_CHANNEL\":\"15\",\"TRIP_NO\":\"123456789\",\"DELIVERY_DATE\":\"2021-01-15\",\"PERIOD\":\"2022.01\",\"START\":\"\",\"COMPLETE\":\"\",\"CUSTOMER\":\"aaaaa\",\"NAME1\":\"LabixCompanyLimited\",\"NAME2\":\"\",\"MATERIAL\":\"\",\"MATERIAL_DESCRIPTION\":\"bbbbb\",\"PAY\":\"M\",\"CHECK\":\"M\",\"FROM\":\"580-FI-901\",\"TO\":\"580-FI-902\",\"PAY_L15\":2605841.0,\"PAY_L30\":2644351.0,\"PAY_BBL\":16399.0,\"PAY_MT\":2051.185,\"PAY_KG\":2051185.0,\"CHECK_L15\":1.0,\"CHECK_L30\":1.0,\"CHECK_BBL\":1.0,\"CHECK_MT\":1.0,\"CHECK_KG\":1.0,\"QTY_L_G_L15\":1.0,\"PERCENT_L_G_L15\":1.0,\"QTY_L_G_L30\":1.0,\"PERCENT_L_G_L30\":1.0,\"QTY_L_G_BBL\":1.0,\"PERCENT_L_G_BBL\":1.0,\"QTY_L_G_MT\":1.0,\"PERCENT_L_G_MT\":1.0,\"QTY_L_G_KG\":1.0,\"PERCENT_L_G_KG\":1.0,\"PAY_TANK_NO\":\"\",\"CHECK_TANK_NO\":\"\",\"SALES_UNIT\":\"\",\"TIME_BEFORE_AFTER\":\"\",\"SOURCE_TANK_METER\":\"\",\"SOURCE_TYPE_PAY_RECIEVE\":\"\"}]}'
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
	static void testWebServiceFail() {
		Test.startTest();
		C360_ReplicatedSAP_Pipe.dto_response dto = new C360_ReplicatedSAP_Pipe.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/c360/replicated/sap/pipe';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"PLIST\":[{\"DATE\":\"2021-01-15\",\"DELIVERY_DATE\":\"2021-01-15\",\"JETTY_NO\":\"001\",\"TRIP_NO\":\"TOP_LPG2\",\"VESSEL_NAME\":\"MT BOON TEST001\",\"PRODUCT\":\"YLPG\",\"TANK\":\"3504\",\"CUSTOMER\":\"SHELL\",\"DESTINATION\":\"The Shell Co.Of Thailand Ltd.\",\"PUMP_CODE\":\"P101B\",\"TANK_TEMP_BEFORE\":34.75,\"TANK_TEMP_AFTER\":34.75,\"TANK_DENSITY\":0.5601,\"METER_TEMP\":0.0,\"METER_DENSITY\":0.0,\"SHIP_TEMP\":30.0,\"SHIP_DENSITY\":0.0,\"BL_QUANTITY_LITRES_30\":583384,\"BL_QUANTITY_METRIC_TONS\":315.024,\"BL_QUANTITY_BARREL\":3549.0,\"BL_QUANTITY_LITRES_OBS\":593449.0,\"QUANTITY_SHORE_LITRES_30\":583384,\"QUANTITY_SHORE_METRIC_TONS\":315.024,\"QUANTITY_SHORE_BARREL\":3549.0,\"QUANTITY_SHORE_LITRES_OBS\":593449.0,\"QUANTITY_METER_LITRES_30\":0,\"QUANTITY_METER_METRIC_TONS\":0.0,\"QUANTITY_METER_BARREL\":0.0,\"QUANTITY_METER_LITRES_OBS\":0.0,\"QUANTITY_SHIP_LITRES_30\":0,\"QUANTITY_SHIP_METRIC_TONS\":0.0,\"QUANTITY_SHIP_BARREL\":0.0,\"QUANTITY_SHIP_LITRES_OBS\":0.0,\"DIFF_METER_SHORE_MT\":0.0,\"DIFF_METER_SHORE_MT_P\":0.0,\"DIFF_METER_SHORE_LITRES_30\":0,\"DIFF_METER_SHORE_LITRES_30_P\":0.0,\"DIFF_METER_SHORE_BARREL\":0.0,\"DIFF_METER_SHORE_BARREL_P\":0.0,\"DIFF_METER_SHORE_LITRES_OBS\":0.0,\"DIFF_METER_SHORE_LITRES_OBS_P\":0.0,\"DIFF_METER_SHIP_MT\":0.0,\"DIFF_METER_SHIP_MT_P\":0.0,\"DIFF_METER_SHIP_LITRES_30\":0,\"DIFF_METER_SHIP_LITRES_30_P\":0.0,\"DIFF_METER_SHIP_BARREL\":0.0,\"DIFF_METER_SHIP_BARREL_P\":0.0,\"DIFF_METER_SHIP_LITRES_OBS\":0.0,\"DIFF_METER_SHIP_LITRES_OBS_P\":0.0,\"DIFF_SHORE_SHIP_MT\":0.0,\"DIFF_SHORE_SHIP_MT_P\":0.0,\"DIFF_SHORE_SHIP_LITRES_30\":0,\"DIFF_SHORE_SHIP_LITRES_30_P\":0.0,\"DIFF_SHORE_SHIP_BARREL\":0.0,\"DIFF_SHORE_SHIP_BARREL_P\":0.0,\"DIFF_SHORE_SHIP_LITRES_OBS\":0.0,\"DIFF_SHORE_SHIP_LITRES_OBS_P\":0.0,\"REMARK\":\"Tank\",\"DISTRIBUTION_CHANNEL\":\"10\",\"BL_APPROVE_DATE\":\"2021-10-10\",\"BL_APPROVE_TIME\":\"00:00:00\"}]}'
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