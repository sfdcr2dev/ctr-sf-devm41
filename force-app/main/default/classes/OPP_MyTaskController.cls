public class OPP_MyTaskController {

    @AuraEnabled
    public static String getCountNotifications(){
        try {
            Integer notifications = [SELECT COUNT() FROM OPP_Notification__c WHERE User__c =: UserInfo.getUserId() AND (Status__c = 'New' OR Status__c = 'Reassigned' OR (Status__c = 'Rejected' AND Application__r.Name = 'THOR'))];
            return String.valueOf(notifications);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<string> getApplicationNames(){
        try {
            List<String> appNames = new List<String>();
            List<OPP_Application__c> applications = [SELECT Id, Name FROM OPP_Application__c WHERE Notification__c = true];
            for(OPP_Application__c application : applications) {
                appNames.add(application.Name);
            }
            return appNames;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<WrapTask> getMyTasks(){
        try {
            OPP_AribaController.getMyPendingApprovables();
            List<WrapTask> wrapTasks = new List<WrapTask>();
            Map<String, List<OPP_Notification__c>> applicationMaps = new Map<String, List<OPP_Notification__c>>();
            Set<String> appNames = new Set<String>();
            List<OPP_Notification__c> notifications = [SELECT Id,Name,Application__r.Name,URL__c,Subject__c,LastModifiedDate FROM OPP_Notification__c WHERE User__c =: UserInfo.getUserId() AND (Status__c ='New' OR Status__c ='Reassigned' OR (Status__c ='Rejected' AND Application__r.Name ='THOR')) ORDER BY LastModifiedDate DESC];
            for(OPP_Notification__c notification : notifications) {
                appNames.add(notification.Application__r.Name);
            }

            for(String appName : appNames) {
                List<OPP_Notification__c> appNotifications = [SELECT Id, Name, Application__r.Name,URL__c,Subject__c,LastModifiedDate,Requester__c,UserName__c,ReferenceID__c FROM OPP_Notification__c WHERE Application__r.Name =: appName AND User__c =: UserInfo.getUserId() AND (Status__c ='New' OR Status__c ='Reassigned' OR (Status__c ='Rejected' AND Application__r.Name ='THOR')) ORDER BY LastModifiedDate DESC];
                applicationMaps.put(appName, appNotifications);
            }

            for(String appName : appNames) {
                    List<OPP_Notification__c> notis = applicationMaps.get(appName);
                    WrapTask wrapTask = new WrapTask();
                    WrapTask.appName = appName;
                    WrapTask.tasks = notis.size();
                    WrapTask.notifications = notis;
                    WrapTasks.add(wrapTask);
            }
            return WrapTasks;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<WrapTask> searchTasks(String str){
        try {
            List<WrapTask> wrapTasks = new List<WrapTask>();
            Map<String, List<OPP_Notification__c>> applicationMaps = new Map<String, List<OPP_Notification__c>>();
            Set<String> appNames = new Set<String>();
            String search = '%'+str+'%';
            List<OPP_Notification__c> notifications = [SELECT Id, Name, Application__r.Name,URL__c,Subject__c,LastModifiedDate,Requester__c FROM OPP_Notification__c WHERE User__c =: UserInfo.getUserId() AND (Status__c = 'New' OR Status__c = 'Reassigned' OR (Status__c = 'Rejected' AND Application__r.Name = 'THOR')) AND
                                                       (Application__r.Name LIKE : search OR Subject__c LIKE : search OR Requester__c LIKE : search) ORDER BY LastModifiedDate DESC];
            for(OPP_Notification__c notification : notifications) {
                appNames.add(notification.Application__r.Name);
            }

            for(String appName : appNames) {
                List<OPP_Notification__c> appNotifications = [SELECT Id,Name,Application__r.Name,URL__c,Subject__c,LastModifiedDate,Requester__c FROM OPP_Notification__c WHERE Application__r.Name =: appName 
                                                              AND User__c =: UserInfo.getUserId() AND (Status__c = 'New' OR Status__c = 'Reassigned') AND (Application__r.Name LIKE : search OR Subject__c LIKE : search OR Requester__c LIKE : search) ORDER BY LastModifiedDate DESC];
                applicationMaps.put(appName, appNotifications);
            }

            for(String appName : appNames) {
                    List<OPP_Notification__c> notis = applicationMaps.get(appName);
                    WrapTask wrapTask = new WrapTask();
                    WrapTask.appName = appName;
                    WrapTask.tasks = notis.size();
                    WrapTask.notifications = notis;
                    WrapTasks.add(wrapTask);
            }
            return WrapTasks;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getUrl(Id Id){
        try {
            String url = [SELECT Id, Url__c FROM OPP_Notification__c WHERE Id =: Id].Url__c;
            return url;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}