/**
 * @author Oktana
 * @description Order__c trigger implementation class
 */
public with sharing class OrderTriggerHandler implements ITriggerHandler {
	public static Boolean TriggerDisabled = false;
	public Boolean isDisabled() {
		return TriggerDisabled;
	}
	public void beforeInsert(List<SObject> newItems) {
		// OrderHandler.populateOrderNumber(newItems);
		// THOR_IRPAIntegration.checkIsSOAP_Order(newItems);
		THOR_IRPAIntegration_Order.checkOrder_beforeTrigger(newItems, new Map<Id, SObject>());
	}
	public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		// THOR_IRPAIntegration.checkIsSOAP_Order(newItems.values());
		THOR_IRPAIntegration_Order.checkOrder_beforeTrigger(newItems.values(), oldItems);
	}
	public void beforeDelete(Map<Id, SObject> oldItems) {
	}
	public void afterInsert(Map<Id, SObject> newItems) {
		if (ApexUtils.runOnce('OrderHandler#handleAlerts')) {
			OrderHandler.handleAlerts(newItems.values());
		}
		OrderHandler.createOrderOperationAndOperation(newItems.values());
		THOR_IRPAIntegration_Order.checkOrder_afterInsert(newItems);
		if (ApexUtils.runOnce('THOR_IRPAIntegration_Order#pushNotificationIntegrationSAP')) {
			THOR_IRPAIntegration_Order.pushNotificationIntegrationSAP(newItems.values());
		}
	}
	public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		if (ApexUtils.runOnce('OrderHandler#handleAlerts')) {
			OrderHandler.handleAlerts(newItems, oldItems);
		}
		THOR_IRPAIntegration_Order.checkOrder_afterUpdate(newItems, oldItems);
		if (ApexUtils.runOnce('THOR_IRPAIntegration_Order#pushNotificationIntegrationSAP')) {
			THOR_IRPAIntegration_Order.pushNotificationIntegrationSAP(newItems.values());
		}
        EMOC_OrderController.EMOC_OrderAfterTrigger(newItems, oldItems);
	}
	public void afterDelete(Map<Id, SObject> oldItems) {
	}
	public void afterUndelete(Map<Id, SObject> oldItems) {
	}
}