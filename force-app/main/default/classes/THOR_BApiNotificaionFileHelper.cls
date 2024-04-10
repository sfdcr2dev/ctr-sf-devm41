public with sharing class THOR_BApiNotificaionFileHelper {
	public class Result {
		// public String linkurl { get; set; }
	}

	public class dto_response extends WebServiceExtend.dto_response {
		public Result result { get; set; }
	}

	public static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}
	// Integrate the Create Notification
	public static dto_response execute(String endpoint, Map<String, Object> result) {
		dto_response responseDTO = new dto_response();
		Application_Log__c applog = new Application_Log__c(
			External_ID__c = String.valueOf(result.get('uuid')),
			Integration_Name__c = 'ZIPM0021',
			Method__c = 'Create',
			// Log_Type__c = 'Inbound from ' + endpoint,
			// Message_Type__c =
			// Error_Message__c
			// Request_Body__c
			SAP_Response_Body__c = JSON.serialize(result)
		);

		try {
			Notification_File__c iNotificationFile = (Notification_File__c) JSON.deserialize(
				JSON.serialize(MethodUtils.getResult('Notification_File__c', result)),
				Notification_File__c.class
			);
			System.debug(iNotificationFile);
			if (iNotificationFile != null) {
				if (String.valueOf(iNotificationFile.get('Integration_Message__c'))?.containsIgnoreCase('Delete Success')) {
					List<String> fileIds = new List<String>();
					for (Notification_File__c nf : [SELECT File_Id__c FROM Notification_File__c WHERE SAP_File_Id__c = :iNotificationFile.SAP_File_Id__c]) {
						fileIds.add(nf.File_Id__c);
					}
					if (fileIds.size() > 0) {
						delete [SELECT Id FROM ContentDocument WHERE Id IN :fileIds];
					}
				} else {
					update iNotificationFile;
				}

				applog.Message_Type__c = iNotificationFile.Integration_Status__c?.equalsIgnoreCase('Success') ? 'Success' : 'Fail';
			}
			ApplicationLogUtils.saveLogInbound(endpoint, applog);

			String linkurl = iNotificationFile != null && result.containsKey('notification_id')
				? String.format(
						'{0}/{1}',
						new List<String>{
							URL.getSalesforceBaseUrl().toExternalForm(),
							'lightning/cmp/c__THOR_NotificationRelatedFiles?c__notificationId=' + result.get('notification_id')
						}
				  )
				: '';

			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{
							'success' => iNotificationFile != null,
							'message' => iNotificationFile != null ? '' : 'Not found Notification Information',
							'linkurl' => linkurl
						},
						'result' => new Map<String, Object>{}
					}
				)
			);
		} catch (DmlException e) {
			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{ 'success' => false, 'message' => e.getDmlMessage(0) },
						'result' => new Map<String, Object>{ 'data' => new List<Object>() }
					}
				)
			);
			applog.Message_Type__c = 'Fail';
			applog.Error_Message__c = String.format('{0}\r\n{1}', new List<String>{ e.getDmlMessage(0), e.getStackTraceString() });
			ApplicationLogUtils.saveLogInbound(endpoint, applog);
		} catch (Exception e) {
			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{ 'success' => false, 'message' => e.getMessage() },
						'result' => new Map<String, Object>{ 'data' => new List<Object>() }
					}
				)
			);
			applog.Message_Type__c = 'Fail';
			applog.Error_Message__c = String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() });
			applog.SAP_Response_Body__c = JSON.serialize(result);
			ApplicationLogUtils.saveLogInbound(endpoint, applog);
		}

		return responseDTO;
	}
}