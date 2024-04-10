/**
 * @author Oktana
 * @description trigger for Master_Map__c
 */
trigger MasterMapTrigger on Master_Map__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new MasterMapTriggerHandler());
}