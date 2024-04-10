/* Author Softever */
trigger CG_SettingItemTrigger on CG_Setting_Items__c (before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    TriggerDispatcher.run(new CG_SettingItemTriggerHandler());
}