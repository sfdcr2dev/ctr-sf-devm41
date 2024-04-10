/**
 * @author Oktana
 * @description trigger for Order__c
 */
trigger OrderTrigger on Order__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new OrderTriggerHandler());
}