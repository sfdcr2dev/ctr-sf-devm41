/**
 * @author Oktana
 * @description test class for THOR_ManageComponentRequestController
 */
@isTest
public with sharing class THOR_ManageCompRequestController_Test {
	@testSetup
	public static void makeData() {
		Functional_Location__c fl = new Functional_Location__c(
			Name = 'new functional location',
			Description__c = 'a test fl'
		);
		insert fl;

		List<Equipment__c> equipment = new List<Equipment__c>();
		equipment.add(new Equipment__c(Name = 'First piece of equipment', FL__c = fl.Id));
		equipment.add(new Equipment__c(Name = 'Second piece of equipment', FL__c = fl.Id));
		insert equipment;

		List<BOM__c> boms = new List<BOM__c>();
		boms.add(new BOM__c(Name = 'New BOM', Equipment__c = equipment[0].Id));
		boms.add(new BOM__c(Name = 'Second BOM', Equipment__c = equipment[1].Id));
		insert boms;

		List<Spare_Part__c> spareParts = new List<Spare_Part__c>();
		spareParts.add(
			new Spare_Part__c(
				Material_Number__c = '10110',
				Price__c = 600.00,
				Name = 'New spare part',
				Material_Description__c = 'New spare part description for spare part.'
			)
		);
		spareParts.add(
			new Spare_Part__c(
				Material_Number__c = '20110',
				Price__c = 700.00,
				Name = 'Another New spare part',
				Material_Description__c = 'New spare part description 20110 for spare part two.'
			)
		);
		insert spareParts;

		List<Spare_Part_Stock__c> sparePartStocks = new List<Spare_Part_Stock__c>();
		sparePartStocks.add(
			new Spare_Part_Stock__c(
				Spare_Part__c = spareParts[0].Id,
				Name = 'Spare part stock test.',
				Available_Quantity__c = 600
			)
		);
		sparePartStocks.add(
			new Spare_Part_Stock__c(
				Spare_Part__c = spareParts[1].Id,
				Name = 'Second spare part stock test.',
				Available_Quantity__c = 700
			)
		);
		insert sparePartStocks;

		List<BOM_with_Spare_Part__c> bomsWithSpareParts = new List<BOM_with_Spare_Part__c>();
		bomsWithSpareParts.add(new BOM_with_Spare_Part__c(BOMNo__c = boms[0].Id, sparePartNo__c = spareParts[0].Id));
		bomsWithSpareParts.add(new BOM_with_Spare_Part__c(BOMNo__c = boms[1].Id, sparePartNo__c = spareParts[1].Id));
		insert bomsWithSpareParts;

		List<PISUsers__c> pisuserLst = new List<PISUsers__c>{
			new PISUsers__c(Name = 'pis01', EMPLOYEEID__c = '12340001'),
			new PISUsers__c(Name = 'pis02', EMPLOYEEID__c = '12340002')
		};
		insert pisuserLst;

		List<Order__c> orders = new List<Order__c>();
		orders.add(
			new Order__c(
				Equipment__c = equipment[0].Id,
				Functional_Location__c = fl.Id,
				Name = 'test order',
				Responsible_person_PISUser__r = new PISUsers__c(EMPLOYEEID__c = '12340001')
			)
		);
		orders.add(
			new Order__c(
				Functional_Location__c = fl.Id,
				Name = 'order no equipment',
				Responsible_person_PISUser__r = new PISUsers__c(EMPLOYEEID__c = '12340002')
			)
		);
		insert orders;
	}

	/**
	 * @given Spare Part Requests for an Order
	 * @when Cart is requested for the Order
	 * @then all Draft Spare Part Requests are returned
	 */
	@isTest
	static void testGetCart() {
		Order__c orderTest = [
			SELECT Id, Functional_Location__c, Equipment__c
			FROM Order__c
			WHERE Equipment__c = NULL
			LIMIT 1
		];

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
		existingCart = THOR_ManageComponentRequestController.getCart(orderTest.Id, 'Draft');
		Test.stopTest();

		System.assertEquals(
			5,
			existingCart.size(),
			'All Spare Part Requests related to the Order should have been retrieved'
		);
	}

	@isTest
	static void testDeleteRequestFromCart() {
		Order__c orderTest = [
			SELECT Id, Functional_Location__c, Equipment__c
			FROM Order__c
			WHERE Equipment__c = NULL
			LIMIT 1
		];

		Spare_Part__c sparePartTest = new Spare_Part__c(Name = 'sparePartTest', Material_Number__c = 'MaterialTest');
		insert sparePartTest;

		Spare_Part_Request__c sPartRequest = new Spare_Part_Request__c(
			Order__c = orderTest.Id,
			Item_No__c = '123',
			Spare_Part__c = sparePartTest.Id,
			Request_Status__c = 'Draft'
		);
		insert sPartRequest;

		Test.startTest();
		THOR_ManageComponentRequestController.deleteRequestFromCart(sPartRequest.Id);
		Test.stopTest();

		Spare_Part_Request__c updatedPartRequest = [
			SELECT Id, Deleted__c
			FROM Spare_Part_Request__c
			WHERE Id = :sPartRequest.Id
		];

		System.assertNotEquals(sPartRequest.Deleted__c, updatedPartRequest.Deleted__c);
		System.assert(updatedPartRequest.Deleted__c);
	}

	@isTest
	static void testHasResponsiblePerson() {
		Order__c order = new Order__c();
		order.Name = String.valueOf(10680966);
		order.Order_Type__c = 'PJ01';
		order.Order_Status__c = 'New';
		order.grouptask__c = 'Task';
		order.groupcount__c = 'Count';
		order.Responsible_person_PISUser__r = new PISUsers__c(EMPLOYEEID__c = '12340001');
		insert order;

		Boolean hasRespPerson;
		Test.startTest();
		hasRespPerson = THOR_ManageComponentRequestController.hasResponsiblePerson(order.Id);
		Test.stopTest();

		System.assert(hasRespPerson);
	}

	@isTest
	static void testHasNoResponsiblePerson() {
		Order__c order = new Order__c();
		order.Name = String.valueOf(10680966);
		order.Order_Type__c = 'PJ01';
		order.Order_Status__c = 'New';
		order.grouptask__c = 'Task';
		order.groupcount__c = 'Count';
		insert order;

		Boolean hasRespPerson;
		Test.startTest();
		hasRespPerson = THOR_ManageComponentRequestController.hasResponsiblePerson(order.Id);
		Test.stopTest();

		System.assert(!hasRespPerson);
	}

	@isTest
	static void testSaveOrSubmitRequestsSave() {
		Order__c orderTest = [
			SELECT Id, Functional_Location__c, Equipment__c
			FROM Order__c
			WHERE Equipment__c = NULL
			LIMIT 1
		];
		orderTest.Responsible_person__c = UserInfo.getUserId();
		update orderTest;
		Spare_Part__c sparePartTest = new Spare_Part__c(Name = 'sparePartTest', Material_Number__c = 'MaterialTest');
		insert sparePartTest;

		Order_Operation__c orderOperationTest = new Order_Operation__c(
			Operation_Text__c = 'orderOpTest',
			Order__c = orderTest.Id
		);
		insert orderOperationTest;

		List<Spare_Part_Request__c> sparePartRequests = new List<Spare_Part_Request__c>();
		for (Integer i = 0; i < 5; i++) {
			sparePartRequests.add(
				new Spare_Part_Request__c(
					Order__c = orderTest.Id,
					Item_No__c = '123' + i,
					Spare_Part__c = sparePartTest.Id,
					Request_Status__c = 'Draft',
					Order_Operation__c = orderOperationTest.Id
				)
			);
		}
		insert sparePartRequests;

		Test.startTest();
		THOR_ManageComponentRequestController.saveOrSubmitRequests('save', sparePartRequests);
		Test.stopTest();
	}

	@isTest
	static void testSaveOrSubmitRequestsSubmit() {
		Order__c orderTest = [
			SELECT Id, Functional_Location__c, Equipment__c
			FROM Order__c
			WHERE Equipment__c = NULL
			LIMIT 1
		];
		orderTest.Responsible_person__c = UserInfo.getUserId();
		update orderTest;
		Spare_Part__c sparePartTest = new Spare_Part__c(Name = 'sparePartTest', Material_Number__c = 'MaterialTest');
		insert sparePartTest;

		Order_Operation__c orderOperationTest = new Order_Operation__c(
			Operation_Text__c = 'orderOpTest',
			Order__c = orderTest.Id
		);
		insert orderOperationTest;

		List<Spare_Part_Request__c> sparePartRequests = new List<Spare_Part_Request__c>();
		for (Integer i = 0; i < 5; i++) {
			sparePartRequests.add(
				new Spare_Part_Request__c(
					Order__c = orderTest.Id,
					Item_No__c = '123' + i,
					Spare_Part__c = sparePartTest.Id,
					Request_Status__c = 'Draft',
					Order_Operation__c = orderOperationTest.Id
				)
			);
		}
		insert sparePartRequests;

		Test.startTest();
		THOR_ManageComponentRequestController.saveOrSubmitRequests('submit', sparePartRequests);
		Test.stopTest();

		List<Spare_Part_Request__c> updatedSPartRequests = [SELECT Id, Request_Status__c FROM Spare_Part_Request__c];
		for (Spare_Part_Request__c updatedSPartRequest : updatedSPartRequests) {
			System.assertEquals('Draft', updatedSPartRequest.Request_Status__c);
		}
	}

	@isTest
	static void testSaveOrSubmitRequestsSubmitNoResponsiblePerson() {
		Order__c orderTest = [
			SELECT Id, Functional_Location__c, Equipment__c
			FROM Order__c
			WHERE Equipment__c = NULL
			LIMIT 1
		];

		Spare_Part__c sparePartTest = new Spare_Part__c(Name = 'sparePartTest', Material_Number__c = 'MaterialTest');
		insert sparePartTest;

		Order_Operation__c orderOperationTest = new Order_Operation__c(
			Operation_Text__c = 'orderOpTest',
			Order__c = orderTest.Id
		);
		insert orderOperationTest;

		List<Spare_Part_Request__c> sparePartRequests = new List<Spare_Part_Request__c>();
		for (Integer i = 0; i < 5; i++) {
			sparePartRequests.add(
				new Spare_Part_Request__c(
					Order__c = orderTest.Id,
					Item_No__c = '123' + i,
					Spare_Part__c = sparePartTest.Id,
					Request_Status__c = 'Draft',
					Order_Operation__c = orderOperationTest.Id
				)
			);
		}
		insert sparePartRequests;

		Test.startTest();
		try {
			THOR_ManageComponentRequestController.saveOrSubmitRequests('submit', sparePartRequests);
		} catch (Exception e) {
			System.assertEquals(
				'System.AuraHandledException',
				e.getTypeName(),
				'An Aura Exception should have be thrown'
			);
		}
		Test.stopTest();
	}

	@isTest
	static void testGetOrderOperations() {
		Order__c order = [
			SELECT Id, Functional_Location__c, Equipment__c
			FROM Order__c
			WHERE Equipment__c = NULL
			LIMIT 1
		];
        //system.debug('Og size '+ [SELECT Id,Operation_Text__c,SubOperation__c FROM Order_Operation__c WHERE Order__c = :order.id].size());
        integer OrderOperationOgSize = [SELECT Id,Operation_Text__c,SubOperation__c FROM Order_Operation__c WHERE Order__c = :order.id].size();
//system.debug('Operation_Text__c ' + [SELECT Id,Operation_Text__c,SubOperation__c FROM Order_Operation__c WHERE Order__c = :order.id][0].Operation_Text__c);
		List<Order_Operation__c> orderOperations = new List<Order_Operation__c>();
		for (Integer i = 0; i < 5; i++) {
			orderOperations.add(
				new Order_Operation__c(
					Order__c = order.Id,
					Operation_Text__c = 'OPERATION' + i,
					SubOperation__c = 'SubOperation' + i,
					Operation_Shot_Text__c = 'Short Text ' + i
				)
			);
		}

		insert orderOperations;

		List<Order_Operation__c> retrievedOrderOperations = new List<Order_Operation__c>();
		Test.startTest();
		retrievedOrderOperations = THOR_ManageComponentRequestController.getOrderOperations(order.Id);
		Test.stopTest();

		System.assertEquals(
			orderOperations.size()+OrderOperationOgSize,
			retrievedOrderOperations.size(),
			'All Order Operations should have been retrieved'
		);
	}

	@isTest
	static void testSaveCartTimeout() {
		Order__c orderTest = [
			SELECT Id, Functional_Location__c, Equipment__c
			FROM Order__c
			WHERE Equipment__c = NULL
			LIMIT 1
		];

		Spare_Part__c sparePartTest = new Spare_Part__c(Name = 'sparePartTest', Material_Number__c = 'MaterialTest');
		insert sparePartTest;

		Order_Operation__c orderOperationTest = new Order_Operation__c(
			Operation_Text__c = 'orderOpTest',
			Order__c = orderTest.Id
		);
		insert orderOperationTest;

		List<Spare_Part_Request__c> sparePartRequests = new List<Spare_Part_Request__c>();
		for (Integer i = 0; i < 5; i++) {
			sparePartRequests.add(
				new Spare_Part_Request__c(
					Order__c = orderTest.Id,
					Item_No__c = '123' + i,
					Spare_Part__c = sparePartTest.Id,
					Request_Status__c = 'Pending for Approval',
					Integration_Status__c = 'In Progress',
					Order_Operation__c = orderOperationTest.Id
				)
			);
		}
		insert sparePartRequests;

		Test.startTest();
		List<Spare_Part_Request__c> retrievedSpareParts = THOR_ManageComponentRequestController.saveCartTimeout(
			orderTest.Id
		);
		Test.stopTest();

		System.assertEquals(
			sparePartRequests.size(),
			retrievedSpareParts.size(),
			'All Spare Parts have been save as draft'
		);
	}
}