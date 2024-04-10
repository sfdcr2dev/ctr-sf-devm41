/* Author Softever */
trigger CG_ReportingTrigger on CG_Reporting__c (before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new CG_ReportingTriggerHandler());
}