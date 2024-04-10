/**
 * @description       :
 * @author            : narathip.s@roundtwosolutions.com
 * @group             :
 * @last modified on  : 06-13-2022
 * @last modified by  : narathip.s@roundtwosolutions.com
 **/
public with sharing class ODM_NotificationController {
	public static String conditionQuery(String apiField, String operator, String val) {
		if (operator.equalsIgnoreCase('LIKE')) {
			val = String.valueOf(val).replace('*', '%');
			if (!val.contains('%')) {
				val = '%' + val + '%';
			}
		}
		return String.format('{0} {1} {2}', new List<String>{ apiField, operator, '\'' + val + '\'' });
	}

	private static List<String> parseNotificationFilterObject(Map<String, Object> filter) {
		Map<String, String> filterMapping = new Map<String, String>();

		/**
		 * @description: Add filter condition for query
		 */
		if (filter.containsKey('Create_Date_From__c')) {
			filterMapping.put('Requested_Date_from__c', 'Requested_Date__c >= ' + String.valueOf(filter.get('Create_Date_From__c')));
		}
		if (filter.containsKey('Create_Date_To__c')) {
			filterMapping.put('Requested_Date_to__c', 'Requested_Date__c <= ' + String.valueOf(filter.get('Create_Date_To__c')));
		}
		if (filter.containsKey('Submission_Date_From__c')) {
			filterMapping.put('Required_Start_from__c', 'Required_Start__c >= ' + String.valueOf(filter.get('Submission_Date_From__c')));
		}
		if (filter.containsKey('Submission_Date_To__c')) {
			filterMapping.put('Required_Start_to__c', 'Required_Start__c <= ' + String.valueOf(filter.get('Submission_Date_To__c')));
		}
		if (filter.containsKey('Requester__c')) {
			filter.put('Requester_PISUser__r.HOST_ID__c', filter.get('Requester__c'));
		}

		Map<String, String> convertFieldName = new Map<String, String>{
			'Notification_Type__c' => 'Type__c',
			'Functional_Location__c' => 'Functional_Location__r.Name',
			'Main_Work_Center__c' => 'Main_Work_Center__r.Name',
			'Notification_Date__c' => 'Requested_Date__c',
			'Requester__c' => 'Requester_PISUser__r.EN_Fullname__c'
		};
		for (String oldKey : convertFieldName.keySet()) {
			if (filter.containsKey(oldKey)) {
				String newKey = convertFieldName.get(oldKey);
				filter.put(newKey, filter.remove(oldKey));
			}
		}

		Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe().get('Notification__c'.toLowerCase()).getDescribe().fields.getMap();
		for (String f : filter.keySet()) {
			if (!sObjectField.containsKey(f) && !f.contains('__r')) {
				filter.remove(f);
			}

			if (f?.equalsIgnoreCase('Main_Work_Center__r.Name')) {
				Object mainWorkCenter = filter.get(f);
				if (String.valueOf(mainWorkCenter).containsIgnoreCase('OPS-')) {
					filterMapping.put('OPSMainWorkCenter__c', 'OPSMainWorkCenter__c LIKE \'%' + String.valueOf(mainWorkCenter).trim() + '%\'');
					filter.remove(f);
				} else {
					filterMapping.put('Main_Work_Center__r.Name', 'Main_Work_Center__r.Name IN (\'' + String.valueOf(mainWorkCenter).trim() + '\')');
					filter.remove(f);
				}
			}
		}

		for (String apiField : filter.keySet()) {
			Object value = filter.get(apiField);
			Schema.DisplayType fieldType = sObjectField.get(apiField)?.getDescribe()?.getType();
			if (String.valueOf(value).contains(';')) {
				List<String> tempVal = new List<String>();
				for (String f : String.valueOf(value).split(';')) {
					tempVal.add(String.format('{0}', new List<String>{ '\'' + f + '\'' }));
				}
				filterMapping.put(apiField,String.format('{0} IN ({1})', new List<String>{ apiField, String.join(tempVal, ',') }));
			} else if (fieldType === Schema.DisplayType.BOOLEAN) {
				filterMapping.put(apiField,String.format('{0} {1} {2}', new List<Object>{ apiField, '=', Boolean.valueOf(value) }));
			} else if (fieldType == Schema.DisplayType.REFERENCE || fieldType == Schema.DisplayType.PICKLIST) {
				filterMapping.put(apiField, conditionQuery(apiField, '=', String.valueOf(value)));
			} else if (fieldType == Schema.DisplayType.DATE) {
				filterMapping.put(apiField,String.format('{0} = {1}', new List<String>{ apiField, String.valueOf(value) }));
			} else {
				filterMapping.put(apiField, conditionQuery(apiField, 'LIKE', String.valueOf(value)));
			}
		}

		/**
		 * @description: union condition when are same field
		 *
		 */
		if (filterMapping.containsKey('Requester_PISUser__r.EN_Fullname__c') || filterMapping.containsKey('Requester_PISUser__r.HOST_ID__c')) {
			filterMapping.put(
				'Requester_PISUser__r',
				String.format('({0} OR {1})',new List<String>{filterMapping.remove('Requester_PISUser__r.EN_Fullname__c'), filterMapping.remove('Requester_PISUser__r.HOST_ID__c')})
            );
		}
		return filterMapping.values();
	}

	/**
	 * @description
	 * @author narathip.s@roundtwosolutions.com | 05-30-2022
	 * @param filter
	 * @param offset
	 * @param rowlimit
	 * @param isSharingSettings
	 * @return Object
	 **/
	@AuraEnabled
	public static Object getNotificationList(
		Map<String, String> filter,
		Integer offset,
		Integer rowlimit,
		Boolean isSharingSettings
	) {
		try {
			List<String> filterMapping = parseNotificationFilterObject(filter);
		
			String condition = '';
			if (isSharingSettings) {
				condition = String.format(
					'WHERE Type__c IN (\'CM\', \'PM\', \'SH\', \'OP\') AND CreatedDate > 2022-01-01T00:00:00.000+0700 AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : ''
					}
				);
			} else {
				condition = String.format(
					'WHERE Type__c IN (\'CM\', \'PM\', \'SH\', \'OP\') AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : ''
					}
				);
			}
			condition = condition.trim().endsWith('AND') ? condition.trim().removeEnd('AND') : condition;
		
			String query = String.format(
				'SELECT {0} FROM Notification__c {1} ORDER BY Notification_Number__c DESC LIMIT 25000',
				new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Number__c', 'toLabel(Notification_Status__c)', 'Description__c', 'Type__c', 'Priority__c', 'CreatedDate', 'Requested_Date__c', 'Required_Start__c', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), condition }
			);
			
			List<Object> notiAsObjectList = Database.query(query);
			List<Object> notiResultAsObjectList;

			if (isSharingSettings) {
				notiResultAsObjectList = new List<Object>();
				for (Object notiAsObject : notiAsObjectList) {
					Notification__c noti = (Notification__c) notiAsObject;
					if (noti.UserRecordAccess.HasEditAccess) {
						notiResultAsObjectList.add(noti);
					}
				}
			} else {
				notiResultAsObjectList = notiAsObjectList;
			}

			List<Object> notiPagingResultAsObjectList = new List<Object>();
			for (Integer i = offset; (i < offset + rowlimit) && (i < notiResultAsObjectList.size()); i++) {
				notiPagingResultAsObjectList.add(notiResultAsObjectList[i]);
			}

			return new Map<String, Object>{
				'data' => notiPagingResultAsObjectList,
				'count' => notiResultAsObjectList.size()
			};
		} catch (Exception e) {
			System.debug(System.LoggingLevel.DEBUG, e.getStackTraceString());
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Boolean hasWriteAccess(String notificationId) {
		List<UserRecordAccess> access = [SELECT RecordId FROM UserRecordAccess WHERE HasEditAccess = TRUE AND RecordId = :notificationId AND UserId = :UserInfo.getUserId()];

		return !access.isEmpty();
	}

	@AuraEnabled
	public static void setNotificationStatusClosed(String notificationId) {
		Notification__c n = [SELECT id, name, System_Status_Text__c, Notification_Status__c FROM Notification__c WHERE Id = :notificationId WITH SECURITY_ENFORCED ];

		n.System_Status_Text__c = 'NOCO';
		// n.Notification_Status__c = 'Closed';
		n.Integration_Status__c = 'In Progress';

		try {
			if (Schema.sObjectType.Notification__c.isUpdateable()) {
				update n;
			}
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}

	@AuraEnabled
    public static Object getUser() {
        User user = [SELECT Id, Name ,FirstName, LastName, Main_Work_Center__c
                     FROM User WHERE Id =: userInfo.getUserId()];
        return user;
    }
}