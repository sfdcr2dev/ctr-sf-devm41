/**
 * @author Oktana
 * @description Cause__c trigger implementation class
 */
public with sharing class CauseTriggerHandler implements ITriggerHandler {
	public static Boolean TriggerDisabled = false;
	public Boolean isDisabled() {
		return TriggerDisabled;
	}
	public void beforeInsert(List<SObject> newItems) {
		CauseHandler.handleItemCause(newItems);

		THOR_iRPAIntegration_Cause.checkIsSOAP_Cause(newItems);
	}
	public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		THOR_iRPAIntegration_Cause.checkIsSOAP_Cause(newItems.values());
	}
	public void beforeDelete(Map<Id, SObject> oldItems) {
	}
	public void afterInsert(Map<Id, SObject> newItems) {
		//THOR_iRPAIntegration_Cause.checkCause_afterInsert(newItems);
	}
	public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		//THOR_iRPAIntegration_Cause.checkCause_afterUpdate(newItems, oldItems);
	}
	public void afterDelete(Map<Id, SObject> oldItems) {
	}
	public void afterUndelete(Map<Id, SObject> oldItems) {
	}
}