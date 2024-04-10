public with sharing class THOR_ManageComponentRequestController {
	@AuraEnabled
	public static List<Spare_Part_Request__c> getCart(Id orderId, String requesterStatus) {
		return [
			SELECT
				Id,
				Order__c,
				Order__r.Order_Number__c,
				Operation__c,
				Order_Operation__c,
				Order_Operation__r.Operation_Shot_Text__c,
				Order_Operation__r.Operation_Text__c,
				Spare_Part__r.Material_Number__c,
				Spare_Part__r.Material_Description__c,
				Available_Quantity__c,
				UM__c,
				Item_No__c,
				Request_Material_Quantity__c,
				Request_Status__c,
				Integration_Status__c,
				Integration_Message__c
			FROM Spare_Part_Request__c
			WHERE Order__c = :orderId AND Request_Status__c = :requesterStatus AND Deleted__c = FALSE
			ORDER BY Item_No__c ASC
		];
	}

	@AuraEnabled
	public static List<Spare_Part_Request__c> saveCartTimeout(String orderId) {
		List<Spare_Part_Request__c> result = new List<Spare_Part_Request__c>();
		for (Spare_Part_Request__c spr : [
			SELECT Id
			FROM Spare_Part_Request__c
			WHERE
				Order__c = :orderId
				AND Order__c != NULL
				AND Request_Status__c = 'Pending for Approval'
				AND (Integration_Status__c = 'In Progress'
				OR Integration_Status__c = NULL)
		]) {
			result.add(
				new Spare_Part_Request__c(
					Id = spr.Id,
					Request_Status__c = 'Draft',
					Integration_Status__c = 'Failed',
					Integration_Message__c = System.Label.Please_contact_System_Administer
				)
			);
		}
		if (result.size() > 0) {
			update result;
		}
		return result;
	}

	@AuraEnabled
	public static Boolean hasResponsiblePerson(Id orderId) {
		return [
				SELECT Id, Responsible_person__c, Responsible_person_PISUser__c
				FROM Order__c
				WHERE Id = :orderId
				LIMIT 1
			]
			?.Responsible_person_PISUser__c != null
			? true
			: false;
	}

	@AuraEnabled
	public static void deleteRequestFromCart(Id requestId) {
		Spare_Part_Request__c request = [SELECT Id FROM Spare_Part_Request__c WHERE Id = :requestId LIMIT 1];
		request.Deleted__c = true;
		update request;
	}

	@AuraEnabled
	public static void saveOrSubmitRequests(String action, List<Spare_Part_Request__c> requests) {
		if (action == 'save') {
			List<Spare_Part_Request__c> updateRequests = new List<Spare_Part_Request__c>();
			for (Spare_Part_Request__c request : requests) {
				if (request.Request_Status__c == 'Draft') {
					updateRequests.add(request);
				}
			}
			update updateRequests;
		} else if (action == 'submit') {
			String orderId = requests[0].Order__c;
			for (Spare_Part_Request__c request : requests) {
				if (request.Request_Status__c == 'Draft') {
					request.IC__c = 'L';
					request.Integration_Status__c = 'In Progress';
					// request.Request_Status__c = 'Pending for Approval';
				}
			}
			Order__c order = [
				SELECT Id, User_Status__c, Order_Status__c, System_Status_Text__c, Responsible_person__c, Responsible_person_PISUser__c
				FROM Order__c
				WHERE Id = :orderId
			];
			order.User_Status__c = order.User_Status__c?.replace('INIL', 'INIT');
			order.System_Status_Text__c = 'REL';
			if (order.Responsible_person_PISUser__c == null) {
				throw new AuraHandledException(
					'You must fill out the responsible person field on this order before submitting.'
				);
			} else {
				order.Order_Status__c = 'In Progress';
			}
			update order;
			update requests;
		}
	}

	@AuraEnabled
	public static List<Order_Operation__c> getOrderOperations(String orderId) {
		return [
			SELECT
				Id,
				Operation_Shot_Text__c,
				Operation_Text__c,
				Operation__c,
				Order__c,
				OrderOperation__c,
				Name,
				Plant__c,
				SubOperation__c,
				Control_Key__c
			FROM Order_Operation__c
			WHERE Order__c = :orderId
		];
	}
}