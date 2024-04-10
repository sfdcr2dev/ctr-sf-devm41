/**
 * @author Oktana
 * @description trigger for Item__c
 */
trigger ItemTrigger on Item__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new ItemTriggerHandler());
}