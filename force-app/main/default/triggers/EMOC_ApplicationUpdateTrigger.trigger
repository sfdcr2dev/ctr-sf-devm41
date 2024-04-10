trigger EMOC_ApplicationUpdateTrigger on E_MOC_Application__c (before update, after update)  {
    List<E_MOC_Application__c> emocAppList = Trigger.new;
    if(Trigger.isBefore && Trigger.isUpdate){
        EMOC_ApplicationTriggerHandler.onBeforeUpdateEmocApp(emocAppList, Trigger.oldMap);
        EMOC_ApplicationTriggerHandler.onBeforeUpdateEmocAppTask(emocAppList, Trigger.oldMap);
    }
    if(Trigger.IsAfter && Trigger.IsUpdate) {
        EMOC_ApplicationTriggerHandler.onAfterUpdateEmocApp(emocAppList, Trigger.oldMap);
    }
}