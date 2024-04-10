@isTest
public class THOR_ReplicatedSAP_MaintenanceItemTest {
    @IsTest
	static void testWebService() {
		Test.startTest();
		THOR_ReplicatedSAP_MaintenanceItem.dto_response dto = new THOR_ReplicatedSAP_MaintenanceItem.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/maintenanceitem';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"MILIST\":[{\"MAINTENANCEPLANT\":\"EMOT00000006\",\"ITEMNO\":\"0001\",\"MAINTENANCEITEM\":\"101\",\"TEXT\":\"Inspec\",\"STRATEGY\":\"TMS01\",\"FL\":\"11LG1104\",\"EQUIPMENT\":\"\",\"PLANNINGPLANT\":\"1200\",\"ORDERTYPE\":\"PM01\",\"PLANNERGROUP\":\"MAA\",\"MAINTENANCEACTIVITYTYPE\":\"M01\",\"MAINWORKCENTER\":\"ENMA-M\",\"TASKLISTTYPE\":\"A\",\"TGROUP\":\"EMOT0001\",\"GROUPCOUNT\":\"1\"}]}'
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