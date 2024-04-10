public without sharing class ODM_WCVeriFileAttachmentController {
    
    @AuraEnabled
	public static String getPTWHeader(String wcId) {
		try {

			PTW_Header__c n = [
				SELECT
					Id
				FROM PTW_Header__c
				WHERE Work_Clearance__c =: wcId 
                AND RecordType.Name = 'Verification'
				WITH SECURITY_ENFORCED
				LIMIT 1
			];
			return n.id;
		} catch (Exception e) {
			System.debug(
				System.LoggingLevel.ERROR,
				String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() })
			);
            return String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() });
		}
	}
    
	@AuraEnabled
	public static ODM_WCVerificationDTO getRelatedObjects(String recordIdentifier) {
		try {
			ODM_WCVerificationDTO dto = new ODM_WCVerificationDTO();

			PTW_Header__c n = [
				SELECT
					Id
				FROM PTW_Header__c
				WHERE Work_Clearance__c =: recordIdentifier 
                AND RecordType.Name = 'Verification'
				WITH SECURITY_ENFORCED
				LIMIT 1
			];

			List<ContentDocumentLink> documents = getFilesRelatedToNotification(n.id);
			dto.files = wrapDocuments(documents);
			dto.notificationObj = n;
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
	 * @description retrieves all files related 
	 * @param recordId
	 */
	public static List<ContentDocumentLink> getFilesRelatedToNotification(Id recordId) {
		return [
			SELECT
				ContentDocumentId,
				ContentDocument.Title,
				ContentDocument.FileType,
				ContentDocument.ContentSize,
				ContentDocument.CreatedDate
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :recordId AND LinkedEntity.Type = 'PTW_Header__c'
			ORDER BY ContentDocument.CreatedDate DESC
		];
	}

	/**
	 * @description wraps a list of documents to add sequential number to each document
	 * @param documents
	 */
	/* *private*/public static List<DocumentWrapper> wrapDocuments(List<ContentDocumentLink> documents) {
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
	/* *private*/public static String getSequentialNumber(Integer sequentialNumber) {
		return String.valueOf(sequentialNumber).leftPad(3, '0');
	}
}