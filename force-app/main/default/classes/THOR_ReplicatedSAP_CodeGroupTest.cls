@isTest
public class THOR_ReplicatedSAP_CodeGroupTest {
	@IsTest
	static void testWebService() {
		Test.startTest();
		Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

		THOR_ReplicatedSAP_CodeGroup.dto_response dto = new THOR_ReplicatedSAP_CodeGroup.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/codegroup';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"CGLIST\":[{\"CODEGROUP\":\"IED-001\",\"CODE\":\"I-BL\",\"DESCRIPTION\":\"Blockage/Plugged.\",\"CATALOG\":\"C\",\"CODEGROUPDESC\":\"AIR FILTER REGULATOR\"},{\"CODEGROUP\":\"IEC-167\",\"CODE\":\"I-WI\",\"DESCRIPTION\":\"Water ingress\",\"CATALOG\":\"5\",\"CODEGROUPDESC\":\"TOC ANALYZER\"},{\"CODEGROUP\":\"IEA-132\",\"CODE\":\"I-AD\",\"DESCRIPTION\":\"Adjustment\",\"CATALOG\":\"A\",\"CODEGROUPDESC\":\"GAS CHROMATOGRAPHY ANALYZER\"},{\"CODEGROUP\":\"ELEC-MOT\",\"CODE\":\"EM01\",\"DESCRIPTION\":\"01-Inspection found sign of abnormal\",\"CATALOG\":\"B\",\"CODEGROUPDESC\":\"Electrical Motor Move to EE/WS\"},{\"CODEGROUP\":\"IED-021\",\"CODE\":\"I-BK\",\"DESCRIPTION\":\"Broken Part / Crack\",\"CATALOG\":\"C\",\"CODEGROUPDESC\":\"CORIOLIS TRANSMITTER\"}]}'
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

		//THOR_ReplicatedSAP_CodeGroup.dto_response dto = new THOR_ReplicatedSAP_CodeGroup.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/codegroup';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"CGLIST\":[{\"CODEGROUP\":\"IED-001\",\"CODE\":\"I-BL\",\"DESCRIPTION\":\"Blockage/Plugged.\",\"CATALOG\":\"C\",\"CODEGROUPDESC\":\"AIR FILTER REGULATOR\"},{\"CODEGROUP\":\"IEC-167\",\"CODE\":\"I-WI\",\"DESCRIPTION\":\"Water ingress\",\"CATALOG\":\"5\",\"CODEGROUPDESC\":\"TOC ANALYZER\"},{\"CODEGROUP\":\"IEA-132\",\"CODE\":\"I-AD\",\"DESCRIPTION\":\"Adjustment\",\"CATALOG\":\"A\",\"CODEGROUPDESC\":\"GAS CHROMATOGRAPHY ANALYZER\"},{\"CODEGROUP\":\"ELEC-MOT\",\"CODE\":\"EM01\",\"DESCRIPTION\":\"01-Inspection found sign of abnormal\",\"CATALOG\":\"B\",\"CODEGROUPDESC\":\"Electrical Motor Move to EE/WS\"},{\"CODEGROUP\":\"IED-021\",\"CODE\":\"I-BK\",\"DESCRIPTION\":\"Broken Part / Crack\",\"CATALOG\":\"C\",\"CODEGROUPDESC\":\"CORIOLIS TRANSMITTER\"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		THOR_ReplicatedSAPWebServices.httpPostWebservice();

		uuidTxt = Uuid.randomUUID();
		req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/codegroup';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"CGLIST\":[{\"CODEGROUP\":\"IED-001\",\"CODE\":\"I-BL\",\"DESCRIPTION\":\"Blockage/Plugged.\",\"CATALOG\":\"C\",\"CODEGROUPDESC\":\"AIR FILTER REGULATOR\"},{\"CODEGROUP\":\"IEC-167\",\"CODE\":\"I-WI\",\"DESCRIPTION\":\"Water ingress\",\"CATALOG\":\"5\",\"CODEGROUPDESC\":\"TOC ANALYZER\"},{\"CODEGROUP\":\"IEA-132\",\"CODE\":\"I-AD\",\"DESCRIPTION\":\"Adjustment\",\"CATALOG\":\"A\",\"CODEGROUPDESC\":\"GAS CHROMATOGRAPHY ANALYZER\"},{\"CODEGROUP\":\"ELEC-MOT\",\"CODE\":\"EM01\",\"DESCRIPTION\":\"01-Inspection found sign of abnormal\",\"CATALOG\":\"B\",\"CODEGROUPDESC\":\"Electrical Motor Move to EE/WS\"},{\"CODEGROUP\":\"IED-021\",\"CODE\":\"I-BK\",\"DESCRIPTION\":\"Broken Part / Crack\",\"CATALOG\":\"C\",\"CODEGROUPDESC\":\"CORIOLIS TRANSMITTER\"}]}'
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