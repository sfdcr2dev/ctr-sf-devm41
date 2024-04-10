public class CTRLeadTriggerHandler implements ITriggerHandler 
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
		//CTRLeadHandler.CreateDupLead((List<Lead>)oldItems.values());
    }
    public void afterInsert(Map<Id, SObject> newItems) 
    {
        CTRLeadHandler.createSharepointfolderAfterCreate((List<Lead>)newItems.values());
        //CTRAccountHandler.CreateFolderSharePointAfterCreate((List<Account>)newItems.values());
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) 
    {
        //CTRAccountHandler.FindRequestItemAfterUpdate((Map<Id,Account>)oldItems, (Map<Id,Account>)newItems);
        CTRLeadHandler.newsAfterUpdate((Map<Id,Lead>)oldItems, (Map<Id,Lead>)newItems);
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
        		CTRLeadHandler.CreateDupLead((List<Lead>)oldItems.values());
    }
    public void afterUndelete(Map<Id, SObject> oldItems) { 
    }

}