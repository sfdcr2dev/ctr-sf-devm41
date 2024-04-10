public class THOR_NotificationListPagingCtrl {
	public static String datetimeGmtString(String datetimeFormat, Boolean lasted) {
		return String.format('{0}T{1}.000+0700', new List<String>{ datetimeFormat, !lasted ? '00:00:00' : '23:59:59' });
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

	private static List<String> parseNotificationFilterObject(Map<String, Object> filter) {
		if (filter.containsKey('Notification_Type__c'))
			filter.put('Type__c', filter.remove('Notification_Type__c'));
		if (filter.containsKey('Functional_Location__c'))
			filter.put('Functional_Location__r.Name', filter.remove('Functional_Location__c'));
		if (filter.containsKey('Main_Work_Center__c'))
			filter.put('Main_Work_Center__r.Code__c', filter.remove('Main_Work_Center__c'));
		if (filter.containsKey('My_Tasks__c') && (Boolean) filter.get('My_Tasks__c'))
			filter.put('AssignedTo__c', filter.remove('User__c'));
		if (filter.containsKey('Breakdown__c') && (Boolean) filter.get('Breakdown__c'))
			filter.put('Breakdown__c', filter.remove('Breakdown__c'));

		List<String> filterMapping = new List<String>();
		if (filter.containsKey('Create_Date_From__c'))
			filterMapping.add('Requested_Date__c >= ' + String.valueOf(filter.get('Create_Date_From__c')));
		if (filter.containsKey('Create_Date_To__c'))
			filterMapping.add('Requested_Date__c <= ' + String.valueOf(filter.get('Create_Date_To__c')));

		Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe().get('Notification__c'.toLowerCase()).getDescribe().fields.getMap();
		for (String f : filter.keySet()) {
			if (!sObjectField.containsKey(f) && !f.contains('__r')) {
				filter.remove(f);
			}
		}

		for (String apiField : filter.keySet()) {
			Object value = filter.get(apiField);

			if (sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN) {
				filterMapping.add(String.format('{0} {1} {2}', new List<Object>{ apiField, '=', (Boolean) value }));
			} else if (sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE) {
				filterMapping.add(conditionQuery(apiField, '=', String.valueOf(value)));
			} else {
				filterMapping.add(conditionQuery(apiField, 'LIKE', String.valueOf(value)));
			}
		}

		return filterMapping;
	}

	/*
	@AuraEnabled
	public static List<Notification__c> getNewNotificationsByFilter(
		Map<String, Object> filter,
		Integer offset,
		Integer rowlimit,
		List<String> shareIds
	) {
		try {
			List<String> filterMapping = parseNotificationFilterObject(filter);
			shareIds = shareIds.size() == 0 ? MethodUtils.getMysObjectEditAcess('Notification__c') : shareIds;

			String query = String.format(
				'SELECT {0} FROM Notification__c {1} {2} ORDER BY Notification_Number__c DESC {3} {4}',
				new List<String>{
					String.join( // fields
						new List<String>{
							'Id',
							'Name',
							'Notification_Status__c',
							'Type__c',
							'Description__c',
							'Priority__c',
							'Requested_Date__c',
							'Notification_Number__c',
							'CreatedDate',
							'Required_Start__c',
							'Functional_Location__r.Name',
							'Main_Work_Center__r.Name',
							'AssignedTo__c'
						},
						','
					),
					String.format(
						'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''),
						new List<String>{
							String.join(
								new List<String>{ conditionQuery('Notification_Status__c', '=', 'New') },
								' AND '
							)
						}
					),
					filterMapping.size() > 0 // condition (optional)
						? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') })
						: '',
					String.format('LIMIT {0}', new List<String>{ String.valueOf(rowlimit) }),
					String.format('OFFSET {0}', new List<String>{ String.valueOf(offset) })
				}
			);
			System.debug(query);
			return Database.query(query);
		} catch (Exception e) {
			System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
			System.debug(System.LoggingLevel.ERROR, e.getMessage());
			throw new AuraHandledException(e.getMessage());
		}
	}
	
	@AuraEnabled
	public static List<Notification__c> getInProgressNotificationsByFilter(
		Map<String, Object> filter,
		Integer offset,
		Integer rowlimit,
		List<String> shareIds
	) {
		try {
			List<String> filterMapping = parseNotificationFilterObject(filter);
			shareIds = shareIds.size() == 0 ? MethodUtils.getMysObjectEditAcess('Notification__c') : shareIds;

			String query = String.format(
				'SELECT {0} FROM Notification__c {1} {2} ORDER BY Notification_Number__c DESC {3} {4}',
				new List<String>{
					String.join( // fields
						new List<String>{
							'Id',
							'Name',
							'Notification_Status__c',
							'Type__c',
							'Description__c',
							'Priority__c',
							'Requested_Date__c',
							'Notification_Number__c',
							'CreatedDate',
							'Functional_Location__r.Name',
							'Main_Work_Center__r.Name',
							'AssignedTo__c'
						},
						','
					),
					String.format(
						'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''),
						new List<String>{
							String.join(
								new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') },
								' OR '
							)
						}
					),
					filterMapping.size() > 0 // condition (optional)
						? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') })
						: '',
					String.format('LIMIT {0}', new List<String>{ String.valueOf(rowlimit) }),
					String.format('OFFSET {0}', new List<String>{ String.valueOf(offset) })
				}
			);
			System.debug(query);
			return Database.query(query);
		} catch (Exception e) {
			System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
			System.debug(System.LoggingLevel.ERROR, e.getMessage());
			throw new AuraHandledException(e.getMessage());
		}
	}
	
	@AuraEnabled
	public static Integer getCountNewNotificationsByFilter(Map<String, Object> filter, List<String> shareIds) {
		try {
			List<String> filterMapping = parseNotificationFilterObject(filter);
			shareIds = shareIds.size() == 0 ? MethodUtils.getMysObjectEditAcess('Notification__c') : shareIds;

			String query = String.format(
				'SELECT {0} FROM Notification__c {1} {2}',
				new List<String>{
					String.join(new List<String>{ 'COUNT()' }, ','), // fields
					String.format(
						'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''),
						new List<String>{
							String.join(
								new List<String>{
									// 'Id IN :shareIds',
									conditionQuery('Notification_Status__c', '=', 'New')
								},
								' AND '
							)
						}
					),
					filterMapping.size() > 0 // condition (optional)
						? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') })
						: ''
				}
			);
			System.debug(query);
			return Database.countQuery(query);
		} catch (Exception e) {
			System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
			System.debug(System.LoggingLevel.ERROR, e.getMessage());
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Integer getCountInProgressNotificationsByFilter(Map<String, Object> filter, List<String> shareIds) {
		try {
			List<String> filterMapping = parseNotificationFilterObject(filter);
			shareIds = shareIds.size() == 0 ? MethodUtils.getMysObjectEditAcess('Notification__c') : shareIds;

			String query = String.format(
				'SELECT {0} FROM Notification__c {1} {2}',
				new List<String>{
					String.join(new List<String>{ 'COUNT()' }, ','), // fields
					String.format(
						'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''),
						new List<String>{
							String.join(
								new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') },
								' OR '
							)
						}
					),
					filterMapping.size() > 0 // condition (optional)
						? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') })
						: ''
				}
			);
			System.debug(query);
			return Database.countQuery(query);
		} catch (Exception e) {
			System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
			System.debug(System.LoggingLevel.ERROR, e.getMessage());
			throw new AuraHandledException(e.getMessage());
		}
	}
	*/

	@AuraEnabled
	public static List<Notification__c> getNewNotificationsByFilter(Map<String, Object> filter,Integer offset,Integer rowlimit,List<String> shareIds) {
		try {

			List<String> filterMapping = parseNotificationFilterObject(filter);
			// String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Required_Start__c', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'New') }, ' AND ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} {3} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Required_Start__c', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'New') }, ' AND ' ) } ), String.format( 'AND ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Type__c', '=', 'CM'),conditionQuery('Type__c', '=', 'PM'),conditionQuery('Type__c', '=', 'OP'),conditionQuery('Type__c', '=', 'SH'),conditionQuery('Type__c', '=', 'MC'),conditionQuery('Type__c', '=', 'EC'),conditionQuery('Type__c', '=', 'IC') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );

			List<Object> notiAsObjectList = Database.query(query);
			List<Notification__c> notiResultAsObjectList;

			notiResultAsObjectList = new List<Notification__c>();
			for (Object notiAsObject : notiAsObjectList) {
				Notification__c noti = (Notification__c) notiAsObject;
				if (noti.UserRecordAccess.HasEditAccess) {
					notiResultAsObjectList.add(noti);
				}
			}
		
			List<Notification__c> notiPagingResultAsObjectList = new List<Notification__c>();
			for (Integer i = offset; (i < offset + rowlimit) && (i < notiResultAsObjectList.size()); i++) {
				notiPagingResultAsObjectList.add(notiResultAsObjectList[i]);
			}

			return notiPagingResultAsObjectList;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static List<Notification__c> getInProgressNotificationsByFilter(Map<String, Object> filter,Integer offset,Integer rowlimit,List<String> shareIds) {
		try {
			List<String> filterMapping = parseNotificationFilterObject(filter);

			// String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			//20230712String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} {3} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') }, ' OR ' ) } ), String.format( 'AND ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Type__c', '=', 'CM'),conditionQuery('Type__c', '=', 'PM'),conditionQuery('Type__c', '=', 'OP'),conditionQuery('Type__c', '=', 'SH'),conditionQuery('Type__c', '=', 'MC'),conditionQuery('Type__c', '=', 'EC'),conditionQuery('Type__c', '=', 'IC') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} {3} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c',
                'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ),
                String.format( 'WHERE ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') }, ' OR ' ) } ), String.format( 'AND ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Type__c', '=', 'CM'),conditionQuery('Type__c', '=', 'PM'),conditionQuery('Type__c', '=', 'OP'),conditionQuery('Type__c', '=', 'SH'),conditionQuery('Type__c', '=', 'MC'),conditionQuery('Type__c', '=', 'EC'),conditionQuery('Type__c', '=', 'IC') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			List<Object> notiAsObjectList = Database.query(query);
			List<Notification__c> notiResultAsObjectList;
		
			notiResultAsObjectList = new List<Notification__c>();
			for (Object notiAsObject : notiAsObjectList) {
				Notification__c noti = (Notification__c) notiAsObject;
				if (noti.UserRecordAccess.HasEditAccess) {
					notiResultAsObjectList.add(noti);
				}
			}
		
			List<Notification__c> notiPagingResultAsObjectList = new List<Notification__c>();
			for (Integer i = offset; (i < offset + rowlimit) && (i < notiResultAsObjectList.size()); i++) {
				notiPagingResultAsObjectList.add(notiResultAsObjectList[i]);
			}

			return notiPagingResultAsObjectList;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Integer getCountNewNotificationsByFilter(Map<String, Object> filter, List<String> shareIds) {
		try {
			List<String> filterMapping = parseNotificationFilterObject(filter);
			// String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Required_Start__c', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'New') }, ' AND ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} {3} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Required_Start__c', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'New') }, ' AND ' ) } ), String.format( 'AND ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Type__c', '=', 'CM'),conditionQuery('Type__c', '=', 'PM'),conditionQuery('Type__c', '=', 'OP'),conditionQuery('Type__c', '=', 'SH'),conditionQuery('Type__c', '=', 'MC'),conditionQuery('Type__c', '=', 'EC'),conditionQuery('Type__c', '=', 'IC') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );

			List<Object> notiAsObjectList = Database.query(query);
			List<Notification__c> notiResultAsObjectList;

			notiResultAsObjectList = new List<Notification__c>();
			for (Object notiAsObject : notiAsObjectList) {
				Notification__c noti = (Notification__c) notiAsObject;
				if (noti.UserRecordAccess.HasEditAccess) {
					notiResultAsObjectList.add(noti);
				}
			}

			return notiResultAsObjectList.size();
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Integer getCountInProgressNotificationsByFilter(Map<String, Object> filter, List<String> shareIds) {
		try {
			List<String> filterMapping = parseNotificationFilterObject(filter);
			// String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			//20230712String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} {3} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') }, ' OR ' ) } ), String.format( 'AND ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Type__c', '=', 'CM'),conditionQuery('Type__c', '=', 'PM'),conditionQuery('Type__c', '=', 'OP'),conditionQuery('Type__c', '=', 'SH'),conditionQuery('Type__c', '=', 'MC'),conditionQuery('Type__c', '=', 'EC'),conditionQuery('Type__c', '=', 'IC') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} {3} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') }, ' OR ' ) } ), String.format( 'AND ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Type__c', '=', 'CM'),conditionQuery('Type__c', '=', 'PM'),conditionQuery('Type__c', '=', 'OP'),conditionQuery('Type__c', '=', 'SH'),conditionQuery('Type__c', '=', 'MC'),conditionQuery('Type__c', '=', 'EC'),conditionQuery('Type__c', '=', 'IC') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );

			List<Object> notiAsObjectList = Database.query(query);
			List<Notification__c> notiResultAsObjectList;
		
			notiResultAsObjectList = new List<Notification__c>();
			for (Object notiAsObject : notiAsObjectList) {
				Notification__c noti = (Notification__c) notiAsObject;
				if (noti.UserRecordAccess.HasEditAccess) {
					notiResultAsObjectList.add(noti);
				}
			}

			return notiResultAsObjectList.size();
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	private static List<String> parseOrderFilterObject(Map<String, Object> filter) {
		if (filter.containsKey('Functional_Location__c'))
			filter.put('Functional_Location__r.Name', filter.remove('Functional_Location__c'));
		if (filter.containsKey('Main_Work_Center__c'))
			filter.put('Main_Work_Center__r.Code__c', filter.remove('Main_Work_Center__c'));

		List<String> filterMapping = new List<String>();
		if (filter.containsKey('Create_Date_From__c'))
			filterMapping.add('Requested_Date__c >= ' + String.valueOf(filter.get('Create_Date_From__c')));
		if (filter.containsKey('Create_Date_To__c'))
			filterMapping.add('Requested_Date__c <= ' + String.valueOf(filter.get('Create_Date_To__c')));

		if (filter.containsKey('Responsible_Person__c')) {
			String val = String.valueOf(filter.remove('Responsible_Person__c'));
		 filterMapping.add( String.format( '({0} OR {1})', new List<String>{ conditionQuery('Responsible_person__r.Employee_Id__c', 'LIKE', val), conditionQuery('ResponsiblePersonText__c', 'LIKE', val) } ) );
		}

		Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe() .get('Order__c'.toLowerCase()) .getDescribe() .fields .getMap();
		for (String f : filter.keySet()) {
			if (!sObjectField.containsKey(f) && !f.contains('__r')) {
				filter.remove(f);
			}
		}

		for (String apiField : filter.keySet()) {
			Object value = filter.get(apiField);

			if (sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN) {
				filterMapping.add(String.format('{0} {1} {2}', new List<Object>{ apiField, '=', (Boolean) value }));
			} else if (sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE) {
				filterMapping.add(conditionQuery(apiField, '=', String.valueOf(value)));
			} else {
				filterMapping.add(conditionQuery(apiField, 'LIKE', String.valueOf(value)));
			}
		}

		return filterMapping;
	}

	@AuraEnabled
	public static List<Order__c> getNewOrdersByFilter( Map<String, Object> filter, Integer offset, Integer rowlimit, List<String> shareIds ) {
		try {
			List<String> filterMapping = parseOrderFilterObject(filter);

			String query = String.format( 'SELECT {0} FROM Order__c {1} {2} ORDER BY Order_Number__c DESC' , new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Order_Status__c', 'Order_Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Order_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'Responsible_person__c', 'UserRecordAccess.HasEditAccess' }, ',' ) , String.format( 'WHERE ({0})', new List<String>{ String.join(new List<String>{ conditionQuery('Order_Status__c', '=', 'New') }, ' OR ') } ) , filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			//20230712String query = String.format( 'SELECT {0} FROM Order__c {1} {2} ORDER BY Order_Number__c DESC {3} {4}', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Order_Status__c', 'Order_Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Order_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'Responsible_person__c' }, ',' ), String.format( 'WHERE ({0})', new List<String>{ String.join(new List<String>{ conditionQuery('Order_Status__c', '=', 'New') }, ' OR ') } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '', String.format('LIMIT {0}', new List<String>{ String.valueOf(rowlimit) }), String.format('OFFSET {0}', new List<String>{ String.valueOf(offset) }) } );
			List<Object> orderAsObjectList = Database.query(query);
			List<Order__c> orderResultAsObjectList;
		
			orderResultAsObjectList = new List<Order__c>();
			for (Object orderAsObject : orderAsObjectList) {
				Order__c order = (Order__c) orderAsObject;
				if (order.UserRecordAccess.HasEditAccess) {
					orderResultAsObjectList.add(order);
				}
			}
		
			List<Order__c> orderPagingResultAsObjectList = new List<Order__c>();
			for (Integer i = offset; (i < offset + rowlimit) && (i < orderResultAsObjectList.size()); i++) {
				orderPagingResultAsObjectList.add(orderResultAsObjectList[i]);
			}

			return orderPagingResultAsObjectList;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static List<Order__c> getInProgressOrdersByFilter( Map<String, Object> filter, Integer offset, Integer rowlimit, List<String> shareIds ) {
		try {
			List<String> filterMapping = parseOrderFilterObject(filter);

			String query = String.format( 'SELECT {0} FROM Order__c {1} {2} ORDER BY Order_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Order_Status__c', 'Order_Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Order_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'Responsible_person__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Order_Status__c', '=', 'In Progress') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			//20230712String query = String.format( 'SELECT {0} FROM Order__c {1} {2} ORDER BY Order_Number__c DESC {3} {4}', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Order_Status__c', 'Order_Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Order_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'Responsible_person__c' }, ',' ), String.format( 'WHERE ({0})' , new List<String>{ String.join( new List<String>{ conditionQuery('Order_Status__c', '=', 'In Progress') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '', String.format('LIMIT {0}', new List<String>{ String.valueOf(rowlimit) }), String.format('OFFSET {0}', new List<String>{ String.valueOf(offset) }) } );
			List<Object> orderAsObjectList = Database.query(query);
			List<Order__c> orderResultAsObjectList;
		
			orderResultAsObjectList = new List<Order__c>();
			for (Object orderAsObject : orderAsObjectList) {
				Order__c order = (Order__c) orderAsObject;
				if (order.UserRecordAccess.HasEditAccess) {
					orderResultAsObjectList.add(order);
				}
			}
		
			List<Order__c> orderPagingResultAsObjectList = new List<Order__c>();
			for (Integer i = offset; (i < offset + rowlimit) && (i < orderResultAsObjectList.size()); i++) {
				orderPagingResultAsObjectList.add(orderResultAsObjectList[i]);
			}

			return orderPagingResultAsObjectList;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Integer getCountNewOrdersByFilter(Map<String, Object> filter, List<String> shareIds) {
		try {
			List<String> filterMapping = parseOrderFilterObject(filter);
			// String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			//20230712String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} {3} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') }, ' OR ' ) } ), String.format( 'AND ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Type__c', '=', 'CM'),conditionQuery('Type__c', '=', 'PM'),conditionQuery('Type__c', '=', 'OP'),conditionQuery('Type__c', '=', 'SH'),conditionQuery('Type__c', '=', 'MC'),conditionQuery('Type__c', '=', 'EC'),conditionQuery('Type__c', '=', 'IC') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			String query = String.format( 'SELECT {0} FROM Order__c {1} {2}', new List<String>{ String.join(new List<String>{ 'Id', 'UserRecordAccess.HasEditAccess' }, ','), String.format( 'WHERE ({0})' , new List<String>{ String.join(new List<String>{ conditionQuery('Order_Status__c', '=', 'New') }, ' OR ') } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );

			List<Object> orderAsObjectList = Database.query(query);
			List<Order__c> orderResultAsObjectList;
		
			orderResultAsObjectList = new List<Order__c>();
			for (Object orderAsObject : orderAsObjectList) {
				Order__c order = (Order__c) orderAsObject;
				if (order.UserRecordAccess.HasEditAccess) {
					orderResultAsObjectList.add(order);
				}
			}

			return orderResultAsObjectList.size();
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Integer getCountInProgressOrdersByFilter(Map<String, Object> filter, List<String> shareIds) {
		try {
			List<String> filterMapping = parseOrderFilterObject(filter);
			// String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			//20230712String query = String.format( 'SELECT {0} FROM Notification__c {1} {2} {3} ORDER BY Notification_Number__c DESC', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c', 'UserRecordAccess.HasEditAccess' }, ',' ), String.format( 'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ conditionQuery('Notification_Status__c', '=', 'In Progress') }, ' OR ' ) } ), String.format( 'AND ({0})', new List<String>{ String.join( new List<String>{ conditionQuery('Type__c', '=', 'CM'),conditionQuery('Type__c', '=', 'PM'),conditionQuery('Type__c', '=', 'OP'),conditionQuery('Type__c', '=', 'SH'),conditionQuery('Type__c', '=', 'MC'),conditionQuery('Type__c', '=', 'EC'),conditionQuery('Type__c', '=', 'IC') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			String query = String.format( 'SELECT {0} FROM Order__c {1} {2}', new List<String>{ String.join(new List<String>{ 'Id', 'UserRecordAccess.HasEditAccess' }, ','), String.format( 'WHERE ({0})' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ conditionQuery('Order_Status__c', '=', 'In Progress') }, ' OR ' ) } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );

			List<Object> orderAsObjectList = Database.query(query);
			List<Order__c> orderResultAsObjectList;
		
			orderResultAsObjectList = new List<Order__c>();
			for (Object orderAsObject : orderAsObjectList) {
				Order__c order = (Order__c) orderAsObject;
				if (order.UserRecordAccess.HasEditAccess) {
					orderResultAsObjectList.add(order);
				}
			}

			return orderResultAsObjectList.size();
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	private static List<String> parseWorkClearanceFilterObject(Map<String, Object> filter) {
		List<String> filterMapping = new List<String>();
		if (filter.containsKey('Clearance_Number__c'))
			filter.put('Name', filter.remove('Clearance_Number__c'));
		if (filter.containsKey('Work_Clearance_Status__c'))
			filter.put('Work_Clearance_Status__c', filter.remove('Work_Clearance_Status__c'));
		if (filter.containsKey('Functional_Location__c'))
			filter.put('Functional_Location__c', filter.remove('Functional_Location__c'));
		if (filter.containsKey('Create_Date_From__c'))
			filterMapping.add('CreatedDate >= ' + datetimeGmtString(String.valueOf(filter.get('Create_Date_From__c')), false));
		if (filter.containsKey('Create_Date_To__c'))
			filterMapping.add('CreatedDate <= ' + datetimeGmtString(String.valueOf(filter.get('Create_Date_To__c')), true));
		if (filter.containsKey('Notification_Number__c'))
			filter.put('Notification__r.Notification_Number__c', filter.remove('Notification_Number__c'));
		if (filter.containsKey('Notification_Type__c'))
			filter.put('Notification__r.Type__c', filter.remove('Notification_Type__c'));
		if (filter.containsKey('Order_Number__c'))
			filter.put('Order__r.Order_Number__c', filter.remove('Order_Number__c'));
		if (filter.containsKey('Order_Type__c'))
			filter.put('Order__r.Order_Type__c', filter.remove('Order_Type__c'));
		if (filter.containsKey('Priority__c'))
			filter.put('Priority_Map__c', filter.remove('Priority__c'));
		if (filter.containsKey('Location__c'))
			filter.put('Location__c', filter.remove('Location__c'));
		if (filter.containsKey('Main_Work_Center__c'))
			filter.put('Main_Work_Center_Text__c', filter.remove('Main_Work_Center__c'));
		if (filter.containsKey('Requester__c')) {
			String Requester = String.valueOf(filter.remove('Requester__c')); // Employee Id or Fullname
			Requester = Requester.replace('*', '%');
			if (!Requester.contains('%')) {
				Requester = '%' + Requester + '%';
			}

			List<String> users = new List<String>();
			for (User u : [SELECT Id, Name, Employee_Id__c FROM User WHERE Employee_Id__c LIKE :Requester LIMIT 10]) {
				users.add('\'' + u.Name + '\'');
			}

			if (users.size() > 0) {
				filterMapping.add( String.format( '({0} OR {1} OR Requester__c IN ({2}))', new List<String>{ conditionQuery('Requester__c', 'LIKE', Requester), conditionQuery('Requester_UI__r.EN_Fullname__c', 'LIKE', Requester), String.join(users, ',') } ) );
			} else {
				filterMapping.add( String.format( '({0} OR {1})', new List<String>{ conditionQuery('Requester__c', 'LIKE', Requester), conditionQuery('Requester_UI__r.EN_Fullname__c', 'LIKE', Requester) } ) );
			}
		}

		Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe() .get('Work_Clearance__c'.toLowerCase()) .getDescribe() .fields .getMap();
		for (String f : filter.keySet()) {
			if (!sObjectField.containsKey(f) && !f.contains('__r')) {
				filter.remove(f);
			}
		}

		for (String apiField : filter.keySet()) {
			Object value = filter.get(apiField);

			if (sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN) {
				filterMapping.add(String.format('{0} {1} {2}', new List<Object>{ apiField, '=', (Boolean) value }));
			} else if (sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE) {
				filterMapping.add(conditionQuery(apiField, '=', String.valueOf(value)));
			} else {
				filterMapping.add(conditionQuery(apiField, 'LIKE', String.valueOf(value)));
			}
		}

		return filterMapping;
	}

	@AuraEnabled
	public static List<Work_Clearance__c> getWithoutNotiAndOrderWorkClearancesByFilter(Map<String, Object> filter,Integer offset,Integer rowlimit) {
		try {
			List<String> filterMapping = parseWorkClearanceFilterObject(filter);
			List<String> shareIds = MethodUtils.getMysObjectEditAcess('Work_Clearance__c');
			String query = String.format( 'SELECT {0} FROM Work_Clearance__c {1} {2} ORDER BY CreatedDate DESC {3} {4}', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Extend_No__c', 'Description__c', 'Priority__c', 'Priority_Map__c', 'Functional_Location__c', 'Main_Work_Center__r.Name', 'Notification__r.Name', 'Order__r.Name', 'CreatedDate' }, ',' ), String.format( 'WHERE ({0}) AND ({1}) ' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ 'System_Status__c = \'CRTE\'', 'System_Status__c = \'PREP\'' }, ' OR ' ), String.join(new List<String>{ 'Notification__c = null', 'Order__c = null' }, ' AND ') } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '', String.format('LIMIT {0}', new List<String>{ String.valueOf(rowlimit) }), String.format('OFFSET {0}', new List<String>{ String.valueOf(offset) }) } );

            return (List<Work_Clearance__c>) Database.query(query);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static List<Work_Clearance__c> getInProgressWorkClearancesByFilter(Map<String, Object> filter,Integer offset,Integer rowlimit) {
		try {
			List<String> filterMapping = parseWorkClearanceFilterObject(filter);
			List<String> shareIds = MethodUtils.getMysObjectEditAcess('Work_Clearance__c');
			String query = String.format( 'SELECT {0} FROM Work_Clearance__c {1} {2} ORDER BY CreatedDate DESC {3} {4}', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Description__c', 'Extend_No__c', 'toLabel(Priority__c)', 'Priority_Map__c', 'Functional_Location__c', 'Main_Work_Center__r.Name', 'Notification__r.Name', 'Order__r.Name', 'CreatedDate' }, ',' ), String.format( 'WHERE ({0}) AND ({1}) ' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ 'System_Status__c = \'CRTE\'', 'System_Status__c = \'PREP\'' }, ' OR ' ), String.join(new List<String>{ 'Notification__c != null', 'Order__c != null' }, ' OR ') } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '', String.format('LIMIT {0}', new List<String>{ String.valueOf(rowlimit) }), String.format('OFFSET {0}', new List<String>{ String.valueOf(offset) }) } );

            return (List<Work_Clearance__c>) Database.query(query);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Integer getCountWithoutNotiAndOrderWorkClearancesByFilter(Map<String, Object> filter) {
		try {
			List<String> filterMapping = parseWorkClearanceFilterObject(filter);
			List<String> shareIds = MethodUtils.getMysObjectEditAcess('Work_Clearance__c');
			String query = String.format( 'SELECT {0} FROM Work_Clearance__c {1} {2}', new List<String>{ String.join(new List<String>{ 'COUNT()' }, ','), String.format( 'WHERE ({0}) AND ({1}) ' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ 'System_Status__c = \'CRTE\'', 'System_Status__c = \'PREP\'' }, ' OR ' ), String.join(new List<String>{ 'Notification__c = null', 'Order__c = null' }, ' AND ') } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );

            return Database.countQuery(query);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Integer getCountInProgressWorkClearancesByFilter(Map<String, Object> filter) {
		try {
			List<String> filterMapping = parseWorkClearanceFilterObject(filter);
			List<String> shareIds = MethodUtils.getMysObjectEditAcess('Work_Clearance__c');
			String query = String.format( 'SELECT {0} FROM Work_Clearance__c {1} {2}', new List<String>{ String.join(new List<String>{ 'COUNT()' }, ','), String.format( 'WHERE ({0}) AND ({1}) ' + (shareIds.size() > 0 ? 'AND Id IN :shareIds' : ''), new List<String>{ String.join( new List<String>{ 'System_Status__c = \'CRTE\'', 'System_Status__c = \'PREP\'' }, ' OR ' ), String.join(new List<String>{ 'Notification__c != null', 'Order__c != null' }, ' OR ') } ), filterMapping.size() > 0 ? String.format('AND {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );

            return Database.countQuery(query);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	private static List<String> parseEqccFilter(Map<String, String> filterMap) {
		if (filterMap.containsKey('Check_Sheet_Code__c')) {
			filterMap.put('Sheet__r.Sheet_Code__c', filterMap.remove('Check_Sheet_Code__c'));
		}
		if (filterMap.containsKey('Check_Sheet_Name__c')) {
			filterMap.put('Sheet__r.Form_Name__c', filterMap.remove('Check_Sheet_Name__c'));
		}
		if (filterMap.containsKey('Equipment__c')) {
			filterMap.put('Header__r.Equipment__r.Name', filterMap.remove('Equipment__c'));
		}
		if (filterMap.containsKey('Notification_Number__c')) {
			filterMap.put('Header__r.Notification__r.Notification_Number__c',filterMap.remove('Notification_Number__c'));
		}
		if (filterMap.containsKey('Functional_Location__c')) {
			filterMap.put('Header__r.FunctionalLocation__r.Name', filterMap.remove('Functional_Location__c'));
		}
		if (filterMap.containsKey('Order_Number__c')) {
			filterMap.put('Header__r.Order__r.Order_Number__c', filterMap.remove('Order_Number__c'));
		}
		if (filterMap.containsKey('Maintenance_Plant__c')) {
			filterMap.put('Header__r.Maintenance_PlantText__c', filterMap.remove('Maintenance_Plant__c'));
		}
		if (filterMap.containsKey('Location__c')) {
			filterMap.put('Header__r.LocationText__c', filterMap.remove('Location__c'));
		}
		if (filterMap.containsKey('Plant_Section__c')) {
			filterMap.put('Header__r.Plant_SectionText__c', filterMap.remove('Plant_Section__c'));
		}
		if (filterMap.containsKey('Main_Work_Center__c')) {
			filterMap.put('Header__r.Main_Work_CenterText__c', filterMap.remove('Main_Work_Center__c'));
		}

		List<String> filterCondition = new List<String>();
		if (filterMap.containsKey('Create_Date_From__c')) {
			filterCondition.add('CreatedDate >= ' + datetimeGmtString(String.valueOf(filterMap.get('Create_Date_From__c')), false));
		}
		if (filterMap.containsKey('Create_Date_To__c')) {
			filterCondition.add('CreatedDate <= ' + datetimeGmtString(String.valueOf(filterMap.get('Create_Date_To__c')), true));
		}
		if (filterMap.containsKey('Requester__c')) {
			String requester = String.valueOf(filterMap.remove('Requester__c')).replace('*', '%'); // Employee Id or Fullname
			if (!requester.contains('%')) {
				requester = '%' + requester + '%';
			}
			String employeeId = requester;
			List<String> users = new List<String>();
			for (User u : [ SELECT Id, Name, Employee_Id__c FROM User WHERE Employee_Id__c LIKE :employeeId WITH SECURITY_ENFORCED LIMIT 7 ]) {
				users.add('\'' + u.Name + '\'');
			}
			if (users.size() > 0) {
				filterCondition.add(String.format('({0} OR Requester__c IN ({1}))',new List<String>{ conditionQuery('Requester__c', 'LIKE', requester), String.join(users, ',') }));
			} else {
				filterCondition.add(String.format('({0})', new List<String>{ conditionQuery('Requester__c', 'LIKE', requester) }));
			}
		}

		Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe().get('Header_Sheet__c'.toLowerCase()).getDescribe().fields.getMap();
		for (String f : filterMap.keySet()) {
			if (!sObjectField.containsKey(f) && !f.contains('__r')) {
				filterMap.remove(f);
			}
		}

		for (String keyApiName : filterMap.keySet()) {
			Object value = filterMap.get(keyApiName);
			if (value == null)
				continue;
			if (sObjectField.get(keyApiName)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN) {
				filterCondition.add(String.format('{0} {1} {2}', new List<Object>{ keyApiName, '=', (Boolean) value }));
			} else if (sObjectField.get(keyApiName)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE) {
				filterCondition.add(conditionQuery(keyApiName, '=', String.valueOf(value)));
			} else {
				filterCondition.add(conditionQuery(keyApiName, 'LIKE', String.valueOf(value)));
			}
		}
		return filterCondition;
	}

	@AuraEnabled
	public static Map<Id /** HeaderSheetId */, EQCC_Step__c> getEqccCurrentStep(List<String> headerSheetIds) {
		Map<Id, EQCC_Step__c> eqccStepMap = new Map<Id, EQCC_Step__c>();
		for (EQCC_Step__c step : [ SELECT Id, Header_Sheet__c, Form_Group__c, Is_Current__c, Percentage__c FROM EQCC_Step__c WHERE Header_Sheet__c IN :headerSheetIds AND Is_Current__c = TRUE AND IsDeleted__c = FALSE WITH SECURITY_ENFORCED ORDER BY Step_Number__c DESC ]) {
			eqccStepMap.put(step.Header_Sheet__c, step);
		}
		return eqccStepMap;
	}

	@AuraEnabled
	public static List<Object> getWithoutNotificationOrOrderEQCCsByFilter(Map<String, String> filter,Integer offset,Integer rowlimit) {
		List<String> filterCondition = parseEqccFilter(filter);
		List<String> shareIds = MethodUtils.getMysObjectEditAcess('EQCC_Header__c');
		String query = String.format( 'SELECT {0} FROM EQCC_Header__c WHERE IsDeleted__c = FALSE AND Notification__c = NULL AND Order__c = NULL {1} ORDER BY CreatedDate DESC {2} {3}', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'FunctionalLocation__r.Name', 'Equipment__r.Name', 'Notification__c', 'Notification__r.Notification_Number__c', 'Notification__r.Description__c', 'Order__c', 'Order__r.Order_Number__c', 'Order__r.Description__c', String.format( '(SELECT {0} FROM Header_Sheets__r WHERE isManuallyCreated__c = TRUE AND IsDeleted__c = FALSE AND Status__c != \'Rejected\' {1})', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Status__c', 'Sheet__c', 'Sheet__r.Sheet_Code__c', 'Sheet__r.Form_Name__c', 'Requester__c', 'isManuallyCreated__c', 'CreatedDate', 'LastModifiedDate', 'isPolluted__c' }, ', ' ), filterCondition.size() > 0 ? 'AND ' + String.join(filterCondition, ' AND ') : '' } ) }, ', ' ), String.format( 'AND Id IN (SELECT Header__c FROM Header_Sheet__c WHERE isManuallyCreated__c = TRUE AND IsDeleted__c = FALSE AND Status__c != \'Rejected\' {0}) {1}', new List<String>{ filterCondition.size() > 0 ? 'AND ' + String.join(filterCondition, ' AND ') : '', shareIds.size() > 0 ? 'AND Id IN :shareIds' : '' } ), 'LIMIT :rowlimit', 'OFFSET :offset' } );

        return (List<Object>) Database.query(query);
	}

	@AuraEnabled
	public static List<Object> getInProgressEQCCsByFilter(Map<String, String> filter,Integer offset,Integer rowlimit) {
		List<String> filterCondition = parseEqccFilter(filter);
		List<String> shareIds = MethodUtils.getMysObjectEditAcess('EQCC_Header__c');
		String query = String.format( 'SELECT {0} FROM EQCC_Header__c WHERE IsDeleted__c = FALSE AND (Notification__c != NULL OR Order__c != NULL) {1} ORDER BY CreatedDate DESC {2} {3}', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'FunctionalLocation__r.Name', 'Equipment__r.Name', 'Notification__c', 'Notification__r.Notification_Number__c', 'Notification__r.Description__c', 'Order__c', 'Order__r.Order_Number__c', 'Order__r.Description__c', String.format( '(SELECT {0} FROM Header_Sheets__r WHERE isManuallyCreated__c = TRUE AND IsDeleted__c = FALSE AND (NOT Status__c IN (\'Approved\', \'Rejected\')) {1})', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Status__c', 'Sheet__c', 'Sheet__r.Sheet_Code__c', 'Sheet__r.Form_Name__c', 'Requester__c', 'isManuallyCreated__c', 'CreatedDate', 'LastModifiedDate', 'isPolluted__c' }, ', ' ), filterCondition.size() > 0 ? 'AND ' + String.join(filterCondition, ' AND ') : '' } ) }, ', ' ), String.format( 'AND Id IN (SELECT Header__c FROM Header_Sheet__c WHERE isManuallyCreated__c = TRUE AND IsDeleted__c = FALSE AND (NOT Status__c IN (\'Approved\', \'Rejected\')) {0}) {1}', new List<String>{ filterCondition.size() > 0 ? 'AND ' + String.join(filterCondition, ' AND ') : '', shareIds.size() > 0 ? 'AND Id IN :shareIds' : '' } ), 'LIMIT :rowlimit', 'OFFSET :offset' } );

        return (List<Object>) Database.query(query);
	}

	@AuraEnabled
	public static Integer getCountWithoutNotificationOrOrderEQCCsByFilter(Map<String, String> filter) {
		List<String> filterCondition = parseEqccFilter(filter);
		List<String> shareIds = MethodUtils.getMysObjectEditAcess('EQCC_Header__c');
		String query = String.format( 'SELECT COUNT() FROM EQCC_Header__c WHERE IsDeleted__c = FALSE AND Notification__c = NULL AND Order__c = NULL {0}', new List<String>{ String.format( 'AND Id IN (SELECT Header__c FROM Header_Sheet__c WHERE isManuallyCreated__c = TRUE AND IsDeleted__c = FALSE AND Status__c != \'Rejected\' {0}) {1}', new List<String>{ filterCondition.size() > 0 ? 'AND ' + String.join(filterCondition, ' AND ') : '', shareIds.size() > 0 ? 'AND Id IN :shareIds' : '' } ) } );

        return (Integer) Database.countQuery(query);
	}

	@AuraEnabled
	public static Integer getCountInProgressEQCCsByFilter(Map<String, String> filter) {
		List<String> filterCondition = parseEqccFilter(filter);
		List<String> shareIds = MethodUtils.getMysObjectEditAcess('EQCC_Header__c');
		String query = String.format( 'SELECT COUNT() FROM EQCC_Header__c WHERE IsDeleted__c = FALSE AND (Notification__c != NULL OR Order__c != NULL) {0}', new List<String>{ String.format( 'AND Id IN (SELECT Header__c FROM Header_Sheet__c WHERE isManuallyCreated__c = TRUE AND IsDeleted__c = FALSE AND (NOT Status__c IN (\'Approved\', \'Rejected\')) {0}) {1}', new List<String>{ filterCondition.size() > 0 ? 'AND ' + String.join(filterCondition, ' AND ') : '', shareIds.size() > 0 ? 'AND Id IN :shareIds' : '' } ) } );

        return (Integer) Database.countQuery(query);
	}
}