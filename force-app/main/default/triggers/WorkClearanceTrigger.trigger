/**
 * @author Oktana
 * @description trigger for Work_Clearance__c
 */
trigger WorkClearanceTrigger on Work_Clearance__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new WorkClearanceTriggerHandler());
}