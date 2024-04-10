@RestResource(urlMapping='/C360bapi/*')
global with sharing class C360_SapBApiWebservices extends WebserviceExtend {
	global class Description extends WebServiceExtend.Description {
		global String linkurl { get; set; }
	}

	@HttpPost
	global static dto_response httpPostWebservice() {
		Map<String, String> requestHeader = RestContext.request.headers;
		RestRequest request = RestContext.request;
		String requestBody = request.requestBody.toString();
		String interfaceName = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
		Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
		if (interfaceName.equalsIgnoreCase('LOG')) {
			/*** @path /bapi/LOG
			 * @description iRPA Cloud*/
			return iRPALogResponse(request.requestURI, result);
		} else if (interfaceName.equalsIgnoreCase('BAPI_FINANCIAL_INFO')) {
			/*** @path /bapi/ZPI_BAPI_ALM_NOTIF_CREATE*/
			return C360_BApiFinancialInfoHelper.execute(request.requestURI, result);
		}
		return dto_response.parse(
			JSON.serialize(
				new Map<String, Object>{
					'description' => new Map<String, Object>{
						'success' => false,
						'message' => String.format('{0}: Not found method', new List<String>{ request.requestURI })
					},
					'result' => new Map<String, Object>{ 'data' => new List<Object>() }
				}
			)
		);
	}
	// SAP send log to Salesfroce server
	private static dto_response iRPALogResponse(String source, Map<String, Object> result){
		Application_Log__c applog = new Application_Log__c(
			Integration_Name__c = 'iRPALogResponse',
			External_ID__c = String.valueOf(result.get('uuid')),
			iRPA_Response_Body__c = JSON.serialize(result)
		);

		Id logId;
		if(applog.External_ID__c != null){
			logId = ApplicationLogUtils.saveLogInbound(source, applog);
		}
		String linkurl = logId != null ? String.format('{0}/{1}', new List<String>{ URL.getSalesforceBaseUrl().toExternalForm(), logId }) : null;
		return dto_response.parse(
			JSON.serialize(
				new Map<String, Object>{
					'description' => new Map<String, Object>{
						'success' => logId != null,
						'message' => logId != null ? '' : 'jobUid not found',
						'linkurl' => linkurl
					}
				}
			)
		);
	}
}