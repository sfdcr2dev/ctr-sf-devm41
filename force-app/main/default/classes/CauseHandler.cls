/**
 * @author Oktana
 */
public with sharing class CauseHandler {
    /**
     * @description populates Cause_No__c and ItemCause__c for every new Cause
     */
    public static void handleItemCause(List<Cause__c> causes) {
        Set<Id> itemIds = new Set<Id>();
        for (Cause__c cause : causes) {
            itemIds.add(cause.Item__c);
        }

        Map<Id, Item__c> items = new Map<Id, Item__c>(getItemsById(itemIds));
        Map<Id, Item__c> itemsToUpdate = new Map<Id, Item__c>();

        Integer lastCauseNo;
        String itemNo;
        for (Cause__c cause : causes) {
            lastCauseNo = (items.get(cause.Item__c).Last_Cause__c != null)
                ? Integer.valueOf(items.get(cause.Item__c).Last_Cause__c)
                : 0;
            lastCauseNo = getNextCauseNo(lastCauseNo);
            itemNo = items.get(cause.Item__c).Item_No__c;

            cause.Cause_No__c = String.valueOf(lastCauseNo);
            cause.Sort_No__c = String.valueOf(lastCauseNo);
            cause.ItemCause__c = cause.Notification__c + itemNo + String.valueOf(lastCauseNo);

            items.get(cause.Item__c).Last_Cause__c = String.valueOf(lastCauseNo);
            itemsToUpdate.put(cause.Item__c, items.get(cause.Item__c));
        }

        if (Schema.SObjectType.Cause__c.isUpdateable()) {
            update itemsToUpdate.values();
        }
    }

    private static Integer getNextCauseNo(Integer currentCauseNo) {
        return currentCauseNo + 1;
    }

    private static List<Item__c> getItemsById(Set<Id> itemIds) {
        return [SELECT Id, Last_Cause__c, Item_No__c FROM Item__c WHERE Id IN :itemIds WITH SECURITY_ENFORCED];
    }
}