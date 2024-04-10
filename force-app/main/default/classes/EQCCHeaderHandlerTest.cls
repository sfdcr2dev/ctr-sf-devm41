/**
 * @author Oktana
 * @description test class for EQCCHeaderHandler
 */
@isTest
public with sharing class EQCCHeaderHandlerTest {
    @testSetup
    static void setup() {
        Master_Map_Set__c mapSet = new Master_Map_Set__c();
        insert mapSet;
        Master_Map__c masterMapNotification = new Master_Map__c(
            Name = 'Test Master Notification',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = mapSet.Id
        );
        insert masterMapNotification;
        Master_Map__c masterMapOrder = new Master_Map__c(
            Name = 'Test Master Order',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = mapSet.Id
        );
        insert masterMapOrder;
        Master_Map__c masterMapEquipment = new Master_Map__c(
            Name = 'Test Master Equipment',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = mapSet.Id
        );
        insert masterMapEquipment;
        Master_Map__c masterMapFLocation = new Master_Map__c(
            Name = 'Test Master FLocation',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = mapSet.Id
        );
        insert masterMapFLocation;
        Notification__c notification = new Notification__c(
            Notification_Number__c = '10676451',
            Main_Work_Center__c = masterMapNotification.Id
        );
        insert notification;

        Order__c order = new Order__c(Name = '12345678', Main_Work_Center__c = masterMapOrder.Id);
        insert order;

        Equipment__c equipment = new Equipment__c(Name = 'Equipment', mainWorkCenter__c = masterMapEquipment.Id);
        insert equipment;

        Functional_Location__c fLocation = new Functional_Location__c(
            Name = 'fLocation',
            MainWorkCenter__c = masterMapFLocation.Id
        );
        insert fLocation;
    }

    /**
     * @given an EQCC Header with a Notification with Main Work Center
     * @when the EQCC Header is inserted
     * @then the EQCC Header Main Work Center value is pulled from the Notification's MWC
     */
    @isTest
    static void testMainWorkCenterNotification() {
        Notification__c notification = getNotification();
        Order__c order = getOrder();
        Equipment__c equipment = getEquipment();
        Functional_Location__c fLocation = getFunctionalLocation();
        EQCC_Header__c header = new EQCC_Header__c(
            Notification__c = notification.Id,
            Order__c = order.Id,
            Equipment__c = equipment.Id,
            FunctionalLocation__c = fLocation.Id
        );

        Test.startTest();
        insert header;
        Test.stopTest();

        header = getHeaderById(header.Id);

        System.assertEquals(
            notification.Main_Work_Center__c,
            header.Main_Work_Center_Text__c,
            'EQCC Header MWC value should have been pulled from the Notification MWC'
        );
    }

    /**
     * @given an EQCC Header with an Order with Main Work Center
     * @when the EQCC Header is inserted
     * @then the EQCC Header Main Work Center value is pulled from the Orders's MWC
     */
    @isTest
    static void testMainWorkCenterOrder() {
        Order__c order = getOrder();
        Equipment__c equipment = getEquipment();
        Functional_Location__c fLocation = getFunctionalLocation();
        EQCC_Header__c header = new EQCC_Header__c(
            Order__c = order.Id,
            Equipment__c = equipment.Id,
            FunctionalLocation__c = fLocation.Id
        );

        Test.startTest();
        insert header;
        Test.stopTest();

        header = getHeaderById(header.Id);

        System.assertEquals(
            order.Main_Work_Center__c,
            header.Main_Work_Center_Text__c,
            'EQCC Header MWC value should have been pulled from the Order MWC'
        );
    }

    /**
     * @given an EQCC Header with an Equipment with Main Work Center
     * @when the EQCC Header is inserted
     * @then the EQCC Header Main Work Center value is pulled from the Equipment's MWC
     */
    @isTest
    static void testMainWorkCenterEquipment() {
        Equipment__c equipment = getEquipment();
        Functional_Location__c fLocation = getFunctionalLocation();
        EQCC_Header__c header = new EQCC_Header__c(Equipment__c = equipment.Id, FunctionalLocation__c = fLocation.Id);

        Test.startTest();
        insert header;
        Test.stopTest();

        header = getHeaderById(header.Id);

        System.assertEquals(
            equipment.MainWorkCenter__c,
            header.Main_Work_Center_Text__c,
            'EQCC Header MWC value should have been pulled from the Equipment MWC'
        );
    }

    /**
     * @given an EQCC Header with a Functional Location with Main Work Center
     * @when the EQCC Header is inserted
     * @then the EQCC Header Main Work Center value is pulled from the Funcationl Location's MWC
     */
    @isTest
    static void testMainWorkCenterFunctionalLocation() {
        Functional_Location__c fLocation = getFunctionalLocation();
        EQCC_Header__c header = new EQCC_Header__c(FunctionalLocation__c = fLocation.Id);

        Test.startTest();
        insert header;
        Test.stopTest();

        header = getHeaderById(header.Id);

        System.assertEquals(
            fLocation.MainWorkCenter__c,
            header.Main_Work_Center_Text__c,
            'EQCC Header MWC value should have been pulled from the Functional Location MWC'
        );
    }

    private static Notification__c getNotification() {
        return [SELECT Id, Main_Work_Center__c FROM Notification__c LIMIT 1];
    }

    private static Equipment__c getEquipment() {
        return [SELECT Id, MainWorkCenter__c FROM Equipment__c LIMIT 1];
    }

    private static Functional_Location__c getFunctionalLocation() {
        return [SELECT Id, MainWorkCenter__c FROM Functional_Location__c LIMIT 1];
    }

    private static EQCC_Header__c getHeaderById(Id headerId) {
        return [SELECT Id, Main_Work_Center_Text__c FROM EQCC_Header__c WHERE Id = :headerId];
    }

    private static Order__c getOrder() {
        return [SELECT Id, Main_Work_Center__c FROM Order__c LIMIT 1];
    }
}