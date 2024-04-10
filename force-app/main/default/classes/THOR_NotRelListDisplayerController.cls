/**
 * @author Sebastian Bucalo
 * @description Queries all related Notification Object
 */
public with sharing class THOR_NotRelListDisplayerController {
    /**
     * @description retrieves all Items, Orders and Files that are related to a specific Notification
     * @return THOR_NotificationListRelatedDTO
     * @param notificationIdentifier
     */
    @AuraEnabled
    public static THOR_NotificationListRelatedDTO getRelatedObjects(String notificationIdentifier) {
        return THOR_NotificationsListRelatedController.getRelatedObjects(notificationIdentifier);
    }
    
    @AuraEnabled
    public static Boolean hasWriteAccess(String recordId) {
        List<UserRecordAccess> access = [
            SELECT RecordId
            FROM UserRecordAccess
            WHERE HasEditAccess = true AND RecordId = :recordId AND UserId = :UserInfo.getUserId()
        ];
        
        return !access.isEmpty();
    }
}