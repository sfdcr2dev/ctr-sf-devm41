/* Trigger for Permit__c */

trigger trg_CheckPermit on Permit__c (before insert, after update) {

    if(Trigger.IsBefore && Trigger.IsInsert) {
        
        CPEM_PermitForTriggerController.CreatePermit(Trigger.New[0]);
        
    }
    
    if(Trigger.IsAfter && Trigger.IsUpdate) {
        
        CPEM_PermitForTriggerController.UpdatePermit(Trigger.Old[0], Trigger.New[0]);
        
    }
    
}