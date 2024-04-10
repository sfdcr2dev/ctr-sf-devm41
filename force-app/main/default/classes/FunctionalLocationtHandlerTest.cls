@isTest
public class FunctionalLocationtHandlerTest {

    @TestSetup
    static void makeData() {
        Master_Map__c mwcType = new Master_Map__c(Name='ELEC', Code__c='ELEC', Type__c='MainWorkCenterType');
        insert mwcType;
        Master_Map__c mwc = new Master_Map__c(Name='ENMA-E', Code__c='ENMA-E', Type__c='Main Work Center', RelatedMasterMap1__c=mwcType.Id);
        insert mwc;
        Functional_Location__c parent = new Functional_Location__c(Name='Parent FL', MainWorkCenter__c=mwc.Id);
        insert parent;
    }

    @isTest
    static void testBeforeInsertFL() {
        Test.startTest();
        Master_Map__c enmae = [SELECT Id, RelatedMasterMap1__r.Name FROM Master_Map__c WHERE Name = 'ENMA-E' LIMIT 1];
        Functional_Location__c fl = new Functional_Location__c(Name='Test', Parent_Functional_Location_Text__c='Parent FL', MainWorkCenter__c=enmae.Id);
        insert fl;
        
        Functional_Location__c expected = [SELECT Mainworkcenter_type__c FROM Functional_Location__c WHERE Name = 'Test' LIMIT 1];
        System.assertEquals('ELEC', expected.Mainworkcenter_type__c);
        Test.stopTest();
    }

    @isTest
    static void testBeforeUpdateFL() {
        Test.startTest();
        Master_Map__c enmae = [SELECT Id, RelatedMasterMap1__r.Name FROM Master_Map__c WHERE Name = 'ENMA-E' LIMIT 1];
        Functional_Location__c fl = new Functional_Location__c(Name='Test');
        insert fl;

        fl.Parent_Functional_Location_Text__c = 'Parent FL';
        fl.MainWorkCenter__c = enmae.Id;
        update fl;

        Functional_Location__c expected = [SELECT Mainworkcenter_type__c FROM Functional_Location__c WHERE Name = 'Test' LIMIT 1];
        System.assertEquals('ELEC', expected.Mainworkcenter_type__c);
        Test.stopTest();
    }
}