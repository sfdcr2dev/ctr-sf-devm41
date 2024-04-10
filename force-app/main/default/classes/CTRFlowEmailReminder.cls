public class CTRFlowEmailReminder {

    @InvocableMethod(label='Send Email Reminder via apex')
    public static void sendEmail(List<FlowInputs> mData) 
    {   
        String recordId = mData[0].recordId;
        CTRRequestFormItem__c reqFormObj = mData[0].reqFormObj;
        List<CTRCommitteeApproval__c> newCommApprs = mData[0].newCommApprs;
        String uploadedList = mData[0].uploadedList;
        String templateType = mData[0].templateType;
        String profile = mData[0].profile;
        
        system.debug('recordId : '+recordId);
        system.debug('reqFormObj : '+reqFormObj);
        system.debug('newCommApprs : '+newCommApprs);
        system.debug('uploadedList : '+uploadedList);
        system.debug('templateType : '+templateType);
        system.debug('profile : '+profile);
        EmailTemplate emailTemplate = new EmailTemplate();
        if (templateType == 'Committee TOP') {
            emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailTOP'];
        } else if (templateType == 'Committee TX') {
            emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailTX'];
        }else if (templateType == 'Committee LABIX') {
            emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailLABIX'];
        }
        system.debug('emailTemplate : '+emailTemplate);
        CTRRequestFormItem__c rqForm = [SELECT Id, SubBU__c, EmailUrgent__c, EmailTo__c, EmailCC__c, AmountOpenedCredit__c, AmountDCLCondition__c, AmountBuyTrade__c, AmountCreditTerm__c,
                Subject__c, Message__c, Owner__c, Owner__r.Name, CommitteeName__c, RecordType.Name, CommitteeReassign__c,
                CommitteeEmail__c, CommitteeAttachment__c, BuyTradeDCLCondition__c, Name, AmountBankGuarantee__c,
                BuyTradeEndorsement__c, HavingCollateral__c, CashOnDelivery__c, HavingOpenedCredit__c, Currency__c, OtherCondition__c,
                Product__c, InternalCreditRating__c, InternalCreditRatingTOP__c, InterestedProductTypeAsCustomer__c, InterestedProductTypeAsSupplier__c,
                InterestedProductTypeAsCustomerTOP__c, InterestedProductTypeAsSupplierTOP__c, InterestedProductTypeAsCustomerTX__c, InterestedProductTypeAsSupplierTX__c,
                PurchasingOrganizationTX__c, SalesOrganizationTX__c, CTRRequestFormHeader__r.Customer__r.Name, CTRRequestFormHeader__r.Customer__c,
                CommitteeStatus__c, Status__c, Approval_Step__c, CMVPPreScreenDecision__c, OwnersCMVP__c, Country__r.Code__c,
                FinCrCond__c, FinPaymentCond__c, FinIntCrRating__c, FinOtherCondition__c, ApprovalTrader_CreditRating__c, TraderWaive__c, Approval_SHAgree__c, Approval_VPAgree__c,
                CTRRequestFormHeader__r.FirstName__c, CTRRequestFormHeader__r.LastName__c, CTRRequestFormHeader__r.Email__c, CTRRequestFormHeader__r.MobilePhone__c,BusinessUnit__c, TermOfPayment__c, TermOfPayment__r.Name
                FROM CTRRequestFormItem__c WHERE Id = :recordId];
        List<CTRCommitteeApproval__c> newCommApprsList = [SELECT Id, ApproverName__r.Name, ApproverName__r.Email, CTRRequestFormItem__c FROM CTRCommitteeApproval__c WHERE Id IN :newCommApprs];
        
        // Set To and CC Email Address List
        system.debug('Set To and CC Email Address List start');

        String[] toAddresses = reqFormObj.EmailTo__c.trim().split(',');
        system.debug('toAddresses : '+toAddresses);
        for (Integer i = 0; i < toAddresses.size(); i++) {
            system.debug('toAddresses[i] : '+toAddresses[i]);
            toAddresses[i] = toAddresses[i];
            //toAddresses[i] = toAddresses[i].replace('\\s', '').trim();
        }
        system.debug('toAddresses :2: '+toAddresses);

        List<String>ccAddresses = new List<String>();
        if(reqFormObj.EmailCC__c != '' && reqFormObj.EmailCC__c != NULL)
        {
            ccAddresses = reqFormObj.EmailCC__c.split(',');
            system.debug('ccAddresses : '+ccAddresses);
            for (Integer i = 0; i < ccAddresses.size(); i++) {
                ccAddresses[i] = ccAddresses[i].replace('\\s', '').trim();
            }
        }
        
        system.debug('Set To and CC Email Address List end');
        // Create an Email with Attachment
        system.debug('Create an Email with Attachment start');
        Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[]{};

        if (String.isNotBlank(uploadedList)) {
            List<String> filenames = uploadedList.split(',');

            List<Attachment> attachments = [SELECT Id, Name, Body, ContentType FROM Attachment WHERE ParentId = :recordId];
            system.debug('documentLinks param --> : recordId'+recordId + ' ContentDocument.Title -->'+ filenames);
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId 
                                                            FROM ContentDocumentLink 
                                                            WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :filenames];
            
            Map<Id, ContentVersion> contentVersionMap = new Map<Id, ContentVersion>();
    
            Set<Id> contentVersionIds = new Set<Id>();
            for (ContentDocumentLink documentLink : documentLinks) {
                contentVersionIds.add(documentLink.ContentDocument.LatestPublishedVersionId);
            }
    
            Map<Id, ContentVersion> contentVersions = new Map<Id, ContentVersion>([SELECT Id, Title, VersionData FROM ContentVersion WHERE Id IN :contentVersionIds]);
    
            if (!documentLinks.isEmpty()) {
                for (ContentDocumentLink documentLink : documentLinks) {
                    ContentVersion file = contentVersions.get(documentLink.ContentDocument.LatestPublishedVersionId);
    
                    Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
                    fileAttachment.setFileName(file.Title);
                    fileAttachment.setBody(file.VersionData);
    
                    fileAttachments.add(fileAttachment);
                }
            }
        }
        system.debug('Create an Email with Attachment mid');
        system.debug('newCommApprs : '+newCommApprs + ' : size '+ newCommApprs.size());

        String finalCondition = '';
        if(rqForm.BusinessUnit__c == 'TOP' || rqForm.BusinessUnit__c == 'LABIX') {
            finalCondition = rqForm?.FinPaymentCond__c != null ? rqForm.FinPaymentCond__c : '';
        } else if(rqForm.BusinessUnit__c == 'TX') {
            finalCondition = rqForm?.FinOtherCondition__c != null ? rqForm.FinOtherCondition__c : '';
        }
        
        for (Integer i = 0; i < newCommApprs.size(); i++) {
            String url = URL.getOrgDomainUrl().toExternalForm() + '/' + newCommApprs[i].CTRRequestFormItem__c;
            // Create an Email Message
            system.debug('Create an Email with Attachment mid : '+i);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            system.debug('Create an Email with Attachment mid : '+i + ' : newCommApprs[i].ApprovalResult__c : '+newCommApprs[i].ApprovalResult__c);
            system.debug('rqForm.Message__c : ' + rqForm.Message__c);
            system.debug('newCommApprs[i].Id : ' + newCommApprs[i].Id);
            system.debug('newCommApprsList[i].ApproverName__r.Name : ' + newCommApprsList[i].ApproverName__r.Name);
            if (newCommApprs[i].ApprovalResult__c == 'Submit to Committee') {
                String emailContent = emailTemplate.HtmlValue.replace('{!relatedTo.Message__c}', rqForm.Message__c)
                    .replace('{!relatedTo.Id}', newCommApprs[i].Id)
                    .replace('file.force.com', 'my.salesforce-sites.com')
                    .replace('{$RecordType$}', rqForm.RecordType.Name.contains('Customer') ? 'Customer' : (rqForm.RecordType.Name.contains('Supplier') ? 'Supplier' : ''))
                    .replace('{$CommitteeApprovalName$}', newCommApprsList[i].ApproverName__r.Name).replace('{$url$}', '<a href="' + url + '" target="_blank"><em>this link</em></a>').replace('{$CommitteeName$}', (rqForm.CommitteeName__c != null) ? rqForm.CommitteeName__c : '')
                    .replace('{$AccountName$}', (rqForm.CTRRequestFormHeader__r.Customer__c != null) ? rqForm.CTRRequestFormHeader__r.Customer__r.Name : '')
                    .replace('{$FinalCreditCondition$}', (rqForm.FinCrCond__c != null) ? rqForm.FinCrCond__c : '')
                    .replace('{$OrgDomainURL$}', System.URL.getOrgDomainURL().toExternalForm().replace('salesforce', 'salesforce-sites'))
                    .replace('{$FinalPaymentCondition$}', (rqForm?.FinPaymentCond__c != null) ? rqForm?.FinPaymentCond__c : '')
                    .replace('{$FinalCondition$}', finalCondition)
                    .replace('{$TermOfPayment$}', (rqForm?.TermOfPayment__c != null) ? rqForm.TermOfPayment__r.Name : '');
                //email.setToAddresses(new String[]{toAddresses[i]});
                email.setToAddresses(new String[]{newCommApprsList[i].ApproverName__r.Email});
                //system.debug('new String[]{toAddresses[i]} : ' + new String[]{toAddresses[i]});
                email.setCcAddresses(ccAddresses);
                email.setWhatId(recordId);
                email.setTemplateId(emailTemplate.Id);
                email.setSubject('[Reminder]'+reqFormObj.Subject__c);
                email.setHtmlBody(emailContent);
                email.setSaveAsActivity(false);
                email.setFileAttachments(fileAttachments);
                email.setCharset('UTF-8');
            }

            // Send the email
            system.debug('start send mail : '+i);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            system.debug('Create an Email with Attachment end');
            if (results[0].isSuccess()) {
                System.debug('Email sent successfully');
                // notifyUsers(reqFormObj, newCommApprs, profile);
            } else {
                System.debug('Email failed to send' + '. Errors: ' + results[0].getErrors()[0].getMessage());
            }
        }
        
    }
    
    ////
    public static void notifyUsers(CTRRequestFormItem__c reqItem, List<CTRCommitteeApproval__c> newCommApprs, String profile) {

        Set<String> recipientsIds = new Set<String>();
        String targetId = reqItem.Id;
        String accountName = reqItem.Name;
        String title = '';
        String body = '';

        if (profile == 'TOP') {
            title = accountName + ' is requesting for committee approval.';
            body = 'Committee has been selected by TRCR. \nPlease submit summary report.';
        } else if(profile == 'TX' || profile == 'System Administrator') {
            title = accountName + ' is requesting for approval.';
            body = 'Please kindly approve the counterparty registration.';
        }

        for (CTRCommitteeApproval__c commAppr : newCommApprs) {
            recipientsIds.add(commAppr.ApproverName__c);
        }
        
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             //WHERE DeveloperName='CTR_Notification'];CTRNotification
            WHERE DeveloperName='CTRNotification'];
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        
        notification.setTitle(title);
        notification.setBody(body);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        
        try {
            notification.send(recipientsIds);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }


    //input details that comes to apex from flow
    public class FlowInputs
    {
        @InvocableVariable
        public String recordId;
        
        @InvocableVariable
        public CTRRequestFormItem__c reqFormObj;
        
        @InvocableVariable
        public List<CTRCommitteeApproval__c> newCommApprs;
        
         @InvocableVariable
        public String uploadedList;
        
        @InvocableVariable
        public String templateType;
        
        @InvocableVariable
        public String profile;
    }

}