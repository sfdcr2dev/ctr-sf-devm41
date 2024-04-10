public with sharing class ODM_WCInspectFileAttachmentCtrl {

	@AuraEnabled
	public static ODM_WCVerificationDTO getRelatedObjects(String recordIdentifier) {
		try {
			ODM_WCVerificationDTO dto = new ODM_WCVerificationDTO();

			List<ContentDocumentLink> documents = [
				SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.ContentSize, ContentDocument.CreatedDate
				FROM ContentDocumentLink
				WHERE LinkedEntityId = :recordIdentifier AND LinkedEntity.Type = 'PTW_Header__c'
				ORDER BY ContentDocument.CreatedDate DESC
			];
			dto.files = wrapDocuments(documents);
			return dto;
		} catch (Exception e) {
			System.debug(
				System.LoggingLevel.ERROR,
				String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() })
			);
			return null;
		}
	}

	/**
	 * @description delete a file
	 * @param fileId file identifier to delete
	 */
	@AuraEnabled
	public static void deleteFile(String fileId) {
		try {
			if (Schema.sObjectType.ContentDocument.isDeletable()) {
				 delete [SELECT Id FROM ContentDocument WHERE Id = :fileId];
			} else {
				throw new AuraHandledException('Not sufficient permissions');
			}
		} catch (Exception ex) {
			System.debug(ex.getMessage()+' Line:'+ex.getLineNumber());
		}
	}

	/**
	 * @description wraps a list of documents to add sequential number to each document
	 * @param documents
	 */
	private static List<DocumentWrapper> wrapDocuments(List<ContentDocumentLink> documents) {
		List<DocumentWrapper> wrappedDocuments = new List<DocumentWrapper>();

		Integer sequentialNumber = 1;
		for (ContentDocumentLink document : documents) {
			wrappedDocuments.add(new DocumentWrapper(getSequentialNumber(sequentialNumber), document));

			sequentialNumber++;
		}

		return wrappedDocuments;
	}

	/**
	 * @description builds a left padded string from a number
	 * @param sequentialNumber
	 */
	private static String getSequentialNumber(Integer sequentialNumber) {
		return String.valueOf(sequentialNumber).leftPad(3, '0');
	}
}