@isTest
public class THOR_ReplicatedSAP_EquipmentTest {
	@IsTest
	static void testWebService() {
		Test.startTest();
		THOR_ReplicatedSAP_Equipment.dto_response dto = new THOR_ReplicatedSAP_Equipment.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/equipment';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"EQLIST\":[{\"EQUIPMENTCATEGORY\":\"1\",\"EQUIPMENTNO\":\"10000001\",\"DESCRIPTION\":\"Test for calibration\",\"SYSTEMSTATUS\":\"INST\",\"USERSTATUS\":\"BOMR\",\"FL\":\"18-FRCA-517-TX100\",\"OBJECTTYPE\":\"DUMMY\",\"LOCATION\":\"02250\",\"MANUFACTURER\":\"MANU-UPDATED_TAG\",\"MANUFACTURERNO\":\"SER-UPDATED_TAG\",\"MODELNO\":\"MOD-UPDATED_TAG\",\"ABCINDICATOR\":\"H\",\"COSTCENTER\":\"113053\",\"MAINWORKCENTER\":\"ELEC-WS\",\"MAINTENANCEPLANT\":\"1200\",\"COMPANYCODE\":\"1100\",\"PLANTSECTION\":\"T2\",\"PLANNERGROUP\":\"EAA\",\"PLANNINGPLANT\":\"1200\",\"CATELOGPROFILE\":\"\",\"SORTFIELD\":\"TEST\",\"ASSET\":\"\",\"SUBNUMBER\": \"\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		THOR_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
}