public with sharing class ODM_HomeCtrl {
 
    @AuraEnabled
    public static Object getUser() {
        User user = [SELECT Id, Name ,FirstName, LastName, Main_Work_Center__c
                     FROM User WHERE Id =: userInfo.getUserId()];
        return user;
    }

    @AuraEnabled
    public static Object getNotificationList(
        Map<String, String> filter,
        Integer offset,
        Integer rowlimit,
        Boolean isSharingSettings
    ) {
        return ODM_NotificationController.getNotificationList(filter, offset, rowlimit, isSharingSettings);
    }

    @AuraEnabled
    public static Object getWcList(
        Map<String, String> filter,
        Integer offset,
        Integer rowlimit,
        Boolean isSharingSettings
    ) {
        return ODM_WorkClearanceController.getWcList(filter, offset, rowlimit, isSharingSettings);
    }

    @AuraEnabled
    public static Object getWcVerificationList(
        Map<String, String> filter,
        Integer offset,
        Integer rowlimit,
        Boolean isSharingSettings
    ) {
        return ODM_WorkClearanceController.getWcVerificationList(filter, offset, rowlimit, isSharingSettings);
    }
    
    @AuraEnabled
    public static Object getWcInspectionList(
        Map<String, String> filter,
        Integer offset,
        Integer rowlimit,
        Boolean isSharingSettings
    ) {
        return ODM_WorkClearanceController.getWcInspectionList(filter, offset, rowlimit, isSharingSettings);
    }
}