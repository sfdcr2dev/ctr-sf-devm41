global class OPP_UpdateDataAssetSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new OPP_UpdateDataAssetBatch(), 100);
    }
}