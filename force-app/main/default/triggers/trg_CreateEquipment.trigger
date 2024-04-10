/* Trigger to create Vendor Data Management, Material Inspection from Equipment */

trigger trg_CreateEquipment on Equipment_Plan__c (after insert) {
    
    if(Trigger.IsAfter && Trigger.IsInsert) {
        
        CPEM_CreateEquipmentForTriggerController.CreateEquipment(Trigger.New[0]);
        
    }
    
}