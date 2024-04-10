/**
 * @author Sebastian Bucalo
 * @description helper for UpdateRelatedRecordStatus trigger
 */
public with sharing class UpdateRelatedRecordStatusHelper {
    /**
     * @description updates the record status related to masterMapList
     * @param masterMapList
     */
    public static void updateRecordStatus(List<Master_Map__c> masterMapList) {
        //get the master_map_set Ids with their master map names
        Map<Id, List<String>> sets = new Map<Id, List<String>>();

        for (Master_Map__c masterMap : masterMapList) {
            //check if master map is used to set an status
            if (masterMap.Master_Map_Set__c != null) {
                if (sets.get(masterMap.Master_Map_Set__c) == null) {
                    sets.put(masterMap.Master_Map_Set__c, new List<String>());
                }
                //add the name to the set
                sets.get(masterMap.Master_Map_Set__c).add(masterMap.Name);
            }
        }

        //Update records status
        updateNotificationStatus(sets);
    }

    /**
     * @description updates the notification status related to masterMapList
     * @param sets
     */
    private static void updateNotificationStatus(Map<Id, List<String>> sets) {
        //sets status
        String newStatus = Constants.NOTIFICATIONS.SYSTEM_STATUS_OSNO;
        String progressStatus = Constants.NOTIFICATIONS.SYSTEM_STATUS_NOPR;
        String closeStatus = Constants.NOTIFICATIONS.SYSTEM_STATUS_NOCO;

        //notification status
        String notificationNew = Constants.NOTIFICATIONS.STATUS_NEW;
        String notificationProgress = Constants.NOTIFICATIONS.STATUS_IN_PROGRESS;
        String notificationClose = Constants.NOTIFICATIONS.STATUS_CLOSED;

        //notifications to update
        List<Notification__c> notificationsToUpdate = new List<Notification__c>();
        if (Schema.sObjectType.Notification__c.isAccessible()) {
            notificationsToUpdate = [
                SELECT Id, Name, Notification_Status__c, Notification_Status_Set__c
                FROM Notification__c
                WHERE Notification_Status_Set__c IN :sets.keySet()
            ];
        }

        for (Notification__c notification : notificationsToUpdate) {
            //get status list
            List<String> statusList = sets.get(notification.Notification_Status_Set__c);

            //update notification status
            if (statusList.contains(newStatus)) {
                notification.Notification_Status__c = notificationNew;
            } else if (statusList.contains(progressStatus)) {
                notification.Notification_Status__c = notificationProgress;
            } else if (statusList.contains(closeStatus)) {
                notification.Notification_Status__c = notificationClose;
            }
        }

        //update orders list
        if (Schema.sObjectType.Notification__c.isUpdateable()) {
            update notificationsToUpdate;
        }
    }
}