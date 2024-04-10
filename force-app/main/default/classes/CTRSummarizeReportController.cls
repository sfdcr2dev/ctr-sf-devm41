public without sharing class CTRSummarizeReportController {

    @AuraEnabled(cacheable=true)
    public static CTRRequestFormItem__c getSummarizeReportInfo(String recordId, String templateType){
        CTRRequestFormItem__c reqFormItem = [SELECT Id, Approval_Step__c, NotifyCustomAction__c, SummarizeReportReassign__c, SummarizeReportSubject__c, SummarizeReportMessage__c, Name, CTRRequestFormHeader__r.Email__c,
                                                 SummarizeReportEmailTo__c, SummarizeReportEmailCC__c, SummarizeReportAttachment__c, OwnersSectionHead__r.Email, OwnersCMVP__r.Email, 
                                                 OwnerId, Owner.Email, RecordType.Name, RecordType.DeveloperName, CommitteeOwner__c, CommitteeOwner__r.Email,CreditOwner__c, CreditOwner__r.Email,CreditOwnerSectionHead__c,IsTRCR__c, fmlAccountTypeName__c
                                                 ,FinCrCond__c,FinPaymentCond__c,InterestedProductTypeAsCustomerTOP__c,InterestedProductTypeAsCustomerTX__c,InterestedProductTypeAsSupplierTOP__c,InterestedProductTypeAsSupplierTX__c
                                                 ,BusinessUnit__c,Customer__r.Name, fmlPositionNameOfVP__c
                                                 FROM CTRRequestFormItem__c WHERE Id = :recordId];
        try
        {
            String queryStr = 'SELECT Subject__c, HTMLBody__c, Type__c FROM CTREmailTemplateMaster__c WHERE Type__c = \'' + templateType + '\' LIMIT 1';
            CTREmailTemplateMaster__c emailTemplate = Database.query(queryStr);
            
            system.debug ('emailTemplate : ' + emailTemplate);
            
            String productName = '';
            String recordType = reqFormItem.RecordType.DeveloperName;
            String bu = reqFormItem.BusinessUnit__c;
            String creditcon = '';
            String payment = '';
            String RecordLink = URL.getOrgDomainUrl().toExternalForm() + '/' + reqFormItem.Id;

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
            
            
            if (String.isBlank(reqFormItem.SummarizeReportMessage__c)) {
                
                reqFormItem.SummarizeReportMessage__c = emailTemplate.HTMLBody__c.replace('{$AccountName$}', reqFormItem.Customer__r.Name).replace('{$ProductName$}', String.isnotBlank(productName) ? productName : '')
                .replace('{$Credit_Condition$}', creditcon).replace('{$PaymentCondition$}', payment).replace('{$RecordType$}', RecordTypeName).replace('{$PositionNameOfVP$}', reqFormItem.fmlPositionNameOfVP__c);
                
            }
            if (String.isBlank(reqFormItem.SummarizeReportSubject__c)) {
                reqFormItem.SummarizeReportSubject__c = emailTemplate.Subject__c.replace('{$RecordType$}', RecordTypeName).replace('{$AccountName$}', reqFormItem.Customer__r.Name).replace('{$BU$}', reqFormItem.BusinessUnit__c);
            }
            if(reqFormItem.CreditOwnerSectionHead__c == UserInfo.getUserId())
            {
                reqFormItem.IsTRCR__c = 'true';
            }
            
            
        }
        catch(Exception e)
        {
            system.debug('Summary Report==Error=='+e.getmessage()+' line:'+e.getLineNumber());
        }
        return reqFormItem;

    }

    // Update List Attachment
    @AuraEnabled
    public static void updateListFileName(String recordId, String uploadedFile){
        try {
            CTRRequestFormItem__c updReqIem = new CTRRequestFormItem__c();
            updReqIem.Id = recordId;
            updReqIem.SummarizeReportAttachment__c = uploadedFile;
            update updReqIem;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Get List Uploaded File
    @AuraEnabled(cacheable=true)
    public static String getUploadedFileName(String recordId) {
        CTRRequestFormItem__c reqItem = [SELECT SummarizeReportAttachment__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
        return reqItem.SummarizeReportAttachment__c;
    }

    // Save Request Document
    @AuraEnabled
    public static void saveSummarizeReport(CTRRequestFormItem__c reqFormItem, Boolean isSubmit, String uploadedList,String recordId){
        try {
            System.debug(reqFormItem.SummarizeReportAttachment__c);
            System.debug(uploadedList);

            if (isSubmit) {
                reqFormItem.Approval_Step__c = 'Summary Report';
            }

            update reqFormItem;
            if (isSubmit) {
                String joinString = '';
                if(String.isNotBlank(uploadedList))
                {
                    List<Object> input = (List<Object>)JSON.deserializeUntyped(uploadedList);
                    Set<String> filenames = new Set<String>();
                    for (Object o : input) {
                        System.debug((Map<String, Object>)o);
                        map<String,Object>a = (Map<String, Object>)o;
                        System.debug(a.get('Title'));
                        String temp = String.valueof(a.get('Title'));
                        System.debug('temp---'+temp);
                        List<String>fileName = temp.split('\\.');
                        System.debug(fileName);
                        filenames.add(fileName[0]);
                        
                    }
                    joinString = String.join(filenames,',');
                    system.debug('joinString===='+joinString);
                }
                sendEmailWithAttachment(reqFormItem.Id, reqFormItem, joinString);
                sendEmailWithAttachmentToTrader(reqFormItem.Id, reqFormItem, joinString);
                //CTRRequestFormItemController.deleteAttachments(reqFormItem.Id, 'SummarizeReportAttachment__c');
                //sendFiletoHeroku(recordId, uploadedList);
            }
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Send Email
    public static void sendEmailWithAttachment(Id recordId, CTRRequestFormItem__c reqFormObj, String uploadedList) {

        CTRRequestFormItem__c reqForm = [SELECT SummarizeReportMessage__c FROM CTRRequestFormItem__c WHERE Id = :recordId];

        // Set To and CC Email Address List
        List<String> toAddresses = new List<String>();
        if(reqFormObj.SummarizeReportEmailTo__c != null && reqFormObj.SummarizeReportEmailTo__c != '')
        {
            toAddresses = reqFormObj.SummarizeReportEmailTo__c.split(',');
            for (Integer i = 0; i < toAddresses.size(); i++) {
                toAddresses[i] = toAddresses[i].replace('\\s', '').trim();
            }
        }


        List<String> ccAddresses = new List<String>();
        if(reqFormObj.SummarizeReportEmailCC__c != null && reqFormObj.SummarizeReportEmailCC__c != '')
        {
            ccAddresses = reqFormObj.SummarizeReportEmailCC__c.split(',');
            for (Integer i = 0; i < ccAddresses.size(); i++) {
                ccAddresses[i] = ccAddresses[i].replace('\\s', '').trim();
            }
        }
        
        // Create an Email with Attachment
        Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[]{};
            
            if (String.isNotBlank(uploadedList))
            {
            
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

            Map<Id, ContentVersion> contentVersions = new Map<Id, ContentVersion>([SELECT Id, Title, VersionData,FileExtension FROM ContentVersion WHERE Id IN :contentVersionIds]);

            if (!documentLinks.isEmpty()) {
                for (ContentDocumentLink documentLink : documentLinks) {
                    ContentVersion file = contentVersions.get(documentLink.ContentDocument.LatestPublishedVersionId);

                    Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
                    fileAttachment.setFileName(file.Title+'.'+file.FileExtension);
                    fileAttachment.setBody(file.VersionData);

                    fileAttachments.add(fileAttachment);
                }
            }
        }

        // Create an Email Message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        String RecordLink = URL.getOrgDomainUrl().toExternalForm() + '/' + reqFormObj.Id;

        email.setToAddresses(toAddresses);
        email.setCcAddresses(ccAddresses);
        email.setWhatId(recordId);
        email.setSubject(reqFormObj.SummarizeReportSubject__c);
        email.setHTMLBody(reqForm.SummarizeReportMessage__c.replace('file.force.com', 'my.salesforce-sites.com').replace('{$RecordLink$}', '<a href="' + RecordLink + '" target="_blank">this link</a>'));
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

    // Send Email to Trader
    public static void sendEmailWithAttachmentToTrader(Id recordId, CTRRequestFormItem__c reqFormObj, String uploadedList) {
        CTRRequestFormItem__c reqForm = [SELECT SummarizeReportMessage__c, Owner.Email FROM CTRRequestFormItem__c WHERE Id = :recordId];

        // Set To and CC Email Address List
        List<String> toAddresses = new List<String>();
        if(reqForm.Owner.Email != null && reqForm.Owner.Email != '') {
            toAddresses = reqForm.Owner.Email.split(',');
            for (Integer i = 0; i < toAddresses.size(); i++) {
                toAddresses[i] = toAddresses[i].replace('\\s', '').trim();
            }
        }

        if(Test.isRunningTest() && toAddresses.size() == 0){
            toAddresses.add('testEmail@email.com');
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

            Map<Id, ContentVersion> contentVersions = new Map<Id, ContentVersion>([SELECT Id, Title, VersionData,FileExtension FROM ContentVersion WHERE Id IN :contentVersionIds]);

            if (!documentLinks.isEmpty()) {
                for (ContentDocumentLink documentLink : documentLinks) {
                    ContentVersion file = contentVersions.get(documentLink.ContentDocument.LatestPublishedVersionId);

                    Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
                    fileAttachment.setFileName(file.Title+'.'+file.FileExtension);
                    fileAttachment.setBody(file.VersionData);

                    fileAttachments.add(fileAttachment);
                }
            }
        }

        // Create an Email Message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        String RecordLink = URL.getOrgDomainUrl().toExternalForm() + '/' + reqFormObj.Id;

        email.setToAddresses(toAddresses);
        email.setWhatId(recordId);
        email.setSubject(reqFormObj.SummarizeReportSubject__c.replace('FYI', 'FYA'));
        email.setHTMLBody(reqForm.SummarizeReportMessage__c.replace('file.force.com', 'my.salesforce-sites.com').replace('{$RecordLink$}', '<a href="' + RecordLink + '" target="_blank">this link</a>'));
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

    // Get Current User Profile
    @AuraEnabled(cacheable=true)
    // public static String getCurrentUserProfileName(String recID) {
    //     List<CTRRequestFormItem__c>itemList =  [SELECT BusinessUnit__c FROM CTRRequestFormItem__c WHERE id =: recID];
    //     return itemList[0].BusinessUnit__c;
    // }
        public static Map<String, String> getCurrentUserProfileName(String recID) {
            List<CTRRequestFormItem__c> itemList = [SELECT BusinessUnit__c, Approval_Step__c FROM CTRRequestFormItem__c WHERE Id = :recID LIMIT 1];

            Map<String, String> profileInfo = new Map<String, String>();
                if (!itemList.isEmpty()) {
                    profileInfo.put('BusinessUnit', itemList[0].BusinessUnit__c);
                    profileInfo.put('ApprovalStep', itemList[0].Approval_Step__c);
            }
    return profileInfo;
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
        System.debug('----uploadedList----'+uploadedList);

            // // Parse the JSON data
            // List<Object> jsonList = (List<Object>) JSON.deserializeUntyped(uploadedList);
            // System.debug('jsonList'+jsonList);

            // // List to store Title values
            // List<String> titleValues = new List<String>();

            // // Iterate through the list to extract and add Title values to the list
            // for (List<Object> record : jsonList) {
            //     String titleValue = (String) record.get('Title');
                
            //     // Add the title value to the list
            //     titleValues.add(titleValue);
            // }

            // // Print or use the title values as needed
            // System.debug('Title Values: ' + titleValues);

        // Parse the JSON data
        List<Object> jsonList = (List<Object>) JSON.deserializeUntyped(uploadedList);

        // List to store Title values
        List<String> titleValues = new List<String>();
        // List to store ContentDocID values
        List<String> condocIdValues = new List<String>();

        // Iterate through the list to extract and add Title values to the list
        for (Object record : jsonList) {
            Map<String, Object> recordMap = (Map<String, Object>) record;
            // Map<String, Object> recordIdMap = (Map<String, Object>) record;
            String titleValue = (String) recordMap.get('Title');
            String condocIdValue = (Boolean)recordMap.get('IsSaved') ? (String) recordMap.get('Id') : null;
            
            // Remove file extension (assuming extension is everything after the last dot)
            Integer lastDotIndex = titleValue.lastIndexOf('.');
            if (lastDotIndex > 0) {
                titleValue = titleValue.substring(0, lastDotIndex);
            }

            // Add the title value to the list
            titleValues.add(titleValue);
            // Add the id value to the list
            condocIdValues.add(condocIdValue);
        }
        System.debug('titleValues'+titleValues);
        System.debug('condocIdValues'+condocIdValues);


        // List<String> filenames = uploadedList.split(',');
        // System.debug('filenames: '+filenames);

        CTRRequestFormItem__c reqattachment = [SELECT SummarizeReportAttachment__c 
        FROM CTRRequestFormItem__c 
        WHERE Id = :recordId LIMIT 1];
        System.debug('reqattachment:'+reqattachment);
        reqattachment.SummarizeReportAttachment__c = '';
        update reqattachment;

        //List<String> filenamesTemp = reqattachment.SummarizeReportAttachment__c.split(',');
        //System.debug('filenamesTemp: '+filenamesTemp);

        
        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId 
        FROM ContentDocumentLink 
        WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :titleValues ];
        Set<Id> mIdList = new Set<Id>();
        for(ContentDocumentLink mfile : documentLinks){
            mIdList.add(mfile.ContentDocumentId);
        }
        List<String> sharepointPath = CTRSharePointLinkController.getSharepointPath(recordId,'05');
        System.debug('--sharepointPath--'+sharepointPath);
        if(sharepointPath.size() > 0)
        {
            CTRSharPointFileController.UploadFileToSharePoint(sharepointPath[0],mIdList);
        }

        //Delete files
        List<ContentDocument > documents = [SELECT Id
        FROM ContentDocument  
        WHERE Id IN :condocIdValues ];
        System.debug('documents:'+documents);
        delete documents;

    }
    
}

// // Your JSON data
// String jsonData = '[{"Id":"0691m000003OJTMAA4","Title":"test sum rep 3.txt","IsSaved":true},{"Id":"0691m000003OJTWAA4","Title":"test sum rep 1.txt","IsSaved":false}]';

// // // Parse the JSON data
// // List<Map<String, String>> jsonList = (List<Map<String, String>>) JSON.deserializeUntyped(jsonData);
// // System.debug('jsonList'+jsonList);

// // Parse the JSON data
// List<Object> jsonList = (List<Object>) JSON.deserializeUntyped(jsonData);
// System.debug('jsonList'+jsonList);