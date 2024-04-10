/**
 * @author Softever
 * @description ESS_Application__c trigger implementation class
 */
public with sharing class ESS_ApplicationTriggerHandler implements ITriggerHandler {

    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) {
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
    }
    public void afterInsert(Map<Id, SObject> newItems) {
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        ESS_ApplicationHandler ApplicationHandler = new ESS_ApplicationHandler();
        ApplicationHandler.SendEmailWhenUpdatedApplicationStatusFromSAP(newItems.values());
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
}