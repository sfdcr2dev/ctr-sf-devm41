/**
 * @author Oktana
 * @description trigger for activity__c
 */
trigger ActivityTrigger on activity__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new ActivityTriggerHandler());
}