/**
 * @author K.B. Carte
 * @description Gets notifications
*/
public with sharing class THOR_CalendarJSController {
    /**
     * @description Gets notifications to display in the calendar
     * @return list of Notifications
     */
    @AuraEnabled
    public static List<Notification__c> getNotifications(){
        List<Notification__c> result =  [SELECT Id, Name, Required_Start__c, Required_End__c FROM Notification__c];
        // Boolean isMobile = UserInfo.getUiTheme() == 'Theme4t';
        return result;
    }

    /**
     * @description Gets whether or not we are on mobile/salesforce1 app
     * @return boolean of if we're on mobile. False is desktop, True is on mobile/SF1
     */
    @AuraEnabled
    public static Boolean getIsMobile(){
        return UserInfo.getUiTheme() == 'Theme4t';
    }
}