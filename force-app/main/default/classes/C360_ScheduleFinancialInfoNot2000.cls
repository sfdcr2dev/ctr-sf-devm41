global class  C360_ScheduleFinancialInfoNot2000 implements Schedulable 
{
	global void execute(SchedulableContext ctx) 
    {
      // Database.executeBatch(new C360_BuyingActualDailyBatch(), 500);
      C360_IRPAIntegration_FinancialInfo.GetAllNot2000();
    }
}