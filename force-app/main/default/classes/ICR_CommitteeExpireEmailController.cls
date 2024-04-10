/* 
    ICR_CommitteeExpireEmailBatchable CommiteeExpireReminder = new ICR_CommitteeExpireEmailBatchable();
    string cronExp1 = '0 0 12 1 * ? *';  0 45 21 19 1 ? *
    system.schedule('Commitee Expire Reminder', cronExp1, CommiteeExpireReminder);
	
	Run on every day
	For Test '0 0 8 * * ? *'
*/
global class ICR_CommitteeExpireEmailController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public boolean isActive = true;
    
    public String query = 'select id, name, committee_title__c, end_date__c, ownerId, active__c, BE_Line_Manager_ID__c, BE_GSCS_ID__c, BE_GSCS_Staff_ID__c from ICR_Approval__c where active__c =: isActive' +
                 		 ' AND end_date__c != null ';
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ICR_Approval__c> ICRApprovals) {
        
        ICR_Config__c ICRConfig = [select id, Expire_Committee_Reminder__c from ICR_Config__c];
        
        integer reminderDate = Integer.ValueOf(ICRConfig.Expire_Committee_Reminder__c);
        
        Date todayDate = system.Date.today().addDays(reminderDate);
        
        //Send Email
        if(ICRApprovals.size() > 0) {
            for(ICR_Approval__c ICR : ICRApprovals) {
                
                if(ICR.End_Date__c != null && ICR.End_Date__c == todayDate) {
                    ICR_CustomEmailAndNotiController ICREmail = new ICR_CustomEmailAndNotiController();
                	ICREmail.SendEmailExpireCommitteeReminder(ICR);
                }
            }
        }

    }
    
    global void finish(Database.BatchableContext BC){    
    }
}