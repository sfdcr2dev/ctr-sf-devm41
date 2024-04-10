global class OPP_SoftwareAssetSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new OPP_SoftwareAssetBatch(), 200);
    }
}