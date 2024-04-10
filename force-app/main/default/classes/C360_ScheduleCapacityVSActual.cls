global class  C360_ScheduleCapacityVSActual implements Schedulable
{
    global void execute(SchedulableContext sc) {
        C360_CapacityMonthlyBatch b = new C360_CapacityMonthlyBatch();
        Id batchId = Database.executeBatch(b, 50);
    }
}