public with sharing class ODM_FileUploadActionController {
/**
	 * @description service to rename documents
	 * @param documentId document to be renamed
	 * @param title new document Title
	 */
	@AuraEnabled
	public static void updateFiles(String documentId, String title) {
		ContentDocument document = [
			SELECT Id, Title
			FROM ContentDocument
			WHERE Id = :documentId
			WITH SECURITY_ENFORCED
		];
		document.Title = title;
		try {
			update document;
		} catch (DMLException e) {
			throw new AuraHandledException('Error occured while renaming document');
		}
	}

	@AuraEnabled
	public static Boolean hasWriteAccess(String recordId) {
		List<UserRecordAccess> access = [
			SELECT RecordId
			FROM UserRecordAccess
			WHERE HasEditAccess = TRUE AND RecordId = :recordId AND UserId = :UserInfo.getUserId()
		];

		return !access.isEmpty();
	}

	@AuraEnabled
	public static ContentVersion saveFile(Id idParent, String strFileName, String base64Data, String Category) {
		String C = Category + '-';
		// Decoding base64Data
		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

		// inserting file
		ContentVersion cv = new ContentVersion();
		cv.Title = C + strFileName;
		cv.PathOnClient = '/' + strFileName;
		cv.FirstPublishLocationId = idParent;
		cv.VersionData = EncodingUtil.base64Decode(base64Data);
		cv.IsMajorVersion = true;
		insert cv;
		return cv;
	}

	@AuraEnabled
	public static list<contentversion> releatedFiles(Id idParent) {
		list<id> lstConDocs = new List<id>();
		for (ContentDocumentLink cntLink : [
			SELECT Id, ContentDocumentId
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :idParent
		]) {
			lstConDocs.add(cntLink.ContentDocumentId);
		}
		if (!lstConDocs.isEmpty()) {
			return [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :lstConDocs];
		} else {
			return null;
		}
	}

	@AuraEnabled
	public static void deleteContentDocument(String recordId) {
		Database.delete(recordId);
	}

	@AuraEnabled
	public static void deleteFiles(String recordId) {
		try {
			List<ContentDocumentLink> contents = [
				SELECT ContentDocumentId, LinkedEntityId
				FROM ContentDocumentLink
				WHERE LinkedEntityId = :recordId
				LIMIT 1
			];
			List<String> ids = new List<String>();
			if (contents.size() > 0) {
				for (ContentDocumentLink content : contents) {
					ids.add(content.ContentDocumentId);
				}
			}
			Database.delete(ids);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}