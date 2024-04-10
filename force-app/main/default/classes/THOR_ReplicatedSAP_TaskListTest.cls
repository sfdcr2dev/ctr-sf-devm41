@isTest
public class THOR_ReplicatedSAP_TaskListTest {
    @IsTest
	static void testWebService() {
		Test.startTest();
		THOR_ReplicatedSAP_TaskList.dto_response dto = new THOR_ReplicatedSAP_TaskList.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/tasklist';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"TLLIST\":[{\"TASKLISTTYPE\":\"A\",\"TGROUP\":\"MTEST01 \",\"GROUPCOUNT\":\"6 \",\"DESCRIPTION\":\"TOP INSP Piping Mixing point Loop02Y3#SF\",\"FL\":\"\",\"WORKCENTER\":\"INSP-GEN\",\"PLANT\":\"1200\",\"PLANNERGROUP\":\"SIN\",\"STRATEGY\":\"MS03\",\"USAGE\":\"4\",\"STATUS\":\"4\",\"CHANGEON\":\"2020-10-01\"}]}'
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

	@IsTest
	static void testWebServiceParseError() {
		Test.startTest();
		THOR_ReplicatedSAP_TaskList.dto_response dto = new THOR_ReplicatedSAP_TaskList.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/tasklist';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"TASKLIST\":[{\"TASKLISTTYPE\":\"A\",\"TGROUP\":\"MTEST01 \",\"GROUPCOUNT\":\"6 \",\"DESCRIPTION\":\"TOP INSP Piping Mixing point Loop02Y3#SF\",\"FL\":\"\",\"WORKCENTER\":\"INSP-GEN\",\"PLANT\":\"1200\",\"PLANNERGROUP\":\"SIN\",\"STRATEGY\":\"MS03\",\"USAGE\":\"4\",\"STATUS\":\"4\",\"CHANGEON\":\"2020-10-01\"}]}'
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