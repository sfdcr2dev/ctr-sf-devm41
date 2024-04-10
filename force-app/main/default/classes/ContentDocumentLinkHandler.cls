/**
 * @author Oktana
 */
public with sharing class ContentDocumentLinkHandler {
    public static void handleNotificationFiles(List<ContentDocumentLink> documentLinks) {
        List<ContentDocumentLink> notificationDocumentLinks = getNotificationDocumentLinks(documentLinks);
        Map<Id, Set<Id>> contentDocumentsByEntityId = getContentDocumentsByEntityId(notificationDocumentLinks);
        Map<Id, Notification__c> notificationsById = new Map<Id, Notification__c>(
            getNotificationsFromDocumentLinks(notificationDocumentLinks)
        );
        Map<Id, List<ContentVersion>> versionsByDocumentId = getContentVersionsByDocumentId(notificationDocumentLinks);

        createNotificationFiles(contentDocumentsByEntityId, notificationsById, versionsByDocumentId);
    }

    private static void createNotificationFiles(
        Map<Id, Set<Id>> contentDocumentsByEntityId,
        Map<Id, Notification__c> notificationsById,
        Map<Id, List<ContentVersion>> versionsByDocumentId
    ) {
        List<Notification_File__c> nFiles = new List<Notification_File__c>();
        for (Id notificationId : contentDocumentsByEntityId.keySet()) {
            for (Id documentId : contentDocumentsByEntityId.get(notificationId)) {
                for (ContentVersion cVersion : versionsByDocumentId.get(documentId)) {
                    Notification_File__c nFile = new Notification_File__c();
                    nFile.Notification__c = notificationId;
                    nFile.Integration_Status__c = 'In Progress';
                    
                    // if (notificationsById.get(notificationId).Notification_Number__c != null) {
                    //     nFile.Notification_Number__c = notificationsById.get(notificationId).Notification_Number__c;
                    // } else {
                    //     nFile.Notification_Number__c = notificationsById.get(notificationId).Name;
                    // }
                    if (notificationsById.get(notificationId)?.Order__r.Order_Number__c != null) {
                        nFile.Order_Number__c = notificationsById.get(notificationId)?.Order__r.Order_Number__c;
                    } else {
                        nFile.Order_Number__c = notificationsById.get(notificationId)?.Order__r.Name;
                    }

                    nFile.File_Name__c = cVersion.Title;
                    nFile.File_Id__c = documentId;

                    nFiles.add(nFile);
                }
            }
        }

        if (Schema.SObjectType.Notification_File__c.isCreateable()) {
            insert nFiles;
        }
    }

    private static List<ContentDocumentLink> getNotificationDocumentLinks(List<ContentDocumentLink> documentLinks) {
        List<ContentDocumentLink> notificationDocumentLinks = getNotificationDocuments(documentLinks);
        return notificationDocumentLinks;
    }

    private static List<ContentDocumentLink> getNotificationDocuments(List<ContentDocumentLink> documentLinks) {
        List<ContentDocumentLink> notificationDocumentLinks = new List<ContentDocumentLink>();

        for (ContentDocumentLink documentLink : documentLinks) {
            if (isSameSObjectType(documentLink.LinkedEntityId, Notification__c.getSObjectType())) {
                notificationDocumentLinks.add(documentLink);
            }
        }
        return notificationDocumentLinks;
    }

    private static Boolean isSameSObjectType(Id entityId, SObjectType objectType) {
        return entityId.getSobjectType() == objectType;
    }

    private static List<Notification__c> getNotificationsFromDocumentLinks(List<ContentDocumentLink> documentLinks) {
        Set<Id> notificationIds = new Set<Id>();
        for (ContentDocumentLink documentLink : documentLinks) {
            notificationIds.add(documentLink.LinkedEntityId);
        }

        return getNotificationsById(notificationIds);
    }

    private static List<Notification__c> getNotificationsById(Set<Id> notificationIds) {
        return [
            SELECT Id, Notification_Number__c, Name, Order__c, Order__r.Order_Number__c, Order__r.Name
            FROM Notification__c
            WHERE Id IN :notificationIds
        ];
    }

    private static Map<Id, Set<Id>> getContentDocumentsByEntityId(List<ContentDocumentLink> documentLinks) {
        Map<Id, Set<Id>> contentDocumentsByEntityId = new Map<Id, Set<Id>>();

        for (ContentDocumentLink documentLink : documentLinks) {
            if (!contentDocumentsByEntityId.containsKey(documentLink.LinkedEntityId)) {
                contentDocumentsByEntityId.put(
                    documentLink.LinkedEntityId,
                    new Set<Id>{ documentLink.ContentDocumentId }
                );
            } else {
                contentDocumentsByEntityId.get(documentLink.LinkedEntityId).add(documentLink.ContentDocumentId);
            }
        }

        return contentDocumentsByEntityId;
    }

    private static Map<Id, List<ContentVersion>> getContentVersionsByDocumentId(
        List<ContentDocumentLink> documentLinks
    ) {
        Set<Id> documentIds = new Set<Id>();
        for (ContentDocumentLink documentLink : documentLinks) {
            documentIds.add(documentLink.ContentDocumentId);
        }
        List<ContentVersion> cVersions = getContentVersionsByDocumentId(documentIds);
        Map<Id, List<ContentVersion>> versionsByDocumentId = new Map<Id, List<ContentVersion>>();

        for (ContentVersion cVersion : cVersions) {
            if (!versionsByDocumentId.containsKey(cVersion.ContentDocumentId)) {
                versionsByDocumentId.put(cVersion.ContentDocumentId, new List<ContentVersion>{ cVersion });
            } else {
                versionsByDocumentId.get(cVersion.ContentDocumentId).add(cVersion);
            }
        }

        return versionsByDocumentId;
    }

    private static List<ContentVersion> getContentVersionsByDocumentId(Set<Id> documentIds) {
        return [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :documentIds];
    }
}