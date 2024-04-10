global class C360_ScheduleProduct implements Schedulable
{
	global void execute(SchedulableContext sc) {
        C360_ProductBatch b = new C360_ProductBatch(); 
        database.executebatch(b,200);
    }
}