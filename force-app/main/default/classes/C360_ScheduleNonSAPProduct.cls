global class C360_ScheduleNonSAPProduct implements Schedulable{
    global void execute(SchedulableContext sc) {
        C360_NonSAPProductBatch a = new C360_NonSAPProductBatch(); 
        database.executebatch(a,200);
    }
}