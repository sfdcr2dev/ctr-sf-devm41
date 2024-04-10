global class C360_ScheduteRPTContractLineItemSummary implements Schedulable {
	
	global void execute(SchedulableContext sc) {
         C360_ReportContractLineItemSummary.sumContractItemMonthYear();
    }    
}