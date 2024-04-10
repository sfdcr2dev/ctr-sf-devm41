/**
 * @author Sebastian Bucalo
 * @description helper for SetFirstNotification Trigger
 */
public with sharing class SetFirstNotificationHelper {
	/**
	 * @description updates the order with the first notification object
	 * @param notifications
	 */
	public static void updateNotificationAndOrder(List<Notification__c> notifications) {
		Map<Id, Set<Id>> notificationsByOrders = new Map<Id, Set<Id>>();

		for (Notification__c notification : notifications) {
			if (notification.Order__c != null) {
				if (!notificationsByOrders.containsKey(notification.Order__c)) {
					notificationsByOrders.put(notification.Order__c, new Set<Id>());
				}

				notificationsByOrders.get(notification.Order__c).add(notification.Id);
			}
		}

		List<Order__c> ordersToUpdate = getOrdersToUpdate(notificationsByOrders.keySet());
		for (Order__c order : ordersToUpdate) {
			Id notiId = new List<Id>(notificationsByOrders.get(order.Id))?.get(0);
			if (notiId != null && order.Notification__c == null) {
				order.Notification__c = notiId;
			}
		}

		if (Schema.sObjectType.Order__c.isUpdateable()) {
			update ordersToUpdate;
		}
	}

	/**
	 * @description send alert for updated Notification to the person it was Assigned To
	 */
	public static void handleNotificationAlerts(Map<Id, sObject> newNotifications, Map<Id, sObject> oldNotifications) {
		List<Notification__c> notificationsToCheck = new List<Notification__c>();
		for (Notification__c newNotification : (List<Notification__c>) newNotifications.values()) {
			Notification__c oldNotification = (Notification__c) oldNotifications.get(newNotification.id);
			if (changedRelevantFields(newNotification, oldNotification)) {
				notificationsToCheck.add(newNotification);
			}
		}
		handleAlerts(notificationsToCheck);
	}

	private static void handleAlerts(List<Notification__c> notifications) {
		List<NotificationAlert> alerts = new List<NotificationAlert>();
		Id alertType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'THOR_Push_Notification'].Id;
		for (Notification__c notification : notifications) {
			alerts.add(
				new NotificationAlert(
					CustomNotificationHelper.buildAlert(
						alertType,
						getNotificationPageRef(notification.Id),
						resolveAlertBody(notification),
						'New Notification'
					),
					notification
				)
			);
		}
		handleSendAlerts(alerts);
	}

	private static void handleSendAlerts(List<NotificationAlert> notificationAlerts) {
		for (NotificationAlert notificationAlert : notificationAlerts) {
			Set<String> receivers = new Set<String>{ String.valueOf(notificationAlert.notification.AssignedTo__c) };
			if (!receivers.isEmpty()) {
				CustomNotificationHelper.sendAlert(notificationAlert.alert, receivers);
			}
		}
	}

	private class NotificationAlert {
		Messaging.CustomNotification alert;
		Notification__c notification;

		public NotificationAlert(Messaging.CustomNotification alert, Notification__c notification) {
			this.alert = alert;
			this.notification = notification;
		}
	}

	private static Boolean isSameUser(Id firstUser, Id secondUser) {
		return firstUser == secondUser;
	}

	private static Boolean changedRelevantFields(
		Notification__c firstNotification,
		Notification__c secondNotification
	) {
		return (firstNotification.AssignedTo__c != secondNotification.AssignedTo__c) ||
			(firstNotification.Description__c != secondNotification.Description__c) ||
			(firstNotification.Notification_Status__c != secondNotification.Notification_Status__c) ||
			(firstNotification.User_Status__c != secondNotification.User_Status__c) ||
			(firstNotification.Fault_Code__c != secondNotification.Fault_Code__c) ||
			(firstNotification.Functional_Location__c != secondNotification.Functional_Location__c);
	}

	private static String getNotificationPageRef(Id notificationId) {
		return '{"type": "standard__component", "attributes": {"componentName": "c__THOR_NotificationRecordDisplay"}, "state": {"c__recordId": "' +
			notificationId +
			'"}}';
	}

	private static String resolveAlertBody(Notification__c notification) {
		return CustomNotificationHelper.buildFormattedMessage(
			'{0} assigned to you',
			new List<String>{ notification.Notification_Number__c }
		);
	}

	/**
	 * @description retrieves orders where the Notification field can be updated
	 * @param orderIds
	 * @return List<Order__c>
	 */
	private static List<Order__c> getOrdersToUpdate(Set<Id> orderIds) {
		return [SELECT Id, Notification__c FROM Order__c WHERE Notification__c = NULL AND Id IN :orderIds WITH SECURITY_ENFORCED];
		// Super_Order__c = NULL AND
	}
}