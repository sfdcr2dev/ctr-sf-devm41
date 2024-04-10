/* Trigger to auto create all Work Process once Project is created. */

trigger trg_AutoCreateAllWorkProcess on Project__c (after insert) {

    if(Trigger.isAfter && Trigger.isInsert) {
        
        CPEM_ProjectForTriggerController.CreateProject(Trigger.New[0]);
        
    }
    
    
}