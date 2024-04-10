@isTest
public class THOR_SubOrderCreationController_Test {
    @TestSetup
    static void makeData(){
        THOR_MakeMockData.makeMockData();
    }

    /**
     * @given parent order Id as string
     * @when getting the parent order and it's fields
     * @then return Order__c record with requested fields to populate suborder with
     */
    @isTest
    public static void testGetParentOrder(){
        Order__c parentMockOrder = getParentOrder();

        Test.startTest();
            Order__c actual = THOR_SubOrderCreationController.getParentOrder( String.valueOf(parentMockOrder.Id) );
        Test.stopTest();

        Order__c childMockOrder = getChildOrder();
        System.assertEquals(
            actual.Id,
            childMockOrder.Super_Order__c,
            'Returned Order__c should be the Super_Order__c of the child order'
        );
    }

    /**
     * @given new saved suborder Id as string
     * @when changing the Order_Number__c to be Name
     * @then change Order_Number__c field and return the record
     */
    @isTest
    public static void testChangeOrderNumberToName(){
        Order__c mockOrder = getParentOrder();

        Test.startTest();
            Order__c actual = THOR_SubOrderCreationController.changeOrderNumberToName( String.valueOf(mockOrder.Id) );
        Test.stopTest();

        System.assertEquals(
            mockOrder.Name,
            actual.Order_Number__c,
            'actual.Order_Number__c should be eqaul to mockOrder.Name'
        );
    }

    /**
     * @given Equipments related to a Functional Location
     * @when service to retrieve Equipments by Functional Location is invoked
     * @then all Equipments should be retrieved
     */
    @isTest
    static void testRetrieveEquipmentByFunctionalLocation() {
        Functional_Location__c fLocation = new Functional_Location__c(
            Name = 'FLOC',
            Authorize_Group__c = 'FLOCAG',
            Description__c = 'FLOCDE'
        );

        insert fLocation;

        List<Equipment__c> equipments = new List<Equipment__c>();
        List<String> equipmentObjectTypes = new List<String> {'UN-TCU', 'TS-BOILER', 'EE-MV4', 'EARTHING BOSS', 'NON PROCESS AREA'};

        for (Integer i = 0; i < 5; i++) {
            equipments.add(
                new Equipment__c(
                    Name = 'EQNM' + i,
                    FL__c = fLocation.Id,
                    Description__c = 'EQDE',
                    Object_Type__c = equipmentObjectTypes.get(i)
                )
            );
        }

        insert equipments;
        List<Equipment__c> retrievedEquipments = new List<Equipment__c>();
        Test.startTest();
        retrievedEquipments = THOR_SubOrderCreationController.retrieveEquipmentsByFunctionalLocation(fLocation.Id);
        Test.stopTest();

        System.assertEquals(equipments.size(), retrievedEquipments.size(), 'All equipments should have been retrieved');
    }

    /**
     * @given a Functional Location
     * @when service to retrieve Functional Location By Id is invoked
     * @then the Functional Location should be retrieved
     */
    @isTest
    static void testRetrieveFunctionalLocationById() {
        Functional_Location__c fLocation = new Functional_Location__c(
            Name = 'FLOC',
            Authorize_Group__c = 'FLOCAG',
            Description__c = 'FLOCDE'
        );

        insert fLocation;

        Functional_Location__c retrievedFL;
        Test.startTest();
        retrievedFL = THOR_SubOrderCreationController.retrieveFunctionalLocationById(fLocation.Id);
        Test.stopTest();

        System.assert(retrievedFL != null, 'The Functional Location should have been retrieved');
    }

