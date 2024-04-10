/**
 * @author Oktana
 * @description test class for PB 'EqccHeader_Process'
 */
@isTest
public with sharing class EqccHeaderProcessTest {
    /**
     * @given PB EqccHeader_Process
     * @when a EQCC Header is created with a notification
     * @then EQCC Header's Main Work Center Text is updated
     */
    @IsTest
    private static void testMWCTextNameUpdateWhenCreatingEqccHeaderWithNotification() {
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        Master_Map__c masterMapMWC = new Master_Map__c(
            Name = 'ENMA-E',
            Code__c = 'ENMA-E',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = masterMapSet.Id
        );
        insert masterMapMWC;

        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            AssignedTo__c = UserInfo.getUserId(),
            Main_Work_Center__c = masterMapMWC.Id
        );

        insert notification;

        EQCC_Header__c header = new EQCC_Header__c();
        header.Notification__c = notification.Id;

        Test.startTest();
        insert header;
        Test.stopTest();

        EQCC_Header__c insertedHeader = [SELECT Id, Notification__r.Main_Work_Center_Text__c FROM EQCC_Header__c][0];

        System.assertEquals(
            masterMapMWC.Name,
            insertedHeader.Notification__r.Main_Work_Center_Text__c,
            'Main Work Center Name was not updated'
        );
    }

    /**
     * @given PB EqccHeader_Process
     * @when a EQCC Header is updated with a notification
     * @then EQCC Header's Main Work Center Text is updated
     */
    @IsTest
    private static void testMWCTextNameUpdateWhenUpdatingEqccHeaderWithNotification() {
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        Master_Map__c masterMapMWC = new Master_Map__c(
            Name = 'ENMA-E',
            Code__c = 'ENMA-E',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = masterMapSet.Id
        );
        insert masterMapMWC;

        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            AssignedTo__c = UserInfo.getUserId(),
            Main_Work_Center__c = masterMapMWC.Id
        );

        insert notification;

        EQCC_Header__c header = new EQCC_Header__c();

        insert header;

        header.Notification__c = notification.Id;

        Test.startTest();
        update header;
        Test.stopTest();

        EQCC_Header__c insertedHeader = [SELECT Id, Notification__r.Main_Work_Center_Text__c FROM EQCC_Header__c][0];

        System.assertEquals(
            masterMapMWC.Name,
            insertedHeader.Notification__r.Main_Work_Center_Text__c,
            'Main Work Center Name was not updated'
        );
    }

    /**
     * @given PB EqccHeader_Process
     * @when a EQCC Header is created with an order
     * @then EQCC Header's Main Work Center Text is updated
     */
    @IsTest
    private static void testMWCTextNameUpdateWhenCreatingEqccHeaderWithOrder() {
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        Master_Map__c masterMapMWC = new Master_Map__c(
            Name = 'ENMA-E',
            Code__c = 'ENMA-E',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = masterMapSet.Id
        );
        insert masterMapMWC;

        Order__c order = new Order__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            Main_Work_Center__c = masterMapMWC.Id,
            Main_Work_Center_Text__c = masterMapMWC.name
        );

        insert order;

        EQCC_Header__c header = new EQCC_Header__c();
        header.Order__c = order.Id;

        Test.startTest();
        insert header;
        Test.stopTest();

        EQCC_Header__c insertedHeader = [SELECT Id, Order__r.Main_Work_Center_Text__c FROM EQCC_Header__c][0];

        System.assertEquals(
            masterMapMWC.Name,
            insertedHeader.Order__r.Main_Work_Center_Text__c,
            'Main Work Center Name was not updated'
        );
    }

    /**
     * @given PB EqccHeader_Process
     * @when a EQCC Header is updated with an order
     * @then EQCC Header's Main Work Center Text is updated
     */
    @IsTest
    private static void testMWCTextNameUpdateWhenUpdatingEqccHeaderWithOrder() {
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        Master_Map__c masterMapMWC = new Master_Map__c(
            Name = 'ENMA-E',
            Code__c = 'ENMA-E',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = masterMapSet.Id
        );
        insert masterMapMWC;

        Order__c order = new Order__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            Main_Work_Center__c = masterMapMWC.Id,
            Main_Work_Center_Text__c = masterMapMWC.name
        );

        insert order;

        EQCC_Header__c header = new EQCC_Header__c();

        insert header;

        header.Order__c = order.Id;

        Test.startTest();
        update header;
        Test.stopTest();

        EQCC_Header__c insertedHeader = [SELECT Id, Order__r.Main_Work_Center_Text__c FROM EQCC_Header__c][0];

        System.assertEquals(
            masterMapMWC.Name,
            insertedHeader.Order__r.Main_Work_Center_Text__c,
            'Main Work Center Name was not updated'
        );
    }
}