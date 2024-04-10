/* Class for ContentDocument (CPEM) */
public with sharing class CPEM_ContentDocumentHandler {

    public static void handleDeleteContentDocument(List<ContentDocument> documents) {
        
        Set<Id> ContentDocumentIds = getContentDocumentId(documents);
        List<ContentDocumentLink> ContentDocumentLinks = getContentDocumentLinks(ContentDocumentIds);
        Set<Id> ContentDocumentLinkIds = getLinkedEntityId(ContentDocumentLinks);
        
        if(ContentDocumentLinkIds.size() > 0) {
            for(Id entityId : ContentDocumentLinkIds) {
                
                if (isSameSObjectType(entityId, Schedule_WBS__c.getSObjectType())) {
                    Schedule_WBS__c swbs = getScheduleWBS(entityId);
                    if( swbs.ContentDocumentLinks.size() == 1 ) {
                        swbs.URL__c = null;
                        update(swbs);
                    }
                }
                else if (isSameSObjectType(entityId, ITB_with_Sub_Contract__c.getSObjectType())) {
                    ITB_with_Sub_Contract__c ITB10 = getITB10(entityId);
                    if( ITB10.ContentDocumentLinks.size() == 1 ) {
                        ITB10.ITB_Engineering_URL__c = null;
                        update(ITB10);
                        
                        ITB_with_Sub_Contract_18__c ITB18 = getITB18FromITB10(ITB10.Id);
                        ITB18.ITB_Engineering_URL__c = null;
                        update(ITB18);
                        
                    }
                }
                else if (isSameSObjectType(entityId, ITB_with_Sub_Contract_18__c.getSObjectType())) {
                    ITB_with_Sub_Contract_18__c ITB18 = getITB18(entityId);
                    if( ITB18.ContentDocumentLinks.size() == 1 ) {
                        ITB18.ITB_Construction_URL__c = null;
                        update(ITB18);
                        
                        ITB_with_Sub_Contract__c ITB10 = getITB10FromITB18(ITB18.Id);
                        ITB10.ITB_Construction_URL__c = null;
                        update(ITB10);
                        
                    }
                }
                else if (isSameSObjectType(entityId, CCE_with_Sub_Contract__c.getSObjectType())) {
                    CCE_with_Sub_Contract__c CCE11 = getCCE11(entityId);
                    if( CCE11.ContentDocumentLinks.size() == 1 ) {
                        CCE11.CCE_Engineering_URL__c = null;
                        update(CCE11);
                        
                        CCE_with_Sub_Contract_19__c CCE19 = getCCE19FromCCE11(CCE11.Id);
                        CCE19.CCE_Engineering_URL__c = null;
                        update(CCE19);
                        
                    }
                }
                else if (isSameSObjectType(entityId, CCE_with_Sub_Contract_19__c.getSObjectType())) {
                    CCE_with_Sub_Contract_19__c CCE19 = getCCE19(entityId);
                    if( CCE19.ContentDocumentLinks.size() == 1 ) {
                        CCE19.CCE_Construction_URL__c = null;
                        update(CCE19);
                        
                        CCE_with_Sub_Contract__c CCE11 = getCCE11FromCCE19(CCE19.Id);
                        CCE11.CCE_Construction_URL__c = null;
                        update(CCE11);
                        
                    }
                }
                else if (isSameSObjectType(entityId, Cost_Estimate_With_MTO_BOQ__c.getSObjectType())) {
                    Cost_Estimate_With_MTO_BOQ__c mtoboq = getMTOBOQ(entityId);
                    if( mtoboq.ContentDocumentLinks.size() == 1 ) {
                        mtoboq.MTO_and_BOQ_File__c = null;
                        update(mtoboq);
                        
                        string projectId = mtoboq.Cost_Estimate__r.Project__c;
                        
                        Close_Out_Database__c cod = getWP31(projectId);
                        cod.BE_Cost_Estimate_File__c = null;
                        update(cod);
                    }
                }
                else if (isSameSObjectType(entityId, Vendor_Data_Management_with_Equipment__c.getSObjectType())) {
                    Vendor_Data_Management_with_Equipment__c vdme = getVDME(entityId);
                    if( vdme.ContentDocumentLinks.size() == 1 ) {
                        vdme.Vendor_Data_File__c = null;
                        update(vdme);
                    }
                }
                else if (isSameSObjectType(entityId, Model_3D__c.getSObjectType())) {
                    Model_3D__c model = getModel(entityId);
                    if( model.ContentDocumentLinks.size() == 1 ) {
                        model.URL__c = null;
                        update(model);
                    }
                }                
                
            }
        }
        
    }
    
    private static Set<Id> getContentDocumentId(List<ContentDocument> documents) {
        
    	Set<ID> ContentDocumentIds = new Set<ID>();
        
        for ( ContentDocument cd : documents ) {
            ContentDocumentIds.add(cd.id);
        }
        
        return ContentDocumentIds;
        
    }
    
    private static Set<Id> getLinkedEntityId(List<ContentDocumentLink> documentLinks) {
        
    	Set<ID> ParentIds = new Set<ID>();
        
        for ( ContentDocumentLink cdl : documentLinks ) {
            ParentIds.add(cdl.LinkedEntityId);
        }
        
        return ParentIds;
        
    }
    
    private static Boolean isSameSObjectType(Id entityId, SObjectType objectType) {
        return entityId.getSobjectType() == objectType;
    }
    
    private static Schedule_WBS__c getScheduleWBS(Id WBSId) {
        return [SELECT Id, BE_WBS_Detail_ID__c, ( SELECT Id FROM ContentDocumentLinks ) FROM Schedule_WBS__c WHERE ID =: WBSId];
    }
    
    private static ITB_with_Sub_Contract__c getITB10(Id ITB10Id) {
        return [SELECT Id, BE_ITB_Subcontract_18_ID__c , ( SELECT Id FROM ContentDocumentLinks) FROM ITB_with_Sub_Contract__c WHERE ID =: ITB10Id];
    }
    
    private static ITB_with_Sub_Contract__c getITB10FromITB18(Id ITB18Id) {
        return [SELECT Id, BE_ITB_Subcontract_18_ID__c , ( SELECT Id FROM ContentDocumentLinks) FROM ITB_with_Sub_Contract__c WHERE BE_ITB_Subcontract_18_ID__c =: ITB18Id];
    }
    
    private static ITB_with_Sub_Contract_18__c getITB18(Id ITB18Id) {
        return [SELECT Id, BE_ITB_Subcontract_10_ID__c , ( SELECT Id FROM ContentDocumentLinks) FROM ITB_with_Sub_Contract_18__c WHERE Id =: ITB18Id];
    }
    
    private static ITB_with_Sub_Contract_18__c getITB18FromITB10(Id ITB10Id) {
        return [SELECT Id, BE_ITB_Subcontract_10_ID__c , ( SELECT Id FROM ContentDocumentLinks) FROM ITB_with_Sub_Contract_18__c WHERE BE_ITB_Subcontract_10_ID__c =: ITB10Id];
    }
    
    private static CCE_with_Sub_Contract__c getCCE11(Id CCE11Id) {
        return [SELECT Id, BE_Sub_Contract_19_ID__c, CCE_Construction_URL__c, ( SELECT Id FROM ContentDocumentLinks ) FROM CCE_with_Sub_Contract__c WHERE Id =: CCE11Id];
    }
    
    private static CCE_with_Sub_Contract__c getCCE11FromCCE19(Id CCE19Id) {
        return [SELECT Id, BE_Sub_Contract_19_ID__c, CCE_Construction_URL__c, ( SELECT Id FROM ContentDocumentLinks ) FROM CCE_with_Sub_Contract__c WHERE BE_Sub_Contract_19_ID__c =: CCE19Id];
    }
    
    private static CCE_with_Sub_Contract_19__c getCCE19(Id CCE19Id) {
        return [SELECT Id, BE_Sub_Contract_11_ID__c, CCE_Engineering_URL__c, ( SELECT Id FROM ContentDocumentLinks ) FROM CCE_with_Sub_Contract_19__c WHERE Id =: CCE19Id];
    }
    
    private static CCE_with_Sub_Contract_19__c getCCE19FromCCE11(Id CCE11Id) {
        return [SELECT Id, BE_Sub_Contract_11_ID__c, CCE_Engineering_URL__c, ( SELECT Id FROM ContentDocumentLinks ) FROM CCE_with_Sub_Contract_19__c WHERE BE_Sub_Contract_11_ID__c =: CCE11Id];
    }
    
    private static Cost_Estimate__c getCE(Id CEId) {
        return [SELECT Id, Project__c, ( SELECT Id FROM ContentDocumentLinks) FROM Cost_Estimate__c WHERE Id =: CEId];
    }
    
    private static Cost_Estimate_With_MTO_BOQ__c getMTOBOQ(Id MTOBOQId) {
        return [SELECT Id, Cost_Estimate__c, Cost_Estimate__r.Project__c, ( SELECT Id FROM ContentDocumentLinks) FROM Cost_Estimate_With_MTO_BOQ__c WHERE Id =: MTOBOQId];
    }
    
    private static Vendor_Data_Management_with_Equipment__c getVDME(Id VDMEId) {
        return [SELECT Id, ( SELECT Id FROM ContentDocumentLinks ) FROM Vendor_Data_Management_with_Equipment__c WHERE Id =: VDMEId];
    }
    
    private static Model_3D__c getModel(Id modelId) {
        return [SELECT Id, ( SELECT Id FROM ContentDocumentLinks ) FROM Model_3D__c WHERE Id =: modelId];
    }
    
    private static Close_Out_Database__c getWP31(Id ProjectId) {
        return [SELECT Id, Project__c, BE_Cost_Estimate_File__c, ( SELECT Id FROM ContentDocumentLinks ) FROM Close_Out_Database__C WHERE Project__c =: ProjectId];
    }
    
    private static List<ContentDocumentLink> getContentDocumentLinks(Set<Id> documentIds) {
        return [SELECT Id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where ContentDocumentId IN :documentIds];
    }
    
}