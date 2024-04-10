/**
 * @author Oktana
 * @description test class for THOR_SetUserStatusControllerTest
 */
@isTest
public with sharing class THOR_SetUserStatusControllerTest {

    @isTest
    public static void testRetrieveUserStatusForNotification() {

        //----- SET
        Master_Map_Set__c mmSet= new Master_Map_Set__c();
        insert mmSet;
        
        //----- TYPE
        Master_Map__c mmType = new Master_Map__c();
        mmType.Name = 'CM';
        mmType.Code__c = 'CM';
        mmType.Master_Map_Set__c = mmSet.Id;
        insert mmType;

        //----- PROFILE
        Master_Map__c mmProfile = new Master_Map__c();
        mmProfile.Name = 'ZPMCM';
        mmProfile.Code__c = 'ZPMCM';
        mmProfile.Master_Map_Set__c = mmSet.Id;
        insert mmProfile;

        //----- TYPE - PROFILE 
        Master_Map__c mmTypeProfileJunction = new Master_Map__c();
        mmTypeProfileJunction.Name = 'CM-ZPMCM';
        mmTypeProfileJunction.Code__c = 'CM-ZPMCM';
        mmTypeProfileJunction.Type__c = 'NotificationTypewithStatusProfile';
        mmTypeProfileJunction.Master_Map_Set__c = mmSet.Id;
        mmTypeProfileJunction.RelatedMasterMap1__c = mmType.Id;
        mmTypeProfileJunction.RelatedMasterMap2__c = mmProfile.Id;
        insert mmTypeProfileJunction;

        //----- STATUS
        Master_Map__c mmStatus1 = new Master_Map__c();
        mmStatus1.Name = 'CANC';
        mmStatus1.Code__c = 'CANC';
        mmStatus1.Description__c = 'Cancelled';
        mmStatus1.Type__c = 'NotificationUserStatus';
        mmStatus1.Master_Map_Set__c = mmSet.Id;
        insert mmStatus1;

        //----- PROFILE - STATUS
        Master_Map__c mmProfileStatusJunction1 = new Master_Map__c();
        mmProfileStatusJunction1.Name = 'ZPMMC -- CANC';
        mmProfileStatusJunction1.Code__c = 'ZPMMC -- CANC';
        mmProfileStatusJunction1.Type__c = 'NotificationStatusProfileWithUserStatus';
        mmProfileStatusJunction1.Master_Map_Set__c = mmSet.Id;
        mmProfileStatusJunction1.RelatedMasterMap1__c = mmProfile.Id;
        mmProfileStatusJunction1.RelatedMasterMap2__c = mmStatus1.Id;
        mmProfileStatusJunction1.Master_Map_Set__c = mmSet.Id;
        insert mmProfileStatusJunction1;

        Test.startTest();
        List<THOR_SetUserStatusController.UserStatusDTO> statusList = THOR_SetUserStatusController.retrieveUserStatusForNotification('CM');
        Test.stopTest();

        System.assertEquals(1, statusList.size(), 'status list size does not match');
        System.assertEquals('CANC', statusList[0].Name, 'status name does not match');
        System.assertEquals('Cancelled', statusList[0].Description, 'status description does not match');
    }

    @isTest
    public static void testRetrieveUserStatusForOrder() {

        //----- SET
        Master_Map_Set__c mmSet= new Master_Map_Set__c();
        insert mmSet;
        
        //----- TYPE
        Master_Map__c mmType = new Master_Map__c();
        mmType.Name = 'CM01';
        mmType.Code__c = 'CM01';
        mmType.Master_Map_Set__c = mmSet.Id;
        insert mmType;

        //----- PROFILE
        Master_Map__c mmProfile = new Master_Map__c();
        mmProfile.Name = 'ZPMCM01';
        mmProfile.Code__c = 'ZPMCM01';
        mmProfile.Master_Map_Set__c = mmSet.Id;
        insert mmProfile;

        //----- TYPE - PROFILE 
        Master_Map__c mmTypeProfileJunction = new Master_Map__c();
        mmTypeProfileJunction.Name = 'CM01-ZPMCM01';
        mmTypeProfileJunction.Code__c = 'CM01-ZPMCM01';
        mmTypeProfileJunction.Type__c = 'OrderTypewithStatusProfile';
        mmTypeProfileJunction.Master_Map_Set__c = mmSet.Id;
        mmTypeProfileJunction.RelatedMasterMap1__c = mmType.Id;
        mmTypeProfileJunction.RelatedMasterMap2__c = mmProfile.Id;
        insert mmTypeProfileJunction;

        //----- STATUS
        Master_Map__c mmStatus1 = new Master_Map__c();
        mmStatus1.Name = 'CANC';
        mmStatus1.Code__c = 'CANC';
        mmStatus1.Description__c = 'Cancelled';
        mmStatus1.Type__c = 'OrderUserStatus';
        mmStatus1.Master_Map_Set__c = mmSet.Id;
        insert mmStatus1;
        
        Master_Map__c mmStatus2 = new Master_Map__c();
        mmStatus2.Name = 'WFTO';
        mmStatus2.Code__c = 'WFTO';
        mmStatus2.Description__c = 'Waiting for TECO';
        mmStatus2.Type__c = 'OrderUserStatus';
        mmStatus2.Master_Map_Set__c = mmSet.Id;
        insert mmStatus2;

        //----- PROFILE - STATUS
        Master_Map__c mmProfileStatusJunction1 = new Master_Map__c();
        mmProfileStatusJunction1.Name = 'ZPMMC01 -- CANC';
        mmProfileStatusJunction1.Code__c = 'ZPMMC01 -- CANC';
        mmProfileStatusJunction1.Type__c = 'OrderStatusProfileWithUserStatus';
        mmProfileStatusJunction1.Status_Number__c = 'TEST';
        mmProfileStatusJunction1.Master_Map_Set__c = mmSet.Id;
        mmProfileStatusJunction1.RelatedMasterMap1__c = mmProfile.Id;
        mmProfileStatusJunction1.RelatedMasterMap2__c = mmStatus1.Id;
        mmProfileStatusJunction1.Master_Map_Set__c = mmSet.Id;
        insert mmProfileStatusJunction1;
        
        Master_Map__c mmProfileStatusJunction2 = new Master_Map__c();
        mmProfileStatusJunction2.Name = 'ZPMCM01 -- FMIR';
        mmProfileStatusJunction2.Code__c = 'ZPMCM01 -- FMIR';
        mmProfileStatusJunction2.Type__c = 'OrderStatusProfileWithUserStatus';
        mmProfileStatusJunction2.Master_Map_Set__c = mmSet.Id;
        mmProfileStatusJunction2.RelatedMasterMap1__c = mmProfile.Id;
        mmProfileStatusJunction2.RelatedMasterMap2__c = mmStatus2.Id;
        mmProfileStatusJunction2.Master_Map_Set__c = mmSet.Id;
        insert mmProfileStatusJunction2;

        Test.startTest();
        List<THOR_SetUserStatusController.UserStatusDTO> statusList = THOR_SetUserStatusController.retrieveUserStatusForOrder('CM01');
        Test.stopTest();

        System.assertEquals(1, statusList.size(), 'status list size does not match');
        System.assertEquals('WFTO', statusList[0].Name, 'status name does not match');
        System.assertEquals('Waiting for TECO', statusList[0].Description, 'status description does not match');
    }
}