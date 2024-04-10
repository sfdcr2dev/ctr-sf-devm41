global class C360_ScheduleProductUnit implements Schedulable
{
	global void execute(SchedulableContext sc) {
        C360_productUnitBatch b = new C360_productUnitBatch(); 
        database.executebatch(b,200);
    }
}