@isTest
public class THOR_ReplicatedSAP_CatelogProfileTest {
	@IsTest
	static void testWebService() {
		Test.startTest();
		Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

		THOR_ReplicatedSAP_CatelogProfile.dto_response dto = new THOR_ReplicatedSAP_CatelogProfile.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/catelogprofile';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"CPLIST\":[{\"CATALOGPROFILE\":\"IEP-000\",\"CODEGROUP\":\"IEF-000\",\"CATALOG\":\"D\",\"CATALOGDESC\":\"ALL EQ. INST-DUMMY.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IEC-001\",\"CATALOG\":\"5\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IEA-001\",\"CATALOG\":\"A\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IEO-001\",\"CATALOG\":\"B\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IED-001\",\"CATALOG\":\"C\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"}]}'
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
	static void testWebServiceUpdate() {
		Test.startTest();
		Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

		//THOR_ReplicatedSAP_CatelogProfile.dto_response dto = new THOR_ReplicatedSAP_CatelogProfile.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/catelogprofile';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"CPLIST\":[{\"CATALOGPROFILE\":\"IEP-000\",\"CODEGROUP\":\"IEF-000\",\"CATALOG\":\"D\",\"CATALOGDESC\":\"ALL EQ. INST-DUMMY.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IEC-001\",\"CATALOG\":\"5\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IEA-001\",\"CATALOG\":\"A\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IEO-001\",\"CATALOG\":\"B\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IED-001\",\"CATALOG\":\"C\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		THOR_ReplicatedSAPWebServices.httpPostWebservice();

		uuidTxt = Uuid.randomUUID();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/catelogprofile';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"CPLIST\":[{\"CATALOGPROFILE\":\"IEP-000\",\"CODEGROUP\":\"IEF-000\",\"CATALOG\":\"D\",\"CATALOGDESC\":\"ALL EQ. INST-DUMMY.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IEC-001\",\"CATALOG\":\"5\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IEA-001\",\"CATALOG\":\"A\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IEO-001\",\"CATALOG\":\"B\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"},{\"CATALOGPROFILE\":\"IEP-001\",\"CODEGROUP\":\"IED-001\",\"CATALOG\":\"C\",\"CATALOGDESC\":\"AIR FILTER REGULATOR.\"}]}'
				}
			)
		);
		RestContext.request = req;

		res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		THOR_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
}