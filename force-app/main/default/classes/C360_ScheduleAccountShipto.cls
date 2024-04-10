global class C360_ScheduleAccountShipto implements Schedulable {
    global void execute(SchedulableContext sc) {
        C360_AccountShiptoBatch b = new C360_AccountShiptoBatch(); 
        database.executebatch(b,200);
    }
}