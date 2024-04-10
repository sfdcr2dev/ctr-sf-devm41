public with sharing class CTRFileUploaderController {
    @AuraEnabled
    public static Id saveFiles(Id parentId, String fileName, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Blob fileBody = EncodingUtil.base64Decode(base64Data);
        // Create ContentVersion
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.ContentLocation = 'S';
        contentVersion.PathOnClient = fileName;
        contentVersion.Title = fileName;
        contentVersion.VersionData = fileBody;

        insert contentVersion;

        // Query the ContentDocumentId field
        ContentVersion queriedContentVersion = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :contentVersion.Id
            LIMIT 1
        ];

        ContentDocumentLink contentLink = new ContentDocumentLink();
        contentLink.ContentDocumentId = queriedContentVersion.ContentDocumentId;
        contentLink.LinkedEntityId = parentId;
        contentLink.ShareType = 'V';
        contentLink.Visibility = 'AllUsers';

        insert contentLink;

        return contentVersion.Id;
    }

    @AuraEnabled
    public static List<ContentDocument> getAttachments(Id recordId, String uploadedList) {
        List<ContentDocument> contentDocuments = new List<ContentDocument>();
        System.debug('==recordId=='+recordId);
        System.debug('==uploadedList=='+uploadedList);

        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        
        Set<Id> contentDocumentIds = new Set<Id>();
        for (ContentDocumentLink link : documentLinks) {
            contentDocumentIds.add(link.ContentDocumentId);
        }

        if (String.isNotBlank(uploadedList)) {
            List<String> filenames = uploadedList.split(',');
            system.debug('filenames----'+filenames);
            contentDocuments = [SELECT Id, Title FROM ContentDocument WHERE Id IN :contentDocumentIds AND Title IN :filenames];
            system.debug('contentDocuments----'+contentDocuments);
        } else {
            return null;
        }
        System.debug('==contentDocuments=='+contentDocuments);
        
        return contentDocuments;
    }
    
    @AuraEnabled
    public static List<String> deleteAttachments(List<Id> attachmentIds) {
        List<ContentDocument> documentsToDelete = [SELECT Id, Title FROM ContentDocument WHERE Id IN :attachmentIds];
        List<String> fileName = new List<String>();
        for (ContentDocument fn : documentsToDelete) {
            fileName.add(fn.Title);
        }
        System.debug('fileName: ' + fileName);
        if (!documentsToDelete.isEmpty()) {
            try {
                delete documentsToDelete;
            } catch (Exception e) {
                System.debug('Error when trying to delete attachments: ' + e.getMessage());
            }
        }

        return fileName;
    }
    /*
    @AuraEnabled
    public static List<ContentVersion> deleteAttachmentsContentDocument(List<Id> attachmentIds) {
        //List<ContentDocument> documentsToDelete = [SELECT Id, Title FROM ContentDocument WHERE Id IN :attachmentIds];
        
        List<ContentVersion> documentsToVersion = [SELECT Id, Title,VersionData,ContentDocumentId FROM ContentVersion WHERE Id IN :attachmentIds];
        Set<String> documentsToDelete = new Set<String>();
        for (ContentDocument fn : documentsToVersion) {
            documentsToDelete.add(fn.ContentDocumentId);
        }
        //System.debug('fileName: ' + fileName);
        if (!documentsToDelete.isEmpty()) {
            try {
                delete documentsToDelete;
            } catch (Exception e) {
                System.debug('Error when trying to delete attachments: ' + e.getMessage());
            }
        }

        return documentsToVersion;
    }*/
    
    
    @AuraEnabled
    public static List<ContentDocument> getAttachmentDetailByIds(Id recordId, List<Id> contentDocumentIds) {
        List<ContentDocument> contentDocuments = [SELECT Id, Title, PublishStatus, ContentSize, FileType, FileExtension, SharingOption FROM ContentDocument WHERE Id IN :contentDocumentIds];
        
        return contentDocuments;
    }
    
    @AuraEnabled
    public static List<ContentDocument> getAttachmentDetails(Id recordId, String uploadedList, Boolean byId) {
        List<ContentDocument> contentDocuments = new List<ContentDocument>();
        System.debug('==recordId=='+recordId);
        System.debug('==uploadedList=='+uploadedList);

        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        
        Set<Id> contentDocumentIds = new Set<Id>();
        for (ContentDocumentLink link : documentLinks) {
            contentDocumentIds.add(link.ContentDocumentId);
        }

        if (String.isNotBlank(uploadedList)) {
            if(byId) {
            	contentDocuments = [SELECT Id, Title, PublishStatus, ContentSize, FileType, FileExtension, SharingOption FROM ContentDocument WHERE Id = :uploadedList];    
            } else {
            	List<String> filenames = uploadedList.split(',');
            	system.debug('filenames----'+filenames);
            	contentDocuments = [SELECT Id, Title, PublishStatus, ContentSize, FileType, FileExtension, SharingOption FROM ContentDocument WHERE Id IN :contentDocumentIds AND Title IN :filenames];
            	system.debug('contentDocuments----'+contentDocuments);        
            }
        } else {
            contentDocuments = [SELECT Id, Title, PublishStatus, ContentSize, FileType, FileExtension, SharingOption FROM ContentDocument WHERE Id IN :contentDocumentIds];
        }
        System.debug('==contentDocuments=='+contentDocuments);
        
        return contentDocuments;
    }
	
}