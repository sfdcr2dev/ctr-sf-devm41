global class C360_ScheduleFinancial implements Schedulable
{
	global void execute(SchedulableContext sc) {
         C360_FinancialBatch.getSalesOrg();
    }
}