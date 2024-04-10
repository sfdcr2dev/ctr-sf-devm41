<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CTRChangeCreditConditionRequestFASHSelectCommittee</fullName>
        <description>CTR Change Credit Condition: Request FA S/H Select Committee</description>
        <protected>false</protected>
        <recipients>
            <field>OwnersSectionHead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXChangeCreditConditionRequestFASHSelectComiittee</template>
    </alerts>
    <alerts>
        <fullName>CTRChangeCreditConditionSendEmailToCommittee</fullName>
        <description>CTR Change Credit Condition: Send Email to Committee</description>
        <protected>false</protected>
        <recipients>
            <field>CommitteeOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXChangeCreditConditionCommitteeApproval</template>
    </alerts>
    <alerts>
        <fullName>CTRChangeCreditCondition_RequestFASHSelectCommittee</fullName>
        <description>CTR Change Credit Condition: Request FA S/H Select Committee</description>
        <protected>false</protected>
        <recipients>
            <field>OwnersSectionHead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXChangeCreditConditionRequestFASHSelectComiittee</template>
    </alerts>
    <alerts>
        <fullName>CTRLABIXEditCustomerInformTraderAfterSHApproved</fullName>
        <description>CTR LABIX Edit Customer Inform Trader After SH Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTOPEditCustomerInformTraderAfterSHApproval</template>
    </alerts>
    <alerts>
        <fullName>CTRLABIXEditCustomerInformTraderAfterSHRejected</fullName>
        <description>CTR LABIX Edit Customer Inform Trader After SH Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTOPEditCustomerInformTraderAfterSHApproval</template>
    </alerts>
    <alerts>
        <fullName>CTRTOPEditCustomerInformTraderAfterSHApproved</fullName>
        <description>CTR TOP Edit Customer Inform Trader After SH Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTOPEditCustomerInformTraderAfterSHApproval</template>
    </alerts>
    <alerts>
        <fullName>CTRTOPEditCustomerInformTraderAfterSHRejected</fullName>
        <description>CTR TOP Edit Customer Inform Trader After SH Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTOPEditCustomerInformTraderAfterSHApproval</template>
    </alerts>
    <alerts>
        <fullName>CTRTXEditCustomerInformRelevantUserAfterMasterControllerDataApproved</fullName>
        <description>CTR TX Edit Customer Inform Relevant User After MasterControllerData Approved</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXEditCustomerInformationMDCMApproval</template>
    </alerts>
    <alerts>
        <fullName>CTRTXEditCustomerInformRelevantUserAfterMasterControllerDataManagerRejected</fullName>
        <description>CTR TX Edit Customer Inform Relevant User After MasterControllerData Manager Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>TraderTeamEmail__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXEditCustomerInformationReadyUpdate</template>
    </alerts>
    <alerts>
        <fullName>CTRTXEditCustomerInformTraderAfterMDCMReject</fullName>
        <description>CTR TX Edit Customer Inform Trader After MDCM Reject</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXEditCustomerInformationMDCMRejectionforSensitiveField</template>
    </alerts>
    <alerts>
        <fullName>CTRTXEditCustomerInformTraderAfterSHApproved</fullName>
        <description>CTR TX Edit Customer Inform Trader After SH Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTOPEditCustomerInformTraderAfterSHApproval</template>
    </alerts>
    <alerts>
        <fullName>CTRTXEditCustomerInformTraderAfterSHRejected</fullName>
        <description>CTR TX Edit Customer Inform Trader After SH Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTOPEditCustomerInformTraderAfterSHApproval</template>
    </alerts>
    <alerts>
        <fullName>EmailApproved</fullName>
        <description>EmailApproved</description>
        <protected>false</protected>
        <recipients>
            <field>CreditOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRFinancialSHApproved</template>
    </alerts>
    <alerts>
        <fullName>EmailApprovedtoTrader</fullName>
        <description>EmailApprovedtoTrader</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>OwnersCMVP__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>OwnersSectionHead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTOPEditInfoApprovetoTrader</template>
    </alerts>
    <alerts>
        <fullName>EmailRejected</fullName>
        <description>EmailRejected</description>
        <protected>false</protected>
        <recipients>
            <field>CreditOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRInformTXFASHCaseReject</template>
    </alerts>
    <alerts>
        <fullName>EmailRejecttoTrader</fullName>
        <description>EmailRejecttoTrader</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRInformEditInfoCaseRejecttoTrader</template>
    </alerts>
    <alerts>
        <fullName>InformRelevantUserAfterMDCMDecision</fullName>
        <description>Inform Relevant User After MDCM Decision</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXEditSupplierInformationReadyUpdate</template>
    </alerts>
    <alerts>
        <fullName>InformSummaryReport</fullName>
        <description>Inform Summary Report</description>
        <protected>false</protected>
        <recipients>
            <field>CreditOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>OwnersCMVP__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>OwnersSectionHead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXChangeCreditConditionInformSumReport</template>
    </alerts>
    <alerts>
        <fullName>InformTraderAfterSectionHeadDecision</fullName>
        <description>Inform Trader After Section Head Decision</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTREditInformationInformTraderAfterSHApproval</template>
    </alerts>
    <alerts>
        <fullName>RequestEditInfoEmail</fullName>
        <description>RequestEditInfoEmail</description>
        <protected>false</protected>
        <recipients>
            <field>CreditOwnerSectionHead__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>CreditOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>CTREmailTemplate/CTRTXRequesttoEditInfo</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Case_Reject_FALB</fullName>
        <description>Send Email to Case Reject FALB</description>
        <protected>false</protected>
        <recipients>
            <field>CreditOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRInformFALBSHCaseReject</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Case_Reject_TRCR</fullName>
        <description>Send Email to Case Reject TRCR</description>
        <protected>false</protected>
        <recipients>
            <field>CreditOwnerSectionHead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRInformTRCRSHCaseReject</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Case_approved_FALB</fullName>
        <description>Send Email to Case approved FALB</description>
        <protected>false</protected>
        <recipients>
            <field>CreditOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRInformFALBSHCaseApproved</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Case_approved_TRCR</fullName>
        <description>Send Email to Case approved TRCR</description>
        <protected>false</protected>
        <recipients>
            <field>CreditOwnerSectionHead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRInformTRCRSHCaseApproved</template>
    </alerts>
    <alerts>
        <fullName>TXCreateEditShipToInformMDCAfterMDCMApproveforNonSensitive</fullName>
        <description>TX Create/Edit Ship-To Inform MDC After MDCM Approve for Non Sensitive</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXCreateEditShipToInformMDCafterMDCMApproveNonSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXCreateEditShipToInformMDCAfterMDCMApproveforSensitive</fullName>
        <description>TX Create/Edit Ship-To Inform MDC After MDCM Approve for Sensitive</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXCreateEditShipToInformMDCafterMDCMApproveSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXCreateEditShipToInformMDCAfterMDCMRejectedforNonSensitiveField</fullName>
        <description>TX Create/Edit Ship-To Inform MDC After MDCM Rejected for Non Sensitive</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXCreateEditShipToInformMDCafterMDCMRejectNonSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXCreateEditShipToInformMDCAfterMDCMRejectedforSensitiveField</fullName>
        <description>TX Create/Edit Ship-To Inform MDC After MDCM Rejected for Sensitive</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>OwnersCMVP__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>OwnersSectionHead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXCreateEditShipToInformRelatedUserafterMDCMRejectSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXCreateEditShipToInformTraderforApprovalNonSensitive</fullName>
        <description>TX Create/Edit Ship-To: Inform Trader for Approval Non Sensitive</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXCreateEditShipToInformTraderforApprovalNonSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXCreateEditShipToInformTraderforApprovalSensitive</fullName>
        <description>TX Create/Edit Ship-To: Inform Trader for Approval Sensitive</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXCreateEditShipToInformTraderforApprovalSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXCreateShipToInformMDCAfterMDCMApproval</fullName>
        <description>TX Create Ship-To Inform MDC After MDCM Approval</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXCreateShipToMDCMApproval</template>
    </alerts>
    <alerts>
        <fullName>TXCreateShipToInformMDCAfterMDCMRejectedforNonSensitiveField</fullName>
        <description>TX Create Ship-To Inform MDC After MDCM Rejected for Non Sensitive Field</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXCreateShipToMDCMRejectionforNonSensitiveField</template>
    </alerts>
    <alerts>
        <fullName>TXCreateShipToInformMDCAfterSHApproved1</fullName>
        <description>TX Create Ship-To: Inform MDC After SH Approved</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXCreateShipToSHApproval</template>
    </alerts>
    <alerts>
        <fullName>TXCreateShipToInformTraderAfterMDCMRejectedforSensitiveField</fullName>
        <description>TX Create Ship-To Inform Trader After MDCM Rejected for Sensitive Field</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXCreateShipToMDCMRejectionforSensitiveField</template>
    </alerts>
    <alerts>
        <fullName>TXCreateShipToInformTraderAfterSHRejected1</fullName>
        <description>TX Create Ship-To: Inform Trader After SH Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXCreateShipToSHRejection</template>
    </alerts>
    <alerts>
        <fullName>TXEditInfoInformMDCafterMDCMApproveNonSensitive</fullName>
        <description>TX Edit Info: Inform MDC after MDCM Approve Non Sensitive</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXEditInfoInformMDCafterMDCMApproveNonSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXEditInfoInformMDCafterMDCMApproveSensitive</fullName>
        <description>TX Edit Info: Inform MDC after MDCM Approve Sensitive</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXEditInfoInformMDCafterMDCMApproveSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXEditInfoInformMDCafterMDCMRejectNonSensitive</fullName>
        <description>TX Edit Info: Inform MDC after MDCM Reject Non Sensitive</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXEditInfoInformMDCafterMDCMRejectNonSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXEditInfoInformRelatedUserafterMDCMRejectSensitive</fullName>
        <description>TX Edit Info: Inform Related User after MDCM Reject Sensitive</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>OwnersCMVP__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>OwnersSectionHead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXEditInfoInformRelatedUserafterMDCMRejectSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXEditInfoInformTraderforApprovalNonSensitive</fullName>
        <description>TX Edit Info: Inform Trader for Approval Non Sensitive</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXEditInfoInformTraderforApprovalNonSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXEditInfoInformTraderforApprovalSensitive</fullName>
        <description>TX Edit Info: Inform Trader for Approval Sensitive</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXEditInfoInformTraderforApprovalSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXEditShipToInformMDCAfterMDCMApproval</fullName>
        <description>TX Edit Ship-To Inform MDC After MDCM Approval</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXEditShipToMDCMApproval</template>
    </alerts>
    <alerts>
        <fullName>TXEditShipToInformMDCAfterSHApproved</fullName>
        <description>TX Edit Ship-To: Inform MDC After SH Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXEditShipToSHApprove</template>
    </alerts>
    <alerts>
        <fullName>TXEditShipToInformMDCAfter_MDCM_RejectedforNonSensitiveField</fullName>
        <description>TX Edit Ship-To Inform MDC After MDCM Rejected for Non Sensitive Field</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXEditShipToMDCMRejectionforNonSensitiveField</template>
    </alerts>
    <alerts>
        <fullName>TXEditShipToInformTraderAfterSHRejected</fullName>
        <description>TX Edit Ship-To: Inform Trader After SH Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXEditShipToSHReject</template>
    </alerts>
    <alerts>
        <fullName>TXEditShipToInformTraderAfter_MDCMRejectedforSensitiveField</fullName>
        <description>TX Edit Ship-To Inform Trader After MDCM Rejected for Sensitive Field</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXEditShipToMDCMRejectionforSensitiveField</template>
    </alerts>
    <alerts>
        <fullName>TXInitialCustomerInformMDCAfterMDCMApproval</fullName>
        <description>TX Initial Customer Inform MDC After MDCM Approval</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXInitialCustomerInformationMDCMApproval</template>
    </alerts>
    <alerts>
        <fullName>TXInitialCustomerInformMDCAfterMDCMRejectedforNonSensitiveField2</fullName>
        <description>TX Initial Customer Inform MDC After MDCM Rejected for Non Sensitive Field</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXInitialCustomerInformationMDCMRejectionforNonSensitiveField</template>
    </alerts>
    <alerts>
        <fullName>TXInitialCustomerInformTraderAfterMDCMRejectedforSensitiveField</fullName>
        <description>TX Initial Customer Inform Trader After MDCM Rejected for Sensitive Field</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXInitialCustomerInformationMDCMRejectionforSensitiveField</template>
    </alerts>
    <alerts>
        <fullName>TXInitialExtendInformMDCafterMDCMApproveNonSensitive</fullName>
        <description>TX Initial/Extend: Inform MDC after MDCM Approve Non Sensitive</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXInitialExtendInformMDCafterMDCMApproveNonSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXInitialExtendInformMDCafterMDCMApproveSensitive</fullName>
        <description>TX Initial/Extend: Inform MDC after MDCM Approve Sensitive</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXInitialExtendInformMDCafterMDCMApproveSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXInitialExtendInformMDCafterMDCMRejectNonSensitive</fullName>
        <description>TX Initial/Extend: Inform MDC after MDCM Reject Non Sensitive</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXInitialExtendInformMDCafterMDCMRejectNonSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXInitialExtendInformRelatedUserafterMDCMRejectSensitive</fullName>
        <description>TX Initial/Extend: Inform Related User after MDCM Reject Sensitive</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>OwnersCMVP__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>OwnersSectionHead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXInitialExtendInformRelatedUserafterMDCMRejectSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXInitialExtendInformTraderforApprovalNonSensitive</fullName>
        <description>TX Initial/Extend: Inform Trader for Approval Non Sensitive</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>MDCMngName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXInitialExtendInformTraderforApprovalNonSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXInitialExtendInformTraderforApprovalSensitive</fullName>
        <description>TX Initial/Extend: Inform Trader for Approval Sensitive</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>MDCMngName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/TXInitialExtendInformTraderforApprovalSensitive</template>
    </alerts>
    <alerts>
        <fullName>TXInitialSupplierInformMDCAfterMDCMApproval</fullName>
        <description>TX Initial Supplier Inform MDC After MDCM Approval</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXInitialSupplierInformationMDCMApproval</template>
    </alerts>
    <alerts>
        <fullName>TXInitialSupplierInformMDCAfterMDCMRejectedforNonSensitiveField</fullName>
        <description>TX Initial Supplier Inform MDC After MDCM Rejected for Non Sensitive Field</description>
        <protected>false</protected>
        <recipients>
            <field>MDCName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXInitialSupplierInformationMDCMRejectionforNonSensitiveField</template>
    </alerts>
    <alerts>
        <fullName>TXInitialSupplierInformTraderAfterMDCMRejectedforSensitiveField</fullName>
        <description>TX Initial Supplier Inform Trader After MDCM Rejected for Sensitive Field</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTREmailTemplate/CTRTXInitialSupplierInformationMDCMRejectionforSensitiveField</template>
    </alerts>
    <fieldUpdates>
        <fullName>ApprovalStepChangeToReject</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Step Change To Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ApprovalStepChangeToWaitingForAppr</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Waiting for Approval</literalValue>
        <name>Approval Step Change To Waiting for Appr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ClearChangeCounterPartyValue</fullName>
        <field>ChangedCounterParty__c</field>
        <literalValue>0</literalValue>
        <name>ClearChangeCounterPartyValue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MDCMApprovalStatusToApprove</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>MDCM Approval Status to Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHApprove</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>S/H Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SHReject</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>S/H Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SectionHeadApprove</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Section Head Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SectionHeadReject</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Section Head Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StatusChangeToApprovalIsInProgress</fullName>
        <field>Status__c</field>
        <literalValue>Approval In Progress</literalValue>
        <name>Status Change to Approval is in Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep1</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Waiting for Approval</literalValue>
        <name>Update Approval Step 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep2</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval Step 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep_CreEdtShipToNonSens</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Inform Counterparty</literalValue>
        <name>Update Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep_CreateEditShipTo</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Open</literalValue>
        <name>Update Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep_EditInfoNonSensitive</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Inform Counterparty</literalValue>
        <name>Update Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep_EditInfoSensitive</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Open</literalValue>
        <name>Update Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalStep_InExSensitive</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Open</literalValue>
        <name>Update Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovedNotifyCustomAction</fullName>
        <field>NotifyCustomAction__c</field>
        <literalValue>Approved Send to SAP</literalValue>
        <name>UpdateApprovedNotifyCustomAction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCounterPartyChangedCTReject</fullName>
        <field>ChangedCounterParty__c</field>
        <literalValue>0</literalValue>
        <name>UpdateCounterPartyChangedCTReject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCounterPartyStatus</fullName>
        <field>ApprovedChangeCounterparty__c</field>
        <literalValue>Submitted</literalValue>
        <name>UpdateCounterPartyStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCounterPartyStatusApprove</fullName>
        <field>ApprovedChangeCounterparty__c</field>
        <literalValue>Approved</literalValue>
        <name>UpdateCounterPartyStatusApprove</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCounterPartyStatusReject</fullName>
        <field>ApprovedChangeCounterparty__c</field>
        <literalValue>Rejected</literalValue>
        <name>UpdateCounterPartyStatusReject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateEditSTFieldApprovalSteptoRejected</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Approval Step to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateEditShipToFieldApprovalSteptoOpen</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Open</literalValue>
        <name>Update Field Approval Step to Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateEditShipToFieldMDCMStatusApproved</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Field MDCM Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateEditShipToFieldMDCMStatusRejected</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>RejectedSen</literalValue>
        <name>Update Field MDCM Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateEditShipToFieldMDCMStatusRejected2</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>RejectedNon</literalValue>
        <name>Update Field MDCM Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateEditShipToFieldRequestStatusNew</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Update Field Request Status New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalStep</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Field Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalStep1</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Field Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalStep2</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Approval Step 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalStep2_1</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Approval Step 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalSteptoApproved</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Field Approval Step to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalSteptoInform</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Inform Counterparty</literalValue>
        <name>Update Field Approval Step to Inform</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalSteptoInform2</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Inform Counterparty</literalValue>
        <name>Update Field Approval Step to Inform</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalSteptoOpen</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Open</literalValue>
        <name>Update Field Approval Step to Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalSteptoRejected</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Approval Step to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalSteptoRejected2</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Approval Step to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldApprovalSteptoWaiting</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Waiting for Approval</literalValue>
        <name>Update Field Approval Step to Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldMDCMStatusApproved</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Field MDCM Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldMDCMStatusRejected2</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>RejectedNon</literalValue>
        <name>Update Field MDCM Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldRequestStatus</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Request Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldRequestStatusApproved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Field Request Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldRequestStatusApproved1</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Field Request Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldRequestStatusInReview</fullName>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Update Field Request Status In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldRequestStatusNew</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Update Field Request Status New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldRequestStatusRejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Request Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldRequestStatusRejected1</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Request Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldStatus</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Field Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldStatus1</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Field Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldStatus2</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Status 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldStatus2_2</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Status 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldStatustoApproved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Field Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldStatustoRejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Field Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusReject_CreEdtNonSens</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>RejectedNon</literalValue>
        <name>Update MDCM Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusReject_CreateEditShipTo</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>RejectedSen</literalValue>
        <name>Update MDCM Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusReject_EditInfoNonSens</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>RejectedNon</literalValue>
        <name>Update MDCM Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusReject_EditInfoSensitive</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>RejectedSen</literalValue>
        <name>Update MDCM Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusReject_InExNonSensitive</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>RejectedNon</literalValue>
        <name>Update MDCM Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusReject_InExSensitive</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>RejectedSen</literalValue>
        <name>Update MDCM Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusToRejectSensitive</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>RejectedSen</literalValue>
        <name>Update MDCM Status to Reject Sensitive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusWaiting_CreEdtShipNonSen</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Waiting for Approval</literalValue>
        <name>Update MDCM Status Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusWaiting_CreEdtShipSens</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Waiting for Approval</literalValue>
        <name>Update MDCM Status Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusWaiting_EditInfSensitive</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Waiting for Approval</literalValue>
        <name>Update MDCM Status Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusWaiting_EditInfoNonSens</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Waiting for Approval</literalValue>
        <name>Update MDCM Status Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusWaiting_InExNonSense</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Waiting for Approval</literalValue>
        <name>Update MDCM Status Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatusWaiting_InExSensitive</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Waiting for Approval</literalValue>
        <name>Update MDCM Status Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatustoApprove_CreEdtShipNonS</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Update MDCM Status to Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatustoApproved_CreatEditShip</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Update MDCM Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatustoApproved_EditInfNonSen</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Update MDCM Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatustoApproved_EditInfoSens</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Update MDCM Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatustoApproved_InExNonSens</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Update MDCM Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMDCMStatustoApproved_InExSens</fullName>
        <field>MDCMApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Update MDCM Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateNotifyCustomAction</fullName>
        <field>NotifyCustomAction__c</field>
        <literalValue>Send to SAP</literalValue>
        <name>UpdateNotifyCustomAction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRejectedNotifyCustomAction</fullName>
        <field>NotifyCustomAction__c</field>
        <literalValue>Rejected Send to SAP</literalValue>
        <name>UpdateRejectedNotifyCustomAction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRequestStatus</fullName>
        <field>Status__c</field>
        <literalValue>Approval In Progress</literalValue>
        <name>Update Request Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStatus_CreateEditShipTo</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStatus_EditInfoNonSensitive</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStatus_EditInfoSensitive</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStatus_InExSensitive</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Change_Approval</fullName>
        <field>ApprovedChangeCounterparty__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Change Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Field</fullName>
        <field>ApprovedCounterParty__c</field>
        <literalValue>1</literalValue>
        <name>Update Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
