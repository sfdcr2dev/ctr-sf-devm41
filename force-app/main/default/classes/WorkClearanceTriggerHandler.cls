/**
 * @author Oktana
 * @description Work_Clearance__c trigger implementation class
 */
public with sharing class WorkClearanceTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) {
        THOR_WorkClearanceTriggerHelper.createOrUpdateWorkClearanceHistorical(newItems);
        THOR_iRPAIntegration_WorkClearance.getInstance().checkIsIRPA(newItems, new List<sObject>());
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {	
        THOR_WorkClearanceTriggerHelper.createOrUpdateWorkClearanceHistorical(newItems.values(), oldItems.values());
        THOR_iRPAIntegration_WorkClearance.getInstance().checkIsIRPA(newItems.values(), oldItems.values());
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
    }
    public void afterInsert(Map<Id, SObject> newItems) {
        SetLatestWCHelper.updateNotificationAndOrder(newItems.values());
        THOR_WorkClearanceTriggerHelper.updateWorkClearanceHistoricalParentId(newItems);
        
        THOR_iRPAIntegration_WorkClearance.getInstance().checkWorkClearance_afterCreate(newItems);
        TriggerDisabled = true;
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        SetLatestWCHelper.updateNotificationAndOrder(newItems.values(), oldItems.values());
        THOR_WorkClearanceTriggerHelper.updateWorkClearanceHistoricalParentId(newItems);

        THOR_iRPAIntegration_WorkClearance.getInstance().checkWorkClearance_afterUpdate(newItems, oldItems);
        TriggerDisabled = true;
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
}

///**
// * @author Oktana
// * @description Work_Clearance__c trigger implementation class
// */
//public with sharing class WorkClearanceTriggerHandler implements ITriggerHandler {
//    public static Boolean TriggerDisabled = false;
//    public Boolean isDisabled() {
//        return TriggerDisabled;
//    }
//    public void beforeInsert(List<SObject> newItems) {
//        THOR_WorkClearanceTriggerHelper.createOrUpdateWorkClearanceHistorical(newItems);
//        THOR_iRPAIntegration_WorkClearance.getInstance().checkIsIRPA(newItems, new List<sObject>());
//    }
//    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {	
//        //SetLatestWCHelper.updateNotificationAndOrder(Trigger.old,Trigger.new);
//        
//        THOR_WorkClearanceTriggerHelper.createOrUpdateWorkClearanceHistorical(newItems.values(), oldItems.values());
//        THOR_iRPAIntegration_WorkClearance.getInstance().checkIsIRPA(newItems.values(), oldItems.values());
//    }
//    public void beforeDelete(Map<Id, SObject> oldItems) {
//    }
//    public void afterInsert(Map<Id, SObject> newItems) {
//        SetLatestWCHelper.updateNotificationAndOrder(newItems.values());
//        
//        THOR_iRPAIntegration_WorkClearance.getInstance().checkWorkClearance_afterCreate(newItems);
//        TriggerDisabled = true;
//    }
//    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
//        SetLatestWCHelper.updateNotificationAndOrder(newItems.values(), oldItems.values());
//        
//        System.debug('Work Clearance Trigger: after update');
//        THOR_iRPAIntegration_WorkClearance.getInstance().checkWorkClearance_afterUpdate(newItems, oldItems);
//        TriggerDisabled = true;
//    }
//    public void afterDelete(Map<Id, SObject> oldItems) {
//    }
//    public void afterUndelete(Map<Id, SObject> oldItems) {
//    }
//}