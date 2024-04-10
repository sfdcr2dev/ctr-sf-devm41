@isTest
public class THOR_BApiOrderHelperTest 
{

    @isTest
    public static void executeTest()
    {
        Order__c o = new Order__c();
        o.Name = 'Test';
        insert o;
        
        String jsonSTR = '{     "Order__c": {         "Id": "'+o.id+'",         "Name": "Success",         "System_Status_Text__c": "Success",         "User_Status__c": "Success",         "Requested_Date__c": "2021-11-03",         "Integration_Status__c": "Success",         "Integration_Message__c": "test call"     },     "uuid": "2304a315-9df9-42c8-99a6-ca656ad759cb" }';
        Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        
        Test.startTest(); 
        THOR_BApiOrderHelper.execute('order_endpoint',response_value);
        Test.stopTest();
        
        List<Order__c> upsertedOrder = [select id,System_Status_Text__c from Order__c];
        
        system.assert(upsertedOrder[0].System_Status_Text__c == 'Success');
    }
    
    @isTest
    public static void executeTest_Error()
    {
        Order__c o = new Order__c();
        o.Name = 'Test';
        insert o;
        
        String jsonSTR = '{     "Order__c": {         "Id": "'+o.id+'",         "Name": "Success",         "System_Status_Text__c": "Success",         "User_Status__c": "Success",         "Requested_Date__c": "2021-1103",         "Integration_Status__c": "Success",         "Integration_Message__c": "test call"     },     "uuid": "2304a315-9df9-42c8-99a6-ca656ad759cb" }';
        Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        
        Test.startTest(); 
        THOR_BApiOrderHelper.execute('order_endpoint',response_value);
        Test.stopTest();
        
        List<Application_Log__c> logList = [select id from Application_Log__c];
        
        system.assert(logList.size() > 0);
    }
}