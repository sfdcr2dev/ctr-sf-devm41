/**
 * Relevant User trigger handler class to handle event CRUD on Relevant User object.
 */
public class ORTLRelUserTriggerHandler implements ITriggerHandler {

	public static Boolean TriggerDisabled = false;
	public Boolean isDisabled() {
		return TriggerDisabled;
	}
	public void beforeInsert(List<SObject> newItems) {
        ORTLActionCtrl.updateRelevantUserName(newItems);
	}
	public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        ORTLActionCtrl.updateRelevantUserName(newItems.values());
	}
	public void beforeDelete(Map<Id, SObject> oldItems) {
	}
	public void afterInsert(Map<Id, SObject> newItems) {
	}
	public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
	}
	public void afterDelete(Map<Id, SObject> oldItems) {
	}
	public void afterUndelete(Map<Id, SObject> oldItems) {
	}
}