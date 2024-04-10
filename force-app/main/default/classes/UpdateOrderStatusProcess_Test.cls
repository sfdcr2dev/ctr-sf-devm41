/**
 * @author Sebastian Bucalo
 * @description test class for PB 'Update_Order_Status'
 */
@isTest
public with sharing class UpdateOrderStatusProcess_Test {
    /**
     * @given PB Update_Order_Status
     * @when An Order is created with System_status_text__c = 'CRTD'
     * @then Order status changes to New
     */
    @IsTest
    private static void testUpdateStatusAfterCreateCRTD() {
        Order__c order = new Order__c(
            Name = 'Test Order',
            Description__c = 'Test Description',
            System_status_text__c = 'CRTD',
            Order_Status__c = 'New'
        );
        Test.startTest();
        insert order;
        Test.stopTest();
        Order__c insertedOrder = [SELECT Id, System_status_text__c, Order_Status__c FROM Order__c WHERE ID = :order.Id];
        System.assertEquals('New', insertedOrder.Order_Status__c, 'Order status was not updated to New');
    }
    /**
     * @given PB Update_Order_Status
     * @when An Order is created with System_status_text__c = 'REL'
     * @then Order status changes to In Progress
     */
    @IsTest
    private static void testUpdateStatusAfterCreateREL() {
        Order__c order = new Order__c(
            Name = 'Test Order',
            Description__c = 'Test Description',
            System_status_text__c = 'REL',
            Order_Status__c = 'In Progress'
        );
        Test.startTest();
        insert order;
        Test.stopTest();
        Order__c insertedOrder = [SELECT Id, System_status_text__c, Order_Status__c FROM Order__c WHERE ID = :order.Id];
        System.assertEquals(
            'In Progress',
            insertedOrder.Order_Status__c,
            'Order status was not updated to In Progress'
        );
    }

    /**
     * @given PB Update_Order_Status
     * @when An Order is created with System_status_text__c = 'TECO'
     * @then Order status changes to New
     */
    @IsTest
    private static void testUpdateStatusAfterCreateTECO() {
        Order__c order = new Order__c(
            Name = 'Test Order',
            Description__c = 'Test Description',
            System_status_text__c = 'TECO',
            Order_Status__c = 'Closed',
            Close_Date__c = Date.today()
        );

        Test.startTest();
        insert order;
        Test.stopTest();
        Order__c insertedOrder = [
            SELECT Id, System_status_text__c, Order_Status__c, Close_Date__c
            FROM Order__c
            WHERE ID = :order.Id
        ];
        System.assertEquals('Closed', insertedOrder.Order_Status__c, 'Order status was not updated to Closed');
        System.assertEquals(Date.today(), insertedOrder.Close_Date__c, 'Close date was not updated');
    }
    /**
     * @given PB Update_Order_Status
     * @when System status text changes (adds CRTD)
     * @then Order status changes to In Progress
     */
    @IsTest
    private static void testUpdateStatusAfterUpdateToCRTD() {
        Order__c order = new Order__c(Name = 'Test Order', Description__c = 'Test Description', Order_Status__c = 'New');
        insert order;
        Order__c insertedOrder = [SELECT Id, System_status_text__c, Order_Status__c FROM Order__c WHERE Id = :order.Id];
        insertedOrder.System_status_text__c = 'CRTD';
        Test.startTest();
        update insertedOrder;
        Test.stopTest();
        Order__c updatedOrder = [SELECT Id, System_status_text__c, Order_Status__c FROM Order__c WHERE Id = :order.Id];
        System.assertEquals('New', updatedOrder.Order_Status__c, 'Order status was not updated to New');
    }

    /**
     * @given PB Update_Order_Status
     * @when System status text changes (adds REL)
     * @then Order status changes to In Progress
     */
    @IsTest
    private static void testUpdateStatusAfterUpdateToREL() {
        Order__c order = new Order__c(Name = 'Test Order', Description__c = 'Test Description',Order_Status__c = 'In Progress');
        insert order;
        Order__c insertedOrder = [SELECT Id, System_status_text__c, Order_Status__c FROM Order__c WHERE Id = :order.Id];
        insertedOrder.System_status_text__c = 'CRTD REL';
        Test.startTest();
        update insertedOrder;
        Test.stopTest();
        Order__c updatedOrder = [SELECT Id, System_status_text__c, Order_Status__c FROM Order__c WHERE Id = :order.Id];
        System.assertEquals('In Progress', updatedOrder.Order_Status__c, 'Order status was not updated to In Progress');
    }

    /**
     * @given PB Update_Order_Status
     * @when System status text changes (adds TECO)
     * @then Order status changes to Close
     */
    @IsTest
    private static void testUpdateStatusAfterUpdateToTECO() {
        Order__c order = new Order__c(Name = 'Test Order', Description__c = 'Test Description',Order_Status__c = 'Closed',Close_Date__c = Date.today() );
        insert order;
        Order__c insertedOrder = [SELECT Id, System_status_text__c, Order_Status__c FROM Order__c WHERE Id = :order.Id];
        Test.startTest();
        insertedOrder.System_status_text__c = 'TECO';
        update insertedOrder;
        Test.stopTest();
        Order__c updatedOrder = [
            SELECT Id, System_status_text__c, Order_Status__c, Close_Date__c
            FROM Order__c
            WHERE Id = :order.Id
        ];
        System.assertEquals('Closed', updatedOrder.Order_Status__c, 'Order status was not updated to Closed');
        System.assertEquals(Date.today(), updatedOrder.Close_Date__c, 'Close date was not updated');
    }

    /**
     * @given PB Update_Order_Status_And_Main_Work_Center_name
     * @when an Order is created
     * @then Order's Main Work Center Text is updated
     */
    @IsTest
    private static void testMWCTextNameUpdateWhenCreatingOrder() {
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
            Name = 'Test Order',
            Description__c = 'Test Description',
            Main_Work_Center__c = masterMapMWC.Id,
            Main_Work_Center_Text__c = masterMapMWC.Name
        );
        Test.startTest();
        insert order;
        Test.stopTest();
        Order__c insertedOrder = [SELECT Id, Main_Work_Center_Text__c FROM Order__c WHERE Id = :order.Id];

        System.assertEquals(
            masterMapMWC.Name,
            insertedOrder.Main_Work_Center_Text__c,
            'Main Work Center Name was not updated'
        );
    }

    /**
     * @given PB Update_Order_Status_And_Main_Work_Center_name
     * @when an Order is updated
     * @then Order's Main Work Center Text is updated
     */
    @IsTest
    private static void testMWCTextNameUpdateWhenUpdatingOrder() {
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
            Name = 'Test Order',
            Description__c = 'Test Description',
            Main_Work_Center_Text__c = masterMapMWC.Name
        );

        insert order;

        order.Main_Work_Center__c = masterMapMWC.Id;

        Test.startTest();
        update order;
        Test.stopTest();
        Order__c insertedOrder = [SELECT Id, Main_Work_Center_Text__c FROM Order__c WHERE Id = :order.Id];

        System.assertEquals(
            masterMapMWC.Name,
            insertedOrder.Main_Work_Center_Text__c,
            'Main Work Center Name was not updated'
        );
    }

    /**
     * @given PB Update_Order_Status
     * @when An Order is created
     * @then Order user status changes to INIL
     */
    @IsTest
    private static void testUpdateUserStatusAfterCreate() {
        Order__c order = new Order__c(
            Name = 'Test Order',
            Description__c = 'Test Description',
            System_Status_Text__c = 'CRTD',
            User_Status__c = 'INIL',
            User_Status_Text__c = 'INIL'
        );
        Test.startTest();
        insert order;
        Test.stopTest();
        Order__c insertedOrder = [SELECT Id, System_status_text__c, User_Status__c, User_Status_Text__c FROM Order__c WHERE ID = :order.Id];
        System.assertEquals('INIL', insertedOrder.User_Status__c, 'Order user status was not updated to INIL');
        System.assertEquals('INIL', insertedOrder.User_Status_Text__c, 'Order user status text was not updated to INIL');
    }
}