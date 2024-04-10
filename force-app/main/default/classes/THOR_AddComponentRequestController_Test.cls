@isTest
public class THOR_AddComponentRequestController_Test {
    @TestSetup
    public static void makeData(){
        Functional_Location__c fl = new Functional_Location__c(Name='new functional location', Description__c='a test fl');
        insert fl;

        List<Equipment__c> equipment = new List<Equipment__c>();
        equipment.add(new Equipment__c(Name='First piece of equipment',
        FL__c=fl.Id));
        equipment.add(new Equipment__c(Name='Second piece of equipment',
        FL__c=fl.Id));
        insert equipment;

        List<BOM__c> boms = new List<BOM__c>();
        boms.add(new BOM__c(Name='New BOM', Equipment__c=equipment[0].Id));
        boms.add(new BOM__c(Name='Second BOM', Equipment__c=equipment[1].Id));
        insert boms;

        List<Spare_Part__c> spareParts = new List<Spare_Part__c>();
        spareParts.add(new Spare_Part__c(Material_Number__c='10110',
        Price__c=600.00, Name='New spare part', Material_Description__c='New spare part description for spare part.'));
        spareParts.add(new Spare_Part__c(Material_Number__c='20110',
        Price__c=700.00, Name='Another New spare part', Material_Description__c='New spare part description 20110 for spare part two.'));
        insert spareParts;

        List<Spare_Part_Stock__c> sparePartStocks = new List<Spare_Part_Stock__c>();
        sparePartStocks.add(new Spare_Part_Stock__c(Spare_Part__c=spareParts[0].Id, Name='Spare part stock test.',
        Available_Quantity__c=600));
        sparePartStocks.add(new Spare_Part_Stock__c(Spare_Part__c=spareParts[1].Id, Name='Second spare part stock test.',
        Available_Quantity__c=700));
        insert sparePartStocks;

        List<BOM_with_Spare_Part__c> bomsWithSpareParts = new List<BOM_with_Spare_Part__c>();
        bomsWithSpareParts.add(new BOM_with_Spare_Part__c(BOMNo__c=boms[0].Id,
        sparePartNo__c=spareParts[0].Id));
        bomsWithSpareParts.add(new BOM_with_Spare_Part__c(BOMNo__c=boms[1].Id,
        sparePartNo__c=spareParts[1].Id));
        insert bomsWithSpareParts;

        List<Order__c> orders = new List<Order__c>();
        orders.add(new Order__c(Equipment__c=equipment[0].Id, Functional_Location__c=fl.Id,
        Name='test order'));
        orders.add(new Order__c(Functional_Location__c=fl.Id, Name='order no equipment'));
        insert orders;

    }

    /**
     * @given a Order__c record Id
     * @when navigating to add component page
     * @then the order object is returned with Functional Location and Equipment information
     */
    @isTest
    public static void testGetFunctionalLocationEquipment(){
        Order__c order = [SELECT Id, Functional_Location__c, Equipment__c FROM Order__c LIMIT 1];

        Test.startTest();
        Order__c returnOrder = THOR_AddComponentRequestController.getFunctionalLocationEquipment(order.Id);
        Test.stopTest();

        System.assertEquals(returnOrder.Functional_Location__c, order.Functional_Location__c, 'Functional location should match');
        System.assertEquals(returnOrder.Equipment__c, order.Equipment__c, 'Equipment should match');

    }

    /**
     * @given a Functional_Location__c record Id
     * @when searching for Spare_Part__c
     * @then a list is returned with Spare_Part__c related to all
     * child Equipment__c from Functional_Location__c
     */
    @isTest
    public static void testGetComponentsWithoutEquipment(){
        Order__c orderTest = [SELECT Id, Functional_Location__c, Equipment__c FROM Order__c WHERE Equipment__c = null LIMIT 1];
        System.assert(orderTest != null);

        Spare_Part__c SparePartItem = [SELECT Id, Name FROM Spare_Part__c order by Name desc LIMIT 1];

        Test.startTest();
        List<Spare_Part__c> spareParts = THOR_AddComponentRequestController.getComponents(orderTest.Functional_Location__c, null, SparePartItem.Name , orderTest.Id);
        Test.stopTest();
        System.assertEquals(2, spareParts.size(), 'List should contain two spare parts');
    }

