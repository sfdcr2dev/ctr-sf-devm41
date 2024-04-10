/**
 * @description       :
 * @author            : narathip.s@roundtwosolutions.com
 * @group             :
 * @last modified on  : 04-04-2022
 * @last modified by  : narathip.s@roundtwosolutions.com
**/
@isTest
public class THOR_ReplicatedSAP_BOMTest {
	@IsTest
	static void testWebService() {
		Test.startTest();
		THOR_ReplicatedSAP_BOM.dto_response dto = new THOR_ReplicatedSAP_BOM.dto_response();
		List<String> recordIds = dto.recordIds;
		Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/bom';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"BOMLIST\":[{\"BOMNO\":\"00000060\",\"EQUIPMENT\":\"20000005          \",\"PLANT\":\"1200\",\"BOMUSAGE\":\"4\",\"ALTERNATEBOM\":\"1 \",\"BOMCATEGORY\":\"E\"},{\"BOMNO\":\"00000061\",\"EQUIPMENT\":\"20000005          \",\"PLANT\":\"2200\",\"BOMUSAGE\":\"4\",\"ALTERNATEBOM\":\"1 \",\"BOMCATEGORY\":\"E\"}]}'
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