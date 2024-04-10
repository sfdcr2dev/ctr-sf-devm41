global class C360_ScheduleBuyingTargetMonthly implements Schedulable
{
	global void execute(SchedulableContext sc) {
         C360_BuyingTargetMonthlyBatch.getSalesOrgCustomer();
    }
}