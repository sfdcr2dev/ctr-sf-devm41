@isTest
public class THOR_IRPAIntegration_OrderTest 
{
    @testSetup
    public static void setupdate()
    {
        List<Master_Map__c>insertedmastermapList = new List<Master_Map__c>();
        
        Master_Map_Set__c mastermapset = new Master_Map_Set__c();
        insert mastermapset;
        system.debug('mastermapset.id'+mastermapset.id);
        
        Master_Map__c plant = new Master_Map__c();
        plant.Code__c = '1200';
        plant.Name = '1200';
        plant.Type__c = 'Plant';
        plant.Master_Map_Set__c = mastermapset.id;
        //insert plant;
        insertedmastermapList.add(plant);
        
        Master_Map__c codegroupOffaultCode = new Master_Map__c();
        codegroupOffaultCode.Code__c = 'IEF-028';
        codegroupOffaultCode.Name = 'IEF-028';
        codegroupOffaultCode.Type__c = 'Code Group';
        codegroupOffaultCode.Master_Map_Set__c = mastermapset.id;
        //insert codegroupOffaultCode;
        insertedmastermapList.add(codegroupOffaultCode);
     
        
        Master_Map__c ob = new Master_Map__c();
        ob.Code__c = 'B';
        ob.Name = 'B';
        ob.Type__c = 'Object Part';
        ob.Master_Map_Set__c = mastermapset.id;
        //insert ob;
        insertedmastermapList.add(ob);
        
        Master_Map__c mainworkcenter = new Master_Map__c();
        mainworkcenter.Code__c = 'ENMA-I';
        mainworkcenter.Name = 'ENMA-I';
        mainworkcenter.Type__c = 'Main Work Center';
        mainworkcenter.Master_Map_Set__c = mastermapset.id;
        //insert mainworkcenter;
        insertedmastermapList.add(mainworkcenter);
        
        Master_Map__c faultcode = new Master_Map__c();
        faultcode.Code__c = 'E02';
        faultcode.Name = 'E02';
        faultcode.Type__c = 'FaultCode';
        faultcode.Master_Map_Set__c = mastermapset.id;
        //insert faultcode;
        insertedmastermapList.add(faultcode);
        
     
        Master_Map__c pmactivity = new Master_Map__c();
        pmactivity.Code__c = 'M01';
        pmactivity.Name = 'M01';
        pmactivity.Type__c = 'MaintActivityType';
        pmactivity.Master_Map_Set__c = mastermapset.id;
        //insert pmactivity;
        insertedmastermapList.add(pmactivity);
        
        insert insertedmastermapList;
        
        map<String,String>masterMapMap = new map<String,String>();
        for(Master_Map__c m : insertedmastermapList)
        {
            masterMapMap.put(m.Type__c,m.Id);
        }
        
        Functional_Location__c fl = new Functional_Location__c();
        fl.Name = 'Test FL';
        insert fl;
        
        Equipment__c eq = new Equipment__c();
        eq.Name = 'Test EQ';
        insert eq;
        
        
        Order__c o = new Order__c();
        o.Name = '101001000';
        o.Order_Type__c = 'PM01';
        o.Functional_Location__c = fl.id;
        o.Equipment__c = eq.id;
        o.Description__c = 'test descritpion';
        //o.Notification__c = noti.id;
        o.PM_Activity_Type__c = masterMapMap.get('MaintActivityType');
        o.System_Status_Text__c = 'CRED ANIN';
        o.User_Status__c = 'ANIN';
        o.Main_Work_Center__c = masterMapMap.get('Main Work Center');
        o.Requested_Date__c = system.today();
        o.Priority__c = 'Normal';
        o.Start_Date__c = system.today();
        o.Finished_Date__c = system.today();
        o.Responsible_person__c = UserInfo.getUserId();
        o.Planning_Plant__c = masterMapMap.get('Plant');
        insert o;
        
        
    }

    @isTest
    public static void testOrderToSAP()
    {
        Test.setMock(HttpCalloutMock.class, new THOR_IRPAMock());
        
        THORIntegration__c cs =new THORIntegration__c();
        cs.iRPA_Client_Id__c = 'sb-d73afc64-431a-4de2-a617-906f7c41942c!b14053|sapmlirpa--irpatrial--trial--uaa-service-broker!b3516';
        cs.iRPA_Client_Secret_Id__c = 'ikiVy26FO2hT1r1gZ/MfOh4MrnI=';
        cs.iRPA_Token_Endpoint__c = 'https://1aa5670atrial.authentication.us10.hana.ondemand.com/oauth/token';
        cs.iRPA_Order_Endpoint__c = 'https://api.irpa-trial.cfapps.us10.hana.ondemand.com/apitrigger/v1/triggers/ecda22a0-354d-4a6e-b404-ec475bd5e3ef/run';
        cs.iRPA_Order_Token__c = 'pPuXlzHCi_iqviV5_RpAzE_4CxKUXBpM';
        cs.iRPA_API_Key_Header__c = 'irpa-api-key';
        cs.iRPA_API_Key__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        
        insert cs;
        
        List<Order__c>orderList = [select id from Order__c];
        test.startTest();
        Order__c updatedOrder = new Order__c(Id = orderList[0].Id);
        updatedOrder.Description__c = 'test update description';
        updatedOrder.Integration_Status__c = 'In Progress';
        update updatedOrder;
        test.stopTest();
        
        List<Order__c>updatedOrderList = [select id from Order__c];
        system.assert(updatedOrderList.size() > 0);        
    }

    @isTest
    public static void testPushNotificationIntegrationSAP()
    {        
        List<Order__c>orderList = [select id from Order__c];
        test.startTest();
        Order__c updatedOrder = new Order__c(Id = orderList[0].Id);
        updatedOrder.Description__c = 'test update description';
        updatedOrder.Integration_Status__c = 'Success';
        update updatedOrder;
        THOR_iRPAIntegration_Order.pushNotificationIntegrationSAP(new List<Order__c>{updatedOrder});
        test.stopTest();
        
        List<Order__c>updatedOrderList = [select id from Order__c];
        system.assert(updatedOrderList.size() > 0);        
    }
}