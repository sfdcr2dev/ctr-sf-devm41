public without sharing class CommitteeTakeActionApprove {
    @AuraEnabled
    public static void submitProcrssApprovalRequest(Id recordId, String appreovalAction, String remark, Boolean sendFromSFDC){
        List<CTRCommitteeApproval__c> committeeToUpdates = new List<CTRCommitteeApproval__c>();
        // try {
            // Send Approve form SFDC
            if (sendFromSFDC) {
                // get user Id
                String userId = UserInfo.getUserId();
                List<CTRCommitteeApproval__c> ctrCommitteeList =
                [   SELECT Id,CTRRequestFormItem__c,ApprovalResult__c,Remark__c, CTRRequestFormItem__r.RecordTypeName__c
                    FROM CTRCommitteeApproval__c
                    WHERE ApprovalResult__c IN ('Submit to Committee', 'Reply to TRCR', 'Reply to FA', 'Reply to FALB')
                    AND CTRRequestFormItem__c  =:recordId
                    AND ApproverName__c =:userId
                ];
                for(CTRCommitteeApproval__c ctrCommittee: ctrCommitteeList){
                    CTRCommitteeApproval__c committeeToUpdate = new CTRCommitteeApproval__c();
                    committeeToUpdate.Id = ctrCommittee.Id;
                    committeeToUpdate.ApprovalResult__c = appreovalAction;
                    committeeToUpdate.ApprovalDate__c = Date.today();
                    committeeToUpdate.Remark__c = remark;
                    committeeToUpdates.add(committeeToUpdate);
                }
                update committeeToUpdates;

                List<CTRCommitteeApproval__c> cmapList = [
                    SELECT Id,ApprovalResult__c
                    FROM CTRCommitteeApproval__c
                    WHERE CTRRequestFormItem__c  =:recordId
                ];
                Boolean allDone = true;
                Boolean hasRejected = false;
                for (CTRCommitteeApproval__c cmap : cmapList) {
                    if (cmap.ApprovalResult__c != 'Approved' && cmap.ApprovalResult__c != 'Rejected') {
                        allDone = false;
                    }
                    if (cmap.ApprovalResult__c == 'Rejected') {
                        hasRejected = true;
                    }
                }
                if (hasRejected == true) {
                    CTRRequestFormItem__c rqit = new CTRRequestFormItem__c();
                    rqit.Id = recordId;
                    rqit.Status__c = 'Rejected';
                    rqit.Approval_Step__c = 'Rejected';
                    rqit.NotifyCustomAction__c = 'Committee Rejected';
                    update rqit;
                    return;
                }
                if (allDone && hasRejected != true) {
                    CTRRequestFormItem__c rqit = new CTRRequestFormItem__c();
                    rqit.Id = recordId;
                    rqit.Status__c = 'Approved';
                    rqit.Approval_Step__c = 'Approved';
                    rqit.NotifyCustomAction__c = 'Committee Approved';
                    update rqit;

                    updateChangeCreditFinancialInfo(rqit.Id);
                    return;
                }
            } else {
                // Send Approve form email
                // CTRCommitteeApproval__c committeeToUpdate = new CTRCommitteeApproval__c();
                // committeeToUpdate.Id = recordId;
                // committeeToUpdate.ApprovalResult__c = appreovalAction;
                // committeeToUpdate.ApprovalDate__c = Date.today();
                // committeeToUpdate.Remark__c = remark;
                // update committeeToUpdate;
                // CTRCommitteeApproval__c committeeToUpdate = [SELECT Id, CTRRequestFormItem__c FROM CTRCommitteeApproval__c WHERE Id = :recordId];
                // // committeeToUpdate.Id = recordId;
                // committeeToUpdate.ApprovalResult__c = appreovalAction;
                // committeeToUpdate.ApprovalDate__c = Date.today();
                // committeeToUpdate.Remark__c = remark;
                // update committeeToUpdate;

                List<CTRCommitteeApproval__c> ctrCommitteeList =
                [   SELECT Id,CTRRequestFormItem__c,ApprovalResult__c,Remark__c, CTRRequestFormItem__r.RecordTypeName__c
                    FROM CTRCommitteeApproval__c
                    WHERE ApprovalResult__c IN ('Submit to Committee', 'Reply to TRCR', 'Reply to FA', 'Reply to FALB')
                    AND Id = :recordId
                ];
                if (ctrCommitteeList.size() > 0) {
                    for(CTRCommitteeApproval__c ctrCommittee: ctrCommitteeList){
                        CTRCommitteeApproval__c committeeToUpdate = new CTRCommitteeApproval__c();
                        ctrCommittee.ApprovalResult__c = appreovalAction;
                        ctrCommittee.ApprovalDate__c = Date.today();
                        ctrCommittee.Remark__c = remark;
                        committeeToUpdates.add(ctrCommittee);
                    }
                    update committeeToUpdates;

                    List<CTRCommitteeApproval__c> cmapList = [
                        SELECT Id,ApprovalResult__c
                        FROM CTRCommitteeApproval__c
                        WHERE CTRRequestFormItem__c  = :committeeToUpdates[0].CTRRequestFormItem__c
                    ];
                    Boolean allDone = true;
                    Boolean hasRejected = false;
                    for (CTRCommitteeApproval__c cmap : cmapList) {
                        if (cmap.ApprovalResult__c != 'Approved' && cmap.ApprovalResult__c != 'Rejected') {
                            allDone = false;
                        }
                        if (cmap.ApprovalResult__c == 'Rejected') {
                            hasRejected = true;
                        }
                    }
                    if (hasRejected == true) {
                        CTRRequestFormItem__c rqit = new CTRRequestFormItem__c();
                        rqit.Id = committeeToUpdates[0].CTRRequestFormItem__c;
                        rqit.Status__c = 'Rejected';
                        rqit.Approval_Step__c = 'Rejected';
                        rqit.NotifyCustomAction__c = 'Committee Rejected';
                        update rqit;
                        return;
                    }
                    if (allDone && hasRejected != true) {
                        CTRRequestFormItem__c rqit = new CTRRequestFormItem__c();
                        rqit.Id = committeeToUpdates[0].CTRRequestFormItem__c;
                        rqit.Status__c = 'Approved';
                        rqit.Approval_Step__c = 'Approved';
                        rqit.NotifyCustomAction__c = 'Committee Approved';
                        update rqit;

                        updateChangeCreditFinancialInfo(rqit.Id);
                        return;
                    }
                }
            }

        // } catch(Exception e){
        //     throw new AuraHandledException(e.getMessage());
        // }
    }

    @AuraEnabled
	public static String getRecordType(Id recordId) {
    CTRRequestFormItem__c recordTypeCTRRequestFormItem = [SELECT Id, RecordTypeId, RecordTypeName__c FROM CTRRequestFormItem__c WHERE Id = :recordId];

    String recordTypeRequestFormItem = recordTypeCTRRequestFormItem.RecordTypeName__c;

    return recordTypeRequestFormItem;
}

    @AuraEnabled
    public static void submitReplyTo(String recordId, String message, String actionButton){
        // try{
            // User submitter = [SELECT Id, Email FROM User WHERE Id =: UserInfo.getUserId()];
            system.debug('recordId ---'+recordId);
            // Get the ID of the organization-wide email address
            OrgWideEmailAddress orgWideEmail = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Commercial Team'];
            // query requestItem Id
            CTRCommitteeApproval__c  rqForm = [
                SELECT CTRRequestFormItem__c,
                CTRRequestFormItem__r.Message__c,
                CTRRequestFormItem__r.EmailTo__c,
                CTRRequestFormItem__r.EmailCC__c,
                CTRRequestFormItem__r.Subject__c,
                ApproverName__r.Name,
                CTRRequestFormItem__r.CreditOwner__r.Email,
                CTRRequestFormItem__r.CreditOwnerName__c,
                CTRRequestFormItem__r.fmlAccountTypeName__c,
                CTRRequestFormItem__r.CompanyNameSubject__c,
                CTRRequestFormItem__r.SubBU__c,
                CTRRequestFormItem__r.Name,
                TRCRSectionHead__c,
                Owner.Name,
                ApproverName__r.Email
                FROM CTRCommitteeApproval__c
                WHERE id =:recordId];

        CTRConfig__c customSetting = CTRConfig__c.getInstance();
        String valueURL = customSetting.EmailService__c;

            if(rqForm.CTRRequestFormItem__r.EmailCC__c == null ||rqForm.CTRRequestFormItem__r.EmailCC__c == ''){
            	rqForm.CTRRequestFormItem__r.EmailCC__c = valueURL;
            }else if(rqForm.CTRRequestFormItem__r.EmailCC__c.indexOf(valueURL) == -1){
        		rqForm.CTRRequestFormItem__r.EmailCC__c = rqForm.CTRRequestFormItem__r.EmailCC__c+', '+valueURL;
			}

            //String[] splitEmailTo = rqForm.CTRRequestFormItem__r.EmailTo__c.split(',');
            String[] splitEmailTo = new List <String>();
            splitEmailTo.add(rqForm.CTRRequestFormItem__r.CreditOwner__r.Email);
            String[] splitEmailCC = rqForm.CTRRequestFormItem__r.EmailCC__c.split(',');
            // Email CC Replace 'space', usage query where Email IN emailCC
            String[] emailCC = rqForm.CTRRequestFormItem__r.EmailCC__c.split(',');
            for (Integer i = 0; i < emailCC.size(); i++) {
                emailCC[i] = emailCC[i].replace('\\s', '').trim();
            }
            //TODO Query user from EmailTo, Use show 'User Name' in content message.
            // List<User> users = [SELECT Id, Name FROM User WHERE Email IN :emailCC];
            // List<User> users = [SELECT Name FROM User WHERE Email='woraporn.l@roundtwosolutions.com']; //TODO mockup value //use Name in email message.
            // System.debug('result::'+users);
            // Add emailCC in list<String> param0
            list<String> eCC = new list<String>();
            eCC.add(emailCC[0]);
            eCC.add(rqForm.ApproverName__r.Email); // cc committee
            String subjecttemp = rqForm.CTRRequestFormItem__r.Subject__c;


            if(rqForm.CTRRequestFormItem__r.Subject__c != null) {
                if(!subjecttemp.contains('[RequestNo.:')) {
                    subjecttemp = '[RequestNo.:'+rqForm.CTRRequestFormItem__c+']'+subjecttemp;
                }
                subjecttemp = 'Re:' + subjecttemp;
            }
            //Messaging.SingleEmailMessage emailTosend = emailTemplateFormSend(rqForm.CTRRequestFormItem__c,subjecttemp,recordId, orgWideEmail.Id, rqForm.ApproverName__r.Name, message, users[0].Name, eCC, splitEmailTo, actionButton);
            // Messaging.SingleEmailMessage emailTosend = emailTemplateFormSend(rqForm.CTRRequestFormItem__c,subjecttemp,recordId, orgWideEmail.Id, rqForm.ApproverName__r.Name, message, users[0].Name, splitEmailTo, eCC, actionButton);
            // Messaging.SingleEmailMessage emailTosend = emailTemplateFormSend(rqForm.CTRRequestFormItem__c,subjecttemp,recordId, orgWideEmail.Id, rqForm.ApproverName__r.Name, message, rqForm.CTRRequestFormItem__r.CreditOwner__r.Name, splitEmailTo, eCC, actionButton);
            Messaging.SingleEmailMessage emailTosend = emailTemplateFormSend(recordId, orgWideEmail.Id, rqForm.CTRRequestFormItem__r.SubBU__c, subjecttemp, rqForm.CTRRequestFormItem__r.Name, rqForm.CTRRequestFormItem__r.fmlAccountTypeName__c, rqForm.CTRRequestFormItem__r.CompanyNameSubject__c,rqForm.ApproverName__r.Name, rqForm.CTRRequestFormItem__r.CreditOwnerName__c, message, splitEmailTo, eCC, actionButton);
            try {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailTosend});
            } catch(Exception ex) {
                System.debug(ex.getMessage());
            }

            // Send Reply form email and save field Message in CTRCommitteeApprovalObj
            CTRCommitteeApproval__c committeeToUpdate = new CTRCommitteeApproval__c();
            committeeToUpdate.Id = recordId;
            committeeToUpdate.Remark__c = message;
            committeeToUpdate.ReplytoTRCR__c = message;
            if (actionButton == 'ReplyFA') {
                committeeToUpdate.ApprovalResult__c = 'Reply to FA';
            } else if (actionButton == 'ReplyFALB') {
                committeeToUpdate.ApprovalResult__c = 'Reply to FALB';
            } else {
                committeeToUpdate.ApprovalResult__c = 'Reply to TRCR';
            }

            //if(actionButton == 'ReplyTRCR'){
            //    committeeToUpdate.ReplytoTRCR__c = message;
            //}else if(actionButton == 'ReplyFA'){
            //    committeeToUpdate.ReplytoFA__c = message;
            //}
            update committeeToUpdate;

            CTRRequestFormItem__c CTRReqItem = [SELECT id,CCEmail__c, Status__c, Approval_Step__c from CTRRequestFormItem__c where id =:rqForm.CTRRequestFormItem__c];
            // CTRReqItem.CCEmail__c = '['+CTRReqItem.CCEmail__c + emailTosend.HtmlBody+']';
            // CTRReqItem.Status__c = 'In Review';
            // CTRReqItem.Approval_Step__c = 'Select Committee';
            CTRReqItem.ReplyToTRCRHistory__c = '['+CTRReqItem.CCEmail__c + emailTosend.HtmlBody+']';
            update CTRReqItem;


        // }catch (Exception e) {
        //     system.debug('committeetakeactionapprove ---'+e.getMessage()+' line:'+e.getlinenumber());
        //     throw new AuraHandledException(e.getMessage());
        // }
    }

    // public static Messaging.SingleEmailMessage emailTemplateFormSend(string reqItemId,string reqItemSubject,String recordId,String orgWideEmailId, String approveName, String message, String emailName, String[] emailToAddresses, String[] emailCCAddresses, String actionButton){
    public static Messaging.SingleEmailMessage emailTemplateFormSend(String recordId,String orgWideEmailId, String subBU, String emailSubject, String formItemName, String accountType, String companyName, String approveName, String emailName, String message, String[] emailToAddresses, String[] emailCCAddresses, String actionButton){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // set HTML body in emal Reply
        // String subProfile;
        // String subText;
        // if(actionButton == 'ReplyTRCR'){
        //     subProfile = '[TOP]';
        //     subText = 'Supplier Registration';
        // }else{
        //     subProfile = '[TX]';
        //     subText = 'Customer Registration';
        // }

        EmailTemplate emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body FROM EmailTemplate WHERE developername = 'CTRCommitteeReplytoTRCR' AND IsActive = true];
        String emailContentMessage = emailTemplate.HtmlValue.replace('{!CTRRequestFormItem__c.CreditOwnerName__c}',emailName != null ? emailName : '');
        emailContentMessage = emailContentMessage.replace('{!CTRCommitteeApproval__c.ApproverName__c}',approveName != null ? approveName : '');
        emailContentMessage = emailContentMessage.replace('{!CTRCommitteeApproval__c.ReplytoTRCR__c}',message != null ? message : '');

        if(emailSubject == null) {
            emailSubject = emailTemplate.Subject;
        }
        emailSubject = emailSubject.replace('{!CTRRequestFormItem__c.fmlAccountTypeName__c}',accountType != null ? accountType : '');
        emailSubject = emailSubject.replace('{!CTRRequestFormItem__c.CompanyNameSubject__c}',companyName != null ? companyName : '');
        emailSubject = emailSubject.replace('{!CTRRequestFormItem__c.SubBU__c}',subBU != null ? subBU : '');
        emailSubject = emailSubject.replace('{!CTRRequestFormItem__c.Name}',formItemName != null ? formItemName : '');
        

        // String emailContentMessage = '<p> Dear ' + emailName + '</p>'+'<br> <p>You received a comment from the committee. ' + approveName + ', on the approval request. Please see the message below and reply to the commmittee.</p>';
        // String emailContentMessageReply = message;
        // String footerOfEmail = '<p> Best Regards,</p><p>Counterparties Registration Automated System</p>';
        email.setToAddresses(emailToAddresses);

        if(!emailCCAddresses.contains('ccemailcommitteetestuser@278tumlkpac10g9kik3znxpnfa13iz7hj9w1rudnbh2cj8m2pw.1m-2nh5eam.cs117.apex.sandbox.salesforce.com')){
            	emailCCAddresses.add('ccemailcommitteetestuser@278tumlkpac10g9kik3znxpnfa13iz7hj9w1rudnbh2cj8m2pw.1m-2nh5eam.cs117.apex.sandbox.salesforce.com');
            //emailCCAddresses.add('an.t@roundtwosolutions.com');
		}
        email.setCcAddresses(emailCCAddresses);
        email.setWhatId(recordId);
        email.setSubject(emailSubject);
        // email.setSubject(reqItemSubject);
        //email.setSubject('[FYA]'+subProfile+' : Request for Approval of New '+subText+': P. General Group Co.,LTD.');
        // email.setHtmlBody(emailContentMessage+'<br>'+emailContentMessageReply+'<br><br>'+footerOfEmail);
        email.setHtmlBody(emailContentMessage);
        email.setSaveAsActivity(false);
        email.setOrgWideEmailAddressId(orgWideEmailId);
        email.setCharset('UTF-8');
        return email;
    }

    @AuraEnabled
    public static Boolean checkPermissionBeforeShowModal(String recordId){
        String userId = UserInfo.getUserId();
        List<CTRCommitteeApproval__c> ctrCommitteeList =
        [   SELECT Id,CTRRequestFormItem__c,ApprovalResult__c,Remark__c, CTRRequestFormItem__r.RecordTypeName__c
            FROM CTRCommitteeApproval__c
            WHERE ApprovalResult__c IN ('Submit to Committee', 'Reply to TRCR', 'Reply to FA', 'Reply to FALB')
            AND CTRRequestFormItem__c  =:recordId
            AND ApproverName__c =:userId
        ];
        if(ctrCommitteeList != null && ctrCommitteeList.size() > 0){
            return true;
        }

        ctrCommitteeList =
        [   SELECT Id,CTRRequestFormItem__c,ApprovalResult__c,Remark__c, CTRRequestFormItem__r.RecordTypeName__c
            FROM CTRCommitteeApproval__c
            WHERE ApprovalResult__c IN ('Submit to Committee')
            AND Id  =:recordId
            AND ApproverName__c =:userId
        ];
        if(ctrCommitteeList != null && ctrCommitteeList.size() > 0){
            return true;
        }

        return false;
    }
     @AuraEnabled
    public static string getCTRCommitteeApprovalId(String recordId){
        String userId = UserInfo.getUserId();
        List<CTRCommitteeApproval__c> ctrCommitteeList =
        [   SELECT Id,CTRRequestFormItem__c,ApprovalResult__c, CTRRequestFormItem__r.RecordTypeName__c
            FROM CTRCommitteeApproval__c
            WHERE ApprovalResult__c IN ('Submit to Committee', 'Reply to TRCR', 'Reply to FA', 'Reply to FALB')
            AND CTRRequestFormItem__c  =:recordId
            AND ApproverName__c =:userId
        ];
        string CTRCommitteeApprovaId = null;

        if(ctrCommitteeList != null && ctrCommitteeList.size() > 0){
            CTRCommitteeApprovaId = ctrCommitteeList[0].Id;
        }

        system.debug('CTRCommitteeApprovaId----'+CTRCommitteeApprovaId);
        return CTRCommitteeApprovaId;
    }
    @AuraEnabled
    public static string getActionButton(String recordId){
        String userId = UserInfo.getUserId();
        string BuProfile = CTRBuProfileController.checkBusinessUnitFromProfile(userId,recordId).BusinessUnit__c;
        String result;
         switch on BuProfile {
            when 'TOP' {
                result = 'ReplyTRCR';
            }
            when 'TX' {
                result = 'ReplyFA';
            }
            when 'LABIX' {
                result = 'ReplyFALB';
            }
            when else {
                result = 'Other';
            }
        }

        return result;
    }

    private static void updateChangeCreditFinancialInfo(Id recordId) {
        // CTRRequestFormItem__c rqit = [
        //     SELECT Id, ChangeCreditInternalCreditRating__c, ChangeCreditCreditCondition__c, ChangeCreditCreditLimit__c, FinancialKey__c
        //     FROM CTRRequestFormItem__c
        //     WHERE Id = :recordId
        // ];

        // String accountId = rqit.Customer__c;
        // String financialKey = rqit.FinancialKey__c;
        // C360_FinancialInfo__c fcif = [
        //     SELECT Id, InternalCreditRating__c, Credit_Condition__c, CreditLimit__c
        //     FROM C360_FinancialInfo__c
        //     WHERE CompanyName__c = :accountId
        //         AND Key__c = :financialKey
        // ];

        // fcif.InternalCreditRating__c = rqit.ChangeCreditCreditCondition__c;
        // fcif.Credit_Condition__c = rqit.Credit_Condition__c;
        // fcif.CreditLimit__c = rqit.CreditLimit__c;

        // update fcif;
    }

}