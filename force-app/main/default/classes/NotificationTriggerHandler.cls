/**
 * @author Oktana
 * @description Notification__c trigger implementation class
 */
public with sharing class NotificationTriggerHandler implements ITriggerHandler {
	public static Boolean TriggerDisabled = false;
	public Boolean isDisabled() {
		return TriggerDisabled;
	}
	public void beforeInsert(List<SObject> newItems) {
		THOR_iRPAIntegration_Notification.checkIsSOAP_Noti(newItems, new Map<Id, SObject>());
	}
	public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		THOR_iRPAIntegration_Notification.checkIsSOAP_Noti(newItems.values(), oldItems);
		THOR_iRPAIntegration_Notification.stampFaultCode(newItems.values(), oldItems);
	}
	public void beforeDelete(Map<Id, SObject> oldItems) {
	}
	public void afterInsert(Map<Id, SObject> newItems) {
		SetFirstNotificationHelper.updateNotificationAndOrder(newItems.values());
		THOR_iRPAIntegration_Notification.checkNotification_afterCreate(newItems);
	}
	public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		SetFirstNotificationHelper.updateNotificationAndOrder(newItems.values());
		if (ApexUtils.runOnce('SetFirstNotificationHelper#handleNotificationAlerts')) {
			SetFirstNotificationHelper.handleNotificationAlerts(newItems, oldItems);
		}
		THOR_iRPAIntegration_Notification.checkNotification_afterUpdate(newItems, oldItems);
		if (ApexUtils.runOnce('THOR_iRPAIntegration_Notification#pushNotificationIntegrationSAP')) {
			THOR_iRPAIntegration_Notification.pushNotificationIntegrationSAP(newItems.values());
		}
	}
	public void afterDelete(Map<Id, SObject> oldItems) {
	}
	public void afterUndelete(Map<Id, SObject> oldItems) {
	}
}