/* 
    Author Softever 
    Class for ContentDocumentLink (ICR) 
*/

public with sharing class ICR_ContentDocumentLinkHandler {

    public static void handleUploadContentDocumentLink(List<ContentDocumentLink> documentLinks) {
        
    	string BaseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        Set<Id> LinkedEntityId = getLinkedEntityId(documentLinks);
        
        if(LinkedEntityId.size() > 0) {
            for(Id entityId : LinkedEntityId) {
                
                if (isSameSObjectType(entityId, ICR_Approval__c.getSObjectType())) {
                    
                    ICR_Approval__c ICR = [select id, status__c, be_file_upload__c, File_Url__c from ICR_Approval__c where Id =: entityId];
                    if(!ICR.BE_File_Upload__c) {
                        ICR.BE_File_Upload__c = true;
                        ICR.File_Url__c = BaseUrl + 'lightning/r/' + ICR.Id + '/related/AttachedContentDocuments/view';
                        update(ICR);
                    }
                    
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
    
}