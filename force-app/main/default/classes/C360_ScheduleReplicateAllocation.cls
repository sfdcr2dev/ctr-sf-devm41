global class C360_ScheduleReplicateAllocation implements Schedulable {
    global void execute(SchedulableContext sc) {
        C360_CalloutAllocationService.callSyncBuying();
        C360_CalloutAllocationService.syncAllocation('TOP');
        C360_CalloutAllocationService.syncAllocation('TLB'); 
    }
}