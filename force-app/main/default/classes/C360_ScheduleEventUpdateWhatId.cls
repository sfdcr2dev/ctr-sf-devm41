global class C360_ScheduleEventUpdateWhatId implements Schedulable{
	global void execute(SchedulableContext sc) {
        C360_EventUpdateWhatIdBatch b = new C360_EventUpdateWhatIdBatch(); 
        database.executebatch(b,200);
    }
}