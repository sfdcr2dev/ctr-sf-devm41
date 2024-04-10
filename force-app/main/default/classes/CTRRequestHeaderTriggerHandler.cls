public with sharing class CTRRequestHeaderTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) 
    {
        CTRRequestHeaderHandler.prepopulateValueBeforeInsert((List<CTRRequestFormHeader__c>)newItems);
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) 
    {
        CTRRequestHeaderHandler.modifyJsonIdToNameBeforeUpdatev2((Map<Id, CTRRequestFormHeader__c>) oldItems, (Map<Id, CTRRequestFormHeader__c>) newItems); 
        
        //CTRRequestHeaderHandler.AddJsonEditInfoBeforeUpdate((Map<Id, CTRRequestFormHeader__c>) oldItems, (Map<Id, CTRRequestFormHeader__c>) newItems); 
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {

    }
    public void afterInsert(Map<Id, SObject> newItems) {
        CTRRequestHeaderHandler.createShareholderAfterInsert((List<CTRRequestFormHeader__c>)newItems.values());
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) 
    {
		//CTRRequestHeaderHandler.onChangeJsonForEditAfterUpdate((Map<Id, CTRRequestFormHeader__c>) oldItems, (Map<Id, CTRRequestFormHeader__c>) newItems); 
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
}