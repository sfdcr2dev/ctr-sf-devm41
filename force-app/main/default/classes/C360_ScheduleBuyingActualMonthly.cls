global class C360_ScheduleBuyingActualMonthly implements Schedulable 
{

   global void execute(SchedulableContext ctx) 
    {
      // Database.executeBatch(new C360_BuyingActualMonthlyBatch(), 500);
       C360_BuyingActualMonthlyBatch.getSalesOrg();
    }
}