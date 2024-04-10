public with sharing class CTRCommitteeSendToSapQueueable implements  Queueable{
    CTRRequestFormHeader__c mRequestHeader;
    CTRRequestFormItem__c mRequestItem;
    String mSapType;

    public CTRCommitteeSendToSapQueueable(CTRRequestFormHeader__c mRequestHeader, CTRRequestFormItem__c mRequestItem, String mSapType){
        this.mRequestHeader = mRequestHeader;
        this.mRequestItem = mRequestItem;
        this.mSapType = mSapType;
    }

    public void execute(QueueableContext context) {
        CTRCommitteeSendToSap.CTRCommitteeSendInformationToSap(mRequestHeader,mRequestItem, mSapType);
    }
}