/* 
 * Author Softever
 
    ICR_ExpireICRBatchable AutoExpireICR = new ICR_ExpireICRBatchable();
    string cronExp1 = '0 0 12 1 * ? *';  0 45 21 19 1 ? *
    system.schedule('Auto Expire ICR', cronExp1, AutoExpireICR);
	
	Run on every day
	For Test '0 0 8 * * ? *'
*/
global class ICR_ExpireICRController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public boolean isActive = true;
    public string status = 'Appointed';
    public date todayDate = date.today().addDays(1);
    
    public String query = 'select id, name, status__c, end_date__c, active__c from ICR_Approval__c where active__c =: isActive' +
                 		 ' AND end_date__c != null AND end_date__c <=: todayDate';
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
        
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ICR_Approval__c> ICRApprovals) {
        
        //Auto expire ICR when reach End Date
        if(ICRApprovals.size() > 0) {
            for(ICR_Approval__c ICR : ICRApprovals) {
                if(ICR.Status__c == status) {
                    ICR_ChangeStatusController.expiredCommittee(ICR.Id);
                }
            }
        }

    }
    
    global void finish(Database.BatchableContext BC){    
    }
}