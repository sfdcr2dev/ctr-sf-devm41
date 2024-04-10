public without sharing class CTRCommitteeSelection2Controller {

    @AuraEnabled(cacheable=true)
    public static List<CommitteeGroup> getGroupedCommittees() {
        Map<String, CommitteeGroup> groupedCommitteesMap = new Map<String, CommitteeGroup>();

        List<CTRCommittee__mdt> committees = [
            SELECT Id, Label, DeveloperName, Parent__c, Name__c, Email__c, CreditRating__c, BU__c, TOP__c, TPX__c, TLB__c, LABIX__c, TXTH__c, TSV__c, JSKem__c, TSR__c, TXIndia__c
            FROM CTRCommittee__mdt];

        // Add mockup records
        // CTRCommittee__mdt newCommittee1 = new CTRCommittee__mdt(
        //  Id = 'm0F1m0000004b1TEST',
        //  Label = 'Committee - TEST',
        //  DeveloperName = 'CommitteeTESTwuttisak',
        //  Parent__c = 'TEST',
        //  Name__c = 'Amornrat Outsource',
        //  Email__c = 'kridsada.ta@b3tech.co.th'
        // );
        // committees.add(newCommittee1);

        // CTRCommittee__mdt newCommittee2 = new CTRCommittee__mdt(
        //  Id = 'm0F1m0000004b2TEST',
        //  Label = 'Committee - TEST',
        //  DeveloperName = 'CommitteeTESTwutti',
        //  Parent__c = 'TEST',
        //  Name__c = 'B3 Outsource',
        //  Email__c = 'wuttisak.ku@b3tech.co.th'
        // );
        // committees.add(newCommittee2);

        // CTRCommittee__mdt newCommittee3 = new CTRCommittee__mdt(
        //     Id = 'm0F1m0000004b3TEST',
        //     Label = 'Committee - TEST',
        //     DeveloperName = 'CommitteeTESTmoke',
        //     Parent__c = 'TEST',
        //     Name__c = 'Moke Krisnangkura',
        //     Email__c = 'moke.k@roundtwosolutions.com'
        // );
        // committees.add(newCommittee3);

        // Group the committees by Parent__c
        for (CTRCommittee__mdt committee : committees) {
            String parentKey = committee.Parent__c;
            if (!groupedCommitteesMap.containsKey(parentKey)) {
                CommitteeGroup committeeGroup = new CommitteeGroup(parentKey);
                groupedCommitteesMap.put(parentKey, committeeGroup);
            }

            groupedCommitteesMap.get(parentKey).committees.add(committee);
        }

         groupedCommitteesMap.keySet().removeAll(getGroupedWithoutName(groupedCommitteesMap));
        List<CommitteeGroup> groupedCommittees = new List<CommitteeGroup>(groupedCommitteesMap.values());
        groupedCommittees.sort();

        return groupedCommittees;
    }

    public class CommitteeGroup implements Comparable {
        @AuraEnabled
        public String parent { get; set; }

        @AuraEnabled
        public List<CTRCommittee__mdt> committees { get; set; }

        public CommitteeGroup(String parentKey) {
            this.parent = parentKey;
            this.committees = new List<CTRCommittee__mdt>();
        }

        public Integer compareTo(Object compareTo) {
            CommitteeGroup compareToCommittee = (CommitteeGroup)compareTo;
            return parent.compareTo(compareToCommittee.parent);
        }
    }

    public static Set<String> getGroupedWithoutName(Map<String, CommitteeGroup> groupedCommitteesMap) {
        Set<String> parentsWithoutChild = new Set<String>();
        for (CommitteeGroup committeeGroup : groupedCommitteesMap.values()) {
            System.debug('committeeGroup.committees: ' + committeeGroup.committees);
            for (CTRCommittee__mdt committee : committeeGroup.committees) {
                if (String.isBlank(committee.Name__c) || String.isBlank(committee.Email__c)) {
                    parentsWithoutChild.add(committeeGroup.parent);
                }
            }
        }
        return parentsWithoutChild;
    }

    @AuraEnabled
    public static CTRRequestFormItem__c getCommitteeInfo(String recordId, String templateType){
        String queryStr = 'SELECT Subject__c, HTMLBody__c, Type__c FROM CTREmailTemplateMaster__c WHERE Type__c = \'' + templateType + '\' LIMIT 1';
        system.debug ('queryStr: '+queryStr);
        if (String.isNotBlank(recordId)) {
            CTREmailTemplateMaster__c emailTemplate = Database.query(queryStr);
            CTRRequestFormItem__c reqFormItem = [
                SELECT
                    Id, SubBU__c, EmailUrgent__c, EmailTo__c, EmailCC__c, AmountOpenedCredit__c, AmountDCLCondition__c, AmountBuyTrade__c, AmountCreditTerm__c,
                    Subject__c, Message__c, Owner__c, Owner__r.Name, CommitteeName__c, RecordType.Name, CommitteeReassign__c,
                    CommitteeEmail__c, CommitteeAttachment__c, BuyTradeDCLCondition__c, Name, AmountBankGuarantee__c,
                    BuyTradeEndorsement__c, HavingCollateral__c, CashOnDelivery__c, HavingOpenedCredit__c, Currency__c, OtherCondition__c,
                    Product__c, InternalCreditRating__c, InternalCreditRatingTOP__c, InterestedProductTypeAsCustomer__c, InterestedProductTypeAsSupplier__c,
                    InterestedProductTypeAsCustomerTOP__c, InterestedProductTypeAsSupplierTOP__c, InterestedProductTypeAsCustomerTX__c, InterestedProductTypeAsSupplierTX__c,
                    PurchasingOrganizationTX__c, SalesOrganizationTX__c, CTRRequestFormHeader__r.Customer__r.Name, CTRRequestFormHeader__r.Customer__c,
                    CommitteeStatus__c, Status__c, Approval_Step__c, CMVPPreScreenDecision__c, OwnersCMVP__c, Country__r.Code__c,
                    FinCrCond__c, FinPaymentCond__c, FinIntCrRating__c, FinOtherCondition__c, ApprovalTrader_CreditRating__c, TraderWaive__c, Approval_SHAgree__c, Approval_VPAgree__c,
                    CTRRequestFormHeader__r.FirstName__c, CTRRequestFormHeader__r.LastName__c, CTRRequestFormHeader__r.Email__c, CTRRequestFormHeader__r.MobilePhone__c,
                    FinAmountBankGuarantee__c,FinAmountCreditTerm__c,FinAmountDCLCondition__c,FinAmountBuyTrade__c,FinAmountOpenedCredit__c,
                    FinBuyTradeDCLCondition__c,FinBuyTradeEndorsement__c,FinCashOnDelivery__c,FinHavingCollateral__c,FinHavingCreditTermOrLetter__c,FinHavingOpenedCredit__c,FinTotalSecuredCurrency__c
                FROM CTRRequestFormItem__c
                WHERE Id = :recordId];
            
            if (String.isBlank(reqFormItem.Message__c)) 
            {
                String msg =  emailTemplate.HTMLBody__c;
                if (reqFormItem.RecordType.Name.contains('Customer')) {
                    msg = msg
                        .replace('{$RecordType$}', 'Customer')
                        // .replace('{$CommitteeName$}', (reqFormItem.CommitteeName__c != null) ? reqFormItem.CommitteeName__c : '')
                        .replace('{$SubBU$}', reqFormItem.SubBU__c)
                        .replace('{$AccountName$}', (reqFormItem.CTRRequestFormHeader__r.Customer__c != null) ? reqFormItem.CTRRequestFormHeader__r.Customer__r.Name : '');
                        // .replace('{$FinalCreditCondition$}', (reqFormItem.FinCrCond__c != null) ? reqFormItem.FinCrCond__c : '')
                        // .replace('{$FinalPaymentCondition$}', (reqFormItem?.FinPaymentCond__c != null) ? reqFormItem?.FinPaymentCond__c : '')
                        // .replace('{$RequestFormLink$}', reqFormItem.Id);
                } 
                else if (reqFormItem.RecordType.Name.contains('Supplier')) 
                {
                    msg = msg.replace('{$RecordType$}', 'Supplier');     
                    // msg = msg.replace('{$CommitteeName$}', (reqFormItem.CommitteeName__c != null) ? reqFormItem.CommitteeName__c : '');
                    msg = msg.replace('{$SubBU$}', reqFormItem.SubBU__c);
                    msg = msg.replace('{$AccountName$}', (reqFormItem.CTRRequestFormHeader__r.Customer__c != null) ? reqFormItem.CTRRequestFormHeader__r.Customer__r.Name : '');

                    // msg = msg.replace('{$FinalCreditCondition$}', (reqFormItem.FinCrCond__c != null) ? reqFormItem.FinCrCond__c : '');
                    // msg = msg.replace('{$FinalPaymentCondition$}', (reqFormItem?.FinPaymentCond__c != null) ? reqFormItem?.FinPaymentCond__c : '');
                    // msg = msg.replace('{$RequestFormLink$}', reqFormItem.Id);
                }
                reqFormItem.Message__c = msg;
            }
            if (String.isBlank(reqFormItem.Subject__c)) {
                if (reqFormItem.RecordType.Name.contains('Customer')) {
                    reqFormItem.Subject__c = emailTemplate.Subject__c
                        .replace('{$RecordType$}', 'Customer')
                        .replace('{$SubBU$}', reqFormItem.SubBU__c)
                        .replace('{$AccountName$}', (reqFormItem.CTRRequestFormHeader__r.Customer__c != null) ? reqFormItem.CTRRequestFormHeader__r.Customer__r.Name : '');
                        // .replace('{$Final Credit Condition}', (reqFormItem.FinCrCond__c != null) ? reqFormItem.FinCrCond__c : '')
                        // .replace('{$Final Payment Condition}', (reqFormItem?.FinPaymentCond__c != null) ? reqFormItem?.FinPaymentCond__c : '')
                        // .replace('{$Request form link}', reqFormItem.Id);
                } else if (reqFormItem.RecordType.Name.contains('Supplier')) {
                    reqFormItem.Subject__c = emailTemplate.Subject__c
                        .replace('{$RecordType$}', 'Supplier')
                        .replace('{$SubBU$}', reqFormItem.SubBU__c)
                        .replace('{$AccountName$}', (reqFormItem.CTRRequestFormHeader__r.Customer__c != null) ? reqFormItem.CTRRequestFormHeader__r.Customer__r.Name : '');
                        // .replace('{$Final Credit Condition}', (reqFormItem.FinCrCond__c != null) ? reqFormItem.FinCrCond__c : '')
                        // .replace('{$Final Payment Condition}', (reqFormItem?.FinPaymentCond__c != null) ? reqFormItem?.FinPaymentCond__c : '')
                        // .replace('{$Request form link}', reqFormItem.Id);
                }
            }
            return reqFormItem;
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static void saveReqFormItem(String recordId, CTRRequestFormItem__c reqFormObj, Boolean isSubmit, String uploadedList, String templateType, String profile) {
        Id currentUserId = UserInfo.getUserId();
        System.debug('Save req form item '+reqFormObj);
        try {
            if (String.isNotBlank(recordId)) {
                reqFormObj.Id = recordId;
            }

            setTRCRSectionHeadIfBlank(recordId, reqFormObj);
            System.debug('Print:');
            System.debug(reqFormObj.CreditOwnerSectionHead__c);
            if (profile == 'TX') {
                if (isSubmit) {
                    List<CTRCommitteeApproval__c> cmteDelete = [SELECT Id FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];

                    String[] cmte = reqFormObj.CommitteeName__c.split(',');
                    List<String> cmteSelected = new List<String>();
                    for (CTRCommittee__mdt cm : [SELECT Name__c FROM CTRCommittee__mdt WHERE DeveloperName IN :cmte]) {
                        cmteSelected.add(cm.Name__c);
                    }
                    List<User> aprvs = [SELECT Id, Name, Email FROM User WHERE IsActive = true AND Name IN :cmteSelected];

                    // Create Committe Approval record
                    List<CTRCommitteeApproval__c> cmteAprvs = new List<CTRCommitteeApproval__c>();
                    for (User aprv : [SELECT Id, Name, Email FROM User WHERE IsActive = true AND Name IN :cmteSelected]) {
                        CTRCommitteeApproval__c cmteAprv = new CTRCommitteeApproval__c(
                            Name = aprv.Name,
                            CTRRequestFormItem__c = recordId,
                            ApprovalDate__c = Date.today(),
                            ApprovalResult__c = 'Submit to Committee',
                            ApproverName__c = aprv.Id,
                            Remark__c = ''
                        );
                        cmteAprvs.add(cmteAprv);
                    }

                    reqFormObj.Status__c = 'Approval In Progress';
                    reqFormObj.Approval_Step__c = 'Waiting for Approval';
                    reqFormObj.RemindDate__c = getRemindDate();
                    reqFormObj.CommitteeStatus__c = 'Submitted';
                    reqFormObj.SubmittedTRCR__c = true;

                    Savepoint sp = Database.setSavepoint();
                    try {
                        upsert reqFormObj;
                        delete cmteDelete;
                        insert cmteAprvs;
                    } catch(Exception ex) {
                        Database.rollback(sp);
                        throw ex;
                    }

                    String joinString = parseJSONAttachments(uploadedList);
                    List<CTRCommitteeApproval__c> newCmteAprvs = [SELECT Id, ApprovalResult__c, ApproverName__c, ApproverName__r.Name, ApproverName__r.Email, CTRRequestFormItem__c FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
                    sendEmailWithAttachment(recordId, reqFormObj, newCmteAprvs, joinString, templateType, profile);
                } else {
                    upsert reqFormObj;
                }
            } else {
                // Set Remind Date
                List<CTRCommitteeApproval__c> cmteAprvs = [SELECT Id, ApproverName__c, ApproverName__r.Name, ApproverName__r.Email, ApprovalResult__c, CTRRequestFormItem__c FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId AND ApprovalResult__c = 'Waiting Section Head Review'];
                if (isSubmit) {
                    reqFormObj.Status__c = 'Approval In Progress';
                    reqFormObj.Approval_Step__c = 'Waiting for Approval';
                    reqFormObj.RemindDate__c = getRemindDate();
                    reqFormObj.CommitteeStatus__c = 'Submitted';
                    reqFormObj.SubmittedTRCR__c = true;

                    if (!cmteAprvs.isEmpty()) {
                        for (CTRCommitteeApproval__c cmteAprv : cmteAprvs) {
                            cmteAprv.ApprovalDate__c = Date.today();
                            cmteAprv.ApprovalResult__c = 'Submit to Committee';
                            cmteAprv.Remark__c = '';
                        }
                    }
                }

                Savepoint sp = Database.setSavepoint();
                try {
                    upsert reqFormObj;
                    update cmteAprvs;
                } catch(Exception ex) {
                    Database.rollback(sp);
                }

                if (isSubmit) {
                    String joinString = parseJSONAttachments(uploadedList);
                    sendEmailWithAttachment(recordId, reqFormObj, cmteAprvs, joinString, templateType, profile);
                }
            }
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage() + e.getLineNumber());
        }
    }

    @AuraEnabled
    public static void saveReqFormItemAndSubmitToSH(String recordId, CTRRequestFormItem__c reqFormObj, Boolean isSubmit, String uploadedList, String templateType, String profile) {
        Id currentUserId = UserInfo.getUserId();
        try {
            // Save Request Form Item
            if (String.isNotBlank(recordId)) {
                reqFormObj.Id = recordId;
            }

            setTRCRSectionHeadIfBlank(recordId, reqFormObj);
            reqFormObj.RevertedTRCRSH__c = false;
            reqFormObj.SubmittedTRCR__c = true;
            reqFormObj.CommitteeStatus__c = 'Waiting Section Head Review';
            upsert reqFormObj;

            List<CTRCommitteeApproval__c> cmteDelete = [SELECT Id FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
            delete cmteDelete;

            CTRRequestFormItem__c rqit = [SELECT Id, CommitteeName__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
            String[] cmte = rqit.CommitteeName__c.split(',');
            List<CTRCommittee__mdt> cmtes = [SELECT Name__c FROM CTRCommittee__mdt WHERE DeveloperName IN :cmte];
            List<String> cmteSelected = new List<String>();
            for (CTRCommittee__mdt cm : cmtes) {
                cmteSelected.add(cm.Name__c);
            }
            System.debug(cmteSelected);
            List<User> aprvs = [SELECT Id, Name, Email FROM User WHERE IsActive = true AND Name IN :cmteSelected];
            System.debug(aprvs);

            // Create Committe Approval record
            List<CTRCommitteeApproval__c> cmteAprvs = new List<CTRCommitteeApproval__c>();
            for (Integer i=0; i < aprvs.size(); i++) {
                CTRCommitteeApproval__c cmteAprv = new CTRCommitteeApproval__c();
                cmteAprv.Name = aprvs[i].Name;
                cmteAprv.CTRRequestFormItem__c = recordId;
                cmteAprv.ApprovalDate__c = Date.today();
                cmteAprv.ApprovalResult__c = 'Waiting Section Head Review';
                cmteAprv.ApproverName__c = aprvs[i].Id;
                cmteAprv.Remark__c = '';
                cmteAprvs.add(cmteAprv);
            }
            insert cmteAprvs;

            // System.debug('Send Email to TRCR Section Head');
            // sendEmailWithAttachmentToSH(recordId, reqFormObj, uploadedList);
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage() + e.getLineNumber());
        }
    }

    // @future(callout=true)
    @AuraEnabled
    public static void sendFiletoHeroku(Id recordId,String uploadedList) {
        System.debug('----recordId----'+recordId);
        System.debug('----uploadedList----'+uploadedList);


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
            String condocIdValue = (String) recordMap.get('Id'); //(Boolean)recordMap.get('IsSaved') ? (String) recordMap.get('Id') : null;

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

        CTRRequestFormItem__c reqattachment = [SELECT CommitteeAttachment__c
        FROM CTRRequestFormItem__c
        WHERE Id = :recordId LIMIT 1];
        System.debug('reqattachment:'+reqattachment);
        reqattachment.CommitteeAttachment__c = '';
        update reqattachment;

        // List<String> filenamesTemp = reqattachment.CommitteeAttachment__c.split(',');
        // System.debug('filenamesTemp: '+filenamesTemp);

        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId
        FROM ContentDocumentLink
        WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :titleValues ];
        Set<Id> mIdList = new Set<Id>();
        for(ContentDocumentLink mfile : documentLinks){
            mIdList.add(mfile.ContentDocumentId);
        }
        List<String> sharepointPath = CTRSharePointLinkController.getSharepointPath(recordId,'04');
        System.debug('--sharepointPath--'+sharepointPath);
        CTRSharPointFileController.UploadFileToSharePoint(sharepointPath[0],mIdList); //CTRSharPointFileController.UploadFileToSharePoint('/Account/SF-02076/Common/02 CTR/07 Other Registration Files',mIdList);

        //Delete files
        List<ContentDocument > documents = [SELECT Id
        FROM ContentDocument  
        WHERE Id IN :condocIdValues ];
        System.debug('--documents:'+documents);
        delete documents;
    }

    public static void sendEmailWithAttachment(Id recordId, CTRRequestFormItem__c reqFormObj, List<CTRCommitteeApproval__c> newCommApprs, String uploadedList, String templateType, String profile) {
        EmailTemplate emailTemplate = new EmailTemplate();
        if (templateType == 'Committee TOP') {
            emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailTOP'];
        } else if (templateType == 'Committee TX') {
            emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailTX'];
        }else if (templateType == 'Committee LABIX') {
            emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailLABIX'];
        }
        system.debug('emailTemplate : '+emailTemplate);
        CTRRequestFormItem__c rqForm = [SELECT Message__c, BusinessUnit__c, SubBU__c, RecordType.Name, CTRRequestFormHeader__r.Customer__r.Name, FinCrCond__c, FinPaymentCond__c, FinOtherCondition__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
        // List<CTRCommitteeApproval__c> newCommApprsList = [SELECT Id, ApproverName__r.Name FROM CTRCommitteeApproval__c WHERE Id IN :newCommApprs];

        String msg = '';
        if (String.isNotBlank(rqForm.Message__c)) {
            msg = rqForm.Message__c;
        }
        msg = msg.replace('{$AccountName$}', (rqForm.CTRRequestFormHeader__r.Customer__r.Name != null) ? rqForm.CTRRequestFormHeader__r.Customer__r.Name : '')
            .replace('{$SubBU$}', rqForm.SubBU__c);
        if (rqForm.RecordType.Name.contains('Customer')) {
            msg = msg.replace('{$RecordType$}', 'Customer');
        } else if (rqForm.RecordType.Name.contains('Supplier')) {
            msg = msg.replace('{$RecordType$}', 'Supplier');
        }
        msg = msg.replace('{$FinalCreditCondition$}', (rqForm.FinCrCond__c != null) ? rqForm.FinCrCond__c : '')
    		.replace('{$FinalPaymentCondition$}', (rqForm?.FinPaymentCond__c != null) ? rqForm?.FinPaymentCond__c : '')
    		.replace('{$FinalOtherCondition$}', (rqForm?.FinOtherCondition__c != null) ? rqForm?.FinOtherCondition__c : '');
            //.replace('{!FinalCreditCondition}', (rqForm.FinCrCond__c != null) ? rqForm.FinCrCond__c : '')
            //.replace('{!FinalPaymentCondition}', (rqForm?.FinPaymentCond__c != null) ? rqForm?.FinPaymentCond__c : '')
            //.replace('{!FinalOtherCondition}', (rqForm?.FinOtherCondition__c != null) ? rqForm?.FinOtherCondition__c : '');

        // Set To and CC Email Address List
        system.debug('Set To and CC Email Address List start');

        // String[] toAddresses = reqFormObj.EmailTo__c.split(',');
        // for (Integer i = 0; i < toAddresses.size(); i++) {
        //     toAddresses[i] = toAddresses[i].replace('\\s', '').trim();
        // }

        List<String> ccAddresses = new List<String>();
        if (reqFormObj.EmailCC__c != null && reqFormObj.EmailCC__c.replace(' ','') != '') {
            ccAddresses = reqFormObj.EmailCC__c.split(',');
        }

        for (Integer i = 0; i < ccAddresses.size(); i++) {
            ccAddresses[i] = ccAddresses[i].replace('\\s', '').trim();
        }

        List<CTRExternalEmailGroup__mdt> mailGroup = [SELECT Email__c FROM CTRExternalEmailGroup__mdt WHERE DeveloperName IN ('CM', 'TRCR', 'TRSS')];
        for (Integer i = 0; i < mailGroup.size(); i++) {
            ccAddresses.add(mailGroup[i].Email__c);
        }
        system.debug('Set To and CC Email Address List end');
        // Create an Email with Attachment
        system.debug('Create an Email with Attachment start');
        Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[]{};

        if (String.isNotBlank(uploadedList)) {
            List<String> filenames = uploadedList.split(',');

            List<Attachment> attachments = [SELECT Id, Name, Body, ContentType FROM Attachment WHERE ParentId = :recordId];
            system.debug('documentLinks param --> : recordId'+recordId + ' ContentDocument.Title -->'+ filenames);
            List<ContentDocumentLink> documentLinks = [
                SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :filenames];

            Map<Id, ContentVersion> contentVersionMap = new Map<Id, ContentVersion>();

            Set<Id> contentVersionIds = new Set<Id>();
            for (ContentDocumentLink documentLink : documentLinks) {
                contentVersionIds.add(documentLink.ContentDocument.LatestPublishedVersionId);
            }

            Map<Id, ContentVersion> contentVersions = new Map<Id, ContentVersion>([SELECT Id, Title, VersionData, FileExtension FROM ContentVersion WHERE Id IN :contentVersionIds]);

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
        system.debug('Create an Email with Attachment mid');
        system.debug('newCommApprs : '+newCommApprs + ' : size '+ newCommApprs.size());
        System.debug('Debug req form obj subject '+reqFormObj.Subject__c);
        for (Integer i = 0; i < newCommApprs.size(); i++) {
            // Create an Email Message
            system.debug('Create an Email with Attachment mid : '+i);
            String url = URL.getOrgDomainUrl().toExternalForm() + '/' + newCommApprs[i].CTRRequestFormItem__c;
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            system.debug('Create an Email with Attachment mid : '+i + ' : newCommApprs[i].ApprovalResult__c : '+newCommApprs[i].ApprovalResult__c);
            if (newCommApprs[i].ApprovalResult__c == 'Submit to Committee') {
                system.debug ('emailTemplate : ' +emailTemplate.HtmlValue);
                String emailContent = emailTemplate.HtmlValue
                    // .replace('{!relatedTo.Message__c}', rqForm.Message__c)
                    .replace('{!relatedTo.Message__c}', msg)
                    .replace('{!relatedTo.Id}', newCommApprs[i].Id).replace('file.force.com', 'my.salesforce-sites.com')
                    .replace('{$CommitteeApprovalName$}', newCommApprs[i].ApproverName__r.Name)
                    .replace('{$url$}', '<a href="' + url + '" target="_blank"><em>this link</em></a>');
                    
                email.setToAddresses(new String[]{newCommApprs[i].ApproverName__r.Email});
                email.setCcAddresses(ccAddresses);
                email.setWhatId(recordId);
                email.setTemplateId(emailTemplate.Id);
                email.setSubject(reqFormObj.Subject__c);
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
                notifyUsers(reqFormObj, new List<CTRCommitteeApproval__c>{newCommApprs[i]}, profile);
            } else {
                System.debug('Email failed to send' + '. Errors: ' + results[0].getErrors()[0].getMessage());
            }
        }
    }

    // public static void sendEmailWithAttachmentToSH(Id recordId, CTRRequestFormItem__c reqFormObj, String uploadedList) {
    //     EmailTemplate emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailLABIX'];
    //     system.debug('emailTemplate : '+emailTemplate);

    //  // Find TRCR Section Head
    //     CTRRequestFormItem__c rqForm = [SELECT Message__c, CommitteeOwner__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
    //     PISUsers__c trcrSH = CTRBuProfileController.getReportToPIS(rqForm.CommitteeOwner__c);
    //     User usr =
    //     system.debug('TRCR Section Head:  '+ trcrSH.User__c);

    //     // Set To and CC Email Address List
    //     system.debug('Set To and CC Email Address List start');
    //     String[] toAddresses = trcrSH?.User__r?.Email.split(',');
    //     for (Integer i = 0; i < toAddresses.size(); i++) {
    //         toAddresses[i] = toAddresses[i].replace('\\s', '').trim();
    //     }

    //     system.debug('Create an Email with Attachment mid : ' + 0);
    //     Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    //     String emailContent = emailTemplate.HtmlValue.replace('{!relatedTo.Message__c}', rqForm.Message__c).replace('file.force.com', 'my.salesforce-sites.com');
    //     email.setToAddresses(new String[]{toAddresses[0]});
    //     // email.setCcAddresses(ccAddresses);
    //     email.setWhatId(recordId);
    //     email.setTemplateId(emailTemplate.Id);
    //     email.setSubject(reqFormObj.Subject__c);
    //     email.setHtmlBody(emailContent);
    //     email.setSaveAsActivity(false);
    //     // email.setFileAttachments(fileAttachments);
    //     email.setCharset('UTF-8');

    //     // Send the email
    //     system.debug('start send mail : '+0);
    //     Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    //     system.debug('Create an Email with Attachment end');
    //     if (results[0].isSuccess()) {
    //         System.debug('Email sent successfully');
    //         CustomNotificationType notificationType = [
    //             SELECT Id, DeveloperName
    //             FROM CustomNotificationType
    //             WHERE DeveloperName='CTRNotification'];
    //         Messaging.CustomNotification notification = new Messaging.CustomNotification();

    //         String title = reqFormObj.Name + ' is requesting for committee approval.';
    //         String body = 'Committee has been selected by TRCR. \nPlease review.';

    //         notification.setTitle(title);
    //         notification.setBody(body);
    //         notification.setNotificationTypeId(notificationType.Id);
    //         notification.setTargetId(recordId);

    //         try {
    //             notification.send(new Set<String>{trcrSH.User__c});
    //         }
    //         catch (Exception e) {
    //             System.debug('Problem sending notification: ' + e.getMessage());
    //         }
    //     } else {
    //         System.debug('Email failed to send' + '. Errors: ' + results[0].getErrors()[0].getMessage());
    //     }
    // }

    // Update List Attachment
    @AuraEnabled
    public static void updateListFileName(String recordId, String uploadedFile){
        try {
            System.debug('=====uploadedFile:'+uploadedFile);
            CTRRequestFormItem__c updReqIem = new CTRRequestFormItem__c();
            updReqIem.Id = recordId;
            updReqIem.CommitteeAttachment__c = uploadedFile;
            update updReqIem;
            System.debug('==updReqIem=='+updReqIem);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Get List Uploaded File
    @AuraEnabled(cacheable=true)
    public static String getUploadedFileName(String recordId) {
        CTRRequestFormItem__c reqItem = [SELECT CommitteeAttachment__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
        return reqItem.CommitteeAttachment__c;
    }

    // Get Current User Profile
    @AuraEnabled(cacheable=true)
    public static String getCurrentUserProfileName(string recordId) {
        return [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
    }

    // Get Current User Profile
    @AuraEnabled(cacheable=true)
    public static String getCurrentUserBUProfile(string recordId) {
        return CTRBuProfileController.checkBusinessUnitFromProfile(UserInfo.getUserId(),recordId).BusinessUnit__c;
    }

    // Get Current User Profile
    @AuraEnabled(cacheable=true)
    public static String getCurrentUser() {
        return UserInfo.getUserId();
    }

    @AuraEnabled(cacheable=true)
    public static List<User> getTRCR(String salesOrg, String recordType, String type, String hasCrude, String interByTX) {
        List<String> actors = new List<String>();
        for (CTRActorInProcess__mdt actor : [ SELECT EmployeeId__c FROM CTRActorInProcess__mdt WHERE Process__c = 'CommitteeSelection' AND Step__c IN ('Credit') AND SalesOrg__c = :salesOrg AND Type__c = :type AND RecordType__c = :recordType AND Product__c = :hasCrude AND InterByTX__c = :interByTX]) {
            actors.add(actor.EmployeeId__c);
        }
        List<String> users = new List<String>();
        for (User usr : [SELECT Id FROM User WHERE Employee_Id__c IN :actors AND IsActive = true]) {
            users.add(usr.Id);
        }
        return [SELECT Id, Name FROM User WHERE Id IN :users];
    }

    @AuraEnabled(cacheable=true)
    public static List<User> getTRCRSectionHead(String salesOrg, String recordType, String type, String hasCrude, String interByTX) {
        List<String> actors = new List<String>();
        for (CTRActorInProcess__mdt actor : [SELECT EmployeeId__c FROM CTRActorInProcess__mdt WHERE Process__c = 'CommitteeSelection' AND Step__c IN ('CreditHead') AND SalesOrg__c = :salesOrg AND Type__c = :type AND RecordType__c = :recordType AND Product__c = :hasCrude AND InterByTX__c = :interByTX]) {
            actors.add(actor.EmployeeId__c);
        }
        List<String> users = new List<String>();
        for (User usr : [SELECT Id FROM User WHERE Employee_Id__c IN :actors AND IsActive = true]) {
            users.add(usr.Id);
        }
        return [SELECT Id, Name FROM User WHERE Id IN :users];
    }

    @AuraEnabled(cacheable=true)
    public static String getCurrentUserCommitteeOwnerSH(string recordId) {
        CTRRequestFormItem__c rqit = [SELECT Id, CommitteeOwner__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
        PISUsers__c pis = CTRBuProfileController.getReportToPIS(rqit.CommitteeOwner__c);
        return pis.User__c;
    }

    // Custom Notification
    public static void notifyUsers(CTRRequestFormItem__c reqItem, List<CTRCommitteeApproval__c> newCommApprs, String profile) {

        Set<String> recipientsIds = new Set<String>();
        String targetId = reqItem.Id;
        String title = '';
        String body = '';
        String accountName = '';
        List<CTRRequestFormItem__c> rqit = [SELECT CTRRequestFormHeader__r.Customer__r.Name FROM CTRRequestFormItem__c WHERE Id = :reqItem.Id];
        if (rqit.size() > 0) {
            accountName = rqit[0].CTRRequestFormHeader__r.Customer__r.Name;
        }

        if (profile == 'TOP') {
            title = accountName + ' is requesting for approval.';
            body = 'Please kindly approve the counterparty registration.';
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
    
// Custom emial Notification
   // public static void EmailNotifyUsers(string recordId,string EmailTo) {
   //     CTRRequestFormItem__c reqItem = [select Id,Name from CTRRequestFormItem__c where id =:recordId];
   //     Set<String> recipientsIds = new Set<String>();
   //     String targetId = reqItem.Id;
   //     String accountName = reqItem.Name;
   //     String title = 'You got mail';
   //     String body = 'you got email involve' + accountName;
//
//        String[] splitEmailTo = EmailTo.split(',');
 //       list<User> userList = [select id from user where Email in:splitEmailTo];
//
 //       for (User Userid : userList) {
 //           recipientsIds.add(Userid.id);
 //       }
//
 //       CustomNotificationType notificationType =
   //         [SELECT Id, DeveloperName
   //          FROM CustomNotificationType
             //WHERE DeveloperName='CTR_Notification'];CTRNotification
  //          WHERE DeveloperName='CTRNotification'];
        // Create a new custom notification
  //      Messaging.CustomNotification notification = new Messaging.CustomNotification();

  //      notification.setTitle(title);
   //     notification.setBody(body);
  //      notification.setNotificationTypeId(notificationType.Id);
  //      notification.setTargetId(targetId);

  //      try {
  //          notification.send(recipientsIds);
   //     }
   //     catch (Exception e) {
   //         System.debug('Problem sending notification: ' + e.getMessage());
   //     }
   // }

    // Revert Committee
    // @AuraEnabled
    // public static Boolean revertCommittee(String recordId) {
    //     Boolean isReverted = false;
    //     List<CTRCommitteeApproval__c> commApprRec = [SELECT Id, ApproverName__c FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId AND ApprovalResult__c = 'Waiting Section Head Review'];

    //     if (!commApprRec.isEmpty()) {
    //         isReverted = true;
    //         List<CTRCommitteeApproval__c> newCommApprList = new List<CTRCommitteeApproval__c>();

    //         for (CTRCommitteeApproval__c comAppr : commApprRec) {
    //             CTRCommitteeApproval__c newCommAppr = new CTRCommitteeApproval__c();
    //             newCommAppr.CTRRequestFormItem__c = recordId;
    //             newCommAppr.ApprovalDate__c = Date.today();
    //             newCommAppr.ApprovalResult__c = 'Revert to TRCR';
    //             newCommAppr.ApproverName__c = comAppr.ApproverName__c;
    //             newCommAppr.Remark__c = '';
    //             newCommApprList.add(newCommAppr);
    //         }
    //         insert newCommApprList;
    //     }
    //     return isReverted;
    // }

    @AuraEnabled
    public static Boolean revertToTRCR(String recordId, String comment) {
        String buProfile = getCurrentUserBUProfile(recordId);
        String revertedStatus = 'Reverted to Credit Team';
        List<CTRCommitteeApproval__c> cmteAprvs = [SELECT Id, ApproverName__c FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId AND ApprovalResult__c = 'Waiting Section Head Review'];
        if (!cmteAprvs.isEmpty()) {
            for (CTRCommitteeApproval__c cmteAprv : cmteAprvs) {
                cmteAprv.ApprovalDate__c = Date.today();
                cmteAprv.ApprovalResult__c = revertedStatus;
                cmteAprv.Remark__c = comment;
            }
        }

        CTRRequestFormItem__c rqit = new CTRRequestFormItem__c();
        rqit.Id = recordId;
        rqit.RevertedTRCRSH__c = true;
        rqit.CommitteeStatus__c = revertedStatus;
        rqit.Comment__c = comment;

        Savepoint sp = Database.setSavepoint();
        try {
            update rqit;
            update cmteAprvs;
        } catch(Exception ex) {
            Database.rollback(sp);
            throw ex;
        }

        return true;
    }

    // //new add
    // @AuraEnabled
    // public static String uploadFiles(List<String> fileList) {
    //     // Implement logic to process the attached files
    //     // You can use ContentVersion or other objects to handle file attachments

    //     System.debug('--uploadFiles--'+fileList);

    //     // List<String> stringList = new List<String>();
    //     // // Example: Print file titles
    //     // for (String title : fileList) {
    //     //     System.debug('title : ' + title);
    //     //     stringList.add('\'' + title + '\'');

    //     // }
    //     // System.debug('stringList : '+stringList);
    //     // String formattedString = '(' + String.join(stringList, ', ') + ')';
    //     // System.debug('formattedString :'+formattedString);

    //     List<ContentVersion> mVersion = [SELECT Id, ContentDocumentId, VersionData,ContentDocument.Title FROM ContentVersion WHERE ContentDocument.Title IN :fileList];
    //     System.debug('--mVersion--'+mVersion);

    //     Set<Id> mIdList = new Set<Id>();
    //     System.debug('--mIdList--'+mIdList);

    //     for(ContentVersion mVer: mVersion)
    //     {
    //         mIdList.add(mVer.ContentDocumentId);
    //         System.debug('--for--mIdList--'+mVer.ContentDocumentId);
    //     }
    //     CTRSharPointFileController.UploadFileToSharePoint('',mIdList);

    //     // Implement your logic and return a response if necessary
    //     return 'Files uploaded successfully';
    // }

    // @AuraEnabled
    // public static Id saveFiles(Id parentId, String fileName, String base64Data) {
    //     base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
    //     Blob fileBody = EncodingUtil.base64Decode(base64Data);
    //     // Create ContentVersion
    //     ContentVersion contentVersion = new ContentVersion();
    //     contentVersion.ContentLocation = 'S';
    //     contentVersion.PathOnClient = fileName;
    //     contentVersion.Title = fileName;
    //     contentVersion.VersionData = fileBody;

    //     insert contentVersion;

    //     // Query the ContentDocumentId field
    //     ContentVersion queriedContentVersion = [
    //         SELECT Id, ContentDocumentId
    //         FROM ContentVersion
    //         WHERE Id = :contentVersion.Id
    //         LIMIT 1
    //     ];

    //     ContentDocumentLink contentLink = new ContentDocumentLink();
    //     contentLink.ContentDocumentId = queriedContentVersion.ContentDocumentId;
    //     contentLink.LinkedEntityId = parentId;
    //     contentLink.ShareType = 'V';
    //     contentLink.Visibility = 'AllUsers';

    //     insert contentLink;

    //     return contentVersion.Id;
    // }

    // @AuraEnabled
    // public static List<ContentDocument> getAttachments(Id recordId, String uploadedList) {
    //     System.debug('==recordId=='+recordId);
    //     System.debug('==uploadedList=='+uploadedList);

    //     List<ContentDocument> contentDocuments = new List<ContentDocument>();

    //     List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];

    //     Set<Id> contentDocumentIds = new Set<Id>();
    //     for (ContentDocumentLink link : documentLinks) {
    //         contentDocumentIds.add(link.ContentDocumentId);
    //     }

    //     if (String.isNotBlank(uploadedList)) {
    //         List<String> filenames = uploadedList.split(',');
    //         contentDocuments = [SELECT Id, Title FROM ContentDocument WHERE Id IN :contentDocumentIds AND Title IN :filenames];
    //     } else {
    //         return null;
    //     }
    //     System.debug('==contentDocuments=='+contentDocuments);


    //     return contentDocuments;
    // }

    // @AuraEnabled
    // public static List<String> deleteAttachments(List<Id> attachmentIds) {
    //     List<ContentDocument> documentsToDelete = [SELECT Id, Title FROM ContentDocument WHERE Id IN :attachmentIds];
    //     List<String> fileName = new List<String>();
    //     for (ContentDocument fn : documentsToDelete) {
    //         fileName.add(fn.Title);
    //     }
    //     System.debug('fileName: ' + fileName);
    //     if (!documentsToDelete.isEmpty()) {
    //         try {
    //             delete documentsToDelete;
    //         } catch (Exception e) {
    //             System.debug('Error when trying to delete attachments: ' + e.getMessage());
    //         }
    //     }

    //     return fileName;
    // }

    private static Date getRemindDate() {
        Date remindDate = Date.today();
        Integer remindDays = 0;
        List<CTRConfig__c> conf = [SELECT RemindDate__c FROM CTRConfig__c LIMIT 1];
        if (conf.size() > 0) {
            remindDays = (conf[0].RemindDate__c != null) ? (Integer) conf[0].RemindDate__c : 0;
        }
        return remindDate.addDays(remindDays);
    }

    private static String parseJSONAttachments(String uploadedList){
        if(String.isNotBlank(uploadedList)) {
            List<Object> input = (List<Object>)JSON.deserializeUntyped(uploadedList);
            Set<String> filenames = new Set<String>();
            for (Object o : input) {
                map<String,Object>a = (Map<String, Object>)o;
                String temp = String.valueof(a.get('Title'));
                List<String>fileName = temp.split('\\.');
                filenames.add(fileName[0]);
            }
            return String.join(filenames,',');
        }
        return '';
    }

    private static void setTRCRSectionHeadIfBlank(String recordId, CTRRequestFormItem__c reit) {
        List<CTRRequestFormItem__c> lst = [SELECT SubBU__c, InterestedProductTypeAsSupplierTOP__c, CreditOwnerSectionHead__c, RecordType.Name, Country__r.Code__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
        if (!(lst.size() > 0)) {
            return;
        }
        if (String.isNotBlank(lst[0].CreditOwnerSectionHead__c)) {
            return;
        }
        String salesOrg = lst[0].SubBU__c;
        String counterpartyType = lst[0].RecordType?.Name?.contains('Customer') ? 'Customer' : (lst[0].RecordType?.Name?.contains('Supplier') ? 'Supplier' : '');
        String type = lst[0].Country__r?.Code__c == 'TH' ? 'Domestic' : 'International';
        String product = lst[0].InterestedProductTypeAsSupplierTOP__c;
        String hasCrude = String.isNotBlank(product) && product.contains('Crude') ? 'Crude' : '';
        String interByTX = 'No';
        List<User> sh = getTRCRSectionHead(salesOrg, counterpartyType, type, hasCrude, interByTX);
        if (sh.size() > 0) {
            reit.CreditOwnerSectionHead__c = sh[0].Id;
        }
    }
    
    /*
    @AuraEnabled
    public static List<ContentDocument> getAttachmentDetails(Id recordId, String uploadedList, Boolean byId) {
        List<ContentDocument> contentDocuments = new List<ContentDocument>();
        System.debug('==recordId=='+recordId);
        System.debug('==uploadedList=='+uploadedList);

        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        
        Set<Id> contentDocumentIds = new Set<Id>();
        for (ContentDocumentLink link : documentLinks) {
            contentDocumentIds.add(link.ContentDocumentId);
        }

        if (String.isNotBlank(uploadedList)) {
            if(byId) {
                contentDocuments = [SELECT Id, Title, PublishStatus, ContentSize, FileType, FileExtension, SharingOption FROM ContentDocument WHERE Id = :uploadedList];    
            } else {
                List<String> filenames = uploadedList.split(',');
                system.debug('filenames----'+filenames);
                contentDocuments = [SELECT Id, Title, PublishStatus, ContentSize, FileType, FileExtension, SharingOption FROM ContentDocument WHERE Id IN :contentDocumentIds AND Title IN :filenames];
                system.debug('contentDocuments----'+contentDocuments);        
            }
        } else {
            contentDocuments = [SELECT Id, Title, PublishStatus, ContentSize, FileType, FileExtension, SharingOption FROM ContentDocument WHERE Id IN :contentDocumentIds];
        }
        System.debug('==contentDocuments=='+contentDocuments);
        
        return contentDocuments;
    }
    */


}