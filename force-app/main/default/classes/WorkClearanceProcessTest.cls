/**
 * @author Oktana
 * @description test class for PB 'Work_Clearance_Process'
 */
@isTest
public with sharing class WorkClearanceProcessTest {
    /**
     * @given PB Work_Clearance_Process
     * @when Work Clearance is created
     * @then Work Clearance's Main Work Center Text is updated
     */
    @IsTest
    private static void testMWCTextNameUpdateWhenCreatingWorkClearance() {
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        Master_Map__c masterMapMWC = new Master_Map__c(
            Name = 'ENMA-E',
            Code__c = 'ENMA-E',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = masterMapSet.Id
        );
        insert masterMapMWC;

        Work_Clearance__c wClearance = new Work_Clearance__c();
        wClearance.main_work_center__c = masterMapMWC.Id;
        wClearance.Description__c = 'Test Description';

        Test.startTest();
        insert wClearance;
        Test.stopTest();
        Work_Clearance__c insertedWClearance = [
            SELECT Id, Main_Work_Center_Text__c
            FROM Work_Clearance__c
            WHERE Id = :wClearance.Id
        ];

        System.assertEquals(
            masterMapMWC.Name,
            insertedWClearance.Main_Work_Center_Text__c,
            'Main Work Center Name was not updated'
        );
    }

    /**
     * @given PB Work_Clearance_Process
     * @when Work Clearance is updated
     * @then Work Clearance's Main Work Center Text is updated
     */
    @IsTest
    private static void testMWCTextNameUpdateWhenUpdatingWorkClearance() {
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        Master_Map__c masterMapMWC = new Master_Map__c(
            Name = 'ENMA-E',
            Code__c = 'ENMA-E',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = masterMapSet.Id
        );
        insert masterMapMWC;

        Work_Clearance__c wClearance = new Work_Clearance__c();
        wClearance.Description__c = 'Test Description';

        insert wClearance;

        wClearance.main_work_center__c = masterMapMWC.Id;

        Test.startTest();
        update wClearance;
        Test.stopTest();
        Work_Clearance__c insertedWClearance = [
            SELECT Id, Main_Work_Center_Text__c
            FROM Work_Clearance__c
            WHERE Id = :wClearance.Id
        ];

        System.assertEquals(
            masterMapMWC.Name,
            insertedWClearance.Main_Work_Center_Text__c,
            'Main Work Center Name was not updated'
        );
    }
}