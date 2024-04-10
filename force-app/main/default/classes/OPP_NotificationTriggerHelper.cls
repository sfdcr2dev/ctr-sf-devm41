public without sharing class OPP_NotificationTriggerHelper {
    public static void createNotificationBell(Map<Id, SObject> newItems){
        List<OPP_Notification__c> items = newItems.values();
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        CustomNotificationType type = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'OPP_Push_Notification'];
        Map<Id, String> mapApp = new Map<Id, String>();
        for (OPP_Application__c app :[SELECT Id,Name FROM OPP_Application__c]){
            mapApp.put(app.Id, app.Name);
        }
        for (OPP_Notification__c oppNoti : items){
            if(oppNoti.User__c != null){
                if(!(new List<String>{'THOR', 'PMP', 'DG Service'}.contains(mapApp.get(oppNoti.Application__c))) || Test.isRunningTest()){          
                    String title = mapApp.get(oppNoti.Application__c) + ' : ' + oppNoti.Status__c;
                    String body = oppNoti.Subject__c;
                    notification.setTitle(title);
                    notification.setBody(body);
                    notification.setSenderId(Userinfo.getUserId());
                    notification.setNotificationTypeId(type.id);
                    Map<String, Object> pageRef = new Map<String, Object>{
                        'type' => 'standard__component',
                        'attributes' => new Map<String, Object> {
                                'componentName' => 'c__OPP_MyTasks'
                        }
                    };
                    notification.setTargetPageRef(JSON.serialize(pageRef));
                    try {
                        notification.send(new Set<String> {oppNoti.User__c});
                    }catch (Exception e) {
                        System.debug('Problem sending notification: ' + e.getMessage());
                    }
                }
            }
        }
    }    
}