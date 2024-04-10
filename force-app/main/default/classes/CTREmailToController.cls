public without sharing class CTREmailToController {

    @AuraEnabled(cacheable=true)
    // public static String getRecordType(String recordId) {
    //     CTRRequestFormItem__c reqFormItem = [SELECT RecordType.Name FROM CTRRequestFormItem__c WHERE Id = :recordId];
    //     return reqFormItem.RecordType.Name;
    // }
    public static Map<String, String> getRecordType(String recordId) {
        List<CTRRequestFormItem__c> reqFormItem = [SELECT RecordType.Name, RecordType.DeveloperName, Status__c, Approval_Step__c, BusinessUnit__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
System.debug('test');
        Map<String, String> recordInfo  = new Map<String, String>();
            if (!reqFormItem.isEmpty()) {
                recordInfo.put('BusinessUnit', reqFormItem[0].BusinessUnit__c);
                recordInfo.put('RecordTypeName', reqFormItem[0].RecordType.Name);
                recordInfo.put('Status', reqFormItem[0].Status__c);
                recordInfo.put('ApprovalStep', reqFormItem[0].Approval_Step__c);
        }
        return recordInfo;
    }

    @AuraEnabled(cacheable=true)
    public static String getRecordTypeForLead(String recordId) {
        lead leadRecType = [SELECT RecordType.Name FROM lead  WHERE Id = :recordId];
        return leadRecType.RecordType.Name;
    }

    @AuraEnabled(cacheable=true)
    public static CTRRequestFormItem__c getEmailToInfo(String recordId, String templateType){
        
        CTRRequestFormItem__c reqFormItem = [SELECT Status__c, Approval_Step__c, EmailPageSubject__c, EmailPageMessage__c, CTRRequestFormHeader__r.Email__c,
                                                    EmailPageEmailTo__c, EmailPageEmailCC__c, EmailPageAttachment__c, Name, CTRRequestFormHeader__c,
                                                    CTRRequestFormHeader__r.CompanyNameENF__c, CTRRequestFormHeader__r.FirstName__c, CTRRequestFormHeader__r.LastName__c,
                                                    Customer__r.Name, InterestedProductTypeAsCustomerTOP__c, InterestedProductTypeAsCustomerTX__c, InterestedProductTypeAsSupplierTOP__c, InterestedProductTypeAsSupplierTX__c,
                                                    BusinessUnit__c, FinCrCond__c, FinPaymentCond__c, RecordType.Name, RecordType.DeveloperName, NotifyCustomAction__c
                                                    FROM CTRRequestFormItem__c WHERE Id = :recordId];
    try
    {     
        String queryStr = 'SELECT Subject__c, HTMLBody__c, Type__c FROM CTREmailTemplateMaster__c WHERE Type__c = \'' + templateType + '\' LIMIT 1';
        CTREmailTemplateMaster__c emailTemplate = Database.query(queryStr);
        
            String productName = '';
            String recordType = reqFormItem.RecordType.DeveloperName;
            String bu = reqFormItem.BusinessUnit__c;
            String creditcon = '';
            String payment = '';
            String RecordTypeName = reqFormItem.RecordType.Name.contains('Customer') ? 'Customer' : 'Supplier';

            if(reqFormItem.FinCrCond__c != null)
            {
                creditcon = reqFormItem.FinCrCond__c;
            }
            if( reqFormItem.FinPaymentCond__c != null)
            {
                payment =  reqFormItem.FinPaymentCond__c;
            }
            if(recordType.contains('Customer'))
            {
                productName = bu == 'TOP' || bu == 'LABIX' ? reqFormItem.InterestedProductTypeAsCustomerTOP__c : reqFormItem.InterestedProductTypeAsCustomerTX__c;
            }
            else
            {
                productName = bu == 'TOP' || bu == 'LABIX' ? reqFormItem.InterestedProductTypeAsSupplierTOP__c : reqFormItem.InterestedProductTypeAsSupplierTX__c;
            }

        if (String.isBlank(reqFormItem.EmailPageMessage__c)) {
            reqFormItem.EmailPageMessage__c = emailTemplate.HTMLBody__c.replace('{$AccountName$}', reqFormItem.Customer__r.Name).replace('{$ProductName$}', String.isnotBlank(productName) ? productName : '')
            .replace('{$FinalCreditCondition$}', creditcon).replace('{$FinalPaymentCondition$}', payment).replace('{$RecordType$}', RecordTypeName);
            //reqFormItem.EmailPageMessage__c = reqFormItem.EmailPageMessage__c.replace('{$CompanyName$}', reqFormItem.CTRRequestFormHeader__r.CompanyNameENF__c);
            //reqFormItem.EmailPageMessage__c = reqFormItem.EmailPageMessage__c.replace('{$ContactFirstName$}', reqFormItem.CTRRequestFormHeader__r.FirstName__c);
            //.EmailPageMessage__c = reqFormItem.EmailPageMessage__c.replace('{$ContactLastName$}', reqFormItem.CTRRequestFormHeader__r.LastName__c);

        }
        if (String.isBlank(reqFormItem.EmailPageSubject__c)) {
            reqFormItem.EmailPageSubject__c = emailTemplate.Subject__c.replace('{$AccountName$}', reqFormItem.Customer__r.Name);
            //reqFormItem.EmailPageSubject__c = reqFormItem.EmailPageSubject__c.replace('{$CompanyName$}', reqFormItem.CTRRequestFormHeader__r.CompanyNameENF__c);

        }
    }
    catch(Exception e)
    {
        system.debug('Email To==Error=='+e.getmessage()+' line:'+e.getLineNumber());
    }
        return reqFormItem;
    }

    @AuraEnabled(cacheable=true)
    public static lead getEmailToInfoForLead(String recordId, String templateType){
        String queryStr = 'SELECT Subject__c, HTMLBody__c, Type__c FROM CTREmailTemplateMaster__c WHERE Type__c = \'' + templateType + '\' LIMIT 1';
        CTREmailTemplateMaster__c emailTemplate = Database.query(queryStr);
        lead LeadMail = [SELECT EmailPageSubject__c, EmailPageMessage__c, Email,
                                                    EmailPageEmailTo__c, EmailPageEmailCC__c, EmailPageAttachment__c, Name
                                                    FROM lead WHERE Id = :recordId];
        
        if (String.isBlank(LeadMail.EmailPageMessage__c)) {
            LeadMail.EmailPageMessage__c = emailTemplate.HTMLBody__c.replace('{$AccountName$}', LeadMail.Name);
                        LeadMail.EmailPageMessage__c = LeadMail.EmailPageMessage__c.replace('{$RecordType$}', LeadMail.Name);

        }
        if (String.isBlank(LeadMail.EmailPageSubject__c)) {
            LeadMail.EmailPageSubject__c = emailTemplate.Subject__c.replace('{$AccountName$}', LeadMail.Name);
                        LeadMail.EmailPageSubject__c = LeadMail.EmailPageSubject__c.replace('{$RecordType$}', templateType);

        }

        return LeadMail;

    }

    @AuraEnabled
    public static void updateListFileName(String recordId, String uploadedFile){
        try {
            CTRRequestFormItem__c updReqIem = new CTRRequestFormItem__c();
            updReqIem.Id = recordId;
            updReqIem.EmailPageAttachment__c = uploadedFile;
            update updReqIem;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void updateListFileNameFroLead(String recordId, String uploadedFile){
        try {
            lead UpdateLead = new lead();
            UpdateLead.Id = recordId;
            UpdateLead.EmailPageAttachment__c = uploadedFile;
            update UpdateLead;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getUploadedFileName(String recordId) {
        CTRRequestFormItem__c reqItem = [SELECT EmailPageAttachment__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
        return reqItem.EmailPageAttachment__c;
    }
    @AuraEnabled(cacheable=true)
    public static String getUploadedFileNameForLead(String recordId) {
        Lead LeadAtt = [SELECT EmailPageAttachment__c FROM Lead WHERE Id = :recordId];
        return LeadAtt.EmailPageAttachment__c;
    }

    @AuraEnabled
    public static void saveEmailTo(CTRRequestFormItem__c reqFormItem, Boolean isSubmit, String uploadedList,String recordId){
        try {
            System.debug('reqFormItem: ' + reqFormItem);
            System.debug('isSubmit: ' + isSubmit);
            update reqFormItem;

            if (isSubmit) {
                setInitialPasswordSecret(reqFormItem.Id);

                CTRRequestFormItem__c getReqFormItem = [SELECT Id, BusinessUnit__c, RecordType.DeveloperName, NotifyCustomAction__c
                                                    FROM CTRRequestFormItem__c WHERE Id = :reqFormItem.Id];

                reqFormItem.SubmittedTraderSendEmail__c = true;
                reqFormItem.Approval_Step__c = 'Inform Counterparty';
                System.debug('Debug send email '+getReqFormItem.BusinessUnit__c+':'+getReqFormItem.RecordType.DeveloperName);
                if(getReqFormItem.BusinessUnit__c == 'TX') {
                    if(getReqFormItem.RecordType.DeveloperName.contains('Customer')) {
                        reqFormItem.NotifyCustomAction__c = 'Emailed to Customer';
                    } else if(getReqFormItem.RecordType.DeveloperName.contains('Supplier')) {
                        reqFormItem.NotifyCustomAction__c = 'Emailed to Supplier';
                    }
                }
                update reqFormItem;
                System.debug('reqFormItem.SubmittedTraderSendEmail__c: ' + reqFormItem.SubmittedTraderSendEmail__c);
                sendEmailWithAttachment(reqFormItem.Id, reqFormItem, uploadedList);
                CTRRequestFormItemController.deleteAttachments(reqFormItem.Id, 'EmailPageAttachment__c');
                // sendFiletoHeroku(recordId, uploadedList);
            }
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void saveEmailToForLead(Lead LeadRec, Boolean isSubmit, String uploadedList,String recordId){
        try {
            System.debug('LeadRec: ' + LeadRec);
            System.debug('isSubmit: ' + isSubmit);
            update LeadRec;
            System.debug('done update: ');
            if (isSubmit) {
                sendEmailWithAttachmentForLead(LeadRec.Id, LeadRec, uploadedList);
                // sendFiletoHeroku(recordId, uploadedList);
            }
            System.debug('done submit: ');
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void sendEmailWithAttachment(Id recordId, CTRRequestFormItem__c reqFormObj, String uploadedList) {

        CTRRequestFormItem__c reqForm = [SELECT Id, BusinessUnit__c, EmailPageMessage__c, RecordType.DeveloperName, NotifyCustomAction__c FROM CTRRequestFormItem__c WHERE Id = :recordId];

        List<String> toAddresses = new List<String>();
        if(reqFormObj.EmailPageEmailTo__c != null && reqFormObj.EmailPageEmailTo__c != '')
        {
            toAddresses = reqFormObj.EmailPageEmailTo__c.split(',');
            for (Integer i = 0; i < toAddresses.size(); i++) {
                toAddresses[i] = toAddresses[i].replace('\\s', '').trim();
            }
        }
        
        List<String> ccAddresses = new List<String>();
        if(reqFormObj.EmailPageEmailCC__c != null && reqFormObj.EmailPageEmailCC__c != '')
        {
            ccAddresses = reqFormObj.EmailPageEmailCC__c.split(',');
            for (Integer i = 0; i < ccAddresses.size(); i++) {
                ccAddresses[i] = ccAddresses[i].replace('\\s', '').trim();
            }
        }
        
        // Create an Email with Attachment
        Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[]{};

        if (String.isNotBlank(uploadedList)) {
            List<String> filenames = uploadedList.split(',');

            List<Attachment> attachments = [SELECT Id, Name, Body, ContentType FROM Attachment WHERE ParentId = :recordId];
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
    
        // Create an Email Message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setToAddresses(toAddresses);
        email.setCcAddresses(ccAddresses);
        email.setWhatId(recordId);
        email.setSubject(reqFormObj.EmailPageSubject__c);
        system.debug('reqForm---'+reqForm.EmailPageMessage__c);
        system.debug('reqForm-2--'+reqForm.EmailPageMessage__c.replace('file.force.com', 'my.salesforce-sites.com'));
        email.setHTMLBody(reqForm.EmailPageMessage__c.replace('file.force.com', 'my.salesforce-sites.com'));
        email.setSaveAsActivity(false);
        email.setFileAttachments(fileAttachments);
        email.setCharset('UTF-8');

        // Send the email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});

        if (results[0].isSuccess()) {
            System.debug('Email sent successfully');
        } else {
            System.debug('Email failed to send' + '. Errors: ' + results[0].getErrors()[0].getMessage());
        }
    }
    public static void sendEmailWithAttachmentForLead(Id recordId, Lead LeadRec, String uploadedList) {
        try{
        Lead LeadMessage = [SELECT EmailPageMessage__c FROM Lead WHERE Id = :recordId];
    
        // Set To and CC Email Address List
        String[] toAddresses = LeadRec.EmailPageEmailTo__c.split(',');
        for (Integer i = 0; i < toAddresses.size(); i++) {
            toAddresses[i] = toAddresses[i].replace('\\s', '').trim();
        }
        
        String[] ccAddresses = new list <string>();  
            system.debug('ccAddresses '+ccAddresses);
            if(LeadRec.EmailPageEmailCC__c != null && LeadRec.EmailPageEmailCC__c != '' && LeadRec.EmailPageEmailCC__c != '[]'){
                ccAddresses = LeadRec.EmailPageEmailCC__c.split(',');
            }
        for (Integer i = 0; i < ccAddresses.size(); i++) {
            ccAddresses[i] = ccAddresses[i].replace('\\s', '').trim();
        }
        
        // Create an Email with Attachment
        Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[]{};

        if (String.isNotBlank(uploadedList)) {
            List<String> filenames = uploadedList.split(',');
            system.debug('filenames : '+filenames);
            List<Attachment> attachments = [SELECT Id, Name, Body, ContentType FROM Attachment WHERE ParentId = :recordId];
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId 
                                                            FROM ContentDocumentLink 
                                                            WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :filenames];
            system.debug('documentLinks size : '+documentLinks.size());
            Map<Id, ContentVersion> contentVersionMap = new Map<Id, ContentVersion>();
    
            Set<Id> contentVersionIds = new Set<Id>();
            for (ContentDocumentLink documentLink : documentLinks) {
                contentVersionIds.add(documentLink.ContentDocument.LatestPublishedVersionId);
            }
    
            Map<Id, ContentVersion> contentVersions = new Map<Id, ContentVersion>([SELECT Id, Title, VersionData FROM ContentVersion WHERE Id IN :contentVersionIds]);
            system.debug('contentVersions size : '+contentVersions.size());
            if (!documentLinks.isEmpty()) {
                for (ContentDocumentLink documentLink : documentLinks) {
                    ContentVersion file = contentVersions.get(documentLink.ContentDocument.LatestPublishedVersionId);
    
                    Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
                    fileAttachment.setFileName(file.Title);
                    fileAttachment.setBody(file.VersionData);
    
                    fileAttachments.add(fileAttachment);
                }
                system.debug('fileAttachments size in if : '+fileAttachments.size());
            }
            system.debug('fileAttachments size : '+fileAttachments.size());
        }
    
        // Create an Email Message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    
        system.debug('toAddresses '+toAddresses);
        system.debug('ccAddresses '+ccAddresses);
        email.setToAddresses(toAddresses);
        email.setCcAddresses(ccAddresses);
        email.setWhatId(recordId);
        email.setSubject(LeadRec.EmailPageSubject__c);
            
        email.setHTMLBody(LeadMessage.EmailPageMessage__c.replace('file.force.com', 'my.salesforce-sites.com'));
        email.setSaveAsActivity(false);
        email.setFileAttachments(fileAttachments);
        email.setCharset('UTF-8');

        // Send the email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});

        if (results[0].isSuccess()) {
            System.debug('Email sent successfully');
        } else {
            System.debug('Email failed to send' + '. Errors: ' + results[0].getErrors()[0].getMessage());
        }
            
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    @AuraEnabled(cacheable=true)
    public static String getCurrentUserProfileName() {
        return [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
    }

    // // @future(callout=true)
    // @AuraEnabled
    // public static void sendFiletoHeroku(Id recordId,String uploadedList) {
    //     System.debug('----recordId----'+recordId);

    //     List<String> filenames = uploadedList.split(',');

    //     List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId 
    //     FROM ContentDocumentLink 
    //     WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :filenames];
    //     Set<Id> mIdList = new Set<Id>();
    //     for(ContentDocumentLink mfile : documentLinks){
    //         mIdList.add(mfile.ContentDocumentId);
    //     }
    //     CTRSharPointFileController.UploadFileToSharePoint('/Account/SF-02076/Common/02 CTR/07 Other Registration Files',mIdList);
    //     //CTRSharPointFileController.sharepointMetadata(recordId,mIdList);
    // }
    @AuraEnabled
    public static void sendFiletoHeroku(Id recordId,String uploadedList) {
        System.debug('----recordId----'+recordId);
        // Parse the JSON data
        List<Object> jsonList = (List<Object>) JSON.deserializeUntyped(uploadedList);

        // List to store Title values
        List<String> titleValues = new List<String>();

        // Iterate through the list to extract and add Title values to the list
        for (Object record : jsonList) {
            Map<String, Object> recordMap = (Map<String, Object>) record;
            String titleValue = (String) recordMap.get('Title');
            
            // Remove file extension (assuming extension is everything after the last dot)
            Integer lastDotIndex = titleValue.lastIndexOf('.');
            if (lastDotIndex > 0) {
                titleValue = titleValue.substring(0, lastDotIndex);
            }

            // Add the title value to the list
            titleValues.add(titleValue);
        }
        System.debug('titleValues'+titleValues);


        // List<String> filenames = uploadedList.split(',');
        // System.debug('filenames: '+filenames);

        CTRRequestFormItem__c reqattachment = [SELECT EmailPageAttachment__c 
        FROM CTRRequestFormItem__c 
        WHERE Id = :recordId LIMIT 1];
        System.debug('reqattachment:'+reqattachment);
        reqattachment.EmailPageAttachment__c = '';
        update reqattachment;

        // List<String> filenamesTemp = reqattachment.EmailPageAttachment__c.split(',');
        // System.debug('filenamesTemp: '+filenamesTemp);

        
        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId 
        FROM ContentDocumentLink 
        WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :titleValues ];
        Set<Id> mIdList = new Set<Id>();
        for(ContentDocumentLink mfile : documentLinks){
            mIdList.add(mfile.ContentDocumentId);
        }
        CTRSharPointFileController.UploadFileToSharePoint('/Account/SF-02076/Common/02 CTR/07 Other Registration Files',mIdList);
        //CTRSharPointFileController.sharepointMetadata(recordId,mIdList);
    }

    private static void setInitialPasswordSecret(Id recordId) {
        CTRRequestFormItem__c rqit = [SELECT CTRRequestFormHeader__r.Customer__r.CTRUser__r.Id FROM CTRRequestFormItem__c WHERE Id = :recordId];
        if (rqit.CTRRequestFormHeader__r?.Customer__r?.CTRUser__r?.Id != null) {
            CTRUser__c usr = new CTRUser__c();
            usr.Id = rqit.CTRRequestFormHeader__r.Customer__r.CTRUser__r.Id;
            usr.InitialPasswordSecret__c = EncodingUtil.base64Encode(Blob.valueOf(usr.Id + '.' + Datetime.now().format('yyyy-MM-dd')));
            update usr;
        }
    }
}