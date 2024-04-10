/**
 * @author Oktana
 * @description test class for Thor_CheckedSheetController
 */
@isTest
public with sharing class Thor_CheckedSheetControllerTest {
    @testSetup
    static void setup() {
        List<Equipment__c> equipments = new List<Equipment__c>();
        for (Integer i = 0; i < 10; i += 2) {
            equipments.add(new Equipment__c(Name = 'Equipment ' + i, Object_Type__c = 'EquipmentObjectType' + i));
            equipments.add(
                new Equipment__c(Name = 'Equipment ' + (i + 1), Object_Type__c = 'EquipmentObjectType' + (i + 1))
            );
        }
        insert equipments;

        List<Functional_Location__c> funcLocations = new List<Functional_Location__c>();
        for (Integer i = 0; i < 10; i += 2) {
            funcLocations.add(
                new Functional_Location__c(Name = 'funcLocation ' + i, Object_Type__c = 'funcLocationObjectType' + i)
            );
            funcLocations.add(
                new Functional_Location__c(
                    Name = 'funcLocation ' + (i + 1),
                    Object_Type__c = 'funcLocationObjectType' + (i + 1)
                )
            );
        }
        insert funcLocations;

        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName
            FROM Checked_Sheet_Pointer__mdt
            LIMIT 1
        ];

        EQCC_Header__c header = new EQCC_Header__c();
        insert header;

        List<EQCC_Checked_Sheet__c> sheets = new List<EQCC_Checked_Sheet__c>();
        for (Integer i = 0; i < 10; i += 2) {
            sheets.add(
                new EQCC_Checked_Sheet__c(
                    Name = 'Sheet Equipment ' + i,
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'SHEETCODE' + i,
                    Form_Questions__c = 5
                )
            );
            sheets.add(
                new EQCC_Checked_Sheet__c(
                    Name = 'Sheet Equipment ' + (i + 1),
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'SHEETCODE' + (i + 1),
                    Form_Questions__c = 5
                )
            );

            sheets.add(
                new EQCC_Checked_Sheet__c(
                    Name = 'Sheet FL ' + i,
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'SHEETCODE' + i,
                    Form_Questions__c = 5
                )
            );
            sheets.add(
                new EQCC_Checked_Sheet__c(
                    Name = 'Sheet FL ' + i + 1,
                    Form_Type__c = formType.DeveloperName,
                    Sheet_Code__c = 'SHEETCODE' + (i + 1),
                    Form_Questions__c = 5
                )
            );
        }
        insert sheets;

        List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>();
        for (EQCC_Checked_Sheet__c sheet : sheets) {
            headerSheets.add(new Header_Sheet__c(Header__c = header.Id, Sheet__c = sheet.Id));
        }
        insert headerSheets;
    }

    /**
     * @given Equipment where the Object Type can suggest EQCC Checked Sheets
     * @when service to retrieve Checked Sheets based on the selected Equipment is invoked
     * @then all Checked Sheet associated to the Equipment's Object Type are retrieved
     */
    @isTest
    static void testRetieveCheckedSheetsByEquipment() {
        Id equipmentId = getEquipmentByObjectType('EquipmentObjectType6');
        Sheet_Mapping__c mapping = new Sheet_Mapping__c(
            Object_Type__c = 'EquipmentObjectType6',
            Form_Code__c = 'SHEETCODE6'
        );
        insert mapping;
        Test.startTest();
        List<EQCC_Checked_Sheet__c> sheets = THOR_CheckedSheetController.retrieveCheckedSheets(equipmentId, null);
        Test.stopTest();

        /*System.assertEquals(
            2,
            sheets.size(),
            'All Checked Sheets suggested by Object Type \'EquipmentObjectType6\' should have been retrieved'
        );*/
    }

    /**
     * @givenFunctional Location where the Object Type can suggest EQCC Checked Sheets
     * @when service to retrieve Checked Sheets based on the selected Functional Location is invoked
     * @then all Checked Sheet associated to the Functional Locations's Object Type are retrieved
     */
    @isTest
    static void testRetieveCheckedSheetsByFunctionalLocation() {
        Id functionalLocationId = getFunctionalLocationByObjectType('funcLocationObjectType6');
        Sheet_Mapping__c mapping = new Sheet_Mapping__c(
            Object_Type__c = 'funcLocationObjectType6',
            Form_Code__c = 'SHEETCODE6'
        );
        insert mapping;
        Test.startTest();
        List<EQCC_Checked_Sheet__c> sheets = THOR_CheckedSheetController.retrieveCheckedSheets(
            null,
            functionalLocationId
        );
        Test.stopTest();

        /*System.assertEquals(
            2,
            sheets.size(),
            'All Checked Sheets suggested by Object Type \'funcLocationObjectType6\' should have been retrieved'
        );*/
    }

    /**
     * @given Equiments and Functional Locations where the Object Type can suggest EQCC Checked Sheets
     * @when service to retrieve Checked Sheets based on the selected Equipment and Functional Location is invoked
     * @then all Checked Sheet associate to the Equipment's Object Type are retrieved
     */
    @isTest
    static void testRetieveCheckedSheets() {
        Id equipmentId = getEquipmentByObjectType('EquipmentObjectType6');
        Id functionalLocationId = getFunctionalLocationByObjectType('funcLocationObjectType6');
        Sheet_Mapping__c mapping = new Sheet_Mapping__c(
            Object_Type__c = 'EquipmentObjectType6',
            Form_Code__c = 'SHEETCODE6'
        );
        insert mapping;
        Test.startTest();
        List<EQCC_Checked_Sheet__c> sheets = THOR_CheckedSheetController.retrieveCheckedSheets(
            equipmentId,
            functionalLocationId
        );
        Test.stopTest();

        /*System.assertEquals(
            2,
            sheets.size(),
            'All Checked Sheets suggested by Object Type \'EquipmentObjectType6\' should have been retrieved'
        );*/
    }

    /**
     * @given a Notification Id
     * @when service to retrieve Notification is invoked
     * @then the Notification record is returned
     */
    @isTest
    static void testRetrieveEQCCNotification() {
        Notification__c notification = new Notification__c(Name = 'Test Notification');
        insert notification;

        Test.startTest();
        Notification__c retrievedNotification = THOR_CheckedSheetController.retrieveEQCCNotification(notification.Id);
        Test.stopTest();

        System.assert(retrievedNotification != null, 'Notification should have been retrieved');
    }

    /**
     * @given an Order Id
     * @when service to retrieve Order is invoked
     * @then the Order record is returned
     */
    @isTest
    static void testRetrieveEQCCOrder() {
        Order__c order = new Order__c(Name = 'Test Order');
        insert order;

        Test.startTest();
        Order__c retrievedOrder = THOR_CheckedSheetController.retrieveEQCCOrder(order.Id);
        Test.stopTest();

        System.assert(retrievedOrder != null, 'Order should have been retrieved');
    }

    /**
     * @given an Order with related Operations
     * @when service to retrieve EQCC based on Order and Operation
     * @then the EQCC Checked Sheets are returned
     */
    @isTest
    static void testRetrieveCheckedSheetsFromOrderOperation() {
        Order__c order = new Order__c(Name = 'Test Order', grouptask__c = 'Task', groupcount__c = 'Count');
        insert order;
        Order_Operation__c orderOperation = new Order_Operation__c(
            Order__c = order.Id,
            Operation_Text__c = 'Operation'
        );
        insert orderOperation;

        Sheet_Mapping__c mapping = new Sheet_Mapping__c(
            Group_Count__c = 'Count',
            Group_Task__c = 'Task',
            Operation_Text__c = 'Operation',
            Form_Code__c = 'SHEETCODE6'
        );
        insert mapping;

        List<EQCC_Checked_Sheet__c> sheets = getEQCCCheckedSheets();
        for (EQCC_Checked_Sheet__c sheet : sheets) {
            sheet.Group_Count__c = order.groupcount__c;
            sheet.Group_Task__c = order.grouptask__c;
            sheet.Sheet_Code__c = 'SHEETCODE6';
        }
        update sheets;

        Test.startTest();
        List<EQCC_Checked_Sheet__c> retrievedEQCCs = THOR_CheckedSheetController.retrieveCheckedSheetsFromOrderOperation(
            orderOperation.Id
        );
        Test.stopTest();

        //System.assert(!retrievedEQCCs.isEmpty(), 'All EQCC should have been returned');
    }

    /**
     * @given an Order with related Operations
     * @when service to retrieve Operations based on Order
     * @then the Operations are returned
     */
    @isTest
    static void testRetrieveOrderOperations() {
        Order__c order = new Order__c(Name = 'Test Order', grouptask__c = 'Task', groupcount__c = 'Count');
        insert order;

        List<Order_Operation__c> orderOperations = new List<Order_Operation__c>();
        for (Integer i = 0; i < 5; i++) {
            orderOperations.add(new Order_Operation__c(Order__c = order.Id, SubOperation__c = 'Sub' + i));
        }
        insert orderOperations;

        Test.startTest();
        List<Order_Operation__c> retrievedOperations = THOR_CheckedSheetController.retrieveOrderOperations(order.Id);
        Test.stopTest();

        System.assert(!retrievedOperations.isEmpty(), 'All Operations should have been returned');
    }

    /**
* @given a Header and Sheets
* @when service to associate Header and Sheets is invoked
* @then new Header_Sheet__c should be created
*/
    @isTest
    static void testCreateEQCCHeaderWithSheets() {
        List<Header_Sheet__c> initialHeaderSheets = getHeaderSheets();
        
        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName
            FROM Checked_Sheet_Pointer__mdt
            LIMIT 1
        ];
        
        Map<String, Object> sheetHeader = new Map<String, Object>();
        
        List<EQCC_Checked_Sheet__c> sheets = new List<EQCC_Checked_Sheet__c>();
        List<Id> sheetIds = new List<Id>();
        sheets.add(new EQCC_Checked_Sheet__c(Name = 'First Sheet', Form_Type__c = formType.DeveloperName,
                                             Form_Questions__c = 5));
        sheets.add(new EQCC_Checked_Sheet__c(Name = 'Second Sheet', Form_Type__c = formType.DeveloperName,
                                             Form_Questions__c = 5));
        insert sheets;
        sheetIds.add(sheets.get(0).Id);
        sheetIds.add(sheets.get(1).Id);

        Test.startTest();
        THOR_CheckedSheetController.createEQCCHeaderWithSheets(sheetHeader, sheetIds, null);
        Test.stopTest();

        List<Header_Sheet__c> finalHeaderSheets = getHeaderSheets();
    }

    /**
     * @given Orders with Equipment and Functional Location
     * @when service to retrieve Orders is invoked
     * @then all Orders are returned
     */
    @isTest
    static void testRetrieveOrdersWithEquipmentAndFL() {
        Equipment__c equipment = getEquipment();
        Functional_Location__c funcLocation = getFunctionalLocation();
        List<Order__c> orders = new List<Order__c>();
        for (Integer i = 0; i < 5; i++) {
            orders.add(new Order__c(Equipment__c = equipment.Id, Functional_Location__c = funcLocation.Id));
        }

        insert orders;

        Test.startTest();
        List<Order__c> retrievedOrders = THOR_CheckedSheetController.retrieveOrders(equipment.Id, funcLocation.Id);
        Test.stopTest();

        System.assertEquals(5, retrievedOrders.size(), 'All Orders should have been retrieved');
    }

    /**
     * @given Orders with Equipment and without Functional Location
     * @when service to retrieve Orders is invoked
     * @then all Orders with Equipment should be returned
     */
    @isTest
    static void testRetrieveOrdersWithEquipmentAndNotFL() {
        Equipment__c equipment = getEquipment();
        List<Order__c> orders = new List<Order__c>();
        for (Integer i = 0; i < 5; i++) {
            orders.add(new Order__c(Equipment__c = equipment.Id));
        }

        insert orders;

        Test.startTest();
        List<Order__c> retrievedOrders = THOR_CheckedSheetController.retrieveOrders(equipment.Id, null);
        Test.stopTest();

        System.assertEquals(5, retrievedOrders.size(), 'All Orders with Equipment should have been retrieved');
    }

    /**
     * @given Orders with Equipment and without Functional Location
     * @when service to retrieve Orders is invoked
     * @then all Orders with FL should be returned
     */
    @isTest
    static void testRetrieveOrdersWithFLAndNotEquipment() {
        Functional_Location__c funcLocation = getFunctionalLocation();
        List<Order__c> orders = new List<Order__c>();
        for (Integer i = 0; i < 5; i++) {
            orders.add(new Order__c(Functional_Location__c = funcLocation.Id));
        }

        insert orders;

        Test.startTest();
        List<Order__c> retrievedOrders = THOR_CheckedSheetController.retrieveOrders(null, funcLocation.Id);
        Test.stopTest();

        System.assertEquals(
            5,
            retrievedOrders.size(),
            'All Orders with Functional Location should have been retrieved'
        );
    }

    /**
     * @given Notifications with Equipment and Functional Location
     * @when service to retrieve Notifications is invoked
     * @then all Notifications are returned
     */
    @isTest
    static void testRetrieveNotificationsWithEquipmentAndFL() {
        Equipment__c equipment = getEquipment();
        Functional_Location__c funcLocation = getFunctionalLocation();
        List<Notification__c> notifications = new List<Notification__c>();
        for (Integer i = 0; i < 5; i++) {
            notifications.add(
                new Notification__c(Equipment__c = equipment.Id, Functional_Location__c = funcLocation.Id)
            );
        }

        insert notifications;

        Test.startTest();
        List<Notification__c> retrievedNotifications = THOR_CheckedSheetController.retrieveNotifications(
            equipment.Id,
            funcLocation.Id
        );
        Test.stopTest();

        System.assertEquals(5, retrievedNotifications.size(), 'All Notifications should have been retrieved');
    }

    /**
     * @given Notifications with Equipment and without Functional Location
     * @when service to retrieve Notifications is invoked
     * @then all Notifications with Equipment should be returned
     */
    @isTest
    static void testRetrieveNotificationsWithEquipmentAndNotFL() {
        Equipment__c equipment = getEquipment();
        List<Notification__c> notifications = new List<Notification__c>();
        for (Integer i = 0; i < 5; i++) {
            notifications.add(new Notification__c(Equipment__c = equipment.Id));
        }

        insert notifications;

        Test.startTest();
        List<Notification__c> retrievedNotifications = THOR_CheckedSheetController.retrieveNotifications(
            equipment.Id,
            null
        );
        Test.stopTest();

        System.assertEquals(
            5,
            retrievedNotifications.size(),
            'All Notifications with Equipment should have been retrieved'
        );
    }

    /**
     * @given Notifications with Equipment and without Functional Location
     * @when service to retrieve Notifications is invoked
     * @then all Notifications with FL should be returned
     */
    @isTest
    static void testRetrieveNotificationsWithFLAndNotEquipment() {
        Functional_Location__c funcLocation = getFunctionalLocation();
        List<Notification__c> notifications = new List<Notification__c>();
        for (Integer i = 0; i < 5; i++) {
            notifications.add(new Notification__c(Functional_Location__c = funcLocation.Id));
        }

        insert notifications;

        Test.startTest();
        List<Notification__c> retrievedNotifications = THOR_CheckedSheetController.retrieveNotifications(
            null,
            funcLocation.Id
        );
        Test.stopTest();

        System.assertEquals(
            5,
            retrievedNotifications.size(),
            'All Notifications with Functional Location should have been retrieved'
        );
    }

    /**
     * @given a Equipment and a service to retrieve Equipments with the FL
     * @when service is invoked
     * @then Equipment is returned inluding the FL__c field
     */
    @isTest
    static void testRetrieveEquipmentWithFL() {
        Functional_Location__c funcLocation = new Functional_Location__c(
            Name = 'new functional location',
            Description__c = 'a test fl'
        );
        insert funcLocation;

        Equipment__c equipment = new Equipment__c(Name = 'Equimpent', FL__c = funcLocation.Id);
        insert equipment;

        Test.startTest();
        equipment = THOR_CheckedSheetController.retrieveFunctionalLocationFromEquipment(equipment.Id);
        Test.stopTest();

        System.assertEquals(
            funcLocation.Id,
            equipment.FL__c,
            'Service should have retrieved the Equipment with the FL field'
        );
    }

    /**
     * @given Equipments, Functional Locations and a service to retrieve Equipments from a FL
     * @when service is invoked
     * @then all Equipments with the FL provided are
     */
    @isTest
    static void testRetrieveEquipmentsFromFL() {
        Functional_Location__c funcLocation = new Functional_Location__c(
            Name = 'new functional location',
            Description__c = 'a test fl'
        );
        insert funcLocation;

        List<Equipment__c> firstEquipments = new List<Equipment__c>();
        for (Integer i = 0; i < 5; i++) {
            firstEquipments.add(new Equipment__c(Name = 'Equimpent' + i, FL__c = funcLocation.Id));
        }
        insert firstEquipments;

        Test.startTest();
        List<Equipment__c> retrievedEquipments = THOR_CheckedSheetController.retrieveEquipmentsFromFunctionalLocation(
            funcLocation.Id
        );
        Test.stopTest();

        System.assertEquals(
            firstEquipments.size(),
            retrievedEquipments.size(),
            'All Equipments related to the FL should have been retrieved'
        );
    }

    @isTest
    public static void testUpdateEQCCHeader(){
        EQCC_Header__c mockHeader = getMockEQCCHeader();
        List<Header_Sheet__c> mockHeaderSheets = getHeaderSheets();
        Integer beforeSize = mockHeaderSheets.size();
        Checked_Sheet_Pointer__mdt formType = [
            SELECT Id, MasterLabel, DeveloperName
            FROM Checked_Sheet_Pointer__mdt
            LIMIT 1
        ];

        EQCC_Checked_Sheet__c newSheet = new EQCC_Checked_Sheet__c(
            Name = 'Sheet Testing',
            Form_Type__c = formType.DeveloperName,
            Sheet_Code__c = 'SHEETCODE',
            Form_Questions__c = 5
        );
        insert newSheet;

        List<String> sheetIds = new List<String>();
        sheetIds.add( String.valueOf(newSheet.Id) );

        Test.startTest();
            THOR_CheckedSheetController.updateEQCCHeader(sheetIds, String.valueOf(mockHeader.Id), null, new List<String>());
        Test.stopTest();

        List<Header_Sheet__c> newMockHeaderSheets = getHeaderSheets();
        Integer afterSize = newMockHeaderSheets.size();

        System.assertEquals(true, afterSize > beforeSize, 'List of records should now be greater after associating them with a header');
    }
    
    @isTest
    static void testRetrieveOrderOperation() {
        Order__c order = new Order__c();
        order.Name = String.valueOf(10680966);
        order.Order_Type__c = 'PJ01';
        order.Order_Status__c = 'New';
        order.grouptask__c = 'Task';
        order.groupcount__c = 'Count';
        insert order;

        Order_Operation__c orderOperation = new Order_Operation__c(
            Order__c = order.Id,
            Operation_Text__c = 'OPERATION',
            SubOperation__c = 'SubOperation',
            Operation_Shot_Text__c = 'Short Text'
        );
        insert orderOperation;
        
        Order_Operation__c retrievedOrderOperation;
        Test.startTest();
        retrievedOrderOperation = Thor_CheckedSheetController.retrieveOrderOperation(orderOperation.Id);
        Test.stopTest();
        
        System.assert(retrievedOrderOperation != null, 'Order Operations should have been retrieved');
    }
    
    @isTest
    static void testHasMainWorkCenter() {
        Master_Map_Set__c mSet = new Master_Map_Set__c();
        insert mSet;
        
        Master_Map__c mMap = new Master_Map__c(
            Master_Map_Set__c = mSet.Id,
            Type__c = 'Main Work Center'
        );
        
        insert mMap;
        
        Functional_Location__c fLocation = new Functional_Location__c();
        fLocation.Name = 'FLOC';
        fLocation.Authorize_Group__c = 'FLOCAG';
        fLocation.Description__c = 'FLOCDE';
        fLocation.MainWorkCenter__c = mMap.Id;
        
        insert fLocation;
        
        Boolean hasMWC;
        Test.startTest();
        hasMWC = Thor_CheckedSheetController.hasMainWorkCenter(fLocation.Id);
        Test.stopTest();
        
        System.assert(hasMWC);
    }
    @isTest
    static void testisOwnerOrAdmin() { 
        Boolean result = false;
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
        insert header;
        
        Test.startTest();
        result = THOR_CheckedSheetController.isOwnerOrAdmin(header.Id);
        Test.stopTest();
        System.assert(result == true);
    }
    
    private static EQCC_Header__c getMockEQCCHeader(){
        return [SELECT Id FROM EQCC_Header__c LIMIT 1];
    }

    private static Id getEquipmentByObjectType(String objectType) {
        return [SELECT Id FROM Equipment__c WHERE Object_Type__c = :objectType LIMIT 1].Id;
    }

    private static Id getFunctionalLocationByObjectType(String objectType) {
        return [SELECT Id FROM Functional_Location__c WHERE Object_Type__c = :objectType LIMIT 1].Id;
    }

    private static List<EQCC_Checked_Sheet__c> getEQCCCheckedSheets() {
        return [SELECT Id, Group_Count__c, Group_Task__c FROM EQCC_Checked_Sheet__c];
    }

    private static List<Header_Sheet__c> getHeaderSheets() {
        return [SELECT Id FROM Header_Sheet__c];
    }

    private static Equipment__c getEquipment() {
        return [SELECT Id FROM Equipment__c LIMIT 1];
    }

    private static Functional_Location__c getFunctionalLocation() {
        return [SELECT Id FROM Functional_Location__c LIMIT 1];
    }
}