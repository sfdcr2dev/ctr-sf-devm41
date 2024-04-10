global class C360_ScheduleNonSAPProductUnit implements Schedulable{
    global void execute(SchedulableContext sc) {
        C360_NonSAPProductUnitBatch a = new C360_NonSAPProductUnitBatch(); 
        database.executebatch(a,200);
    }
}