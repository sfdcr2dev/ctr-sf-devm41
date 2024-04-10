/**
 * @author Oktana
 * @description Queries all related EQCC Objects with their respective EQCC Checked Sheets for a specific Order
 */
public with sharing class THOR_OrderRelatedEQCCController {
    /**
     * @description retrieves all EQCCs and their respective EQCC Checked Sheets that are related to a specific Order
     * @return Related EQCCs from the database
     * @param orderIdentifier is the Id of the Order
     */
    @AuraEnabled
    public static List<HeaderSheetWrapper> getRelatedEQCCs(String orderIdentifier) {
        try {
            Map<Id, EQCC_Header__c> headers = new Map<Id, EQCC_Header__c>(getHeaderFromOrder(orderIdentifier));
            List<Header_Sheet__c> headerSheets = getHeaderSheetsByHeader(headers.keySet());
            Map<Id, EQCC_Checked_Sheet__c> sheets = new Map<Id, EQCC_Checked_Sheet__c>(
                getSheetsFromHeaderSheets(headerSheets)
            );

            Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = buildSheetsByHeader(
                headers,
                headerSheets,
                sheets
            );

            return createHeaderSheetWrapper(sheetsByHeader);
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    /**
     * @description get records from junction object based on Header__c
     * @param headerId
     */
    private static List<Header_Sheet__c> getHeaderSheetsByHeader(Set<Id> headerIds) {
        return [
            SELECT Id, Header__c, Sheet__c, Status__c, CreatedDate, isManuallyCreated__c, Requester__c, isPolluted__c
            FROM Header_Sheet__c
            WHERE Header__c IN :headerIds AND IsDeleted__c = FALSE
        ];
    }

    /**
     * @description get sheets from junction object
     * @param headerSheets
     */
    private static Map<Id, EQCC_Checked_Sheet__c> getSheetsFromHeaderSheets(List<Header_Sheet__c> headerSheets) {
        Set<Id> sheetIds = new Set<Id>();
        for (Header_Sheet__c sheet : headerSheets) {
            sheetIds.add(sheet.Sheet__c);
        }

        Map<Id, EQCC_Checked_Sheet__c> sheets = new Map<Id, EQCC_Checked_Sheet__c>(
            [SELECT Id, Name, Sheet_Code__c, Status__c, CreatedDate, Group__c FROM EQCC_Checked_Sheet__c WHERE Id IN :sheetIds]
        );

        return sheets;
    }

    private static List<EQCC_Header__c> getHeaderFromOrder(String orderIdentifier) {
        return [
            SELECT
                Id,
                Name,
                FunctionalLocation__r.Name,
                Equipment__r.Name,
                Notification__r.Notification_Number__c,
                Order__r.Order_Number__c,
                Order_Operation__r.Operation_Shot_Text__c
            FROM EQCC_Header__c
            WHERE Order__c = :orderIdentifier AND IsDeleted__c = FALSE
            WITH SECURITY_ENFORCED
        ];
    }

    private static Map<EQCC_Header__c, Set<CheckedSheetWrapper>> buildSheetsByHeader(
        Map<Id, EQCC_Header__c> headers,
        List<Header_Sheet__c> headerSheets,
        Map<Id, EQCC_Checked_Sheet__c> sheets
    ) {
        Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = new Map<EQCC_Header__c, Set<CheckedSheetWrapper>>();

        for (Header_Sheet__c headerSheet : headerSheets) {
            if (!sheetsByHeader.containsKey(headers.get(headerSheet.Header__c))) {
                sheetsByHeader.put(
                    headers.get(headerSheet.Header__c),
                    new Set<CheckedSheetWrapper>{
                        new CheckedSheetWrapper(
                            sheets.get(headerSheet.Sheet__c),
                            headerSheet.Status__c,
                            headerSheet.Requester__c,
                            Date.valueOf(headerSheet.CreatedDate),
                            headerSheet.isManuallyCreated__c,
                            headerSheet.Id,
                            headerSheet.isPolluted__c
                        )
                    }
                );
            } else {
                sheetsByHeader.get(headers.get(headerSheet.Header__c))
                    .add(
                        new CheckedSheetWrapper(
                            sheets.get(headerSheet.Sheet__c),
                            headerSheet.Status__c,
                            headerSheet.Requester__c,
                            Date.valueOf(headerSheet.CreatedDate),
                            headerSheet.isManuallyCreated__c,
                            headerSheet.Id,
                            headerSheet.isPolluted__c
                        )
                    );
            }
        }

        for (Id headerId : headers.keySet()) {
            if (!sheetsByHeader.containsKey(headers.get(headerId))) {
                sheetsByHeader.put(headers.get(headerId), new Set<CheckedSheetWrapper>());
            }
        }

        return sheetsByHeader;
    }

    private static List<HeaderSheetWrapper> createHeaderSheetWrapper(
        Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader
    ) {
        List<Profile> isAdmin = [
            SELECT Id
            FROM Profile
            WHERE Id = :UserInfo.getProfileId() AND Name = 'System Administrator'
        ];
        List<HeaderSheetWrapper> wrappers = new List<HeaderSheetWrapper>();
        Boolean isOwnerOrAdmin;
        Set<Id> ownedHeaderIds = getHeadersOwnedByUser(sheetsByHeader.keySet());
        for (EQCC_Header__c header : sheetsByHeader.keySet()) {
            isOwnerOrAdmin = !isAdmin.isEmpty() || ownedHeaderIds.contains(header.Id);
            wrappers.add(
                new HeaderSheetWrapper(
                    header,
                    new List<CheckedSheetWrapper>(sheetsByHeader.get(header)),
                    isOwnerOrAdmin
                )
            );
        }

        return wrappers;
    }

    private static Set<Id> getHeadersOwnedByUser(Set<EQCC_Header__c> headers) {
        Set<Id> headerIds = new Map<Id, EQCC_Header__c>(new List<EQCC_Header__c>(headers)).keySet();

        return new Map<Id, EQCC_Header__c>(
                [SELECT Id FROM EQCC_Header__c WHERE Id IN :headerIds AND OwnerId = :UserInfo.getUserId()]
            )
            .keySet();
    }

    /**
     * @description Checks if Header_Sheet__c was manually created
     * @param recordId String of related EQCC_Header__c
     * @return Boolean
     */
    @AuraEnabled
    public static Boolean checkIfManuallyCreated(String recordId) {
        List<Header_Sheet__c> isManualRecords = [
            SELECT Id
            FROM Header_Sheet__c
            WHERE Header__c = :recordId AND isManuallyCreated__c = FALSE
        ];
        if (isManualRecords.size() == 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @description Deletes EQCC_Header__c by Id
     * @param recordId String of record to delete
     * @return Boolean
     */
    @AuraEnabled
    public static Boolean deleteEQCCHeader(String recordId) {
        try {
            EQCC_Header__c headerToDelete = [
                SELECT Id
                FROM EQCC_Header__c
                WHERE Id = :recordId
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            List<Header_Sheet__c> headerJunctionRecord = [
                SELECT Id, Sheet__c
                FROM Header_Sheet__c
                WHERE Header__c = :recordId
                WITH SECURITY_ENFORCED
            ];

            List<EQCC_Step__c> stepsToDelete = [
                SELECT Id, Name
                FROM EQCC_Step__c
                WHERE Header_Sheet__c IN :headerJunctionRecord
                WITH SECURITY_ENFORCED
            ];

            delete headerToDelete;
            delete stepsToDelete;
            List<Database.DeleteResult> result = Database.delete(headerJunctionRecord, false);

            return true;
        } catch (Exception e) {
            return false;
        }
    }
}