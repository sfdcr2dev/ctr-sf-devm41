/* Trigger to create ITB SubContractor, CCE Approval Process, Cost Estimate from SubContractor Bidding */

trigger trg_CreateSubContractorBidding on Subcontractor_Bidding__c (after insert) {

    if(Trigger.IsAfter && Trigger.IsInsert) {
        
        CPEM_SubContractorForTriggerController.CreateSubContractorBidding(Trigger.New[0]);
        
    }
    
}