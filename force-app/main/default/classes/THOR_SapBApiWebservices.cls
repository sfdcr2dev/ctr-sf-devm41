@RestResource(urlMapping='/bapi/*')
global with sharing class THOR_SapBApiWebservices extends WebserviceExtend {
	// global enum SERVICENAME {
	//     ZPI_BAPI_ALM_NOTIF_CREATE,
	// 	LOG
	// }

	global class Description extends WebServiceExtend.Description {
		global String linkurl { get; set; }
	}

	// global class dto_response extends WebServiceExtend.dto_response {
	// 	global Description description { get; set; }
	// }

	// global static dto_response parse(String json) {
	// 	return (dto_response) System.JSON.deserialize(json, dto_response.class);
	// }

	@HttpPost
	global static dto_response httpPostWebservice() {
		Map<String, String> requestHeader = RestContext.request.headers;
		RestRequest request = RestContext.request;
		String requestBody = request.requestBody.toString();
		String interfaceName = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);

		System.debug(System.LoggingLevel.DEBUG, request.requestURI);
		System.debug(System.LoggingLevel.DEBUG, MethodUtils.serializePrettyString(requestBody));

		Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

		if (interfaceName.equalsIgnoreCase('LOG')) {
			/**
			 * @path /bapi/LOG
			 * @description iRPA Cloud
			 */
			return iRPALogResponse(request.requestURI, result);
		} else if (interfaceName.equalsIgnoreCase('ZPI_BAPI_ALM_NOTIF_CREATE')) {
			/**
			 * @path /bapi/ZPI_BAPI_ALM_NOTIF_CREATE
			 */
			return THOR_BApiNotificaionHelper.execute(request.requestURI, result);
		} else if (interfaceName.equalsIgnoreCase('ZPI_BAPI_ALM_ORDER_CREATE')) {
			/**
			 * @path /bapi/ZPI_BAPI_ALM_ORDER_CREATE
			 */
			return THOR_BApiOrderHelper.execute(request.requestURI, result);
		} else if (interfaceName.equalsIgnoreCase('ZPM_BAPI_COMPONENT')) {
			/**
			 * @path /bapi/ZPM_BAPI_COMPONENT
			 */
			return THOR_BApiComponentHelper.execute(request.requestURI, result);
		} else if (interfaceName.equalsIgnoreCase('ZPM_CREATE_CC_NOTIF')
			|| interfaceName.equalsIgnoreCase('ZPM_CREATE_CC_ORDER')
			|| interfaceName.equalsIgnoreCase('ZPM_UPDATE_CC')) {
			/**
			 * @path /bapi/ZPM_CREATE_CC_NOTIF
			 * @path /bapi/ZPM_CREATE_CC_ORDER
			 * @path /bapi/ZPM_UPDATE_CC
			 */
			return THOR_BApiWorkClearanceHelper.execute(request.requestURI, result);
		} else if (interfaceName.equalsIgnoreCase('ZPI_BAPI_ALM_ITEM_CREATE')) {
			/**
			 * @path /bapi/ZPI_BAPI_ALM_ITEM_CREATE
			 */
			return THOR_BApiItemHelper.execute(request.requestURI, result);
		} else if (interfaceName.equalsIgnoreCase('ZIPM0021')) {
			/**
			 * @path /bapi/ZIPM0021
			 */
			return THOR_BApiNotificaionFileHelper.execute(request.requestURI, result);
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
	private static dto_response iRPALogResponse(String source, Map<String, Object> result) {
		Application_Log__c applog = new Application_Log__c(
			Integration_Name__c = 'iRPALogResponse',
			External_ID__c = String.valueOf(result.get('uuid')),
			iRPA_Response_Body__c = JSON.serialize(result)
		);

		Id logId;
		if (applog.External_ID__c != null) {
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