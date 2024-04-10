public without sharing class CTRCommitteeSelectionController {

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

    @AuraEnabled(cacheable=true)
    public static List<CommitteeGroup> getGroupedCommittees() {
        Map<String, CommitteeGroup> groupedCommitteesMap = new Map<String, CommitteeGroup>();

        List<CTRCommittee__mdt> committees = [
            SELECT Id, Label, DeveloperName, Parent__c, Name__c, EmployeeId__c, Email__c, CreditRating__c, BU__c, TOP__c, TPX__c, TLB__c, LABIX__c, TXTH__c, TSV__c, JSKem__c, TSR__c, TXIndia__c
            FROM CTRCommittee__mdt
        ];

        setUserEmailCommittees(committees);

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

    @AuraEnabled
    public static CTRBUProfile__mdt getCurrentUserBUProfile(string recordId) {
        return CTRBuProfileController.checkBusinessUnitFromProfile(UserInfo.getUserId(), recordId);
    }

    @AuraEnabled
    public static String getRequestCounterpartyType(string recordId) {
        List<CTRRequestFormItem__c> rqit = [ SELECT Id, RecordType.Name FROM CTRRequestFormItem__c WHERE Id = :recordId ];

        if (rqit.size() > 0) {
            if (rqit[0].RecordType.Name.contains('Customer')) {
                return 'Customer';
            } else if (rqit[0].RecordType.Name.contains('Supplier')) {
                return 'Supplier';
            }
            return '';
        } else {
            return '';
        }
    }

    @AuraEnabled
    public static CTRRequestFormItem__c getRequestItem(String recordId) {
        CTRRequestFormItem__c rqit = [SELECT Id, RecordTypeId, RecordType.Name FROM CTRRequestFormItem__c WHERE Id = :recordId];
        return rqit;
    }

    @AuraEnabled
    public static Map<String, Master_Map__c> getMasterPaymentTerm() {
        Map<String, Master_Map__c> pytm = new Map<String, Master_Map__c>();
        for (Master_Map__c itm : [SELECT Id, Name FROM Master_Map__c WHERE Type__c = 'Payment Term']) {
            pytm.put(itm.Id, itm);
        }
        return pytm;
    }

    @AuraEnabled
    public static CTRRequestFormItem__c getCommitteeInfo(String recordId, String templateType) {
        if (String.isNotBlank(recordId)) {
            CTREmailTemplateMaster__c emailTemplate = [
                SELECT Subject__c, HTMLBody__c, Type__c
                FROM CTREmailTemplateMaster__c
                WHERE Type__c = :templateType LIMIT 1
            ];

            CTRRequestFormItem__c reqFormItem = [
                SELECT
                    Id, Name,
                    AgreeAsTraderCommentSH__c, AgreeAsTraderCommentVP__c, AmountBankGuarantee__c, AmountBuyTrade__c, AmountCreditTerm__c, AmountDCLCondition__c, AmountOpenedCredit__c, Approval_SHAgree__c, Approval_Step__c, Approval_VPAgree__c, ApprovalTrader_CreditCondition__c, ApprovalTrader_CreditLimit__c, ApprovalTrader_CreditRating__c, ApprovalTrader_PaymentCondition__c, ApprovalTrader_PaymentTerm__c, ApprovalTrader_TradeCreditInsurance__c, ApprovalTraderCreditLimitCurrency__c, ApprovalTraderRiskCategory__c, ApprovalTraderTradeCreditCurrency__c, Authorization__c,
                    BuyTradeDCLCondition__c, BuyTradeEndorsement__c,
                    CashOnDelivery__c, ChangeCreditCreditCondition__c, ChangeCreditCreditLimit__c, ChangeCreditCreditLimitCurrency__c, ChangeCreditInternalCreditRating__c, CMVPPreScreenDecision__c, Comment__c, CommitteeAttachment__c, CommitteeEmail__c, CommitteeName__c, CommitteeStatus__c, Country__c, Country__r.Code__c, Credit_Condition__c, CreditLimit__c, CreditLimitCurrency__c, CreditOwner__c, CreditOwnerSectionHead__c, CTRRequestFormHeader__r.Customer__c, CTRRequestFormHeader__r.Customer__r.Name, CTRRequestFormHeader__r.Email__c, CTRRequestFormHeader__r.FirstName__c, CTRRequestFormHeader__r.LastName__c, CTRRequestFormHeader__r.MobilePhone__c, Currency__c, Customer__c,
                    EffectiveDateForm__c, EffectiveDateTo__c, EmailAuthorization__c, EmailCC__c, EmailTo__c, EmailUrgent__c,
                    FinalPerformanceBond__c, FinAmountBankGuarantee__c, FinAmountBuyTrade__c, FinAmountCreditTerm__c, FinAmountDCLCondition__c, FinAmountOpenedCredit__c, FinBuyTradeDCLCondition__c, FinBuyTradeEndorsement__c, FinCashOnDelivery__c, FinCrCond__c, FinCrLimit__c, FinCrLimitCur__c, FinHavingCollateral__c, FinHavingCreditTermOrLetter__c, FinHavingOpenedCredit__c, FinIntCrRating__c, FinOtherCondition__c, FinPaymentCond__c, FinPaymentTerm__c, FinRiskCategory__c, FinTotalSecuredCurrency__c, FinTradeCrIns__c, FinTradeCrInsCu__c,
                    HavingCollateral__c, HavingCreditTermOrLetter__c, HavingOpenedCredit__c,
                    InterestedProductTypeAsCustomer__c, InterestedProductTypeAsCustomerTOP__c, InterestedProductTypeAsCustomerTX__c, InterestedProductTypeAsSupplier__c, InterestedProductTypeAsSupplierTOP__c, InterestedProductTypeAsSupplierTX__c, InternalCreditRating__c, InternalCreditRatingTOP__c,
                    Message__c,
                    OtherCondition__c, Owner__c, Owner__r.Name, OwnersCMVP__c,
                    PaymentCondition__c, PaymentTerm__c, PerformanceBond__c, Product__c, PurchasingOrganizationTOP__c, PurchasingOrganizationTX__c,
                    RecordType.Name, RemarkPerformanceBond__c, RequestToChangeCredit__c, RiskCategory__c,
                    SalesOrganization__c, SalesOrganizationTOP__c, SalesOrganizationTX__c, Status__c, SubBU__c, Subject__c, SubTypeCondition__c,
                    TDPerformanceBond__c, TermOfPayment__c, TotalSecuredCurrency__c, Trade_Credit_Insurance__c, TradeCreditInsuranceCurrency__c, TraderRemark__c, TraderWaive__c, TypeOfBusiness__c, TypeOfBusinessOther__c, TermOfPayment__r.Name,
                    CompanyCodeTX__c, DistributionChannel__c, Division__c, PurchasingOrganization__c, 
                    BlockedReason__c, SelectedPurchasingOrg__c
                FROM CTRRequestFormItem__c
                WHERE Id = :recordId
            ];

            if (String.isBlank(reqFormItem.Subject__c)) {
                reqFormItem.Subject__c = mergeFieldEmailTemplate(recordId, emailTemplate.Subject__c, 'Draft');
            } else {
                reqFormItem.Subject__c = mergeFieldEmailTemplate(recordId, reqFormItem.Subject__c, 'Draft');
            }
            if (String.isBlank(reqFormItem.Message__c)) {
                reqFormItem.Message__c = mergeFieldEmailTemplate(recordId, emailTemplate.HTMLBody__c, 'Draft');
            } else {
                reqFormItem.Message__c = mergeFieldEmailTemplate(recordId, reqFormItem.Message__c, 'Draft');
            }

            return reqFormItem;
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static List<User> getTRCR(String salesOrg, String recordType, String type, String hasCrude, String interByTX) {
        List<String> actors = new List<String>();
        for (CTRActorInProcess__mdt actor : [ SELECT EmployeeId__c FROM CTRActorInProcess__mdt WHERE Process__c = 'CommitteeSelection' AND Step__c IN ('Credit') AND SalesOrg__c = :salesOrg AND Type__c = :type AND RecordType__c = :recordType AND Product__c = :hasCrude AND InterByTX__c = :interByTX]) {
            actors.add(actor.EmployeeId__c);
        }
        List<String> users = new List<String>();
        for (User usr : [SELECT Id FROM User WHERE Employee_Id__c IN :actors AND IsActive = true]) {
            users.add(usr.Id);
        }
        return [SELECT Id, Name, Email, Employee_ID__c FROM User WHERE Id IN :users];
    }

    @AuraEnabled
    public static List<User> getTRCRSectionHead(String salesOrg, String recordType, String type, String hasCrude, String interByTX) {
        List<String> actors = new List<String>();
        for (CTRActorInProcess__mdt actor : [SELECT EmployeeId__c FROM CTRActorInProcess__mdt WHERE Process__c = 'CommitteeSelection' AND Step__c IN ('CreditHead') AND SalesOrg__c = :salesOrg AND Type__c = :type AND RecordType__c = :recordType AND Product__c = :hasCrude AND InterByTX__c = :interByTX]) {
            actors.add(actor.EmployeeId__c);
        }
        List<String> users = new List<String>();
        for (User usr : [SELECT Id FROM User WHERE Employee_Id__c IN :actors AND IsActive = true]) {
            users.add(usr.Id);
        }
        return [SELECT Id, Name, Email, Employee_ID__c FROM User WHERE Id IN :users];
    }

    @AuraEnabled
    public static List<User> getCEO(String salesOrg, String recordType, String type, String hasCrude, String interByTX) {
        List<String> actors = new List<String>();
        for (CTRActorInProcess__mdt actor : [ SELECT EmployeeId__c FROM CTRActorInProcess__mdt WHERE Process__c = 'DueDiligence' AND Step__c IN ('CEO') AND SalesOrg__c = :salesOrg AND Type__c = :type AND RecordType__c = :recordType AND Product__c = :hasCrude AND InterByTX__c = :interByTX]) {
            actors.add(actor.EmployeeId__c);
        }
        List<String> users = new List<String>();
        for (User usr : [SELECT Id FROM User WHERE Employee_Id__c IN :actors AND IsActive = true]) {
            users.add(usr.Id);
        }
        return [SELECT Id, Name, Email, Employee_ID__c FROM User WHERE Id IN :users];
    }

    private static String mergeFieldEmailTemplate(String recordId, String msg, String stage) {
        CTRRequestFormItem__c reqFormItem = [ SELECT Id, RecordType.Name, SubBU__c, CTRRequestFormHeader__r.Customer__c, CTRRequestFormHeader__r.Customer__r.Name, FinCrCond__c, FinPaymentCond__c, FinOtherCondition__c, TermOfPayment__c, TermOfPayment__r.Name, BusinessUnit__c FROM CTRRequestFormItem__c WHERE Id = :recordId ];

        if (reqFormItem.RecordType.Name.contains('Customer')) {
            msg = msg.replace('{$RecordType$}', 'Customer');
        } else if (reqFormItem.RecordType.Name.contains('Supplier')) {
            msg = msg.replace('{$RecordType$}', 'Supplier');
        }

        String finalCondition = '';
        if(reqFormItem.BusinessUnit__c == 'TOP' || reqFormItem.BusinessUnit__c == 'LABIX') {
            finalCondition = reqFormItem.FinPaymentCond__c;
        } else if(reqFormItem.BusinessUnit__c == 'TX') {
            finalCondition = reqFormItem.FinOtherCondition__c;
        }

        msg = msg.replace('{$SubBU$}', reqFormItem.SubBU__c);
        msg = msg.replace('{$AccountName$}', (reqFormItem.CTRRequestFormHeader__r.Customer__c != null) ? reqFormItem.CTRRequestFormHeader__r.Customer__r.Name : '');

        if (stage != 'Draft') {
            if (!String.isBlank(reqFormItem.FinCrCond__c)) {
                msg = msg.replace('{$FinalCreditCondition$}', reqFormItem.FinCrCond__c);
            } else {
                msg = msg.replace('{$FinalCreditCondition$}', '');
            }
            if (!String.isBlank(finalCondition)) {
                msg = msg.replace('{$FinalCondition$}', finalCondition);
            } else {
                msg = msg.replace('{$FinalCondition$}', '');
            }
            if (!String.isBlank(reqFormItem.TermOfPayment__c)) {
                msg = msg.replace('{$TermOfPayment$}', reqFormItem.TermOfPayment__r.Name);
            } else {
                msg = msg.replace('{$TermOfPayment$}', '');
            }
            // msg = msg.replace('{$FinalPaymentCondition$}', reqFormItem.FinPaymentCond__c);
        }

        return msg;
    }

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
        String type = (lst[0].Country__r?.Code__c == 'TH' || lst[0].Country__r == null) ? 'Domestic' : 'International';
        String product = lst[0].InterestedProductTypeAsSupplierTOP__c;
        String hasCrude = String.isNotBlank(product) && product.contains('Crude') ? 'Crude' : '';
        String interByTX = 'No';
        List<User> sh = getTRCRSectionHead(salesOrg, counterpartyType, type, hasCrude, interByTX);
        if (sh.size() > 0) {
            reit.CreditOwnerSectionHead__c = sh[0].Id;
        }
    }

    @AuraEnabled
    public static void saveReqFormItem(String recordId, CTRRequestFormItem__c reqFormObj, Boolean isSubmit, String uploadedList, String templateType, String profile) {
        try {
            if (String.isBlank(recordId)) {
                throw new AuraHandledException('The recordId field cannot be blank. Please specify the recordId when updating the request form.');
            }

            reqFormObj.Id = recordId;
            setTRCRSectionHeadIfBlank(recordId, reqFormObj);
            if (profile == 'TX') {
                upsert reqFormObj;
            } else {
                upsert reqFormObj;
            }
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            System.debug('Error Message: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage() + e.getLineNumber());
        }
    }

    @AuraEnabled
    public static void saveReqFormItemSH(String recordId, CTRRequestFormItem__c reqFormObj, Boolean isSubmit, String uploadedList, String templateType, String profile) {
        try {
            if (String.isBlank(recordId)) {
                throw new AuraHandledException('The recordId field cannot be blank. Please specify the recordId when updating the request form.');
            }

            reqFormObj.Id = recordId;
            setTRCRSectionHeadIfBlank(recordId, reqFormObj);
            upsert reqFormObj;

            List<CTRCommitteeApproval__c> cmteDelete = [SELECT Id FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
            List<CTRCommitteeApproval__c> cmteAprvs = createCommitteeApprovalList(getUserOfCommittees(recordId), 'Waiting Section Head Review', recordId);

            SavePoint sp = Database.setSavepoint();
            try {
                delete cmteDelete;
                insert cmteAprvs;
            } catch(Exception ex) {
                Database.rollback(sp);
                throw ex;
            }
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            System.debug('Error Message: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage() + e.getLineNumber());
        }
    }

    @AuraEnabled
    public static void saveReqFormItemAndSubmitToSH(String recordId, CTRRequestFormItem__c reqFormObj, Boolean isSubmit, String uploadedList, String templateType, String profile) {
        try {
            System.debug('saveReqFormItemAndSubmitToSH');
            if (String.isBlank(recordId)) {
                throw new AuraHandledException('The recordId field cannot be blank. Please specify the recordId when updating the request form.');
            }

            setTRCRSectionHeadIfBlank(recordId, reqFormObj);
            reqFormObj.Id = recordId;
            reqFormObj.RevertedTRCRSH__c = false;
            reqFormObj.SubmittedTRCR__c = true;
            reqFormObj.CommitteeStatus__c = 'Waiting Section Head Review';
            upsert reqFormObj;

            List<CTRCommitteeApproval__c> cmteDelete = [SELECT Id FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
            List<CTRCommitteeApproval__c> cmteAprvs = createCommitteeApprovalList(getUserOfCommittees(recordId), 'Waiting Section Head Review', recordId);

            SavePoint sp = Database.setSavepoint();
            try {
                delete cmteDelete;
                insert cmteAprvs;
            } catch(Exception ex) {
                Database.rollback(sp);
                throw ex;
            }
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            System.debug('Error Message: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage() + e.getLineNumber());
        }
    }

    @AuraEnabled
    public static void saveReqFormItemAndSubmitToCommittees(String recordId, CTRRequestFormItem__c reqFormObj, Boolean isSubmit, String uploadedList, String templateType, String profile) {
        try {
            System.debug('saveReqFormItemAndSubmitToCommittees : '+profile);
            if (String.isBlank(recordId)) {
                throw new AuraHandledException('The recordId field cannot be blank. Please specify the recordId when updating the request form.');
            }

            reqFormObj.Id = recordId;
            setTRCRSectionHeadIfBlank(recordId, reqFormObj);
            if (profile == 'TX') {
                reqFormObj.Status__c = 'Approval In Progress';
                reqFormObj.Approval_Step__c = 'Waiting for Approval';
                reqFormObj.RemindDate__c = getRemindDate();
                reqFormObj.CommitteeStatus__c = 'Submitted';
                reqFormObj.SubmittedTRCR__c = true;
                upsert reqFormObj;

                List<CTRCommitteeApproval__c> cmteDelete = [SELECT Id FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
                List<CTRCommitteeApproval__c> cmteAprvs = createCommitteeApprovalList(getUserOfCommittees(recordId), 'Submit to Committee', recordId);

                Savepoint sp = Database.setSavepoint();
                try {
                    delete cmteDelete;
                    insert cmteAprvs;
                } catch(Exception ex) {
                    Database.rollback(sp);
                    throw ex;
                }

                String joinString = parseJSONAttachments(uploadedList);
                List<CTRCommitteeApproval__c> newCmteAprvs = [ SELECT Id, ApprovalResult__c, ApproverName__c, ApproverName__r.Name, ApproverName__r.Email, CTRRequestFormItem__c FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
                sendEmailWithAttachment(recordId, reqFormObj, newCmteAprvs, joinString, templateType, profile);
            } else {
                reqFormObj.Status__c = 'Approval In Progress';
                reqFormObj.Approval_Step__c = 'Waiting for Approval';
                reqFormObj.RemindDate__c = getRemindDate();
                reqFormObj.CommitteeStatus__c = 'Submitted';
                reqFormObj.SubmittedTRCR__c = true;
                upsert reqFormObj;

                List<CTRCommitteeApproval__c> cmteDelete = [SELECT Id FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
                List<CTRCommitteeApproval__c> cmteAprvs = createCommitteeApprovalList(getUserOfCommittees(recordId), 'Submit to Committee', recordId);

                Savepoint sp = Database.setSavepoint();
                try {
                    delete cmteDelete;
                    insert cmteAprvs;
                } catch(Exception ex) {
                    Database.rollback(sp);
                    throw ex;
                }

                String joinString = parseJSONAttachments(uploadedList);
                List<CTRCommitteeApproval__c> newCmteAprvs = [ SELECT Id, ApprovalResult__c, ApproverName__c, ApproverName__r.Name, ApproverName__r.Email, CTRRequestFormItem__c FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
                sendEmailWithAttachment(recordId, reqFormObj, newCmteAprvs, joinString, templateType, profile);
            }
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            System.debug('Error Message: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage() + e.getLineNumber());
        }
    }

    @AuraEnabled
    public static void saveReqFormItemAndSubmitToCEO(String recordId, CTRRequestFormItem__c reqFormObj, Boolean isSubmit, String uploadedList, String templateType, String profile) {
        try {
            if (String.isBlank(recordId)) {
                throw new AuraHandledException('The recordId field cannot be blank. Please specify the recordId when updating the request form.');
            }

            reqFormObj.Id = recordId;
            setTRCRSectionHeadIfBlank(recordId, reqFormObj);
            if (profile == 'TX') {
                reqFormObj.Status__c = 'Approval In Progress';
                reqFormObj.Approval_Step__c = 'Waiting for Approval';
                reqFormObj.RemindDate__c = getRemindDate();
                reqFormObj.CommitteeStatus__c = 'Submitted';
                reqFormObj.SubmittedTRCR__c = true;
                upsert reqFormObj;

                List<CTRRequestFormItem__c> lst = [SELECT SubBU__c, InterestedProductTypeAsSupplierTOP__c, CreditOwnerSectionHead__c, RecordType.Name, Country__r.Code__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
                String salesOrg = lst[0].SubBU__c;
                String counterpartyType = lst[0].RecordType?.Name?.contains('Customer') ? 'Customer' : (lst[0].RecordType?.Name?.contains('Supplier') ? 'Supplier' : '');
                String type = lst[0].Country__r?.Code__c == 'TH' ? 'Domestic' : 'International';
                String product = lst[0].InterestedProductTypeAsSupplierTOP__c;
                String hasCrude = String.isNotBlank(product) && product.contains('Crude') ? 'Crude' : '';
                String interByTX = 'No';

                List<CTRCommitteeApproval__c> cmteDelete = [SELECT Id FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
                List<User> ceo = getCEO(salesOrg, counterpartyType, type, hasCrude, interByTX);
                List<CTRCommitteeApproval__c> cmteAprvs = createCommitteeApprovalList(new List<User>{ ceo[0] }, 'Submit to Committee', recordId);

                Savepoint sp = Database.setSavepoint();
                try {
                    delete cmteDelete;
                    insert cmteAprvs;
                } catch(Exception ex) {
                    Database.rollback(sp);
                    throw ex;
                }

                String joinString = parseJSONAttachments(uploadedList);
                List<CTRCommitteeApproval__c> newCmteAprvs = [ SELECT Id, ApprovalResult__c, ApproverName__c, ApproverName__r.Name, ApproverName__r.Email, CTRRequestFormItem__c FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
                sendEmailWithAttachment(recordId, reqFormObj, newCmteAprvs, joinString, templateType, profile);
            } else {
                reqFormObj.Status__c = 'Approval In Progress';
                reqFormObj.Approval_Step__c = 'Waiting for Approval';
                reqFormObj.RemindDate__c = getRemindDate();
                reqFormObj.CommitteeStatus__c = 'Submitted';
                reqFormObj.SubmittedTRCR__c = true;
                upsert reqFormObj;

                List<CTRRequestFormItem__c> lst = [SELECT SubBU__c, InterestedProductTypeAsSupplierTOP__c, CreditOwnerSectionHead__c, RecordType.Name, Country__r.Code__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
                String salesOrg = lst[0].SubBU__c;
                String counterpartyType = lst[0].RecordType?.Name?.contains('Customer') ? 'Customer' : (lst[0].RecordType?.Name?.contains('Supplier') ? 'Supplier' : '');
                String type = lst[0].Country__r?.Code__c == 'TH' ? 'Domestic' : 'International';
                String product = lst[0].InterestedProductTypeAsSupplierTOP__c;
                String hasCrude = String.isNotBlank(product) && product.contains('Crude') ? 'Crude' : '';
                String interByTX = 'No';

                List<CTRCommitteeApproval__c> cmteDelete = [SELECT Id FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
                List<User> ceo = getCEO(salesOrg, counterpartyType, type, hasCrude, interByTX);
                List<CTRCommitteeApproval__c> cmteAprvs = createCommitteeApprovalList(new List<User>{ ceo[0] }, 'Submit to Committee', recordId);

                Savepoint sp = Database.setSavepoint();
                try {
                    delete cmteDelete;
                    insert cmteAprvs;
                } catch(Exception ex) {
                    Database.rollback(sp);
                    throw ex;
                }

                String joinString = parseJSONAttachments(uploadedList);
                List<CTRCommitteeApproval__c> newCmteAprvs = [ SELECT Id, ApprovalResult__c, ApproverName__c, ApproverName__r.Name, ApproverName__r.Email, CTRRequestFormItem__c FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];
                sendEmailWithAttachment(recordId, reqFormObj, newCmteAprvs, joinString, templateType, profile);
            }
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            System.debug('Error Message: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage() + e.getLineNumber());
        }
    }

    @AuraEnabled
    public static void saveReqFormItemAndSubmitNoApproval(String recordId, CTRRequestFormItem__c reqFormObj, Boolean isSubmit, String uploadedList, String templateType, String profile) {
        try {
            if (String.isBlank(recordId)) {
                throw new AuraHandledException('The recordId field cannot be blank. Please specify the recordId when updating the request form.');
            }

            reqFormObj.Id = recordId;
            setTRCRSectionHeadIfBlank(recordId, reqFormObj);
            if (profile == 'TX') {
                reqFormObj.Status__c = 'Approved';
                reqFormObj.Approval_Step__c = 'Approved';
                reqFormObj.RemindDate__c = getRemindDate();
                reqFormObj.CommitteeStatus__c = 'Submitted';
                reqFormObj.SubmittedTRCR__c = true;
                upsert reqFormObj;

                List<CTRCommitteeApproval__c> cmteDelete = [SELECT Id FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];

                Savepoint sp = Database.setSavepoint();
                try {
                    delete cmteDelete;
                } catch(Exception ex) {
                    Database.rollback(sp);
                    throw ex;
                }
            } else {
                reqFormObj.Status__c = 'Approved';
                reqFormObj.Approval_Step__c = 'Approved';
                reqFormObj.RemindDate__c = getRemindDate();
                reqFormObj.CommitteeStatus__c = 'Submitted';
                reqFormObj.SubmittedTRCR__c = true;
                upsert reqFormObj;

                List<CTRCommitteeApproval__c> cmteDelete = [SELECT Id FROM CTRCommitteeApproval__c WHERE CTRRequestFormItem__c = :recordId];

                Savepoint sp = Database.setSavepoint();
                try {
                    delete cmteDelete;
                } catch(Exception ex) {
                    Database.rollback(sp);
                    throw ex;
                }
            }
        } catch (Exception e) {
            System.debug('Error Line: ' + e.getLineNumber());
            System.debug('Error Message: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage() + e.getLineNumber());
        }
    }

    @AuraEnabled
    public static Boolean revertToTRCR(String recordId, String comment) {
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

    @AuraEnabled
    public static void sendFiletoHeroku(Id recordId,String uploadedList) {
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

        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId
        FROM ContentDocumentLink
        WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :titleValues ];
        Set<Id> mIdList = new Set<Id>();
        for(ContentDocumentLink mfile : documentLinks){
            mIdList.add(mfile.ContentDocumentId);
        }
        List<String> sharepointPath = CTRSharePointLinkController.getSharepointPath(recordId,'04');
        if(sharepointPath.size() > 0)
        {
            CTRSharPointFileController.UploadFileToSharePoint(sharepointPath[0],mIdList);
        }

        List<ContentDocument > documents = [SELECT Id
        FROM ContentDocument
        WHERE Id IN :condocIdValues ];

        delete documents;
    }

    private static List<User> getUserOfCommittees(Id recordId) {
        CTRRequestFormItem__c rqit = [SELECT Id, CommitteeName__c FROM CTRRequestFormItem__c WHERE Id = :recordId];

        if (String.isBlank(rqit.CommitteeName__c)) {
            return new List<User>();
        }

        String[] cmte = rqit.CommitteeName__c.split(',');
        List<CTRCommittee__mdt> cmtes = [SELECT Name__c, EmployeeId__c FROM CTRCommittee__mdt WHERE DeveloperName IN :cmte];

        List<String> cmteSelected = new List<String>();
        for (CTRCommittee__mdt cm : cmtes) {
            cmteSelected.add(cm.Name__c);
            // cmteSelected.add(cm.EmployeeId__c);
        }

        List<User> aprvs = [SELECT Id, Name, Email, Employee_ID__c FROM User WHERE IsActive = true AND Name IN :cmteSelected];
        // List<User> aprvs = [SELECT Id, Name, Email, Employee_ID__c FROM User WHERE IsActive = true AND Employee_ID__c IN :cmteSelected];

        return aprvs;
    }

    private static List<CTRCommitteeApproval__c> createCommitteeApprovalList(List<User> aprvs, String status, Id parentId) {
        List<CTRCommitteeApproval__c> cmteAprvs = new List<CTRCommitteeApproval__c>();
        for (User aprv : aprvs) {
            CTRCommitteeApproval__c cmteAprv = new CTRCommitteeApproval__c(
                Name = aprv.Name,
                CTRRequestFormItem__c = parentId,
                ApprovalDate__c = Date.today(),
                ApprovalResult__c = status,
                ApproverName__c = aprv.Id,
                Remark__c = ''
            );
            cmteAprvs.add(cmteAprv);
        }
        return cmteAprvs;
    }

    private static void setUserEmailCommittees(List<CTRCommittee__mdt> cmtes) {
        List<String> cmtesName = new List<String>();
        for (CTRCommittee__mdt cmte : cmtes) {
            cmtesName.add(cmte.Name__c);
        }

        Map<String, User> mapUsers = new Map<String, User>();
        for (User usr : [SELECT Id, Name, Email, Employee_ID__c FROM User WHERE IsActive = true AND Name IN :cmtesName]) {
            mapUsers.put(usr.Name, usr);
        }
        
        for (CTRCommittee__mdt cmte : cmtes) {
            if (mapUsers.containsKey(cmte.Name__c)) {
                cmte.Email__c = mapUsers.get(cmte.Name__c).Email;
            }
        }

        // List<String> cmtesEmployeeId = new List<String>();
        // for (CTRCommittee__mdt cmte : cmtes) {
        //     cmtesEmployeeId.add(cmte.EmployeeId__c);
        // }

        // Map<String, User> mapUsers = new Map<String, User>();
        // for (User usr : [SELECT Id, Name, Email, Employee_ID__c FROM User WHERE IsActive = true AND Employee_ID__c IN :cmtesEmployeeId]) {
        //     mapUsers.put(usr.Employee_ID__c, usr);
        // }
        
        // for (CTRCommittee__mdt cmte : cmtes) {
        //     if (mapUsers.containsKey(cmte.EmployeeId__c)) {
        //         cmte.Email__c = mapUsers.get(cmte.EmployeeId__c).Email__c;
        //     }
        // }
    }

    public static void sendEmailWithAttachment(Id recordId, CTRRequestFormItem__c reqFormObj, List<CTRCommitteeApproval__c> newCommApprs, String uploadedList, String templateType, String profile) {
        CTRRequestFormItem__c itm = [SELECT BusinessUnit__c FROM CTRRequestFormItem__c WHERE Id = :recordId];        
        EmailTemplate emailTemplate = new EmailTemplate();
        if (itm.BusinessUnit__c == 'TOP') {
            emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailTOP'];
        } else if (itm.BusinessUnit__c == 'TX') {
            emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailTX'];
        } else if (itm.BusinessUnit__c == 'LABIX') {
            emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailLABIX'];
        }
        // if (templateType == 'Committee TOP' || templateType == 'TOP Change Customer Credit Condition' || templateTYpe == 'TOP Change Supplier Credit Condition') {
        //     emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailTOP'];
        // } else if (templateType == 'Committee TX' || templateType == 'Committee Customer TX' || templateType == 'Committee Supplier TX' || templateType == 'TX Change Customer Credit Condition' || templateType == 'TX Change Customer Credit Condition') {
        //     emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailTX'];
        // } else if (templateType == 'Committee LABIX' || templateType == '') {
        //     emailTemplate = [SELECT Id, Name, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CommitteeTakeActioninEmailLABIX'];
        // }

        CTRRequestFormItem__c rqForm = [ SELECT Message__c, BusinessUnit__c, SubBU__c, RecordType.Name, CTRRequestFormHeader__r.Customer__r.Name, FinCrCond__c, FinPaymentCond__c, FinOtherCondition__c FROM CTRRequestFormItem__c WHERE Id = :recordId];

        String msg = '';
        System.debug('Email message before merging'+msg);
        if (String.isNotBlank(rqForm.Message__c)) {
            msg = mergeFieldEmailTemplate(recordId, rqForm.Message__c, '');
        }

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

        Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[]{};
        if (String.isNotBlank(uploadedList)) {
            List<String> filenames = uploadedList.split(',');

            List<Attachment> attachments = [SELECT Id, Name, Body, ContentType FROM Attachment WHERE ParentId = :recordId];
            List<ContentDocumentLink> documentLinks = [ SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :filenames];

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

        for (Integer i = 0; i < newCommApprs.size(); i++) {
            String url = URL.getOrgDomainUrl().toExternalForm() + '/' + newCommApprs[i].CTRRequestFormItem__c;

            if (newCommApprs[i].ApprovalResult__c == 'Submit to Committee') {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String emailContent = emailTemplate.HtmlValue
                    .replace('{!relatedTo.Message__c}', msg)
                    .replace('{!relatedTo.Id}', newCommApprs[i].Id).replace('file.force.com', 'my.salesforce-sites.com')
                    .replace('{$OrgDomainURL$}', System.URL.getOrgDomainURL().toExternalForm().replace('salesforce', 'salesforce-sites'))
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

                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
                if (results[0].isSuccess()) {
                    notifyUsers(reqFormObj, new List<CTRCommitteeApproval__c>{newCommApprs[i]}, profile);
                } else {
                    System.debug('Email failed to send' + '. Errors: ' + results[0].getErrors()[0].getMessage());
                }
            }
        }
    }

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

        CustomNotificationType notificationType = [
            SELECT Id, DeveloperName
            FROM CustomNotificationType
            WHERE DeveloperName='CTRNotification'];

        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        notification.setTitle(title);
        notification.setBody(body);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);

        try {
            notification.send(recipientsIds);
        } catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}