    /**
     * @given Master Map records of Type 'MaintActivityTypeAndOrderType' and related to Order Type records
     * @when service to retrieve PM Activities is invoked an Order Type
     * @then all records related to the Order Type are retrieved
     */
    @isTest
    static void testGetPMActivityType() {
        Master_Map_Set__c mSet = new Master_Map_Set__c();
        insert mSet;
        Master_Map__c orderType = new Master_Map__c(
            Master_Map_Set__c = mSet.Id,
            Name = 'OrderType'
        );
        insert orderType;
        List<Master_Map__c> relatedMaps = new List<Master_Map__c>();
        for (Integer i = 0; i < 5; i++) {
            relatedMaps.add(
                new Master_Map__c(
                    Master_Map_Set__c = mSet.Id,
                    Name = 'Related Map ' + i
                )
            );
        }
        insert relatedMaps;

        List<Master_Map__c> mMaps = new List<Master_Map__c>();
        for (Integer i = 0; i < 5; i++) {
            mMaps.add(
                new Master_Map__c(
                    Master_Map_Set__c = mSet.Id,
                    RelatedMasterMap1__c = relatedMaps.get(i).Id,
                    Name = 'Map ' + i,
                    Type__c = 'MaintActivityTypeAndOrderType',
                    RelatedMasterMap2__c = orderType.Id
                )
            );
        }
        insert mMaps;

        List<Master_Map__c> retrievedRecords = new List<Master_Map__c>();
        Test.startTest();
        String oType = String.valueOf(orderType.Id).substring(0, 15);
        retrievedRecords = THOR_SubOrderCreationController.getPMActivityType(oType);
        Test.stopTest();

        System.assertEquals(
            mMaps.size(),
            retrievedRecords.size(),
            'All records related to the Order Type should have been retrieved'
        );
    }

    /**
     * @when when service to get PM Activity Type is invoked with a null Order Type
     * @then no records are returned
     */
    @isTest
    static void testGetPMActivityTypeNull() {
        List<Master_Map__c> pmActivities = new List<Master_Map__c>();

        Test.startTest();
        pmActivities = THOR_SubOrderCreationController.getPMActivityType(null);
        Test.stopTest();

        System.assert(pmActivities == null, 'No records should have been retrieved');
    }

    /**
     * @given
     * @when
     * @then
     */
    @isTest
    static void testGetMainWorkCenters() {
        Master_Map_Set__c mSet = new Master_Map_Set__c();
        insert mSet;
        Master_Map__c mMap = new Master_Map__c(
            Master_Map_Set__c = mSet.Id,
            Name = 'OrderType'
        );
        insert mMap;
        List<Master_Map__c> relatedMaps = new List<Master_Map__c>();
        for (Integer i = 0; i < 5; i++) {
            relatedMaps.add(
                new Master_Map__c(
                    Master_Map_Set__c = mSet.Id,
                    Name = 'Related Map ' + i,
                    Type__c = 'CategoryWithMainWorkCenterWithPlant',
                    RelatedMasterMap2__c = mMap.Id
                )
            );
        }
        insert relatedMaps;

        List<Master_Map__c> mainWorkCenters = new List<Master_Map__c>();
        Test.startTest();
        mainWorkCenters = THOR_SubOrderCreationController.getMainWorkCenters(mMap.Id);
        Test.stopTest();

        System.assertEquals(
            1,
            mainWorkCenters.size(),
            'All Main Work Center records should have been returned'
        );
    }

    /**
     * @given an Order
     * @when the service to retrieve Order by Id is invoked
     * @then the records is returned
     */
    @isTest
    static void testGetOrderById() {
        Order__c order = new Order__c();
        order.Name = String.valueOf(10680966);
        order.Order_Type__c = 'PJ01';
        order.Order_Status__c = 'New';
        order.grouptask__c = 'Task';
        order.groupcount__c = 'Count';
        insert order;

        Order__c retrievedOrder = new Order__c();

        Test.startTest();
        retrievedOrder = THOR_SubOrderCreationController.getOrderById(order.Id);
        Test.stopTest();

        System.assert(retrievedOrder != null, 'The Order should have been retrieved');
    }

    /**
     * @given Master Maps
     * @when the service to search Master Map by Name Or Description is invoked
     * @then the matching records are returned
     */
    @isTest
    static void testSearchPMActivityTypeByNameAndDescription() {
        Master_Map_Set__c mSet = new Master_Map_Set__c();
        insert mSet;
        Master_Map__c mMap = new Master_Map__c(
            Master_Map_Set__c = mSet.Id,
            Name = 'OrderType'
        );
        insert mMap;
        List<Master_Map__c> relatedMaps = new List<Master_Map__c>();
        for (Integer i = 0; i < 5; i++) {
            relatedMaps.add(
                new Master_Map__c(
                    Master_Map_Set__c = mSet.Id,
                    Name = 'Name' + i,
                    Description__c = 'Desc' + i
                )
            );
        }
        insert relatedMaps;

        List<Master_Map__c> retrievedRecords = new List<Master_Map__c>();
        Test.startTest();
        retrievedRecords = THOR_SubOrderCreationController.searchPMActivityTypeByNameAndDescription('Desc', relatedMaps);
        Test.stopTest();

        System.assertEquals(relatedMaps.size(), retrievedRecords.size(), 'All records should have been retrieved');
    }

