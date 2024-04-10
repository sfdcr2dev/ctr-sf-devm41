/**
 * @author Oktana
 * @description trigger for EQCC_Step__c
 */
trigger EQCCStepTrigger on EQCC_Step__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new EQCCStepTriggerHandler());
}