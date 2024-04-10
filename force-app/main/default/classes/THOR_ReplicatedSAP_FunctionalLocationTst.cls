@isTest
public class THOR_ReplicatedSAP_FunctionalLocationTst {
    @IsTest
	static void testWebService() {
		Test.startTest();
		THOR_ReplicatedSAP_FunctionalLocation.dto_response dto = new THOR_ReplicatedSAP_FunctionalLocation.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/fl';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{ \"FLLIST\":[{\"FL\":\"TOP-HONEYWELL\",\"DESCRIPTION\":\"HONEYWELL DCS SYSTEM\",\"SUBFL\":\"TOP-DCS-SYSTEM\",\"OBJECTTYPE\":\"UN-DCS\",\"PLANNERGROUP\":\"\",\"PLANNINGPLANT\":\"1200\",\"AUTHORIZEGROUP\":\"ADM\",\"COMPANYCODE\":\"1100\",\"PLANTSECTION\":\"ID1\",\"LOCATION\":\"02500\",\"MAINWORKCENTER\":\"\",\"MAINTENANCEPLANT\":\"1200\",\"SYSTEMSTATUS\":\"CRTE\",\"USERSTATUS\":\"\",\"COSTCENTER\":\"113047\",\"WBSELEMENT\":\"\",\"CATELOGPROFILE\":\"\",\"MAINWORKCENTERPLANT\":\"\"}]}'
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