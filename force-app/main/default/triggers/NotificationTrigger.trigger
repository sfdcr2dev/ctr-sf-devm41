/**
 * @author Oktana
 * @description trigger for Notification__c
 */
trigger NotificationTrigger on Notification__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new NotificationTriggerHandler());
}