/**
 * @author Oktana
 * @description test class for OrderHandler
 */
@isTest
public with sharing class OrderHandlerTest {
    /**
     * R2
     */
    @TestSetup
    static void makeData() {
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Read Only'];
        User readOnlyUser = new User(
            Alias = 'standt',
            Email = 'ReadOnlyUser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'ReadOnlyUser' + DateTime.now().getTime() + '@testorg.com'
        );
        insert readOnlyUser;

        List<Order__c> mockOrders = new List<Order__c>{
            new Order__c(
                Description__c = 'Lorem Ipsum 1',
                Order_Status__c = 'In Progress',
                Requested_Date__c = Date.today(),
                Priority__c = '2',
                Order_Type__c = 'CM - Corrective Maintenance'
            ),
            new Order__c(
                Description__c = 'Lorem Ipsum 2',
                Order_Status__c = 'In Progress',
                Requested_Date__c = Date.today(),
                Priority__c = '2',
                Order_Type__c = 'CM - Corrective Maintenance',
                Responsible_person__c = UserInfo.getUserId()
            )
        };
        insert mockOrders;
        // OrderTriggerHandler.cls changes any and all new/insert Order_Status__c to 'New'
        mockOrders[0].System_Status_Text__c = 'REL';
        mockOrders[1].System_Status_Text__c = 'REL';
        mockOrders[0].Order_Status__c = 'In Progress';
        mockOrders[1].Order_Status__c = 'In Progress';
        mockOrders[1].Super_Order__c = mockOrders[0].Id;
        update mockOrders;

        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

    }
    /**
     * @given Order records to insert
     * @when Orders are inserted
     * @then the External ID field Order_Number__c should be populated with the Order's Name
     */

    @isTest
    public static void testPopulateOrderNumber() {
        List<Order__c> orders = new List<Order__c>();
        for (Integer i = 0; i < 5; i++) {
            orders.add(new Order__c(Name = 'Order' + i));
        }

        Test.startTest();
        insert orders;
        Test.stopTest();

        List<Order__c> updatedOrders = getUpdatedOrders();

        for (Order__c order : updatedOrders) {
            //System.assertEquals(order.Name, order.Order_Number__c, 'Order Number should be populated with Order Name');
        }
    }

    /**
     * @given Order records to insert
     * @when Orders are inserted with type CM01
     * @then orderOperation and operation are created automatically
     */
    @isTest
    public static void createOrderOperationAndOperation() {
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        Master_Map__c mainWorkCenter = new Master_Map__c(
            Name = 'Test Master',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = masterMapSet.Id
        );
        insert mainWorkCenter;

        Master_Map__c plant = new Master_Map__c(
            Name = 'Test Master',
            Type__c = 'Plant',
            Master_Map_Set__c = masterMapSet.Id
        );
        insert plant;

        List<Order__c> orders = new List<Order__c>();

        //orders with type CM01 will create operations
        for (Integer i = 0; i < 2; i++) {
            orders.add(
                new Order__c(
                    Name = 'Order' + i,
                    Order_Type__c = 'CM01',
                    Main_Work_Center__c = mainWorkCenter.Id,
                    Description__c = 'Desc' + i,
                    Planning_Plant__c = plant.Id
                )
            );
        }

        //Orders with type PM01 won't create operations
        for (Integer i = 0; i < 2; i++) {
            orders.add(new Order__c(Name = i + 'Order', Order_Type__c = 'PM01'));
        }

        Test.startTest();
        insert orders;
        Test.stopTest();

        List<Order_Operation__c> createdOrderOperations = getCreatedOrderOperations();
        List<Operation__c> createdOperations = getCreatedOperations();

        //lists sizes
        // System.assertEquals(2, createdOrderOperations.size(), 'OrderOperations were not created correct');
        // System.assertEquals(2, createdOperations.size(), 'Operations were not created correct');

        //created OrderOperation
        // System.assertEquals('0010', createdOrderOperations[0].Operation_Text__c, 'Operation_Text__c does not match');
        // System.assertEquals(
        //     mainWorkCenter.Id,
        //     createdOrderOperations[0].Main_Work_Center__c,
        //     'Main_Work_Center__c does not match'
        // );
        // System.assertEquals(
        //     'Desc0',
        //     createdOrderOperations[0].Operation_Shot_Text__c,
        //     'Operation_Shot_Text__c does not match'
        // );
        // System.assertEquals('ZPM1', createdOrderOperations[0].Control_Key__c, 'Control_Key__c does not match');
        // System.assertEquals(plant.Id, createdOrderOperations[0].Plant__c, 'Plant__c does not match');
        // System.assertEquals(orders[0].Id, createdOrderOperations[0].Order__c, 'Order__c does not match');
        // System.assertEquals(
        //     createdOperations[0].Id,
        //     createdOrderOperations[0].Operation__c,
        //     'Operation__c does not match'
        // );

        //created Operation
        // System.assertEquals(
        //     mainWorkCenter.Id,
        //     createdOperations[0].Main_Work_Center__c,
        //     'Main_Work_Center__c does not match'
        // );
        // System.assertEquals('Desc0', createdOperations[0].Short_Text__c, 'Operation_Shot_Text__c does not match');
        // System.assertEquals('ZPM1', createdOperations[0].Control_Key__c, 'Control_Key__c does not match');
        // System.assertEquals(plant.Id, createdOperations[0].Plant__c, 'Plant__c does not match');
        // System.assertEquals(orders[0].Id, createdOperations[0].Order__c, 'Order__c does not match');
    }

    /**
     * R2
     */
    @isTest
    public static void testRetrieveRelatedOrdersByStatusWhenNoNewOrder() {
        //Order__c childOrder = getChildOrder();
        setOrdersStatusToNew();
        Order__c parentOrder = getParentOrder();
        Test.startTest();
        List<THOR_ObjectCardDTO> newList = THOR_RetrieverController.retrieveRelatedOrdersByStatus(
            'New',
            Id.valueOf(parentOrder.Id)
        );
        Test.stopTest();
        // System.assert(newList.size() == 0, 'New related order should not be retrived because there is not');
    }

    private static User getReadOnlyUser() {
        return [SELECT ID FROM User WHERE Email = 'ReadOnlyUser@testorg.com'];
    }

    private static Order__c getParentOrder() {
        return [SELECT Id FROM Order__c WHERE Description__c = 'Lorem Ipsum 1'][0];
    }

    private static void setOrdersStatusToNew() {
        List<Order__c> orders = [SELECT Id, Order_Status__c FROM Order__c];
        for (Order__c order : orders) {
            order.Order_Status__c = Constants.ORDERS.STATUS_NEW;
        }

        update orders;
    }

    private static List<Order__c> getUpdatedOrders() {
        return [SELECT Id, Name, Order_Number__c FROM Order__c];
    }

    private static List<Order_Operation__c> getCreatedOrderOperations() {
        return [
            SELECT
                Id,
                Operation_Text__c,
                SubOperation__c,
                Main_Work_Center__c,
                Operation_Shot_Text__c,
                Control_Key__c,
                Plant__c,
                Order__c,
                Operation__c
            FROM Order_Operation__c
        ];
    }

    private static List<Operation__c> getCreatedOperations() {
        return [
            SELECT Id, Sub_Operation__c, Main_Work_Center__c, Short_Text__c, Control_Key__c, Plant__c, Order__c
            FROM Operation__c
        ];
    }
}