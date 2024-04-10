@isTest
public class EMOC_SubOrderControllerTest {
    @testSetup static void Data() {
        Master_Map__c mapMas1 = new Master_Map__c();
        mapMas1.Name = 'CR01';
        insert mapMas1;

        Master_Map__c mapMas2 = new Master_Map__c();
        mapMas2.Name = 'CR02';
        insert mapMas2;

        Master_Map__c mapMas3 = new Master_Map__c();
        mapMas3.Name = 'CR03';
        mapMas3.RelatedMasterMap1__c = mapMas2.Id;
        mapMas3.RelatedMasterMap2__c = mapMas1.Id;
        insert mapMas3;
        
        Master_Map__c mapMas4 = new Master_Map__c();
        mapMas4.Name = '1200';
        mapMas4.Type__c = 'Plant';
        insert mapMas4;
        Master_Map__c mapMas5 = new Master_Map__c();
        mapMas5.Name = 'M01';
        insert mapMas5;
        
        Functional_Location__c funcLoc = new Functional_Location__c();
        funcLoc.Name = 'Test Functional Location';
        funcLoc.Description__c = 'TEST'; 
        funcLoc.MainWorkCenter__c = mapMas1.Id;
        funcLoc.mainWorkCenterPlant__c = mapMas1.Id;
        insert funcLoc;

        Profile p = [select id from Profile where name='System Administrator'];
        
        User User = new User();
        User.Department = 'EMOC';
        User.Email = 'EMOC@gmail.com';
        User.Username = 'EMOC@gmail.com';
        User.firstName = 'FirstTestEMOC';
        User.LastName = 'LastEMOC';
        User.Alias = 'utest';
        User.EmailEncodingKey = 'UTF-8';
        User.LocaleSidKey='en_US';
        User.LanguageLocaleKey='en_US';
        User.TimeZoneSidKey='Asia/Bangkok';
        User.ProfileId = p.id;
        insert User;
        
        PISUsers__c pisUser = new PISUsers__c();
        pisUser.ORGID__c = '10000001';
        pisUser.User__c = User.Id;
        insert pisUser;
        
        Notification__c noti = new Notification__c();
      	noti.Functional_Location__c = funcLoc.Id;
      	//noti.Functional_Location_Description__c = 'des1';
      	//noti.Plant_of_Main_Work_Center__c = '1200';
      	noti.Main_Work_Center__c = mapMas1.Id;
      	//noti.Requestor_ID__c = '00000647';
      	//noti.Requestor_Name__c = '0052v00000h2YV3AAM';
      	noti.Description__c = '';
      	noti.Department_Resp__c = 'ENVP';
      	//noti.Notification__c = '';
      	noti.Integration_Status__c = '';
      	noti.Integration_Message__c = '';
      	//noti.Order__c = '';
      	noti.Notification_Status__c = '';
      	noti.User_Status__c = '';
        insert noti;
        
        E_MOC_Application__c emoc = new E_MOC_Application__c();
        emoc.MOC_Type__c = 'Emergency';
        emoc.Functional_Override__c = true;
        emoc.Functional_Location__c = funcLoc.Id;
        //emoc.RecordTypeId = recordtype.Id;
        emoc.Change_Type__c = 'Permanent';
        emoc.RAM_Total__c = 'M';
        emoc.Next_Reminder_Date__c = Date.today();
        emoc.Emergency__c = true;
        emoc.OPM_OPEX__c = true;
        emoc.Mechanical_change__c = true;
        emoc.Air_Cooled_Exchangers__c = true;
        emoc.Status_Functional_Override__c = 'Create';
        emoc.Instrument_change__c = true;
        emoc.Alarm__c = true;
        emoc.Start_date__c = Date.today();
        emoc.End_date__c = Date.today();
        emoc.Notification__c  = noti.Id;
        emoc.Requestor_Name__c  = User.Id;
        insert emoc; 
        
        Order__c o = new Order__c();
        o.Name = '101001000';
        o.Order_Type__c = 'PM01';
        o.Functional_Location__c = funcLoc.id;
        o.Description__c = 'test descritpion';
        o.Notification__c = noti.id;
        // o.PM_Activity_Type__c = masterMapMap.get('MaintActivityType');
        o.System_Status_Text__c = 'CRED ANIN';
        o.User_Status__c = 'ANIN';
        // o.Main_Work_Center__c = masterMapMap.get('Main Work Center');
        o.Requested_Date__c = system.today();
        o.Priority__c = 'Normal';
        o.Start_Date__c = system.today();
        o.Finished_Date__c = system.today();
        o.Responsible_person__c = UserInfo.getUserId();
        // o.Planning_Plant__c = masterMapMap.get('Plant');
        o.Integration_Status__c = 'In Progress';
        o.E_MOC_Application_No__c = emoc.Id;
        o.Order_Status__c = 'New';
        insert o;
        
        Order__c ord = new Order__c();
        ord.Name = '101001001';
        ord.Order_Type__c = 'PM02';
        ord.Functional_Location__c = funcLoc.id;
        ord.Description__c = 'test descritpion';
        ord.Super_Order__c = o.Id;
        ord.Order_Status__c = 'In Progress';
        ord.E_MOC_Application_No__c = emoc.Id;
        insert ord;
        
        Order__c ord2 = new Order__c();
        ord2.Name = '101001002';
        ord2.Order_Type__c = 'PM02';
        ord2.Functional_Location__c = funcLoc.id;
        ord2.Description__c = 'test descritpion';
        ord2.Super_Order__c = o.Id;
        ord2.Order_Status__c = 'New';
        ord2.E_MOC_Application_No__c = emoc.Id;
        insert ord2;
        
    }
    
