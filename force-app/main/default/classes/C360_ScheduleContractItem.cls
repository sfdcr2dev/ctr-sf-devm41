global class C360_ScheduleContractItem implements Schedulable
{
	global void execute(SchedulableContext sc) {
         C360_ContractItemBatch c = new C360_ContractItemBatch();
		 Id batchId = Database.executeBatch(c, 200);
    }
}