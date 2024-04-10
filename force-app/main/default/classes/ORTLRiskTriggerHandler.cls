/**
 * Risk trigger handler class to handle event CRUD on Risk object.
 */
public class ORTLRiskTriggerHandler implements ITriggerHandler {

	public static Boolean TriggerDisabled = false;
	public Boolean isDisabled() {
		return TriggerDisabled;
	}
	public void beforeInsert(List<SObject> newItems) {
		// Update APU, Plant Section and also Discipline related to Functional Location (Tag No.)
		ORTLRiskCtrl.updateAPUPlantSectionDiscipline(newItems);
	}
	public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		// Update APU, Plant Section and also Discipline related to Functional Location (Tag No.)
		ORTLRiskCtrl.updateAPUPlantSectionDiscipline(newItems.values());
	}
	public void beforeDelete(Map<Id, SObject> oldItems) {
	}
	public void afterInsert(Map<Id, SObject> newItems) {
        if (Label.ORTLEnableSendMail.equalsIgnoreCase('true')) {
            // Sending email to notify related users (initiator) when risk are created.
            ORTLRiskCtrl.sendEmailRiskRegistered(newItems);
        }
	}
	public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        if (Label.ORTLEnableSendMail.equalsIgnoreCase('true')) {
            // Sending email to notify related users (initiator, all relevant users (CC) in all actions related to risks) when risk are closed.
            ORTLRiskCtrl.sendEmailRiskClosed(newItems, oldItems);
            // Sending email to notify related users (initiator, all relevant users (CC) in all actions relatedto risks) when risk are completed.
            ORTLRiskCtrl.sendEmailRiskCompleted(newItems, oldItems);
        }
	}
	public void afterDelete(Map<Id, SObject> oldItems) {
	}
	public void afterUndelete(Map<Id, SObject> oldItems) {
	}
}