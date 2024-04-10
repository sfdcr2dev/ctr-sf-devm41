@isTest
public class C360_ReplicatedSAP_JettyTest {
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
		C360_ReplicatedSAP_Jetty.dto_response dto = new C360_ReplicatedSAP_Jetty.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/c360/replicated/sap/jetty';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"JLIST\":[{\"DATE\":\"2021-01-15\",\"JETTY_NO\":\"001\",\"TRIP_NO\":\"TOP_LPG2\",\"VESSEL_NAME\":\"MT BOON TEST001\",\"PRODUCT\":\"YLPG\",\"TANK\":\"3504\",\"CUSTOMER\":\"SHELL\",\"DESTINATION\":\"The Shell Co.Of Thailand Ltd.\",\"PUMP_CODE\":\"P101B\",\"TANK_TEMP_BEFORE\":34.75,\"TANK_TEMP_AFTER\":34.75,\"TANK_DENSITY\":0.5601,\"METER_TEMP\":0.0,\"METER_DENSITY\":0.0,\"SHIP_TEMP\":30.0,\"SHIP_DENSITY\":0.0,\"BL_QUANTITY_LITRES_30\":583384,\"BL_QUANTITY_METRIC_TONS\":315.024,\"BL_QUANTITY_BARREL\":3549.0,\"BL_QUANTITY_LITRES_OBS\":593449.0,\"QUANTITY_SHORE_LITRES_30\":583384,\"QUANTITY_SHORE_METRIC_TONS\":315.024,\"QUANTITY_SHORE_BARREL\":3549.0,\"QUANTITY_SHORE_LITRES_OBS\":593449.0,\"QUANTITY_METER_LITRES_30\":0,\"QUANTITY_METER_METRIC_TONS\":0.0,\"QUANTITY_METER_BARREL\":0.0,\"QUANTITY_METER_LITRES_OBS\":0.0,\"QUANTITY_SHIP_LITRES_30\":0,\"QUANTITY_SHIP_METRIC_TONS\":0.0,\"QUANTITY_SHIP_BARREL\":0.0,\"QUANTITY_SHIP_LITRES_OBS\":0.0,\"DIFF_METER_SHORE_MT\":0.0,\"DIFF_METER_SHORE_MT_P\":0.0,\"DIFF_METER_SHORE_LITRES_30\":0,\"DIFF_METER_SHORE_LITRES_30_P\":0.0,\"DIFF_METER_SHORE_BARREL\":0.0,\"DIFF_METER_SHORE_BARREL_P\":0.0,\"DIFF_METER_SHORE_LITRES_OBS\":0.0,\"DIFF_METER_SHORE_LITRES_OBS_P\":0.0,\"DIFF_METER_SHIP_MT\":0.0,\"DIFF_METER_SHIP_MT_P\":0.0,\"DIFF_METER_SHIP_LITRES_30\":0,\"DIFF_METER_SHIP_LITRES_30_P\":0.0,\"DIFF_METER_SHIP_BARREL\":0.0,\"DIFF_METER_SHIP_BARREL_P\":0.0,\"DIFF_METER_SHIP_LITRES_OBS\":0.0,\"DIFF_METER_SHIP_LITRES_OBS_P\":0.0,\"DIFF_SHORE_SHIP_MT\":0.0,\"DIFF_SHORE_SHIP_MT_P\":0.0,\"DIFF_SHORE_SHIP_LITRES_30\":0,\"DIFF_SHORE_SHIP_LITRES_30_P\":0.0,\"DIFF_SHORE_SHIP_BARREL\":0.0,\"DIFF_SHORE_SHIP_BARREL_P\":0.0,\"DIFF_SHORE_SHIP_LITRES_OBS\":0.0,\"DIFF_SHORE_SHIP_LITRES_OBS_P\":0.0,\"REMARK\":\"Tank\",\"DISTRIBUTION_CHANNEL\":\"10\",\"BL_APPROVE_DATE\":\"0000-00-00\",\"BL_APPROVE_TIME\":\"00:00:00\"},{\"DATE\":\"2021-01-15\",\"JETTY_NO\":\"001\",\"TRIP_NO\":\"TOP_LPG2\",\"VESSEL_NAME\":\"MT BOON TEST001\",\"PRODUCT\":\"YLPG\",\"TANK\":\"3504\",\"CUSTOMER\":\"SHELL\",\"DESTINATION\":\"The Shell Co.Of Thailand Ltd.\",\"PUMP_CODE\":\"P101B\",\"TANK_TEMP_BEFORE\":\"\",\"TANK_TEMP_AFTER\":\"\",\"TANK_DENSITY\":\"\",\"METER_TEMP\":\"\",\"METER_DENSITY\":\"\",\"SHIP_TEMP\":\"\",\"SHIP_DENSITY\":\"\",\"BL_QUANTITY_LITRES_30\":\"\",\"BL_QUANTITY_METRIC_TONS\":\"\",\"BL_QUANTITY_BARREL\":\"\",\"BL_QUANTITY_LITRES_OBS\":\"\",\"QUANTITY_SHORE_LITRES_30\":\"\",\"QUANTITY_SHORE_METRIC_TONS\":\"\",\"QUANTITY_SHORE_BARREL\":\"\",\"QUANTITY_SHORE_LITRES_OBS\":\"\",\"QUANTITY_METER_LITRES_30\":\"\",\"QUANTITY_METER_METRIC_TONS\":\"\",\"QUANTITY_METER_BARREL\":\"\",\"QUANTITY_METER_LITRES_OBS\":\"\",\"QUANTITY_SHIP_LITRES_30\":\"\",\"QUANTITY_SHIP_METRIC_TONS\":\"\",\"QUANTITY_SHIP_BARREL\":\"\",\"QUANTITY_SHIP_LITRES_OBS\":\"\",\"DIFF_METER_SHORE_MT\":\"\",\"DIFF_METER_SHORE_MT_P\":\"\",\"DIFF_METER_SHORE_LITRES_30\":\"\",\"DIFF_METER_SHORE_LITRES_30_P\":\"\",\"DIFF_METER_SHORE_BARREL\":\"\",\"DIFF_METER_SHORE_BARREL_P\":\"\",\"DIFF_METER_SHORE_LITRES_OBS\":\"\",\"DIFF_METER_SHORE_LITRES_OBS_P\":\"\",\"DIFF_METER_SHIP_MT\":\"\",\"DIFF_METER_SHIP_MT_P\":\"\",\"DIFF_METER_SHIP_LITRES_30\":\"\",\"DIFF_METER_SHIP_LITRES_30_P\":\"\",\"DIFF_METER_SHIP_BARREL\":\"\",\"DIFF_METER_SHIP_BARREL_P\":\"\",\"DIFF_METER_SHIP_LITRES_OBS\":\"\",\"DIFF_METER_SHIP_LITRES_OBS_P\":\"\",\"DIFF_SHORE_SHIP_MT\":\"\",\"DIFF_SHORE_SHIP_MT_P\":\"\",\"DIFF_SHORE_SHIP_LITRES_30\":\"\",\"DIFF_SHORE_SHIP_LITRES_30_P\":\"\",\"DIFF_SHORE_SHIP_BARREL\":\"\",\"DIFF_SHORE_SHIP_BARREL_P\":\"\",\"DIFF_SHORE_SHIP_LITRES_OBS\":\"\",\"DIFF_SHORE_SHIP_LITRES_OBS_P\":\"\",\"REMARK\":\"Tank\",\"DISTRIBUTION_CHANNEL\":\"10\",\"BL_APPROVE_DATE\":\"0000-00-00\",\"BL_APPROVE_TIME\":\"00:00:00\"}]}'
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
		C360_ReplicatedSAP_Jetty.dto_response dto = new C360_ReplicatedSAP_Jetty.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/c360/replicated/sap/jetty';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"JLIST\":[{\"DATE\":\"2021-01-15\",\"JETTY_NO\":\"001\",\"TRIP_NO\":\"TOP_LPG2\",\"VESSEL_NAME\":\"MT BOON TEST001\",\"PRODUCT\":\"YLPG\",\"TANK\":\"3504\",\"CUSTOMER\":\"SHELL\",\"DESTINATION\":\"The Shell Co.Of Thailand Ltd.\",\"PUMP_CODE\":\"P101B\",\"TANK_TEMP_BEFORE\":34.75,\"TANK_TEMP_AFTER\":34.75,\"TANK_DENSITY\":0.5601,\"METER_TEMP\":0.0,\"METER_DENSITY\":0.0,\"SHIP_TEMP\":30.0,\"SHIP_DENSITY\":0.0,\"BL_QUANTITY_LITRES_30\":583384,\"BL_QUANTITY_METRIC_TONS\":315.024,\"BL_QUANTITY_BARREL\":3549.0,\"BL_QUANTITY_LITRES_OBS\":593449.0,\"QUANTITY_SHORE_LITRES_30\":583384,\"QUANTITY_SHORE_METRIC_TONS\":315.024,\"QUANTITY_SHORE_BARREL\":3549.0,\"QUANTITY_SHORE_LITRES_OBS\":593449.0,\"QUANTITY_METER_LITRES_30\":0,\"QUANTITY_METER_METRIC_TONS\":0.0,\"QUANTITY_METER_BARREL\":0.0,\"QUANTITY_METER_LITRES_OBS\":0.0,\"QUANTITY_SHIP_LITRES_30\":0,\"QUANTITY_SHIP_METRIC_TONS\":0.0,\"QUANTITY_SHIP_BARREL\":0.0,\"QUANTITY_SHIP_LITRES_OBS\":0.0,\"DIFF_METER_SHORE_MT\":0.0,\"DIFF_METER_SHORE_MT_P\":0.0,\"DIFF_METER_SHORE_LITRES_30\":0,\"DIFF_METER_SHORE_LITRES_30_P\":0.0,\"DIFF_METER_SHORE_BARREL\":0.0,\"DIFF_METER_SHORE_BARREL_P\":0.0,\"DIFF_METER_SHORE_LITRES_OBS\":0.0,\"DIFF_METER_SHORE_LITRES_OBS_P\":0.0,\"DIFF_METER_SHIP_MT\":0.0,\"DIFF_METER_SHIP_MT_P\":0.0,\"DIFF_METER_SHIP_LITRES_30\":0,\"DIFF_METER_SHIP_LITRES_30_P\":0.0,\"DIFF_METER_SHIP_BARREL\":0.0,\"DIFF_METER_SHIP_BARREL_P\":0.0,\"DIFF_METER_SHIP_LITRES_OBS\":0.0,\"DIFF_METER_SHIP_LITRES_OBS_P\":0.0,\"DIFF_SHORE_SHIP_MT\":0.0,\"DIFF_SHORE_SHIP_MT_P\":0.0,\"DIFF_SHORE_SHIP_LITRES_30\":0,\"DIFF_SHORE_SHIP_LITRES_30_P\":0.0,\"DIFF_SHORE_SHIP_BARREL\":0.0,\"DIFF_SHORE_SHIP_BARREL_P\":0.0,\"DIFF_SHORE_SHIP_LITRES_OBS\":0.0,\"DIFF_SHORE_SHIP_LITRES_OBS_P\":0.0,\"REMARK\":\"Tank\",\"DISTRIBUTION_CHANNEL\":\"10\",\"BL_APPROVE_DATE\":\"0000-00-00\",\"BL_APPROVE_TIME\":\"00:00:00\"}]}'
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