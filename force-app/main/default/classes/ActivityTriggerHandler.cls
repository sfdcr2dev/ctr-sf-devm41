/**
 * @author Oktana
 * @description Activity__c trigger implementation class
 */
public with sharing class ActivityTriggerHandler implements ITriggerHandler {
	public static Boolean TriggerDisabled = false;
	public Boolean isDisabled() {
		return TriggerDisabled;
	}
	public void beforeInsert(List<SObject> newItems) {
		ActivityHandler.updateItemActivityField(newItems);
        ActivityHandler.updateNotiActivityField(newItems);
		THOR_iRPAIntegration_Activity.checkIsSOAP_Activity(newItems);
	}
	public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		THOR_iRPAIntegration_Activity.checkIsSOAP_Activity(newItems.values());
	}
	public void beforeDelete(Map<Id, SObject> oldItems) {
	}
	public void afterInsert(Map<Id, SObject> newItems) {
		//THOR_iRPAIntegration_Activity.checkActivity_afterInsert(newItems);
	}
	public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		//THOR_iRPAIntegration_Activity.checkActivity_afterUpdate(newItems, oldItems);
	}
	public void afterDelete(Map<Id, SObject> oldItems) {
	}
	public void afterUndelete(Map<Id, SObject> oldItems) {
	}
}