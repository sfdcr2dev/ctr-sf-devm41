/**
 * @author Oktana
 * @description ContentDocumentLink trigger implementation class
 */
public with sharing class ContentDocumentLinkTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) {
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
        // ORTL Project:  If risk attachments are removed, the action attachments related to them will be deleted, and vice versa.
        ORTLCtDocLnkCtrl.handleContentDocumentLinkDeleted(oldItems);
    }
    public void afterInsert(Map<Id, SObject> newItems) {
        ContentDocumentLinkHandler.handleNotificationFiles(newItems.values());
        CPEM_ContentDocumentLinkHandler.handleUploadContentDocumentLink(newItems.values());
        ICR_ContentDocumentLinkHandler.handleUploadContentDocumentLink(newItems.values());

        // ORTL Project: While uploading action attachments, also add to risk attachments.
        ORTLCtDocLnkCtrl.handleUploadContentDocumentLink(newItems.values());
    }
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        CPEM_ContentDocumentLinkHandler.handleUploadContentDocumentLink(newItems.values());
    }
    public void afterDelete(Map<Id, SObject> oldItems) {
//        ContentDocumentHandler.handleNotificationFilesDeleted(oldItems);
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
}