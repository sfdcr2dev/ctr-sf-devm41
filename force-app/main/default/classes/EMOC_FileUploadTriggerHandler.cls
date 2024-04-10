public class EMOC_FileUploadTriggerHandler {
    public static void onAfterUpload(List<ContentVersion> ContentVersionList){
        List<SObject> soListToBeUpdated = new List<SObject>();
        for (ContentVersion cv : ContentVersionList) {
            Id myId = Id.valueOf(cv.FirstPublishLocationId);
            String sobjectName = string.valueOf(myId.getSObjectType());
            if (sobjectName == 'E_MOC_Monitoring_Activity__c') {
                E_MOC_Monitoring_Activity__c obj = new E_MOC_Monitoring_Activity__c();
                obj.Id = myId;
                obj.Attachment__c = true;
                soListToBeUpdated.add(obj);
            } else if (sobjectName == 'E_MOC_Attachment_Detail_design__c') {
                E_MOC_Attachment_Detail_design__c obj = new E_MOC_Attachment_Detail_design__c();
                obj.Id = myId;
                obj.Attachment__c = true;
                soListToBeUpdated.add(obj);
            } else if (sobjectName == 'E_MOC_Attachment_Deviate_form__c') {
                E_MOC_Attachment_Deviate_form__c obj = new E_MOC_Attachment_Deviate_form__c();
                obj.Id = myId;
                obj.Attachment__c = true;
                soListToBeUpdated.add(obj);
            } else if (sobjectName == 'E_MOC_Attachment_Doc_require__c') {
                E_MOC_Attachment_Doc_require__c obj = new E_MOC_Attachment_Doc_require__c();
                obj.Id = myId;
                obj.Attachment__c = true;
                soListToBeUpdated.add(obj);
            } else if (sobjectName == 'E_MOC_Attachment_PSSR_category__c') {
                E_MOC_Attachment_PSSR_category__c obj = new E_MOC_Attachment_PSSR_category__c();
                obj.Id = myId;
                obj.Attachment__c = true;
                soListToBeUpdated.add(obj);
            } else if (sobjectName == 'E_MOC_Attachment_Risk_analysis__c') {
                E_MOC_Attachment_Risk_analysis__c obj = new E_MOC_Attachment_Risk_analysis__c();
                obj.Id = myId;
                obj.Attachment__c = true;
                soListToBeUpdated.add(obj);
            }
        }
        update soListToBeUpdated;
    }
}