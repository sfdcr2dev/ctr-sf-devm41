/**
 * @author Softever
 * @description CG_Setting__c trigger implementation class
 */
public with sharing class CG_SettingTriggerHandler implements ITriggerHandler {

    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) {
        CG_SettingHandler SettingHandler = new CG_SettingHandler();
        SettingHandler.CheckSettingCreation(newItems, null);
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        CG_SettingHandler SettingHandler = new CG_SettingHandler();
        SettingHandler.CheckSettingCreation(newItems.values(), oldItems.values());
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
    }
    public void afterInsert(Map<Id, SObject> newItems) {
        CG_SettingHandler SettingHandler = new CG_SettingHandler();
        SettingHandler.CreateAndDeleteJobSchedule(newItems.values());
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        CG_SettingHandler SettingHandler = new CG_SettingHandler();
        SettingHandler.CreateAndDeleteJobSchedule(newItems.values());
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
}