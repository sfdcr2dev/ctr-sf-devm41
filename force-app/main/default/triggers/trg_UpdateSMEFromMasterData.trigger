/* Trigger for Master Data Detail */
trigger trg_UpdateSMEFromMasterData on Master_Data_Detail__c (after update) {

    if(Trigger.IsAfter && Trigger.IsUpdate) {
        
        CPEM_MasterDataForTriggerController.UpdateSMEFromMasterData(Trigger.New[0], Trigger.Old[0].SME__c);
        
    }
    
}