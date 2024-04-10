public with sharing class EMOC_OrderListController {
	@AuraEnabled
	public static Map<String, Object> getOrdersByFilter(String emocId) {
        system.debug('emocId: '+ emocId);
        List<Order__c> orderList = [SELECT Id,
                                        Name,
                                        Order_Status__c,
                                        Order_Type__c,
                                        Description__c
                                        FROM Order__c 
                                    	WHERE E_MOC_Application_No__c = :emocId LIMIT 1];
        
        List<E_MOC_Application__c> emoc = [SELECT Id, Notification__c FROM E_MOC_Application__c WHERE Id = :emocId LIMIT 1];

        Map<String, Object> returnList = new Map<String, Object>();
        List<Map<String, String>> orderListMsp = new List<Map<String, String>>();
        
        if (emoc[0].Notification__c == null) {
			returnList.put('Notification__c', '');
        } else {
            returnList.put('Notification__c', emoc[0].Notification__c);
        }
        
        for(Order__c obj: orderList) {
            Map<String, String> objList = new Map<String, String>();
            objList.put('Id',obj.Id);
            objList.put('Name',obj.Name != null ? obj.Name : '');
			objList.put('Order_Status__c',obj.Order_Status__c != null ? obj.Order_Status__c : '');
            objList.put('Order_Type__c',obj.Order_Type__c != null ? obj.Order_Type__c : '');
            objList.put('Description__c',obj.Description__c != null ? obj.Description__c : '');
            orderListMsp.add(objList);
            returnList.put('orderList', orderListMsp);
        }
        return returnList;
	}
}