    /**
     * @given Master Maps
     * @when the service to search Master Map by Name Or Description is invoked
     * @then the matching records are returned
     */
    @isTest
    static void testSearchMainWorkCenterByNameAndDescription() {
        Master_Map_Set__c mSet = new Master_Map_Set__c();
        insert mSet;
        Master_Map__c mMap = new Master_Map__c(
            Master_Map_Set__c = mSet.Id,
            Name = 'OrderType',
            Description__c = 'Desc'
        );
        insert mMap;
        List<Master_Map__c> relatedMaps = new List<Master_Map__c>();
        for (Integer i = 0; i < 5; i++) {
            relatedMaps.add(
                new Master_Map__c(
                    Master_Map_Set__c = mSet.Id,
                    Name = 'Name' + i,
                    Description__c = 'Desc' + i,
                    RelatedMasterMap1__c = mMap.Id
                )
            );
        }
        insert relatedMaps;
        Map<Id, Master_Map__c> maps = new Map<Id, Master_Map__c>(relatedMaps);
        relatedMaps = [
            SELECT Id, RelatedMasterMap1__r.Description__c, RelatedMasterMap1__r.Name
            FROM Master_Map__c
            WHERE Id IN :maps.keySet()
        ];

        List<Master_Map__c> retrievedRecords = new List<Master_Map__c>();
        Test.startTest();
        retrievedRecords = THOR_SubOrderCreationController.searchMainWorkCenterByNameAndDescription('Desc', relatedMaps);
        Test.stopTest();

        System.assertEquals(relatedMaps.size(), retrievedRecords.size(), 'All records should have been retrieved');
    }

    /**
     * @given Master Maps of type 'Plant'
     * @when service to retrieve Plants is invoked
     * @then all Plant records should be returned
     */
    @isTest
    static void testGetMainWorkCenterPlants() {
        Master_Map_Set__c mSet = new Master_Map_Set__c();
        insert mSet;

        List<Master_Map__c> relatedMaps = new List<Master_Map__c>();
        for (Integer i = 0; i < 5; i++) {
            relatedMaps.add(
                new Master_Map__c(
                    Master_Map_Set__c = mSet.Id,
                    Name = 'Related Map ' + i,
                    Type__c = 'Plant'
                )
            );
        }
        insert relatedMaps;

        List<Master_Map__c> plants = new List<Master_Map__c>();
        Test.startTest();
        plants = (List<Master_Map__c>)THOR_SubOrderCreationController.getMainWorkCenterPlants(null);
        Test.stopTest();

        System.assertEquals(
            relatedMaps.size(),
            plants.size(),
            'All Plant records should have been returned'
        );
    }

    /**
     * @given Master Maps
     * @when the service to search MainWorkCenterPlants by Name Or Description is invoked
     * @then the matching records are returned
     */
    @isTest
    static void testSearchMainWorkCenterPlantByNameAndDescription() {
        Master_Map_Set__c mSet = new Master_Map_Set__c();
        insert mSet;
        Master_Map__c mMap = new Master_Map__c(
            Master_Map_Set__c = mSet.Id,
            Name = 'OrderType',
            Description__c = 'Desc'
        );
        insert mMap;
        List<Master_Map__c> relatedMaps = new List<Master_Map__c>();
        for (Integer i = 0; i < 5; i++) {
            relatedMaps.add(
                new Master_Map__c(
                    Master_Map_Set__c = mSet.Id,
                    Name = 'Name' + i,
                    Description__c = 'Desc' + i
                )
            );
        }
        insert relatedMaps;

        List<Master_Map__c> retrievedRecords = new List<Master_Map__c>();
        Test.startTest();
        retrievedRecords = THOR_SubOrderCreationController.searchMainWorkCenterPlantByNameAndDescription('Desc', relatedMaps);
        Test.stopTest();

        System.assertEquals(relatedMaps.size(), retrievedRecords.size(), 'All records should have been retrieved');
    }

    private static Order__c getParentOrder(){
        return [SELECT Id, Name, Order_Number__c FROM Order__c WHERE Name='Test Order'];
    }

    private static Order__c getChildOrder(){
        return [SELECT Id, Super_Order__c, Name, Order_Number__c FROM Order__c WHERE Name='Child Test Order' LIMIT 1];
    }
}