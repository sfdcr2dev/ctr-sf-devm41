/**
 * @author Oktana
 */
public with sharing class EquipmentHandler {
    /**
     * @description populates Last_Related_Equipment__c on Functional Location
     */
    public static void handleLastRelatedEquipment(List<Equipment__c> equipments) {
        Map<Id, Id> equipmentsByFL = new Map<Id, Id>();

        for (Equipment__c equipment : equipments) {
            if (equipment.FL__c != null) {
                equipmentsByFL.put(equipment.FL__c, equipment.Id);
            }
        }

        List<Functional_Location__c> funcLocations = getFunctionalLocationsById(new Set<Id>(equipmentsByFL.keySet()));

        List<Functional_Location__c> funcLocationsToUpdate = new List<Functional_Location__c>();
        for (Functional_Location__c funcLocation : funcLocations) {
            if (funcLocation.First_Related_Equipment__c == null) {
                funcLocation.First_Related_Equipment__c = equipmentsByFL.get(funcLocation.Id);
                funcLocationsToUpdate.add(funcLocation);
            }
        }

        if (Schema.SObjectType.Functional_Location__c.isUpdateable()) {
            System.debug('====> ' + JSON.serializePretty(funcLocationsToUpdate));
            update funcLocationsToUpdate;
        }
    }

    private static List<Functional_Location__c> getFunctionalLocationsById(Set<Id> funcLocationIds) {
        return [
            SELECT Id, First_Related_Equipment__c
            FROM Functional_Location__c
            WHERE Id IN :funcLocationIds
            WITH SECURITY_ENFORCED
        ];
    }

    public static void handleEquipment(List<Equipment__c> equipments) {
        Set<String> flText = new Set<String>();
        for (Equipment__c equipment : equipments) {
            if (equipment.FL_Text__c != null) {
                flText.add(equipment.FL_Text__c);
            }
        }
        Map<String, Id> flMap = new Map<String, Id>();
        for(Functional_Location__c fl : [SELECT Id, Name FROM Functional_Location__c WHERE Name IN: flText]) {
            flMap.put(fl.Name, fl.Id);
        }

        for (Equipment__c equipment : equipments) {
            if (equipment.FL_Text__c != null) {
                equipment.FL__c = flMap.get(equipment.FL_Text__c);
            }
        }
    }
}