/* Author Softever */
public with sharing class ICR_CustomEmailAndNotiController {

    public void SendNoti(List<ICR_Approval__c> oldICRs, List<ICR_Approval__c> newICRs) {
        
        Id ICRId = newICRs[0].Id;
        string oldStatus = oldICRs[0].Status__c;
        string newStatus = newICRs[0].Status__c;
        
        ICR_Approval__c ICR = [select id, name, type__c, ownerId, be_line_manager_id__c, be_gscs_staff_id__c, be_gscs_id__c,
                               	be_evp_id__c, be_pmsv_id__c, be_gsvp_id__c, AMM_Conclusion__c, owner.firstname, owner.lastname,
                                circular_no__c, request_date__c, start_date__c, end_date__c, cancel_reason__c, committee_title__c,
                                auto_approve__c from ICR_Approval__c where id =: ICRId];
        
        string approvalType = ICR.Type__c;
        
        //When Requester Submit approval to Line Manager
        if(oldStatus == 'Not Submit' && newStatus == 'Waiting Line Manager Approval' && !ICR.Auto_Approve__c) {
            SendNotiWaitingForLineManagerApproval(ICR);
            SendEmailE01WaitingForLineManagerApproval(ICR);
            SendEmailE02WaitingForLineManagerApproval(ICR);
        }
        //When Requester Auto Approved
        if(oldStatus == 'Not Submit' && newStatus == 'Waiting Line Manager Approval' && ICR.Auto_Approve__c) {
            SendNotiWaitingSubmitApprovalType(ICR);
            SendEmailE04WaitingSubmitApprovalType(ICR);
            SendEmailE05WaitingSubmitApprovalType(ICR);
        }
        //When Line Manager Cancelled Request
        else if(oldStatus == 'Waiting Line Manager Approval' && newStatus == 'Cancelled Request') {
            SendNotiCancelledLineManager(ICR);
            SendEmailCancelledLineManager(ICR);
        }
        //When Line Manager Cancelled Request
        else if(oldStatus == 'Waiting Requester Revise' && newStatus == 'Cancelled Request') {
            SendNotiCancelledLineManager(ICR);
            SendEmailCancelledLineManager(ICR);
        }
        //When Line Manager Rejected approval and Requester need to revise
        else if(oldStatus == 'Waiting Line Manager Approval' && newStatus == 'Waiting Requester Revise') {
            SendNotiWaitingRequesterRevise(ICR);
            SendEmailWaitingRequesterRevise(ICR);
        }
        //When Line Manager appprove
        else if(oldStatus == 'Waiting Line Manager Approval' && newStatus == 'Waiting Submit Approval Type') {
            SendNotiWaitingSubmitApprovalType(ICR);
            SendEmailE04WaitingSubmitApprovalType(ICR);
            SendEmailE05WaitingSubmitApprovalType(ICR);
        }
        //When Requester Submit for Approval from Line Manager Rejected
        else if(oldStatus == 'Waiting Requester Revise' && newStatus == 'Waiting Line Manager Approval') {
            SendNotiWaitingSubmitApprovalType(ICR);
            SendEmailWaitingRequesterRevise(ICR);
        }
        //When GSCS Staff select Approval Type and submit for approve
        else if(oldStatus == 'Waiting Submit Approval Type' && newStatus == 'Waiting GSCS Approval') {
            SendNotiWaitingGSCSApproval(ICR);
            SendEmailWaitingGSCSApproval(ICR);
        }
        //When GSCS Cancel after rejected
        else if(oldStatus == 'Waiting Submit Approval Type' && newStatus == 'Cancelled Request') {
            SendNotiCancelledGSCS(ICR);
            SendEmailCancelledGSCS(ICR);
        }
        //When GSCS Cancel
        else if(oldStatus == 'Waiting GSCS Approval' && newStatus == 'Cancelled Request') {
            SendNotiCancelledGSCS(ICR);
            SendEmailCancelledGSCS(ICR);
        }
        //When GSCS Approved (Disappointed) when Type is Other
        else if(oldStatus == 'Waiting GSCS Approval' && newStatus == 'Disappointed' && approvalType == 'Other') {
            SendNotiDisappointedGSCS(ICR);
            SendEmailDisappointedGSCS(ICR);
        }
        //When GSCS Rejected Send back to GSCS Staff
        else if(oldStatus == 'Waiting GSCS Approval' && newStatus == 'Waiting Submit Approval Type') {
            SendNotiWaitingSubmitApprovalTypeAfterGSCSRejected(ICR);
            SendEmailE03WaitingSubmitApprovalType(ICR);
        }
        //When GSCS Approved when Type is CEO or AMM
        else if(oldStatus == 'Waiting GSCS Approval' && newStatus == 'Waiting Requester Update Result' && approvalType != 'Other') {
        	SendNotiWaitingRequesterUpdateResult(ICR);
            SendEmailE06WaitingRequesterUpdateResult(ICR);
            SendEmailE07WaitingRequesterUpdateResult(ICR);
        }
        //When Requester select AMM Conclusion as Disappoint
        else if(oldStatus == 'Waiting Requester Update Result' && newStatus == 'Disappointed') { //&& ICR.AMM_Conclusion__c == 'Disappoint' && approvalType == 'AMM') {
        	SendNotiDisappointedAMM(ICR);
            SendEmailDisappointedAMM(ICR);
        }
        //When Requester Submit for approve to EVP
        else if(oldStatus == 'Waiting Requester Update Result' && newStatus == 'Waiting EVP Approval' && approvalType != 'Other') {
        	SendNotiWaitingEVPApproval(ICR);
            SendEmailE01WaitingEVPApproval(ICR);
            SendEmailE02WaitingEVPApproval(ICR);
        }
        //When EVP Reject approve and send back to Requester
        /* else if(oldStatus == 'Waiting EVP Approval' && newStatus == 'Waiting Requester Update Result' 
                && approvalType != 'Other' && string.isBlank(ICR.cancel_reason__c)) {
        	SendNotiWaitingRequesterUpdateResult(ICR);
            SendEmailRejectedWaitingRequesterUpdateResult(ICR);
        } */
        //When EVP approved and put Circular No
        else if(oldStatus == 'Waiting EVP Approval' && newStatus == 'Waiting Circular No.') {
        	SendNotiWaitingCircularNo(ICR);
            SendEmailE08WaitingCircularNo(ICR);
            SendEmailE09WaitingCircularNo(ICR);
        }
        //When EVP cancalled
        /* else if(oldStatus == 'Waiting Requester Update Result' && newStatus == 'Cancelled Request' && !string.isBlank(ICR.cancel_reason__c)) {
        	SendNotiCancelledEVP(ICR);
            SendEmailCancelledEVP(ICR);
        } */
        //When PMSV enter Circular No
        else if(oldStatus == 'Waiting Circular No.' && newStatus == 'Waiting Signed Circular File') {
        	SendNotiWaitingSignedCircularFile(ICR);
            SendEmailE10EnteredCircularNo(ICR);
            SendEmailE11EnteredCircularNo(ICR);
        }
        //When GSCS Staff uploaded Circular File
        else if(oldStatus == 'Waiting Signed Circular File' && newStatus == 'Appointed') {
        	SendNotiAppointed(ICR);
            SendEmailAppointed(ICR);
        }
    }
    
    public void SendNotiAfterRejected(List<ICR_Approval__c> oldICRs, List<ICR_Approval__c> newICRs) {
        
        Id ICRId = newICRs[0].Id;
        string oldStatus = oldICRs[0].Status__c;
        string newStatus = newICRs[0].Status__c;
        
        ICR_Approval__c ICR = [select id, name, type__c, ownerId, be_line_manager_id__c, be_gscs_staff_id__c, be_gscs_id__c,
                               	be_evp_id__c, be_pmsv_id__c, be_gsvp_id__c, AMM_Conclusion__c, owner.firstname, owner.lastname,
                                circular_no__c, request_date__c, start_date__c, end_date__c, cancel_reason__c, committee_title__c 
                                from ICR_Approval__c where id =: ICRId];
        
        string approvalType = ICR.Type__c;
        
        //When EVP Reject approve and send back to Requester
        if(oldStatus == 'Waiting EVP Approval' && newStatus == 'Waiting Requester Update Result' 
                && approvalType != 'Other' && string.isBlank(ICR.cancel_reason__c)) {
        	SendNotiRejectedWaitingRequesterUpdateResult(ICR);
            SendEmailRejectedWaitingRequesterUpdateResult(ICR);
        }
        //When EVP cancalled
        else if(oldStatus == 'Waiting Requester Update Result' && newStatus == 'Cancelled Request' && !string.isBlank(ICR.cancel_reason__c)) {
        	SendNotiCancelledEVP(ICR);
            SendEmailCancelledEVP(ICR);
        }
    }
    
    public void SendNotiWaitingRequesterRevise(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Waiting_Requester_Revise'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been rejected. Need to be revise.';
        string body = 'Line Manager has rejected ICR ' + ICR.name + '. Please revise it again.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
        //Requester
        receivers.add(ICR.OwnerId);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-02 (Requester, GSCS Staff)
    public void SendEmailWaitingRequesterRevise(ICR_Approval__c ICR) {
        
        /* ProcessInstance PI = [select id, processdefinitionid, targetobjectid, status, createddate 
                              from processinstance where targetobjectid =: ICR.Id 
                              AND Status = 'Pending' order by createddate desc];
        
        ProcessInstanceWorkitem PIWI = [select id, processinstanceid from ProcessInstanceWorkitem 
                                        where processinstanceid =: PI.Id];
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/ProcessInstanceWorkitem' + PIWI.Id + '/view'; */
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        
        if(ICR.Request_Date__c == null) {
            ICR.Request_Date__c = date.today();
        }
        
        string requestDate = ICR.Request_Date__c.format();
        
        User LineManager = [select id, email, firstname, lastname from User where Id =: ICR.BE_Line_Manager_ID__c];
        
        //Receivers Requester, GSCS Staff
        string[] receiverIds = new string[] { ICR.BE_Line_Manager_ID__c, ICR.BE_GSCS_Staff_ID__c, ICR.OwnerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Submit_For_Approve_E_02'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.OwnerFullName}', LineManager.FirstName + ' ' + LineManager.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.OwnerFullName}', LineManager.FirstName + ' ' + LineManager.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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

    public void SendNotiWaitingForLineManagerApproval(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Waiting_Line_Manager_Approval'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' need your approval.';
        string body = 'ICR ' + ICR.name + 'need your approval. You can check it out by click on this notification.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //LineManager
        receivers.add(ICR.BE_Line_Manager_ID__c);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-01 Requester Submit for Approval (Line Manager)
    public void SendEmailE01WaitingForLineManagerApproval(ICR_Approval__c ICR) {
        
        /* ProcessInstance PI = [select id, processdefinitionid, targetobjectid, status, createddate 
                              from processinstance where targetobjectid =: ICR.Id 
                              AND Status = 'Pending' order by createddate desc];
        
        ProcessInstanceWorkitem PIWI = [select id, processinstanceid from ProcessInstanceWorkitem 
                                        where processinstanceid =: PI.Id];
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/ProcessInstanceWorkitem' + PIWI.Id + '/view'; */
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        if(ICR.Request_Date__c == null) {
            ICR.Request_Date__c = date.today();
        }
        
        string requestDate = ICR.Request_Date__c.format();
        
        User Requester = [select id, email, firstname, lastname from User where Id =: ICR.OwnerId];
        
        //Receivers Line Manager
        string[] receiverIds = new string[] { ICR.BE_Line_Manager_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Submit_For_Approve_E_01'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.OwnerFullName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.OwnerFullName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    //E-02 Requester Submit for Approval (GSCS Staff)
    public void SendEmailE02WaitingForLineManagerApproval(ICR_Approval__c ICR) {
        
        /* ProcessInstance PI = [select id, processdefinitionid, targetobjectid, status, createddate 
                              from processinstance where targetobjectid =: ICR.Id 
                              AND Status = 'Pending' order by createddate desc];
        
        ProcessInstanceWorkitem PIWI = [select id, processinstanceid from ProcessInstanceWorkitem 
                                        where processinstanceid =: PI.Id];
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/ProcessInstanceWorkitem' + PIWI.Id + '/view'; */
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        
        if(ICR.Request_Date__c == null) {
            ICR.Request_Date__c = date.today();
        }
        
        string requestDate = ICR.Request_Date__c.format();
        
        User Requester = [select id, email, firstname, lastname from User where Id =: ICR.OwnerId];
        
        //Receivers GSCS Staff
        string[] receiverIds = new string[] { ICR.BE_GSCS_Staff_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Submit_For_Approve_E_02'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.OwnerFullName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.OwnerFullName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiCancelledLineManager(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Cancelled_Request'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been cancelled.';
        string body = 'ICR ' + ICR.name + 'has been cancelled by Line Manager.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-03 Line Manager Cancelled (Requester, GSCS Staff)
    public void SendEmailCancelledLineManager(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User LineManager = [select id, email, firstname, lastname from User where Id =: ICR.BE_Line_Manager_ID__c];
        
        //Receivers Requester, GSCS Staff
        string[] receiverIds = new string[] { ICR.OwnerId , ICR.BE_GSCS_Staff_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Noti_Canceled_E_03'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', LineManager.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', LineManager.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', LineManager.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', LineManager.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiWaitingSubmitApprovalType(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Waiting_Submit_Approval_Type'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been approved by Line Manager.';
        string body = 'ICR ' + ICR.name + ' has been approved by Line Manager. You need to select approval type before proceeding to next step.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
        //GSCS
        receivers.add(ICR.BE_GSCS_ID__c);
        //GSVP
        receivers.add(ICR.BE_GSVP_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    public void SendNotiWaitingSubmitApprovalTypeAfterGSCSRejected(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Waiting_Submit_Approval_Type'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been rejected by GSCS.';
        string body = 'ICR ' + ICR.name + ' has been rejected by GSCS. You need to revise by select approval type before proceeding.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
        //GSCS
        receivers.add(ICR.BE_GSCS_ID__c);
        //GSVP
        receivers.add(ICR.BE_GSVP_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-03 GSCS Rejected (GSCS Staff)
    public void SendEmailE03WaitingSubmitApprovalType(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User GSCS = [select id, email, firstname, lastname from User where Id =: ICR.BE_GSCS_ID__c];
        
        //Receivers GSCS Staff
        string[] receiverIds = new string[] { ICR.BE_GSCS_Staff_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Noti_Rejected_E_03'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', GSCS.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', GSCS.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', GSCS.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', GSCS.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    //E-04 Line Manager Approved (GSCS Staff)
    public void SendEmailE04WaitingSubmitApprovalType(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User LineManager = [select id, email, firstname, lastname from User where Id =: ICR.BE_Line_Manager_ID__c];
        
        //Receivers GSCS Staff
        string[] receiverIds = new string[] { ICR.BE_GSCS_Staff_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Submit_Type_E_04'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', LineManager.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', LineManager.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', LineManager.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', LineManager.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    //E-05 Line Manager Approved (GSVP, GSCS, Requester)
    public void SendEmailE05WaitingSubmitApprovalType(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User LineManager = [select id, email, firstname, lastname from User where Id =: ICR.BE_Line_Manager_ID__c];
        
        //Receivers GSCS Staff
        string[] receiverIds = new string[] { ICR.OwnerId, ICR.BE_GSVP_ID__c, ICR.BE_GSCS_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Submit_Type_E_05'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', LineManager.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', LineManager.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', LineManager.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', LineManager.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiWaitingGSCSApproval(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Waiting_GSCS_Approval'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has selected approval type. It need your approval.';
        string body = 'ICR ' + ICR.name + 'has selected approval type as ' + ICR.Type__c;
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //GSCS
        receivers.add(ICR.BE_GSCS_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-01 GSCS Staff Submit for Approval (GSCS)
    public void SendEmailWaitingGSCSApproval(ICR_Approval__c ICR) {
        
        /* ProcessInstance PI = [select id, processdefinitionid, targetobjectid, status, createddate 
                              from processinstance where targetobjectid =: ICR.Id 
                              AND Status = 'Pending' order by createddate desc];
        
        ProcessInstanceWorkitem PIWI = [select id, processinstanceid from ProcessInstanceWorkitem 
                                        where processinstanceid =: PI.Id];
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/ProcessInstanceWorkitem' + PIWI.Id + '/view'; */
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User GSCSStaff = [select id, email, firstname, lastname from User where Id =: ICR.BE_GSCS_Staff_ID__c];
        
        //Receivers GSCS
        string[] receiverIds = new string[] { ICR.BE_GSCS_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Submit_For_Approve_E_01'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.OwnerFullName}', GSCSStaff.FirstName + ' ' + GSCSStaff.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.OwnerFullName}', GSCSStaff.FirstName + ' ' + GSCSStaff.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    //E-03 GSCS Rejected (GSCS Staff)
    public void SendEmailRejectedWaitingGSCSApprovalType(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User GSCS = [select id, email, firstname, lastname from User where Id =: ICR.BE_GSCS_ID__c];
        
        //Receivers GSCS Staff
        string[] receiverIds = new string[] { ICR.BE_GSCS_Staff_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Noti_Rejected_E_03'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', GSCS.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', GSCS.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', GSCS.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', GSCS.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiCancelledGSCS(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Cancelled_Request'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been cancelled.';
        string body = 'ICR ' + ICR.name + 'has been cancelled by GSCS.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
        //Line Manager
        receivers.add(ICR.BE_Line_Manager_ID__c);
        //GSVP
        receivers.add(ICR.BE_GSVP_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-03 GSCS Cancelled (GSVP, Line Manager, GSCS Staff, Requester)
    public void SendEmailCancelledGSCS(ICR_Approval__c ICR) {
        
        
        /* ProcessInstance PI = [select id, processdefinitionid, targetobjectid, status, createddate 
                              from processinstance where targetobjectid =: ICR.Id 
                              AND Status = 'Pending' order by createddate desc];
        
        ProcessInstanceWorkitem PIWI = [select id, processinstanceid from ProcessInstanceWorkitem 
                                        where processinstanceid =: PI.Id];
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/ProcessInstanceWorkitem' + PIWI.Id + '/view'; */
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User GSCS = [select id, email, firstname, lastname from User where Id =: ICR.BE_GSCS_ID__c];
        
        //Receivers GSVP, Line Manager, GSCS Staff, Requester
        string[] receiverIds = new string[] { ICR.BE_GSVP_ID__c, ICR.BE_Line_Manager_ID__c, ICR.BE_GSCS_Staff_ID__c, ICR.OwnerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Noti_Canceled_E_03'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', GSCS.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', GSCS.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', GSCS.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', GSCS.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiDisappointedGSCS(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Disappointed'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been disappointed.';
        string body = 'ICR ' + ICR.name + 'has been disappointed by GSCS.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
        //Line Manager
        receivers.add(ICR.BE_Line_Manager_ID__c);
        //GSVP
        receivers.add(ICR.BE_GSVP_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-13 GSCS Approved (Disappointed) (GSVP, Line Manager, GSCS Staff, Requester)
    public void SendEmailDisappointedGSCS(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User GSCS = [select id, email, firstname, lastname from User where Id =: ICR.BE_GSCS_ID__c];
        
        //Receivers GSVP, Line Manager, GSCS Staff, Requester
        string[] receiverIds = new string[] { ICR.BE_GSVP_ID__c, ICR.BE_Line_Manager_ID__c, ICR.BE_GSCS_Staff_ID__c, ICR.OwnerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Disappointed_E_13'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiWaitingRequesterUpdateResult(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Waiting_Requester_Update_Result'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been approved by GSCS';
        string body = 'ICR ' + ICR.name + ' has been approved by GSCS. You need to update result on this ICR.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
        //GSVP
        receivers.add(ICR.BE_GSVP_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    public void SendNotiRejectedWaitingRequesterUpdateResult(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Waiting_Requester_Update_Result'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been rejected by EVP';
        string body = 'ICR ' + ICR.name + ' has been rejected by EVP. Please check your ICR before resubmit.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
        //GSVP
        receivers.add(ICR.BE_GSVP_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-03 EVP Rejected send back (Requester, GSCS Staff)
    public void SendEmailRejectedWaitingRequesterUpdateResult(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User EVP = [select id, email, firstname, lastname from User where Id =: ICR.BE_EVP_ID__c];
        
        //Receivers Requester
        string[] receiverIds = new string[] { ICR.OwnerId, ICR.BE_GSCS_Staff_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Noti_Rejected_E_03'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.Name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', EVP.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', EVP.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', EVP.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', EVP.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    //E-06 GSCS Approved for AMM , CEO (Requester)
    public void SendEmailE06WaitingRequesterUpdateResult(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User GSCS = [select id, email, firstname, lastname from User where Id =: ICR.BE_GSCS_ID__c];
        
        //Receivers Requester
        string[] receiverIds = new string[] { ICR.OwnerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Update_Result_E_06'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', GSCS.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', GSCS.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', GSCS.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', GSCS.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    //E-07 GSCS Approved for AMM , CEO (GSVP, GSCS Staff)
    public void SendEmailE07WaitingRequesterUpdateResult(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User GSCS = [select id, email, firstname, lastname from User where Id =: ICR.BE_GSCS_ID__c];
        
        //Receivers Requester
        string[] receiverIds = new string[] { ICR.BE_GSVP_ID__c, ICR.BE_GSCS_Staff_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Update_Result_E_07'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.Name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', GSCS.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', GSCS.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', GSCS.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', GSCS.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiAskToReview(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Ask_To_Review'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' need your review.';
        string body = 'You need to review ICR ' + ICR.name + ' for approval type ' + ICR.Type__c;
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    
    public void SendNotiWaitingEVPApproval(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Waiting_EVP_Approval'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' need your approval.';
        string body = ICR.name + ' for approval type ' + ICR.Type__c + ' need your approval.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //EVP
        receivers.add(ICR.BE_EVP_ID__c);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
        //GSCS
        receivers.add(ICR.BE_GSCS_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-01 Requester Submit for Approval (EVP)
    public void SendEmailE01WaitingEVPApproval(ICR_Approval__c ICR) {
        
        /* ProcessInstance PI = [select id, processdefinitionid, targetobjectid, status, createddate 
                              from processinstance where targetobjectid =: ICR.Id 
                              AND Status = 'Pending' order by createddate desc];
        
        ProcessInstanceWorkitem PIWI = [select id, processinstanceid from ProcessInstanceWorkitem 
                                        where processinstanceid =: PI.Id];
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/ProcessInstanceWorkitem' + PIWI.Id + '/view'; */
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User Requester = [select id, email, firstname, lastname from User where Id =: ICR.OwnerId];
        
        //Receivers EVP
        string[] receiverIds = new string[] { ICR.BE_EVP_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Submit_For_Approve_E_01'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.OwnerFullName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.OwnerFullName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    //E-02 Requester Submit for Approval (GSCS Staff, GSCS)
    public void SendEmailE02WaitingEVPApproval(ICR_Approval__c ICR) {
        
        /* ProcessInstance PI = [select id, processdefinitionid, targetobjectid, status, createddate 
                              from processinstance where targetobjectid =: ICR.Id 
                              AND Status = 'Pending' order by createddate desc];
        
        ProcessInstanceWorkitem PIWI = [select id, processinstanceid from ProcessInstanceWorkitem 
                                        where processinstanceid =: PI.Id];
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/ProcessInstanceWorkitem' + PIWI.Id + '/view'; */
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User Requester = [select id, email, firstname, lastname from User where Id =: ICR.OwnerId];
        
        //Receivers EVP
        string[] receiverIds = new string[] { ICR.BE_GSCS_Staff_ID__c, ICR.BE_GSCS_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Submit_For_Approve_E_02'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.OwnerFullName}', Requester.FirstName + ' ' + Requester.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.OwnerFullName}', Requester.FirstName + ' ' + Requester.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    //E-03 EVP Rejected for AMM , CEO (Requester, GSCS Staff)
    public void SendEmailRejectedWaitingEVPApproval(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User EVP = [select id, email, firstname, lastname from User where Id =: ICR.BE_EVP_ID__c];
        
        //Receivers Requester, GSCS Staff
        string[] receiverIds = new string[] { ICR.OwnerId, ICR.BE_GSCS_Staff_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Noti_Rejected_E_03'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', EVP.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', EVP.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', EVP.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', EVP.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Commtitee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiCancelledEVP(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Cancelled_Request'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been cancelled.';
        string body = 'ICR ' + ICR.name + 'has been cancelled by EVP.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        
        //GSCS Staff
        Group GSCSStaffGroup = [select id, developername from Group where developername =: 'ICR_GSCS_Staff'];
        List<GroupMember> GSCSStaffUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSStaffGroup.Id];
                    
        if(GSCSStaffUsers.size() > 0) {
            for(GroupMember GSCSStaff : GSCSStaffUsers) {
                receivers.add(GSCSStaff.UserOrGroupId);
            }
        }
        
        //GSCS
        Group GSCSGroup = [select id, developername from Group where developername =: 'ICR_GSCS'];
        List<GroupMember> GSCSUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSGroup.Id];
                    
        if(GSCSUsers.size() > 0) {
            for(GroupMember GSCS : GSCSUsers) {
                receivers.add(GSCS.UserOrGroupId);
            }
        }
        
        //VP
        Group VPGroup = [select id, developername from Group where developername =: 'ICR_VP'];
        List<GroupMember> VPUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: VPGroup.Id];
                    
        if(VPUsers.size() > 0) {
            for(GroupMember VP : VPUsers) {
                receivers.add(VP.UserOrGroupId);
            }
        }
                 
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-03 EVP Cancelled (GSCS, GSCS Staff, Requester, VP)
    public void SendEmailCancelledEVP(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User EVP = [select id, email, firstname, lastname from User where Id =: ICR.BE_EVP_ID__c];
        
        //Receivers GSCS, GSCS Staff, Requester, VP
        string[] receiverIds = new string[] { ICR.BE_GSCS_ID__c, ICR.BE_GSCS_Staff_ID__c, ICR.OwnerId };
        
        //VP
        Group VPGroup = [select id, developername from Group where developername =: 'ICR_VP'];
        List<GroupMember> VPUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: VPGroup.Id];
                    
        if(VPUsers.size() > 0) {
            for(GroupMember VP : VPUsers) {
                receiverIds.add(VP.UserOrGroupId);
            }
        }
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Noti_Canceled_E_03'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', EVP.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', EVP.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', EVP.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', EVP.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiWaitingCircularNo(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Waiting_Circular_No'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' need circular no.';
        string body = 'You need to generate circular no for ' + 'ICR ' + ICR.name + ' .';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //PMSV Group
        Group PMSVGroup = [select id, developername from Group where developername =: 'ICR_PMSV'];
        List<GroupMember> PMSVUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PMSVGroup.Id];
                    
        List<Id> PMSVUserIds = new List<Id>();
        if(PMSVUsers.size() > 0) {
            for(GroupMember PMSV : PMSVUsers) {
                receivers.add(PMSV.UserOrGroupId);
            }
        }
        
        //GSCS
        Group GSCSGroup = [select id, developername from Group where developername =: 'ICR_GSCS'];
        List<GroupMember> GSCSUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSGroup.Id];
                    
        List<Id> GSCSUserIds = new List<Id>();
        if(GSCSUsers.size() > 0) {
            for(GroupMember GSCS : GSCSUsers) {
                receivers.add(GSCS.UserOrGroupId);
            }
        }
        
        //GSCS Staff
        Group GSCSStaffGroup = [select id, developername from Group where developername =: 'ICR_GSCS_Staff'];
        List<GroupMember> GSCSStaffUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSStaffGroup.Id];
                    
        List<Id> GSCSStaffUserIds = new List<Id>();
        if(GSCSStaffUsers.size() > 0) {
            for(GroupMember GSCSStaff : GSCSStaffUsers) {
                receivers.add(GSCSStaff.UserOrGroupId);
            }
        }
        
        //Requester
        receivers.add(ICR.OwnerId);
        
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-08 EVP Approved (PMSV)
    public void SendEmailE08WaitingCircularNo(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User EVP = [select id, email, firstname, lastname from User where Id =: ICR.BE_EVP_ID__c];
        
        //Receivers PMSV
        List<string> receiverIds = new List<string>();
        
        //PMSV Group
        Group PMSVGroup = [select id, developername from Group where developername =: 'ICR_PMSV'];
        List<GroupMember> PMSVUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PMSVGroup.Id];
                    
        List<Id> PMSVUserIds = new List<Id>();
        if(PMSVUsers.size() > 0) {
            for(GroupMember PMSV : PMSVUsers) {
                receiverIds.add(PMSV.UserOrGroupId);
            }
        }
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Circular_No_E_08'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', EVP.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', EVP.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', EVP.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', EVP.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    //E-09 EVP Approved (GSCS, GSCS Staff, Requester)
    public void SendEmailE09WaitingCircularNo(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User EVP = [select id, email, firstname, lastname from User where Id =: ICR.BE_EVP_ID__c];
        
        //Receivers GSCS, GSCS Staff, Requester
        string[] receiverIds = new string[] { ICR.BE_GSCS_ID__c, ICR.BE_GSCS_Staff_ID__c, ICR.OwnerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Circular_No_E_09'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', EVP.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', EVP.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', EVP.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', EVP.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiWaitingSignedCircularFile(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Waiting_Signed_Circular_File'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' need to upload Signed Circular File';
        string body = 'You need to upload Signed Circular File for ' + 'ICR ' + ICR.name + ' .';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-10 PMSV Entered Circular No (GSCS Staff)
    public void SendEmailE10EnteredCircularNo(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User PMSV = [select id, email, firstname, lastname from User where Id =: ICR.BE_PMSV_ID__c];
        
        //Receivers GSCS Staff
        string[] receiverIds = new string[] { ICR.BE_GSCS_Staff_ID__c };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Signed_Circular_Doc_E_10'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', PMSV.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', PMSV.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Circular_No__c}', ICR.Circular_No__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', PMSV.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', PMSV.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Circular_No__c}', ICR.Circular_No__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    //E-11 PMSV Entered Circular No (Requester)
    public void SendEmailE11EnteredCircularNo(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User PMSV = [select id, email, firstname, lastname from User where Id =: ICR.BE_PMSV_ID__c];
        
        //Receivers Requester
        string[] receiverIds = new string[] { ICR.OwnerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Signed_Circular_Doc_E_11'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.Name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', PMSV.FirstName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Approver__r.LastName}', PMSV.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Circular_No__c}', ICR.Circular_No__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.FirstName}', PMSV.FirstName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Approver__r.LastName}', PMSV.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Circular_No__c}', ICR.Circular_No__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiAppointed(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Appointed'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been appointed.';
        string body = 'ICR ' + ICR.name + ' has been appointed. Please check it out.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-12 PMSV Uploaded Circular File (GSCS, GSCS Staff, Requester)
    public void SendEmailAppointed(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        string startDate = ICR.Start_Date__c.format();
        
        string endDate = '';
        
        if(ICR.End_Date__c != null) {
            endDate = ICR.End_Date__c.format();
        }
        
        User PMSV = [select id, email, firstname, lastname from User where Id =: ICR.BE_PMSV_ID__c];
        
        //Receivers GSCS, GSCS Staff, Requester
        string[] receiverIds = new string[] { ICR.BE_GSCS_ID__c, ICR.BE_GSCS_Staff_ID__c, ICR.OwnerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Appointed_E_12'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Circular_No__c}', ICR.Circular_No__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Start_Date__c}', startDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.End_Date__c}', endDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Circular_No__c}', ICR.Circular_No__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Start_Date__c}', startDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.End_Date__c}', endDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    public void SendNotiDisappointedAMM(ICR_Approval__c ICR) {
        
        // Get the Id for our custom notification type
		CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType 
                               			 			WHERE DeveloperName = 'ICR_Status_Disappointed'];
        
        // Create a new custom notification
        Messaging.CustomNotification customNoti = new Messaging.CustomNotification();
        
        string title = 'ICR ' + ICR.name + ' has been disappointed.';
        string body = 'ICR ' + ICR.name + 'has been disappointed. Please upload disappointment file.';
        
        // Set the contents for the notification
        customNoti.setTitle(title);
        customNoti.setBody(body);
             
        // Set the notification type and target
        customNoti.setNotificationTypeId(notificationType.Id);
        customNoti.setTargetId(ICR.Id);
                    
        Set<String> receivers = new Set<String>();
        
        //Requester
        receivers.add(ICR.OwnerId);
        //GSCS Staff
        receivers.add(ICR.BE_GSCS_Staff_ID__c);
        //GSCS
        receivers.add(ICR.BE_GSCS_ID__c);
                    
        // Actually send the notification
        try {
            customNoti.send(receivers);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
    }
    //E-13 Requester (Disappointed) (GSCS, GSCS Staff, Requester)
    public void SendEmailDisappointedAMM(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string requestDate = ICR.Request_Date__c.format();
        
        User GSCS = [select id, email, firstname, lastname from User where Id =: ICR.BE_GSCS_ID__c];
        
        //Receivers GSCS, GSCS Staff, Requester
        string[] receiverIds = new string[] { ICR.BE_GSCS_ID__c, ICR.BE_GSCS_Staff_ID__c, ICR.OwnerId };
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Disappointed_E_13'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
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
    
    //E-15 Committee Expire Reminder (Requester, VP, GSCS Staff, GSCS)
    public void SendEmailExpireCommitteeReminder(ICR_Approval__c ICR) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ICR.Id;
        string endDate = '';
        
        if(ICR.End_Date__c != null) {
            endDate = ICR.End_Date__c.format();
        }
        
        //Receivers Requester, VP, GSCS Staff, GSCS
        string[] receiverIds = new string[] { ICR.OwnerId, ICR.BE_Line_Manager_ID__c, ICR.BE_GSCS_ID__c, ICR.BE_GSCS_Staff_ID__c };
        
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
            
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Committee_Expired_E_15'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.End_Date__c}', endDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Committee_Title__c);
            plainBody = plainBody.replace('{!ICR_Approval__c.End_Date__c}', endDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            //Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            lstMails.add(message);
            
            /* if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            } */
            
        }
        
        if(lstMails.size() > 0) {
            //Sending the email list in a single call.
        	Messaging.sendEmail(lstMails);
        }
        
    }
    
    //E-16 Reset Running No for ICR
    public void SendEmailResetRunningNoReminder() {
        
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
            
        User adminUser = [select id, email from user where username =: 'anawach@softever.co.th'];
        
        List<ICR_Config__c> Configs = [select id, admin_email__c from icr_config__c];

        List<string> adminEmails = new List<string>();
        
        boolean moreThanOneEmail = Configs[0].admin_email__c.contains(',');
        
        if(moreThanOneEmail) {
            adminEmails = Configs[0].admin_email__c.split(',');
        }
        else {
            adminEmails.add(Configs[0].admin_email__c);
        }
        
        
        for(string adminEmail : adminEmails) {
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'ICR_Reset_Running_No_E_16'];
            
            string subject = emailTemplate.Subject;
            
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', 'Admin');
            
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', 'Admin');
            
            message.setTargetObjectId(adminUser.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(adminUser.Id);
            message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
            
            message.toAddresses = new String[] { adminEmail };
                
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            //Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                
            lstMails.add(message);
            
            
        }
                   
        if(lstMails.size() > 0) {
            //Sending the email list in a single call.
        	Messaging.sendEmail(lstMails);
        }
        
    }
}