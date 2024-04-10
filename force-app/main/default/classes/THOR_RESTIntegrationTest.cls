@isTest
public class THOR_RESTIntegrationTest 
{
    @testSetup
    public static void setupdata()
    {
        Order__c insertedOrder = new Order__c();
        insertedOrder.Name = 'dummy';
        insertedOrder.Order_Number__c = 'dummy';
        insert insertedOrder;
    }
    
	@isTest
    public static void testPostOrder()
    {
        Order__c o = [select id from Order__c LIMIT 1];
        
        Test.startTest();
        THOR_RESTIntegration.doPost(o.id, '123456789');
        Test.stopTest();
        
        Order__c updatedOrder = [select id,Name from Order__c LIMIT 1];
        
        System.assert(updatedOrder.Name == '123456789');
    }
}