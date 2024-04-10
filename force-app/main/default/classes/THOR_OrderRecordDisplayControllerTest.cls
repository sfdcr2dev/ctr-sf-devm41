/**
 * @author Oktana
 * @description test class for THOR_OrderRecordDisplayController
 */
@isTest
public with sharing class THOR_OrderRecordDisplayControllerTest {
	/**
	 * @given an order without related objects
	 * @when order has not related objects
	 * @then order status is updated to close
	 */
	@isTest
	static void testUpdateOrderWithoutRelatedObjects2() {
		Order__c order = new Order__c();
		order.Order_Number__c = '1234';
		order.Order_Type__c = 'PJ01';
		order.Order_Status__c = 'New';
		insert order;

		Test.startTest();
		THOR_OrderRecordDisplayController.getCloseOrderStatus(order.Id);
		THOR_OrderRecordDisplayController.setTimeoutOrder(order.Id);
		THOR_OrderRecordDisplayController.getSubOrdersListRelatedByStatus(
			order.Id,
			new Map<String, String>{ 'Order_Status__c' => 'Order_Status__c = \'New\'' }
		);
		THOR_OrderRecordDisplayController.getNotificationRelatedByStatus(
			order.Id,
			new Map<String, String>{ 'Notification_Status__c' => 'Notification_Status__c = \'New\'' }
		);
		THOR_OrderRecordDisplayController.getOrderOperationRelated(order.Id);
		THOR_OrderRecordDisplayController.hasWriteAccess(order.Id);
		Test.stopTest();

		Order__c updatedOrder = [SELECT Id, Name, Order_Status__c, Close_Date__c FROM Order__c WHERE Id = :order.Id];

		System.assertEquals('New', updatedOrder.Order_Status__c, 'Order status was not updated to Closed');
		System.assertEquals(Date.today(), updatedOrder.Close_Date__c, 'Order close date was not updated');
	}
	/**
	 * @given an order without related objects
	 * @when order has not related objects
	 * @then order status is updated to close
	 */
	@isTest
	static void testUpdateOrderWithoutRelatedObjects() {
		Order__c order = new Order__c();
		order.Order_Number__c = '1234';
		order.Order_Type__c = 'PJ01';
		order.Order_Status__c = 'New';
		insert order;

		Test.startTest();
		THOR_OrderRecordDisplayController.getCloseOrderStatus(order.Id);
		Test.stopTest();

		Order__c updatedOrder = [SELECT Id, Name, Order_Status__c, Close_Date__c FROM Order__c WHERE Id = :order.Id];

		System.assertEquals('New', updatedOrder.Order_Status__c, 'Order status was not updated to Closed');
		System.assertEquals(Date.today(), updatedOrder.Close_Date__c, 'Order close date was not updated');
	}

	/**
	 * @given an order with related objects
	 * @when order has sub order without system status text TECO
	 * @then order status is not updated to close
	 */
	@isTest
	static void testUpdateOrderWithSubOrderWithoutTECO() {
		Order__c order = new Order__c();
		order.Order_Number__c = '1234';
		order.Order_Type__c = 'PJ01';
		order.Order_Status__c = 'New';
		insert order;

		Order__c subOrder = new Order__c();
		subOrder.Order_Number__c = '4321';
		subOrder.Order_Type__c = 'PJ01';
		subOrder.Order_Status__c = 'New';
		subOrder.Super_Order__c = order.Id;
		insert subOrder;

		Test.startTest();
		THOR_OrderRecordDisplayController.getCloseOrderStatus(order.Id);
		Test.stopTest();

		Order__c updatedOrder = [SELECT Id, Name, Order_Status__c FROM Order__c WHERE Id = :order.Id];

		System.assertEquals('New', updatedOrder.Order_Status__c, 'Order status should not be updated to Close');
	}

	/**
	 * @given an order with related objects
	 * @when order has Notification without fault code
	 * @then order status is not updated to close
	 */
	@isTest
	static void testUpdateOrderWithNotificationWithoutFaultCode() {
		Order__c order = new Order__c();
		order.Order_Number__c = '1234';
		order.Order_Type__c = 'PJ01';
		order.Order_Status__c = 'New';
		insert order;

		Notification__c notification = new Notification__c();
		notification.Notification_Number__c = '4321';
		notification.Type__c = 'CM';
		notification.Notification_Status__c = 'New';
		notification.Description__c = 'This is a test description...';
		notification.AssignedTo__c = userInfo.getUserId();
		notification.Order__c = order.Id;
		insert notification;

		Test.startTest();
		THOR_OrderRecordDisplayController.getCloseOrderStatus(order.Id);
		Test.stopTest();

		Order__c updatedOrder = [SELECT Id, Name, Order_Status__c FROM Order__c WHERE Id = :order.Id];

		System.assertEquals('New', updatedOrder.Order_Status__c, 'Order status should not be updated to Close');
	}

	/**
	 * @given an order with related Work Clearance
	 * @when order system status text does not contain WOCO
	 * @then order status is not updated to close
	 */
	@isTest
	static void testUpdateOrderWithWorkClearanceWithoutWOCO() {
		Order__c order = new Order__c();
		order.Order_Number__c = '1234';
		order.Order_Type__c = 'PJ01';
		order.Order_Status__c = 'New';
		order.System_Status_Text__c = 'CRTD';
		insert order;

		Work_Clearance__c wClearance = new Work_Clearance__c();
		wClearance.Description__c = 'Test Description';
		wClearance.Order__c = order.Id;
		insert wClearance;

		Order__c subOrder = new Order__c();
		subOrder.Order_Number__c = '4321';
		subOrder.Order_Type__c = 'PJ01';
		subOrder.Order_Status__c = 'Closed';
		subOrder.System_Status_Text__c = 'TECO';
		subOrder.Super_Order__c = order.Id;
		insert subOrder;

		Test.startTest();
		THOR_OrderRecordDisplayController.getCloseOrderStatus(order.Id);
		Test.stopTest();

		Order__c updatedOrder = [SELECT Id, Name, Order_Status__c FROM Order__c WHERE Id = :order.Id];

		System.assertEquals('New', updatedOrder.Order_Status__c, 'Order status should not be updated to Close');
	}

	/**
	 * @given an order with related sub orders
	 * @when all sub order system status text contain TECO
	 * @then order status is updated to close
	 */
	@isTest
	static void testUpdateOrderWithSubOrdersTECO() {
		Order__c order = new Order__c();
		order.Order_Number__c = '1234';
		order.Order_Type__c = 'PJ01';
		order.Order_Status__c = 'New';
		order.System_Status_Text__c = 'CRTD';
		insert order;

		Order__c subOrder = new Order__c();
		subOrder.Order_Number__c = '4321';
		subOrder.Order_Type__c = 'PJ01';
		subOrder.Order_Status__c = 'Closed';
		subOrder.System_Status_Text__c = 'TECO';
		subOrder.Super_Order__c = order.Id;
		insert subOrder;

		Order__c subOrder2 = new Order__c();
		subOrder2.Order_Number__c = '54321';
		subOrder2.Order_Type__c = 'PJ01';
		subOrder2.Order_Status__c = 'Closed';
		subOrder2.System_Status_Text__c = 'TECO';
		subOrder2.Super_Order__c = order.Id;
		insert subOrder2;

		Test.startTest();
		THOR_OrderRecordDisplayController.getCloseOrderStatus(order.Id);
		Test.stopTest();

		Order__c updatedOrder = [SELECT Id, Name, Order_Status__c, Close_Date__c FROM Order__c WHERE Id = :order.Id];

		System.assertEquals('New', updatedOrder.Order_Status__c, 'Order status was not updated to Closed');
		System.assertEquals(Date.today(), updatedOrder.Close_Date__c, 'Order close date was not updated');
	}

	/**
	 * @given an order with related notifications
	 * @when all notifications have fault code
	 * @then order status is updated to close
	 */
	@isTest
	static void testUpdateOrderWithNotificationWithFaultCode() {
		Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
		insert masterMapSet;

		Master_Map__c masterMap = new Master_Map__c(
			Name = 'Fault Code Test',
			Type__c = 'FaultCode',
			Master_Map_Set__c = masterMapSet.Id
		);
		insert masterMap;

		Order__c order = new Order__c();
		order.Order_Number__c = '1234';
		order.Order_Type__c = 'PJ01';
		order.Order_Status__c = 'New';
		order.System_Status_Text__c = 'CRTD';
		insert order;

		Notification__c notification = new Notification__c();
		notification.Notification_Number__c = '4321';
		notification.Type__c = 'CM';
		notification.Notification_Status__c = 'New';
		notification.Description__c = 'This is a test description...';
		notification.AssignedTo__c = userInfo.getUserId();
		notification.Order__c = order.Id;
		notification.Fault_Code__c = masterMap.Id;
		insert notification;

		Notification__c notification2 = new Notification__c();
		notification2.Notification_Number__c = '54321';
		notification2.Type__c = 'CM';
		notification2.Notification_Status__c = 'New';
		notification2.Description__c = 'This is a test description...';
		notification2.AssignedTo__c = userInfo.getUserId();
		notification2.Order__c = order.Id;
		notification2.Fault_Code__c = masterMap.Id;
		insert notification2;

		Test.startTest();
		THOR_OrderRecordDisplayController.getCloseOrderStatus(order.Id);
		Test.stopTest();

		Order__c updatedOrder = [SELECT Id, Name, Order_Status__c, Close_Date__c FROM Order__c WHERE Id = :order.Id];

		System.assertEquals('New', updatedOrder.Order_Status__c, 'Order status was not updated to Closed');
		System.assertEquals(Date.today(), updatedOrder.Close_Date__c, 'Order close date was not updated');
	}
}