global class C360_ScheduleProductSalesarea implements Schedulable
{
	global void execute(SchedulableContext sc) {
        C360_productSalesareaBatch b = new C360_productSalesareaBatch(); 
        database.executebatch(b,200);
    }
}