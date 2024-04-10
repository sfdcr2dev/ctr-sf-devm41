global class C360_ScheduleNonSAPFinancial implements Schedulable{
    global void execute(SchedulableContext sc) {
        C360_NonSAPFinancialBatch a = new C360_NonSAPFinancialBatch(); 
        database.executebatch(a,200);
    }
}