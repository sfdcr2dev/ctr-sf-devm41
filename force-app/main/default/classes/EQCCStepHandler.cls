/**
 * @author Oktana
 */
public without sharing class EQCCStepHandler {
    public static void updateHeaderSheetStatus(Map<Id, sObject> newSteps, Map<Id, sObject> oldSteps) {
        Set<Id> headerSheetIds = new Set<Id>();
        Map<Id, String> headerSheetStatus = new Map<Id, String>();

        for (EQCC_Step__c step : (List<EQCC_Step__c>) newSteps.values()) {
            if (step.Status__c != ((EQCC_Step__c) oldSteps.get(step.Id)).Status__c) {
                headerSheetIds.add(step.Header_Sheet__c);
                headerSheetStatus.put(step.Header_Sheet__c, step.Status__c);
            }
        }

        List<Header_Sheet__c> headerSheets = getHeaderSheetsByIds(headerSheetIds);

        for (Header_Sheet__c headerSheet : headerSheets) {
            headerSheet.Status__c = headerSheetStatus.get(headerSheet.Id);
        }

        if (Schema.SObjectType.Header_Sheet__c.isUpdateable()) {
            update headerSheets;
        }
    }

    private static List<Header_Sheet__c> getHeaderSheetsByIds(Set<Id> headerSheetIds) {
        return [SELECT Id, Status__c FROM Header_Sheet__c WHERE Id IN :headerSheetIds];
    }
}