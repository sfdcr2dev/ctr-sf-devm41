/**
 * @description       :
 * @author            : narathip.s@roundtwosolutions.com
 * @group             :
 * @last modified on  : 06-29-2022
 * @last modified by  : narathip.s@roundtwosolutions.com
 **/
public with sharing class ODM_WorkClearanceController {
    @AuraEnabled
    public static Object getUser() {
        User user = [SELECT Id, Name ,FirstName, LastName, Main_Work_Center__c
                     FROM User WHERE Id =: userInfo.getUserId()];
        return user;
    }

	public static String conditionQuery(String apiField, String operator, String val) {
		if (operator.equalsIgnoreCase('LIKE')) {
			val = String.valueOf(val).replace('*', '%');
			if (!val.contains('%')) {
				val = '%' + val + '%';
			}
		}
		return String.format('{0} {1} {2}', new List<String>{ apiField, operator, '\'' + val + '\'' });
	}

	private static List<String> parseWcFilterObject(Map<String, Object> filter) {
		Map<String, String> filterMapping = new Map<String, String>();
		if (filter.containsKey('Create_Date_From__c')) {
			filterMapping.put(
				'CreatedDate_from',
				'CreatedDate >= ' + String.valueOf(filter.get('Create_Date_From__c') + 'T00:00:00.000+0700')
			);
		}
		if (filter.containsKey('Create_Date_To__c')) {
			filterMapping.put(
				'CreatedDate_to',
				'CreatedDate <= ' + String.valueOf(filter.get('Create_Date_To__c') + 'T23:59:59.000+0700')
			);
		}
		if (filter.containsKey('Requested_Date_Form__c')) {
			filterMapping.put(
				'AuthorizedDate_from',
				'Authorized_Date_UI__c >= ' + String.valueOf(filter.get('Requested_Date_Form__c'))
			);
		}
		if (filter.containsKey('Requested_Date_To__c')) {
			filterMapping.put(
				'AuthorizedDate_to',
				'Authorized_Date_UI__c <= ' + String.valueOf(filter.get('Requested_Date_To__c'))
			);
		}

		/**
		 * @description: Add filter condition for query
		 */
		if (filter.containsKey('Requester__c')) {
			filter.put('Requester_UI__r.EMPLOYEEID__c', filter.get('Requester__c'));
		}
		if (filter.containsKey('Created_By__c')) {
			filter.put('Requester_UI__r.EMPLOYEEID__c', filter.get('Created_By__c'));
		}

		// Thor_filter__c => Work_Clearance__c
		Map<String, String> convertFieldName = new Map<String, String>{
			'Clearance_Number__c' => 'Work_Clearance__c',
			// 'Work_Clearance_Status__c' => 'Work_Clearance_Status__c',
			'Functional_Location__c' => 'FunctionalLocation__r.Name',
			'Notification_Number__c' => 'Notification__r.Name',
			'Notification_Type__c' => 'Notification__r.type__c',
			'Order_Number__c' => 'Order__r.Name',
			'Order_Type__c' => 'Order__r.Order_Type__c',
			// 'Priority__c' => 'Priority__c',
			'Requester__c' => 'Requester_UI__r.EN_Fullname__c',
			// 'Main_Work_Center__c' => 'Main_Work_Center__c',
			// 'Location__c' => 'Location__c'

			// Historical Search
			'Status__c' => 'Work_Clearance_Status__c',
			'Main_Work_Center__c' => 'Main_Work_Center__r.Name',
			'Created_By__c' => 'Requester_UI__r.EN_Fullname__c'
		};

		for (String oldKey : convertFieldName.keySet()) {
			if (filter.containsKey(oldKey)) {
				String newKey = convertFieldName.get(oldKey);
				filter.put(newKey, filter.remove(oldKey));
			}
		}

		Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe().get('Work_Clearance__c'.toLowerCase()).getDescribe().fields.getMap();
		//System.debug(JSON.serializePretty(sObjectField.get('Priority__c').getDescribe().getPicklistValues()));
		for (String f : filter.keySet()) {
			if (!sObjectField.containsKey(f) && !f.contains('__r')) {
				filter.remove(f);
			}

			if (f?.equalsIgnoreCase('Priority__c')) {
				Schema.DescribeFieldResult dfr = sObjectField.get(f)?.getDescribe();
				List<Schema.PicklistEntry> picklistValueInfo = dfr.getPicklistValues();
				for (Schema.PicklistEntry p : picklistValueInfo) {
					filter.put(f, String.valueOf(filter.get(f))?.replace(p.getLabel(), p.getValue()));
				}
			}

			if (f?.equalsIgnoreCase('Area__c')) {
				filterMapping.put('Area__c', 'Area__c IN (\'' + filter.get(f) + '\')');
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
			if (String.valueOf(value)?.contains(';')) {
				List<String> tempVal = new List<String>();
				for (String f : String.valueOf(value).split(';')) {
					tempVal.add(String.format('{0}', new List<String>{ '\'' + f + '\'' }));
				}
				filterMapping.put(apiField,String.format('{0} IN ({1})', new List<String>{ apiField, String.join(tempVal, ',') }));
			} else if (fieldType === Schema.DisplayType.BOOLEAN) {
				filterMapping.put(apiField,String.format('{0} {1} {2}', new List<Object>{ apiField, '=', Boolean.valueOf(value) }));
			} else if (fieldType == Schema.DisplayType.REFERENCE || fieldType == Schema.DisplayType.PICKLIST) {
				filterMapping.put(apiField, conditionQuery(apiField, ' = ', String.valueOf(value)));
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
		if (
			filterMapping.containsKey('Requester_UI__r.EN_Fullname__c') ||
			filterMapping.containsKey('Requester_UI__r.EMPLOYEEID__c')
		) {
			filterMapping.put(
				'Requester_UI__r',
				String.format(
					'({0} OR {1})',
					new List<String>{
						filterMapping.remove('Requester_UI__r.EN_Fullname__c'),
						filterMapping.remove('Requester_UI__r.EMPLOYEEID__c')
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
	public static Object getWcList(
		Map<String, String> filter,
		Integer offset,
		Integer rowlimit,
		Boolean isSharingSettings
	) {
		String query;
		try {
			List<String> filterMapping = parseWcFilterObject(filter);

			String condition = '';
			if (isSharingSettings) {
				condition = String.format(
					'WHERE CreatedDate > 2021-01-01T00:00:00.000+0700 AND {0}',
					//'WHERE Authorized_Date_UI__c > 2022-01-01 AND Area__c != null AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
							: ''
					}
				);
			} else {
				condition = String.format(
					'WHERE {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
							: ''
					}
				);
			}

			condition = condition.trim().endsWith('AND') ? condition.trim().removeEnd('AND') : condition;

			query = String.format(
				'SELECT {0} FROM Work_Clearance__c {1} ORDER BY Authorized_Date__c DESC LIMIT 25000',
				new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Area__c', 'CreatedDate', 'Authorized_Date_UI__c', 'Work_Clearance__c', 'Work_Clearance_Status__c', 'Functional_Location__c', 'FunctionalLocation__r.Description__c', 'Main_Work_Center__r.Name', 'Notification__r.Name', 'Order__r.Name', 'Verification_Status__c', 'UserRecordAccess.HasEditAccess' }, ',' ), // fields
					condition
				}
			);

			List<Object> wcAsObjectList = Database.query(query);
			List<Object> wcResultAsObjectList;

			if (isSharingSettings) {
				wcResultAsObjectList = new List<Object>();
				for (Object wcAsObject : wcAsObjectList) {
					Work_Clearance__c wc = (Work_Clearance__c) wcAsObject;
					if (wc.UserRecordAccess.HasEditAccess) {
						wcResultAsObjectList.add(wc);
					}
				}
			} else {
				wcResultAsObjectList = wcAsObjectList;
			}

			List<Object> wcPagingResultAsObjectList = new List<Object>();
			for (Integer i = offset; (i < offset + rowlimit) && (i < wcResultAsObjectList.size()); i++) {
				wcPagingResultAsObjectList.add(wcResultAsObjectList[i]);
			}

			return new Map<String, Object>{
				'data' => wcPagingResultAsObjectList,
				'count' => wcResultAsObjectList.size()
			};
		} catch (Exception e) {
			//System.debug(System.LoggingLevel.DEBUG, e.getStackTraceString());
			throw new AuraHandledException(query);
		}
	}

	@AuraEnabled
	public static Object getWcVerificationList(
		Map<String, String> filter,
		Integer offset,
		Integer rowlimit,
		Boolean isSharingSettings
	) {
		String query;
		try {
			List<String> filterMapping = parseWcFilterObject(filter);

			String condition = '';
			if (isSharingSettings) {
				condition = String.format(
					'WHERE CreatedDate > 2021-01-01T00:00:00.000+07:00 AND Work_Clearance_Status__c = \'In Progress\' AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND (Verification_Status__c = null OR Verification_Status__c = \'Draft\') AND {0}',
					//'WHERE Authorized_Date_UI__c > 2022-01-01 AND Work_Clearance_Status__c = \'In Progress\' AND Area__c != null AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND (Verification_Status__c = null OR Verification_Status__c = \'Draft\') AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
							: ''
					}
				);
			} else {
				condition = String.format(
					'WHERE Work_Clearance_Status__c = \'In Progress\' AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND (Verification_Status__c = null OR Verification_Status__c = \'Draft\') AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
							: ''
					}
				);
			}
			condition = condition.trim().endsWith('AND') ? condition.trim().removeEnd('AND') : condition;

			query = String.format(
				'SELECT {0} FROM Work_Clearance__c {1} ORDER BY Authorized_Date__c DESC LIMIT 25000',
				new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Area__c', 'CreatedDate', 'Authorized_Date_UI__c', 'Work_Clearance__c', 'Work_Clearance_Status__c', 'Functional_Location__c', 'FunctionalLocation__r.Description__c', 'Main_Work_Center__r.Name', 'Notification__r.Name', 'Order__r.Name', 'Verification_Status__c', 'UserRecordAccess.HasEditAccess' }, ',' ), // fields
					condition
				}
			);

			List<Object> wcAsObjectList = Database.query(query);
			List<Object> wcResultAsObjectList;

			if (isSharingSettings) {
				wcResultAsObjectList = new List<Object>();
				for (Object wcAsObject : wcAsObjectList) {
					Work_Clearance__c wc = (Work_Clearance__c) wcAsObject;
					if (wc.UserRecordAccess.HasEditAccess) {
						wcResultAsObjectList.add(wc);
					}
				}
			} else {
				wcResultAsObjectList = wcAsObjectList;
			}

			List<Object> wcPagingResultAsObjectList = new List<Object>();
			for (Integer i = offset; (i < offset + rowlimit) && (i < wcResultAsObjectList.size()); i++) {
				wcPagingResultAsObjectList.add(wcResultAsObjectList[i]);
			}

			return new Map<String, Object>{
				'data' => wcPagingResultAsObjectList,
				'count' => wcResultAsObjectList.size()
			};
		} catch (Exception e) {
//System.debug(System.LoggingLevel.DEBUG, e.getStackTraceString());
			throw new AuraHandledException(query);
		}
	}

	@AuraEnabled
	public static Object getWcVerificationAllList(
		Map<String, String> filter,
		Integer offset,
		Integer rowlimit,
		Boolean isSharingSettings
	) {
		String query;
		try {
			List<String> filterMapping = parseWcFilterObject(filter);

			String condition = '';
			if (isSharingSettings) {
				condition = String.format(
					'WHERE CreatedDate > 2021-01-01T00:00:00.000+07:00 AND Work_Clearance_Status__c = \'In Progress\' AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND {0}',
					//'WHERE Authorized_Date_UI__c > 2022-01-01 AND Work_Clearance_Status__c = \'In Progress\' AND Area__c != null AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND (Verification_Status__c = null OR Verification_Status__c = \'Draft\') AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
							: ''
					}
				);
			} else {
				condition = String.format(
					'WHERE Work_Clearance_Status__c = \'In Progress\' AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
							: ''
					}
				);
			}
			condition = condition.trim().endsWith('AND') ? condition.trim().removeEnd('AND') : condition;

			query = String.format(
				'SELECT {0} FROM Work_Clearance__c {1} ORDER BY Authorized_Date__c DESC LIMIT 25000',
				new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Area__c', 'CreatedDate', 'Authorized_Date_UI__c', 'Work_Clearance__c', 'Work_Clearance_Status__c', 'Functional_Location__c', 'FunctionalLocation__r.Description__c', 'Main_Work_Center__r.Name', 'Notification__r.Name', 'Order__r.Name', 'Verification_Status__c', 'UserRecordAccess.HasEditAccess' }, ',' ), // fields
					condition
				}
			);

			List<Object> wcAsObjectList = Database.query(query);
			List<Object> wcResultAsObjectList;

			if (isSharingSettings) {
				wcResultAsObjectList = new List<Object>();
				for (Object wcAsObject : wcAsObjectList) {
					Work_Clearance__c wc = (Work_Clearance__c) wcAsObject;
					if (wc.UserRecordAccess.HasEditAccess) {
						wcResultAsObjectList.add(wc);
					}
				}
			} else {
				wcResultAsObjectList = wcAsObjectList;
			}

			List<Object> wcPagingResultAsObjectList = new List<Object>();
			for (Integer i = offset; (i < offset + rowlimit) && (i < wcResultAsObjectList.size()); i++) {
				wcPagingResultAsObjectList.add(wcResultAsObjectList[i]);
			}

			return new Map<String, Object>{
				'data' => wcPagingResultAsObjectList,
				'count' => wcResultAsObjectList.size()
			};
		} catch (Exception e) {
//System.debug(System.LoggingLevel.DEBUG, e.getStackTraceString());
			throw new AuraHandledException(query);
		}
	}

	@AuraEnabled
	public static Object getWcInspectionList(
		Map<String, String> filter,
		Integer offset,
		Integer rowlimit,
		Boolean isSharingSettings
	) {
		String query;
		try {
			List<String> filterMapping = parseWcFilterObject(filter);

			String condition = '';
			if (isSharingSettings) {
				condition = String.format(
					'WHERE CreatedDate > 2022-01-01T00:00:00.000+0700 AND Work_Clearance_Status__c = \'In Progress\' AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND Verification_Status__c = \'Agree\' AND {0}',
					//'WHERE Authorized_Date_UI__c > 2022-01-01 AND Work_Clearance_Status__c = \'In Progress\' AND Area__c != null AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND Verification_Status__c = \'Agree\' AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
							: ''
					}
				);
			} else {
				condition = String.format(
					'WHERE Work_Clearance_Status__c = \'In Progress\' AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND Verification_Status__c = \'Agree\' AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
							: ''
					}
				);
			}
			condition = condition.trim().endsWith('AND') ? condition.trim().removeEnd('AND') : condition;

			query = String.format(
				'SELECT {0} FROM Work_Clearance__c {1} ORDER BY Authorized_Date__c DESC LIMIT 25000',
				new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Area__c', 'CreatedDate', 'Authorized_Date_UI__c', 'Work_Clearance__c', 'Work_Clearance_Status__c', 'Functional_Location__c', 'FunctionalLocation__r.Description__c', 'Main_Work_Center__r.Name', 'Notification__r.Name', 'Order__r.Name', 'Verification_Status__c', 'UserRecordAccess.HasEditAccess', '(SELECT Id FROM PTW_Header__r WHERE FormName__c = \'Inspection\' AND Status__c = \'ดำเนินการได้\')' }, ',' ), // fields
					condition
				}
			);

			List<Object> wcAsObjectList = Database.query(query);
			List<Object> wcResultAsObjectList;

			if (isSharingSettings) {
				wcResultAsObjectList = new List<Object>();
				for (Object wcAsObject : wcAsObjectList) {
					Work_Clearance__c wc = (Work_Clearance__c) wcAsObject;
					if (wc.UserRecordAccess.HasEditAccess) {
						wcResultAsObjectList.add(wc);
					}
				}
			} else {
				wcResultAsObjectList = wcAsObjectList;
			}

			List<Object> wcPagingResultAsObjectList = new List<Object>();
			for (Integer i = offset; (i < offset + rowlimit) && (i < wcResultAsObjectList.size()); i++) {
				wcPagingResultAsObjectList.add(wcResultAsObjectList[i]);
			}

			return new Map<String, Object>{
				'data' => wcPagingResultAsObjectList,
				'count' => wcResultAsObjectList.size()
			};
		} catch (Exception e) {
			//System.debug(System.LoggingLevel.DEBUG, e.getStackTraceString());
			throw new AuraHandledException(query);
		}
	}

	@AuraEnabled
	public static Object getWcInspectionDoneList(
		Map<String, String> filter,
		Integer offset,
		Integer rowlimit,
		Boolean isSharingSettings
	) {
		String query;
		try {
			List<String> filterMapping = parseWcFilterObject(filter);

			String condition = '';
			if (isSharingSettings) {
				condition = String.format(
					'WHERE CreatedDate > 2022-01-01T00:00:00.000+0700 AND Work_Clearance_Status__c = \'In Progress\' AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND Verification_Status__c = \'Agree\' AND {0}',
					//'WHERE Authorized_Date_UI__c > 2022-01-01 AND Work_Clearance_Status__c = \'In Progress\' AND Area__c != null AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND Verification_Status__c = \'Agree\' AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
							: ''
					}
				);
			} else {
				condition = String.format(
					'WHERE Work_Clearance_Status__c = \'In Progress\' AND (Authorized_Signature_UI__c != null AND Authorized_Signatory_UI__c != null) AND Verification_Status__c = \'Agree\' AND {0}',
					new List<String>{
						filterMapping.size() > 0 // condition (optional)
							? String.format('{0}', new List<Object>{ String.join(filterMapping, ' AND ') })
							: ''
					}
				);
			}
			condition = condition.trim().endsWith('AND') ? condition.trim().removeEnd('AND') : condition;

			query = String.format(
				'SELECT {0} FROM Work_Clearance__c {1} ORDER BY Authorized_Date__c DESC LIMIT 25000',
				new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Area__c', 'CreatedDate', 'Authorized_Date_UI__c', 'Work_Clearance__c', 'Work_Clearance_Status__c', 'Functional_Location__c', 'FunctionalLocation__r.Description__c', 'Main_Work_Center__r.Name', 'Notification__r.Name', 'Order__r.Name', 'Verification_Status__c', 'UserRecordAccess.HasEditAccess', '(SELECT Id FROM PTW_Header__r WHERE FormName__c = \'Inspection\' AND Status__c = \'ดำเนินการได้\')' }, ',' ), // fields
					condition
				}
			);

			List<Object> wcAsObjectList = Database.query(query);
			List<Object> wcResultAsObjectList;

			if (isSharingSettings) {
				wcResultAsObjectList = new List<Object>();
				for (Object wcAsObject : wcAsObjectList) {
					Work_Clearance__c wc = (Work_Clearance__c) wcAsObject;
					if (wc.UserRecordAccess.HasEditAccess && !wc.PTW_Header__r.isEmpty()) {
						wcResultAsObjectList.add(wc);
					}
				}
			} else {
				wcResultAsObjectList = new List<Object>();
				for (Object wcAsObject : wcAsObjectList) {
					Work_Clearance__c wc = (Work_Clearance__c) wcAsObject;
					if (!wc.PTW_Header__r.isEmpty()) {
						wcResultAsObjectList = wcAsObjectList;
					}
				}
			}

			List<Object> wcPagingResultAsObjectList = new List<Object>();
			for (Integer i = offset; (i < offset + rowlimit) && (i < wcResultAsObjectList.size()); i++) {
				wcPagingResultAsObjectList.add(wcResultAsObjectList[i]);
			}

			return new Map<String, Object>{
				'data' => wcPagingResultAsObjectList,
				'count' => wcResultAsObjectList.size()
			};
		} catch (Exception e) {
			//System.debug(System.LoggingLevel.DEBUG, e.getStackTraceString());
			throw new AuraHandledException(query);
		}
	}
}