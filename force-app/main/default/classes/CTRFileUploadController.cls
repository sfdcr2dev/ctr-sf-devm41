public with sharing class CTRFileUploadController {
    
    @AuraEnabled
    public static Object getFileUploadInfo(String sObjectName, String fieldName, String recordId) {
        String query = 'SELECT Id, Name, ' + fieldName + ' FROM ' + sObjectName + ' WHERE Id = :recordId';
        List<sObject> lstResult = Database.query(query);
        Object result;
        if (lstResult.size() > 0) {
            result = lstResult[0];
        }
        return result;
    }

    @AuraEnabled
    public static void updateFileUploadInfo(String sObjectName, String fieldName, String recordId, String fieldValue) {
        Schema.SObjectType className = Schema.getGlobalDescribe().get(sObjectName);
        if (className != null) {
            SObject obj = className.newSObject();
            obj.Id = recordId;
            obj.put(fieldName, fieldValue);
            update obj;
        }
    }

    @AuraEnabled
    public static List<ContentDocument> getAttachmentsByIds(Id recordId, List<Id> contentDocumentIds) {
        return [
            SELECT Id, Title, PublishStatus, ContentSize, FileType, FileExtension, SharingOption 
            FROM ContentDocument 
            WHERE Id IN :contentDocumentIds
        ];
    }

    @AuraEnabled
    public static List<String> deleteAttachments(List<Id> attachmentIds) {
        List<ContentDocument> documents = [SELECT Id, Title FROM ContentDocument WHERE Id IN :attachmentIds];
        List<String> fileIds = new List<String>();
        for (ContentDocument fn : documents) {
            fileIds.add(fn.Id);
        }
        if (!documents.isEmpty()) {
            try {
                delete documents;
            } catch (Exception e) {
                System.debug('Error when trying to delete attachments: ' + e.getMessage());
            }
        }
        return fileIds;
    }
}