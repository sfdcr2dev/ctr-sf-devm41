/**
 * @author Oktana
 * @description Queries all related EQCC Objects with their respective EQCC Checked Sheets for a specific Notification
 */
public with sharing class THOR_NotificationRelatedEQCCController {
    /**
     * @description retrieves all EQCCs and their respective EQCC Checked Sheets that are related to a specific Notification
     * @return Related EQCCs from the database
     * @param notificationIdentifier is the Id of the Notification
     */
    @AuraEnabled
    public static List<HeaderSheetWrapper> getRelatedEQCCs(String notificationIdentifier) {
        try {
            Map<Id, EQCC_Header__c> headers = new Map<Id, EQCC_Header__c>(
                getHeaderFromNotification(notificationIdentifier)
            );
            List<Header_Sheet__c> headerSheets = getHeaderSheetsByHeader(headers.keySet());
            Map<Id, EQCC_Checked_Sheet__c> sheets = new Map<Id, EQCC_Checked_Sheet__c>(getSheetsFromHeaderSheets(headerSheets));
            Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = buildSheetsByHeader(headers,headerSheets,sheets);

            return createHeaderSheetWrapper(sheetsByHeader);
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    /**
     * @description retrieves all EQCC_Checked_Sheet__c from a given header
     * @return EQCC_Checked_Sheet__c from the database
     * @param theRelatedHeaderId is the Id of the header
     */
    @AuraEnabled
    public static List<HeaderSheetWrapper> getHeaderRelatedEQCCs(String headerId) {
        try {
            Map<Id, EQCC_Header__c> headers = new Map<Id, EQCC_Header__c>(getHeadersById(new Set<Id>{ headerId }));
            List<Header_Sheet__c> headerSheets = getHeaderSheetsByHeader(new Set<Id>{ Id.valueOf(headerId) });
            Map<Id, EQCC_Checked_Sheet__c> sheets = getSheetsFromHeaderSheets(headerSheets);
            Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = buildSheetsByHeader(headers,headerSheets,sheets);

            return createHeaderSheetWrapper(sheetsByHeader);
        } catch (Exception e) {
            throw new AuraException('Something went wrong...');
        }
    }

    /**
     * @description retrieves all EQCC Checked Sheets
     * @return Related EQCCs from the database
     */
    @AuraEnabled(cacheable=true)
    public static List<EQCC_Checked_Sheet__c> getEQCCCS() {
        try {
            return [SELECT Id, Name FROM EQCC_Checked_Sheet__c WITH SECURITY_ENFORCED];
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    /**
     * @description add EQCC_Checked_Sheet to a EQCC_Header
     * @param currentEQCCHeaderId is the Id of the Header
     * @param currentEQCCCheckedSheetId checksheet id
     */
    @AuraEnabled
    public static void setEQCCHeader(String currentEQCCCheckedSheetId, String currentEQCCHeaderId) {
        try {
            Header_Sheet__c headerSheet = new Header_Sheet__c(Header__c = currentEQCCHeaderId,Sheet__c = currentEQCCCheckedSheetId);
            if (Schema.sObjectType.Header_Sheet__c.isCreateable()) {
                insert headerSheet;
            } else {
                throw new AuraHandledException('Something went wrong...');
            }
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong...');
        }
    }

    @AuraEnabled
    public static Boolean hasWriteAccess(String recordId) {
        List<UserRecordAccess> access = [ SELECT RecordId FROM UserRecordAccess WHERE HasEditAccess = TRUE AND RecordId = :recordId AND UserId = :UserInfo.getUserId() ];
        return !access.isEmpty();
    }

    @AuraEnabled
    public static Boolean isOwnerOrAdmin(String headerId) {
        List<EQCC_Header__c> isOwner = [ SELECT Id, OwnerId FROM EQCC_Header__c WHERE Id = :headerId AND OwnerId = :UserInfo.getUserId() ];
        List<Profile> isAdmin = [ SELECT Id FROM Profile WHERE Id = :UserInfo.getProfileId() AND Name = 'System Administrator' ];
        return !isOwner.isEmpty() || !isAdmin.isEmpty();
    }

    /**
     * @description get records from junction object based on Header__c
     * @param headerId
     */
    private static List<Header_Sheet__c> getHeaderSheetsByHeader(Set<Id> headerIds) {
        return [ SELECT Id, Header__c, CreatedDate, isManuallyCreated__c, Sheet__c, Status__c, Requester__c, isPolluted__c FROM Header_Sheet__c WHERE Header__c IN :headerIds AND IsDeleted__c = FALSE ];
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
        Map<Id, EQCC_Checked_Sheet__c> sheets = new Map<Id, EQCC_Checked_Sheet__c>( [ SELECT Id, Name, Form_Name__c, Form_Type__c, Sheet_Code__c, Status__c, CreatedDate, Group__c FROM EQCC_Checked_Sheet__c WHERE Id IN :sheetIds ] );
        return sheets;
    }

    private static List<EQCC_Header__c> getHeaderFromNotification(String notificationIdentifier) {
        return [ SELECT Id, Name, FunctionalLocation__r.Name, Equipment__r.Name, Notification__r.Notification_Number__c, Notification__r.Description__c, Order__r.Order_Number__c, Order__r.Description__c FROM EQCC_Header__c WHERE Notification__c = :notificationIdentifier AND IsDeleted__c = FALSE WITH SECURITY_ENFORCED ];
    }

    private static Map<EQCC_Header__c, Set<CheckedSheetWrapper>> buildSheetsByHeader(
        Map<Id, EQCC_Header__c> headers,
        List<Header_Sheet__c> headerSheets,
        Map<Id, EQCC_Checked_Sheet__c> sheets
    ) {
        Map<EQCC_Header__c, Set<CheckedSheetWrapper>> sheetsByHeader = new Map<EQCC_Header__c, Set<CheckedSheetWrapper>>();

        Date mDate;
        for (Header_Sheet__c headerSheet : headerSheets) {
            mDate = getDateFromDatetime(headerSheet.CreatedDate);
            if (!sheetsByHeader.containsKey(headers.get(headerSheet.Header__c))) {
                sheetsByHeader.put( headers.get(headerSheet.Header__c), new Set<CheckedSheetWrapper>{ new CheckedSheetWrapper( sheets.get(headerSheet.Sheet__c), headerSheet.Status__c, headerSheet.Requester__c, mDate, headerSheet.isManuallyCreated__c, headerSheet.Id, headerSheet.isPolluted__c ) } );
            } else {
                sheetsByHeader.get(headers.get(headerSheet.Header__c)).add( new CheckedSheetWrapper( sheets.get(headerSheet.Sheet__c), headerSheet.Status__c, headerSheet.Requester__c, mDate, headerSheet.isManuallyCreated__c, headerSheet.Id, headerSheet.isPolluted__c ) );
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
        List<Profile> isAdmin = [ SELECT Id FROM Profile WHERE Id = :UserInfo.getProfileId() AND Name = 'System Administrator' ];
        List<HeaderSheetWrapper> wrappers = new List<HeaderSheetWrapper>();
        Boolean isOwnerOrAdmin;
        Set<Id> ownedHeaderIds = getHeadersOwnedByUser(sheetsByHeader.keySet());
        for (EQCC_Header__c header : sheetsByHeader.keySet()) {
            isOwnerOrAdmin = !isAdmin.isEmpty() || ownedHeaderIds.contains(header.Id);
            wrappers.add( new HeaderSheetWrapper( header, new List<CheckedSheetWrapper>(sheetsByHeader.get(header)), isOwnerOrAdmin ) );
        }
        return wrappers;
    }

    private static Set<Id> getHeadersOwnedByUser(Set<EQCC_Header__c> headers) {
        Set<Id> headerIds = new Map<Id, EQCC_Header__c>(new List<EQCC_Header__c>(headers)).keySet();
        return new Map<Id, EQCC_Header__c>([SELECT Id FROM EQCC_Header__c WHERE Id IN :headerIds AND OwnerId = :UserInfo.getUserId()]).keySet();
    }

    /**
     * @description marks as Deleted EQCC_Header__c and related records by Id
     * @param recordId String of EQCC_Header__c Id to delete
     * @return Boolean
     */
    @AuraEnabled
    public static Boolean deleteEQCCHeader(String recordId) {
        try {
            EQCC_Header__c headerToDelete = [ SELECT Id FROM EQCC_Header__c WHERE Id = :recordId WITH SECURITY_ENFORCED LIMIT 1 ];

            List<Header_Sheet__c> headerJunctionRecord = [ SELECT Id, Sheet__c FROM Header_Sheet__c WHERE Header__c = :recordId WITH SECURITY_ENFORCED ];

            List<EQCC_Step__c> stepsToDelete = [ SELECT Id, Name FROM EQCC_Step__c WHERE Header_Sheet__c IN :headerJunctionRecord WITH SECURITY_ENFORCED ];

            markHeadersAsDeleted(new List<EQCC_Header__c>{ headerToDelete });
            markStepsAsDeleted(stepsToDelete);
            markHeaderSheetsAsDeleted(headerJunctionRecord);

            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * @description Gets the IDs of related Notification and Order
     * @param headerId String of EQCC_Header__c Id that is related
     * @return EQCC_Header__c containing Notifcation and Order Ids
     */
    @AuraEnabled
    public static EQCC_Header__c getNotificationOrderId(String headerId) {
        return [ SELECT Notification__c, Order__c, Order_Operation__c FROM EQCC_Header__c WHERE Id = :headerId WITH SECURITY_ENFORCED LIMIT 1 ];
    }

    /**
     * @description marks as Deleted records based on EQCC_Header Id if no autogenerated
     * @param headerId String of EQCC_Header__c Id that is related
     * @return Boolen true if successful
     */
    @AuraEnabled
    public static Boolean deleteManualEQCCHeader(String headerId) {
        List<Header_Sheet__c> headers = [ SELECT Id, isManuallyCreated__c FROM Header_Sheet__c WHERE Header__c = :headerId WITH SECURITY_ENFORCED ]; 
        List<Boolean> manuallyCreated = new List<Boolean>();
        for (Integer i = 0; i < headers.size(); i++) {
            manuallyCreated.add(headers[i].isManuallyCreated__c);
        }

        if (manuallyCreated.contains(false)) {
// cancel delete if there is auto generated headers
            return false;
        } else {
            List<EQCC_Header__c> eqccheader = [ SELECT Id FROM EQCC_Header__c WHERE Id = :headerId WITH SECURITY_ENFORCED ];
            List<EQCC_Step__c> steps = [ SELECT Id FROM EQCC_Step__c WHERE Header_Sheet__c IN :headers WITH SECURITY_ENFORCED ];

            markHeaderSheetsAsDeleted(headers);
            markHeadersAsDeleted(eqccHeader);
            markStepsAsDeleted(steps);

            return true;
        }
    }

    private static Date getDateFromDatetime(Datetime mDatetime) {
        return Date.newInstance(mDatetime.year(), mDatetime.month(), mDatetime.day());
    }

    private static List<EQCC_Header__c> getHeadersById(Set<Id> headerIds) {
        return [ SELECT Id, Name, FunctionalLocation__r.Name, Equipment__r.Name, Notification__r.Notification_Number__c, Order__r.Order_Number__c FROM EQCC_Header__c WHERE Id IN :headerIds WITH SECURITY_ENFORCED ];
    }

    private static void markHeadersAsDeleted(List<EQCC_Header__c> headers) {
        for (EQCC_Header__c header : headers) {
            header.IsDeleted__c = true;
        }

        if (Schema.SObjectType.EQCC_Header__c.isUpdateable()) {
            update headers;
        }
    }

    private static void markStepsAsDeleted(List<EQCC_Step__c> stepsToDelete) {
        for (EQCC_Step__c step : stepsToDelete) {
            step.isDeleted__c = true;
        }
        if (Schema.SObjectType.EQCC_Step__c.isUpdateable()) {
            update stepsToDelete;
        }
    }

    private static void markHeaderSheetsAsDeleted(List<Header_Sheet__c> headerSheets) {
        for (Header_Sheet__c headerSheet : headerSheets) {
            headerSheet.IsDeleted__c = true;
        }

        if (Schema.SObjectType.Header_Sheet__c.isUpdateable()) {
            update headerSheets;
        }
    }
}