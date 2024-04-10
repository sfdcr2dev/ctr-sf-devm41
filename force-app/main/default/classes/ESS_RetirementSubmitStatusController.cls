/* 
    ESS_RetirementSubmitStatusBatchable RetirmentSubmitStatus = new ESS_RetirementSubmitStatusBatchable();
    string cronExp1 = '0 0 12 1 * ? *';
    system.schedule('ESS - Retirment employee submit auto change status', cronExp1, RetirmentSubmitStatus);
	
	Run on 1 August at 00:00 of every year
	For Test '0 59 23 31 07 ? *'
*/
global class ESS_RetirementSubmitStatusController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public date todayDate = system.Date.today();
    public List<string> statuses = new List<string>{'WaitingEmployeeSubmit'};
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