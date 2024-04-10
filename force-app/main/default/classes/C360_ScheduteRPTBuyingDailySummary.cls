global class C360_ScheduteRPTBuyingDailySummary implements Schedulable {
	global void execute(SchedulableContext sc) {
        C360_ReportBuyingDailySummary.sumBuyingDailyMonthYear();
    }
}