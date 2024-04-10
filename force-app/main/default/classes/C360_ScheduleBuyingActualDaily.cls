global class  C360_ScheduleBuyingActualDaily implements Schedulable 
{
	global void execute(SchedulableContext ctx) 
    {
      // Database.executeBatch(new C360_BuyingActualDailyBatch(), 500);
      C360_BuyingActualDailyBatch.getSalesOrgCustomer();
    }
}