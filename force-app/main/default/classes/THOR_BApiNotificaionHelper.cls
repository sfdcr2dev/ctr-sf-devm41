public with sharing class THOR_BApiNotificaionHelper {
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
			Integration_Name__c = 'ZPI_BAPI_ALM_NOTIF_CREATE',
			Method__c = 'Create',
			// Log_Type__c = 'Inbound from ' + endpoint,
			Message_Type__c = 'Success',
			// Error_Message__c
			// Request_Body__c
			SAP_Response_Body__c = JSON.serialize(result)
		);

		try {
			Notification__c iNotification = (Notification__c) JSON.deserialize(
				JSON.serialize(MethodUtils.getResult('Notification__c', result)).replace('"NaN-NaN-NaN"', 'null'),
				Notification__c.class
			);
			Map<String, Object> iNotificationTemp = new Map<String, Object>(iNotification.getPopulatedFieldsAsMap());
			if (
				iNotificationTemp.containsKey('Notification_Number__c') &&
				String.isEmpty(String.valueOf(iNotificationTemp.get('Notification_Number__c')))
			) {
				iNotificationTemp.remove('Notification_Number__c');
			}
			if (
				iNotificationTemp.containsKey('Required_Start__c') && iNotificationTemp.get('Required_Start__c') == null
			) {
				iNotificationTemp.remove('Required_Start__c');
			}
			if (iNotificationTemp.containsKey('Required_End__c') && iNotificationTemp.get('Required_End__c') == null) {
				iNotificationTemp.remove('Required_End__c');
			}
			if (
				String.isEmpty(iNotification.Integration_Status__c) ||
				!iNotification.Integration_Status__c?.equalsIgnoreCase('Success')
			) {
				iNotification.Integration_Status__c = 'Failed';
			}
			iNotification = (Notification__c) JSON.deserialize(
				JSON.serialize(iNotificationTemp),
				Notification__c.class
			);

			Date d = Date.newInstance(1900, 01, 01);
			if (iNotification.Required_Start__c < d) {
				iNotification.Required_Start__c = null;
			}
			if (iNotification.Required_End__c < d) {
				iNotification.Required_End__c = null;
			}

			System.debug(iNotification);
			if (iNotification != null) {
				String historyText = [SELECT Id, History_Detail__c FROM Notification__c WHERE Id = :iNotification.Id]
				?.History_Detail__c;

				if (iNotification.Integration_Status__c?.equalsIgnoreCase('Success')) {
					iNotification.Notification_Number__c = iNotification.Notification_Number__c
						?.replaceFirst('^0+', '');
					iNotification.Name = iNotification.Notification_Number__c;

					if (iNotification.System_Status_Text__c.containsIgnoreCase('NOCO')) {
						iNotification.Notification_Status__c = 'Closed';
					}
					if (historyText != null && historyText.contains('* ')) {
						iNotification.History_Detail__c = historyText.replace('* ', '');
					}
				}
				iNotification.isIRPA__c = false;
				iNotification.isSOAP__c = false;
				update iNotification;
				// applog.Message_Type__c = iNotification.Integration_Status__c?.equalsIgnoreCase('Success') ? 'Success' : 'Fail';
			}
			ApplicationLogUtils.saveLogInbound(endpoint, applog);

			String linkurl = iNotification != null
				? String.format(
						'{0}/{1}',
						new List<String>{
							URL.getSalesforceBaseUrl().toExternalForm(),
							'lightning/cmp/c__THOR_NotificationRecordDisplay?c__recordId=' + iNotification.Id
						}
				  )
				: '';

			responseDTO = dto_response.parse(
				JSON.serialize(
					new Map<String, Object>{
						'description' => new Map<String, Object>{
							'success' => iNotification != null,
							'message' => iNotification != null ? '' : 'Not found Notification Information',
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
			applog.Error_Message__c = e.getDmlMessage(0);
			applog.SAP_Response_Body__c = JSON.serialize(result);
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
			applog.Error_Message__c = e.getMessage();
			applog.SAP_Response_Body__c = JSON.serialize(result);
			ApplicationLogUtils.saveLogInbound(endpoint, applog);
		}

		return responseDTO;
	}
}