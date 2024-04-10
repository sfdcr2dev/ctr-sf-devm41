/**
 * @author Sebastian Bucalo
 * @description helper for SetWCToNotification Trigger
 */
public with sharing class SetLatestWCHelper{
	/**
	 * @description updates the notification and order with the newest Work_Clearance__c object
	 * @param wcList
	 */
	public static void updateNotificationAndOrder(List<Work_Clearance__c> newWCs, List<Work_Clearance__c> oldWCs){

		if (newWCs.size() > 0){
			Work_Clearance__c newWC = newWCs[0];
			Work_Clearance__c oldWC = oldWCs[0];
			updateNotification(newWC, oldWC);
			updateOrder(newWC, oldWC);
		}
	}
        
	public static void updateNotificationAndOrder(List<Work_Clearance__c> newWCs){

		if (newWCs.size() > 0){
			Work_Clearance__c newWC = newWCs[0];
			updateNotification(newWC);
			updateOrder(newWC);
		}
	}
    
	private static void updateNotification(Work_Clearance__c newWC){

		boolean updNotification = false;
        
		List<Notification__c> newNotifications = new List<Notification__c>();

		if (Schema.sObjectType.Notification__c.isAccessible()){
			newNotifications = [Select id, Name, Work_Clearance__r.id, Work_Clearance__r.Name, Work_Clearance__r.createdDate
			                 	From Notification__c
			                 	Where id = :newWC.Notification__c];
		}

		if (newNotifications.size() > 0){

			Notification__c notification = newNotifications[0];

			if (notification.Work_Clearance__r.id == null || newWC.createdDate > notification.Work_Clearance__r.createdDate){
				notification.Work_Clearance__c = newWC.id;


				updNotification = true;
			}

			if (updNotification && Schema.sObjectType.Notification__c.isUpdateable()){
				update notification;
			}
		}
	}

	private static void updateOrder(Work_Clearance__c newWC){

		boolean updOrder = false;

		List<Order__c> newOrders = new List<Order__c>();

		if (Schema.sObjectType.Order__c.isAccessible()){
			newOrders = [Select id, Name, Work_Clearance__r.id, Work_Clearance__r.Name, Work_Clearance__r.createdDate
						From Order__c
						Where id = :newWC.Order__c];
		}

		if (newOrders.size() > 0){

			Order__c order = newOrders[0];

			if (order.Work_Clearance__r.id == null || newWC.createdDate > order.Work_Clearance__r.createdDate){
				order.Work_Clearance__c = newWC.id;

				updOrder = true;
			}

			if (updOrder && Schema.sObjectType.Order__c.isUpdateable()){
				update order;
			}
		}
	}

	/**
	 * @description updates the notification with the newest Work_Clearance__c object
	 * @param wc
	 */
	private static void updateNotification(Work_Clearance__c newWC, Work_Clearance__c oldWC){

		boolean updNotification = false;
        
		List<Notification__c> newNotifications = new List<Notification__c>();
		List<Notification__c> oldNotifications = new List<Notification__c>();

		if (Schema.sObjectType.Notification__c.isAccessible()){
			if(newWC.Notification__c != null) {
				newNotifications = [Select id, Name, Work_Clearance__r.id, Work_Clearance__r.Name, Work_Clearance__r.createdDate
			                 		From Notification__c
			                 		Where id = :newWC.Notification__c];
			} 
			else {
				oldNotifications = [Select id, Name, Work_Clearance__r.id, Work_Clearance__r.Name, Work_Clearance__r.createdDate
			                 		From Notification__c
			                 		Where Work_Clearance__r.id = :oldWC.Id];
			}
		}

		if (newNotifications.size() > 0){

			Notification__c notification = newNotifications[0];

			if (notification.Work_Clearance__r.id == null || newWC.createdDate > notification.Work_Clearance__r.createdDate){
				notification.Work_Clearance__c = newWC.id;


				updNotification = true;
			}

			if (updNotification && Schema.sObjectType.Notification__c.isUpdateable()){
				update notification;
			}
		}
		else {
			List<Notification__c> notifications = new List<Notification__c>();
			for(Notification__c notification : oldNotifications) {
				notification.Work_Clearance__c = null;
				notifications.add(notification);
			}
			update notifications;
		}
	}

	/**
	 * @description updates the object with the newest Work_Clearance__c object
	 * @param wc
	 */
    
	private static void updateOrder(Work_Clearance__c newWC, Work_Clearance__c oldWC){

		boolean updOrder = false;

		List<Order__c> newOrders = new List<Order__c>();
		List<Order__c> oldOrders = new List<Order__c>();

		if (Schema.sObjectType.Order__c.isAccessible()){
			if(newWC.Order__C != null) {
				newOrders = [Select id, Name, Work_Clearance__r.id, Work_Clearance__r.Name, Work_Clearance__r.createdDate
							 From Order__c
							 Where id = :newWC.Order__c];
			}
			else {
				oldOrders = [Select id, Name, Work_Clearance__r.id, Work_Clearance__r.Name, Work_Clearance__r.createdDate
							 From Order__c
							 Where Work_Clearance__r.id = :oldWC.Id];
			}
		}

		if (newOrders.size() > 0){

			Order__c order = newOrders[0];

			if (order.Work_Clearance__r.id == null || newWC.createdDate > order.Work_Clearance__r.createdDate){
				order.Work_Clearance__c = newWC.id;

				updOrder = true;
			}

			if (updOrder && Schema.sObjectType.Order__c.isUpdateable()){
				update order;
			}
		}
		else {
			if (oldOrders.size() > 0) {
				List<Order__c> orders = new List<Order__c>();
				for(Order__c order : oldOrders) {
					order.Work_Clearance__c = null;
					orders.add(order);
				}
				
				update orders;
			}
		}
	}   
}