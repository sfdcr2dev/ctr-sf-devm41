/* Class for ContentDocumentLink (CPEM) */
public with sharing class CPEM_ContentDocumentLinkHandler {

    public static void handleUploadContentDocumentLink(List<ContentDocumentLink> documentLinks) {
        
    	string BaseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        Set<Id> LinkedEntityId = getLinkedEntityId(documentLinks);
        
        if(LinkedEntityId.size() > 0) {
            for(Id entityId : LinkedEntityId) {
                
                if (isSameSObjectType(entityId, Schedule_WBS__c.getSObjectType())) {
                    Schedule_WBS__c swbs = new Schedule_WBS__c(Id = entityId);
                    swbs.URL__c = BaseUrl + 'lightning/r/' + swbs.Id + '/related/AttachedContentDocuments/view';
                    update(swbs);
                }
                else if (isSameSObjectType(entityId, ITB_with_Sub_Contract__c.getSObjectType())) {
                    ITB_with_Sub_Contract__c ITB10 = new ITB_with_Sub_Contract__c(Id = entityId);
                    ITB10.ITB_Engineering_URL__c = BaseUrl + 'lightning/r/' + ITB10.Id + '/related/AttachedContentDocuments/view';
                    update(ITB10);
                    
                    ITB_with_Sub_Contract_18__c ITB18 = getITB18(ITB10.Id);
                    ITB18.ITB_Engineering_URL__c = BaseUrl + 'lightning/r/' + ITB10.Id + '/related/AttachedContentDocuments/view';
            		update(ITB18);
                }
                else if (isSameSObjectType(entityId, ITB_with_Sub_Contract_18__c.getSObjectType())) {
                    ITB_with_Sub_Contract_18__c ITB18 = new ITB_with_Sub_Contract_18__c(Id = entityId);
                    ITB18.ITB_Construction_URL__c = BaseUrl + 'lightning/r/' + ITB18.Id + '/related/AttachedContentDocuments/view';
                    update(ITB18);
                    
                    ITB_with_Sub_Contract__c ITB10 = getITB10(ITB18.Id);
                    ITB10.ITB_Construction_URL__c = BaseUrl + 'lightning/r/' + ITB18.Id + '/related/AttachedContentDocuments/view';
            		update(ITB10);
                }
                else if (isSameSObjectType(entityId, CCE_with_Sub_Contract__c.getSObjectType())) {
                    CCE_with_Sub_Contract__c CCE11 = new CCE_with_Sub_Contract__c(Id = entityId);
                    CCE11.CCE_Engineering_URL__c = BaseUrl + 'lightning/r/' + CCE11.Id + '/related/AttachedContentDocuments/view';
                    update(CCE11);
                    
                    CCE_with_Sub_Contract_19__c CCE19 = getCCE19(CCE11.Id);
                    CCE19.CCE_Engineering_URL__c = BaseUrl + 'lightning/r/' + CCE11.Id + '/related/AttachedContentDocuments/view';
            		update(CCE19);
                }
                else if (isSameSObjectType(entityId, CCE_with_Sub_Contract_19__c.getSObjectType())) {
                    CCE_with_Sub_Contract_19__c CCE19 = new CCE_with_Sub_Contract_19__c(Id = entityId);
                    CCE19.CCE_Construction_URL__c = BaseUrl + 'lightning/r/' + CCE19.Id + '/related/AttachedContentDocuments/view';
                    update(CCE19);
                    
                    CCE_with_Sub_Contract__c CCE11 = getCCE11(CCE19.Id);
                    CCE11.CCE_Construction_URL__c = BaseUrl + 'lightning/r/' + CCE19.Id + '/related/AttachedContentDocuments/view';
            		update(CCE11);
                }
                else if (isSameSObjectType(entityId, Cost_Estimate_With_MTO_BOQ__c.getSObjectType())) {
                    Cost_Estimate_With_MTO_BOQ__c mtoboq = [select id, Cost_Estimate__c, Cost_Estimate__r.Project__c from Cost_Estimate_With_MTO_BOQ__c where Id =: entityId];
                    mtoboq.MTO_and_BOQ_File__c = BaseUrl + 'lightning/r/' + mtoboq.Id + '/related/AttachedContentDocuments/view';
                    update(mtoboq);
                    
                    string projectId = mtoboq.Cost_Estimate__r.Project__c;
                    System.debug('Project Id : ' + projectId);
                    
                    Close_Out_Database__c WP31 = getWP31(projectId);
                    WP31.BE_Cost_Estimate_File__c = BaseUrl + 'lightning/r/' + mtoboq.Cost_Estimate__c + '/related/Cost_Estimate_With_MTO_BOQ__r/view';
            		update(WP31);
                }
                else if (isSameSObjectType(entityId, Vendor_Data_Management_with_Equipment__c.getSObjectType())) {
                    Vendor_Data_Management_with_Equipment__c vdme = new Vendor_Data_Management_with_Equipment__c(Id = entityId);
                    vdme.Vendor_Data_File__c  = BaseUrl + 'lightning/r/' + vdme.Id + '/related/AttachedContentDocuments/view';
            		update(vdme);
                }
                else if (isSameSObjectType(entityId, Model_3D__c.getSObjectType())) {
                    Model_3D__c model = new Model_3D__c(Id = entityId);
                    model.URL__c = BaseUrl + 'lightning/r/' + model.Id + '/related/AttachedContentDocuments/view';
                	update(model);
                }                
                
            }
        }
        
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
    
    private static ITB_with_Sub_Contract__c getITB10(Id ITB18Id) {
        return [SELECT Id, BE_ITB_Subcontract_18_ID__c, ITB_Construction_URL__c FROM ITB_with_Sub_Contract__c WHERE BE_ITB_Subcontract_18_ID__c =: ITB18Id];
    }
    
    private static ITB_with_Sub_Contract_18__c getITB18(Id ITB10Id) {
        return [SELECT Id, BE_ITB_Subcontract_10_ID__c, ITB_Engineering_URL__c FROM ITB_with_Sub_Contract_18__c WHERE BE_ITB_Subcontract_10_ID__c =: ITB10Id];
    }
    
    private static CCE_with_Sub_Contract__c getCCE11(Id CCE19Id) {
        return [SELECT Id, BE_Sub_Contract_19_ID__c, CCE_Construction_URL__c FROM CCE_with_Sub_Contract__c WHERE BE_Sub_Contract_19_ID__c =: CCE19Id];
    }
    
    private static CCE_with_Sub_Contract_19__c getCCE19(Id CCE11Id) {
        return [SELECT Id, BE_Sub_Contract_11_ID__c, CCE_Engineering_URL__c FROM CCE_with_Sub_Contract_19__c WHERE BE_Sub_Contract_11_ID__c =: CCE11Id];
    }
    
    private static Close_Out_Database__c getWP31(Id ProjectId) {
        return [SELECT Id, Project__c, BE_Cost_Estimate_File__c FROM Close_Out_Database__C WHERE Project__c =: ProjectId];
    }
    
}