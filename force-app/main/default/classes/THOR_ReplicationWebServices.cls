@RestResource(urlMapping='/THOR_Replicated/*')
global with sharing class THOR_ReplicationWebServices extends WebServiceExtend {

    @HttpPost
	global static dto_response httpPostWebservice() {
        Map<String, String> requestHeader = RestContext.request.headers;
		RestRequest request = RestContext.request;
		String requestBody = request.requestBody.toString();
		String interfaceName = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);

		Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

		if (interfaceName.equalsIgnoreCase('safetypermit')) {
			/**
			 * @path /replicated/safetypermit
			 * @description Safety Permit Replication through API Gateway
			 */
            THOR_Replication_SafetyPermit.dto_response dto_result = THOR_Replication_SafetyPermit.execute(body, request);

			return dto_result;
        }

        return THOR_Replication_SafetyPermit.parse(
			JSON.serialize(
				new Map<String, Object>{
					'returnvalue' => new List<Object>()
				}
			)
		);
    }
}