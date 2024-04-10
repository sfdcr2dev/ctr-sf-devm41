global class C360_ScheduleContractHeader implements Schedulable
{
	global void execute(SchedulableContext sc) {
         C360_ContractHeaderBatch c = new C360_ContractHeaderBatch();
		 Id batchId = Database.executeBatch(c, 200);
    }
}