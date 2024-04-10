global class C360_SchedulePartner implements Schedulable
{
	global void execute(SchedulableContext sc) {
        C360_PartnerBatch b = new C360_PartnerBatch(); 
        database.executebatch(b,200);
    }
}