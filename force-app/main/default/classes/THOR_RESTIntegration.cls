@RestResource(urlMapping='/Order/*')
global class THOR_RESTIntegration 
{
    @HttpPost
    global static String doPost(String orderid,String orderno) 
    {
        Order__c updatedOrder = new Order__c(id = orderid);
        updatedOrder.Name = orderno;
        updatedOrder.Order_Number__c = orderno;
        update updatedOrder;
        system.debug('success');
        return 'success';
    }

}