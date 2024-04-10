@isTest
public with sharing class THOR_OrderRelCmpReqController_Test{
	@isTest
	public static void givenOrderIdWhenCalledRetrieveComponentsRequestsExpectedArrayOfDTOS(){
		Profile userProfile = [SELECT Id FROM Profile WHERE Name='Read Only'];
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

		Order__c order = new Order__c();
		order.Description__c = 'Order Test';
		order.Requested_Date__c = Date.today();
		insert order;

		Spare_Part__c sp = new Spare_Part__c();
		sp.Name = 'SP Test';
		sp.Material_Number__c = '238';
		sp.Material_Description__c = 'Desc 238';
		sp.Base_Unit__c = 'PC';
		insert sp;

		Spare_Part_Stock__c stock = new Spare_Part_Stock__c();
		stock.Name = 'Stock Test';
		stock.Available_Quantity__c = 14;
		stock.Spare_Part__c = sp.Id;
		insert stock;

		Order_Operation__c orderOperation = new Order_Operation__c(
            Operation_Text__c = 'orderOpTest',
            Order__c = order.Id
        );
        insert orderOperation;

		Spare_Part_Request__c request = New Spare_Part_Request__c();
		request.Name = 'Request Test';
		request.Order__c = order.Id;
		request.Request_Material_Quantity__c = 180;
		request.Request_Status__c = 'Pending for Approval';
		request.Spare_Part_Stock__c = stock.Id;
		request.Spare_Part__c = sp.Id;
		request.Order_Operation__c = orderOperation.Id;
		insert request;


		List<THOR_ObjectCardDTO> dtos = THOR_OrderRelCmpReqController.retrieveComponentsRequests(order.Id);
		System.assert(dtos.size() == 1, 'Controller did not returned elements');
		System.runAs(readOnlyUser) {
			try{
				List<THOR_ObjectCardDTO> dtosFail = THOR_OrderRelCmpReqController.retrieveComponentsRequests(order.Id);
			}catch(Exception e){
				System.assertEquals(
					'System.AuraHandledException',
					e.getTypeName(),
					'Aura Exception should be thrown when user access is restricted or bad query'
				);
			}
		}
	}
    
    @isTest
    static void testGetCartCount() {
        Order__c order = new Order__c();
		order.Description__c = 'Order Test';
		order.Requested_Date__c = Date.today();
		insert order;

		Spare_Part__c sp = new Spare_Part__c();
		sp.Name = 'SP Test';
		sp.Material_Number__c = '238';
		sp.Material_Description__c = 'Desc 238';
		sp.Base_Unit__c = 'PC';
		insert sp;

		Spare_Part_Stock__c stock = new Spare_Part_Stock__c();
		stock.Name = 'Stock Test';
		stock.Available_Quantity__c = 14;
		stock.Spare_Part__c = sp.Id;
		insert stock;

		Order_Operation__c orderOperation = new Order_Operation__c(
            Operation_Text__c = 'orderOpTest',
            Order__c = order.Id
        );
        insert orderOperation;

		Spare_Part_Request__c request = New Spare_Part_Request__c();
		request.Name = 'Request Test';
		request.Order__c = order.Id;
		request.Request_Material_Quantity__c = 180;
		request.Request_Status__c = 'Draft';
		request.Spare_Part_Stock__c = stock.Id;
		request.Spare_Part__c = sp.Id;
		request.Order_Operation__c = orderOperation.Id;
		insert request;
        
        Integer cartCount;
        Test.startTest();
        cartCount = THOR_OrderRelCmpReqController.getCartCount(order.Id);
        Test.stopTest();
        
        System.assertEquals(1, cartCount);
    }
    
    @isTest
    static void testGetCartCountException() {
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='Read Only'];
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
        
        Order__c order = new Order__c();
		order.Description__c = 'Order Test';
		order.Requested_Date__c = Date.today();
		insert order;

		Spare_Part__c sp = new Spare_Part__c();
		sp.Name = 'SP Test';
		sp.Material_Number__c = '238';
		sp.Material_Description__c = 'Desc 238';
		sp.Base_Unit__c = 'PC';
		insert sp;

		Spare_Part_Stock__c stock = new Spare_Part_Stock__c();
		stock.Name = 'Stock Test';
		stock.Available_Quantity__c = 14;
		stock.Spare_Part__c = sp.Id;
		insert stock;

		Order_Operation__c orderOperation = new Order_Operation__c(
            Operation_Text__c = 'orderOpTest',
            Order__c = order.Id
        );
        insert orderOperation;

		Spare_Part_Request__c request = New Spare_Part_Request__c();
		request.Name = 'Request Test';
		request.Order__c = order.Id;
		request.Request_Material_Quantity__c = 180;
		request.Request_Status__c = 'Draft';
		request.Spare_Part_Stock__c = stock.Id;
		request.Spare_Part__c = sp.Id;
		request.Order_Operation__c = orderOperation.Id;
		insert request;
        
        Integer cartCount;
        Test.startTest();
        System.runAs(readOnlyUser) {
            try {
                cartCount = THOR_OrderRelCmpReqController.getCartCount(orderOperation.Id);
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
}