@RestResource(urlMapping='/api/replicated/sap/*')
global with sharing class THOR_ReplicatedSAPWebServices extends WebserviceExtend {
	@HttpPost
	global static dto_response httpPostWebservice() {
		Map<String, String> requestHeader = RestContext.request.headers;
		RestRequest request = RestContext.request;
		String requestBody = request.requestBody.toString();
		String interfaceName = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);

		Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

		if (
			/**
			 * @path /api/replicated/sap/safetypermit
			 * @description This is pull information Safety Permit Service
			 */
			interfaceName.equalsIgnoreCase('safetypermit')
		) {
			return THOR_Replication_SafetyPermit.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/bom
			 * @description This is pull information BOM Service
			 */
			interfaceName.equalsIgnoreCase('bom')
		) {
			return THOR_ReplicatedSAP_BOM.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/bomwithsparepart
			 * @description This is pull information BOM Service
			 */
			interfaceName.equalsIgnoreCase('bomwithsparepart')
		) {
			return THOR_ReplicatedSAP_BOMWithSparePart.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/catelogprofile
			 * @description This is pull information Catelog Profile with Code Group Service
			 */
			interfaceName.equalsIgnoreCase('catelogprofile')
		) {
			return THOR_ReplicatedSAP_CatelogProfile.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/codegroup
			 * @description This is pull information Code Group with Code Service
			 */
			interfaceName.equalsIgnoreCase('codegroup')
		) {
			return THOR_ReplicatedSAP_CodeGroup.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/fl
			 * @description This is pull information Functional Location Service
			 */
			interfaceName.equalsIgnoreCase('fl')
		) {
			return THOR_ReplicatedSAP_FunctionalLocation.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/equipment
			 * @description This is pull information Equipment Service
			 */
			interfaceName.equalsIgnoreCase('equipment')
		) {
			return THOR_ReplicatedSAP_Equipment.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/notification
			 * @description This is pull information Notification Service
			 */
			interfaceName.equalsIgnoreCase('notification')
		) {
			return THOR_ReplicatedSAP_Notification.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/order
			 * @description This is pull Order Service
			 */
			interfaceName.equalsIgnoreCase('order')
		) {
			return THOR_ReplicatedSAP_Order.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/workclearance
			 * @description This is pull Work Clearance Service
			 */
			interfaceName.equalsIgnoreCase('workclearance')
		) {
			return THOR_ReplicatedSAP_WorkClearance.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/maintenanceplan
			 * @description This is pull Maintenance Plan Service
			 */
			interfaceName.equalsIgnoreCase('maintenanceplan')
		) {
			return THOR_ReplicatedSAP_MaintenancePlan.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/maintenanceitem
			 * @description This is pull Maintenance Item Service
			 */
			interfaceName.equalsIgnoreCase('maintenanceitem')
		) {
			return THOR_ReplicatedSAP_MaintenanceItem.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/tasklist
			 * @description This is pull Task List Service
			 */
			interfaceName.equalsIgnoreCase('tasklist')
		) {
			return THOR_ReplicatedSAP_TaskList.execute(body, request);
		} else if (
			/**
			 * @path /api/replicated/sap/operation
			 * @description This is pull Operation Service
			 */
			interfaceName.equalsIgnoreCase('operation')
		) {
			return THOR_ReplicatedSAP_Operation.execute(body, request);
		}

		String gatewayId = body.containsKey('gateway_id') ? String.valueOf(body.get('gateway_id')) : null;
		String requestBodyParse = body.containsKey('body') ? String.valueOf(body.get('body')) : null;
		String responseBodyParse = JSON.serialize(
			new Map<String, Object>{
				'description' => new Map<String, Object>{
					'success' => false,
					'message' => String.format('{0}: Not found method', new List<String>{ request.requestURI }),
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
				Error_Message__c = String.format('{0}: Not found method', new List<String>{ request.requestURI }),
				Request_Body__c = JSON.serialize(requestBodyParse),
				Response_Body__c = responseBodyParse
			)
		);
		return dto_response.parse(responseBodyParse);
	}
}