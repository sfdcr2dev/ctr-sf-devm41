/* Trigger for CCE with Sub Contract Work Process 11 */
trigger trg_UpdateNotApplicableWorkProcess11 on CCE_with_Sub_Contract__c (after update) {

    if(Trigger.IsAfter && Trigger.IsUpdate) {
    
        CPEM_UpdateNotApplicableWPController.UpdateWorkProcess11(Trigger.Old[0], Trigger.New[0]);
        
    }
    
}