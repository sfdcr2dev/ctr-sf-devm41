/**
 * @author Oktana
 * @description trigger for Order_Operation__c
 */
trigger OrderOperationTrigger on Order_Operation__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new OrderOperationTriggerHandler());
}