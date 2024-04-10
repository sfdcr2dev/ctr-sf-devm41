/* 
    ESS_ApplicationTaxReminderBatchable ApplicationAdminReminder = new ESS_ApplicationTaxReminderBatchable();
    string cronExp1 = '0 0 12 1 * ? *';
    system.schedule('ESS - Application Tax Reminder', cronExp1, ApplicationAdminReminder);
	
	Run on 5 January , 1 October of every year
	For Test '0 0 8 * * ? *'
*/
global class ESS_ApplicationTaxReminderController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    private static string orgId = UserInfo.getOrganizationId();
    public string data = 'IN';
    public string query = 'select id, document_no__c, status__c, employee_id__c, employee_name__c, name_emp_en_fn__c, name_emp_en_ln__c from ESS_Master_Employee__c where data__c = :data limit 5';
         
	global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ESS_Master_Employee__c> Masters) {
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_Tax'];
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND User__c != null];
            
        Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                if(PISUser.MAINPOSITION__c) {
                    mapPISUsers.put(PISUser.EMPLOYEEID__c, PISUser);
                }
            }    
        } 
        
        if(Masters.size() > 0) {
            
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            
            for(ESS_Master_Employee__c Master : Masters) {
                Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ApplicationTax(emailTemplate, mapPISUsers, Master);
                if(sendEmail != null) {
                    sendEmails.add(sendEmail);
                }
            }
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){    
    }
    
}