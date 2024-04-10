@isTest
public with sharing class SetNewOrderStatusHelper_Test{
	@isTest
	static void insertOrderExpectedNewOrder(){
		Order__c order = new Order__c();
		insert order;

		List<Order__c> orders = [Select Id, Order_Status__c
		                         From Order__c
		                         where Order_Status__c = 'New'];

		System.assert(orders.size() == 1, 'orders.size() <> 1');
	}
}