@RestResource(urlMapping='/api/c360/replicated/sap/*')
global with sharing class C360_ReplicatedSAPWebServices extends WebserviceExtend {
	@HttpPost
	global static dto_response httpPostWebservice() {
		Map<String, String> requestHeader = RestContext.request.headers;
		RestRequest request = RestContext.request;
		String requestBody = request.requestBody.toString();
		String interfaceName = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
		Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
		if(interfaceName.equalsIgnoreCase('bankguarantees')){
			return C360_ReplicatedSAP_Bankguarantees.execute(body, request);
		}else if( interfaceName.equalsIgnoreCase('overdue')){
			return C360_ReplicatedSAP_Overdue.execute(body, request);
		}else if(interfaceName.equalsIgnoreCase('buyingdaily')){
			return C360_ReplicatedSAP_BuyingDaily.execute(body, request);
		}else if (interfaceName.equalsIgnoreCase('jetty')){
			return C360_ReplicatedSAP_Jetty.execute(body, request);
		}else if (interfaceName.equalsIgnoreCase('pipe')){
			return C360_ReplicatedSAP_Pipe.execute(body, request);
		}else if (interfaceName.equalsIgnoreCase('cca')){
			return C360_ReplicatedSAP_CCA.execute(body, request);
		}
		String gatewayId = body.containsKey('gateway_id') ? String.valueOf(body.get('gateway_id')) : null;
		String requestBodyParse = body.containsKey('body') ? String.valueOf(body.get('body')) : null;
		String responseBodyParse = JSON.serialize(
			new Map<String, Object>{
				'description' => new Map<String, Object>{
					'success' => false,
					'message' => String.format('{0}: Not found method', new List<String>{request.requestURI}),
					'linkurl' => gatewayId
				},
				'result' => new Map<String, Object>{ 'data' => new List<Object>() }
			}
		);
		ApplicationLogUtils.saveLogInbound(
			request.requestURI,
			new Application_Log__c(
				Integration_Name__c = interfaceName,
				External_ID__c = gatewayId,
				Message_Type__c = 'Fail',
				Error_Message__c = String.format('{0}: Not found method', new List<String>{request.requestURI}),
				Request_Body__c = JSON.serialize(requestBodyParse),
				Response_Body__c = responseBodyParse
			)
		);
		return dto_response.parse(responseBodyParse);
	}
}