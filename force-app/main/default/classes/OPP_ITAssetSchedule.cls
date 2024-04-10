global class OPP_ITAssetSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new OPP_ITAssetBatch(), 200);
    }
}