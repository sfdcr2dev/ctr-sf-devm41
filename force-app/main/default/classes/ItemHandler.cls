/**
 * @author Oktana
 */
public with sharing class ItemHandler {
	/**
	 * @description populates Item_No__c and NotiItem__c for every new Item
	 */
	public static void updateNotiItemField(List<Item__c> items) {
		Set<Id> notificationIds = new Set<Id>();
		for (Item__c item : items) {
			notificationIds.add(item.Notification__c);
		}

		Map<Id, Notification__c> notifications = new Map<Id, Notification__c>(getNotificationsById(notificationIds));
		Map<Id, Notification__c> notificationsToUpdate = new Map<Id, Notification__c>();
		Integer lastItemNo;
		for (Item__c item : items) {
			lastItemNo = (notifications.get(item.Notification__c).Last_Item__c != null)
				? Integer.valueOf(notifications.get(item.Notification__c).Last_Item__c)
				: 0;
			lastItemNo = getNextItemNo(lastItemNo);

			item.Sort_No__c = String.valueOf(lastItemNo);
			if (item.Item_No__c == null) {
				item.Item_No__c = String.valueOf(lastItemNo);
			}
			if (item.NotiItem__c == null) {
				item.NotiItem__c = item.Notification__c + String.valueOf(lastItemNo);
			}

			notifications.get(item.Notification__c).Last_Item__c = String.valueOf(lastItemNo);
			notificationsToUpdate.put(item.Notification__c, notifications.get(item.Notification__c));
		}

		if (Schema.SObjectType.Notification__c.isUpdateable()) {
			update notificationsToUpdate.values();
		}
	}

	private static Integer getNextItemNo(Integer lastItemNo) {
		return lastItemNo + 1;
	}

	private static List<Notification__c> getNotificationsById(Set<Id> notificationIds) {
		return [SELECT Id, Last_Item__c FROM Notification__c WHERE Id IN :notificationIds WITH SECURITY_ENFORCED];
	}
}