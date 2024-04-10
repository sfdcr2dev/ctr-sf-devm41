/**
 * @author Oktana
 */
public with sharing class ActivityHandler {
    public static void updateItemActivityField(List<Activity__c> activities) {
        Set<Id> itemIds = new Set<Id>();
        for (Activity__c activity : activities) {
            itemIds.add(activity.Item__c);
        }

        Map<Id, Item__c> items = new Map<Id, Item__c>(getItemsById(itemIds));
        Map<Id, Item__c> itemsToUpdate = new Map<Id, Item__c>();

        Integer lastActivityNo;
        String itemNo;
        for (Activity__c activity : activities) {
            lastActivityNo = (items.get(activity.Item__c).Last_Activity__c != null)
                ? Integer.valueOf(items.get(activity.Item__c).Last_Activity__c)
                : 0;
            lastActivityNo = getNextActivityNo(lastActivityNo);
            itemNo = items.get(activity.Item__c).Item_No__c;

            activity.Activity_No__c = String.valueOf(lastActivityNo);
            activity.Sort_No__c = String.valueOf(lastActivityNo);
            activity.ItemActivity__c = activity.Notification__c + itemNo + String.valueOf(lastActivityNo);

            items.get(activity.Item__c).Last_Activity__c = String.valueOf(lastActivityNo);
            itemsToUpdate.put(activity.Item__c, items.get(activity.Item__c));
        }

        if (Schema.SObjectType.Activity__c.isUpdateable()) {
            update itemsToUpdate.values();
        }
    }

    private static Integer getNextActivityNo(Integer currentActivityNo) {
        return currentActivityNo + 1;
    }

    private static List<Item__c> getItemsById(Set<Id> itemIds) {
        return [SELECT Id, Last_Activity__c, Item_No__c FROM Item__c WHERE Id IN :itemIds WITH SECURITY_ENFORCED];
    }
    
    public static void updateNotiActivityField(List<Activity__c> activities) {
        Set<Id> itemIds = new Set<Id>();
        Set<Id> notificationIds = new Set<Id>();
        for (Activity__c activity : activities) {
            itemIds.add(activity.Item__c);
            notificationIds.add(activity.Notification__c);
        }
        
        Map<Id, Item__c> items = new Map<Id, Item__c>(getItemsById(itemIds));
        Map<Id, Item__c> itemsToUpdate = new Map<Id, Item__c>();
        
        Map<Id, Notification__c> notifications = new Map<Id, Notification__c>(getNotificationsById(notificationIds));
        Map<Id, Notification__c> notificationsToUpdate = new Map<Id, Notification__c>();
        
        Integer lastActivityNo;
        String itemNo;
        for (Activity__c activity : activities) {
            lastActivityNo = (notifications.get(activity.Notification__c)?.Last_Activity__c != null)
                ? Integer.valueOf(notifications.get(activity.Notification__c).Last_Activity__c)
                : 0;
            lastActivityNo = getNextActivityNo(lastActivityNo);
            itemNo = items.get(activity.Item__c).Item_No__c;

            activity.Activity_No__c = String.valueOf(lastActivityNo);
            activity.Sort_No__c = String.valueOf(lastActivityNo);
            activity.ItemActivity__c = activity.Notification__c + itemNo + String.valueOf(lastActivityNo);

            notifications.get(activity.Notification__c).Last_Activity__c = String.valueOf(lastActivityNo);
            notificationsToUpdate.put(activity.Notification__c, notifications.get(activity.Notification__c));
        }

        if (Schema.SObjectType.Notification__c.isUpdateable()) {
            update notificationsToUpdate.values();
        }
    }

    private static List<Notification__c> getNotificationsById(Set<Id> notificationIds) {
        return [SELECT Id, Last_Activity__c FROM Notification__c WHERE Id IN :notificationIds];
    }
}