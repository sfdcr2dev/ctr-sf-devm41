/* Author Softever */
public with sharing class ICR_ChangeStatusController {
    
    @auraEnabled
    public static string getCurrentStatus(Id ICRId) {
        
        Id LoggedInUserId = UserInfo.getUserId();
        
        string responseStatus = '';
        
        ICR_Approval__c ICR = [select id, name, status__c, recordtype.name, ask_to_review__c, type__c, active__c, amm_conclusion__c from ICR_Approval__c where Id =: ICRId];
        
        string RTName = ICR.RecordType.Name;
        string Status = ICR.Status__c;
        boolean isActive = ICR.Active__c;
        
        boolean isRecordLock = Approval.isLocked(ICRId);
        
        boolean isCancelDisappointShow = checkCancelDisappointPermission(ICRId, Status);
        system.debug(isCancelDisappointShow);
        
        if(Status == 'Waiting Line Manager Approval' || Status == 'Waiting EVP Approval') {
           //|| Status == 'Waiting Signed Circular File') {
            
            if(isCancelDisappointShow) {
                responseStatus = 'Cancel';
            }
        }
        if(Status == 'Waiting GSCS Approval' && ICR.Type__c == 'Other') {
            
            if(isCancelDisappointShow) {
                responseStatus = 'Cancel';
            }
            
        }
        else if(Status == 'Waiting Requester Update Result') {
            
            /* if(isCancelDisappointShow && ICR.Type__c == 'AMM' && ICR.AMM_Conclusion__c == 'Disappoint') {
            	responseStatus = 'Disappoint';
            } */
            
            responseStatus = 'Review';
            
            if(ICR.Ask_to_Review__c == false && ICR.Type__c == 'AMM' && ICR.AMM_Conclusion__c == 'Appoint') {
                responseStatus = 'ReviewAMM';
            }
            else if(ICR.Ask_to_Review__c == true && ICR.Type__c == 'AMM' && ICR.AMM_Conclusion__c == 'Appoint') {
                responseStatus = 'ReviewNone';
            }
            else if(ICR.Ask_to_Review__c == false && ICR.Type__c == 'AMM' && ICR.AMM_Conclusion__c == 'Disappoint') {
                if(isCancelDisappointShow) {
                    responseStatus = 'DisappointAMM';
                }
            }
            else if(ICR.Ask_to_Review__c == true && ICR.Type__c == 'AMM' && ICR.AMM_Conclusion__c == 'Disappoint') {
                responseStatus = 'ReviewAMM';
                
                if(isCancelDisappointShow) {
                    responseStatus = 'ReviewDisappointAMM';
                }
            }
            else if(ICR.Ask_to_Review__c == false && ICR.Type__c == 'CEO') {
                responseStatus = 'ReviewCEO';
            }  
            else if(ICR.Ask_to_Review__c == true && ICR.Type__c == 'CEO') {
                responseStatus = 'ReviewNone';
            }               
        }
        else {
            responseStatus = 'None';
        } 
        
        if(isRecordLock) {
            responseStatus = 'None';
        }
        
        if(isRecordLock && (status == 'Waiting Line Manager Approval' || status == 'Waiting EVP Approval')) {
                
            if(isCancelDisappointShow) {
                responseStatus = 'Cancel'; 
            }
        }
        else if(isRecordLock && status == 'Waiting GSCS Approval' && ICR.Type__c == 'Other') {
            
            if(isCancelDisappointShow) {
                responseStatus = 'Cancel'; 
            }
        }
        else if(isRecordLock && status == 'Waiting GSCS Approval' && ICR.Type__c != 'Other') {
            
            if(isCancelDisappointShow) {
                responseStatus = 'Cancel'; 
            }
        }
        
        if(Status == 'Appointed' && isActive) {
            
			boolean isExpire = checkExpirePermission(ICR.Id, Status);
            if(isExpire) {
                responseStatus = 'Active';
            }  
            else {
                responseStatus = 'DisableActive';
            }
        }
        else if(Status == 'Appointed' && !isActive) {
            responseStatus = 'Expired';
        }
        system.debug(responseStatus);
        return responseStatus;
    }
    
    @auraEnabled
    public static boolean cancelStatus(Id ICRId, string cancelReason) {
        
        ICR_Approval__c ICR = [select id, name, status__c, cancel_reason__c from ICR_Approval__c where Id =: ICRId];
        
        //Unlock Record
        List<ICR_Approval__c> ICRApprovals = new List<ICR_Approval__c>();
        ICRApprovals.add(ICR);
        
        Approval.UnlockResult[] lrList = Approval.unlock(ICRApprovals, false);

        if(lrList.size() > 0) {
            for(Approval.UnlockResult lr : lrList) { 
                
                if(lr.isSuccess()) {
                    System.debug(lr.getId());
                }
            }
        }
        
        //Reject Record
        List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem 
            WHERE ProcessInstance.TargetObjectId =: ICRId ];
        
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for(ProcessInstanceWorkitem workItem : workItems) {
          Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setWorkitemId(workItem.Id);
          //Valid values are: Approve, Reject, or Removed. 
          //Only system administrators can specify Removed.
          req.setAction('Reject');
          req.setComments('Cancel this ICR.');
          requests.add(req);
        }
        Approval.ProcessResult[] processResults = Approval.process(requests);
        
        ICR.Status__c = 'Cancelled Request';
        ICR.Cancel_Reason__c = cancelReason;
        update(ICR);
        
        return true;
    }
    
    @auraEnabled
    public static boolean disappointStatus(Id ICRId) {
        
        ICR_Approval__c ICR = [select id, name, status__c, type__c, amm_conclusion__c from ICR_Approval__c where Id =: ICRId];

        if(!string.isBlank(ICR.Type__c) && string.isBlank(ICR.AMM_Conclusion__c)) {
            return false;
        }

        //Unlock Record
        List<ICR_Approval__c> ICRApprovals = new List<ICR_Approval__c>();
        ICRApprovals.add(ICR);
        
        Approval.UnlockResult[] lrList = Approval.unlock(ICRApprovals, false);

        if(lrList.size() > 0) {
            for(Approval.UnlockResult lr : lrList) { 
                
                if(lr.isSuccess()) {
                    System.debug(lr.getId());
                }
            }
        }
        
        //Reject Record
        List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem 
            WHERE ProcessInstance.TargetObjectId =: ICRId ];
        
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for(ProcessInstanceWorkitem workItem : workItems){
          Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setWorkitemId(workItem.Id);
          //Valid values are: Approve, Reject, or Removed. 
          //Only system administrators can specify Removed.
          req.setAction('Reject');
          req.setComments('Disappointed this ICR.');
          requests.add(req);
        }
        Approval.ProcessResult[] processResults = Approval.process(requests);
        
        ICR.Status__c = 'Disappointed';
        update(ICR);
        
        return true;
        
    }
    
    @auraEnabled
    public static boolean expiredCommittee(Id ICRId) {
        
        ICR_Approval__c ICR = [select id, name, status__c, type__c, active__c from ICR_Approval__c where Id =: ICRId];

        ICR.Active__c = false;
        ICR.End_Date__c = system.Date.today();
        update(ICR);
        
        return true;
        
    }
    
    @auraEnabled
    public static boolean activeCommittee(Id ICRId) {
        
        ICR_Approval__c ICR = [select id, name, status__c, type__c, active__c from ICR_Approval__c where Id =: ICRId];

        ICR.Active__c = true;
        update(ICR);
        
        return true;
        
    }
    
    @auraEnabled
    public static boolean getAskToReview(Id ICRId) {
        
        ICR_Approval__c ICR = [select id, name, status__c, ownerid, be_gscs_staff_id__c, Ask_to_Review__c,
                               Request_Date__c, type__c from ICR_Approval__c where Id =: ICRId];
		
        ICR.Ask_to_Review__c = true;
        update(ICR);
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm()+'/'+ICR.Id;
        
        string requestDate = ICR.Request_Date__c.format();
        
        //Receivers 
        string[] receiverIds = new string[] { ICR.OwnerId , ICR.BE_GSCS_Staff_ID__c  } ;
        
        for(string receiverId : receiverIds) {
            
            User Receiver = [select id, email, firstname, lastname from User where Id =: receiverId];
            
            //Send email
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Thaioil'); 
            message.setSaveAsActivity(false); 
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName = 'ICR_Ask_to_Review'];
            
        	string subject = emailTemplate.Subject;
        	subject = subject.replace('{!ICR_Approval__c.Name}', ICR.name);
        
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Name);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            htmlBody = htmlBody.replace('{!ICR_Approval__c.Link}', URL);
            htmlBody = htmlBody.replace(']]>', '');
        
        	String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Receiver}', Receiver.FirstName + ' ' + Receiver.LastName);
            plainBody = plainBody.replace('{!ICR_Approval__c.Name}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Committee_Title__c}', ICR.Name);
            plainBody = plainBody.replace('{!ICR_Approval__c.Request_Date__c}', requestDate);
            plainBody = plainBody.replace('{!ICR_Approval__c.Link}', URL);
            plainBody = plainBody.replace(']]>', '');
        	
            message.setTargetObjectId(Receiver.Id); 
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(Receiver.Id);
        	message.setSubject(subject);
            message.setHtmlBody(htmlBody);
            message.setPlainTextBody(plainBody);
        
            message.toAddresses = new String[] { receiver.email, 'sarocha@softever.co.th' };
                   
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
            
        }
        
        //Send Noti
        ICR_CustomEmailAndNotiController Noti = new ICR_CustomEmailAndNotiController();
        Noti.SendNotiAskToReview(ICR);
            
        return true;
        
    }
    
    public static boolean checkCancelDisappointPermission(Id ICRId, string status) {
        
        boolean canShow = false;
        
        Id loggedInUserId = UserInfo.getUserId();
        
        ICR_Approval__c ICR = [select id, name, approver__c, be_evp_id__c, ownerId from ICR_Approval__c where Id =: ICRId];
        
        //GSCS Staff
        List<Id> GSCSStaffIds = new List<Id>();
        Group GSCSStaffGroup = [select id, developername from Group where developername =: 'ICR_GSCS_Staff'];
        List<GroupMember> GSCSStaffUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSStaffGroup.Id];
                    
        if(GSCSStaffUsers.size() > 0) {
            for(GroupMember GSCSStaff : GSCSStaffUsers) {
                GSCSStaffIds.add(GSCSStaff.UserOrGroupId);
            }
        }
        
        //GSCS
        List<Id> GSCSIds = new List<Id>();
        Group GSCSGroup = [select id, developername from Group where developername =: 'ICR_GSCS'];
        List<GroupMember> GSCSUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSGroup.Id];
                    
        if(GSCSUsers.size() > 0) {
            for(GroupMember GSCS : GSCSUsers) {
                GSCSIds.add(GSCS.UserOrGroupId);
            }
        }
        
        if(status == 'Waiting Line Manager Approval') {
            if(loggedInUserId == ICR.Approver__c) {
                canShow = true;
            }
        }
        else if(status == 'Waiting GSCS Approval') {
            if(GSCSIds.size() > 0) {
                for(Id GSCSId : GSCSIds) {
                    if(loggedInUserId == GSCSId) {
                        canShow = true;
                    }
                }
            }
        }        
        else if(status == 'Waiting Requester Update Result') {
            if(GSCSStaffIds.size() > 0) {
                for(Id GSCSStaffId : GSCSStaffIds) {
                    if(loggedInUserId == GSCSStaffId) {
                        canShow = true;
                    }
                }
            }
            
            if(loggedInUserId == ICR.OwnerId) {
                canShow = true;
            }
        }       
        else if(status == 'Waiting EVP Approval') {
            if(loggedInUserId == ICR.BE_EVP_ID__c) {
                canShow = true;
            }
        }
        
        return canShow;
        
    }
    
    public static boolean checkExpirePermission(Id ICRId, string status) {
        
        boolean canShow = false;
        
        Id loggedInUserId = UserInfo.getUserId();
        
        ICR_Approval__c ICR = [select id, name, approver__c, be_evp_id__c, ownerId, active__c from ICR_Approval__c where Id =: ICRId];
        
        //GSCS Staff
        List<Id> GSCSStaffIds = new List<Id>();
        Group GSCSStaffGroup = [select id, developername from Group where developername =: 'ICR_GSCS_Staff'];
        List<GroupMember> GSCSStaffUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSStaffGroup.Id];
                    
        if(GSCSStaffUsers.size() > 0) {
            for(GroupMember GSCSStaff : GSCSStaffUsers) {
                GSCSStaffIds.add(GSCSStaff.UserOrGroupId);
            }
        }
        
        if(status == 'Appointed' && ICR.Active__c == true) {
            if(GSCSStaffIds.size() > 0) {
                for(Id GSCSStaffId : GSCSStaffIds) {
                    if(loggedInUserId == GSCSStaffId) {
                        canShow = true;
                    }
                }
            }
        }   
        
        return canShow;
        
    }
    
}