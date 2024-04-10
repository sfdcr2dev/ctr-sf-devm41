/**
 * @author R2
 * @description OPP_Notification__c trigger implementation class
 */
public with sharing class OPP_NotificationTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) {
        //TriggerDisabled = true;
        //OPP_NotificationTriggerHelper.createNotificationBell(newItems);
        //TriggerDisabled = false;
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        //TriggerDisabled = true;
        //OPP_NewsTriggerHelper.disableHighlight(newItems, oldItems);
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
    }
    public void afterInsert(Map<Id, SObject> newItems) {
        TriggerDisabled = true;
        OPP_NotificationTriggerHelper.createNotificationBell(newItems);
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        TriggerDisabled = true;
        OPP_NotificationTriggerHelper.createNotificationBell(newItems);
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
}