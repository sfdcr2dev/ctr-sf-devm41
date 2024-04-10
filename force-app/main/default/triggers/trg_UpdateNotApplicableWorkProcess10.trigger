/* Trigger for ITB with Sub Contract Work Process 10 */
trigger trg_UpdateNotApplicableWorkProcess10 on ITB_with_Sub_Contract__c (after update) {

    if(Trigger.IsAfter && Trigger.IsUpdate) {
    
        CPEM_UpdateNotApplicableWPController.UpdateWorkProcess10(Trigger.Old[0], Trigger.New[0]);
        
    }
    
}