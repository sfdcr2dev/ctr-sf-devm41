/**
 * @author R2
 * @description helper for SetEQCCHeaderHelper Trigger
 */
public with sharing class SetEQCCHeaderHelper {
	public static void updateEQCCHeader(List<EQCC_Header__c> eqccHeaders){

        Map<Id, List<Header_Sheet__c>> eqccHeaderMap = new Map<Id, List<Header_Sheet__c>>();
        Set<Id> eqccHeaderIdSet = new Set<Id>();
        for (EQCC_Header__c eqccHeader : eqccHeaders){
            //List<Header_Sheet__c> headerSheets = [SELECT Id, Sheet__r.Form_Name__c FROM Header_Sheet__c WHERE Header__c =: eqccHeader.Id];
            eqccHeaderIdSet.add(eqccHeader.Id);
            
        }

        for(EQCC_Header__c eqccHeader : [SELECT Id, (SELECT Id, Sheet__r.Form_Name__c FROM Header_Sheets__r) FROM EQCC_Header__c WHERE Id IN: eqccHeaderIdSet]) {
            eqccHeaderMap.put(eqccHeader.Id, eqccHeader.Header_Sheets__r);
        }

        for(EQCC_Header__c eqccHeader : eqccHeaders) {
            if(eqccHeaderMap.containsKey(eqccHeader.Id)) {
                List<Header_Sheet__c> headerSheets = eqccHeaderMap.get(eqccHeader.Id);
                String str = '';
                for(Header_Sheet__c headerSheet : headerSheets) {
                    str += headerSheet.Sheet__r.Form_Name__c + ',';
                }
                eqccHeader.Form_Name_Text__c = str;
            }
        }
	}
}