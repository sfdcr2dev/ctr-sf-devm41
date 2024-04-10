/**
 * @author Sebastian Bucalo
 * @description helper for SetNewOrderStatus Trigger
 */
public with sharing class SetNewOrderStatusHelper{
	/**
	 * @description creates a master map status and a status set
	 * @param createdOrders
	 */
	public static void setNewOrderStatus(List<Order__c> createdOrders){
		integer listLenght = createdOrders.size();

		List<Id> ordersId = new List<Id>();
		List<Master_Map_Set__c> mmSets = new List<Master_Map_Set__c>();


		for (integer i = 0; i < listLenght; i ++){
			ordersId.add(createdOrders[i].Id);
			Master_Map_Set__c mmSet = new Master_Map_Set__c();
			mmSets.add(mmSet);
		}
		if (Schema.sObjectType.Master_Map_Set__c.isCreateable()){
			insert mmSets;
		}

		List<Order__c> orders = new List<Order__c>();
		if (Schema.sObjectType.Order__c.isAccessible()){
			orders = [Select id, Description__c, Order_Status_Set__c
			          From Order__c
			          where Id In :ordersId];
		}

		List<Master_Map__c> statusList = new List<Master_Map__c>();
		for (integer i = 0; i < listLenght; i ++){

			Master_Map__c mm = new Master_Map__c();
			mm.Name = 'CRTD';
			mm.Master_Map_Set__c = mmSets[i].Id;
			statusList.add(mm);

			orders[i].Order_Status_Set__c = mmSets[i].Id;
		}

		if (Schema.sObjectType.Order__c.isUpdateable()){
			update orders;
		}
		if (Schema.sObjectType.Master_Map_Set__c.isUpdateable()){
			update mmSets;
		}

        if (Schema.sObjectType.Master_Map__c.isCreateable()){
            insert statusList;
        }
	}
}