/**
 * @author Oktana
 * @description test class for THOR_OrderListRelatedController
 */
@isTest
public with sharing class THOR_OrderListRelatedController_Test {
	@TestSetup
	static void makeData() {
		Master_Map_Set__c mms = new Master_Map_Set__c();
		insert mms;

		Master_Map__c mm = new Master_Map__c();
		mm.Type__c = 'Main Work Center';
		mm.Name = 'ENMA-E';
		mm.Master_Map_Set__c = mms.Id;
		insert mm;

		Order__c parentOrder = new Order__c();
		parentOrder.Name = 'Parent Order';
		parentOrder.Order_Type__c = 'PJ01';
		parentOrder.Order_Status__c = 'New';
		parentOrder.Order_Number__c = '10730703';
		insert parentOrder;
		Order__c subOrder = new Order__c();
		subOrder.Name = 'Sub Order';
		subOrder.Super_Order__c = parentOrder.Id;
		subOrder.Order_Type__c = 'PJ01';
		subOrder.Order_Status__c = 'New';
		subOrder.Main_Work_Center__c = mm.id;
		insert subOrder;
		Notification__c relatedNotification = new Notification__c();
		relatedNotification.Name = 'Related Notification';
		relatedNotification.Notification_Number__c = '10676408';
		relatedNotification.Type__c = 'CM';
		relatedNotification.user_Status__c = 'NNCP';
		relatedNotification.Order__c = parentOrder.id;
		relatedNotification.Main_Work_Center__c = mm.id;
		insert relatedNotification;
	}
	/**
	 * @given an Order with related sub orders and a service to retrieve Order's related records
	 * @when the serice is invoked
	 * @then all Order's related Sub-Orders are retrieved
	 */
	@isTest
	static void testRetrieveOrderRelatedSubOrders() {
		Order__c parentOrder = getParentOrder();
		Test.startTest();
		THOR_OrderListRelatedDTO dto = THOR_OrderListRelatedController.getRelatedObjects(Id.valueOf(parentOrder.Id));
		Test.stopTest();
		System.assertEquals(
			1,
			dto.relatedSubOrders.size(),
			'All Order\'s related Sub Orders should have been retrieved'
		);
	}
	/**
	 * @given an Order with related notifications and a service to retrieve Order's related records
	 * @when the service is invoked
	 * @then all Order's related Notifications are retrieved
	 */
	@isTest
	static void testRetrieveOrderRelatedNotifications() {
		Order__c parentOrder = getParentOrder();
		Test.startTest();
		THOR_OrderListRelatedDTO dto = THOR_OrderListRelatedController.getRelatedObjects(Id.valueOf(parentOrder.Id));
		Test.stopTest();
		System.assertEquals(
			1,
			dto.relatedNotifications.size(),
			'All Order\'s related Notifications should have been retrieved'
		);
	}
	/**
	 * @given an Order and a service to retrieve Order's related records
	 * @when the service is invoked with an empty Order Id
	 * @then no related records are found and error is thrown
	 */
	@isTest
	static void testExceptionWhenNoOrderId() {
		Test.startTest();
		try {
			THOR_OrderListRelatedDTO dto = THOR_OrderListRelatedController.getRelatedObjects('');
			System.assert(false, 'An exception should have been thrown');
		} catch (Exception e) {
			System.assertEquals('System.AuraHandledException', e.getTypeName(), 'An exception should catch empty ids');
		}
		Test.stopTest();
	}
	private static Order__c getParentOrder() {
		return [SELECT Id FROM Order__c WHERE Name = 'Parent Order' LIMIT 1];
	}
	/**
	 * @given an Order with related notifications and a service to retrieve Order's related records
	 * @when the service is invoked
	 * @then all Order's related Notifications are retrieved filtered by status
	 */
	@isTest
	static void testgetRelatedNotificationsByStatusWhenInProgressAndClosed() {
		Master_Map__c mm = new Master_Map__c();
		Order__c parentOrder = getParentOrder();
		Notification__c closedNotification = new Notification__c();
		closedNotification.Name = 'Related Notification';
		closedNotification.Notification_Number__c = '10676999';
		closedNotification.Type__c = 'CM';
		closedNotification.Fault_Code__c = mm.id;
		closedNotification.user_Status__c = 'NNCP';
		closedNotification.Order__c = parentOrder.id;
		insert closedNotification;
		closedNotification.System_Status_Text__c = 'NOCO';
		closedNotification.Notification_Status__c = 'Closed';
		update closedNotification;

		Notification__c inProgressNotification = new Notification__c();
		inProgressNotification.Name = 'Related Notification';
		inProgressNotification.Notification_Number__c = '10676111';
		inProgressNotification.Type__c = 'CM';
		inProgressNotification.Notification_Status__c = 'In Progress';
		inProgressNotification.System_Status_Text__c = 'NOPR';
		inProgressNotification.user_Status__c = 'NNCP';
		inProgressNotification.Description__c = 'This is a test description...';
		inProgressNotification.AssignedTo__c = userInfo.getUserId();
		inProgressNotification.Order__c = parentOrder.id;
		insert inProgressNotification;

		Notification__c inProgressNotification1 = new Notification__c();
		inProgressNotification1.Name = 'Related Notification';
		inProgressNotification1.Notification_Number__c = '10676112';
		inProgressNotification1.Type__c = 'CM';
		inProgressNotification1.Notification_Status__c = 'In Progress';
		inProgressNotification1.System_Status_Text__c = 'NOPR';
		inProgressNotification1.user_Status__c = 'NNCP';
		inProgressNotification1.Description__c = 'This is a test description...';
		inProgressNotification1.AssignedTo__c = userInfo.getUserId();
		inProgressNotification1.Order__c = parentOrder.id;
		insert inProgressNotification1;
		Test.startTest();
		THOR_OrderListRelatedDTO dtoInProgress = THOR_OrderListRelatedController.getRelatedNotificationsByStatus(
			Id.valueOf(parentOrder.Id),
			'In Progress'
		);
		Test.stopTest();
		System.assertEquals(3, dtoInProgress.relatedNotifications.size(), 'Not retrieving the related notifications');
	}
	/**
	 * @given an Order with related notifications and a service to retrieve Order's related records
	 * @when the service is invoked
	 * @then all Order's related Notifications are retrieved filtered by status
	 */
	@isTest
	static void testgetRelatedNotificationsByStatusWhenOneNew() {
		Order__c parentOrder = getParentOrder();
		Test.startTest();
		THOR_OrderListRelatedDTO dtoNew = THOR_OrderListRelatedController.getRelatedNotificationsByStatus(
			Id.valueOf(parentOrder.Id),
			'New'
		);
		Test.stopTest();
		System.assertEquals(
			1,
			dtoNew.relatedNotifications.size(),
			'One new related notification should have been retrieved'
		);
	}

	/**
	 * @given an Order with related notifications and a service to retrieve Order's related records
	 * @when the service is invoked
	 * @then all Order's related Notifications are retrieved filtered by status
	 */
	@isTest
	static void testgetRelatedNotificationsByStatusAndFiltersWhenOneNew() {
		Order__c parentOrder = getParentOrder();
		Test.startTest();
		THOR_OrderListRelatedDTO dtoNew = THOR_OrderListRelatedController.getRelatedNotificationsByStatus(
			Id.valueOf(parentOrder.Id),
			'New',
			'',
			false,
			null,
			null,
			0
		);
		Test.stopTest();
		System.assertEquals(
			1,
			dtoNew.relatedNotifications.size(),
			'One new related notification should have been retrieved'
		);
	}

	/**
	 * @given an Order with related notifications and a service to retrieve Order's related records
	 * @when the service is invoked
	 * @then all Order's related Sub-Orders are retrieved filtered by status
	 */
	@isTest
	static void testgetRelatedOrderByStatusAndFiltersWhenOneNew() {
		Order__c parentOrder = getParentOrder();
		Test.startTest();
		THOR_OrderListRelatedDTO dtoNew = THOR_OrderListRelatedController.getRelatedOrdersByStatus(
			Id.valueOf(parentOrder.Id),
			'New',
			'',
			false,
			null,
			null,
			0
		);
		Test.stopTest();
		System.assertEquals(1, dtoNew.relatedSubOrders.size(), 'One new related sub orders should have been retrieved');
	}

	/**
	 * @given an Order with related sub orders and a service to retrieve Order's related records by status
	 * @when the service is invoked
	 * @then all Order's related Sub-Orders are retrieved filtered by status
	 */
	@isTest
	static void testgetRelatedOrdersByStatusWhenOneNew() {
		Order__c parentOrder = getParentOrder();
		Test.startTest();
		THOR_OrderListRelatedDTO newList = THOR_OrderListRelatedController.getRelatedOrdersByStatus(
			Id.valueOf(parentOrder.Id),
			'New'
		);
		Test.stopTest();
		System.assertEquals(
			1,
			newList.relatedSubOrders.size(),
			'One related New Sub Orders should have been retrieved'
		);
	}
	/**
	 * @given an Order with related sub orders and a service to retrieve Order's related records by status
	 * @when the service is invoked
	 * @then all Order's related Sub-Orders are retrieved filtered by status
	 */
	@isTest
	static void testgetRelatedOrdersByStatusWhenOneCloseAndOneInProgress() {
		Order__c parentOrder = getParentOrder();
		Order__c closedSubOrder = new Order__c();
		closedSubOrder.Name = 'Sub Order2';
		closedSubOrder.Super_Order__c = parentOrder.Id;
		closedSubOrder.Order_Type__c = 'PJ01';
		closedSubOrder.Order_Status__c = 'Closed';
		closedSubOrder.System_Status_Text__c = 'TECO';
		insert closedSubOrder;
		Order__c inProgressSubOrder = new Order__c();
		inProgressSubOrder.Name = 'Sub Order3';
		inProgressSubOrder.Super_Order__c = parentOrder.Id;
		inProgressSubOrder.Order_Type__c = 'PJ01';
		inProgressSubOrder.Order_Status__c = 'In Progress';
		inProgressSubOrder.System_Status_Text__c = 'REL';
		insert inProgressSubOrder;
		Test.startTest();
		THOR_OrderListRelatedDTO inProgressList = THOR_OrderListRelatedController.getRelatedOrdersByStatus(
			Id.valueOf(parentOrder.Id),
			'In Progress'
		);
		Test.stopTest();
		System.assertEquals(2, inProgressList.relatedSubOrders.size(), 'Should be 2 orders in execution');
		System.assertEquals(
			closedSubOrder.Id,
			inProgressList.relatedSubOrders[0].Id,
			'The retrieved order is not related to the parent'
		);
	}
}