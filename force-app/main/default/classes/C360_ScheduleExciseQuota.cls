global class C360_ScheduleExciseQuota implements Schedulable
{
	global void execute(SchedulableContext sc) {
         C360_ExciseQuotaBatch  c = new C360_ExciseQuotaBatch();
		 Id batchId = Database.executeBatch(c, 200);
    }
}