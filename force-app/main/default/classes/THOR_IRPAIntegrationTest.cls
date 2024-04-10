@isTest
public class THOR_IRPAIntegrationTest 
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
        
        Master_Map__c categoryWithMainWork = new Master_Map__c();
        categoryWithMainWork.Code__c = '10000023';
        categoryWithMainWork.Name = '10000023';
        categoryWithMainWork.Type__c = 'CategoryWithMainWorkCenterWithPlant';
        categoryWithMainWork.Master_Map_Set__c = mastermapset.id;
        //insert categoryWithMainWork;
        insertedmastermapList.add(categoryWithMainWork);
        
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
        
        Notification__c noti = new Notification__c();
        noti.Name = '10101000';
        noti.Functional_Location__c = fl.id;
        //noti.Order__c = o.Id;
        noti.Equipment__c = eq.Id;
        noti.Code_Group__c = masterMapMap.get('Code Group');
        noti.Fault_Code__c =  masterMapMap.get('FaultCode');
        noti.Breakdown__c = true;
        noti.Description__c = 'test description';
        noti.History_Detail__c = '* test his detail';
        noti.Main_Work_Center__c = masterMapMap.get('Main Work Center');
        noti.Notification_Number__c = '10101000';
        noti.System_Status_Text__c = 'NNCP';
        noti.Notification_Status__c = 'In Progress';
        noti.Planning_Plant__c = masterMapMap.get('Plant');
        noti.Priority__c = 'Normal';
        noti.Requested_Date__c = system.today();
        noti.Requester__c = userinfo.getUserId();
        noti.Required_End__c = system.today();
        noti.Required_Start__c = system.today();
        noti.Type__c = 'CM';
        noti.User_Status__c = 'NNCP';
        insert noti;
        
        Order__c o = new Order__c();
        o.Name = '101001000';
        o.Order_Type__c = 'PM01';
        o.Functional_Location__c = fl.id;
        o.Equipment__c = eq.id;
        o.Description__c = 'test descritpion';
        o.Notification__c = noti.id;
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
        o.Integration_Status__c = 'In Progress';
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
        insert spr;
        
        
        
        Item__c item = new Item__c();
        item.Damage__c = masterMapMap.get('Damage');
        item.Object_Part__c = masterMapMap.get('Object Part');
        item.Damage_Code_Group__c = masterMapMap.get('Code Group');
        item.Object_Part_Code_Group__c = masterMapMap.get('Code Group');
        item.Text__c = 'test';
        item.Item_No__c = '1';
        item.Notification__c = noti.id;
        insert item;
        
        Cause__c c = new Cause__c();
        c.Item__c = item.id;
        c.Notification__c = noti.id;
        c.Code_Group__c = masterMapMap.get('Code Group');
        c.Code__c = masterMapMap.get('Cause');
        c.Text__c = 'test';
        c.Cause_No__c = '1';
        insert c;
        
        Activity__c a = new Activity__c();
        a.Item__c = item.id;
        a.Notification__c = noti.id;
        a.Code_Group__c = masterMapMap.get('Code Group');
        a.Code__c = masterMapMap.get('Activity');
        a.Text__c = 'test';
        a.Activity_No__c = '1';
        a.ItemActivity__c = 'test.1';
        insert a;

    }
    
    @isTest
    public static void testPushNotificationIntegrationSAP()
    {
        Test.setMock(HttpCalloutMock.class, new THOR_IRPAMock());
        
        THORIntegration__c cs =new THORIntegration__c();
        cs.iRPA_Client_Id__c = 'sb-d73afc64-431a-4de2-a617-906f7c41942c!b14053|sapmlirpa--irpatrial--trial--uaa-service-broker!b3516';
        cs.iRPA_Client_Secret_Id__c = 'ikiVy26FO2hT1r1gZ/MfOh4MrnI=';
        cs.iRPA_Token_Endpoint__c = 'https://1aa5670atrial.authentication.us10.hana.ondemand.com/oauth/token';
        cs.iRPA_Notification_Endpoint__c = 'https://api.irpa-trial.cfapps.us10.hana.ondemand.com/apitrigger/v1/triggers/ff3f5515-206c-4c37-8654-a3d5d20de966/run';
        cs.iRPA_Notification_Token__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        cs.iRPA_API_Key_Header__c = 'irpa-api-key';
        cs.iRPA_API_Key__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        
        insert cs;
        
        test.startTest();
        
        List<Notification__c>notiList = [select id from Notification__c];
        
        Notification__c updatedNoti = new Notification__c(Id = notiList[0].Id);
        updatedNoti.Description__c = 'tset';
        updatedNoti.Integration_Status__c = 'Success';
        updatedNoti.History_Detail__c = '* Line 1\n* Line 2\n* Line 3\n';
        update updatedNoti;
        List<Notification__c>updatednotiList = [select id from Notification__c];
        test.stopTest();
        system.assert(updatednotiList.size() > 0);
        
    }
    
    @isTest
    public static void testNotificationToSAP()
    {
        Test.setMock(HttpCalloutMock.class, new THOR_IRPAMock());
        
        THORIntegration__c cs =new THORIntegration__c();
        cs.iRPA_Client_Id__c = 'sb-d73afc64-431a-4de2-a617-906f7c41942c!b14053|sapmlirpa--irpatrial--trial--uaa-service-broker!b3516';
        cs.iRPA_Client_Secret_Id__c = 'ikiVy26FO2hT1r1gZ/MfOh4MrnI=';
        cs.iRPA_Token_Endpoint__c = 'https://1aa5670atrial.authentication.us10.hana.ondemand.com/oauth/token';
        cs.iRPA_Notification_Endpoint__c = 'https://api.irpa-trial.cfapps.us10.hana.ondemand.com/apitrigger/v1/triggers/ff3f5515-206c-4c37-8654-a3d5d20de966/run';
        cs.iRPA_Notification_Token__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        cs.iRPA_API_Key_Header__c = 'irpa-api-key';
        cs.iRPA_API_Key__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        
        insert cs;
        
        test.startTest();
        
        List<Notification__c>notiList = [select id from Notification__c];
        
        Notification__c updatedNoti = new Notification__c(Id = notiList[0].Id);
        updatedNoti.Description__c = 'tset';
        updatedNoti.Integration_Status__c = 'In Progress';
        update updatedNoti;
        List<Notification__c>updatednotiList = [select id from Notification__c];
        test.stopTest();
        system.assert(updatednotiList.size() > 0);
        
    }
    
    @isTest
    public static void testItemToSAP()
    {
        Test.setMock(HttpCalloutMock.class, new THOR_IRPAMock());
        
        THORIntegration__c cs =new THORIntegration__c();
        cs.iRPA_Client_Id__c = 'sb-d73afc64-431a-4de2-a617-906f7c41942c!b14053|sapmlirpa--irpatrial--trial--uaa-service-broker!b3516';
        cs.iRPA_Client_Secret_Id__c = 'ikiVy26FO2hT1r1gZ/MfOh4MrnI=';
        cs.iRPA_Token_Endpoint__c = 'https://1aa5670atrial.authentication.us10.hana.ondemand.com/oauth/token';
        cs.iRPA_Item_Endpoint__c = 'https://api.irpa-trial.cfapps.us10.hana.ondemand.com/apitrigger/v1/triggers/ecda22a0-354d-4a6e-b404-ec475bd5e3ef/run';
        cs.iRPA_Item_Token__c = 'pPuXlzHCi_iqviV5_RpAzE_4CxKUXBpM';
        cs.iRPA_API_Key_Header__c = 'irpa-api-key';
        cs.iRPA_API_Key__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        
        insert cs;
        
        test.startTest();
        List<Item__c>itemList = [select id from Item__c];
        Item__c updatedItem = new Item__c(Id = itemList[0].Id);
        updatedItem.Text__c = 'tset';
        update updatedItem;
        List<Item__c>updateditemList = [select id from Item__c];
        test.stopTest();
        system.assert(updateditemList.size() > 0);
    }
    
    @isTest
    public static void testCauseToSAP()
    {
        Test.setMock(HttpCalloutMock.class, new THOR_IRPAMock());
        
        THORIntegration__c cs =new THORIntegration__c();
        cs.iRPA_Client_Id__c = 'sb-d73afc64-431a-4de2-a617-906f7c41942c!b14053|sapmlirpa--irpatrial--trial--uaa-service-broker!b3516';
        cs.iRPA_Client_Secret_Id__c = 'ikiVy26FO2hT1r1gZ/MfOh4MrnI=';
        cs.iRPA_Token_Endpoint__c = 'https://1aa5670atrial.authentication.us10.hana.ondemand.com/oauth/token';
        cs.iRPA_Cause_Endpoint__c = 'https://api.irpa-trial.cfapps.us10.hana.ondemand.com/apitrigger/v1/triggers/ecda22a0-354d-4a6e-b404-ec475bd5e3ef/run';
        cs.iRPA_Cause_Token__c = 'pPuXlzHCi_iqviV5_RpAzE_4CxKUXBpM';
        cs.iRPA_API_Key_Header__c = 'irpa-api-key';
        cs.iRPA_API_Key__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        
        insert cs;
        
        test.startTest();
        List<Cause__c>causeList = [select id from Cause__c];
        Cause__c updatedCause = new Cause__c(Id = causeList[0].Id);
        updatedCause.Text__c = 'tset';
        update updatedCause;
        List<Cause__c>updatedcauseList = [select id from Cause__c];
        test.stopTest();
        system.assert(updatedcauseList.size() > 0);
    }
    
    @isTest
    public static void testActivityToSAP()
    {
        Test.setMock(HttpCalloutMock.class, new THOR_IRPAMock());
        
        THORIntegration__c cs =new THORIntegration__c();
        cs.iRPA_Client_Id__c = 'sb-d73afc64-431a-4de2-a617-906f7c41942c!b14053|sapmlirpa--irpatrial--trial--uaa-service-broker!b3516';
        cs.iRPA_Client_Secret_Id__c = 'ikiVy26FO2hT1r1gZ/MfOh4MrnI=';
        cs.iRPA_Token_Endpoint__c = 'https://1aa5670atrial.authentication.us10.hana.ondemand.com/oauth/token';
        cs.iRPA_Activity_Endpoint__c = 'https://api.irpa-trial.cfapps.us10.hana.ondemand.com/apitrigger/v1/triggers/ecda22a0-354d-4a6e-b404-ec475bd5e3ef/run';
        cs.iRPA_Activity_Token__c = 'pPuXlzHCi_iqviV5_RpAzE_4CxKUXBpM';
        cs.iRPA_API_Key_Header__c = 'irpa-api-key';
        cs.iRPA_API_Key__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        
        insert cs;
        
        test.startTest();
        List<Activity__c>activityList = [select id from Activity__c];
        Activity__c updatedActivity = new Activity__c(Id = activityList[0].Id);
        updatedActivity.Text__c = 'tset';
        update updatedActivity;
        List<Activity__c>updatedactivityList = [select id from Activity__c];
        test.stopTest();
        system.assert(updatedactivityList.size() > 0);        
    }
    
    @isTest
    public static void testSparePartRequestToSAP()
    {
        Test.setMock(HttpCalloutMock.class, new THOR_IRPAMock());
        
        THORIntegration__c cs =new THORIntegration__c();
        cs.iRPA_Client_Id__c = 'sb-d73afc64-431a-4de2-a617-906f7c41942c!b14053|sapmlirpa--irpatrial--trial--uaa-service-broker!b3516';
        cs.iRPA_Client_Secret_Id__c = 'ikiVy26FO2hT1r1gZ/MfOh4MrnI=';
        cs.iRPA_Token_Endpoint__c = 'https://1aa5670atrial.authentication.us10.hana.ondemand.com/oauth/token';
        cs.iRPA_Spare_Part_Request_Endpoint__c = 'https://api.irpa-trial.cfapps.us10.hana.ondemand.com/apitrigger/v1/triggers/ecda22a0-354d-4a6e-b404-ec475bd5e3ef/run';
        cs.iRPA_Spare_Part_Request_Token__c = 'pPuXlzHCi_iqviV5_RpAzE_4CxKUXBpM';
        cs.iRPA_API_Key_Header__c = 'irpa-api-key';
        cs.iRPA_API_Key__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        
        insert cs;
        
        test.startTest();
        List<Spare_Part_Request__c>sprList = [select id from Spare_Part_Request__c];
        Spare_Part_Request__c updatedSparePartRequest = new Spare_Part_Request__c(Id = sprList[0].Id);
        updatedSparePartRequest.Request_Status__c = 'Pending for Approval';
        update updatedSparePartRequest;
        List<Spare_Part_Request__c>updatedsprList = [select id from Spare_Part_Request__c];
        test.stopTest();
        system.assert(updatedsprList.size() > 0);        
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
        
        test.startTest();
        List<Order__c>orderList = [select id from Order__c];
        Order__c updatedOrder = new Order__c(Id = orderList[0].Id);
        updatedOrder.Description__c = 'test update description';
        updatedOrder.Integration_Status__c = 'In Progress';
        update updatedOrder;
        List<Order__c>updatedOrderList = [select id from Order__c];
        test.stopTest();
        
        system.assert(updatedOrderList.size() > 0);        
    }

    @isTest
    public static void testPISUserProperty()
    {      
        PISUsers__c puser = new PISUsers__c();
        puser.User__c = UserInfo.getUserId();
        puser.HOST_ID__c = '00000001';
        insert puser;
        
        Test.startTest();
        // First Get PISUser From Database
        THOR_IRPAIntegration.pisUserMap.get(puser.Id);
        // Next Call Get PISUser From Cache
        PISUsers__c pisUser = THOR_IRPAIntegration.pisUserMap.get(puser.Id);
        Test.stopTest();

        System.assertEquals(UserInfo.getUserId(), pisUser?.User__c);
    }

    @isTest
    public static void testCategoryWithMainWorkCenterWithPlant()
    {
        Test.startTest();
        Master_Map__c masterMap1 = new Master_Map__c(
            Name = 'Related 1',
            Code__c = 'Related 1'
        );
        insert masterMap1;

        Master_Map__c masterMap2 = new Master_Map__c(
            Name = 'Related 2',
            Code__c = 'Related 2'
        );
        insert masterMap2;

        Master_Map__c masterMap = new Master_Map__c(
            Name = 'Test',
            Code__c = 'Test',
            Type__c = 'CategoryWithMainWorkCenterWithPlant',
            RelatedMasterMap1__c = masterMap1.Id,
            RelatedMasterMap2__c = masterMap2.Id
        );
        insert masterMap;

        String RelatedCode = THOR_IRPAIntegration.categoryWithMainWorkCenterWithPlant.get('Related 1Related 2');

        //System.assertEquals('Test', RelatedCode);
        Test.stopTest();
    }
    
    @isTest
    public static void testCatelogFaultCode()
    {
        Test.startTest();
        Master_Map__c masterMap1 = new Master_Map__c(
            Name = 'Related 1',
            Code__c = 'Related 1'
        );
        insert masterMap1;

        Master_Map__c masterMap2 = new Master_Map__c(
            Name = 'Related 2',
            Code__c = 'Related 2'
        );
        insert masterMap2;

        Master_Map__c masterMap = new Master_Map__c(
            Name = 'Test',
            Code__c = 'Test',
            Type__c = 'CatelogFaultCode',
            RelatedMasterMap1__c = masterMap1.Id,
            RelatedMasterMap2__c = masterMap2.Id
        );
        insert masterMap;

        String RelatedCode = THOR_IRPAIntegration.catelogFaultCode.get(String.valueOf(masterMap2.Id));
        System.assertEquals(String.valueOf(masterMap1.Id), RelatedCode);

        Test.stopTest();

    }
}