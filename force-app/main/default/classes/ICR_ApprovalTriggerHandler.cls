/**
 * @author Softever
 * @description ICR_Approval__c trigger implementation class
 */
public with sharing class ICR_ApprovalTriggerHandler implements ITriggerHandler {

    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) {
        ICR_ApprovalHandler ICR = new ICR_ApprovalHandler();
        ICR.StatusOnInsert(newItems);
        ICR.FindingLineManager(newItems);
        ICR.LineManagerAutoApprove(newItems);
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        ICR_ApprovalHandler ICR = new ICR_ApprovalHandler();
        ICR.FindingEVP(newItems.values());
        ICR.StatusICRActive(newItems.values(), oldItems.values());
        
        ICR_CustomEmailAndNotiController SendNoti = new ICR_CustomEmailAndNotiController();
        SendNoti.SendNoti(oldItems.values(), newItems.values());
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
    }
    public void afterInsert(Map<Id, SObject> newItems) {
        ICR_ApprovalHandler ICR = new ICR_ApprovalHandler();
        ICR.UnlockICRRecord(newItems.values());
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        
        ICR_CustomEmailAndNotiController SendNotiAfterUpdate = new ICR_CustomEmailAndNotiController();
        SendNotiAfterUpdate.SendNotiAfterRejected(oldItems.values(), newItems.values());
        
        ICR_ApprovalHandler ICRHandler = new ICR_ApprovalHandler();
        ICRHandler.CreateTask(oldItems.values(), newItems.values());
        
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
}