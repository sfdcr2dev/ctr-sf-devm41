/**
 * @author Oktana
 * @description trigger for Cause__c
 */
trigger CauseTrigger on Cause__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new CauseTriggerHandler());
}