public with sharing class CaseLineItemsHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    
    public void beforeInsert(List<SObject> newItems) {}
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        // Set<Id> caseIds = new Set<Id>();
        // for (OPP_Case_Line_Items__c caseLineItem : (List<OPP_Case_Line_Items__c>)newItems.values()) caseIds.add(caseLineItem.Case__c);
        // Map<Id, Case> caseMaps = new Map<Id, Case>([SELECT Id, Status, Request_From_Type__c, Current_user__c FROM Case WHERE Id IN :caseIds]);

        CaseLineItemsHandler.reviseNewWinNo((Map<Id, OPP_Case_Line_Items__c>)newItems, (Map<Id, OPP_Case_Line_Items__c>)oldItems);
        // CaseLineItemsHandler.opp_dgcheckprice_valdiated((Map<Id, OPP_Case_Line_Items__c>)newItems, caseMaps);

    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
        // Set<Id> caseIds = new Set<Id>();
        // for (OPP_Case_Line_Items__c caseLineItem : (List<OPP_Case_Line_Items__c>)newItems.values()) caseIds.add(caseLineItem.Case__c);
        // Map<Id, Case> caseMaps = new Map<Id, Case>([SELECT Id, Status, Request_From_Type__c, Current_user__c FROM Case WHERE Id IN :caseIds]);

        // if(![SELECT Id, Name FROM Profile WHERE Id = :Userinfo.getProfileId()]?.Name.containsIgnoreCase('System Administrator')) {
        //     CaseLineItemsHandler.validateDeleteCaseLineItems((Map<Id, OPP_Case_Line_Items__c>)oldItems, caseMaps);
        // }
    }

    public void afterInsert(Map<Id, SObject> newItems) {}
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
    public void afterDelete(Map<Id, SObject> oldItems) {}
    public void afterUndelete(Map<Id, SObject> oldItems) {}



    private static void reviseNewWinNo(Map<Id, OPP_Case_Line_Items__c> newItems, Map<Id, OPP_Case_Line_Items__c> oldItems) {
        for (OPP_Case_Line_Items__c caseLineItem : newItems.values()) {
            if(OPP_Case_Line_Items__c.SObjectType.getDescribe().getRecordTypeInfosById().get(caseLineItem.RecordTypeId).getDeveloperName().containsIgnoreCase('Hardware') &&
                caseLineItem.New_WinNo__c != oldItems.get(caseLineItem.Id).get('New_WinNo__c')){
                caseLineItem.Is_Summited_PMAsset__c = false;
            }
        }
    }

    // private static void opp_dgcheckprice_valdiated(Map<Id, OPP_Case_Line_Items__c> newItems, Map<Id, Case> caseMaps) {
    //     for (OPP_Case_Line_Items__c caseLineItem : newItems.values()) {
    //         if(new List<String>{ 'Hardware' , 'Software', 'IT Stationery' }.contains(caseMaps.get(caseLineItem.Case__c)?.Request_From_Type__c)
    //             && caseMaps.get(caseLineItem.Case__c)?.Status.equalsIgnoreCase('DG Check Price') && caseMaps.get(caseLineItem.Case__c)?.Current_user__c == true) {
                    
    //                 // Display error message if the request edit when after Submitted
    //                 caseLineItem.addError('You cannot edit information after Submit for Approval');

    //         }
    //     }
    // }

    // private static void validateDeleteCaseLineItems(Map<Id, OPP_Case_Line_Items__c> oldItems, Map<Id, Case> caseMaps) {
        
    //     for(OPP_Case_Line_Items__c caseLineItem : oldItems.values()) {
    //         if(!caseMaps.get(caseLineItem.Case__c)?.Status.equalsIgnoreCase('Draft')) {
    //             caseLineItem.addError(String.format('{0}', new List<String>{
    //                 System.Label.DG_Service_You_cannot_remove_request_items
    //             }));
    //         }
    //     }

    // }
}