/**
 * @author Oktana
 * @description Queries all related Work Clearances for a specific Order and wrap it in a DTO object
 */
public with sharing class THOR_OrderRelatedWorkClearanceCtr {
    /**
     * @description Retrieves all related Work Clearances for a specific Order with their respective files
     * @return Related Work Clearances and respecitve attached files
     * @param orderIdentifier is the Id of the Order
     */
    @AuraEnabled
    public static Work_Clearance__c getRelatedObjects(String orderIdentifier) {
        //try {
            //Map<Id, THOR_RelatedWorkClearanceDTO> returnData = new Map<Id, THOR_RelatedWorkClearanceDTO>();

            // First, get all work clearances related to the order
            /*List<Work_Clearance__c> workClearances = [
                SELECT
                    Id,
                    Name,
                    Work_Clearance__c,
                    Functional_Location__c,
                    Description__c,
                    Priority__c,
                    Main_Work_Center__r.Name
                FROM Work_Clearance__c
                WHERE Order__c = :orderIdentifier
                ORDER BY CreatedDate DESC
            ];
            Integer sequentialNumber = (workClearances != null) ? workClearances.size() : 0;
            for (Work_Clearance__c wc : workClearances) {
                THOR_RelatedWorkClearanceDTO dto = new THOR_RelatedWorkClearanceDTO();

                dto.workClearanceId = wc.Id;
                dto.workClearanceName = getSequentialNumber(sequentialNumber);
                dto.workClearance = wc.Work_Clearance__c;
                dto.workClearanceFunctionalLocation = wc.Functional_Location__c;
                dto.workClearanceDescription = wc.Description__c;
                dto.workClearancePriority = wc.Priority__c;
                dto.workClearanceMainWorkCenter = wc.Main_Work_Center__r.Name;
                returnData.put(wc.Id, dto);

                sequentialNumber--;
            }

            if( returnData.keySet().size() >= 1 ){
                for (ContentDocumentLink document : [
                    SELECT
                        ContentDocumentId,
                        ContentDocument.Title,
                        ContentDocument.FileType,
                        ContentDocument.ContentSize,
                        LinkedEntityId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN :returnData.keySet() AND LinkedEntity.Type = 'Work_Clearance__c'
                    ORDER BY SystemModstamp DESC
                    ]) {
                    returnData.get(document.LinkedEntityId).workClearanceFiles.add(document);
                }
            }

            return returnData;*/
            Work_Clearance__c workClearance = [
                SELECT
                    Id,
                    Name,
                    Work_Clearance__c,
                    Functional_Location__c,
                    Description__c,
                    Priority__c,
                    Main_Work_Center__r.Name,
                    Requester__c,
                    Notification__r.Name,
                    Area__c,
                    Maintenance_Unit__c,
                    Problem__c,
                    Work_Detail__c,
                    Thaioil_Supervisor_Indicator__c,
                    Telephone_No__c,
                    Applicant_or_Bearer__c,
                    Telephone_No_2__c,
                    Bearer1__c,
                    Bearer2__c,
                    Bearer3__c,
                    Can_go_wrong1__c,
                    Can_go_wrong2__c,
                    Can_go_wrong3__c,
                    Can_go_wrong4__c,
                    Cause1__c,
                    Cause2__c,
                    Cause3__c,
                    Cause4__c,
                    Prevent1__c,
                    Prevent2__c,
                    Prevent3__c,
                    Prevent4__c,
                    Authorized_Signature__c,
                    Check_Date__c,
                    Check_Time__c,
                    Extend_Time_To__c,
                    Close_Applicant_or_Bearer__c,
                    Extend_Applicant_or_Bearer__c,
                    Extend_Authorized_Sign__c,
                    Close_Authorized_Sign_off__c,
                    Sign_off_Flag__c,
                	Applicant_or_Bearer_Telephone__c,
                	TOP_Supervisor_Telephone__c,
                	Authorized_Signatory__c,
                	Extend_Time_Flag__c,
                    Authorized_Indicator__c
                FROM Work_Clearance__c
                WHERE Order__c = :orderIdentifier
                ORDER BY CreatedDate DESC LIMIT 1
            ];
            return workClearance;
        //} catch (Exception e) {
            //throw new AuraHandledException('Something went wrong...');
        //}
    }

    /**
     * @description builds a left padded string from a number
     * @param sequentialNumber
     */
    /*private static String getSequentialNumber(Integer sequentialNumber) {
        return String.valueOf(sequentialNumber).leftPad(3, '0');
    }*/
}