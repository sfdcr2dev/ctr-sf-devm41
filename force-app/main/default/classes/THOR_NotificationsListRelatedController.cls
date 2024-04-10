/**
 * @author Oktana
 * @description Queries all related Notification Object
 */
public without sharing class THOR_NotificationsListRelatedController {
	/**
	 * @description retrieves all Items, Orders and Files that are related to a specific Notification
	 * @return The Notification plus related Items, Orders and Files from the database
	 * @param notificationIdentifier is the Id of the Notification
	 */
	@AuraEnabled
	public static THOR_NotificationListRelatedDTO getRelatedObjects(String notificationIdentifier) {
		try {
			THOR_NotificationListRelatedDTO dto = new THOR_NotificationListRelatedDTO();

			Notification__c n = [
				SELECT
					Id,
					Order__c,
					Integration_Status__c,
					Notification_Status__c,
					(
						SELECT
							Id,
							Name,
							CreatedDate,
							Start_Date__c,
							End_Date__c,
							Notification__r.Id,
							Object_part__r.Name,
							Object_Part_Code_Group__r.Name,
							Object_Part_Code_Group__r.Description__c,
							Object_Part_Code_Group_Text__c,
							Object_Part_Code_Text__c,
							Integration_Status__c
						FROM Items__r
						WHERE isDeleted__c = FALSE
					),
					(
						SELECT Integration_Status__c, File_Id__c, LastModifiedDate
						FROM Notification_File__r
						ORDER BY CreatedDate DESC
					)
				FROM Notification__c
				WHERE Id = :notificationIdentifier
				WITH SECURITY_ENFORCED
				LIMIT 1
			];

			dto.orderId = n.Order__c;
			dto.relatedItems = THOR_DTOMapper.mapItems(n.Items__r);
			dto.relatedSubOrders = [
				SELECT Id, Name
				FROM Order__c
				WHERE Super_Order__c = :n.Order__c AND Super_Order__c != NULL
				WITH SECURITY_ENFORCED
			];

			List<ContentDocumentLink> documents = getFilesRelatedToNotification(notificationIdentifier);
			dto.files = wrapDocuments(documents);
			dto.notification_files = n.Notification_File__r;
			dto.hasEditAccess = [
				SELECT RecordId, HasEditAccess
				FROM UserRecordAccess
				WHERE RecordId = :notificationIdentifier AND UserId = :UserInfo.getUserId()
			]
			?.HasEditAccess;
			dto.notificationObj = n;
			return dto;
		} catch (Exception e) {
			System.debug(
				System.LoggingLevel.ERROR,
				String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() })
			);
			throw new AuraHandledException(
				String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() })
			);
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
				// delete [SELECT Id FROM ContentDocument WHERE Id = :fileId];
				Map<Id, Notification_File__c> documentsMap = new Map<Id, Notification_File__c>(
					ContentDocumentHandler.getNotificationFilesByFileId(new Set<Id>{ fileId })
				);

				if (String.isNotEmpty(documentsMap.values().get(0)?.SAP_File_Id__c)) {
					THOR_iRPAIntegration_NotificationFile.sendNotificationFilesToSAP(documentsMap.values(), 'Deleted');
				} else {
					delete [SELECT Id FROM ContentDocument WHERE Id = :fileId];
				}
			} else {
				throw new AuraHandledException('Not sufficient permissions');
			}
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}

	/**
	 * @description retrieves all files related to a notification
	 * @param notificationId
	 */
	private static List<ContentDocumentLink> getFilesRelatedToNotification(Id notificationId) {
		return [
			SELECT
				ContentDocumentId,
				ContentDocument.Title,
				ContentDocument.FileType,
				ContentDocument.ContentSize,
				ContentDocument.CreatedDate
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :notificationId AND LinkedEntity.Type = 'Notification__c'
			ORDER BY ContentDocument.CreatedDate DESC
		];
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

	@AuraEnabled
	public static void resendIntegrationNotificationFile(String fileId, String flag) {
		try {
			Map<Id, Notification_File__c> notiFiles = new Map<Id, Notification_File__c>(
				ContentDocumentHandler.getNotificationFilesByFileId(new Set<Id>{ fileId })
			);
			update notiFiles.values();

			THOR_iRPAIntegration_NotificationFile.sendNotificationFilesToSAP(notiFiles.values(), flag);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}