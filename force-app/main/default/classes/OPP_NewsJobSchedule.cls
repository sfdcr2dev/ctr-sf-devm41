global class OPP_NewsJobSchedule implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        OPP_NewsJobHelper.setDraftToPublished();
        OPP_NewsJobHelper.setPublishedToExpired();
    }
    
}