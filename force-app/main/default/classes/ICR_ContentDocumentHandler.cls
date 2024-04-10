/* 
    Author Softever 
    Class for ContentDocument (ICR) 
*/

public with sharing class ICR_ContentDocumentHandler {

    public static void handleDeleteContentDocument(List<ContentDocument> documents) {
        
        Set<Id> ContentDocumentIds = getContentDocumentId(documents);
        List<ContentDocumentLink> ContentDocumentLinks = getContentDocumentLinks(ContentDocumentIds);
        Set<Id> ContentDocumentLinkIds = getLinkedEntityId(ContentDocumentLinks);
        
        if(ContentDocumentLinkIds.size() > 0) {
            for(Id entityId : ContentDocumentLinkIds) {
                
                if (isSameSObjectType(entityId, ICR_Approval__c.getSObjectType())) {
                    ICR_Approval__c ICR = getICRApproval(entityId);
                    if( ICR.ContentDocumentLinks.size() == 1 ) {
                        ICR.BE_File_Upload__c = false;
                        update(ICR);
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
    
    private static ICR_Approval__c getICRApproval(Id ICRId) {
        return [SELECT Id, BE_File_Upload__c, ( SELECT Id FROM ContentDocumentLinks ) FROM ICR_Approval__c WHERE ID =: ICRId];
    }
    
    private static List<ContentDocumentLink> getContentDocumentLinks(Set<Id> documentIds) {
        return [SELECT Id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where ContentDocumentId IN :documentIds];
    }
    
}