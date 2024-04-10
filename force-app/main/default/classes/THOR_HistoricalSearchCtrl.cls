public with sharing class THOR_HistoricalSearchCtrl {
	private static final Integer LIMITMAX_CONST = 400;

	public static String datetimeGmtString(String datetimeFormat, Boolean lasted) {
		return String.format('{0}T{1}.000+0700', new List<String>{ datetimeFormat, !lasted ? '00:00:00' : '23:59:59' });
	}

	@AuraEnabled
	public static Object getMyFilterHistoricalSearch(String filterType, List<String> fields) {
		Id userId = UserInfo.getUserId();
		fields.add('Id');
		Set<String> fieldSets = new Set<String>(fields);
		THOR_Filter__c filterValues = (THOR_Filter__c) Database.query(String.format('SELECT {0} FROM THOR_Filter__c WHERE User__c = :userId AND Filter_type__c = :filterType LIMIT 1',new List<String>{ String.join(fields, ', ') }));
		return filterValues;
	}

	private static String conditionQuery(String apiField, String operator, String val) {
		if (operator.equalsIgnoreCase('LIKE')) {
			val = String.valueOf(val).replace('*', '%');
			if (!val.contains('%')) val = '%' + val + '%';
		}
		return String.format('{0} {1} {2}', new List<String>{ apiField, operator, '\'' + val + '\'' });
	}

	@AuraEnabled
	public static List<HeaderSheetWrapper> getInProgressEQCCFilter(Map<String, Object> filterMap,Integer offset,Integer rowlimit) {
		List<Header_Sheet__c> headerSheets = getInProgressHeaderSheetsFilter(filterMap, offset, rowlimit);
		Map<Id, EQCC_Header__c> headers = getHeadersFromHeaderSheets(headerSheets);
		Map<Id, EQCC_Checked_Sheet__c> sheets = getSheetsFromHeaderSheets(headerSheets, headers.keySet());
		Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = buildSheetsByHeader(headers,headerSheets,sheets);
		return createHeaderSheetWrapper(sheetsByHeader);
	}
	@AuraEnabled
	public static Integer getCountNewOrdersByFilter(String recordId) {
		try {
			THOR_Filter__c savedFilters = [SELECT Id, Name, Filter_type__c, Notification_Number__c, NotificationTypeMulti__c, Functional_Location__c, Create_Date_To__c, Create_Date_From__c, StatusMulti__c, PriorityMulti__c, Main_Work_Center__c, Plant_Section__c, Maintenance_Plant__c, Location__c, Breakdown__c, Order_Number__c, OrderTypeMulti__c, Super_Order__c, Clearance_Number__c, Requested_Date_Form__c, Requested_Date_To__c, Created_By__c, Equipment__c, EQCC_Code__c, EQCC_Name__c FROM THOR_Filter__c WHERE Id = :recordId LIMIT 1];

			Map<String, Object> filter = new Map<String, Object>();
			filter.put('Functional_Location__c', savedFilters.Functional_Location__c);
			filter.put('Notification_Number__c', savedFilters.Notification_Number__c);
			filter.put('Order_Number__c', savedFilters.Order_Number__c);
			filter.put('Main_Work_Center__c', savedFilters.Main_Work_Center__c);
			filter.put('Maintenance_Plant__c', savedFilters.Maintenance_Plant__c);
			filter.put('Plant_Section__c', savedFilters.Plant_Section__c);
			filter.put('Location__c', savedFilters.Location__c);
			filter.put('Create_Date_To__c', savedFilters.Create_Date_To__c);
			filter.put('Create_Date_From__c', savedFilters.Create_Date_From__c);
			filter.put('Priority__c', savedFilters.PriorityMulti__c);
			filter.put('Super_Order__c', savedFilters.Super_Order__c);
			filter.put('Order_Status__c', savedFilters.StatusMulti__c);
			filter.put('Order_Type__c', savedFilters.OrderTypeMulti__c);
			for (String key : filter.keySet()) {
				if (filter.get(key) == null || filter.get(key) == '') filter.remove(key);
			}
			if (filter.containsKey('Notification_Number__c')) filter.put('Notification__r.Notification_Number__c', filter.remove('Notification_Number__c'));
			if (filter.containsKey('Super_Order__c')) filter.put('Super_Order__r.Name', filter.remove('Super_Order__c'));
			if (filter.containsKey('Functional_Location__c')) filter.put('Functional_Location__r.Name', filter.remove('Functional_Location__c'));
			if (filter.containsKey('Main_Work_Center__c')) filter.put('Main_Work_Center__r.Code__c', filter.remove('Main_Work_Center__c'));
			List<String> filterMapping = new List<String>();
            if(filter.containsKey('Create_Date_From__c')){
                String tempDate = String.valueOf(filter.get('Create_Date_From__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate >= ' + datetimeGmtString(onlyDate, false));
                filter.remove('Create_Date_From__c');
            }
            if(filter.containsKey('Create_Date_To__c')){
                String tempDate = String.valueOf(filter.get('Create_Date_To__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate <= ' + datetimeGmtString(onlyDate, true));
                filter.remove('Create_Date_To__c');
            }
			if (filter.containsKey('Order_Type__c')) {
				String[] arrNoti = String.valueOf(filter.remove('Order_Type__c')).split(';');
				String notificationTypeMulti = '\'' + String.join(arrNoti, '\',\'') + '\'';
				filterMapping.add('Order_Type__c IN (' + notificationTypeMulti + ')');
			}
			if (filter.containsKey('Order_Status__c')) {
				String[] arrStatus = String.valueOf(filter.remove('Order_Status__c')).split(';');
				String statusMulti = '\'' + String.join(arrStatus, '\',\'') + '\'';
				filterMapping.add('Order_Status__c IN (' + statusMulti + ')');
			}
			if (filter.containsKey('Priority__c')) {
				String[] arrPriority = String.valueOf(filter.remove('Priority__c')).split(';');
				String priorityMulti = '\'' + String.join(arrPriority, '\',\'') + '\'';
				filterMapping.add('Priority__c IN (' + priorityMulti + ')');
			}
			Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe().get('Order__c'.toLowerCase()).getDescribe().fields.getMap();
			for (String f : filter.keySet()) {
				if (!sObjectField.containsKey(f) && !f.contains('__r')) filter.remove(f);
			}
			for (String apiField : filter.keySet()) {
				Object value = filter.get(apiField);
				filterMapping.add((sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN)? String.format('{0} {1} {2}', new List<Object>{ apiField, '=', (Boolean) value }) :(sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE)? conditionQuery(apiField, '=', String.valueOf(value)) :conditionQuery(apiField, 'LIKE', String.valueOf(value)));
			}
			String query = String.format('SELECT {0} FROM Order__c {1}  ',new List<String>{String.join(new List<String>{ 'COUNT()' }, ','),filterMapping.size() > 0? String.format('WHERE {0}', new List<Object>{ String.join(filterMapping, ' AND ') }): ''});
			return Database.countQuery(query);
		} catch (Exception e) {throw new AuraHandledException(e.getMessage());}
	}

	@AuraEnabled
	public static Integer getCountNewWorkClearanceByFilter(String recordId) {
		try {
			THOR_Filter__c savedFilters = [SELECT Id,Name,Filter_type__c,Notification_Number__c,NotificationTypeMulti__c,Functional_Location__c,Create_Date_To__c,Create_Date_From__c,StatusMulti__c,PriorityMulti__c,Main_Work_Center__c,Plant_Section__c,Maintenance_Plant__c,Location__c,Breakdown__c,Order_Number__c,OrderTypeMulti__c,Super_Order__c,Clearance_Number__c,Requested_Date_Form__c,Requested_Date_To__c,Created_By__c,Equipment__c,EQCC_Code__c,EQCC_Name__c,Work_Clearance_Status__c FROM THOR_Filter__c WHERE Id = :recordId LIMIT 1];
			Map<String, Object> filterMap = new Map<String, Object>();
			filterMap.put('Functional_Location__c',savedFilters.Functional_Location__c);
			filterMap.put('Notification_Number__c',savedFilters.Notification_Number__c);
			filterMap.put('Order_Number__c',savedFilters.Order_Number__c);
			filterMap.put('Main_Work_Center__c',savedFilters.Main_Work_Center__c);
			filterMap.put('Maintenance_Plant__c',savedFilters.Maintenance_Plant__c);
			filterMap.put('Plant_Section__c',savedFilters.Plant_Section__c);
			filterMap.put('Location__c',savedFilters.Location__c);
			filterMap.put('Create_Date_To__c',savedFilters.Create_Date_To__c);
			filterMap.put('Create_Date_From__c',savedFilters.Create_Date_From__c);
			filterMap.put('Maintenance_Plant__c',savedFilters.Maintenance_Plant__c);
			filterMap.put('Status__c',savedFilters.StatusMulti__c);
			filterMap.put('Clearance_Number__c',savedFilters.Clearance_Number__c);
			filterMap.put('Requested_Date_Form__c',savedFilters.Requested_Date_Form__c);
			filterMap.put('Requested_Date_To__c',savedFilters.Requested_Date_To__c);
			filterMap.put('Notification_Type__c',savedFilters.NotificationTypeMulti__c);
			filterMap.put('Order_Type__c',savedFilters.OrderTypeMulti__c);
			filterMap.put('Priority__c',savedFilters.PriorityMulti__c);
			filterMap.put('Created_By__c',savedFilters.Created_By__c);
			for (String key : filterMap.keySet()) {
				if (filterMap.get(key) == null || filterMap.get(key) == '') filterMap.remove(key);
			}
			if (filterMap.containsKey('Order_Number__c')) filterMap.put('Order__r.Order_Number__c', filterMap.remove('Order_Number__c'));
			if (filterMap.containsKey('Notification_Number__c')) filterMap.put('Notification__r.Notification_Number__c', filterMap.remove('Notification_Number__c'));
			if (filterMap.containsKey('Functional_Location__c')) filterMap.put('Functional_Location__c', filterMap.remove('Functional_Location__c'));
			if (filterMap.containsKey('Clearance_Number__c')) filterMap.put('Name', filterMap.remove('Clearance_Number__c'));
			if (filterMap.containsKey('Main_Work_Center__c')) filterMap.put('Main_Work_Center_Text__c', filterMap.remove('Main_Work_Center__c'));
			List<String> filterMapping = new List<String>();
			if (filterMap.containsKey('Created_By__c')) {
				String Requester = String.valueOf(filterMap.remove('Created_By__c')); // Employee Id or Fullname
				Boolean haveStar = Requester.contains('*');
				Requester = String.valueOf(Requester).replace('*', '%');
				if (!Requester.contains('%')) Requester = '%' + Requester + '%';
				String employeeId = Requester;
				List<String> users = new List<String>();
				for (User u : [ SELECT Id, Name, Employee_Id__c FROM User WHERE Employee_Id__c LIKE:employeeId LIMIT 10]) {
					users.add('\'' + u.Name + '\'');
				}
                filterMapping.add((users.size() > 0)?String.format('({0} OR CreatedBy.Name IN ({1}))',new List<String>{conditionQuery('CreatedBy.Name', 'LIKE', Requester),String.join(users, ',')}):String.format('({0})', new List<String>{ conditionQuery('CreatedBy.Name', 'LIKE', Requester) }));
			}
            if(filterMap.containsKey('Requested_Date_Form__c')){
                String tempDate = String.valueOf(filterMap.get('Requested_Date_Form__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate >= ' + datetimeGmtString(onlyDate, false));
                filterMap.remove('Requested_Date_Form__c');
            }
            if(filterMap.containsKey('Requested_Date_To__c')){
                String tempDate = String.valueOf(filterMap.get('Requested_Date_To__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate <= ' + datetimeGmtString(onlyDate, true));
                filterMap.remove('Requested_Date_To__c');
            }
			if (filterMap.containsKey('Order_Type__c')) {
				String[] arrOrder = String.valueOf(filterMap.remove('Order_Type__c')).split(';');
				String orderTypeMulti = '\'' + String.join(arrOrder, '\',\'') + '\'';
				filterMapping.add('Order__r.Order_Type__c IN (' + orderTypeMulti + ')');
			}
			if (filterMap.containsKey('Status__c')) {
				String[] arrwcStatus = String.valueOf(filterMap.remove('Status__c')).split(';');
				String wcstatusMulti = '\'' + String.join(arrwcStatus, '\',\'') + '\'';
				filterMapping.add('Work_Clearance_Status__c IN (' + wcstatusMulti + ')');
			}
			if (filterMap.containsKey('Notification_Type__c')) {
				String[] arrType = String.valueOf(filterMap.remove('Notification_Type__c')).split(';');
				String notiType = '\'' + String.join(arrType, '\',\'') + '\'';
				filterMapping.add('Notification__r.Type__c IN (' + notiType + ')');
			}
			if (filterMap.containsKey('Priority__c')) {
				String[] arrPriority = String.valueOf(filterMap.remove('Priority__c')).split(';');
				String priorityMulti = '\'' + String.join(arrPriority, '\',\'') + '\'';
				filterMapping.add('Priority_Map__c IN (' + priorityMulti + ')');
			}
			Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe().get('Work_Clearance__c'.toLowerCase()).getDescribe().fields.getMap();
			for (String f : filterMap.keySet()) {
				if (!sObjectField.containsKey(f) && !f.contains('__r')) filterMap.remove(f);
			}
			for (String apiField : filterMap.keySet()) {
				Object value = filterMap.get(apiField);
				filterMapping.add((sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN)? String.format('{0} {1} {2}', new List<Object>{ apiField, '=', (Boolean) value }) :(sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE)? conditionQuery(apiField, '=', String.valueOf(value)) :conditionQuery(apiField, 'LIKE', String.valueOf(value)));
			}
			String query = String.format( 'SELECT {0} FROM Work_Clearance__c {1} ', new List<String>{String.join(new List<String>{ 'COUNT()' }, ','),filterMapping.size() > 0 ? String.format('WHERE {0}', new List<Object>{ String.join(filterMapping, ' AND ') }): ''});
			return Database.countQuery(query);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Integer getCountNewNotificationsByFilter(String recordId) {
		try {
			THOR_Filter__c savedFilters = [SELECT Id, Name, Filter_type__c, Notification_Number__c, NotificationTypeMulti__c, Functional_Location__c, Create_Date_To__c, Create_Date_From__c, StatusMulti__c, PriorityMulti__c, Main_Work_Center__c, Plant_Section__c, Maintenance_Plant__c, Location__c, Breakdown__c, Order_Number__c, OrderTypeMulti__c, Super_Order__c, Clearance_Number__c, Requested_Date_Form__c, Requested_Date_To__c, Created_By__c, Equipment__c, EQCC_Code__c, EQCC_Name__c FROM THOR_Filter__c WHERE Id = :recordId LIMIT 1 ];
			Map<String, Object> filterMap = new Map<String, Object>();
			filterMap.put('Functional_Location__c', savedFilters.Functional_Location__c);
			filterMap.put('Notification_Number__c', savedFilters.Notification_Number__c);
			filterMap.put('Order_Number__c', savedFilters.Order_Number__c);
			filterMap.put('Main_Work_Center__c', savedFilters.Main_Work_Center__c);
			filterMap.put('Maintenance_Plant__c', savedFilters.Maintenance_Plant__c);
			filterMap.put('Plant_Section__c', savedFilters.Plant_Section__c);
			filterMap.put('Location__c', savedFilters.Location__c);
            filterMap.put('Create_Date_From__c', savedFilters.Create_Date_From__c);
            filterMap.put('Create_Date_To__c', savedFilters.Create_Date_To__c);
            if (savedFilters.Breakdown__c == true) filterMap.put('Breakdown__c', savedFilters.Breakdown__c);
            filterMap.put('Status__c', savedFilters.StatusMulti__c);
			filterMap.put('Notification_Type__c', savedFilters.NotificationTypeMulti__c);
			filterMap.put('Priority__c', savedFilters.PriorityMulti__c);

			for (String key : filterMap.keySet()) {
				if (filterMap.get(key) == null || filterMap.get(key) == '') filterMap.remove(key);
			}

			if (filterMap.containsKey('Functional_Location__c')) filterMap.put('Functional_Location__r.Name', filterMap.remove('Functional_Location__c'));	
			if (filterMap.containsKey('Order_Number__c')) filterMap.put('Order__r.Order_Number__c', filterMap.remove('Order_Number__c'));
			if (filterMap.containsKey('Main_Work_Center__c')) filterMap.put('Main_Work_Center__r.Code__c', filterMap.remove('Main_Work_Center__c'));
			if (filterMap.containsKey('My_Tasks__c') && (Boolean) filterMap.get('My_Tasks__c')) filterMap.put('AssignedTo__c', filterMap.remove('User__c'));
			if (filterMap.containsKey('Breakdown__c') && (Boolean) filterMap.get('Breakdown__c')) filterMap.put('Breakdown__c', filterMap.remove('Breakdown__c'));
            List<String> filterMapping = new List<String>();
            if(filterMap.containsKey('Create_Date_From__c')){
                String tempDate = String.valueOf(filterMap.get('Create_Date_From__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate >= ' + datetimeGmtString(onlyDate, false));
                filterMap.remove('Create_Date_From__c');
            }
            if(filterMap.containsKey('Create_Date_To__c')){
                String tempDate = String.valueOf(filterMap.get('Create_Date_To__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate <= ' + datetimeGmtString(onlyDate, true));
                filterMap.remove('Create_Date_To__c');
            }
			if (filterMap.containsKey('Notification_Type__c')) {
				String[] arrNoti = String.valueOf(filterMap.remove('Notification_Type__c')).split(';');
				String notificationTypeMulti = '\'' + String.join(arrNoti, '\',\'') + '\'';
				filterMapping.add('Type__c IN (' + notificationTypeMulti + ')');
			}
			if (filterMap.containsKey('Status__c')) {
				String[] arrStatus = String.valueOf(filterMap.remove('Status__c')).split(';');
				String statusMulti = '\'' + String.join(arrStatus, '\',\'') + '\'';
				filterMapping.add('Notification_Status__c IN (' + statusMulti + ')');
			}
			if (filterMap.containsKey('Priority__c')) {
				system.debug('pri: ' + filterMap.get('Priority__c'));
				String[] arrPriority = String.valueOf(filterMap.remove('Priority__c')).split(';');
				String priorityMulti = '\'' + String.join(arrPriority, '\',\'') + '\'';
				filterMapping.add('Priority__c IN (' + priorityMulti + ')');
			}
			Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe().get('Notification__c'.toLowerCase()).getDescribe().fields.getMap();
			for (String f : filterMap.keySet()) {
				if (!sObjectField.containsKey(f) && !f.contains('__r')) filterMap.remove(f);
			}
			for (String apiField : filterMap.keySet()) {
				Object value = filterMap.get(apiField);
				filterMapping.add((sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN)? String.format('{0} {1} {2}', new List<Object>{ apiField, '=', (Boolean) value }) :(sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE)? conditionQuery(apiField, '=', String.valueOf(value)) :conditionQuery(apiField, 'LIKE', String.valueOf(value)));
			}
			String query = String.format('SELECT {0} FROM Notification__c {1}', new List<String>{ String.join(new List<String>{ 'COUNT()' }, ','), filterMapping.size() > 0 ? String.format('WHERE {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '' } );
			return Database.countQuery(query);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static List<Object> doHistoricalSearch(String recordId, Integer offset, Integer rowlimit) {
		try {
			THOR_Filter__c savedFilters = [SELECT Id, Name, Filter_type__c, Notification_Number__c, NotificationTypeMulti__c, Functional_Location__c, Create_Date_To__c, Create_Date_From__c, StatusMulti__c, PriorityMulti__c, Main_Work_Center__c, Plant_Section__c, Maintenance_Plant__c, Location__c, Breakdown__c, Order_Number__c, OrderTypeMulti__c, Super_Order__c, Clearance_Number__c, Requested_Date_Form__c, Requested_Date_To__c, Created_By__c, Creator__c, Equipment__c, EQCC_Code__c, EQCC_Name__c FROM THOR_Filter__c WHERE Id = :recordId LIMIT 1 ];
			Map<String, Object> filterMap = new Map<String, Object>();
			filterMap.put('Functional_Location__c', savedFilters.Functional_Location__c);
			filterMap.put('Notification_Number__c', savedFilters.Notification_Number__c);
			filterMap.put('Order_Number__c', savedFilters.Order_Number__c);
			filterMap.put('Main_Work_Center__c', savedFilters.Main_Work_Center__c);
			filterMap.put('Maintenance_Plant__c', savedFilters.Maintenance_Plant__c);
			filterMap.put('Plant_Section__c', savedFilters.Plant_Section__c);
			filterMap.put('Location__c', savedFilters.Location__c);
			filterMap.put('Create_Date_To__c', savedFilters.Create_Date_To__c);
			filterMap.put('Create_Date_From__c', savedFilters.Create_Date_From__c);

			if (savedFilters.Filter_type__c == 'NotificationHistorical') {
				if (savedFilters.Breakdown__c == true) filterMap.put('Breakdown__c', savedFilters.Breakdown__c);
				filterMap.put('Status__c', savedFilters.StatusMulti__c);
				filterMap.put('Notification_Type__c', savedFilters.NotificationTypeMulti__c);
				filterMap.put('Priority__c', savedFilters.PriorityMulti__c);
				for (String key : filterMap.keySet()) {
					if (filterMap.get(key) == null || filterMap.get(key) == '') filterMap.remove(key);
				}
				List<Notification__c> result = getNotificationsByFilter(filterMap, offset, rowlimit);
				return result;
			} else if (savedFilters.Filter_type__c == 'OrderHistorical') {
				filterMap.put('Priority__c', savedFilters.PriorityMulti__c);
				filterMap.put('Super_Order__c', savedFilters.Super_Order__c);
				filterMap.put('Order_Status__c', savedFilters.StatusMulti__c);
				filterMap.put('Order_Type__c', savedFilters.OrderTypeMulti__c);
				for (String key : filterMap.keySet()) {
					if (filterMap.get(key) == null || filterMap.get(key) == '') filterMap.remove(key);
				}
				List<Order__c> result = getOrdersByFilter(filterMap, offset, rowlimit);
				return result;
			} else if (savedFilters.Filter_type__c == 'WorkClearanceHistorical') {
				filterMap.put('Clearance_Number__c', savedFilters.Clearance_Number__c);
				filterMap.put('Requested_Date_Form__c', savedFilters.Requested_Date_Form__c);
				filterMap.put('Requested_Date_To__c', savedFilters.Requested_Date_To__c);
				filterMap.put('Notification_Type__c', savedFilters.NotificationTypeMulti__c);
				filterMap.put('Order_Type__c', savedFilters.OrderTypeMulti__c);
				filterMap.put('Priority__c', savedFilters.PriorityMulti__c);
				filterMap.put('Created_By__c', savedFilters.Created_By__c);
				filterMap.put('Maintenance_Plant__c', savedFilters.Maintenance_Plant__c);
				filterMap.put('Plant_Section__c', savedFilters.Plant_Section__c);
				filterMap.put('Status__c', savedFilters.StatusMulti__c);
				filterMap.put('Location__c', savedFilters.Location__c);
				for (String key : filterMap.keySet()) {
					if (filterMap.get(key) == null || filterMap.get(key) == '') filterMap.remove(key);
				}
				List<Work_Clearance__c> result = getWorkClearanceByFilter(filterMap, offset, rowlimit);
				return result;
			} else if (savedFilters.Filter_type__c == 'EQCCHistorical') {
				filterMap.put('Equipment__c', savedFilters.Equipment__c);
				filterMap.put('Check_Sheet_Name__c', savedFilters.EQCC_Name__c);
				filterMap.put('Check_Sheet_Code__c', savedFilters.EQCC_Code__c);
				filterMap.put('Creator__c', savedFilters.Creator__c);
				for (String key : filterMap.keySet()) {
					if (filterMap.get(key) == null || filterMap.get(key) == '') filterMap.remove(key);
				}
				List<HeaderSheetWrapper> result = getInProgressEQCCFilter(filterMap, offset, rowlimit);
				return result;
			} else { return null; }
		} catch (Exception e) { throw new AuraHandledException(e.getMessage());}
	}

	@AuraEnabled
	public static List<Notification__c> getNotificationsByFilter(Map<String, Object> filter, Integer offset, Integer rowlimit ) {
		try {
			if (filter.containsKey('Functional_Location__c')) filter.put('Functional_Location__r.Name', filter.remove('Functional_Location__c'));
			if (filter.containsKey('Order_Number__c')) filter.put('Order__r.Order_Number__c', filter.remove('Order_Number__c'));
			if (filter.containsKey('Main_Work_Center__c')) filter.put('Main_Work_Center__r.Code__c', filter.remove('Main_Work_Center__c'));
			if (filter.containsKey('My_Tasks__c') && (Boolean) filter.get('My_Tasks__c')) filter.put('AssignedTo__c', filter.remove('User__c'));
			if (filter.containsKey('Breakdown__c') && (Boolean) filter.get('Breakdown__c')) filter.put('Breakdown__c', filter.remove('Breakdown__c'));
            List<String> filterMapping = new List<String>();
            if(filter.containsKey('Create_Date_From__c')){
                String tempDate = String.valueOf(filter.get('Create_Date_From__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate >= ' + datetimeGmtString(onlyDate, false));
                filter.remove('Create_Date_From__c');
            }
            if(filter.containsKey('Create_Date_To__c')){
                String tempDate = String.valueOf(filter.get('Create_Date_To__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate <= ' + datetimeGmtString(onlyDate, true));
                filter.remove('Create_Date_To__c');
            }
			if (filter.containsKey('Notification_Type__c')) {
				String[] arrNoti = String.valueOf(filter.remove('Notification_Type__c')).split(';');
				String notificationTypeMulti = '\'' + String.join(arrNoti, '\',\'') + '\'';
				filterMapping.add('Type__c IN (' + notificationTypeMulti + ')');
			}
			if (filter.containsKey('Status__c')) {
				String[] arrStatus = String.valueOf(filter.remove('Status__c')).split(';');
				String statusMulti = '\'' + String.join(arrStatus, '\',\'') + '\'';
				filterMapping.add('Notification_Status__c IN (' + statusMulti + ')');
			}
			if (filter.containsKey('Priority__c')) {
				String[] arrPriority = String.valueOf(filter.remove('Priority__c')).split(';');
				String priorityMulti = '\'' + String.join(arrPriority, '\',\'') + '\'';
				filterMapping.add('Priority__c IN (' + priorityMulti + ')');
			}
			Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe() .get('Notification__c'.toLowerCase()) .getDescribe() .fields .getMap();
			for (String f : filter.keySet()) {
				if (!sObjectField.containsKey(f) && !f.contains('__r')) filter.remove(f);
			}
			for (String apiField : filter.keySet()) {
				Object value = filter.get(apiField);
				filterMapping.add((sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN)? String.format('{0} {1} {2}', new List<Object>{ apiField, '=', (Boolean) value }) :(sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE)? conditionQuery(apiField, '=', String.valueOf(value)) :conditionQuery(apiField, 'LIKE', String.valueOf(value)));
			}
			String query = String.format( 'SELECT {0} FROM Notification__c {1} ORDER BY Notification_Number__c DESC {2}', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c' }, ',' ), filterMapping.size() > 0 ? String.format('WHERE {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '', String.format('LIMIT {0}', new List<String>{ String.valueOf(LIMITMAX_CONST) }) } );
			return Database.query(query);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static List<Order__c> getOrdersByFilter(Map<String, Object> filter, Integer offset, Integer rowlimit) {
		try {
			if (filter.containsKey('Notification_Number__c')) filter.put('Notification__r.Notification_Number__c', filter.remove('Notification_Number__c'));
			if (filter.containsKey('Functional_Location__c')) filter.put('Functional_Location__r.Name', filter.remove('Functional_Location__c'));
			if (filter.containsKey('Main_Work_Center__c')) filter.put('Main_Work_Center__r.Code__c', filter.remove('Main_Work_Center__c'));
			if (filter.containsKey('Super_Order__c')) filter.put('Super_Order__r.Name', filter.remove('Super_Order__c'));
			List<String> filterMapping = new List<String>();
            if(filter.containsKey('Create_Date_From__c')){
                String tempDate = String.valueOf(filter.get('Create_Date_From__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate >= ' + datetimeGmtString(onlyDate, false));
                filter.remove('Create_Date_From__c');
            }
            if(filter.containsKey('Create_Date_To__c')){
                String tempDate = String.valueOf(filter.get('Create_Date_To__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate <= ' + datetimeGmtString(onlyDate, true));
                filter.remove('Create_Date_To__c');
            }
			if (filter.containsKey('Order_Type__c')) {
				String[] arrNoti = String.valueOf(filter.remove('Order_Type__c')).split(';');
				String notificationTypeMulti = '\'' + String.join(arrNoti, '\',\'') + '\'';
				filterMapping.add('Order_Type__c IN (' + notificationTypeMulti + ')');
			}
			if (filter.containsKey('Order_Status__c')) {
				String[] arrStatus = String.valueOf(filter.remove('Order_Status__c')).split(';');
				String statusMulti = '\'' + String.join(arrStatus, '\',\'') + '\'';
				filterMapping.add('Order_Status__c IN (' + statusMulti + ')');
			}
			if (filter.containsKey('Priority__c')) {
				String[] arrPriority = String.valueOf(filter.remove('Priority__c')).split(';');
				String priorityMulti = '\'' + String.join(arrPriority, '\',\'') + '\'';
				filterMapping.add('Priority__c IN (' + priorityMulti + ')');
			}
			Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe() .get('Order__c'.toLowerCase()) .getDescribe() .fields .getMap();
			for (String f : filter.keySet()) {
				if (!sObjectField.containsKey(f) && !f.contains('__r')) filter.remove(f);
			}
			for (String apiField : filter.keySet()) {
				Object value = filter.get(apiField);
                filterMapping.add((sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN)? String.format('{0} {1} {2}', new List<Object>{ apiField, '=', (Boolean) value }) :(sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE)? conditionQuery(apiField, '=', String.valueOf(value)) :conditionQuery(apiField,'LIKE', String.valueOf(value)));
			}
			String query = String.format( 'SELECT {0} FROM Order__c {1} ORDER BY Order_Number__c DESC {2}', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Order_Status__c', 'Order_Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Order_Number__c', 'Super_Order__c', 'Super_Order__r.Name', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'Responsible_person__c' }, ',' ), filterMapping.size() > 0 ? String.format('WHERE {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '', String.format('LIMIT {0}', new List<String>{ String.valueOf(LIMITMAX_CONST) }) } );
			return Database.query(query);
		} catch (Exception e) {
			throw new AuraHandledException(e.getStackTraceString());
		}
	}

	@AuraEnabled
	public static List<Work_Clearance__c> getWorkClearanceByFilter( Map<String, Object> filter, Integer offset, Integer rowlimit ) {
		try {
			if (filter.containsKey('Order_Number__c')) filter.put('Order__r.Order_Number__c', filter.remove('Order_Number__c'));
			if (filter.containsKey('Notification_Number__c')) filter.put('Notification__r.Notification_Number__c', filter.remove('Notification_Number__c'));
			if (filter.containsKey('Functional_Location__c')) filter.put('Functional_Location__c', filter.remove('Functional_Location__c'));
			if (filter.containsKey('Clearance_Number__c')) filter.put('Name', filter.remove('Clearance_Number__c'));
			if (filter.containsKey('Main_Work_Center__c')) filter.put('Main_Work_Center_Text__c', filter.remove('Main_Work_Center__c'));
			List<String> filterMapping = new List<String>();
			if (filter.containsKey('Created_By__c')) {
				String Requester = String.valueOf(filter.remove('Created_By__c')); // Employee Id or Fullname
				Boolean haveStar = Requester.contains('*');
				Requester = String.valueOf(Requester).replace('*', '%');
				if (!Requester.contains('%')) Requester = '%' + Requester + '%';
				String employeeId = Requester;
				List<String> users = new List<String>();
				for (User u : [ SELECT Id, Name, Employee_Id__c FROM User WHERE Employee_Id__c LIKE :employeeId LIMIT 10 ]) {
					users.add('\'' + u.Name + '\'');
				}
                filterMapping.add((users.size() > 0)?String.format( '({0} OR CreatedBy.Name IN ({1}))', new List<String>{ conditionQuery('CreatedBy.Name', 'LIKE', Requester), String.join(users, ',') } ):String.format('({0})', new List<String>{ conditionQuery('CreatedBy.Name', 'LIKE', Requester) }));
			}
            if(filter.containsKey('Requested_Date_Form__c')){
                String tempDate = String.valueOf(filter.get('Requested_Date_Form__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate >= ' + datetimeGmtString(onlyDate, false));
                filter.remove('Requested_Date_Form__c');
            }
            if(filter.containsKey('Requested_Date_To__c')){
                String tempDate = String.valueOf(filter.get('Requested_Date_To__c'));
                String onlyDate = tempDate.substring(0,10);
                filterMapping.add('CreatedDate <= ' + datetimeGmtString(onlyDate, true));
                filter.remove('Requested_Date_To__c');
            }
            if (filter.containsKey('Status__c')) {
                String[] arrwcStatus = String.valueOf(filter.remove('Status__c')).split(';');
                String wcstatusMulti = '\'' + String.join(arrwcStatus, '\',\'') + '\'';
                filterMapping.add('Work_Clearance_Status__c IN (' + wcstatusMulti + ')');
            }
			if (filter.containsKey('Order_Type__c')) {
				String[] arrOrder = String.valueOf(filter.remove('Order_Type__c')).split(';');
				String orderTypeMulti = '\'' + String.join(arrOrder, '\',\'') + '\'';
				filterMapping.add('Order__r.Order_Type__c IN (' + orderTypeMulti + ')');
			}
			if (filter.containsKey('Notification_Type__c')) {
				String[] arrType = String.valueOf(filter.remove('Notification_Type__c')).split(';');
				String statusMulti = '\'' + String.join(arrType, '\',\'') + '\'';
				filterMapping.add('Notification__r.Type__c IN (' + statusMulti + ')');
			}
			if (filter.containsKey('Priority__c')) {
				system.debug('pri: ' + filter.get('Priority__c'));
				String[] arrPriority = String.valueOf(filter.remove('Priority__c')).split(';');
				String priorityMulti = '\'' + String.join(arrPriority, '\',\'') + '\'';
				filterMapping.add('Priority_Map__c IN (' + priorityMulti + ')');
			}
			Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe() .get('Work_Clearance__c'.toLowerCase()) .getDescribe() .fields .getMap();
			for (String f : filter.keySet()) {
				if (!sObjectField.containsKey(f) && !f.contains('__r')) filter.remove(f);
			}
			for (String apiField : filter.keySet()) {
				Object value = filter.get(apiField);
                filterMapping.add((sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN)? String.format('{0} {1} {2}', new List<Object>{ apiField, '=', (Boolean) value }) :(sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE)? conditionQuery(apiField, '=', String.valueOf(value)) :conditionQuery(apiField, 'LIKE', String.valueOf(value)));
			}
			String query = String.format( 'SELECT {0} FROM Work_Clearance__c {1} ORDER BY Name DESC {2} ', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'CreatedDate', 'Order__c', 'Notification__c', 'Order__r.Order_Type__c', 'Order__r.Order_Number__c', 'Notification__r.Type__c', 'Notification__r.Notification_Number__c', 'Priority_Map__c', 'Description__c', 'CreatedBy.Name', 'Functional_Location__c', 'FunctionalLocation__r.Name', 'Main_Work_Center__r.Code__c', 'Main_Work_Center_Text__c', 'Maintenance_Plant__c', 'Plant_Section__c', 'Work_Clearance_Status__c', 'Location__c', 'Extend_No__c' }, ',' ), filterMapping.size() > 0 ? String.format('WHERE {0}', new List<Object>{ String.join(filterMapping, ' AND ') }) : '', String.format('LIMIT {0}', new List<String>{ String.valueOf(LIMITMAX_CONST) }) } );
			return Database.query(query);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	private static List<HeaderSheetWrapper> createHeaderSheetWrapper( Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader ) {
		List<HeaderSheetWrapper> wrappers = new List<HeaderSheetWrapper>();
		for (EQCC_Header__c header : sheetsByHeader.keySet()) {
			wrappers.add(new HeaderSheetWrapper(header, new List<CheckedSheetWrapper>(sheetsByHeader.get(header))));
		}
		return wrappers;
	}

	@AuraEnabled
	public static Integer getCountInProgressEQCCsByFilter(String recordId) {
		THOR_Filter__c savedFilters = [ SELECT Id, Name, Filter_type__c, Notification_Number__c, NotificationTypeMulti__c, Functional_Location__c, Create_Date_To__c, Create_Date_From__c, StatusMulti__c, PriorityMulti__c, Main_Work_Center__c, Plant_Section__c, Maintenance_Plant__c, Location__c, Breakdown__c, Order_Number__c, OrderTypeMulti__c, Super_Order__c, Clearance_Number__c, Requested_Date_Form__c, Requested_Date_To__c, Created_By__c, Equipment__c, EQCC_Code__c, EQCC_Name__c, Creator__c FROM THOR_Filter__c WHERE Id = :recordId LIMIT 1 ];
		Map<String, Object> filterMap = new Map<String, Object>();
		filterMap.put('Functional_Location__c', savedFilters.Functional_Location__c);
		filterMap.put('Notification_Number__c', savedFilters.Notification_Number__c);
		filterMap.put('Order_Number__c', savedFilters.Order_Number__c);
		filterMap.put('Main_Work_Center__c', savedFilters.Main_Work_Center__c);
		filterMap.put('Maintenance_Plant__c', savedFilters.Maintenance_Plant__c);
		filterMap.put('Plant_Section__c', savedFilters.Plant_Section__c);
		filterMap.put('Location__c', savedFilters.Location__c);
		filterMap.put('Create_Date_To__c', savedFilters.Create_Date_To__c);
		filterMap.put('Create_Date_From__c', savedFilters.Create_Date_From__c);
		filterMap.put('Creator__c', savedFilters.Creator__c);
		filterMap.put('Equipment__c', savedFilters.Equipment__c);
		filterMap.put('Check_Sheet_Name__c', savedFilters.EQCC_Name__c);
		filterMap.put('Check_Sheet_Code__c', savedFilters.EQCC_Code__c);
		filterMap.put('Created_By__c', savedFilters.Created_By__c);
		for (String key : filterMap.keySet()) {
			if (filterMap.get(key) == null || filterMap.get(key) == '') filterMap.remove(key);
		}
		Integer offset = 0;
		Integer rowlimit = 50000;
		List<Header_Sheet__c> headerSheets = getInProgressHeaderSheetsFilter(filterMap, offset, rowlimit);
		return headerSheets.size();
	}

	private static Map<Id, EQCC_Header__c> getHeadersFromHeaderSheets(List<Header_Sheet__c> headerSheets) {
		Set<Id> headerIds = new Set<Id>();
		for (Header_Sheet__c headerSheet : headerSheets) {
			headerIds.add(headerSheet.Header__c);
		}
		Map<Id, EQCC_Header__c> sheets = new Map<Id, EQCC_Header__c>( [ SELECT Id, FunctionalLocation__r.Name, Equipment__r.Name, Name, Notification__r.Notification_Number__c, Notification__r.Description__c, Order__r.Order_Number__c, Order__r.Description__c, CreatedDate FROM EQCC_Header__c WHERE Id IN :headerIds AND IsDeleted__c = FALSE WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC ] );
		return sheets;
	}

	private static Map<Id, EQCC_Checked_Sheet__c> getSheetsFromHeaderSheets( List<Header_Sheet__c> headerSheets, Set<Id> headersIds ) {
		Set<Id> sheetIds = new Set<Id>();
		for (Header_Sheet__c headerSheet : headerSheets) {
			if (headersIds.isEmpty() || headersIds.contains(headerSheet.Header__c)) sheetIds.add(headerSheet.Sheet__c);
		}
		Map<Id, EQCC_Checked_Sheet__c> sheets = new Map<Id, EQCC_Checked_Sheet__c>( [ SELECT Id, Form_Type__c, Sheet_Code__c, Name, Status__c, CreatedDate, Group__c, LastModifiedDate, Form_Name__c FROM EQCC_Checked_Sheet__c WHERE Id IN :sheetIds ORDER BY CreatedDate DESC ] );
		return sheets;
	}

	private static Map<EQCC_Header__c, Set<CheckedSheetWrapper>> buildSheetsByHeader( Map<Id, EQCC_Header__c> headers, List<Header_Sheet__c> headerSheets, Map<Id, EQCC_Checked_Sheet__c> sheets ) {
		Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = new Map<EQCC_Header__c, Set<CheckedSheetWrapper>>();
		for (Header_Sheet__c headerSheet : headerSheets) {
			if (headers.keySet().contains(headerSheet.Header__c)) {
				if (!sheetsByHeader.containsKey(headers.get(headerSheet.Header__c))) {
					sheetsByHeader.put( headers.get(headerSheet.Header__c), new Set<CheckedSheetWrapper>{ new CheckedSheetWrapper( sheets.get(headerSheet.Sheet__c), headerSheet.Status__c, headerSheet.Requester__c, headerSheet.CreatedDate, headerSheet.LastModifiedDate, headerSheet.isManuallyCreated__c, headerSheet.Id, headerSheet.isPolluted__c, headerSheet.Name, headerSheet.EQCC_Steps__r ) } );
				} else {
					sheetsByHeader.get(headers.get(headerSheet.Header__c)) .add( new CheckedSheetWrapper( sheets.get(headerSheet.Sheet__c), headerSheet.Status__c, headerSheet.Requester__c, headerSheet.CreatedDate, headerSheet.LastModifiedDate, headerSheet.isManuallyCreated__c, headerSheet.Id, headerSheet.isPolluted__c, headerSheet.Name, headerSheet.EQCC_Steps__r ) );
				}
			}
		}
		for (Id headerId : headers.keySet()) {
			if (!sheetsByHeader.containsKey(headers.get(headerId))) sheetsByHeader.put(headers.get(headerId), new Set<CheckedSheetWrapper>());
		}
		return sheetsByHeader;
	}
	private static List<Header_Sheet__c> getInProgressHeaderSheetsFilter( Map<String, Object> filter, Integer offset, Integer rowlimit ) {
		List<String> filterCondition = new List<String>();
        if(filter.containsKey('Create_Date_From__c')){
            String tempDate = String.valueOf(filter.get('Create_Date_From__c'));
            String onlyDate = tempDate.substring(0,10);
            filterCondition.add('CreatedDate >= ' + datetimeGmtString(onlyDate, false));
            filter.remove('Create_Date_From__c');
        }
        if(filter.containsKey('Create_Date_To__c')){
            String tempDate = String.valueOf(filter.get('Create_Date_To__c'));
            String onlyDate = tempDate.substring(0,10);
            filterCondition.add('CreatedDate <= ' + datetimeGmtString(onlyDate, true));
            filter.remove('Create_Date_To__c');
        }
        if (filter.containsKey('Check_Sheet_Code__c')) filter.put('Sheet__r.Sheet_Code__c', filter.remove('Check_Sheet_Code__c'));
		if (filter.containsKey('Check_Sheet_Name__c')) filter.put('Sheet__r.Form_Name__c', filter.remove('Check_Sheet_Name__c'));
		if (filter.containsKey('Equipment__c')) filter.put('Header__r.Equipment__r.Name', filter.remove('Equipment__c'));
		if (filter.containsKey('Notification_Number__c')) filter.put('Header__r.Notification__r.Notification_Number__c', filter.remove('Notification_Number__c'));
		if (filter.containsKey('Functional_Location__c')) filter.put('Header__r.FunctionalLocation__r.Name', filter.remove('Functional_Location__c'));
		if (filter.containsKey('Order_Number__c')) filter.put('Header__r.Order__r.Order_Number__c', filter.remove('Order_Number__c'));
		if (filter.containsKey('Maintenance_Plant__c')) filter.put('Header__r.Maintenance_PlantText__c', filter.remove('Maintenance_Plant__c'));
		if (filter.containsKey('Location__c')) filter.put('Header__r.LocationText__c', filter.remove('Location__c'));
		if (filter.containsKey('Plant_Section__c')) filter.put('Header__r.Plant_SectionText__c', filter.remove('Plant_Section__c'));
		if (filter.containsKey('Main_Work_Center__c')) filter.put('Header__r.Main_Work_CenterText__c', filter.remove('Main_Work_Center__c'));
		if (filter.containsKey('Creator__c')) {
			String Requester = String.valueOf(filter.remove('Creator__c')); // Employee Id or Fullname
			Boolean haveStar = Requester.contains('*');
			Requester = String.valueOf(Requester).replace('*', '%');
			if (!Requester.contains('%')) Requester = '%' + Requester + '%';
			String employeeId = Requester;
			List<String> users = new List<String>();
			for (User u : [SELECT Id, Name, Employee_Id__c FROM User WHERE Employee_Id__c LIKE :employeeId LIMIT 10]) {
				users.add('\'' + u.Name + '\'');
			}
            filterCondition.add( (users.size() > 0) ? String.format( '({0} OR Requester__c IN ({1}))', new List<String>{ conditionQuery('Requester__c', 'LIKE', Requester), String.join(users, ',') }) :String.format('({0})', new List<String>{ conditionQuery('Requester__c', 'LIKE', Requester) })) ;
		}
		Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe() .get('Header_Sheet__c'.toLowerCase()) .getDescribe() .fields .getMap();
		for (String f : filter.keySet()) {
			if (!sObjectField.containsKey(f) && !f.contains('__r')) filter.remove(f);
		}
		for (String keyApiName : filter.keySet()) {
			Object value = filter.get(keyApiName);
			if (value == null) continue;
            filterCondition.add((sObjectField.get(keyApiName)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN)? String.format('{0} {1} {2}', new List<Object>{ keyApiName, '=', (Boolean) value }) :(sObjectField.get(keyApiName)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE)? conditionQuery(keyApiName, '=', String.valueOf(value)) :conditionQuery(keyApiName, 'LIKE', String.valueOf(value)) );
		}
		String query = String.format( 'SELECT {0} FROM Header_Sheet__c ' + 'WHERE IsDeleted__c = FALSE {1}' + 'ORDER BY CreatedDate DESC {2}', new List<String>{ String.join( new List<String>{ 'Id', 'Name', 'Sheet__c', 'Status__c', 'Requester__c', 'Header__c', 'isManuallyCreated__c', 'CreatedDate', 'LastModifiedDate', 'isPolluted__c', '(SELECT Id FROM EQCC_Steps__r WHERE Is_Current__c = TRUE AND IsDeleted__c = false ORDER BY Step_Number__c DESC LIMIT 1)' }, ',' ), filterCondition.size() > 0 ? String.format( 'AND {0}', new List<String>{ String.join(filterCondition, ' AND ') } ) : '', String.format('LIMIT {0}', new List<String>{ String.valueOf(rowlimit) }) } );
		Map<Id, Header_Sheet__c> sheets = new Map<Id, Header_Sheet__c>((List<Header_Sheet__c>) Database.query(query));
		List<Header_Sheet__c> newInprogressHeaderList = new List<Header_Sheet__c>();
		return sheets.values();
	}

	@AuraEnabled
	public static sObject getMyFilter(String recordId) {
		try {
			List<THOR_Filter__c> savedFilters = [ SELECT Id, Name, Filter_type__c, Notification_Number__c, NotificationTypeMulti__c, Functional_Location__c, Create_Date_To__c, Create_Date_From__c, StatusMulti__c, PriorityMulti__c, Main_Work_Center__c, Plant_Section__c, Maintenance_Plant__c, Location__c, Breakdown__c, Order_Number__c, OrderTypeMulti__c, Super_Order__c, Clearance_Number__c, Requested_Date_Form__c, Requested_Date_To__c, Created_By__c, Creator__c, Equipment__c, EQCC_Code__c, EQCC_Name__c FROM THOR_Filter__c WHERE Id = :recordId LIMIT 1 ];
            return (savedFilters.size() > 0) ? savedFilters[0] : null;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}