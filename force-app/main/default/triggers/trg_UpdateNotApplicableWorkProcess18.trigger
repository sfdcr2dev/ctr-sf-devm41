/* Trigger for ITB with Sub Contract Work Process 18 */
trigger trg_UpdateNotApplicableWorkProcess18 on ITB_with_Sub_Contract_18__c (after update) {

    if(Trigger.IsAfter && Trigger.IsUpdate) {
    
        CPEM_UpdateNotApplicableWPController.UpdateWorkProcess18(Trigger.Old[0], Trigger.New[0]);
        
    }
    
}