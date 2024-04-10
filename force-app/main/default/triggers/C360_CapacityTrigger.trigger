trigger C360_CapacityTrigger on C360_Capacity__c (before insert) {
    C360_CapacityCheckDuplicateClass.validateCapacityKey(Trigger.new[0]);
}