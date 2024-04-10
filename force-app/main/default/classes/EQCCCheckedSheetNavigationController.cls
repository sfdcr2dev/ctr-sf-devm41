public with sharing class EQCCCheckedSheetNavigationController {
    /**
     * @description retrieves a Step from a Checked Sheet
     * @param stepId id of known Step from the Checked Sheet
     * @param stepNum step number to retrieve
     */
    @AuraEnabled(cacheable=true)
    public static EQCC_Step__c getStepFromNumber(Id stepId, Integer stepNum) {
        Id parentCheckedSheet = [SELECT Header_Sheet__c FROM EQCC_Step__c WHERE Id = :stepId LIMIT 1].Header_Sheet__c;

        return [SELECT Id, Form_Group__c FROM EQCC_Step__c WHERE Step_Number__c = :stepNum AND Header_Sheet__c = :parentCheckedSheet];
    }

    /**
     * @description retrieves current Step Id based on a Checked Sheet Id
     * @param headerSheetId Checked Sheet Id
     */
    @AuraEnabled
    public static Id getIdOfCurrentStep(Id headerSheetId) {
        List<EQCC_Step__c> currentStep = [
            SELECT Id
            FROM EQCC_Step__c
            WHERE Header_Sheet__c = :headerSheetId
                AND Is_Current__c = TRUE
                AND IsDeleted__c = false
            WITH SECURITY_ENFORCED
            ORDER BY Step_Number__c DESC
            LIMIT 1
        ];

        if (currentStep.size() == 1) {
            return currentStep[0].Id;
        } else {
            return null;
        }

    }

    /**
     * @description retrieve EQCC Checked Sheets available from EQCC Header
     */
    @AuraEnabled
    public static List<EQCC_Checked_Sheet__c> retrieveSuggestedCheckedSheets(Id headerId) {
        EQCC_Header__c header = getHeaderById(headerId);
        List<EQCC_Checked_Sheet__c> sheets;

        if (header.Order_Operation__c != null) {
            sheets = THOR_CheckedSheetController.retrieveCheckedSheetsFromOrderOperation(header.Order_Operation__c);
        } else {
            sheets = THOR_CheckedSheetController.retrieveCheckedSheets(
                header.Equipment__c,
                header.FunctionalLocation__c
            );
        }

        return sheets;
    }

    /**
     * @description associates Checked Sheet with Header
     * @param sheetId
     * @param headerId
     */
    @AuraEnabled
    public static Id associateCheckedSheetToHeader(Id sheetId, Id headerId) {
        List<Header_Sheet__c> headerSheets = existsHeaderSheet(sheetId, headerId);

        if (headerSheets.isEmpty()) {
            Header_Sheet__c headerSheet = new Header_Sheet__c(
                Header__c = headerId,
                Sheet__c = sheetId,
                isManuallyCreated__c = true
            );

            if (Schema.sObjectType.Header_Sheet__c.isCreateable()) {
                insert headerSheet;
                return headerSheet.Id;
            } else {
                throw new AuraHandledException('No sufficient permissions');
            }
        }

        return headerSheets.get(0).Id;
    }

    private static EQCC_Header__c getHeaderById(Id headerId) {
        return [
            SELECT Id, Equipment__c, FunctionalLocation__c, Order_Operation__c
            FROM EQCC_Header__c
            WHERE Id = :headerId
                AND IsDeleted__c = false
            WITH SECURITY_ENFORCED
        ];
    }

    private static List<Header_Sheet__c> existsHeaderSheet(Id sheetId, Id headerId) {
        List<Header_Sheet__c> headerSheets = [
            SELECT Id
            FROM Header_Sheet__c
            WHERE Sheet__c = :sheetId
                AND Header__c = :headerId
                AND IsDeleted__c = false
        ];

        return headerSheets;
    }
}