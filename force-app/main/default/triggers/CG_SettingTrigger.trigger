/* Author Softever */
trigger CG_SettingTrigger on CG_Setting__c (before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new CG_SettingTriggerHandler());
}