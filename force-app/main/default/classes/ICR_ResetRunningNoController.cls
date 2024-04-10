/* 
    ICR_ResetRunningNoEmailBatchable ResetRunningNo = new ICR_ResetRunningNoEmailBatchable();
    string cronExp1 = '0 0 0 1 1 ? *';  0 45 21 19 1 ? *
    system.schedule('Reset ICR Running No', cronExp1, ResetRunningNo);
    string cronExp2 = '0 0 0 2 1 ? *';  0 45 21 19 1 ? *
    system.schedule('Reset ICR Running No', cronExp2, ResetRunningNo);
    string cronExp3 = '0 0 0 3 1 ? *';  0 45 21 19 1 ? *
    system.schedule('Reset ICR Running No', cronExp3, ResetRunningNo);
    string cronExp4 = '0 0 0 4 1 ? *';  0 45 21 19 1 ? *
    system.schedule('Reset ICR Running No', cronExp4, ResetRunningNo);
    string cronExp5 = '0 0 0 5 1 ? *';  0 45 21 19 1 ? *
    system.schedule('Reset ICR Running No', cronExp5, ResetRunningNo);
	
	Run on every day
	For Test '0 0 8 * * ? *'
*/
global class ICR_ResetRunningNoController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public boolean isActive = true;
    
    public String query = 'select id, name, committee_title__c, end_date__c, ownerId, active__c, BE_Line_Manager_ID__c, BE_GSCS_ID__c, BE_GSCS_Staff_ID__c from ICR_Approval__c where active__c =: isActive';
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ICR_Approval__c> ICRApprovals) {
        
        ICR_CustomEmailAndNotiController ICREmail = new ICR_CustomEmailAndNotiController();
        ICREmail.SendEmailResetRunningNoReminder();

    }
    
    global void finish(Database.BatchableContext BC){    
    }
}