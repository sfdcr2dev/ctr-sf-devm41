/**
 * @author Oktana
 * @description test class for EquipmentHandler
 */
@isTest
public with sharing class EquipmentHandlerTest {
    /**
     * @given a new Equipment with FL populated
     * @when Equipment is inserted
     * @then First_Related_Equipment__c is populated for the Functional Location
     */
    @isTest
    static void testFirstRelatedEquipment() {
        Functional_Location__c funcLocation = new Functional_Location__c(Name = 'Test');
        insert funcLocation;

        Equipment__c equipment = new Equipment__c(Name = 'Test Equipment', FL__c = funcLocation.Id);

        Test.startTest();
        insert equipment;
        Test.stopTest();

        funcLocation = getFunctionalLocationById(funcLocation.Id);

        System.assertEquals(
            equipment.Id,
            funcLocation.First_Related_Equipment__c,
            'First_Related_Equipment__c should have been populated'
        );
    }

    /**
     * @given an Equipment with FL populated
     * @when Equipment is updated with a new FL
     * @then FL keeps the first Equipment as the First_Related_Equipment__c
     */
    @isTest
    static void testFirstRelatedEquipmentWhenSeveralEquipments() {
        Functional_Location__c funcLocation = new Functional_Location__c(Name = 'Test');
        insert funcLocation;

        Equipment__c equipment = new Equipment__c(Name = 'Test Equipment', FL__c = funcLocation.Id);
        insert equipment;

        Equipment__c newEquipment = new Equipment__c(Name = 'New Equipment', FL__c = funcLocation.Id);

        Test.startTest();
        insert newEquipment;
        newEquipment.FL_Text__c = 'Test';
        update newEquipment;
        Test.stopTest();

        funcLocation = getFunctionalLocationById(funcLocation.Id);

        System.assertEquals(
            equipment.Id,
            funcLocation.First_Related_Equipment__c,
            'FL should have kept the first Equipment as the First_Related_Equipment__c'
        );
    }

    private static Functional_Location__c getFunctionalLocationById(Id funcLocationId) {
        return [SELECT Id, First_Related_Equipment__c FROM Functional_Location__c WHERE Id = :funcLocationId];
    }
}