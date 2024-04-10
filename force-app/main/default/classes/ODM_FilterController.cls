/**
 * @author Oktana
 * @description controller for THOR_Filter component
 */
public with sharing class ODM_FilterController {
	@AuraEnabled
	public static String getExcludedFilter() {
		String excludedFilter = '';
		Id userId = UserInfo.getUserId();

		String userRoleName = '';
		List<User> userList = [SELECT UserRole.Name FROM User WHERE Id = :userId WITH SECURITY_ENFORCED];
		if (userList.size() > 0) {
			userRoleName = userList[0].UserRole.Name;
		}

		if (userRoleName != null) {
			if (
				userRoleName.contains('D-CO-Ordinator') ||
				userRoleName.contains('D-Team Lead') ||
				userRoleName.contains('D-Working Team')
			) {
				excludedFilter = '';
			} else if (userRoleName.contains('Operator')) {
				excludedFilter = 'userFilter';
			} else if (
				userRoleName.contains('CO-Ordinator') ||
				userRoleName.contains('Team Lead') ||
				userRoleName.contains('Working Team')
			) {
				excludedFilter = 'mwcFilter';
			}
		}

		return excludedFilter;
	}

	/**
	 * @description
	 * @author narathip.s@roundtwosolutions.com | 05-26-2022
	 * @param filterType
	 * @param formPage
	 * @param fields
	 * @return sObject
	 **/
	@AuraEnabled
	public static sObject getMyFilter(String filterType, String formPage) {
		try {
			List<String> fields = getFieldsFilter(formPage);
			fields = fields != null && fields?.size() > 0 ? fields : new List<String>();
			fields.addAll(new List<String>{ 'Id', 'IsActive__c' });

			String userId = UserInfo.getUserId();
			List<sObject> sobjectList = Database.query(
				String.format(
					'SELECT {0} FROM THOR_Filter__c WHERE User__c = :userId AND Filter_type__c = :filterType LIMIT 1',
					new List<String>{ String.join(new List<String>(new Set<String>(fields)), ', ') }
				)
			);

			return sobjectList.size() > 0 ? sobjectList.get(0) : null;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description
	 * @author narathip.s@roundtwosolutions.com | 05-26-2022
	 * @param filterType
	 * @param formPage
	 * @param fields
	 * @return sObject
	 **/
	@AuraEnabled
	public static sObject setMyFilter(String filterType, String formPage, THOR_Filter__c filter) {
		try {
			List<String> fields = getFieldsFilter(formPage);
			fields = fields != null && fields?.size() > 0 ? fields : new List<String>();
			fields.addAll(new List<String>{ 'Id', 'IsActive__c' });

			String userId = UserInfo.getUserId();

			List<sObject> sobjectList = Database.query(
				String.format(
					'SELECT {0} FROM THOR_Filter__c WHERE User__c = :userId AND Filter_type__c = :filterType LIMIT 1',
					new List<String>{ String.join(new List<String>(new Set<String>(fields)), ', ') }
				)
			);

			if (sobjectList.size() > 0) {
				THOR_Filter__c f = (THOR_Filter__c) sobjectList[0];
				Boolean isActive = false;
				for (String field : getFieldsFilter(formPage)) {
					f.put(field, filter.get(field));
					isActive = !isActive && !String.isEmpty(String.valueOf(f.get(field))) ? true : false;
				}
				f.IsActive__c = isActive;
				update f;
			} else {
				filter.User__c = userId;
				filter.Filter_type__c = filterType;
				Boolean isActive = false;
				for (String field : getFieldsFilter(formPage)) {
					if (!isActive && !String.isEmpty(String.valueOf(filter.get(field)))) {
						isActive = true;
					}
				}
				filter.IsActive__c = isActive;
				insert filter;	
			}

			sobjectList = Database.query(
				String.format(
					'SELECT {0} FROM THOR_Filter__c WHERE User__c = :userId AND Filter_type__c = :filterType LIMIT 1',
					new List<String>{ String.join(new List<String>(new Set<String>(fields)), ', ') }
				)
			);
			return sobjectList.size() > 0 ? sobjectList.get(0) : null;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	private static List<String> getFieldsFilter(String formPage) {
		return new Map<String, List<String>>{
				'ODM_NotificationFilter' => new List<String>{
//'Filter_type__c',
					'Notification_Number__c','Notification_Type__c','Functional_Location__c','Main_Work_Center__c', 'Maintenance_Plant__c', 'Create_Date_From__c',
					'Create_Date_To__c','Submission_Date_From__c','Submission_Date_To__c','Description__c','Requester__c'
				},
				'ODM_NotificationSwitchOverFilter' => new List<String>{
//'Filter_type__c',
					'Notification_Number__c','Notification_Type__c','Functional_Location__c','Main_Work_Center__c', 'Maintenance_Plant__c', 'Create_Date_From__c',
					'Create_Date_To__c','Submission_Date_From__c','Submission_Date_To__c','Description__c','Requester__c'
				},
				'ODM_WorkClearanceFilter' => new List<String>{
					'Clearance_Number__c','Work_Clearance_Status__c','Functional_Location__c','Main_Work_Center__c','Create_Date_From__c',
					'Create_Date_To__c','Requested_Date_Form__c','Requested_Date_To__c','Notification_Number__c','Notification_Type__c',
					'Order_Number__c','Order_Type__c','Priority__c','Requester__c','Main_Work_Center__c','Location__c','Area__c','Maintenance_Plant__c'
				},
				'ODM_WorkClearanceVerificationFilter' => new List<String>{
					'Clearance_Number__c','Work_Clearance_Status__c','Functional_Location__c','Main_Work_Center__c','Create_Date_From__c',
					'Create_Date_To__c','Requested_Date_Form__c','Requested_Date_To__c','Notification_Number__c','Notification_Type__c',
					'Order_Number__c','Order_Type__c','Priority__c','Requester__c','Main_Work_Center__c','Location__c','Area__c','Maintenance_Plant__c'
				},
				'ODM_WorkClearanceInspectionFilter' => new List<String>{
					'Clearance_Number__c','Work_Clearance_Status__c','Functional_Location__c','Main_Work_Center__c','Create_Date_From__c',
					'Create_Date_To__c','Requested_Date_Form__c','Requested_Date_To__c','Notification_Number__c','Notification_Type__c',
					'Order_Number__c','Order_Type__c','Priority__c','Requester__c','Main_Work_Center__c','Location__c','Area__c','Maintenance_Plant__c'
				}
			}
			.get(formPage);
	}

	// @AuraEnabled
	// public static sObject getMyFilterODM(String filterType, List<String> fields) {
	// 	try {
	// 		Set<String> uqinueFields = new Set<String>();
	// 		uqinueFields.addAll(fields);
	// 		uqinueFields.addAll(new List<String>{ 'Id', 'IsActive__c' });
	// 		List<String> temp_fields = new List<String>(uqinueFields);
	// 		String userId = UserInfo.getUserId();

	// 		List<sObject> sobjectList = Database.query(
	// 			String.format(
	// 				'SELECT {0} FROM THOR_Filter__c WHERE User__c = :userId AND Filter_type__c = :filterType LIMIT 1',
	// 				new List<String>{ String.join(new List<String>(new Set<String>(temp_fields)), ', ') }
	// 			)
	// 		);
	// 		return sobjectList.size() > 0 ? sobjectList.get(0) : null;
	// 	} catch (Exception e) {
	// 		System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
	// 		throw new AuraHandledException(e.getMessage());
	// 	}
	// }

	@AuraEnabled(cacheable=true)
	public static Object getDescribeFieldResult(String fieldName, String sObjectName) {
		Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe()
			.get(sObjectName?.toLowerCase())
			.getDescribe()
			.fields.getMap();
		Schema.DescribeFieldResult dfr = sObjectField.get(fieldName.trim()).getDescribe();

		return JSON.deserializeUntyped(
			JSON.serialize(
				new Map<String, Object>{
					'name' => dfr.getName(),
					'label' => dfr.getLabel(),
					'type' => dfr.getType(),
					'inlineHelpText' => dfr.getInlineHelpText(),
					'isAccessible' => dfr.isAccessible()
				}
			)
		);
	}

	// private static String conditionQuery(String apiField, String operator, String val) {
	// 	return String.format('{0} {1} {2}', new List<String>{ apiField, operator, '\'' + val + '\'' });
	// }

	@AuraEnabled(cacheable=true)
	public static List<Master_Map__c> getMasterMapByTpye(String filterQuery, String type) {
		String str = filterQuery?.length() > 0 ? filterQuery?.replace('*', '%') : '%';
		if (!str.contains('%')) {
			str = str.startsWith('%') ? str : '%' + str;
			str = str.endsWith('%') ? str : str + '%';
		}

		return [SELECT Id,Type__c,Code__c,Description__c,RelatedMasterMap1__r.Code__c,RelatedMasterMap2__r.Code__c,RelatedMasterMap3__r.Code__c
			FROM Master_Map__c WHERE Type__c = :type AND (Code__c LIKE :str OR Description__c LIKE :str
			OR RelatedMasterMap2__r.Code__c LIKE :str) ORDER BY Code__c ASC, RelatedMasterMap2__r.Code__c ASC];
	}

	@AuraEnabled
	public static List<Master_Map__c> getMasterMapReversed(String code2, String type) {
		type = type.startsWith('%') ? type : '%' + type;

		return [SELECT Id,Type__c,Code__c,Description__c,RelatedMasterMap1__r.Code__c,RelatedMasterMap2__r.Code__c,RelatedMasterMap3__r.Code__c
			FROM Master_Map__c WHERE Type__c LIKE :type AND RelatedMasterMap2__r.Code__c = :code2
			ORDER BY Code__c ASC, RelatedMasterMap2__r.Code__c ASC];
	}

	// public static String conditionQuery(String apiField, String operator, String val) {
	// 	if (operator.equalsIgnoreCase('LIKE')) {
	// 		val = String.valueOf(val).replace('*', '%');
	// 		if (!val.contains('%')) {
	// 			val = '%' + val + '%';
	// 		}
	// 	}
	// 	return;
	// }

	@AuraEnabled(cacheable=true)
	public static List<Object> fetchRecordsRecently(String sObjectName, String searchText, List<String> fieldsFilter) {
		Map<String, SObjectField> sOjectFieldMap = MethodUtils.getAllFieldBySObject(sObjectName);
		List<String> fields = new List<String>(sOjectFieldMap.keySet());

		List<String> filterCondition = new List<String>();
		Set<Id> recentlyIds = new Set<Id>();
		if (String.isEmpty(searchText)) {
			recentlyIds = new Map<Id, RecentlyViewed>(
					[SELECT Id, Name FROM RecentlyViewed WHERE Type = :sObjectName ORDER BY LastViewedDate DESC]
				)
				.keySet();
		} else {
			searchText = searchText.replace('*', '%').trim();
			if (!searchText.contains('%')) {
				searchText = '%' + searchText + '%';
			} else {
				searchText = searchText + '%';
			}
			for (String field : fieldsFilter) {
				if (sOjectFieldMap.containsKey(field) && !field.equalsIgnoreCase('Id')) {
					filterCondition.add(
						String.format('{0} {1} {2}', new List<String>{ field, 'LIKE', '\'' + searchText + '\'' })
					);
					System.debug(String.format('{0} {1} {2}', new List<String>{ field, 'LIKE', '\'' + searchText + '\'' }));
				}
			}
		}

		if (!sObjectName.containsIgnoreCase('__c')) {
			for (Integer i = 0; i < fields.size(); i++) {
				if (!fields.get(i).containsIgnoreCase('__c')) {
					fields.remove(i);
				}
			}
			fields.add('Name');
			fields = new List<String>(new Set<String>(fields));
		}

		Id recordId = searchText?.length() == 18 ? (Id) searchText : null;
		Boolean isRecordId = recordId != null ? recordId?.getSObjectType().getDescribe().getName() != null : false;
		Boolean isPISUsersObject = sObjectName == 'PISUsers__c';
		String query = String.format(
			'SELECT {0} FROM {1} {2} ORDER BY NAME LIMIT 7',
			new List<Object>{
				String.join(fields, ', '),
				sObjectName,
				String.isEmpty(searchText) || filterCondition.size() == 0
					? (recentlyIds.size() > 0
						? isPISUsersObject
							? 'WHERE Id IN :recentlyIds AND FUNCTION__c = \'EVPM\' AND LEVEL__c != \'Junior\' AND Active__c = true'
							: 'WHERE Id IN :recentlyIds'
						: isPISUsersObject
							? 'WHERE Id IN :recentlyIds AND Active__c = true'
							:'')
					: String.format(
							'WHERE {0}',
							isRecordId
								? new List<Object>{ 'Id = :searchText' }
								: isPISUsersObject
									? new List<Object>{ String.join(
										new List<Object>{
											'FUNCTION__c = \'EVPM\'',
											'LEVEL__c != \'Junior\'',
											'Active__c = true',
											String.format(' ({0}) ', new List<Object>{ String.join(filterCondition, ' OR ')})
										}
										, ' AND ')
									}
									: new List<Object>{ String.join(filterCondition, ' OR ') }
					  )
			}
		);
//System.debug(System.LoggingLevel.DEBUG, query);
		return (List<Object>) Database.query(query);
	}

	@AuraEnabled(cacheable=true)
	public static Object getRecordInfo(Id recordId) {
		if (recordId == null) {
			return null;
		}

		String sObjectName = String.valueOf(recordId.getSobjectType());
		String query = String.format(
			'SELECT {0} FROM {1} WHERE Id = :recordId LIMIT 1',
			new List<Object>{
				String.join(new List<String>(MethodUtils.getAllFieldBySObject(sObjectName).keySet()), ', '),
				sObjectName
			}
		);
//System.debug(System.LoggingLevel.DEBUG, query);
		return ((List<Object>) Database.query(query)).get(0);
	}
}