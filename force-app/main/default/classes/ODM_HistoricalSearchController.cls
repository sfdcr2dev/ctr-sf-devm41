public with sharing class ODM_HistoricalSearchController {

	@AuraEnabled
	public static string getMyMainWorkCenter(){
		User me = [SELECT Main_Work_Center__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
		return me.Main_Work_Center__c;
	}

	@AuraEnabled
	public static Object getMyFilterHistoricalSearch(String filterType, List<String> fields) {
		Id userId = UserInfo.getUserId();
		Set<String> fieldSets = new Set<String>(fields);

		// fields.add('Id');
		// System.debug('fieldSets' + fieldSets);
		String query = String.format(
			'SELECT {0} FROM THOR_Filter__c WHERE User__c = :userId AND Filter_type__c = :filterType LIMIT 1',
			new List<String>{ String.join(fields, ', ') }
		);

		THOR_Filter__c filterValues = (THOR_Filter__c) Database.query(query);
		return filterValues;
	}

	@AuraEnabled
	public static Object getHistoricalNotificationList(
		String filter,
		Integer offset,
		Integer rowlimit,
		Boolean isSharingSettings
	) {
		try {
			THOR_Filter__c notificationFields = [
				SELECT
					id,
					Notification_Number__c,
					NotificationTypeMulti__c,
					StatusMulti__c,
					Functional_Location__c,
					Create_Date_From__c,
					Create_Date_To__c,
					Notification_Date__c,
					Requester__c,
					Submission_Date_From__c,
					Submission_Date_To__c,
					Main_Work_Center__c,
					Maintenance_Plant__c,
					Plant_Section__c,
					Description__c
				FROM THOR_Filter__c
				WHERE id = :filter
				LIMIT 1
			];

			Map<String, String> filterMap = new Map<String, String>();
			filterMap.put('Notification_Number__c', notificationFields.Notification_Number__c);
			filterMap.put('Functional_Location__c', notificationFields.Functional_Location__c);
			filterMap.put('Notification_Type__c', notificationFields.NotificationTypeMulti__c);
			filterMap.put('Notification_Status__c', notificationFields.StatusMulti__c);
			filterMap.put('Create_Date_From__c', String.valueOf(notificationFields.Create_Date_From__c));
			filterMap.put('Create_Date_To__c', String.valueOf(notificationFields.Create_Date_To__c));
			filterMap.put('Notification_Date__c', String.valueOf(notificationFields.Notification_Date__c));
			filterMap.put('Requester__c', notificationFields.Requester__c);
			filterMap.put('Main_Work_Center__c', notificationFields.Main_Work_Center__c);
			//filterMap.put('MaintenancePlantText__c', notificationFields.Maintenance_Plant__c);
			filterMap.put('Submission_Date_From__c', String.valueOf(notificationFields.Submission_Date_From__c));
			filterMap.put('Submission_Date_To__c', String.valueOf(notificationFields.Submission_Date_To__c));
			filterMap.put('Maintenance_Plant__c', String.valueOf(notificationFields.Maintenance_Plant__c));
			filterMap.put('Plant_Section__c', String.valueOf(notificationFields.Plant_Section__c));
			filterMap.put('Description__c', String.valueOf(notificationFields.Description__c));

			for (String key : filterMap.keySet()) {
				// if blank as value for key, value pair
				// if (filterMap.get(key) == null || filterMap.get(key) == '' || filterMap.get(key) == 'null') {
				if (String.isEmpty(filterMap.get(key))) {
					filterMap.remove(key);
				}
			}

			Object obj = ODM_NotificationController.getNotificationList(filterMap, offset, rowlimit, isSharingSettings);
			return obj;
		} catch (Exception e) {
			System.debug(System.LoggingLevel.DEBUG, e.getStackTraceString());
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static Object getHistoricalWcList(
		String filter,
		Integer offset,
		Integer rowlimit,
		Boolean isSharingSettings
	) {
		//try {
			THOR_Filter__c wcFields = [
				SELECT
					id,
					Clearance_Number__c,
					StatusMulti__c,
					Main_Work_Center__c,
					Functional_Location__c,
					Create_Date_From__c,
					Create_Date_To__c,
					Requested_Date_Form__c,
					Requested_Date_To__c,
					Notification_Number__c,
					NotificationTypeMulti__c,
					Order_Number__c,
					OrderTypeMulti__c,
					PriorityMulti__c,
					Created_By__c,
					Requester__c,
					Area__c,
					Location__c,
					Plant_Section__c,
					Maintenance_Plant__c
				FROM THOR_Filter__c
				WHERE id = :filter
				LIMIT 1
			];

			Map<String, String> filterMap = new Map<String, String>();
			filterMap.put('Clearance_Number__c', wcFields.Clearance_Number__c);
			filterMap.put('Status__c', wcFields.StatusMulti__c);
			filterMap.put('Functional_Location__c', wcFields.Functional_Location__c);
			filterMap.put('Main_Work_Center__c', wcFields.Main_Work_Center__c);
			filterMap.put('Area__c', wcFields.Area__c);
			filterMap.put('MaintenancePlantText__c', wcFields.Maintenance_Plant__c);
			filterMap.put('Create_Date_From__c', String.valueOf(wcFields.Create_Date_From__c));
			filterMap.put('Create_Date_To__c', String.valueOf(wcFields.Create_Date_To__c));
			filterMap.put('Requested_Date_Form__c', String.valueOf(wcFields.Requested_Date_Form__c));
			filterMap.put('Requested_Date_To__c', String.valueOf(wcFields.Requested_Date_To__c));
			filterMap.put('Notification_Number__c', wcFields.Notification_Number__c);
			filterMap.put('Notification_Type__c', wcFields.NotificationTypeMulti__c);
			filterMap.put('Order_Number__c', wcFields.Order_Number__c);
			filterMap.put('Order_Type__c', wcFields.OrderTypeMulti__c);
			filterMap.put('Priority__c', wcFields.PriorityMulti__c);
			filterMap.put('Requester__c', wcFields.Requester__c);
			filterMap.put('Plant_Section__c', wcFields.Plant_Section__c);
			filterMap.put('Location__c', wcFields.Location__c);

			for (String key : filterMap.keySet()) {
				// if blank as value for key, value pair
				// if (filterMap.get(key) == null || filterMap.get(key) == '' || filterMap.get(key) == 'null') {
				if (String.isEmpty(filterMap.get(key))) {
					filterMap.remove(key);
				}
			}

			Object obj = ODM_WorkClearanceController.getWcList(filterMap, offset, rowlimit, isSharingSettings);
			return obj;
		//} catch (Exception e) {
		//	System.debug(System.LoggingLevel.DEBUG, e.getStackTraceString());
		//	throw new AuraHandledException(e.getMessage());
		//}
	}

	@AuraEnabled
	public static sObject getMyFilter(String recordId) {
		try {
			List<THOR_Filter__c> savedFilters = [
				SELECT
					Id,
					Name,
					Filter_type__c,
					Notification_Number__c,
					NotificationTypeMulti__c,
					Functional_Location__c,
					Create_Date_To__c,
					Create_Date_From__c,
					StatusMulti__c,
					PriorityMulti__c,
					Main_Work_Center__c,
					Plant_Section__c,
					Maintenance_Plant__c,
					Location__c,
					Breakdown__c,
					Order_Number__c,
					OrderTypeMulti__c,
					Super_Order__c,
					Clearance_Number__c,
					// Requested_Date_Form__c,
					// Requested_Date_To__c,
					Created_By__c,
					Creator__c,
					Equipment__c,
					EQCC_Code__c,
					EQCC_Name__c,
					Notification_Date__c,
					Requester__c,
					Submission_Date_From__c,
					Submission_Date_To__c
				FROM THOR_Filter__c
				WHERE Id = :recordId
				LIMIT 1
			];

			if (savedFilters.size() > 0) {
				return savedFilters[0];
			} else {
				return null;
			}
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}