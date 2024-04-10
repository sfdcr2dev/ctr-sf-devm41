public with sharing class ESS_ApplicationHandler {

    //Send Email when updated status from SAP
    public void SendEmailWhenUpdatedApplicationStatusFromSAP(List<ESS_Application__c> Applications) {
        
        if(Applications.size() > 0) {
            
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_02'];
        
            for(ESS_Application__c App : Applications) {
                if(App.Status__c == ESS_Enum.ApplicationStatus.Completed.name()) {
                    //E1-02
                    Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ApplicationSendToOwnerWhenCompletedInSAP(emailTemplate, mapPISUsers, App);
                	sendEmails.add(sendEmail);
                }
            }
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
        }
    }    
}