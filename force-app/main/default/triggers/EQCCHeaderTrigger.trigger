/**
 * @author R2
 * @description trigger for EQCC_Header__c
 */
trigger EQCCHeaderTrigger on EQCC_Header__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new EQCCHeaderTriggerHandler());
}