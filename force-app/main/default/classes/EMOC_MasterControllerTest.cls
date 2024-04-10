@isTest
public class EMOC_MasterControllerTest {
    @testSetup static void Data() {  
        Master_Map__c mapMas1 = new Master_Map__c();
        mapMas1.Name = 'CR01';
        mapMas1.Type__c = 'Main Work Center';
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
        
        Functional_Location__c funcLoc = new Functional_Location__c();
        funcLoc.Name = 'Test Functional Location';
        funcLoc.Description__c = 'TEST';
       	funcLoc.MainWorkCenter__c = mapMas1.Id;
        funcLoc.mainWorkCenterPlant__c = mapMas1.Id;
        insert funcLoc;

        User currentuser = [Select Id, Name, Department from User where Id = :userinfo.getuserId()];
        currentuser.Department = 'EMOC';
        update currentuser;

    }
    static testmethod void testData() {
        Test.startTest();

        User currentuser = [Select Id, Name, Department from User where Id = :userinfo.getuserId()];
        
        Master_Map__c mapMas1 = new Master_Map__c();
        mapMas1.Name = 'CR01';
        mapMas1.Type__c = 'Main Work Center';
        insert mapMas1;
        
        EMOC_MasterController.getLookupFncLocation('Functional', 'Notification');
        EMOC_MasterController.getLookupUser(currentuser.Name);
 		EMOC_MasterController.getLookupMasterMap(mapMas1.Id);
        EMOC_MasterController.getLookupPMActivity('CR01');
        EMOC_MasterController.getLookupMainWorkCenterPlan('1200');
        Test.stopTest();
    }
}