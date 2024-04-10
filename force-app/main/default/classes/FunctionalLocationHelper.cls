public without sharing class FunctionalLocationHelper {
    
    /**
     * @description retrieves Notifications filtered by Functional Location and filters
     * @param functionalLocationId
     * @param mainWorkCenterFilter
     * @param userFilterActive
     * @param fromDateFilter
     * @param toDateFilter
     */
    public static List<Notification__c> getNotificationsByFunctionalLocationAndFilters(
        String functionalLocationId,
        //String mainWorkCenterFilter,
        Boolean userFilterActive,
        Date fromDateFilter,
        Date toDateFilter
    ) {
        List<Notification__c> flNotifications = new List<Notification__c>();

        for (Notification__c flNotification : [
            SELECT
                Id,
                Name,
                Notification_Status__c,
                Type__c,
                Description__c,
                Priority__c,
                Requested_Date__c,
                Notification_Number__c,
                CreatedDate,
                Functional_Location__r.Name,
                Main_Work_Center__r.Name,
                Notification__c.AssignedTo__c
            FROM Notification__c
            WHERE Functional_Location__r.Id = :functionalLocationId
            WITH SECURITY_ENFORCED
            ORDER BY Notification_Number__c DESC
        ]) {
            if (
                //flNotification.Main_Work_Center__r != null &&
                //flNotification.Main_Work_Center__r.Name.contains(mainWorkCenterFilter) &&
                (!userFilterActive || flNotification.AssignedTo__c == UserInfo.getUserId()) &&
                (fromDateFilter == null ||
                flNotification.CreatedDate.Date() >= fromDateFilter) &&
                (toDateFilter == null ||
                flNotification.CreatedDate.Date() <= toDateFilter)
            ) {
                flNotifications.add(flNotification);
            }
        }

        return flNotifications;
    }
}