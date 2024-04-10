/**
 * @author Oktana
 * @description test class for MasterMapHandler
 */
@isTest
public class MasterMapHandlerTest {
    /**
     * @given no Master Map Set
     * @when a new Master Map is created
     * @then a Master Map Set is created and related to the Master Map
     */
    @isTest
    static void testNewMasterMapWithoutMasterMapSet() {
        Master_Map__c masterMap = new Master_Map__c(Name = 'Test Master Map');
        List<Master_Map_Set__c> initialSets = getMasterMapSet();

        Test.startTest();
        insert masterMap;
        Test.stopTest();

        List<Master_Map_Set__c> finalSets = getMasterMapSet();

        System.assertEquals(finalSets.size(), initialSets.size() + 1, 'A new Master Map Set should have been created');

        List<Master_Map__c> masterMaps = getMasteMaps();

        System.assertEquals(
            finalSets.get(0).Id,
            masterMaps.get(0).Master_Map_Set__c,
            'The new Master Map Set should have been related to the new Master Map'
        );
    }

    /**
     * @given a Master Map Set
     * @when a new Master Map is created
     * @then the Master Map Set is created and related to the Master Map
     */
    @isTest
    static void testNewMasterMapWithMasterMapSet() {
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        Master_Map__c masterMap = new Master_Map__c(Name = 'Test Master Map');
        List<Master_Map_Set__c> initialSets = getMasterMapSet();

        Test.startTest();
        insert masterMap;
        Test.stopTest();

        List<Master_Map_Set__c> finalSets = getMasterMapSet();

        System.assertEquals(finalSets.size(), initialSets.size(), 'No new Master Map Set should have been created');

        List<Master_Map__c> masterMaps = getMasteMaps();

        System.assertEquals(
            masterMapSet.Id,
            masterMaps.get(0).Master_Map_Set__c,
            'The new Master Map Set should have been related to the new Master Map'
        );
    }

    private static List<Master_Map_Set__c> getMasterMapSet() {
        return [SELECT Id FROM Master_Map_Set__c];
    }

    private static List<Master_Map__c> getMasteMaps() {
        return [SELECT Id, Master_Map_Set__c FROM Master_Map__c];
    }
}