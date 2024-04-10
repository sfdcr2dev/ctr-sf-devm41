@isTest
public class THOR_BApiComponentHelperTest 
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
        
        Master_Map__c damage = new Master_Map__c();
        damage.Code__c = 'D';
        damage.Name = 'D';
        damage.Type__c = 'Damage';
        damage.Master_Map_Set__c = mastermapset.id;
        //insert damage;
        insertedmastermapList.add(damage);
        
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
        
        Master_Map__c cause = new Master_Map__c();
        cause.Code__c = 'C02';
        cause.Name = 'C02';
        cause.Type__c = 'Cause';
        cause.Master_Map_Set__c = mastermapset.id;
        //insert cause;
        insertedmastermapList.add(cause);
        
        Master_Map__c activity = new Master_Map__c();
        activity.Code__c = 'A02';
        activity.Name = 'A02';
        activity.Type__c = 'Activity';
        activity.Master_Map_Set__c = mastermapset.id;
        //insert activity;
        insertedmastermapList.add(activity);
        
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
        insert o;
        
        Order_Operation__c op = new Order_Operation__c();
        op.Order__c = o.Id;
        op.OrderOperation__c = o.Name + '0010';
        insert op;
        
        Spare_Part__c sp = new Spare_Part__c();
        sp.Name = '000001';
        sp.Material_Number__c = '000001';
        insert sp;
        
        Spare_Part_Request__c spr = new Spare_Part_Request__c();
        spr.Order__c = o.id;
        spr.Order_Operation__c = op.id;
        spr.Spare_Part__c = sp.id;
        spr.Request_Material_Quantity__c = 10.0;
        spr.Item_No__c = '0010';
        spr.Request_Status__c = 'Draft';
        insert spr;
        
        
        
    }
    

    @isTest
    public static void executeTest()
    {
        Spare_Part_Request__c sp = [select id, Order__c from Spare_Part_Request__c limit 1];
        
        //String jsonSTR = '{     "Spare_Part_Request__c": [{         "Id": "'+sp.id+'",         "Integration_Status__c": "Success",         "Integration_Message__c": "test call"     }     ],     "jobUid": "2304a315-9df9-42c8-99a6-ca656ad759cb" }';
        String jsonSTR = '{     "sparePartRequests": [{         "Id": "'+sp.id+'",        "Integration_Status__c": "Success",         "Integration_Message__c": "test call"     }     ], "orderId": "'+sp.Order__c+'",     "uuid": "2304a315-9df9-42c8-99a6-ca656ad759cb" }';
        Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR); 
        
        Test.startTest(); 
        THOR_BApiComponentHelper.execute('component_endpoint',response_value);
        Test.stopTest();
        
        List<Application_Log__c> log = [select id from Application_Log__c];
        
        system.assert(log.size() > 0);
    }
    
    @isTest
    public static void executeTest_Error()
    {
        Spare_Part_Request__c sp = [select id from Spare_Part_Request__c limit 1];
        String jsonSTR = '{     "Spare_Part_Request__c": [{         "Id": "'+sp.id+'tests",         "Integration_Status__c": "SuccessSS",         "Integration_Message__c": "test call"     }     ],     "uuid": "2304a315-9df9-42c8-99a6-ca656ad759cb" }';
        Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        
        Test.startTest(); 
        THOR_BApiComponentHelper.execute('component_endpoint',response_value);
        Test.stopTest();
        
        List<Spare_Part_Request__c> upsertedSP = [select id,Integration_Status__c from Spare_Part_Request__c];
        
        system.assert(upsertedSP[0].Integration_Status__c != 'Success');
    }
}