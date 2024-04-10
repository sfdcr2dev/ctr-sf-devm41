/**
 * @author Oktana
 * @description trigger for Spare_Part_Request__c
 */
trigger SparePartRequestTrigger on Spare_Part_Request__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new SparePartRequestTriggerHandler());
}