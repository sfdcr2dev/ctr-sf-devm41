public class CTRAccountTriggerHandler implements ITriggerHandler 
{
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
    public void afterInsert(Map<Id, SObject> newItems) 
    {
        if(!Test.isRunningTest()){
            //CTRAccountHandler.CreateFolderSharePointAfterCreate((List<Account>)newItems.values());
        }}
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) 
    {
        CTRAccountHandler.CreateFolderSharePointAfterCreate((Map<Id,Account>) oldItems, (Map<Id,Account>) newItems);
        CTRAccountHandler.createRequestFolderAfterSharepointFolderReady((Map<Id,Account>) oldItems, (Map<Id,Account>) newItems);
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) { 
    }
}