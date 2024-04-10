public without sharing class CTRDocumentChecklistController {

    // Get Document Checklist Information
    @AuraEnabled(cacheable=true)
    public static CTRRequestFormItem__c getDocChecklistInfo(String recordId, String templateType){
        
        CTRRequestFormItem__c reqFormItem = [SELECT CustomerAttachment__c, CTRRequestFormHeader__r.Email__c, CustomerEmailCC__c,CTRRequestFormHeader__r.Customer__r.CTRUser__c,
                                             CustomerSubject__c, CustomerMessage__c, RecordType.Name, Name, CTRRequestFormHeader__r.Customer__r.CTRUser__r.TemporaryLoginURL__c,
                                             SubBU__c,CTRRequestFormHeader__r.Country__r.Code__c,RecordType.DeveloperName,InterestedProductTypeAsSupplierTOP__c,isTRCR__c,Customer__r.Name
                                             ,CreditOwnerSectionHead__c,BusinessUnit__c, OwnerEmail__c, Owner.Name, CTRRequestFormHeader__r.FirstName__c, CTRRequestFormHeader__r.LastName__c
                                             FROM CTRRequestFormItem__c WHERE Id = :recordId];
        
        templateType = reqFormItem.BusinessUnit__c == 'TX' ? 'Request More Document TX':'Request More Document TOP';
        String queryStr = 'SELECT Subject__c, HTMLBody__c, Type__c FROM CTREmailTemplateMaster__c WHERE Type__c = \'' + templateType + '\' LIMIT 1';
        CTREmailTemplateMaster__c emailTemplate = Database.query(queryStr);
        
        if (String.isBlank(reqFormItem.CustomerMessage__c)) {
            reqFormItem.CustomerMessage__c = emailTemplate.HTMLBody__c
                .replace('{$AccountName$}', reqFormItem.Customer__r.Name)
                .replace('{$ContactFirstName$}', reqFormItem.CTRRequestFormHeader__r.FirstName__c)
                .replace('{$ContactLastName$}', reqFormItem.CTRRequestFormHeader__r.LastName__c)
                //.replace('{$RequestDocumentURL$}', reqFormItem.CTRRequestFormHeader__r.Customer__r?.CTRUser__r?.TemporaryLoginURL__c);
                .replace('{$RequestDocumentURL$}', '<a href="' + reqFormItem.CTRRequestFormHeader__r.Customer__r?.CTRUser__r?.TemporaryLoginURL__c + '/' + reqFormItem.CTRRequestFormHeader__r.Customer__c + '" target="_blank"><em>this link</em></a>');
             //.replace('{$RequestDocumentURL$}', '<a href="https://www.google.co.th" target="_blank">this link</a>');
            
        }
        reqFormItem.CustomerMessage__c = reqFormItem.CustomerMessage__c.replace('{$TraderName$}', reqFormItem.Owner.Name != null ? reqFormItem.Owner.Name : '');
        
        if (String.isBlank(reqFormItem.CustomerSubject__c)) {
            reqFormItem.CustomerSubject__c = emailTemplate.Subject__c
            .replace('{$AccountName$}', reqFormItem.Customer__r.Name).replace('{$SubBU$}',reqFormItem.SubBU__c);
        }
        reqFormItem.CustomerSubject__c = reqFormItem.CustomerSubject__c.replace('{$RecordType$}', reqFormItem.RecordType.Name != null ? reqFormItem.RecordType.Name : '');
        
        String Process = 'VerifyDocuments';
        String SalesOrg = reqFormItem.SubBU__c;
        String isDom = reqFormItem.CTRRequestFormHeader__r.Country__r.Code__c == 'TH' ? 'Domestic':'International';
        String RecordType = reqFormItem.RecordType.DeveloperName.contains('Customer') ? 'Customer':'Supplier';
        String Product = '';
        if(SalesOrg == 'TOP' && RecordType == 'Supplier' && reqFormItem.InterestedProductTypeAsSupplierTOP__c != null)
        {
            if(reqFormItem.InterestedProductTypeAsSupplierTOP__c.contains('Crude'))
            {
                Product = 'Crude';
            }
            
        }
        
        String isByTX = 'No';
        String VP = 'VP';
        String TRCR = 'Credit';
        Map<String,List<String>>actorMap = CTRRequestFormItemController.getActor(Process,SalesOrg,isDom,RecordType,Product,isByTX,'');           
        if(actorMap != null)
        {
            if(actorMap.get(TRCR) != null )
            {
                if(actorMap.get(TRCR).contains(UserInfo.getUserId()))
                {
                    reqFormItem.isTRCR__c = 'true';
                } 
            }
            
        }
        
        String BU = reqFormItem.BusinessUnit__c;
        Process = 'InformChangeInformation';
        String TRCRHead = 'CreditHead';
        Map<String,List<String>>trcrHeadMap = CTRRequestFormItemController.getActor(Process,SalesOrg,isDom,RecordType,Product,isByTX,'');
        if(trcrHeadMap != null)
        {
            if(trcrHeadMap.get(TRCRHead) != null )
            {
               reqFormItem.CreditOwnerSectionHead__c = trcrHeadMap.get(TRCRHead)[0];
            }
            
        }
        
        return reqFormItem;

    }

    // Save Document Checklist
    @AuraEnabled
    public static void saveDocChecklist(CTRRequestFormItem__c reqFormItem, List<CTRDocumentItem__c> docItemChecklist) {
        try {
            upsert docItemChecklist ExternalKey__c;
            update reqFormItem;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Update List Attachment
    @AuraEnabled
    public static void updateListFileName(String recordId, String uploadedFile){
        try {
            CTRRequestFormItem__c updReqIem = new CTRRequestFormItem__c();
            updReqIem.Id = recordId;
            updReqIem.CustomerAttachment__c = uploadedFile;
            update updReqIem;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Get List Uploaded File
    @AuraEnabled(cacheable=true)
    public static String getUploadedFileName(String recordId) {
        CTRRequestFormItem__c reqItem = [SELECT CustomerAttachment__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
        return reqItem.CustomerAttachment__c;
    }

    // Save Request Document
    @AuraEnabled
    public static void saveRequestDoc(CTRRequestFormItem__c reqFormItem, Boolean isSubmit, String uploadedList){
        try {
            reqFormItem.DocumentSubmittedDateTime__c = null;
            upsert reqFormItem;

            if (isSubmit) {
                String joinString = '';
                if(String.isNotBlank(uploadedList) && uploadedList != null)
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
                CTRRequestFormItemController.deleteAttachments(reqFormItem.Id, 'CustomerAttachment__c');
                CTRRequestFormItemController.CreatedNotiforHeroku(reqFormItem.Id);
            }
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Send Email
    public static void sendEmailWithAttachment(Id recordId, CTRRequestFormItem__c reqFormObj, String uploadedList) {

        CTRRequestFormItem__c reqForm = [SELECT CustomerMessage__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
        String RecordLink = URL.getOrgDomainUrl().toExternalForm() + '/' + recordId;
        // Set To and CC Email Address List
        List<String> toAddresses = new List<String>();
        
        if(reqFormObj.CustomerEmailTo__c != null && reqFormObj.CustomerEmailTo__c != '')
        {
            toAddresses = reqFormObj.CustomerEmailTo__c.split(',');
            for (Integer i = 0; i < toAddresses.size(); i++) {
                toAddresses[i] = toAddresses[i].replace('\\s', '').trim();
            }
        }

        List<String> ccAddresses = new List<String>();
        
        if(reqFormObj.CustomerEmailCC__c != null && reqFormObj.CustomerEmailCC__c != '')
        {
            ccAddresses = reqFormObj.CustomerEmailCC__c.split(',');
            for (Integer i = 0; i < ccAddresses.size(); i++) {
                ccAddresses[i] = ccAddresses[i].replace('\\s', '').trim();
            }
        }
        
        // Create an Email with Attachment
        Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[]{};

        if (String.isNotBlank(uploadedList) && uploadedList != null) {
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

        email.setToAddresses(toAddresses);
        email.setCcAddresses(ccAddresses);
        email.setWhatId(recordId);
        email.setSubject(reqFormObj.CustomerSubject__c);
        email.setHTMLBody(reqForm.CustomerMessage__c.replace('file.force.com', 'my.salesforce-sites.com').replace('{$RecordLink$}', '<a href="' + RecordLink + '" target="_blank">this link</a>'));
        email.setCharset('UTF-8');
        email.setSaveAsActivity(false);
        email.setFileAttachments(fileAttachments);

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
    public static String getCurrentUserProfileName() {
        return [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
    }
    
    @AuraEnabled(cacheable=true)
    public static CTRBuProfile__mdt getBUInfo(Id recordId)
    {
        try 
        {
            CTRBuProfile__mdt currentuserBU = CTRBuProfileController.checkBusinessUnitFromProfile(UserInfo.getUserId(),recordId);
            return currentuserBU;
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null;
        }
    }

    @AuraEnabled
    public static void sendFiletoHeroku(Id recordId,String uploadedList,CTRRequestFormItem__c reqFormItem) {
        System.debug('----recordId----'+recordId);

        if(uploadedList != null && uploadedList != '')
        {
            // Parse the JSON data
            List<Object> jsonList = (List<Object>) JSON.deserializeUntyped(uploadedList);
            
            // List to store Title values
            List<String> titleValues = new List<String>();
            // List to store ContentDocID values
            List<String> condocIdValues = new List<String>();
            
            // Iterate through the list to extract and add Title values to the list
            for (Object record : jsonList) {
                Map<String, Object> recordMap = (Map<String, Object>) record;
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
            
            CTRRequestFormItem__c reqattachment = [SELECT CustomerAttachment__c 
                                                   FROM CTRRequestFormItem__c 
                                                   WHERE Id = :recordId LIMIT 1];
            System.debug('reqattachment:'+reqattachment);
            reqattachment.CustomerAttachment__c = '';
            update reqattachment;
            
            //List<String> filenamesTemp = reqattachment.CustomerAttachment__c.split(',');
            //System.debug('filenamesTemp: '+filenamesTemp);
            
            
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId 
                                                       FROM ContentDocumentLink 
                                                       WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :titleValues ];
            Set<Id> mIdList = new Set<Id>();
            for(ContentDocumentLink mfile : documentLinks){
                mIdList.add(mfile.ContentDocumentId);
            }
            CTRSharPointFileController.UploadFileToSharePoint('/Account/SF-02076/Common/02 CTR/07 Other Registration Files',mIdList);
            // System.debug('reqFormItem: '+reqFormItem.Id);
            // CTRRequestFormItemController.deleteAttachments(reqFormItem.Id, 'CustomerAttachment__c');
            
            //Delete files
            List<ContentDocument > documents = [SELECT Id
                                                FROM ContentDocument  
                                                WHERE Id IN :condocIdValues ];
            System.debug('documents:'+documents);
            delete documents;
        }
        
    }

    @AuraEnabled
    public static List<CTRDocumentMaster__mdt> getMetaDocList(String businessUnit) {
        System.debug('Debug business unit '+businessUnit);
        return [SELECT SortOrder__c, DeveloperName, DocumentName__c, Question__c, IsRequired__c FROM CTRDocumentMaster__mdt WHERE BusinessUnit__c =: businessUnit AND IsActive__c = true ORDER BY SortOrder__c];
    }

    @AuraEnabled
    public static List<CTRDocumentItem__c> getDefaultDocChecklist(Id recordId, String businessUnit) {
        return [SELECT Id,ExternalKey__c, Result__c FROM CTRDocumentItem__c WHERE CTRRequestFormItem__c =: recordId AND BusinessUnit__c =: businessUnit];
    }
}