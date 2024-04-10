/* Author Softever */
/* Class for CPEM to send email to user */
public with sharing class CPEM_SendEmailController {

    //Send email to SME after user Submit for Approve
    public static void SendEmailToSME(Id WorkOrderId, Id SMEId, Id RequesterId, Id projectManagerId, string ProjectName, decimal WorkProcessNo, string WorkProcessName) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + WorkOrderId;
        
        //SME
        User SME = [select id, email, firstname, lastname from User where Id =: SMEId];
        string SMEName = SME.FirstName + ' ' + SME.LastName;
        //Requester
        User Requester = [select id, email, firstname, lastname from User where Id =: RequesterId];
        string RequesterName = Requester.FirstName + ' ' + Requester.LastName;
        //PM
        User PM = [select id, email, firstname, lastname from User where Id =: ProjectManagerId];
        string ProjectManager = PM.FirstName + ' ' + PM.LastName;
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSenderDisplayName('Thaioil'); 
        message.setSaveAsActivity(false); 
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CPEM_Action_Require'];
        
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!ProjectName}', ProjectName);
        subject = subject.replace('{!WorkProcessNo}', String.ValueOf(WorkProcessNo));
        subject = subject.replace('{!WorkProcessName}', WorkProcessName);
        
        String htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!SMEName}', SMEName);
        htmlBody = htmlBody.replace('{!RequesterName}', ProjectManager);
        htmlBody = htmlBody.replace('{!ProjectName}', ProjectName);
        htmlBody = htmlBody.replace('{!WorkProcessNo}', String.ValueOf(WorkProcessNo));
        htmlBody = htmlBody.replace('{!WorkProcessName}', WorkProcessName);
        htmlBody = htmlBody.replace('{!Link}', URL);
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!SMEName}', SMEName);
        plainBody = plainBody.replace('{!RequesterName}', ProjectManager);
        plainBody = plainBody.replace('{!ProjectName}', ProjectName);
        plainBody = plainBody.replace('{!WorkProcessNo}', String.ValueOf(WorkProcessNo));
        plainBody = plainBody.replace('{!WorkProcessName}', WorkProcessName);
        plainBody = plainBody.replace('{!Link}', URL);
        plainBody = plainBody.replace(']]>', '');
        
        message.setTargetObjectId(SMEId); 
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(SMEId);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        
        message.toAddresses = new String[] { SME.email };
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
        }
        
    }
    
    //Send email to Requester after SME Approved
    public static void SendApprovedEmailToRequester(Id WorkOrderId, Id SMEId, Id RequesterId, Id ProjectManagerId, string ProjectName, decimal WorkProcessNo, string WorkProcessName) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + WorkOrderId;
        
        //SME
        User SME = [select id, email, firstname, lastname from User where Id =: SMEId];
        string SMEName = SME.FirstName + ' ' + SME.LastName;
        //Requester
        User Requester = [select id, email, firstname, lastname from User where Id =: RequesterId];
        string RequesterName = Requester.FirstName + ' ' + Requester.LastName;
        //PM
        User PM = [select id, email, firstname, lastname from User where Id =: ProjectManagerId];
        string ProjectManager = PM.FirstName + ' ' + PM.LastName;
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSenderDisplayName('Thaioil'); 
        message.setSaveAsActivity(false); 
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CPEM_Noti_Approved'];
        
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!ProjectName}', ProjectName);
        subject = subject.replace('{!WorkProcessNo}', String.ValueOf(WorkProcessNo));
        subject = subject.replace('{!WorkProcessName}', WorkProcessName);
        
        String htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!SMEName}', SMEName);
        htmlBody = htmlBody.replace('{!RequesterName}', ProjectManager);
        htmlBody = htmlBody.replace('{!ProjectName}', ProjectName);
        htmlBody = htmlBody.replace('{!WorkProcessNo}', String.ValueOf(WorkProcessNo));
        htmlBody = htmlBody.replace('{!WorkProcessName}', WorkProcessName);
        htmlBody = htmlBody.replace('{!Link}', URL);
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!SMEName}', SMEName);
        plainBody = plainBody.replace('{!RequesterName}', ProjectManager);
        plainBody = plainBody.replace('{!ProjectName}', ProjectName);
        plainBody = plainBody.replace('{!WorkProcessNo}', String.ValueOf(WorkProcessNo));
        plainBody = plainBody.replace('{!WorkProcessName}', WorkProcessName);
        plainBody = plainBody.replace('{!Link}', URL);
        plainBody = plainBody.replace(']]>', '');
        
        message.setTargetObjectId(PM.Id); 
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(PM.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        
        message.toAddresses = new String[] { PM.email };
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
        }
        
    }
    
    //Send email to Requester after SME Rejected
    public static void SendRejectedEmailToRequester(Id WorkOrderId, Id SMEId, Id RequesterId, Id ProjectManagerId, string ProjectName, decimal WorkProcessNo, string WorkProcessName) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + WorkOrderId;
        
        //SME
        User SME = [select id, email, firstname, lastname from User where Id =: SMEId];
        string SMEName = SME.FirstName + ' ' + SME.LastName;
        //Requester
        User Requester = [select id, email, firstname, lastname from User where Id =: RequesterId];
        string RequesterName = Requester.FirstName + ' ' + Requester.LastName;
        //PM
        User PM = [select id, email, firstname, lastname from User where Id =: ProjectManagerId];
        string ProjectManager = PM.FirstName + ' ' + PM.LastName;
        
        //Send email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSenderDisplayName('Thaioil'); 
        message.setSaveAsActivity(false); 
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'CPEM_Noti_Rejected'];
        
        string subject = emailTemplate.Subject;
        subject = subject.replace('{!ProjectName}', ProjectName);
        subject = subject.replace('{!WorkProcessNo}', String.ValueOf(WorkProcessNo));
        subject = subject.replace('{!WorkProcessName}', WorkProcessName);
        
        String htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{!SMEName}', SMEName);
        htmlBody = htmlBody.replace('{!RequesterName}', ProjectManager);
        htmlBody = htmlBody.replace('{!ProjectName}', ProjectName);
        htmlBody = htmlBody.replace('{!WorkProcessNo}', String.ValueOf(WorkProcessNo));
        htmlBody = htmlBody.replace('{!WorkProcessName}', WorkProcessName);
        htmlBody = htmlBody.replace('{!Link}', URL);
        htmlBody = htmlBody.replace(']]>', '');
        
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!SMEName}', SMEName);
        plainBody = plainBody.replace('{!RequesterName}', ProjectManager);
        plainBody = plainBody.replace('{!ProjectName}', ProjectName);
        plainBody = plainBody.replace('{!WorkProcessNo}', String.ValueOf(WorkProcessNo));
        plainBody = plainBody.replace('{!WorkProcessName}', WorkProcessName);
        plainBody = plainBody.replace('{!Link}', URL);
        plainBody = plainBody.replace(']]>', '');
        
        message.setTargetObjectId(PM.Id); 
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(PM.Id);
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        message.setPlainTextBody(plainBody);
        
        message.toAddresses = new String[] { PM.email };
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
        }
        
    }
    
}