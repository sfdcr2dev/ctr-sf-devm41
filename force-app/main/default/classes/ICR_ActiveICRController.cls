/* 
 * Author Softever
 
    ICR_ActiveICRBatchable AutoActiveICR = new ICR_ActiveICRBatchable();
    string cronExp1 = '0 0 12 1 * ? *';  0 45 21 19 1 ? *
    system.schedule('Auto Acitve ICR', cronExp1, AutoActiveICR);
	
	Run on every day
	For Test '0 0 8 * * ? *'
*/
global class ICR_ActiveICRController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public boolean isActive = false;
    public string status = 'Appointed';
    public date todayDate = date.today();
    public String query = 'select id, name, status__c, start_date__c, end_date__c, active__c from ICR_Approval__c where status__c =: status' ;
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ICR_Approval__c> ICRApprovals) {
        
        //Auto Active ICR when reach Start Date
        if(ICRApprovals.size() > 0) {
            for(ICR_Approval__c ICR : ICRApprovals) {
                if(ICR.Active__c == isActive && ICR.Start_Date__c == todayDate) {
                    ICR_ChangeStatusController.activeCommittee(ICR.Id);
                }
            }
        }

    }
    
    global void finish(Database.BatchableContext BC){    
    }
}