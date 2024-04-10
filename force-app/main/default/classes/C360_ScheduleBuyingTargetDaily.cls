global class C360_ScheduleBuyingTargetDaily implements Schedulable
{
	global void execute(SchedulableContext sc) {
        C360_BuyingTargetDailyBatch.getSalesOrgCustomer();
    }
}