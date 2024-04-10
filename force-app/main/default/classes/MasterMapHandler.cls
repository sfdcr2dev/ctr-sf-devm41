/**
 * @author Oktana
 */
public with sharing class MasterMapHandler {
    /**
     * @description populates Master_Map_Set__c for every new Master Map
     */
    public static void setMasterMapSet(List<Master_Map__c> masters) {
        List<Master_Map_Set__c> masterMapSet = getMasterMapSet();

        Id masterMapSetId;
        if (masterMapSet.isEmpty()) {
            Master_Map_Set__c newSet = new Master_Map_Set__c();
            if (Schema.SObjectType.Master_Map_Set__c.isCreateable()) {
                insert newSet;
                masterMapSetId = newSet.Id;
            }
        } else {
            masterMapSetId = masterMapSet.get(0).Id;
        }

        for (Master_Map__c masterMap : masters) {
            System.debug('====> ' + JSON.serializePretty(masterMap));
            masterMap.Master_Map_Set__c = masterMapSetId;
        }
    }

    private static List<Master_Map_Set__c> getMasterMapSet() {
        return [SELECT Id FROM Master_Map_Set__c];
    }
}