@isTest
public class EMOC_FileUploadTriggerTest {
    @isTest static void testGetData(){
        Test.startTest();
        E_MOC_Application__c eMocApp = new E_MOC_Application__c();
        insert eMocApp;
        
        E_MOC_Attachment_Doc_require__c eMocDR = new E_MOC_Attachment_Doc_require__c();
        eMocDR.E_MOC_Application__c = eMocApp.Id;
        eMocDR.E_MOC_Checklist_type__c = 'Plot Plan';
        eMocDR.E_MOC_Doc_Type__c = 'Common document';
        insert eMocDR;
        
        E_MOC_Attachment_Detail_design__c eMocDD = new E_MOC_Attachment_Detail_design__c();
        eMocDD.E_MOC_Application__c = eMocApp.Id;
        eMocDD.E_MOC_Checklist_type__c = 'Plot Plan';
        eMocDD.E_MOC_Doc_Type__c = 'Common document';
        insert eMocDD;
        
        E_MOC_Attachment_Deviate_form__c eMocDF = new E_MOC_Attachment_Deviate_form__c();
        eMocDF.E_MOC_Application__c = eMocApp.Id;
        eMocDF.E_MOC_Checklist_type__c = 'Deviate form';
        eMocDF.E_MOC_Doc_Type__c = 'Deviate form';
        insert eMocDF;
        
        E_MOC_Attachment_PSSR_category__c eMocPC = new E_MOC_Attachment_PSSR_category__c();
        eMocPC.E_MOC_Application__c = eMocApp.Id;
        eMocPC.E_MOC_Checklist_type__c = 'PSSR category';
        eMocPC.E_MOC_Doc_Type__c = 'PSSR category';
        insert eMocPC;
        
        E_MOC_Attachment_Risk_analysis__c eMocRA = new E_MOC_Attachment_Risk_analysis__c();
        eMocRA.E_MOC_Application__c = eMocApp.Id;
        eMocRA.E_MOC_Checklist_type__c = 'HRA Checklist';
        eMocRA.E_MOC_Doc_Type__c = 'Risk analysis';
        insert eMocRA;

        List<ContentVersion> cvList = new List<ContentVersion> {
        	new ContentVersion(Title = 'File1',FirstPublishLocationId = eMocDD.Id, PathOnClient = 'File1.txt', VersionData = Blob.valueOf('File1'), IsMajorVersion = true),
            new ContentVersion(Title = 'File2',FirstPublishLocationId = eMocDF.Id, PathOnClient = 'File2.txt', VersionData = Blob.valueOf('File2'), IsMajorVersion = true),
            new ContentVersion(Title = 'File3',FirstPublishLocationId = eMocDR.Id, PathOnClient = 'File3.txt', VersionData = Blob.valueOf('File3'), IsMajorVersion = true),
            new ContentVersion(Title = 'File4',FirstPublishLocationId = eMocPC.Id, PathOnClient = 'File4.txt', VersionData = Blob.valueOf('File4'), IsMajorVersion = true),
            new ContentVersion(Title = 'File5',FirstPublishLocationId = eMocRA.Id, PathOnClient = 'File5.txt', VersionData = Blob.valueOf('File5'), IsMajorVersion = true)
        };
        insert cvList;
        
        Set<Id> cvIds = new Set<Id>();
        for(ContentVersion cv : cvList) {
            cvIds.add(cv.Id);
        }
        cvList = [SELECT Id, ContentDocumentId,FirstPublishLocationId,OwnerId  FROM ContentVersion WHERE Id = :cvIds];

		List<user> users = [select Id FROM user Limit 1];

        List<ContentDocumentLink> ContentDocumentList = new List<ContentDocumentLink>();
		List<String> ContentDocumentlink = new List<String>();

        for(ContentVersion cv : cvList){
            if(cv.ContentDocumentId != null && !ContentDocumentlink.contains(cv.ContentDocumentId)){
                for(user u:users){
                    if(u.Id != cv.OwnerId){
                        ContentDocumentlink.add(cv.ContentDocumentId);
                        ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId=cv.ContentDocumentId,LinkedEntityId = u.Id,ShareType='V');
                        ContentDocumentList.add(cdl); 
                    }
                }
            }
        }

        insert ContentDocumentList;
        
    	Test.stopTest();
    }
}