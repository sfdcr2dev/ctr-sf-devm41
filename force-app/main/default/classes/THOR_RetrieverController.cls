/**
 * @author Oktana Team
 * @description controller for Retriever component
 */
public with sharing class THOR_RetrieverController {
	/**
	 * @description retrieves Notifications filtered by status
	 * @param status
	 * @return List<THOR_ObjectCardDTO>
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveNotifications(String status) {
		try {
			return THOR_DTOMapper.mapNotifications(getNotificationsByStatus(status));
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	/**
	 * @description retrieves Notifications filtered by status and other filters
	 * @param status
	 * @param mainWorkCenterFilter
	 * @param userFilterActive
	 * @param fromDateFilter
	 * @param toDateFilter
	 * @return List<THOR_ObjectCardDTO>
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveNotifications( String status, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter, Integer loadLimit ) {
		try {
			return THOR_DTOMapper.mapNotifications( getNotificationsByStatus( status, mainWorkCenterFilter, userFilterActive, fromDateFilter, toDateFilter, loadLimit ) );
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	@AuraEnabled
	public static Integer retrieveNotificationsCount( String status, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter ) {
		try {
			return getNotificationByStatusAndFiltersCount( status, mainWorkCenterFilter, userFilterActive, fromDateFilter, toDateFilter );
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	/**
	 * @description retrieves Notifications filtered by Functional Location
	 * @param functionalLocationId
	 * @return List<THOR_ObjectCardDTO>
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveFLNotifications(String functionalLocationId) {
		try {
			return THOR_DTOMapper.mapNotifications(getNotificationsByFunctionalLocation(functionalLocationId));
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	/**
	 * @description retrieves Notifications filtered by Functional Location
	 * @param functionalLocationId
	 * @return List<THOR_ObjectCardDTO>
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveFLNotifications( String functionalLocationId, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter ) {
		try {
			return THOR_DTOMapper.mapFunctionalLocationNotifications( FunctionalLocationHelper.getNotificationsByFunctionalLocationAndFilters( functionalLocationId, userFilterActive, fromDateFilter, toDateFilter ) );
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	/**
	 * @description retrieves Notifications assigned to the current user and filtered by status
	 * @param status
	 * @return List<THOR_ObjectCardDTO>
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveAssignedNotifications(String status) {
		try {
			return THOR_DTOMapper.mapNotifications(getAssignedNotificationsByStatus(status));
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	/**
	 * @description retrieves Orders filtered by status
	 * @param status
	 * @return List<THOR_ObjectCardDTO>
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveOrders(String status) {
		try {
			return THOR_DTOMapper.mapOrders(getOrdersByStatus(status));
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	/**
	 * @description retrieves Orders filtered by status and filters
	 * @param status
	 * @param mainWorkCenterFilter
	 * @param userFilterActive
	 * @param fromDateFilter
	 * @param toDateFilter
	 * @return List<THOR_ObjectCardDTO>
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveOrders( String status, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter, Integer loadLimit ) {
		try {
			return THOR_DTOMapper.mapOrders( getOrdersByStatusAndFilters( status, mainWorkCenterFilter, userFilterActive, fromDateFilter, toDateFilter, loadLimit ) );
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	@AuraEnabled
	public static Integer retrieveOrdersCount( String status, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter ) {
		try {
			return getOrderByStatusAndFiltersCount( status, mainWorkCenterFilter, userFilterActive, fromDateFilter, toDateFilter );
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	/**
	 * @description retrieves Operations filtered by orderId
	 * @param orderId
	 * @param loadLimit
	 * @return List<THOR_ObjectCardDTO>
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveOperations(Id orderId, Integer loadLimit) {
		try {
			return THOR_DTOMapper.mapOperations(getOperationsByOrderId(orderId, loadLimit));
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	/**
	 * @description retrieves Operations count filtered by orderId
	 * @param orderId
	 * @return Integer
	 */
	@AuraEnabled
	public static Integer retrieveOperationsCount(Id orderId) {
		return [SELECT COUNT() FROM Order_Operation__c WHERE Order__c = :orderId WITH SECURITY_ENFORCED];
	}

	/**
	 * @description retrieves Orders the current User is responsible for, filtered by status
	 * @param status
	 * @return List<THOR_ObjectCardDTO>
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveResponsibleOrders(String status) {
		try {
			return THOR_DTOMapper.mapOrders(getResponsibleOrdersByStatus(status));
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	/**
	 * @description retrieves all the related orders by the parent order id
	 * @return DTO list for THOR_ObjectCard
	 * @param status retrieves orders new or exccution
	 * @param relId the ID of the parent order
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveRelatedOrders(String status, String relId) {
		return THOR_DTOMapper.mapOrders(THOR_OrderListRelatedController.getRelatedObjects(relId).relatedSubOrders);
	}

	/**
	 * @description retrieves all the related orders by the parent order id filter by status
	 * @return DTO list for THOR_ObjectCard
	 * @param status
	 * @param relId
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveRelatedOrdersByStatus(String status, String relId) {
		return THOR_DTOMapper.mapOrders(
			THOR_OrderListRelatedController.getRelatedOrdersByStatus(relId, status).relatedSubOrders
		);
	}

	/**
	 * @description retrieves all the related orders by the parent order id filter by status and filter
	 * @return DTO list for THOR_ObjectCard
	 * @param status
	 * @param relId
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveRelatedOrdersByStatus( String status, String relId, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter, Integer loadLimit ) {
		return THOR_DTOMapper.mapOrders( THOR_OrderListRelatedController.getRelatedOrdersByStatus( relId, status, mainWorkCenterFilter, userFilterActive, fromDateFilter, toDateFilter, loadLimit ).relatedSubOrders );
	}

	/**
	 * @description retrieves the related orders count by the parent order id filter by status and filter
	 * @return DTO list for THOR_ObjectCard
	 * @param status
	 * @param relId
	 */
	@AuraEnabled
	public static Integer retrieveRelatedOrdersCount( String status, String relId, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter ) {
		Integer res = 0;
		String queryString = '';
		if (status != 'In Progress') {
			queryString = 'SELECT count()';
			queryString += ' FROM Order__c';
			queryString += ' WHERE Order_Status__c = \'' + status + '\'';
			queryString += ' AND Super_Order__c = \'' + relId + '\'';
		} else {
			queryString = 'SELECT count()';
			queryString += ' FROM Order__c';
			queryString += ' WHERE Order_Status__c = \'' + status + '\'';
			queryString += ' OR Order_Status__c =\'' + 'Closed' + '\'';
			queryString += ' AND Super_Order__c = \'' + relId + '\'';
		}

		if (mainWorkCenterFilter != '') {
			queryString += ' AND Main_Work_Center__r.Name = \'' + mainWorkCenterFilter + '\'';
		}

		if (userFilterActive) {
			queryString += ' AND Responsible_person__c = \'' + UserInfo.getUserId() + '\'';
		}

		if (fromDateFilter != null) {
			queryString += ' AND CreatedDate >=' + dateToString(fromDateFilter) + 'T00:00:00Z';
		}

		if (toDateFilter != null) {
			queryString += ' AND CreatedDate <=' + dateToString(toDateFilter.addDays(1)) + 'T00:00:00Z';
		}

		res = database.countQuery(queryString);
		return res;
	}

	/**
	 * @description retrieves all the related norifications by the parent order id
	 * @return DTO list for THOR_ObjectCard
	 * @param status retrieves notifications new or exccution
	 * @param relId the ID of the parent order
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveRelatedNotifications(String status, String relId) {
		return THOR_DTOMapper.mapNotifications(
			THOR_OrderListRelatedController.getRelatedObjects(relId).relatedNotifications
		);
	}

	/**
	 * @description retrieves all the related norifications by the parent order id and status
	 * @return DTO list for THOR_ObjectCard
	 * @param status retrieves notifications new or exccution
	 * @param relId the ID of the parent order
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveRelatedNotificationsByStatus(String status, String relId) {
		return THOR_DTOMapper.mapNotifications(
			THOR_OrderListRelatedController.getRelatedNotificationsByStatus(relId, status).relatedNotifications
		);
	}

	/**
	 * @description retrieves all the related norifications by the parent order id and status and filters
	 * @return DTO list for THOR_ObjectCard
	 * @param status retrieves notifications new or exccution
	 * @param mainWorkCenterFilter
	 * @param userFilterActive
	 * @param fromDateFilter
	 * @param toDateFilter
	 * @param relId the ID of the parent order
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveRelatedNotificationsByStatus( String status, String relId, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter, Integer loadLimit ) {
		return THOR_DTOMapper.mapNotifications( THOR_OrderListRelatedController.getRelatedNotificationsByStatus( relId, status, mainWorkCenterFilter, userFilterActive, fromDateFilter, toDateFilter, loadLimit ).relatedNotifications );
	}

	/**
	 * @description retrieves the related notifications count by the parent order id filter by status and filter
	 * @return DTO list for THOR_ObjectCard
	 * @param status
	 * @param relId
	 */
	@AuraEnabled
	public static Integer retrieveRelatedNotificationsCount(
		String status,
		String relId,
		String mainWorkCenterFilter,
		Boolean userFilterActive,
		Date fromDateFilter,
		Date toDateFilter
	) {
		Set<String> statusLst = new Set<String>{ status };
		if(status.equalsIgnoreCase('In Progress') || status.equalsIgnoreCase('Closed')) {
			statusLst.add('In Progress');
			statusLst.add('Closed');
		}
		List<String> conditionQuery = new List<String>{
			'Order__c = :relId'
		};
		if(String.isNotEmpty(mainWorkCenterFilter)) {
			conditionQuery.add('Main_Work_Center__r.Name = :mainWorkCenterFilter');
		}
		if(userFilterActive) {
			conditionQuery.add('AssignedTo__c = \'' + UserInfo.getUserId() + '\'');
		}
		if(fromDateFilter != null) {
			conditionQuery.add('CreatedDate >= ' + dateToString(fromDateFilter) + 'T00:00:00Z');
		}
		if(toDateFilter != null) {
			conditionQuery.add('CreatedDate <= ' + dateToString(toDateFilter.addDays(1)) + 'T00:00:00Z');
		}
		String query = String.format( 'SELECT COUNT() FROM Notification__c WHERE ({0}) {1}', new List<Object>{ 'Notification_Status__c IN :statusLst', conditionQuery.size() > 0 ? 'AND ' + String.join(conditionQuery, ' AND ') : '' } );
		System.debug(System.LoggingLevel.DEBUG, query);
		return database.countQuery(query);
/*
		// Integer res = 0;

		// String queryString = 'SELECT count()';
		// queryString += ' FROM Notification__c';
		// queryString += ' WHERE Notification_Status__c = \'' + status + '\'';
		// queryString += ' AND Order__c = \'' + relId + '\'';

		// if (mainWorkCenterFilter != '') {
		// 	queryString += ' AND Main_Work_Center__r.Name = \'' + mainWorkCenterFilter + '\'';
		// }

		// if (userFilterActive) {
		// 	queryString += ' AND AssignedTo__c = \'' + UserInfo.getUserId() + '\'';
		// }

		// if (fromDateFilter != null) {
		// 	queryString += ' AND CreatedDate >=' + dateToString(fromDateFilter) + 'T00:00:00Z';
		// }

		// if (toDateFilter != null) {
		// 	queryString += ' AND CreatedDate <=' + dateToString(toDateFilter.addDays(1)) + 'T00:00:00Z';
		// }

		// res = database.countQuery(queryString);
		// return res;
*/
	}

	/**
	 * @description retrieves all the current user items filter by notification
	 * @return List<THOR_ObjectCardDTO>
	 * @param notificationId
	 */
	@AuraEnabled
	public static List<THOR_ObjectCardDTO> retrieveItems(String notificationId) {
		try {
			return THOR_DTOMapper.mapItems( [ SELECT Id, Name, Notification__r.Id, Start_Date__c, End_Date__c FROM Item__c WHERE Notification__r.Id = :notificationId WITH SECURITY_ENFORCED ] );
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong...');
		}
	}

	/**
	 * @description retrieves Notifications filtered by status
	 * @param notificationStatus Notification status
	 */
	private static List<Notification__c> getNotificationsByStatus(String notificationStatus) {
		return [SELECT Id, Name, Notification_Status__c, Type__c, Description__c, Priority__c, Requested_Date__c, Notification_Number__c, CreatedDate, Functional_Location__r.Name FROM Notification__c WHERE Notification_Status__c = :notificationStatus WITH SECURITY_ENFORCED ORDER BY Notification_Number__c DESC ];
	}

	/**
	 * @description retrieves Notifications filtered by status
	 * @param notificationStatus Notification status
	 */
	private static List<Notification__c> getNotificationsByStatus( String notificationStatus, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter, Integer loadLimit ) {
		List<Notification__c> notifications = getNotificationByStatusAndFilters( notificationStatus, mainWorkCenterFilter, userFilterActive, fromDateFilter, toDateFilter, loadLimit );

		return notifications;
	}

	/**
	 * @description retrieves Notifications assigned to the current User and filtered by status
	 * @param notificationStatus Notification status
	 */
	private static List<Notification__c> getAssignedNotificationsByStatus(String notificationStatus) {
		return [ SELECT Id, Name, Notification_Status__c, Type__c, Description__c, Priority__c, Requested_Date__c, Notification_Number__c, CreatedDate, Functional_Location__r.Name FROM Notification__c WHERE Notification_Status__c = :notificationStatus AND AssignedTo__c = :UserInfo.getUserId() WITH SECURITY_ENFORCED ORDER BY Notification_Number__c DESC ];
	}

	/**
	 * @description retrieves Orders filtered by status
	 * @param orderStatus Order status
	 */
	private static List<Order__c> getOrdersByStatus(String orderStatus) {
		return [ SELECT Id, Name, Order_Status__c, Order_Type__c, Description__c, Priority__c, Requested_Date__c, Order_Number__c, CreatedDate, Functional_Location__r.Name FROM Order__c WHERE Order_Status__c = :orderStatus WITH SECURITY_ENFORCED ORDER BY Order_Number__c DESC ];
	}

	/**
	 * @description retrieves Orders Operations filtered by order Id
	 * @param orderId
	 */
	private static List<Order_Operation__c> getOperationsByOrderId(Id orderId, Integer loadLimit) {
		if (loadLimit == 0) {
			loadLimit = Constants.SOQL.SOQL_LIMIT;
		}

		return [ SELECT Id, Operation__c, Operation_Text__c, Operation__r.CreatedDate, Order__c, Operation__r.Name, Operation__r.Main_Work_Center__c, Main_Work_Center__r.Name, Operation_Shot_Text__c, SubOperation__c, Operation__r.Short_Text__c FROM Order_Operation__c WHERE Order__c = :orderId WITH SECURITY_ENFORCED LIMIT :loadLimit ];
	}

	/**
	 * @description retrieves Orders the current User is responsible for, filtered by status
	 * @param orderStatus Order status
	 */
	private static List<Order__c> getResponsibleOrdersByStatus(String orderStatus) {
		return [ SELECT Id, Name, Order_Status__c, Order_Type__c, Description__c, Priority__c, Requested_Date__c, Order_Number__c, CreatedDate, Functional_Location__r.Name FROM Order__c WHERE Order_Status__c = :orderStatus AND Responsible_person__c = :UserInfo.getUserId() WITH SECURITY_ENFORCED ORDER BY Order_Number__c DESC ];
	}

	/**
	 * @description retrieves Orders the current User is responsible for, filtered by status
	 * @param orderStatus Order status
	 */
	@AuraEnabled
	public static String getObjectTypeFromId(String recordId) {
		Id rtn = Id.valueOf(recordId);
		return String.valueOf(rtn.getSobjectType());
	}

	/**
	 * @description retrieves Main Work Centers that are related to notifications
	 */
	@AuraEnabled
	public static List<String> getRelatedMainWorkCenterNames() {
		List<String> res = getMainWorkCenterNames();

		if (res.size() == 0) {
			List<String> mwcNames = new List<String>{ 'ENMA-', 'ENMB-', 'ENMC-', 'ENMD-', 'ENME-', 'ENMF-' };
			List<String> meiNames = new List<String>{ 'M', 'E', 'I' };
			for (String mwcName : mwcNames) {
				for (String mei : meiNames) {
					res.add(mwcName + mei);
				}
			}
		}
		return res;
	}

	//----------- HELPER METHODS -----------

	private static List<String> getMainWorkCenterNames() {
		List<String> res = new List<String>();

		String userRoleName = getUserRoleName();

		String mainWorkCenterName = 'ENM';

		if (userRoleName != null) {
			if (userRoleName.contains('APU-A')) {
				mainWorkCenterName += 'A-';
			} else if (userRoleName.contains('APU-B')) {
				mainWorkCenterName += 'B-';
			} else if (userRoleName.contains('APU-C')) {
				mainWorkCenterName += 'C-';
			} else if (userRoleName.contains('APU-D')) {
				mainWorkCenterName += 'D-';
			} else if (userRoleName.contains('APU-E')) {
				mainWorkCenterName += 'E-';
			} else if (userRoleName.contains('APU-F')) {
				mainWorkCenterName += 'F-';
			}

			if (
				!mainWorkCenterName.equals('ENM') &&
				(userRoleName.contains('Operator') || userRoleName.contains('Manager'))
			) {
				res.add(mainWorkCenterName + 'M');
				res.add(mainWorkCenterName + 'E');
				res.add(mainWorkCenterName + 'I');
			} else if (userRoleName.contains(mainWorkCenterName + 'M')) {
				res.add(mainWorkCenterName + 'M');
			} else if (userRoleName.contains(mainWorkCenterName + 'E')) {
				res.add(mainWorkCenterName + 'E');
			} else if (userRoleName.contains(mainWorkCenterName + 'I')) {
				res.add(mainWorkCenterName + 'I');
			}
		}

		return res;
	}

	private static List<Notification__c> getNotificationByStatusAndFilters( String notificationStatus, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter, Integer loadLimit ) {
		List<String> conditionQuery = new List<String>();
		if(String.isNotEmpty(mainWorkCenterFilter)) {
			conditionQuery.add('Main_Work_Center__r.Name = :mainWorkCenterFilter');
		}
		if(userFilterActive) {
			conditionQuery.add('AssignedTo__c = \'' + UserInfo.getUserId() + '\'');
		}
		if(fromDateFilter != null) {
			conditionQuery.add('CreatedDate >= ' + dateToString(fromDateFilter) + 'T00:00:00Z');
		}
		if(toDateFilter != null) {
			conditionQuery.add('CreatedDate <= ' + dateToString(toDateFilter.addDays(1)) + 'T00:00:00Z');
		}
		String query = String.format( 'SELECT {0} FROM Notification__c WHERE ({1}) {2} ORDER BY Notification_Number__c DESC {3}', new List<Object>{ String.join( new List<String>{ 'Id', 'Name', 'Notification_Status__c', 'Type__c', 'Description__c', 'Priority__c', 'Requested_Date__c', 'Notification_Number__c', 'CreatedDate', 'Functional_Location__r.Name', 'Main_Work_Center__r.Name', 'AssignedTo__c' }, ', ' ), 'Notification_Status__c = :notificationStatus OR Notification_Status__c = ' + '\'Closed\'', conditionQuery.size() > 0 ? 'AND ' + String.join(conditionQuery, ' AND ') : '', loadLimit > 0 ? 'LIMIT :loadLimit' : '' } );
		return (List<Notification__c>)Database.query(query);

		// Integer count = 0;
		// String queryString = 'SELECT Id, Name, Notification_Status__c, Type__c, Description__c, Priority__c, Requested_Date__c, Notification_Number__c, CreatedDate, Functional_Location__r.Name, Main_Work_Center__r.Name, AssignedTo__c';
		// queryString += ' FROM Notification__c';
		// queryString += ' WHERE Notification_Status__c = \'' + notificationStatus + '\'';

		// if (mainWorkCenterFilter != '') {
		// 	queryString += ' AND Main_Work_Center__r.Name = \'' + mainWorkCenterFilter + '\'';
		// }

		// if (userFilterActive) {
		// 	queryString += ' AND AssignedTo__c = \'' + UserInfo.getUserId() + '\'';
		// }

		// if (fromDateFilter != null) {
		// 	queryString += ' AND CreatedDate >=' + dateToString(fromDateFilter) + 'T00:00:00Z';
		// }

		// if (toDateFilter != null) {
		// 	queryString += ' AND CreatedDate <=' + dateToString(toDateFilter.addDays(1)) + 'T00:00:00Z';
		// }

		// //queryString += ' WITH SECURITY_ENFORCED';
		// queryString += ' ORDER BY Notification_Number__c DESC';
		// if (loadLimit > 0) {
		// 	queryString += ' LIMIT ' + loadLimit;
		// }

		// List<Notification__c> notifications = Database.query(queryString);
		// return notifications;

	}

	private static Integer getNotificationByStatusAndFiltersCount( String notificationStatus, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter ) {
		Integer res = 0;

		String queryString = 'SELECT count()';
		queryString += ' FROM Notification__c';
		queryString += ' WHERE Notification_Status__c = \'' + notificationStatus + '\'';

		if (mainWorkCenterFilter != '') {
			queryString += ' AND Main_Work_Center__r.Name = \'' + mainWorkCenterFilter + '\'';
		}

		if (userFilterActive) {
			queryString += ' AND AssignedTo__c = \'' + UserInfo.getUserId() + '\'';
		}

		if (fromDateFilter != null) {
			queryString += ' AND CreatedDate >=' + dateToString(fromDateFilter) + 'T00:00:00Z';
		}

		if (toDateFilter != null) {
			queryString += ' AND CreatedDate <=' + dateToString(toDateFilter.addDays(1)) + 'T00:00:00Z';
		}

		res = database.countQuery(queryString);
		return res;
	}

	/**
	 * @description retrieves Orders filtered by status and filters
	 * @param orderStatus Order status
	 * @param mainWorkCenterFilter
	 * @param userFilterActive
	 * @param fromDateFilter
	 * @param toDateFilter
	 */
	private static List<Order__c> getOrdersByStatusAndFilters( String orderStatus, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter, Integer loadLimit ) {
		Integer count = 0;

		List<Order__c> orders = new List<Order__c>();

		String queryString = 'SELECT Id, Name, Order_Status__c, Order_Type__c, Description__c, Priority__c, Requested_Date__c, Order_Number__c, CreatedDate, Functional_Location__r.Name, Main_Work_Center__r.Name, Responsible_person__c';
		queryString += ' FROM Order__c';
		queryString += ' WHERE Order_Status__c = \'' + orderStatus + '\'';

		if (mainWorkCenterFilter != '') {
			queryString += ' AND Main_Work_Center__r.Name = \'' + mainWorkCenterFilter + '\'';
		}

		if (userFilterActive) {
			queryString += ' AND Responsible_person__c = \'' + UserInfo.getUserId() + '\'';
		}

		if (fromDateFilter != null) {
			queryString += ' AND CreatedDate >=' + dateToString(fromDateFilter) + 'T00:00:00Z';
		}

		if (toDateFilter != null) {
			queryString += ' AND CreatedDate <=' + dateToString(toDateFilter.addDays(1)) + 'T00:00:00Z';
		}

		queryString += ' ORDER BY Order_Number__c DESC';

		if (loadLimit > 0) {
			queryString += ' LIMIT ' + loadLimit;
		}
		orders = Database.query(queryString);

		return orders;
	}

	private static Integer getOrderByStatusAndFiltersCount( String status, String mainWorkCenterFilter, Boolean userFilterActive, Date fromDateFilter, Date toDateFilter ) {
		Integer res = 0;

		String queryString = 'SELECT count()';
		queryString += ' FROM Order__c';
		queryString += ' WHERE Order_Status__c = \'' + status + '\'';

		if (mainWorkCenterFilter != '') {
			queryString += ' AND Main_Work_Center__r.Name = \'' + mainWorkCenterFilter + '\'';
		}

		if (userFilterActive) {
			queryString += ' AND Responsible_person__c = \'' + UserInfo.getUserId() + '\'';
		}

		if (fromDateFilter != null) {
			queryString += ' AND CreatedDate >=' + dateToString(fromDateFilter) + 'T00:00:00Z';
		}

		if (toDateFilter != null) {
			queryString += ' AND CreatedDate <=' + dateToString(toDateFilter.addDays(1)) + 'T00:00:00Z';
		}

		res = database.countQuery(queryString);
		return res;
	}

	private static String getUserRoleName() {
		Id userId = UserInfo.getUserId();

		String userRoleName = '';
		List<User> userList = [SELECT UserRole.Name FROM User WHERE Id = :userId WITH SECURITY_ENFORCED];
		if (userList.size() > 0) {
			userRoleName = userList[0].UserRole.Name;
		}

		return userRoleName;
	}

	/**
	 * @description retrieves Notifications filtered by Functional Location
	 * @param functionalLocationId Functional Location Id
	 */
	private static List<Notification__c> getNotificationsByFunctionalLocation(String functionalLocationId) {
		return [ SELECT Id, Name, Notification_Status__c, Type__c, Description__c, Priority__c, Requested_Date__c, Notification_Number__c, CreatedDate, Functional_Location__r.Name FROM Notification__c WHERE Functional_Location__r.Id = :functionalLocationId WITH SECURITY_ENFORCED ORDER BY Notification_Number__c DESC ];
	}

	private static String dateToString(Date dateToConvert) {
		DateTime dateToConvertDT = (DateTime) dateToConvert;

		return dateToConvertDT.formatGMT('yyyy-MM-dd');
	}
}