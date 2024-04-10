/**
 * Action trigger handler class to handle event CRUD on Action object.
 */
public class ORTLActionTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) {
		// Update Plant Section related to Functional Location (Tag No.)
		ORTLActionCtrl.updateAPUPlantSection(newItems);
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		// Update Plant Section related to Functional Location (Tag No.)
		ORTLActionCtrl.updateAPUPlantSection(newItems.values());
        // Sending email to notify related users (initiator) when risk are created.
        ORTLActionCtrl.checkAction_beforeTrigger(newItems.values(), oldItems);
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
    }
    public void afterInsert(Map<Id, SObject> newItems) {
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        if (Label.ORTLEnableSendMail.equalsIgnoreCase('true')) {
            // Sending email to notify related users (initiator, all relevant users (CC)) when due date in action are changed.
            ORTLActionCtrl.sendEmailActionDueDateChanged(newItems, oldItems);
            // Sending email to notify related users (initiator, all relevant users (CC)) when action are closed.
            ORTLActionCtrl.sendEmailActionClosed(newItems, oldItems);
            // Sending email to notify related users (initiator, all relevant users (CC)) when action are canceled.
            ORTLActionCtrl.sendEmailActionCanceled(newItems, oldItems);
        }
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
}