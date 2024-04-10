global class  C360_ScheduleFinancialInfo2000 implements Schedulable 
{
	global void execute(SchedulableContext ctx) 
    {
      // Database.executeBatch(new C360_BuyingActualDailyBatch(), 500);
      C360_IRPAIntegration_FinancialInfo.Get2000();
    }
}