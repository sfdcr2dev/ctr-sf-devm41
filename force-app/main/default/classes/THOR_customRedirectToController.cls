/**
 * @author Oktana
 * @description Gets related record fields by parent Id
 */
public with sharing class THOR_customRedirectToController {
    /**
     * @description retrieves related Order Name by parent ID
     * @return sObject with related field
     * @param notifId is the Id of the parent Notification
     * @param fromRecord is the String of the object we're querying
     * @param relatedField is String of the field we're querying
     */
    @AuraEnabled
    public static List<sObject> getRelatedRecord(String notifId, String fromRecord, String relatedField) {
        String query;
        // if we're getting Work Clearance force it to get latest by CreatedDate
        if (relatedField.contains('Work_Clearance__r.Name')) {
            query =
                'SELECT Id, Name, CreatedDate FROM Work_Clearance__c WHERE ' +
                fromRecord +
                '=\'' +
                String.escapeSingleQuotes(notifId) +
                '\' ORDER BY CreatedDate DESC';
        } else {
            query =
                'SELECT ' +
                String.escapeSingleQuotes(relatedField) +
                ' FROM ' +
                String.escapeSingleQuotes(fromRecord) +
                ' WHERE Id=\'' +
                String.escapeSingleQuotes(notifId) +
                '\'';
        }
        try {
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
     * @description retrieves the Id for Work Clearance attached files
     * @return List<ContentDocumentLink> or null if not found
     * @param relatedId is the Id of the parent Work_Clearence__c
     */
    @AuraEnabled
    public static List<ContentDocumentLink> getAttachmentId(String relatedId) {
        try {
            return [
                SELECT ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityID = :relatedId
                WITH SECURITY_ENFORCED
                ORDER BY SystemModstamp DESC 
                LIMIT 1
                
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}