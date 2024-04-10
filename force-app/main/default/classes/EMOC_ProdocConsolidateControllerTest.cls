@isTest
public class EMOC_ProdocConsolidateControllerTest {
    
    @testSetup
    static void setupData() {
        PRODOCIntegration__c setting = new PRODOCIntegration__c();
        setting.Endpoint__c = 'https://dprodoc.thaioilgroup.com/prodocEmoc/api/v1/EMOC/ConsolidateComment';
        setting.Method__c = 'POST';
        setting.API_Key__c  = '1234';
        setting.Content_Type__c = 'application/json;charset=utf-8';
        setting.Heap_Limit__c = 1000000;
        setting.Callout_Timeout__c = 120000;
        insert setting;
        
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
        	new ContentVersion(Title = 'File1', PathOnClient = 'File1.txt', VersionData = Blob.valueOf('File1'), IsMajorVersion = true),
            new ContentVersion(Title = 'File2', PathOnClient = 'File2.txt', VersionData = Blob.valueOf('File2'), IsMajorVersion = true)
        };
        insert cvList;
        
        Set<Id> cvIds = new Set<Id>();
        for(ContentVersion cv : cvList) {
            cvIds.add(cv.Id);
        }
        cvList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cvIds];
        
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink> {
            new ContentDocumentLink(LinkedEntityId = eMocDD.Id, ContentDocumentId = cvList.get(0).ContentDocumentId, ShareType = 'V'),
            new ContentDocumentLink(LinkedEntityId = eMocDF.Id, ContentDocumentId = cvList.get(1).ContentDocumentId, ShareType = 'V')
        };
        insert cdlList;
    }
    
    @isTest
    static void getOptions() {
        E_MOC_Application__c eMocApp = [SELECT Id FROM E_MOC_Application__c LIMIT 1];
        
        Test.startTest();
        List<Map<String, Object>> results = EMOC_ProdocConsolidateController.getOptions(eMocApp.Id);
        Test.stopTest();
    }
    
    @isTest
    static void retrieveData() {
        E_MOC_Application__c eMocApp = [SELECT Id FROM E_MOC_Application__c LIMIT 1];
        
        Test.startTest();
        Map<String, Object> result = EMOC_ProdocConsolidateController.retrieveData('E_MOC_Attachment_Detail_design__c', eMocApp.Id);
        Test.stopTest();
    }
    
    @isTest
    static void prepareToConsolidate() {
        E_MOC_Application__c eMocApp = [SELECT Id FROM E_MOC_Application__c LIMIT 1];
        Map<String, Object> eMocDDMap = EMOC_ProdocConsolidateController.retrieveData('E_MOC_Attachment_Detail_design__c', eMocApp.Id);
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStatusCode(200);
        mock.setStaticResource('PRODOC_EMOCResponse');
        
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String selectedData = JSON.serialize(eMocDDMap.get('data'));
        Map<String, Object> result = EMOC_ProdocConsolidateController.prepareToConsolidate(selectedData, eMocApp.Id);
        Test.stopTest();
    }

}