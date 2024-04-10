/**
 * @author Oktana
 * @description test class for Thor_RetrieveController
 */
@isTest
public with sharing class THOR_RetrieverController_Test {
	@TestSetup
	static void makeData() {
		Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Read Only'];
        List<User>userList = new List<User>();
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
		userList.add(readOnlyUser) ;

		User dTeamLead = new User(
			Alias = 'dTL',
			Email = 'testUser@testorg.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'Testing',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator']
			.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testUser' + DateTime.now().getTime() + '@testorg.com'
        );
        userList.add(dTeamLead) ;
        insert userList;

		Functional_Location__c parentFL = new Functional_Location__c(Name = 'Parent FL');
		insert parentFL;
		List<Notification__c> childNotifications = new List<Notification__c>();
		for (Integer i = 0; i < 5; i++) {
			childNotifications.add(
				new Notification__c(
					Name = String.valueOf(i),
					Functional_Location__c = parentFL.Id,
					Notification_Status__c = 'New'
				)
			);
		}
		insert childNotifications;
		List<Order__c> mockOrders = new List<Order__c>{
			new Order__c(
				Description__c = 'Lorem Ipsum 1',
				Order_Status__c = 'In Progress',
				Requested_Date__c = Date.today(),
				Order_Number__c = '99900701',
				Priority__c = 'Normal',
				Order_Type__c = 'CM - Corrective Maintenance'
			),
			new Order__c(
				Description__c = 'Lorem Ipsum 2',
				Order_Status__c = 'In Progress',
				Requested_Date__c = Date.today(),
				Order_Number__c = '99900702',
				Priority__c = 'Normal',
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

		Operation__c operation = new Operation__c();
		insert operation;

		Order_Operation__c orderOperation = new Order_Operation__c();
		orderOperation.Order__c = mockOrders[0].Id;
		orderOperation.Operation__c = operation.Id;
		insert orderOperation;

		Master_Map_Set__c mms = new Master_Map_Set__c();
		insert mms;

		Master_Map__c mainWorkCenterTest = new Master_Map__c();
		mainWorkCenterTest.Master_Map_Set__c = mms.Id;
		mainWorkCenterTest.Name = 'ENMA-E';
		mainWorkCenterTest.Type__c = 'Main Work Center';
		mainWorkCenterTest.Code__c = 'ENMA-E';
		insert mainWorkCenterTest;
		mainWorkCenterTest.Name = 'ENMA-E';
		update mainWorkCenterTest;

		Notification__c notiENMA = new Notification__c();
		notiENMA.Description__c = 'Lorem Ipsum notiENMA';
		notiENMA.Notification_Status__c = 'In Progress';
		notiENMA.Priority__c = 'Normal';
		notiENMA.System_Status_Text__c = 'NOPR';
		notiENMA.Requested_Date__c = Date.today();
		notiENMA.Required_End__c = Date.today();
		notiENMA.Required_Start__c = Date.today();
		notiENMA.Type__c = 'PM';
		notiENMA.User_Status__c = 'CANC';
		notiENMA.AssignedTo__c = UserInfo.getUserId();
		notiENMA.Order__c = mockOrders[0].Id;
		notiENMA.Functional_Location__c = parentFL.Id;
		notiENMA.Main_Work_Center__c = mainWorkCenterTest.Id;
		insert notiENMA;

		Order__c orderENMA = new Order__c(
			Description__c = 'Lorem Ipsum OrderENMA',
			System_Status_Text__c = 'CRTD REL',
			//Order_Status__c = 'In Progress',
			Requested_Date__c = Date.today(),
			Priority__c = 'Normal',
			Order_Type__c = 'CM - Corrective Maintenance',
			Responsible_person__c = UserInfo.getUserId(),
			Main_Work_Center__c = mainWorkCenterTest.Id,
			Super_Order__c = getParentOrder().Id
		);
		insert orderENMA;

		Notification__c n = new Notification__c();
		n.Description__c = 'Lorem Ipsum';
		n.Notification_Status__c = 'New';
		n.Priority__c = 'Normal';
		n.Requested_Date__c = Date.today();
		n.Required_End__c = Date.today();
		n.Required_Start__c = Date.today();
		n.Type__c = 'PM';
		n.User_Status__c = 'CANC';
		n.AssignedTo__c = UserInfo.getUserId();
		n.Order__c = mockOrders[0].Id;
		insert n;
		Item__c mockItem = new Item__c(
			Start_Date__c = System.today(),
			End_Date__c = System.today().addDays(4),
			Notification__c = notiENMA.Id
		);
		insert mockItem;
	}
	@isTest
	public static void givenStatusWhenCalledGetNotificationsExpectedArrayOfDTOSFilteredByStatus() {
		List<THOR_ObjectCardDTO> dtos = THOR_RetrieverController.retrieveNotifications('New');
		System.assert(dtos.size() > 0, 'Controller did not returned elements');
		System.assertEquals('New', dtos[0].status, 'Status does not match');
	}
	@isTest
	public static void givenStatusWhenCalledGetNotificationsExpectedArrayOfDTOSFilteredByStatusException() {
		User readOnlyUser = getReadOnlyUser();
		System.runAs(readOnlyUser) {
			try {
				List<THOR_ObjectCardDTO> dtos = THOR_RetrieverController.retrieveNotifications('New');
			} catch (Exception e) {
				System.assertEquals(
					'System.AuraHandledException',
					e.getTypeName(),
					'Aura Exception should be thrown when user access is restricted or bad query'
				);
			}
		}
	}
	@isTest
	public static void givenStatusWhenCalledGetNotificationsExpectedEmptyArray() {
		List<THOR_ObjectCardDTO> dtos = THOR_RetrieverController.retrieveNotifications('In Execution');
		System.assert(dtos.size() == 0, 'Controller returned elements');
	}
	@isTest
	public static void givenStatusWhenCalledGetOrdersExpectedArrayOfDTOSFilteredByStatus() {
		List<THOR_ObjectCardDTO> dtos = THOR_RetrieverController.retrieveOrders('In Progress');
		System.assert(dtos.size() > 0, 'Controller did not returned elements');
		System.assertEquals('In Progress', dtos[0].status, 'Status does not match');
	}
	@isTest
	public static void testRetrieveOrdersException() {
		User readOnlyUser = getReadOnlyUser();
		System.runAs(readOnlyUser) {
			try {
				List<THOR_ObjectCardDTO> dtos = THOR_RetrieverController.retrieveOrders('New');
			} catch (Exception e) {
				System.assertEquals(
					'System.AuraHandledException',
					e.getTypeName(),
					'Aura Exception should be thrown when user access is restricted or bad query'
				);
			}
		}
	}
	@isTest
	public static void testRetrieveResponsibleOrders() {
		Test.startTest();
		List<THOR_ObjectCardDTO> actual = THOR_RetrieverController.retrieveResponsibleOrders('In Progress');
		Test.stopTest();
		System.assert(
			actual.size() > 0,
			'Should return orders that have us/UserInfo.getUserId() as the Responsible_person__c'
		);
	}
	@isTest
	public static void testRetrieveResponsibleOrdersException() {
		User readOnlyUser = getReadOnlyUser();
		System.runAs(readOnlyUser) {
			try {
				List<THOR_ObjectCardDTO> actual = THOR_RetrieverController.retrieveResponsibleOrders('In Progress');
			} catch (Exception e) {
				System.assertEquals(
					'System.AuraHandledException',
					e.getTypeName(),
					'Aura Exception should be thrown when user access is restricted or bad query'
				);
			}
		}
	}
	@isTest
	public static void testRetrieveRelatedOrders() {
		Order__c childOrder = getChildOrder();
		Order__c parentOrder = getParentOrder();
		Test.startTest();
		List<THOR_ObjectCardDTO> actual = THOR_RetrieverController.retrieveRelatedOrders(
			'In Progress',
			Id.valueOf(parentOrder.Id)
		);
		Test.stopTest();
		Order__c actualOrderSuper = [SELECT Id, Super_Order__c FROM Order__c WHERE Id = :actual[0].recordId LIMIT 1];
		System.assertEquals(
			parentOrder.Id,
			actualOrderSuper.Super_Order__c,
			'Returned Order__c should have a Super_Order__c of the parent'
		);
	}
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
		//System.assert(newList.size() == 0, 'New related order should not be retrived because there is not');
	}
	@isTest
	public static void testRetrieveRelatedOrdersByStatusWhenOneInProgress() {
		Order__c childOrder = getChildOrder();
		Order__c parentOrder = getParentOrder();
		Test.startTest();
		List<THOR_ObjectCardDTO> inPorgressList = THOR_RetrieverController.retrieveRelatedOrdersByStatus(
			'In Progress',
			Id.valueOf(parentOrder.Id)
		);
		Test.stopTest();
		System.assertEquals(inPorgressList[0].recordId, childOrder.Id, 'Retrieved order is not the related order');
	}
	@isTest
	public static void testRetrieveRelatedNotifications() {
		Order__c parentOrder = getParentOrder();
		Test.startTest();
		List<THOR_ObjectCardDTO> actual = THOR_RetrieverController.retrieveRelatedNotifications(
			'New',
			Id.valueOf(parentOrder.Id)
		);
		Test.stopTest();
		Notification__c actualOrderId = [
			SELECT Id, Order__c
			FROM Notification__c
			WHERE Id = :actual[0].recordId
			LIMIT 1
		];
		System.assertEquals(
			parentOrder.Id,
			actualOrderId.Order__c,
			'Returned Notification__c should have an Order__c of the parentOrder'
		);
	}
	@isTest
	public static void testRetrieveRelatedNotificationsByStatusWhenOneNewRelated() {
		Order__c parentOrder = getParentOrder();
		Test.startTest();
		List<THOR_ObjectCardDTO> newRelatedNotifications = THOR_RetrieverController.retrieveRelatedNotificationsByStatus(
			'New',
			Id.valueOf(parentOrder.Id)
		);
		Test.stopTest();
		System.assertEquals(
			1,
			newRelatedNotifications.size(),
			'There should be one notification with Status New related to the Order'
		);
	}
	@isTest
	public static void testRetrieveRelatedNotificationsByStatusWhenNoInProgressRelated() {
		//deleteNotiENMA();

		Order__c parentOrder = getParentOrder();
		Test.startTest();
		List<THOR_ObjectCardDTO> inProgressRelatedNotifications = THOR_RetrieverController.retrieveRelatedNotificationsByStatus(
			'In Progress',
			Id.valueOf(parentOrder.Id)
		);
		Test.stopTest();
		System.assertEquals(inProgressRelatedNotifications.size(), 1, 'Theres notifications related In Progress');
	}
	@isTest
	public static void testRetrieveItems() {
		Notification__c relatedNotification = getAssignedNotification();
		Test.startTest();
		List<THOR_ObjectCardDTO> actual = THOR_RetrieverController.retrieveItems(ID.valueOf(relatedNotification.Id));
		Test.stopTest();
		System.assertEquals(
			relatedNotification.Id,
			actual[0].notification,
			'Should return Item__c related to the Notification__c'
		);
	}
	@isTest
	public static void testRetrieveItemsException() {
		User readOnlyUser = getReadOnlyUser();
		System.runAs(readOnlyUser) {
			try {
				List<THOR_ObjectCardDTO> actual = THOR_RetrieverController.retrieveItems('');
			} catch (Exception e) {
				System.assertEquals(
					'System.AuraHandledException',
					e.getTypeName(),
					'Aura Exception should be thrown when user access is restricted or bad query'
				);
			}
		}
	}

	/**
	 * @given Notifications related to a Functional Location
	 * @when the service to retrieve Notifications related to a FL is invoked
	 * @then all Notifications related to the FL are retrieved
	 */
	@isTest
	public static void testRetrieveFLNotifications() {
		Functional_Location__c parentFL = getFunctionalLocation();
		Test.startTest();
		List<THOR_ObjectCardDTO> dtos = THOR_RetrieverController.retrieveFLNotifications(String.valueOf(parentFL.Id));
		Test.stopTest();
		System.assertEquals(6, dtos.size(), 'All Notifications related to FL should have been retrieved');
	}
	/**
	 * @given Notifications related to a Functional Location
	 * @when the service to retrieve Notifications related to a FL is invoked by a User with no permissions
	 * @then an exception should be arised
	 */
	@isTest
	public static void testRetrieveFLNotificationsException() {
		Functional_Location__c parentFL = getFunctionalLocation();
		User readOnlyUser = getReadOnlyUser();
		System.runAs(readOnlyUser) {
			try {
				List<THOR_ObjectCardDTO> dtos = THOR_RetrieverController.retrieveFLNotifications(
					Id.valueOf(parentFL.Id)
				);
			} catch (Exception e) {
				System.assertEquals(
					'System.AuraHandledException',
					e.getTypeName(),
					'Aura Exception should be thrown when user access is restricted or bad query'
				);
			}
		}
	}
	/**
	 * @given Id as string
	 * @when getting the object type to use for navigation
	 * @then return object type as String
	 */
	@isTest
	public static void testGetObjectTypeFromId() {
		Order__c mockOrder = getParentOrder();
		Notification__c mockNotification = getAssignedNotification();
		String orderId = String.valueOf(mockOrder.Id);
		String notificationId = String.valueOf(mockNotification.Id);
		Test.startTest();
		String orderType = THOR_RetrieverController.getObjectTypeFromId(orderId);
		String notificationType = THOR_RetrieverController.getObjectTypeFromId(notificationId);
		Test.stopTest();
		System.assertEquals('Order__c', orderType, 'Method should return the object type, returned should be Order__c');
		System.assertEquals(
			'Notification__c',
			notificationType,
			'Method should return the object type, returned should be Notification__c'
		);
	}
	@isTest
	public static void testRetrieveAssignedNotifications() {
		Notification__c shouldBe = getAssignedNotification();
		Test.startTest();
		List<THOR_ObjectCardDTO> actual = THOR_RetrieverController.retrieveAssignedNotifications('In Progress');
		Test.stopTest();
		System.assertEquals(shouldBe.Id, actual[0].recordId, 'Should return the record we inserted');
	}
	@isTest
	public static void testRetrieveAssignedNotificationsException() {
		User readOnlyUser = getReadOnlyUser();
		System.runAs(readOnlyUser) {
			try {
				List<THOR_ObjectCardDTO> actual = THOR_RetrieverController.retrieveAssignedNotifications('New');
			} catch (Exception e) {
				System.assertEquals(
					'System.AuraHandledException',
					e.getTypeName(),
					'Aura Exception should be thrown when user access is restricted or bad query'
				);
			}
		}
	}
	@isTest
	public static void retrieveNotificationsWithFiltersExpectedOne() {
		Test.startTest();
		List<THOR_ObjectCardDTO> filteredNotifications = THOR_RetrieverController.retrieveNotifications(
			'In Progress',
			'ENMA-E',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1),
			1
		);
		Test.stopTest();
		System.assertEquals(1, filteredNotifications.size(), 'retrieved notifications size does not match');
	}

	@isTest
	public static void retrieveNotificationsException() {
		User readOnlyUser = getReadOnlyUser();
		Test.startTest();
		System.runAs(readOnlyUser) {
			try {
				List<THOR_ObjectCardDTO> filteredNotifications = THOR_RetrieverController.retrieveNotifications(
					'In Progress',
					'ENMA-E',
					true,
					Date.Today().addDays(-1),
					Date.Today().addDays(1),
					1
				);
			} catch (Exception e) {
				System.assertEquals(
					'System.AuraHandledException',
					e.getTypeName(),
					'Aura Exception should be thrown when user access is restricted or bad query'
				);
			}
		}
		Test.stopTest();
	}

	@isTest
	public static void retrieveNotificationsWithloadLimitZeroFiltersExpectedOne() {
		Test.startTest();
		List<THOR_ObjectCardDTO> filteredNotifications = THOR_RetrieverController.retrieveNotifications(
			'In Progress',
			'ENMA-E',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1),
			0
		);
		Test.stopTest();
		System.assertEquals(1, filteredNotifications.size(), 'retrieved notifications size does not match');
	}

	@isTest
	public static void retrieveNotificationsCountWithFiltersExpectedOne() {
		Test.startTest();
		Integer count = THOR_RetrieverController.retrieveNotificationsCount(
			'In Progress',
			'ENMA-E',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1)
		);
		Test.stopTest();
		System.assertEquals(1, count, 'retrieved orders count does not match');
	}

	@isTest
	public static void retrieveNotificationsWithFiltersExpectedZero() {
		Test.startTest();
		List<THOR_ObjectCardDTO> filteredNotificationsByMWC = THOR_RetrieverController.retrieveNotifications(
			'In Progress',
			'ENMA-I',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1),
			1
		);

		List<THOR_ObjectCardDTO> filteredNotificationsByDate = THOR_RetrieverController.retrieveNotifications(
			'In Progress',
			'ENMA-E',
			true,
			Date.Today().addDays(1),
			Date.Today().addDays(1),
			1
		);

		User userTest = [SELECT Id, Name, Alias FROM User WHERE Alias = 'dTL'][0];

		System.runAs(userTest) {
			List<THOR_ObjectCardDTO> filteredNotificationsByUser = THOR_RetrieverController.retrieveNotifications(
				'In Progress',
				'ENMA-E',
				true,
				Date.Today().addDays(-1),
				Date.Today().addDays(1),
				1
			);
			Test.stopTest();
			System.assertEquals(
				0,
				filteredNotificationsByUser.size(),
				'retrieved notifications by user does not match'
			);
		}

		System.assertEquals(0, filteredNotificationsByMWC.size(), 'retrieved notifications by MWC does not match');
		System.assertEquals(0, filteredNotificationsByDate.size(), 'retrieved notifications by date does not match');
	}

	@isTest
	public static void retrieveFLNotificationsWithFiltersExpectedOne() {
		Functional_Location__c parentFL = getFunctionalLocation();

		Test.startTest();
		List<THOR_ObjectCardDTO> filteredNotifications = THOR_RetrieverController.retrieveFLNotifications(
			parentFL.Id,
			//'ENMA-E',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1)
		);
		Test.stopTest();
		System.assertEquals(1, filteredNotifications.size(), 'retrieved notifications size does not match');
	}

	@isTest
	public static void retrieveFLNotificationsWithFiltersExpectedZero() {
		Functional_Location__c parentFL = getFunctionalLocation();

		List<THOR_ObjectCardDTO> filteredNotificationsByUser;
		Test.startTest();
		List<THOR_ObjectCardDTO> filteredNotificationsByDate = THOR_RetrieverController.retrieveFLNotifications(
			parentFL.Id,
			//'ENMA-E',
			true,
			Date.Today().addDays(1),
			Date.Today().addDays(1)
		);

		User userTest = [SELECT Id, Name, Alias FROM User WHERE Alias = 'dTL'][0];

		System.runAs(userTest) {
			filteredNotificationsByUser = THOR_RetrieverController.retrieveFLNotifications(
				parentFL.Id,
				//'ENMA-E',
				true,
				Date.Today().addDays(-1),
				Date.Today().addDays(1)
			);
			Test.stopTest();
		}

		System.assertEquals(0, filteredNotificationsByUser.size(), 'retrieved fl notifications by user does not match');

		System.assertEquals(0, filteredNotificationsByDate.size(), 'retrieved fl notifications by date does not match');
	}

	@isTest
	public static void retrieveOrdersWithFiltersExpectedOne() {
		Test.startTest();
		List<THOR_ObjectCardDTO> filteredOrders = THOR_RetrieverController.retrieveOrders(
			'In Progress',
			'ENMA-E',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1),
			1
		);
		Test.stopTest();
		//System.assertEquals(1, filteredOrders.size(), 'retrieved orders size does not match');
	}

	@isTest
	public static void retrieveOrdersWithLoadLimitZeroFiltersExpectedOne() {
		Test.startTest();
		List<THOR_ObjectCardDTO> filteredOrders = THOR_RetrieverController.retrieveOrders(
			'In Progress',
			'ENMA-E',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1),
			0
		);
		Test.stopTest();
		//System.assertEquals(1, filteredOrders.size(), 'retrieved orders size does not match');
	}

	@isTest
	public static void retrieveOrdersWithFiltersExpectedZero() {
		Test.startTest();
		List<THOR_ObjectCardDTO> filteredOrdersByMWC = THOR_RetrieverController.retrieveOrders(
			'In Progress',
			'ENMA-I',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1),
			1
		);

		List<THOR_ObjectCardDTO> filteredOrdersByDate = THOR_RetrieverController.retrieveOrders(
			'In Progress',
			'ENMA-E',
			true,
			Date.Today().addDays(1),
			Date.Today().addDays(1),
			1
		);

		User userTest = [SELECT Id, Name, Alias FROM User WHERE Alias = 'dTL'][0];

		System.runAs(userTest) {
			List<THOR_ObjectCardDTO> filteredOrdersByUser = THOR_RetrieverController.retrieveOrders(
				'In Progress',
				'ENMA-E',
				true,
				Date.Today().addDays(-1),
				Date.Today().addDays(1),
				1
			);
			Test.stopTest();
			System.assertEquals(0, filteredOrdersByUser.size(), 'retrieved orders by user does not match');
		}

		System.assertEquals(0, filteredOrdersByMWC.size(), 'retrieved orders by MWC does not match');
		System.assertEquals(0, filteredOrdersByDate.size(), 'retrieved orders by date does not match');
	}

	@isTest
	public static void retrieveOrdersCountWithFiltersExpectedOne() {
		Test.startTest();
		Integer count = THOR_RetrieverController.retrieveOrdersCount(
			'In Progress',
			'ENMA-E',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1)
		);
		Test.stopTest();
		//System.assertEquals(1, count, 'retrieved orders count does not match');
	}

	@isTest
	public static void retrieveRelatedOrdersByStatusWithFiltersExpectedOne() {
		Order__c parentOrder = getParentOrder();

		Test.startTest();
		List<THOR_ObjectCardDTO> filteredOrders = THOR_RetrieverController.retrieveRelatedOrdersByStatus(
			'In Progress',
			Id.valueOf(parentOrder.Id),
			'ENMA-E',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1),
			0
		);
		Test.stopTest();
		//System.assertEquals(1, filteredOrders.size(), 'retrieved related orders size does not match');
	}

	@isTest
	public static void retrieveRelatedOrdersByStatusWithFiltersExpectedZero() {
		Order__c parentOrder = getParentOrder();

		Test.startTest();
		List<THOR_ObjectCardDTO> filteredOrdersByMWC = THOR_RetrieverController.retrieveRelatedOrdersByStatus(
			'In Progress',
			Id.valueOf(parentOrder.Id),
			'ENMA-I',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1),
			0
		);

		List<THOR_ObjectCardDTO> filteredOrdersByDate = THOR_RetrieverController.retrieveRelatedOrdersByStatus(
			'In Progress',
			Id.valueOf(parentOrder.Id),
			'ENMA-E',
			true,
			Date.Today().addDays(1),
			Date.Today().addDays(1),
			0
		);

		User userTest = [SELECT Id, Name, Alias FROM User WHERE Alias = 'dTL'][0];

		System.runAs(userTest) {
			List<THOR_ObjectCardDTO> filteredOrdersByUser = THOR_RetrieverController.retrieveRelatedOrdersByStatus(
				'In Progress',
				Id.valueOf(parentOrder.Id),
				'ENMA-E',
				true,
				Date.Today().addDays(-1),
				Date.Today().addDays(1),
				0
			);
			Test.stopTest();
			System.assertEquals(0, filteredOrdersByUser.size(), 'retrieved related orders by user does not match');
		}

		System.assertEquals(0, filteredOrdersByMWC.size(), 'retrieved related orders by MWC does not match');
		System.assertEquals(0, filteredOrdersByDate.size(), 'retrieved related orders by date does not match');
	}

	@isTest
	public static void retrieveRelatedNotificationsByStatusWithFiltersExpectedOne() {
		Order__c parentOrder = getParentOrder();

		Test.startTest();
		List<THOR_ObjectCardDTO> filteredNotifications = THOR_RetrieverController.retrieveRelatedNotificationsByStatus(
			'In Progress',
			Id.valueOf(parentOrder.Id),
			'ENMA-E',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1),
			0
		);
		Test.stopTest();
		System.assertEquals(1, filteredNotifications.size(), 'retrieved related notifications size does not match');
	}

	@isTest
	public static void retrieveRelatedNotificationsByStatusWithFiltersExpectedZero() {
		Order__c parentOrder = getParentOrder();

		Test.startTest();
		List<THOR_ObjectCardDTO> filteredNotificationsByMWC = THOR_RetrieverController.retrieveRelatedNotificationsByStatus(
			'Closed',
			Id.valueOf(parentOrder.Id),
			'ENMA-I',
			true,
			Date.Today().addDays(-1),
			Date.Today().addDays(1),
			0
		);

		List<THOR_ObjectCardDTO> filteredNotificationsByDate = THOR_RetrieverController.retrieveRelatedNotificationsByStatus(
			'Closed',
			Id.valueOf(parentOrder.Id),
			'ENMA-E',
			true,
			Date.Today().addDays(1),
			Date.Today().addDays(1),
			0
		);

		User userTest = [SELECT Id, Name, Alias FROM User WHERE Alias = 'dTL'][0];

		System.runAs(userTest) {
			List<THOR_ObjectCardDTO> filteredNotificationsByUser = THOR_RetrieverController.retrieveRelatedNotificationsByStatus(
				'Closed',
				Id.valueOf(parentOrder.Id),
				'ENMA-E',
				true,
				Date.Today().addDays(-1),
				Date.Today().addDays(1),
				0
			);
			Test.stopTest();
			System.assertEquals(
				0,
				filteredNotificationsByUser.size(),
				'retrieved related notifications by user does not match'
			);
		}

		System.assertEquals(
			0,
			filteredNotificationsByMWC.size(),
			'retrieved related notifications by MWC does not match'
		);
		System.assertEquals(
			0,
			filteredNotificationsByDate.size(),
			'retrieved related notifications by date does not match'
		);
	}

	@isTest
	public static void getRelatedMainWorkCenterNamesTest() {
		User testRoleUser = new User(
			Alias = 'tru',
			Email = 'testUser@testorg.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'Testing',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator']
			.Id,
			TimeZoneSidKey = 'America/Los_Angeles',
			UserName = 'testRoleUser' + DateTime.now().getTime() + '@testorg.com',
			UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'TOP THOR APU-A Team Lead-ENMA-E/TOC-2' LIMIT 1]
			.Id
		);

		insert testRoleUser;

		System.runAs(testRoleUser) {
			List<String> relatedMainWorkCenterNames = THOR_RetrieverController.getRelatedMainWorkCenterNames();

			System.assertEquals(
				relatedMainWorkCenterNames.size(),
				1,
				'relatedMainWorkCenterNames has more than one element'
			);

			System.assertEquals(
				relatedMainWorkCenterNames[0],
				'ENMA-E',
				'wrong related main work center name retrieved'
			);
		}
	}

	@isTest
	public static void retrieveOperationsTest() {
		Order__c order = [SELECT Id, Description__c FROM Order__c WHERE Description__c = 'Lorem Ipsum 1'];

		Test.startTest();
		List<THOR_ObjectCardDTO> dtos = THOR_RetrieverController.retrieveOperations(order.Id, 0);
		List<THOR_ObjectCardDTO> dtosWithLimit = THOR_RetrieverController.retrieveOperations(order.Id, 1);
		Test.stopTest();

		//System.assertEquals(1, dtos.size(), 'Retrieved list size does not match');
		//System.assertEquals(1, dtosWithLimit.size(), 'Retrieved list (with limit) size does not match');
	}

	@isTest
	public static void retrieveOperationsCountTest() {
		Order__c order = [SELECT Id, Description__c FROM Order__c WHERE Description__c = 'Lorem Ipsum 1'];

		Test.startTest();
		Integer count = THOR_RetrieverController.retrieveOperationsCount(order.Id);
		Test.stopTest();

		//System.assertEquals(1, count, 'Retrieved operations count does not match');
	}

	@isTest
	static void testRetrieveRelatedOrdersCount() {
		Order__c superOrder = new Order__c(Name = 'Super Order');
		insert superOrder;
		List<Order__c> orders = new List<Order__c>();
		for (Integer i = 0; i < 5; i++) {
			orders.add(
				new Order__c(
					Order_Status__c = Constants.ORDERS.STATUS_NEW,
					Super_Order__c = superOrder.Id,
					Responsible_person__c = UserInfo.getUserId()
				)
			);
		}

			// orders.add(
			// 	new Order__c(
			// 		Order_Status__c = Constants.ORDERS.STATUS_NEW,
			// 		Super_Order__c = superOrder.Id,
			// 		Responsible_person__c = UserInfo.getUserId()
			// 	)
			// );
		insert orders;

		Integer countOrders;
		Test.startTest();
		countOrders = THOR_RetrieverController.retrieveRelatedOrdersCount(
			Constants.ORDERS.STATUS_NEW,
			superOrder.Id,
			'',
			true,
			Date.today(),
			Date.today().addDays(1)
		);
		Test.stopTest();

		System.assertEquals(5, countOrders, 'Orders should be counted');
	}
   

	@isTest
	static void testRetrieveRelatedNotificationsCount() {
        Test.startTest();
		THOR_RetrieverController.retrieveRelatedNotificationsCount(
			'In Progress',
			'',
			'',
			true,
			Date.today(),
			Date.today().addDays(1)
		);
		Test.stopTest();
        /*
		Order__c superOrder = new Order__c(Name = 'Super Order', Order_Number__c = '99900901');
		insert superOrder;
		List<Notification__c> notifications = new List<Notification__c>();
		for (Integer i = 0; i < 1; i++) {
			notifications.add(
				new Notification__c(
					Notification_Status__c = Constants.NOTIFICATIONS.STATUS_NEW,
					Order__c = superOrder.Id,
					AssignedTo__c = UserInfo.getUserId()
				)
			);
		}
		insert notifications;

		Integer countNotifications;
		Test.startTest();
		countNotifications = THOR_RetrieverController.retrieveRelatedNotificationsCount(
			Constants.NOTIFICATIONS.STATUS_NEW,
			superOrder.Id,
			'',
			true,
			Date.today(),
			Date.today().addDays(1)
		);
		Test.stopTest();
*/
		//System.assertEquals(5, countNotifications, 'Notifications should be counted');
	}

	private static User getReadOnlyUser() {
		return [SELECT ID FROM User WHERE Email = 'ReadOnlyUser@testorg.com'];
	}
	private static Functional_Location__c getFunctionalLocation() {
		return [SELECT Id FROM Functional_Location__c WHERE Name = 'Parent FL' LIMIT 1];
	}
	private static Notification__c getAssignedNotification() {
		return [SELECT Id FROM Notification__c WHERE Description__c = 'Lorem Ipsum notiENMA'];
	}
	private static Order__c getParentOrder() {
		return [SELECT Id FROM Order__c WHERE Description__c = 'Lorem Ipsum 1'][0];
	}
	private static Order__c getChildOrder() {
		return [SELECT Id FROM Order__c WHERE Description__c = 'Lorem Ipsum 2'][0];
	}

	private static void deleteNotiENMA() {
		Notification__c notiENMA = [SELECT Id FROM Notification__c WHERE Description__c = 'Lorem Ipsum notiENMA'][0];

		delete notiENMA;
	}

	private static void setOrdersStatusToNew() {
		List<Order__c> orders = [SELECT Id, Order_Status__c FROM Order__c];
		for (Order__c order : orders) {
			order.Order_Status__c = Constants.ORDERS.STATUS_NEW;
		}

		update orders;
	}
}