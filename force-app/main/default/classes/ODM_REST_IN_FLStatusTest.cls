@isTest
public class ODM_REST_IN_FLStatusTest {
   
    @IsTest
	static void testWebService() {
		Test.startTest();
		//ODM_REST_IN_FLStatus.ResponseWrapper response = new ODM_REST_IN_FLStatus.ResponseWrapper();

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/ODM_REST_IN_FLStatus';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{ \"tags\": [ {\"tagId\":\"TOC4-U2100-INSP-LS-P2121-04\", \"tagName\":\"P-2121_21PG-055\", \"description\":\"Discharge Pressure\", \"groupName\":\"U-2100 CDU 3 Plant Round\", \"flId\":\"\", \"mainWorkCenter\":\"OPS-TOC4\", \"value\":\"0\", \"engUnit\":\"Barg\", \"timestamp\":\"2022-02-18 19:36:17\", \"status\":0}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		ODM_REST_IN_FLStatus.doPost();
		Test.stopTest();
	}

	@IsTest
	static void testWebServiceCatch() {
		Test.startTest();
		//ODM_REST_IN_FLStatus.ResponseWrapper response = new ODM_REST_IN_FLStatus.ResponseWrapper();

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/ODM_REST_IN_FLStatus';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{ \"tags\": [ { {\"tagId\":\"TOC4-U2100-INSP-LS-P2121-04\", \"tagName\":\"P-2121_21PG-055\", \"description\":\"Discharge Pressure\", \"groupName\":\"U-2100 CDU 3 Plant Round\", \"flId\":\"\", \"mainWorkCenter\":\"OPS-TOC4\", \"value\":\"0\", \"engUnit\":\"Barg\", \"timestamp\":\"2022-02-18 19:36:17\", \"status\":0}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		ODM_REST_IN_FLStatus.doPost();
		Test.stopTest();
	}
    
	@IsTest
	static void testWebServiceCatch2() {
		Test.startTest();
		//ODM_REST_IN_FLStatus.ResponseWrapper response = new ODM_REST_IN_FLStatus.ResponseWrapper();

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/ODM_REST_IN_FLStatus';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{ \"no tags\": [ {\"tagId\":\"TOC4-U2100-INSP-LS-P2121-04\", \"tagName\":\"P-2121_21PG-055\", \"description\":\"Discharge Pressure\", \"groupName\":\"U-2100 CDU 3 Plant Round\", \"flId\":\"\", \"mainWorkCenter\":\"OPS-TOC4\", \"value\":\"0\", \"engUnit\":\"Barg\", \"timestamp\":\"2022-02-18 19:36:17\", \"status\":0}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		ODM_REST_IN_FLStatus.doPost();
		Test.stopTest();
	}
}