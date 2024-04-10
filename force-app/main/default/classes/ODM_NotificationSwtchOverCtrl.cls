public with sharing class ODM_NotificationSwtchOverCtrl {
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
		if (filter.containsKey('Create_Date_From__c')) {
			filterMapping.put(
				'Requested_Date_from__c',
				'Requested_Date__c >= ' + String.valueOf(filter.get('Create_Date_From__c'))
			);
		}
		if (filter.containsKey('Create_Date_To__c')) {
			filterMapping.put(
				'Requested_Date_to__c',
				'Requested_Date__c <= ' + String.valueOf(filter.get('Create_Date_To__c'))
			);
		}
		if (filter.containsKey('Submission_Date_From__c')) {
			filterMapping.put(
				'Required_Start_from__c',
				'Required_Start__c >= ' + String.valueOf(filter.get('Submission_Date_From__c'))
			);
		}
		if (filter.containsKey('Submission_Date_To__c')) {
			filterMapping.put(
				'Required_Start_to__c',
				'Required_Start__c <= ' + String.valueOf(filter.get('Submission_Date_To__c'))
			);
		}

		/**
		 * @description: Add filter condition for query
		 */
		if (filter.containsKey('Requester__c')) {
			filter.put('Requester_PISUser__r.EMPLOYEEID__c', filter.get('Requester__c'));
		}

		//Thor_filter__c => Notification__c
		Map<String, String> convertFieldName = new Map<String, String>{
			'Notification_Type__c' => 'Type__c',
			'Functional_Location__c' => 'Functional_Location__r.Name',
			'Main_Work_Center__c' => 'Main_Work_Center__r.Code__c',
			'Notification_Date__c' => 'Requested_Date__c',
			// 'Submission_Date_From__c' => 'Required_Start__c',
			'Requester__c' => 'Requester_PISUser__r.EN_Fullname__c'
		};
		for (String oldKey : convertFieldName.keySet()) {
			if (filter.containsKey(oldKey)) {
				String newKey = convertFieldName.get(oldKey);
				filter.put(newKey, filter.remove(oldKey));
			}
		}

		Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe()
			.get('Notification__c'.toLowerCase())
			.getDescribe()
			.fields
			.getMap();
		for (String f : filter.keySet()) {
			if (!sObjectField.containsKey(f) && !f.contains('__r')) {
				filter.remove(f);
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
				filterMapping.put(
					apiField,
					String.format('{0} IN ({1})', new List<String>{ apiField, String.join(tempVal, ',') })
				);
			} else if (fieldType === Schema.DisplayType.BOOLEAN) {
				filterMapping.put(
					apiField,
					String.format('{0} {1} {2}', new List<Object>{ apiField, '=', Boolean.valueOf(value) })
				);
			} else if (fieldType == Schema.DisplayType.REFERENCE || fieldType == Schema.DisplayType.PICKLIST) {
				filterMapping.put(apiField, conditionQuery(apiField, '=', String.valueOf(value)));
			} else if (fieldType == Schema.DisplayType.DATE) {
				filterMapping.put(
					apiField,
					String.format('{0} = {1}', new List<String>{ apiField, String.valueOf(value) })
				);
			} else {
				filterMapping.put(apiField, conditionQuery(apiField, 'LIKE', String.valueOf(value)));
			}
		}

		/**
		 * @description: union condition when are same field
		 *
		 */
		if (
			filterMapping.containsKey('Requester_PISUser__r.EN_Fullname__c') ||
			filterMapping.containsKey('Requester_PISUser__r.EMPLOYEEID__c')
		) {
			filterMapping.put(
				'Requester_PISUser__r',
				String.format(
					'({0} OR {1})',
					new List<String>{
						filterMapping.remove('Requester_PISUser__r.EN_Fullname__c'),
						filterMapping.remove('Requester_PISUser__r.EMPLOYEEID__c')
					}
				)
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
			System.debug(LoggingLevel.DEBUG, JSON.serializePretty(filterMapping));

			List<String> shareIds = new List<String>();
			if (isSharingSettings) {
				shareIds = MethodUtils.getMysObjectEditAcess('Notification__c');
			}

			String condition = String.format(
				'WHERE Description__c LIKE \'SWITCH OVER%\' AND {0} {1}',
				new List<String>{
					shareIds.size() > 0 ? 'Id IN :shareIds AND' : '',
					filterMapping.size() > 0 // condition (optional)
						? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
						: ''
				}
			);
			condition = condition.trim().endsWith('WHERE') ? condition.trim().removeEnd('WHERE') : condition;
			String query = String.format(
				'SELECT {0} FROM Notification__c {1} ORDER BY Notification_Number__c DESC {2} {3}',
				new List<String>{
					String.join( // fields
						new List<String>{
							'Id',
							'Name',
							'Notification_Number__c',
							'toLabel(Notification_Status__c)',
							'Description__c',
							'Type__c',
							'Priority__c',
							// 'CreatedDate',
							'Requested_Date__c',
							'Required_Start__c',
							'Functional_Location__r.Name',
							'Main_Work_Center__r.Name',
							'AssignedTo__c'
						},
						','
					),
					condition,
					String.format('LIMIT {0}', new List<String>{ String.valueOf(rowlimit) }),
					String.format('OFFSET {0}', new List<String>{ String.valueOf(offset) })
				}
			);

			System.debug(query);
			return new Map<String, Object>{
				'data' => Database.query(query),
				'count' => Database.countQuery(
					String.format('SELECT Count() FROM Notification__c {0}', new List<String>{ condition })
				)
			};
		} catch (Exception e) {
			System.debug(System.LoggingLevel.DEBUG, e.getStackTraceString());
			throw new AuraHandledException(e.getMessage());
		}
	}
}