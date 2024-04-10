/**
 * @author Oktana
 */
public with sharing class SparePartRequestHandler {
	public static void updateOrderOrderOperationField(Map<Id, Spare_Part_Request__c> sparePartRequests) {
		// List<Spare_Part_Request__c> pendingRequests = new List<Spare_Part_Request__c>();
		// for (Spare_Part_Request__c spr : sparePartRequests.values()) {
		//     if (spr.Request_Status__c == 'Pending for Approval') {
		//         pendingRequests.add(spr);
		//     }
		// }

		Map<Id, Order__c> ordersMap = new Map<Id, Order__c>();
		Map<Id, Order_Operation__c> orderOperationsMap = new Map<Id, Order_Operation__c>();

		List<Id> orderIds = new List<Id>();
		List<Id> orderOperationsIds = new List<Id>();
		for (Spare_Part_Request__c sparePartRequest : sparePartRequests.values()) {
			orderIds.add(sparePartRequest.Order__c);
			orderOperationsIds.add(sparePartRequest.Order_Operation__c);
		}

		if (Schema.sObjectType.Order__c.isAccessible()) {
			ordersMap = new Map<Id, Order__c>([SELECT Id, Name FROM Order__c WHERE Id IN :orderIds]);
		}

		System.debug('orderOperationsIds: ' + orderOperationsIds);
		if (Schema.sObjectType.Order_Operation__c.isAccessible()) {
			orderOperationsMap = new Map<Id, Order_Operation__c>([SELECT Id, Operation_Text__c FROM Order_Operation__c WHERE Id IN :orderOperationsIds]);
		}

		for (Spare_Part_Request__c sparePartRequest : sparePartRequests.values()) {
			sparePartRequest.OrderOrderOperation__c =
				ordersMap.get(sparePartRequest.Order__c)?.Name +
				orderOperationsMap.get(sparePartRequest.Order_Operation__c)?.Operation_Text__c +
				sparePartRequest.Item_No__c; //+
			//sparePartsMap.get(sparePartRequest.Spare_Part__c).Name;
			System.debug('sparePartRequest.OrderOrderOperation__c: ' + sparePartRequest.OrderOrderOperation__c);
		}
	}
	public static void updateItemNumberField(List<Spare_Part_Request__c> sparePartRequests) {
		Integer itemNoValueStep = 10;
		String orderId = sparePartRequests[0].Order__c;
		List<Spare_Part_Request__c> maxItemNoSparePartRequest = [
			SELECT Id, Item_No_Value__c
			FROM Spare_Part_Request__c
			WHERE Order__c = :orderId
			WITH SECURITY_ENFORCED
			ORDER BY Item_No_Value__c DESC NULLS LAST
			LIMIT 1
		];

		Integer maxItemNoValue = 0;
		if (maxItemNoSparePartRequest.size() > 0 && maxItemNoSparePartRequest[0].Item_No_Value__c != null) {
			maxItemNoValue = Integer.valueOf(maxItemNoSparePartRequest[0].Item_No_Value__c);
		}

		for (Spare_Part_Request__c sparePartRequest : sparePartRequests) {
			maxItemNoValue += itemNoValueStep;
			sparePartRequest.Item_No__c = String.valueOf(maxItemNoValue).leftPad(4, '0');
			sparePartRequest.Item_No_Value__c = maxItemNoValue;
		}
	}
}