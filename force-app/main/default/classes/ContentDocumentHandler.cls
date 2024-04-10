/**
 * @author Oktana
 */
public with sharing class ContentDocumentHandler {
	public static void handleNotificationFilesRenamed(Map<Id, sObject> newItems, Map<Id, sObject> oldItems) {
		// Map<Id, ContentDocument> renamedDocumentsById = new Map<Id, ContentDocument>();

		// for (ContentDocument newDocument : (List<ContentDocument>) newItems.values()) {
		// 	ContentDocument oldDocument = (ContentDocument) oldItems.get(newDocument.Id);

		// 	if (isDocumentRenamed(newDocument, oldDocument)) {
		// 		renamedDocumentsById.put(newDocument.Id, newDocument);
		// 	}
		// }

		if (newItems.size() > 0) {
			List<Notification_File__c> nFilesToUpdate = new List<Notification_File__c>();

			for (Notification_File__c nFile : getNotificationFilesByFileId(newItems.keySet())) {
				ContentDocument contentDocument = (ContentDocument) newItems.get(nFile.File_Id__c);
				if (nFile.File_Name__c != contentDocument.Title) {
					nFile.File_Name__c = contentDocument.Title;

					nFilesToUpdate.add(nFile);
				}
			}

			if (Schema.SObjectType.Notification_File__c.isUpdateable() && nFilesToUpdate.size() > 0) {
				update nFilesToUpdate;
			}
		}
	}

	public static void handleNotificationFilesDeleted(Map<Id, sObject> oldDocuments) {
		List<Notification_File__c> nFilesToDelete = getNotificationFilesByFileId(oldDocuments.keySet());

		if (Schema.SObjectType.Notification_File__c.isDeletable()) {
			delete nFilesToDelete;
			// THOR_iRPAIntegration_NotificationFile.sendNotificationFilesToSAP(nFilesToDelete, 'Deleted');
		}
	}

	// private static Boolean isDocumentRenamed(ContentDocument newDocument, ContentDocument oldDocument) {
	// 	return newDocument.Title != oldDocument.Title;
	// }

	public static List<Notification_File__c> getNotificationFilesByFileId(Set<Id> documentIds) {
		return [
			SELECT
				Id,
				File_Name__c,
				File_Id__c,
				Url_Link__c,
				Integration_Status__c,
				Notification__c,
				SAP_File_Id__c,
				Notification_Number_Formular__c
			FROM Notification_File__c
			WHERE File_Id__c IN :documentIds
		];
			// WITH SECURITY_ENFORCED
	}
}