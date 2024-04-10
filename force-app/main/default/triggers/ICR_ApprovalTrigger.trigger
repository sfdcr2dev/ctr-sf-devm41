/* Author Softever */
trigger ICR_ApprovalTrigger on ICR_Approval__c (before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new ICR_ApprovalTriggerHandler());
}