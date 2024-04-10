/**
 * @author Oktana
 * @description Queries related Notifications, Sub Orders and Operations on an specific Order record
 */
public with sharing class THOR_OrderListRelatedController {
	/**
	 * @description retrieves all Notifications, Sub Orders and Operations that are related to a specific Order
	 * @return The Order plus related Notifications, Orders and Operations from the database
	 * @param orderIdentifier is the Id of the Order
	 */
	@AuraEnabled
	public static THOR_OrderListRelatedDTO getRelatedObjects(String orderIdentifier) {
		try {
			THOR_OrderListRelatedDTO dto = new THOR_OrderListRelatedDTO();
			Order__c temporalOrderVariable = [
				SELECT
					Id,
					(
						SELECT
							Id,
							Name,
							Notification_Status__c,
							Notification_Number__c,
							Type__c,
							Functional_Location__c,
							Priority__c,
							Requested_Date__c,
							Description__c
						FROM Notifications__r
					),
					(
						SELECT
							Id,
							Name,
							Order_Status__c,
							Order_Type__c,
							Description__c,
							Priority__c,
							Requested_Date__c,
							Order_Number__c,
							Functional_Location__r.Name,
							CreatedDate
						FROM Orders__r
					),
					(SELECT Id, Name FROM Order_Operations__r)
				FROM Order__c
				WHERE Id = :orderIdentifier
				WITH SECURITY_ENFORCED
				LIMIT 1
			];
			dto.relatedNotifications = temporalOrderVariable.Notifications__r;
			dto.relatedSubOrders = temporalOrderVariable.Orders__r;
			dto.relatedOperations = temporalOrderVariable.Order_Operations__r;
			return dto;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
	/**
	 * @description retrieves all Notifications related to a specific Order filtered by status
	 * @return The Order plus related Notifications from the database
	 * @param orderIdentifier
	 * @param notificationStatus
	 */
	@AuraEnabled
	public static THOR_OrderListRelatedDTO getRelatedNotificationsByStatus(
		String orderIdentifier,
		String notificationStatus
	) {
		List<String> status = new List<String>();
		status.add(notificationStatus);
		if (notificationStatus.equals('In Progress')) {
			status.add('Closed');
		}
		try {
			THOR_OrderListRelatedDTO dto = new THOR_OrderListRelatedDTO();
			Order__c temporalOrderVariable = [
				SELECT
					Id,
					(
						SELECT
							Id,
							Name,
							Notification_Status__c,
							Notification_Number__c,
							Type__c,
							Functional_Location__r.Name,
							Priority__c,
							Requested_Date__c,
							CreatedDate,
							Description__c
						FROM Notifications__r
						WHERE Notification_Status__c IN :status
					)
				FROM Order__c
				WHERE Id = :orderIdentifier
				WITH SECURITY_ENFORCED
				LIMIT 1
			];
			dto.relatedNotifications = temporalOrderVariable.Notifications__r;
			return dto;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description retrieves all Notifications related to a specific Order filtered by status and filters
	 * @return The Order plus related Notifications from the database
	 * @param orderIdentifier
	 * @param notificationStatus
	 * @param mainWorkCenterFilter
	 * @param userFilterActive
	 * @param fromDateFilter
	 * @param toDateFilter
	 */
	@AuraEnabled
	public static THOR_OrderListRelatedDTO getRelatedNotificationsByStatus(
		String orderIdentifier,
		String notificationStatus,
		String mainWorkCenterFilter,
		Boolean userFilterActive,
		Date fromDateFilter,
		Date toDateFilter,
		Integer loadLimit
	) {
		Set<String> status = new Set<String>{ notificationStatus };
		if (notificationStatus.equalsIgnoreCase('In Progress') || notificationStatus.equalsIgnoreCase('Closed')) {
			status.add('In Progress');
			status.add('Closed');
		}
		String userRoleName = getUserRoleName();

		if (loadLimit == 0) {
			loadLimit = Constants.SOQL.SOQL_LIMIT;
		}

		try {
			THOR_OrderListRelatedDTO dto = new THOR_OrderListRelatedDTO();
			Order__c temporalOrderVariable = [
				SELECT
					Id,
					(
						SELECT
							Id,
							Name,
							Notification_Status__c,
							Notification_Number__c,
							Type__c,
							Functional_Location__r.Name,
							Priority__c,
							Requested_Date__c,
							CreatedDate,
							Description__c,
							Main_Work_Center__r.Name,
							AssignedTo__c
						FROM Notifications__r
						WHERE Notification_Status__c IN :status
						LIMIT :loadLimit
					)
				FROM Order__c
				WHERE Id = :orderIdentifier
				WITH SECURITY_ENFORCED
				LIMIT 1
			];

			List<Notification__c> filteredNotifications = new List<Notification__c>();
			for (Notification__c notification : temporalOrderVariable.Notifications__r) {
				if (
					notification.Main_Work_Center__r != null &&
					notification.Main_Work_Center__r.Name.contains(mainWorkCenterFilter) &&
					(!userFilterActive || notification.AssignedTo__c == UserInfo.getUserId()) &&
					(fromDateFilter == null ||
					notification.CreatedDate.Date() >= fromDateFilter) &&
					(toDateFilter == null ||
					notification.CreatedDate.Date() <= toDateFilter)
				) {
					filteredNotifications.add(notification);
				}
			}

			dto.relatedNotifications = filteredNotifications;
			return dto;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description retrieves all Notifications, Sub Orders and Operations that are related to a specific Order
	 * @return The Order plus related Orders
	 * @param orderIdentifier
	 * @param orderStatus
	 */
	@AuraEnabled
	public static THOR_OrderListRelatedDTO getRelatedOrdersByStatus(String orderIdentifier, string orderStatus) {
		List<String> status = new List<String>();
		status.add(orderStatus);
		if (orderStatus.equals('In Progress')) {
			status.add('Closed');
		}
		try {
			THOR_OrderListRelatedDTO dto = new THOR_OrderListRelatedDTO();
			Order__c temporalOrderVariable = [
				SELECT
					Id,
					(
						SELECT
							Id,
							Name,
							Order_Status__c,
							Order_Type__c,
							Description__c,
							Priority__c,
							Requested_Date__c,
							Order_Number__c,
							Functional_Location__r.Name,
							CreatedDate
						FROM Orders__r
						WHERE Order_Status__c IN :status
					)
				FROM Order__c
				WHERE Id = :orderIdentifier
				WITH SECURITY_ENFORCED
				LIMIT 1
			];
			dto.relatedSubOrders = temporalOrderVariable.Orders__r;
			return dto;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description retrieves all Notifications, Sub Orders and Operations that are related to a specific Order
	 * @return The Order plus related Orders
	 * @param orderIdentifier
	 * @param orderStatus
	 * @param mainWorkCenterFilter
	 * @param userFilterActive
	 * @param fromDateFilter
	 * @param toDateFilter
	 */
	@AuraEnabled
	public static THOR_OrderListRelatedDTO getRelatedOrdersByStatus(
		String orderIdentifier,
		string orderStatus,
		String mainWorkCenterFilter,
		Boolean userFilterActive,
		Date fromDateFilter,
		Date toDateFilter,
		Integer loadLimit
	) {
		List<String> status = new List<String>();
		status.add(orderStatus);
		if (orderStatus.equals('In Progress')) {
			status.add('Closed');
		}

		String userRoleName = getUserRoleName();

		if (loadLimit == 0) {
			loadLimit = Constants.SOQL.SOQL_LIMIT;
		}

		try {
			THOR_OrderListRelatedDTO dto = new THOR_OrderListRelatedDTO();
			Order__c temporalOrderVariable = [
				SELECT
					Id,
					(
						SELECT
							Id,
							Name,
							Order_Status__c,
							Order_Type__c,
							Description__c,
							Priority__c,
							Requested_Date__c,
							Order_Number__c,
							Functional_Location__r.Name,
							CreatedDate,
							Main_Work_Center__r.Name,
							Responsible_Person__c
						FROM Orders__r
						WHERE Order_Status__c IN :status
						LIMIT :loadLimit
					)
				FROM Order__c
				WHERE Id = :orderIdentifier
				WITH SECURITY_ENFORCED
				LIMIT 1
			];

			List<Order__c> filteredOrders = new List<Order__c>();
			for (Order__c order : temporalOrderVariable.Orders__r) {
				if (
					order.Main_Work_Center__r != null &&
					order.Main_Work_Center__r.Name.contains(mainWorkCenterFilter) &&
					(!userFilterActive || order.Responsible_Person__c == UserInfo.getUserId()) &&
					(fromDateFilter == null ||
					order.CreatedDate.Date() >= fromDateFilter) &&
					(toDateFilter == null ||
					order.CreatedDate.Date() <= toDateFilter)
				) {
					filteredOrders.add(order);
				}
			}

			dto.relatedSubOrders = filteredOrders;
			return dto;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	//----------- HELPER METHODS -----------

	private static String getUserRoleName() {
		Id userId = UserInfo.getUserId();

		String userRoleName = '';
		List<User> userList = [SELECT UserRole.Name FROM User WHERE Id = :userId WITH SECURITY_ENFORCED];
		if (userList.size() > 0) {
			userRoleName = userList[0].UserRole.Name;
		}

		return userRoleName;
	}
}