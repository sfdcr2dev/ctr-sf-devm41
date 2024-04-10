/**
 * @author R2
 * @description trigger for OPP_Notification__c
 */
trigger OPP_NotificationTrigger on OPP_Notification__c (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete) {
    TriggerDispatcher.run(new OPP_NotificationTriggerHandler());
}