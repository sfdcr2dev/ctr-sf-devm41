/* 
    ESS_RetirementAutoChangeStatusBatchable RetirmentAutoChangeStatus = new ESS_RetirementAutoChangeStatusBatchable();
    string cronExp1 = '0 0 12 1 * ? *';
    system.schedule('ESS - Retirment waiting approve auto change status', cronExp1, RetirmentAutoChangeStatus);
	
	Run on 16 August at 00:00 of every year
	For Test '0 59 23 15 09 ? *'
*/
global class ESS_RetirementAutoChangeStatusController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public date todayDate = system.Date.today();
    public List<string> statuses = new List<string>{'WaitingForApprovalSectionHead', 'WaitingForApprovalDepartmentHead'};
    public string query = 'select id, status__c, Default_Retirement_Date__c from ESS_Retirement__c where status__c IN: statuses';
         
	global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ESS_Retirement__c> Retirements) {
        
        if(Retirements.size() > 0){
            for(ESS_Retirement__c Retirement : Retirements) {
                Retirement.Status__c = ESS_Enum.RetirementStatus.DefaultFromSystem.name();
                Retirement.Retirement_Date__c = Retirement.Default_Retirement_Date__c;
            }
		
			database.update(Retirements,false);            
        }
        
    }
    
    global void finish(Database.BatchableContext BC){    
    }
    
}