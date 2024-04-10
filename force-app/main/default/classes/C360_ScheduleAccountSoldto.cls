global class C360_ScheduleAccountSoldto implements Schedulable {
    global void execute(SchedulableContext sc) {
        C360_AccountSoldtoBatch b = new C360_AccountSoldtoBatch(); 
        database.executebatch(b,200);
    }
}