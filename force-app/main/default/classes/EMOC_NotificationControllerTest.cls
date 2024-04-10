@isTest
public class EMOC_NotificationControllerTest {
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
        
        Functional_Location__c funcLoc = new Functional_Location__c();
        funcLoc.Name = 'Test Functional Location';
        funcLoc.Description__c = 'TEST'; 
        funcLoc.MainWorkCenter__c = mapMas1.Id;
        funcLoc.mainWorkCenterPlant__c = mapMas1.Id;
        insert funcLoc;
        
        User currentuser = [Select Id, Name, Department from User where Id = :userinfo.getuserId()];
        currentuser.Department = 'EMOC';
        update currentuser;
        
        PISUsers__c pisUser = new PISUsers__c();
        pisUser.ORGID__c = '10000001';
        pisUser.User__c = currentuser.Id;
        pisUser.Active__c = true;
        pisUser.MAINPOSITION__c = true;
        insert pisUser;
        
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
        emoc.MOS_for_maintenance__c  = true;
        emoc.Safeguarding_force_signal__c = false;
        emoc.Status_Common_Workflow__c = 'VP Approve';
        insert emoc; 

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
      	noti.Integration_Status__c = 'In Progress';
      	noti.Integration_Message__c = '';
      	//noti.Order__c = '';
      	noti.Notification_Status__c = '';
      	noti.User_Status__c = '';
        noti.E_MOC_Application_No__c = emoc.Id;
        insert noti;
    }
    
    static testmethod void testPushNotificationIntegrationSAP()
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
        
        List<Notification__c>notiList = [select id from Notification__c];
        E_MOC_Application__c emoc = [select id from E_MOC_Application__c];
        
        emoc.Status_Functional_Override__c = 'Implementation#1';
        emoc.Status_Common_Workflow__c = 'Concept Approval';
        emoc.MOC_Type__c = 'Normal';
        emoc.Functional_Override__c = true;
        update emoc;
        
        emoc.Status_Functional_Override__c = 'Close out';
        emoc.Functional_Override__c = true;
        emoc.Notification__c = notiList[0].Id;
        update emoc;
        
        emoc.Status_Common_Workflow__c = 'Closed';
        emoc.Status_Functional_Override__c = 'Implementation#1';
        emoc.Common_Workflow__c = true;
        update emoc;
        
        test.startTest();

        Notification__c updatedNoti = new Notification__c(Id = notiList[0].Id);
        updatedNoti.Description__c = 'tset';
        update updatedNoti;
        Map<String, String> obj = new Map<String, String>();

        obj.put('Id', updatedNoti.Id);
        obj.put('Integration_Status__c', 'In Progress');
        obj.put('E_MOC_Application_No__c',emoc.Id);

        EMOC_NotificationController.putNotification(obj);
        test.stopTest();
        List<Notification__c>updatednotiList = [select id from Notification__c];
        system.assert(updatednotiList.size() > 0);
        
    }
    
    static testmethod void testData() {       
        
        Test.startTest();

        User currentuser = [Select Id, Name, Department from User where Id = :userinfo.getuserId()];
        Master_Map__c msMap = [Select Id, Name from Master_Map__c limit 1];
        E_MOC_Application__c emocApp = [SELECT Id, Name FROM E_MOC_Application__c LIMIT 1];
        Functional_Location__c func = [SELECT Id, Name FROM Functional_Location__c LIMIT 1];
        PISUsers__c pisUser = [Select Id, ORGID__c  from PISUsers__c where User__c = :userinfo.getuserId()];
        
        EMOC_NotificationController.getLookupFncLocation('Functional');
        EMOC_NotificationController.getLookupUser(currentuser.Name);
        EMOC_NotificationController.getLookupMasterMap(msMap.Name);
        EMOC_NotificationController.getLookupPMActivity('');
        
        Map<String, String> obj = new Map<String, String>();
		obj.put('emocApplicationId', emocApp.Id);
        EMOC_NotificationController.getEmocApplication(obj);
        
        String notification = '{"notification":{"Notification_Type__c":"CR","Functional_Location__c":"'+func.Id+'","Functional_Location_Description__c":"des1"'+
            ',"Plant_of_Main_Work_Center__c":"1200","Main_Work_Center__c":"ENMA-I","Requestor_ID__c":"'+currentuser.Id+'","Requestor_Name__c":"'+currentuser.Id+'"'+
            ',"Description__c":"DES1","Department_Resp__c":"ENVP","Notification__c":"","Integration_Status__c":"Failed","Integration_Message__c":"","Order__c":""'+
            ',"Notification_Status__c":"","User_Status__c":"","Priority__c":""}}';
        
        EMOC_NotificationController.submitNotification(emocApp.Id);

        Notification__c noti = [SELECT Id, Name FROM Notification__c LIMIT 1];
		obj.put('id', noti.Id);
        obj.put('Id', noti.Id);
        obj.put('Integration_Status__c', 'In Progress');
        obj.put('E_MOC_Application_No__c', emocApp.Id);
        
        EMOC_NotificationController.getNotification(obj);
        //EMOC_NotificationController.putNotification(obj);
        EMOC_NotificationController.deleteNotification(obj);
        
        emocApp.Status_Common_Workflow__c = 'Concept Approval';
        emocApp.Notification__c = null;
        update emocApp;
        
        emocApp.Status_Common_Workflow__c = 'Implementation';
        emocApp.MOC_Type__c = 'Normal';
        emocApp.Notification__c = null;
        update emocApp;
       
        Test.stopTest();
    }
}