    /**
     * @given an Equipment__c record Id
     * @when searching for Spare_Part__c
     * @then a list is returned with Spare_Part__c related to the Equipment__c
     */
    @isTest
    public static void testGetComponentsWithEquipment() {
        Order__c orderTest = [SELECT Id, Functional_Location__c, Equipment__c FROM Order__c WHERE Equipment__c != null LIMIT 1];
        System.assert(orderTest != null);

        Spare_Part__c SparePartItem = [SELECT Id, Name FROM Spare_Part__c order by Name desc LIMIT 1];

        Test.startTest();
        List<Spare_Part__c> spareParts = THOR_AddComponentRequestController.getComponents(null, orderTest.Equipment__c, SparePartItem.Name, orderTest.Id);
        Test.stopTest();
        System.assertEquals(1, spareParts.size(), 'List should contain only one spare part');
    }


    /**
     * @given an Equipment__c record Id
     * @when searching for Spare_Part__c
     * @then a list is returned with Spare_Part__c related to the Spare_Part__c
     */
    @isTest
    public static void testGetComponentsWithSparePartItem() {
        Order__c orderTest = [SELECT Id, Functional_Location__c, Equipment__c FROM Order__c WHERE Equipment__c != null LIMIT 1];
        System.assert(orderTest != null);

        Spare_Part__c SparePartItem = [SELECT Id, Material_Number__c FROM Spare_Part__c order by Name LIMIT 1];

        Test.startTest();
        List<Spare_Part__c> spareParts = THOR_AddComponentRequestController.getComponents(null, null, SparePartItem.Material_Number__c, orderTest.Id);
        Test.stopTest();
        System.assertEquals(1, spareParts.size(), 'List should contain only one spare part');
    }

    /**
     * @given a Functional_Location__c and Equipment__c record Id
     * @when searching for Spare_Part__c
     * @then a list is returned with Spare_Part__c related to
     * both Functional_Location__c and Equipment__c
     */
    @isTest
    public static void testGetComponentsWithEquipmentAndFL(){
        Order__c orderTest = [SELECT Id, Functional_Location__c, Equipment__c FROM Order__c WHERE Equipment__c != null LIMIT 1];
        System.assert(orderTest != null);

        Test.startTest();
        List<Spare_Part__c> spareParts = THOR_AddComponentRequestController.getComponents(orderTest.Functional_Location__c, orderTest.Equipment__c, null, orderTest.Id);
        Test.stopTest();
        // System.assertEquals(1, spareParts.size(), 'List should contain only one spare part');
    }

    /**
     * @given Spare Part Requests for an Order
     * @when Existing Cart is requested for the Order
     * @then all Draft Spare Part Requests are returned
     */
    @isTest
    static void testGetExistingCart() {
        Order__c orderTest = [SELECT Id, Functional_Location__c, Equipment__c FROM Order__c WHERE Equipment__c = null LIMIT 1];

        Spare_Part__c sparePartTest = new Spare_Part__c(Name = 'sparePartTest', Material_Number__c = 'MaterialTest');
        insert sparePartTest;

        List<Spare_Part_Request__c> sparePartRequests = new List<Spare_Part_Request__c>();
        for (Integer i = 0; i < 5; i++) {
            sparePartRequests.add(
                new Spare_Part_Request__c(
                    Order__c = orderTest.Id,
                    Item_No__c = '123' + i,
                    Spare_Part__c = sparePartTest.Id,
                    Request_Status__c = 'Draft'
                )
            );
        }
        insert sparePartRequests;

        List<Spare_Part_Request__c> existingCart = new List<Spare_Part_Request__c>();

        Test.startTest();
        existingCart = THOR_AddComponentRequestController.getExistingCart(orderTest.Id);
        Test.stopTest();

        System.assertEquals(5, existingCart.size(), 'All Spare Part Requests related to the Order should have been retrieved');
    }

    /**
     *
     *
     */
    @isTest
    static void testCreateOrUpdateCart() {
        Order__c orderTest = [SELECT Id, Functional_Location__c, Equipment__c FROM Order__c WHERE Equipment__c = null LIMIT 1];
        List<Spare_Part__c> items = getSpareParts();
        List<Spare_Part_Stock__c> stocks = getSparePartStocks();

        Test.startTest();
        THOR_AddComponentRequestController.createOrUpdateCart(orderTest.Id, items, stocks);
        Test.stopTest();
    }

    private static List<Spare_Part__c> getSpareParts() {
        return [SELECT Material_Number__c, Price__c, Name, Material_Description__c, Base_Unit__c FROM Spare_Part__c];
    }

    private static List<Spare_Part_Stock__c> getSparePartStocks() {
        return [SELECT Id, Available_Quantity__c, Plant__c, Spare_Part__c FROM Spare_Part_Stock__c];
    }
}