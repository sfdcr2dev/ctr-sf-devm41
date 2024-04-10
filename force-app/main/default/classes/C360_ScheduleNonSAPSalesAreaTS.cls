global class C360_ScheduleNonSAPSalesAreaTS implements Schedulable{
    global void execute(SchedulableContext sc) {
        C360_NonSAPSalesAreaTSBatch a = new C360_NonSAPSalesAreaTSBatch(); 
        database.executebatch(a,200);
    }
}