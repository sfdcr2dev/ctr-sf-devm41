/**
 * @author Oktana
 * @description Item__c trigger implementation class
 */
public with sharing class ItemTriggerHandler implements ITriggerHandler {
	public static Boolean TriggerDisabled = false;
	public Boolean isDisabled() {
		return TriggerDisabled;
	}
	public void beforeInsert(List<SObject> newItems) {
		ItemHandler.updateNotiItemField(newItems);
		THOR_IRPAIntegration_Item.checkIsSOAP_Item(newItems, null);
	}
	public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		THOR_IRPAIntegration_Item.checkIsSOAP_Item(newItems.values(), oldItems);
	}
	public void beforeDelete(Map<Id, SObject> oldItems) {
	}
	public void afterInsert(Map<Id, SObject> newItems) {
		THOR_IRPAIntegration_Item.checkItem_afterInsert(newItems);
	}
	public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		THOR_IRPAIntegration_Item.checkItem_afterUpdate(newItems, oldItems);
	}
	public void afterDelete(Map<Id, SObject> oldItems) {
	}
	public void afterUndelete(Map<Id, SObject> oldItems) {
	}
}