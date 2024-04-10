global class C360_ScheduteRPTBuyingDailyToMTD implements Schedulable {
	global void execute(SchedulableContext sc) {
        C360_ReportBuyingDailyTransFormToMTD.sumBuyingDaily();
    }
}