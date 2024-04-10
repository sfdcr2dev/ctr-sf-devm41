/**
 * @author Oktana
 * @description Spare_Part_Request__c trigger implementation class
 */
public with sharing class SparePartRequestTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) {
        SparePartRequestHandler.updateItemNumberField(newItems);
        // THOR_IRPAIntegration.checkIsSOAP_SparePartRequest(newItems);
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        SparePartRequestHandler.updateOrderOrderOperationField((Map<Id, Spare_Part_Request__c>)newItems);
        // THOR_IRPAIntegration.checkIsSOAP_SparePartRequest(newItems.values());
        THOR_IRPAIntegration_Component.checkSparePartRequest_beforeUpdate(newItems, oldItems);
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
    }
    public void afterInsert(Map<Id, SObject> newItems) {
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        THOR_IRPAIntegration_Component.checkSparePartRequest_afterUpdate(newItems, oldItems);
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
}