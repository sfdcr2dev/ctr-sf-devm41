/* Trigger for CCE with Sub Contract Work Process 19 */
trigger trg_UpdateNotApplicableWorkProcess19 on CCE_with_Sub_Contract_19__c (after update) {

    if(Trigger.IsAfter && Trigger.IsUpdate) {
    
        CPEM_UpdateNotApplicableWPController.UpdateWorkProcess19(Trigger.Old[0], Trigger.New[0]);
        
    }
    
}