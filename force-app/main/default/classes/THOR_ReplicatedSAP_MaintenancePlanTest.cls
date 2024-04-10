@isTest
public class THOR_ReplicatedSAP_MaintenancePlanTest {
    @IsTest
	static void testWebService() {
		Test.startTest();
		THOR_ReplicatedSAP_MaintenancePlan.dto_response dto = new THOR_ReplicatedSAP_MaintenancePlan.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/maintenanceplan';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"MPLIST\":[{\"CATEGORY\":\"PM\",\"MAINTENANCEPLANTNO\":\"E-BA1A10\",\"DESCRIPTION\":\"Test ZPMR0006#SF\",\"STRATEGY\":\"ELEC-T\",\"FACTORY\":\"TC\",\"AUTHORIZEGROUP\":\"E12S\",\"NOITEM\":\"0002\",\"CALLNUMBER\":\"181\",\"SCHEDULEDPERIOD\":\"010\",\"SCHEDULEDUNIT\":\"YR\",\"SYSTEMSTATUS\":\"CRTD\",\"CYCLESTART\":\"2011-01-09\"}]}'
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