public with sharing class THOR_iRPAIntegration_NotificationFile extends MethodUtils {
	// Notification Files
	public static void sendNotificationFilesToSAP(List<Notification_File__c> noti_files, String flag) {
		if (!(new List<String>{ 'created', 'deleted' }.contains(flag.toLowerCase()))) {
			return;
		}

		System.debug(JSON.serializePretty(noti_files));

		flag = flag.equalsIgnoreCase('Created') ? 'Created' : 'Deleted';
		List<String> notiBodyFiesIds = new List<String>();
		List<Notification_File__c> updateNotiFiles = new List<Notification_File__c>();
		List<Object> notiBodyFies = new List<Object>();
		for (Notification_File__c noti_f : noti_files) {
			if (noti_f.Integration_Status__c == 'Failed' || String.isEmpty(noti_f.Integration_Status__c) || flag.equalsIgnoreCase('Deleted')) {
				updateNotiFiles.add(new Notification_File__c(Id = noti_f.Id, Integration_Status__c = 'In Progress'));
			}

			if (noti_f.Notification__c != null) {
				notiBodyFiesIds.add(noti_f?.Notification__c);
			}

			notiBodyFies.add(
				new Map<String, String>{
					'sf_id' => noti_f.Id,
					'notification_number' => String.isNotEmpty(noti_f.Notification_Number_Formular__c) ? noti_f.Notification_Number_Formular__c : '',
					'sap_file_id' => String.isNotEmpty(noti_f.SAP_File_Id__c) ? noti_f.SAP_File_Id__c : '',
					'file_Id' => String.isNotEmpty(noti_f.File_Id__c) ? noti_f.File_Id__c : '',
					'file_name' => String.isNotEmpty(noti_f.File_Name__c) ? noti_f.File_Name__c : '',
					'link' => noti_f.Url_Link__c == null
						? String.format('{0}/{1}', new List<Object>{ URL.getSalesforceBaseUrl().toExternalForm(), noti_f.File_Id__c })
						: noti_f.Url_Link__c,
					'action' => new Map<String, String>{ 'created' => '1', 'deleted' => '2' }.get(flag.toLowerCase()),
					'object_type' => 'BUS2038',
					'flag' => flag
				}
			);
		}

		if (notiBodyFies.size() > 0) {
			Database.update(updateNotiFiles, false);
			String notificationId = noti_files.get(0)?.Notification__c;
			String uuid = Uuid.randomUUID();
			calloutToIRPA_NotificationFile(
				String.join(notiBodyFiesIds, ', '),
				uuid,
				flag,
				JSON.serialize(
					new Map<String, Object>{
						'input' => new Map<String, Object>{
							'NotificationAttachmentData' => new Map<String, Object>{
								'notification_attachment' => notiBodyFies,
								'uuid' => uuid,
								'notification_id' => notificationId
							}
						},
						'invocationContext' => '${invocation_context}'
					}
				)
			);
		}
	}

	@future(callout=true)
	public static void calloutToIRPA_NotificationFile(String notiBodyFiesIds, String uuid, String flag, String bodyJson) {
		THORIntegration__c CS = THORIntegration__c.getInstance();

		Application_Log__c applog = new Application_Log__c();
		applog.Integration_Name__c = 'calloutToIRPA_NotificationFile';
		applog.Method__c = new Map<String, String>{ 'Created' => 'Create', 'Deleted' => 'Delete' }.get(flag);
		applog.Message_Type__c = 'In Progress';
		applog.Request_Body__c = bodyJson;
		applog.Reference_ID__c = notiBodyFiesIds;
		applog.External_ID__c = uuid;

		try {
			Http http = new Http();
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_Token_Endpoint__c);
			req.setBody('grant_type=client_credentials&client_id=' + CS.iRPA_Client_Id__c + '&client_secret=' + CS.iRPA_Client_Secret_Id__c);
			HttpResponse res = http.send(req);
			String token = res.getBody();

			Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(token);
			String access_token = result.containsKey('access_token') ? (String) result.get('access_token') : '';

			/**
			 * @Description R2
			 * Sending url link to iRPA
			 */
			System.debug(System.LoggingLevel.DEBUG, JSON.serializePretty(CS));

			req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_Notification_File_Endpoint__c);
			req.setHeader('Content-Type', 'application/json');
			req.setHeader('Authorization', 'Bearer ' + access_token);
			req.setHeader(CS.iRPA_API_Key_Header__c, CS.iRPA_API_Key__c);
			req.setTimeout(120 * 1000);
			req.setBody(bodyJson);

			res = http.send(req);
			System.debug(System.LoggingLevel.DEBUG, res?.getStatus());
			System.debug(System.LoggingLevel.DEBUG, res?.getStatusCode());
			System.debug(System.LoggingLevel.DEBUG, MethodUtils.serializePrettyString(bodyJson));
			System.debug(System.LoggingLevel.DEBUG, MethodUtils.serializePrettyString(res?.getBody()));

			result = getValuesWithRegex(res?.getBody());
			applog.Response_Body__c = res?.getBody();
			if (result.containsKey('severity') && String.valueOf(result.get('severity')).equalsIgnoreCase('ERROR')) {
				List<Notification_File__c> notiFiles = new List<Notification_File__c>();
				for (String value : notiBodyFiesIds.split(',')) {
					notiFiles.add(
						new Notification_File__c(
							Id = value.trim(),
							Integration_Status__c = 'Failed',
							Integration_Message__c = String.valueOf(result.get('message'))
						)
					);
				}
				update notiFiles;
				applog.Message_Type__c = 'Fail';
			}

			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Notification_File_Endpoint__c, applog);
		} catch (Exception e) {
			String msg = String.format('{0} \r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() });
			System.debug(System.LoggingLevel.Error, msg);
			applog.Message_Type__c = 'Fail';
			applog.Error_Message__c = msg;

			ApplicationLogUtils.saveLogOutbound(CS?.iRPA_Notification_File_Endpoint__c, applog);
		}
	}
}