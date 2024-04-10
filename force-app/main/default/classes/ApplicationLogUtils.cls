public without sharing class ApplicationLogUtils extends MethodUtils implements ITriggerHandler {
	public static Boolean TriggerDisabled = false;
	public Boolean isDisabled() {
		return TriggerDisabled;
	}
	public void beforeInsert(List<SObject> newItems) {
		for (Application_Log__c newlog : (List<Application_Log__c>) newItems) {
			if (String.isNotEmpty(newlog.Error_Message__c)) {
				newlog.Error_Message__c = String.format(
					'[{0}]: {1},\r\n',
					new List<String>{ getDatetimeStampNowTH(), serializePrettyString(newlog.Error_Message__c) }
				)?.left(131072);
			}
			if (String.isNotEmpty(newlog.Request_Body__c)) {
				newlog.Request_Body__c = String.format(
					'[{0}]: {1},\r\n',
					new List<String>{ getDatetimeStampNowTH(), serializePrettyString(newlog.Request_Body__c) }
				)?.left(131072);
			}
			if (String.isNotEmpty(newlog.Response_Body__c)) {
				newlog.Response_Body__c = String.format(
					'[{0}]: {1},\r\n',
					new List<String>{ getDatetimeStampNowTH(), serializePrettyString(newlog.Response_Body__c) }
				)?.left(131072);
			}
			if (String.isNotEmpty(newlog.SAP_Response_Body__c)) {
				newlog.SAP_Response_Body__c = String.format(
					'[{0}]: {1},\r\n',
					new List<String>{ getDatetimeStampNowTH(), serializePrettyString(newlog.SAP_Response_Body__c) }
				)?.left(131072);
			}
		}
	}
	public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		for (Application_Log__c newlog : (List<Application_Log__c>) newItems.values()) {
			Application_Log__c oldlog = (Application_Log__c) oldItems.get(newlog.Id);

			newlog.Log_Type__c = String.isNotEmpty(oldlog.Log_Type__c) ? oldlog.Log_Type__c : newlog.Log_Type__c;
			newlog.Integration_Name__c = String.isNotEmpty(oldlog.Integration_Name__c)
				? oldlog.Integration_Name__c
				: newlog.Integration_Name__c;
			newlog.Request_Body__c = String.isNotEmpty(oldlog.Request_Body__c)
				? oldlog.Request_Body__c?.left(131072)
				: newlog.Request_Body__c?.left(131072);

			newlog.Error_Message__c = String.format(
				'{0}\r\n{1}',
				new List<String>{
					oldlog?.Error_Message__c != null ? oldlog.Error_Message__c : '',
					newlog.Error_Message__c != null &&
						newlog.Error_Message__c != oldlog?.Error_Message__c
						? String.format(
								'[{0}]: {1},\r\n',
								new List<String>{
									getDatetimeStampNowTH(),
									serializePrettyString(newlog.Error_Message__c)
								}
						  )
						: ''
				}
			)?.left(131072);
			// serializePrettyString();
			newlog.Response_Body__c = String.format(
				'{0}\r\n{1}',
				new List<String>{
					oldlog?.Response_Body__c != null ? oldlog.Response_Body__c : '',
					newlog.Response_Body__c != null &&
						newlog.Response_Body__c != oldlog?.Response_Body__c
						? String.format(
								'[{0}]: {1},\r\n',
								new List<String>{
									getDatetimeStampNowTH(),
									serializePrettyString(newlog.Response_Body__c)
								}
						  )
						: ''
				}
			)?.left(131072);
			newlog.iRPA_Response_Body__c = String.format(
				'{0}\r\n{1}',
				new List<String>{
					oldlog?.iRPA_Response_Body__c != null ? oldlog.iRPA_Response_Body__c : '',
					newlog.iRPA_Response_Body__c != null &&
						newlog.iRPA_Response_Body__c != oldlog?.iRPA_Response_Body__c
						? String.format(
								'[{0}]: {1},\r\n',
								new List<String>{
									getDatetimeStampNowTH(),
									serializePrettyString(newlog.iRPA_Response_Body__c)
								}
						  )
						: ''
				}
			)?.left(131072);
			newlog.SAP_Response_Body__c = String.format(
				'{0}\r\n{1}',
				new List<String>{
					oldlog?.SAP_Response_Body__c != null ? oldlog.SAP_Response_Body__c : '',
					newlog.SAP_Response_Body__c != null &&
						newlog.SAP_Response_Body__c != oldlog?.SAP_Response_Body__c
						? String.format(
								'[{0}]: {1},\r\n',
								new List<String>{
									getDatetimeStampNowTH(),
									serializePrettyString(newlog.SAP_Response_Body__c)
								}
						  )
						: ''
				}
			)?.left(131072);
		}
	}
	public void beforeDelete(Map<Id, SObject> oldItems) {
	}
	public void afterInsert(Map<Id, SObject> newItems) {
	}
	public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
	}
	public void afterDelete(Map<Id, SObject> oldItems) {
	}
	public void afterUndelete(Map<Id, SObject> oldItems) {
	}

	private static String getDatetimeStampNowTH() {
		return String.format(
			'"{0}"',
			new List<String>{ JSON.serialize(Datetime.now().addHours(7)).replace('\"', '').replace('Z', '+0700') }
		);
	}

	public static Id saveLogInbound(String source, Application_Log__c log) {
		log.Log_Type__c = 'Inbound from ' + source;
		return saveLog(log);
	}

	public static Id saveLogOutbound(String destination, Application_Log__c log) {
		log.Log_Type__c = 'Outbound to ' + destination;
		return saveLog(log);
	}

	public static Id saveLog(Application_Log__c log) {
		try {
			if (log.get('External_ID__c') == null) {
				upsert log;
			} else {
				upsert log External_ID__c;
			}
		} catch (DmlException e) {
			String msg = String.format(
				'{0}\n{1}',
				new List<String>{ 'Cannot save log: ' + e.getDmlMessage(0), 'Stack: ' + e.getStackTraceString() }
			);
			System.debug(System.LoggingLevel.ERROR, msg);

			log.Integration_Name__c = log.Integration_Name__c != null
				? log.Integration_Name__c
				: 'Salesforce system error';
			log.Log_Type__c = 'Salesforce System DMLException';
			log.Message_Type__c = 'Fail';
			log.Error_Message__c = msg;
			if (log.get('External_ID__c') == null) {
				upsert log;
			} else {
				upsert log External_ID__c;
			}
		}

		return log.Id;
	}
}