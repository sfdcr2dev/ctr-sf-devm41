/**
 * @author Softever
 * @description CG_Setting_Items__c trigger implementation class
 */
public with sharing class CG_SettingItemTriggerHandler implements ITriggerHandler {

    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) {
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
    }
    public void afterInsert(Map<Id, SObject> newItems) {
        CG_SettingItemHandler SettingItemHandler = new CG_SettingItemHandler();
        SettingItemHandler.CreateAndDeleteJobSchedule(newItems.values());
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        CG_SettingItemHandler SettingItemHandler = new CG_SettingItemHandler();
        SettingItemHandler.CreateAndDeleteJobSchedule(newItems.values());
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
}