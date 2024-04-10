@isTest
public class EMOC_OrderListControllerTest {
    @testSetup static void Data() {
        Functional_Location__c funcLoc = new Functional_Location__c();
        funcLoc.Name = 'Test Functional Location';
        insert funcLoc;
        
        Master_Map__c mapMas = new Master_Map__c();
        mapMas.Name = 'ENMA-I';
        insert mapMas;
        
        User currentuser = [Select Id, Name, Department from User where Id = :userinfo.getuserId()];
        currentuser.Department = 'EMOC';
        update currentuser;
        
        Notification__c noti = new Notification__c();
      	noti.Functional_Location__c = funcLoc.Id;
      	noti.Main_Work_Center__c = mapMas.Id;
      	noti.Description__c = '';
      	noti.Department_Resp__c = 'ENVP';
      	noti.Integration_Status__c = '';
      	noti.Integration_Message__c = '';
      	noti.Notification_Status__c = '';
      	noti.User_Status__c = '';
        insert noti;
        
        E_MOC_Application__c emoc = new E_MOC_Application__c();
        emoc.MOC_Type__c = 'Emergency';
        emoc.Functional_Override__c = true;
        emoc.Functional_Location__c = funcLoc.Id;
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
        insert emoc; 
        
        Order__c o = new Order__c();
        o.Name = '101001000';
        o.Order_Type__c = 'PM01';
        o.Functional_Location__c = funcLoc.id;
        o.Description__c = 'test descritpion';
        o.Notification__c = noti.id;
        o.System_Status_Text__c = 'CRED ANIN';
        o.User_Status__c = 'ANIN';
        o.Requested_Date__c = system.today();
        o.Priority__c = 'Normal';
        o.Start_Date__c = system.today();
        o.Finished_Date__c = system.today();
        o.Responsible_person__c = UserInfo.getUserId();
        o.Integration_Status__c = 'In Progress';
        o.E_MOC_Application_No__c = emoc.Id;
        insert o;
        
    }
    
    static testmethod void testData() {        
        Test.startTest();

        E_MOC_Application__c emocApp = [SELECT Id, Name FROM E_MOC_Application__c LIMIT 1];
        
        EMOC_OrderListController.getOrdersByFilter(emocApp.Id);
        
        Test.stopTest();
    }
}