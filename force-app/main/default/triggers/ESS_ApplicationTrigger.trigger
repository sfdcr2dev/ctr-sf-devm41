trigger ESS_ApplicationTrigger on ESS_Application__c (before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new ESS_ApplicationTriggerHandler());
}