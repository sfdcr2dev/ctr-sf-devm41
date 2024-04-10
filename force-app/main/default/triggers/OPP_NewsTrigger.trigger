/**
 * @author R2
 * @description trigger for OPP_News__c
 */
trigger OPP_NewsTrigger on OPP_News__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new OPP_NewsTriggerHandler());
}