    static testmethod void testPushOrderIntegrationSAP()
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
        
        Map<String, String> obj = new Map<String, String>();
        obj.put('Id', updatedOrder.Id);
        obj.put('Integration_Status__c', 'In Progress');
        EMOC_SubOrderController.putOrder(obj);
        
        test.stopTest();
        
        List<Order__c>updatedOrderList = [select id from Order__c];
        system.assert(updatedOrderList.size() > 0);                
    }
    
    static testmethod void testData() {        
        Test.startTest();
		Id userId = UserInfo.getUserId();
        
        User currentuser = [Select Id, Name, Department from User where firstName = 'FirstTestEMOC' limit 1];
        Master_Map__c msMap = [Select Id, Name from Master_Map__c limit 1];
        E_MOC_Application__c emocApp = [SELECT Id, Name FROM E_MOC_Application__c LIMIT 1];
        Functional_Location__c func = [SELECT Id, Name FROM Functional_Location__c LIMIT 1];
        PISUsers__c pisUser = [Select Id, ORGID__c  from PISUsers__c where User__c = :currentuser.Id limit 1];
		Order__c order = [SELECT Id, Name FROM Order__c WHERE Name = '101001000'];

        EMOC_SubOrderController.getLookupFncLocation('Functional');
        EMOC_SubOrderController.getLookupUser(currentuser.Name);
       // Map<String, String> paramSearch = new Map<String, String>{'orderType' => 'CR01', 'searchParam' => ''};
        EMOC_SubOrderController.getLookupMasterMap('CR01');
        EMOC_SubOrderController.getLookupMainWorkCenterPlan('1200');
        EMOC_SubOrderController.getLookupPMActivity('');
               
        Map<String, String> obj = new Map<String, String>();
		obj.put('orderId', order.Id);
        EMOC_SubOrderController.getOrder(obj);
        
        String orderString = '{"order":{"Order_Type__c":"CR01","Functional_Location__c":"'+func.Id+'","Functional_Location_Description__c":"des1"'+
            ',"PM_Activity_Type__c":"'+msMap.Id+'","mainWorkCenterPlant__c":"'+msMap.Id+'","Main_Work_Center__c":"'+msMap.Id+'"'+
            ',"Responsible_Person_Name__c":"'+currentuser.Id+'","Responsible_Person_ID__c":"'+currentuser.Id+'","Start_Date__c":"2022-08-18","Finished_Date__c":"2022-08-25"'+
            ',"Budget_Number_WBS_element__c":"999999","Requestor__c":null'+
            ',"Integration_Status__c":"In Progress","Order_Status__c":"In Progress","User_Status__c":null'+
            ',"Requestor_Name__c":"'+currentuser.Id+'","Department_Resp__c":"ENVP","Requestor_ID__c":"'+currentuser.Id+'","Responsible_person_PISUser__c":"'+pisUser.Id+'"'+
            ',"Super_Order_Text__c":"","Super_Order__c":"'+order.Id+'","Super_Order__c_id":"'+order.Id+'"}}';
        
        Map<String, Object> response = EMOC_SubOrderController.postOrder(orderString);
        
        //Order__c orderDetail = [SELECT Id, Name FROM Order__c WHERE Id = :String.valueof(response.get('Id'))];
        Order__c orderDetail = [SELECT Id, Name FROM Order__c LIMIT 1];

		obj.put('Id', orderDetail.Id);
        obj.put('orderId', orderDetail.Id);
        
        EMOC_SubOrderController.getOrderDetail(obj);
        EMOC_SubOrderController.deleteOrder(obj);
        
        Order__c order2 = new Order__c();
		order2.Order_Number__c = '1234';
		order2.Order_Type__c = 'PJ01';
		order2.Order_Status__c = 'In Progress';
        order2.Integration_Status__c = 'Success';
        order2.E_MOC_Application_No__c = emocApp.Id;
        order2.System_Status_Text__c = 'TECO';
		insert order2; 

        Map<String, String> params = new Map<String, String>();
		params.put('Id', order2.Id);
        EMOC_SubOrderController.getCloseOrderStatus(params);

        Test.stopTest();
    }

}