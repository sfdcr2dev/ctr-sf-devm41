@isTest
public class THOR_ReplicatedSAP_OperationTest {
    @IsTest
	static void testWebService() {
		Test.startTest();
		THOR_ReplicatedSAP_Operation.dto_response dto = new THOR_ReplicatedSAP_Operation.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/operation';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"OPLIST\":[{\"TASKLISTTYPE\":\"A\",\"TGROUP\":\"EMOT0001\",\"GROUPCOUNT\":\"00000003\",\"SUPERIOROPNODE\":\"00000000\",\"OPERATION\":\"0010\",\"DESCRIPTION\":\"To inspect air cooler#2\",\"CONTROLKEY\":\"PM01\",\"WORKCENTER\":\"ENMA-E\",\"PLANT\":\"1200\"}]}'
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