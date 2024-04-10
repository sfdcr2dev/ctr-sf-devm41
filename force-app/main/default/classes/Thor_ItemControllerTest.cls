/**
 * @author Oktana
 * @description test class for Thor_ItemController
 */
@isTest
public with sharing class Thor_ItemControllerTest {
    @testSetup
    static void setup() {
        Master_Map_Set__c mapset = new Master_Map_Set__c();
        insert mapset;
system.debug('=1=mapset.Id==>'+mapset.Id);
        Master_Map__c IEP = new Master_Map__c();
        IEP.Name = 'IEP-133';
        IEP.Code__c = 'IEP-133';
        IEP.Master_Map_Set__c = mapset.Id;
        insert IEP;

        Master_Map__c IEA = new Master_Map__c();
        IEA.Name = 'IEA-133';
        IEA.Type__c = 'Code Group';
        IEA.Description__c = 'VISCOSITY ANALYZER';
        IEA.Code__c = 'IEA-133';
        IEA.Master_Map_Set__c = mapset.Id;
        insert IEA;

        Equipment__c equip = new Equipment__c();
        equip.catelogProfile__c = IEP.Id;
        insert equip;

        Functional_Location__c functionalLocation = new Functional_Location__c();
        functionalLocation.catelogProfile__c = IEP.Id;
        insert functionalLocation;
        
        system.debug('==equip.Id==>'+equip.Id);
        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Description',
            Equipment__c = equip.Id
        );
        insert notification;

        Notification__c notification2 = new Notification__c(
            Name = 'Test Notification2',
            Description__c = 'Description',
            Functional_Location__c = functionalLocation.Id
        );
        insert notification2;
        

        Item__c item = new Item__c(Notification__c = notification.Id, Text__c = 'Test Item');
        insert item;
        List<Master_Map__c> masterMaps = new List<Master_Map__c>{
            new Master_Map__c(
                Name = 'IEC-133',
                Type__c = 'Code Group',
                Code__c = 'IEC-133',
                Description__c = 'VISCOSITY ANALYZER',
                Master_Map_Set__c = mapset.Id
            ),
            new Master_Map__c(Name = 'I-SC', Code__c = 'I-SC', Master_Map_Set__c = mapset.Id),
            new Master_Map__c(Name = 'I-LO', Code__c = 'I-LO', Master_Map_Set__c = mapset.Id),
            new Master_Map__c(Name = 'I-TT', Code__c = 'I-TT', Master_Map_Set__c = mapset.Id)
        };
        insert masterMaps;

        List<Master_Map__c> otherMaps = new List<Master_Map__c>{
            new Master_Map__c(
                Type__c = 'CatelogCause',
                Code__c = 'Loose',
                Description__c = 'Loose',
                RelatedMasterMap1__c = masterMaps.get(0).Id,
                RelatedMasterMap2__c = masterMaps.get(1).Id,
                Master_Map_Set__c = mapset.Id
            ),
            new Master_Map__c(
                Type__c = 'CatelogActivity',
                Description__c = 'Tighten',
                Code__c = 'Tighten',
                RelatedMasterMap1__c = IEA.Id,
                RelatedMasterMap2__c = masterMaps.get(3).Id,
                Master_Map_Set__c = mapset.Id
            ),
            new Master_Map__c(
                Type__c = 'CatalogType',
                Description__c = 'Cause',
                RelatedMasterMap1__c = IEP.Id,
                RelatedMasterMap2__c = masterMaps.get(0).Id,
                Master_Map_Set__c = mapset.Id
            ),
            new Master_Map__c(
                Type__c = 'CatalogType',
                Description__c = 'Activity',
                RelatedMasterMap1__c = IEP.Id,
                RelatedMasterMap2__c = IEA.Id,
                Master_Map_Set__c = mapset.Id
            )
        };
        insert otherMaps;

        Notification__c noti = new Notification__c();
        noti.Name = '10728301';
        insert noti;

        List<Cause__c> itemCauses = new List<Cause__c>();
        for (Integer i = 0; i < 5; i++) {
            itemCauses.add(new Cause__c(Item__c = item.Id, Text__c = 'Cause' + i));
        }
        for (Integer i = 5; i < 9; i++) {
            itemCauses.add(new Cause__c(Item__c = item.Id, Text__c = 'Cause' + i, isDeleted__c = true));
        }
        insert itemCauses;

        List<Activity__c> itemActivities = new List<Activity__c>();
        for (Integer i = 0; i < 5; i++) {
            itemActivities.add(new Activity__c(Item__c = item.Id, Notification__c = noti.Id, Text__c = 'Activity' + i));
        }
        for (Integer i = 5; i < 9; i++) {
            itemActivities.add(new Activity__c(Item__c = item.Id, Notification__c = noti.Id, Text__c = 'Activity' + i, isDeleted__c = true));
        }
        insert itemActivities;
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all cause code groups should be retreived
     */
    @isTest
    static void testgetCauseCodeGroupsFiltered() {
        Test.startTest();
        System.debug(Limits.getQueries());
        List<Master_Map__c> mapList = new List<Master_Map__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification' AND Description__c = 'Description'
        ];

        mapList = THOR_ItemController.getCauseCodeGroupsFiltered(noti.Id);
        System.assertEquals(1, mapList.size());
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all cause code groups should be retreived
     */
    @isTest
    static void testgetCauseCodeGroupsFilteredByNothing() {
        Test.startTest();
        Notification__c noti = new Notification__c();
        noti.Name = '10728301';
        insert noti;

        System.debug(Limits.getQueries());
        List<Master_Map__c> mapList = THOR_ItemController.getCauseCodeGroupsFiltered(noti.Id);
        System.assertEquals(1, mapList.size());
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all activity code groups should be retreived
     */
    @isTest
    static void testgetActivityCodeGroupsFilteredEQ() {
        Test.startTest();
        List<Master_Map__c> mapList = new List<Master_Map__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification' AND Description__c = 'Description'
        ];

        mapList = THOR_ItemController.getActivityCodeGroupsFiltered(noti.Id);
        System.assertEquals(1, mapList.size());
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all activity code groups should be retreived
     */
    @isTest
    static void testgetActivityCodeGroupsFilteredEQByNothing() {
        Test.startTest();
        Notification__c noti = new Notification__c();
        noti.Name = '10728301';
        insert noti;

        List<Master_Map__c> mapList = THOR_ItemController.getActivityCodeGroupsFiltered(noti.Id);
        System.assertEquals(1, mapList.size());
        Test.stopTest();
    }
    
    @isTest
    static void testgetActivityCodeGroupsFilteredFL() {
        Test.startTest();
        List<Master_Map__c> mapList = new List<Master_Map__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification2' AND Description__c = 'Description'
        ];

        mapList = THOR_ItemController.getActivityCodeGroupsFiltered(noti.Id);
        System.assertEquals(1, mapList.size());
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all cause should be retreived
     */
    @isTest
    static void testgetCausesFilteredEQ() {
        Test.startTest();
        List<Master_Map__c> mapList = new List<Master_Map__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification' AND Description__c = 'Description'
        ];

        mapList = THOR_ItemController.getCausesFiltered(noti.Id, null);
        System.assertEquals(1, mapList.size());
        Test.stopTest();
    }
    
    @isTest
    static void testgetCausesFilteredFL() {
        Test.startTest();
        List<Master_Map__c> mapList = new List<Master_Map__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification2' AND Description__c = 'Description'
        ];

        mapList = THOR_ItemController.getCausesFiltered(noti.Id, null);
        System.assertEquals(1, mapList.size());
        Test.stopTest();
    }
    
    @isTest
    static void testgetCausesFilteredNone() {
        Test.startTest();
        List<Master_Map__c> mapList = new List<Master_Map__c>();
        List<Master_Map__c> codeGroupList = new List<Master_Map__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification2' AND Description__c = 'Description'
        ];
        noti.Equipment__c = null;
        noti.Functional_Location__c = null;
        codeGroupList = THOR_ItemController.getCauseCodeGroupsFiltered(noti.Id);

        mapList = THOR_ItemController.getCausesFiltered(noti.Id, codeGroupList[0].Id);
        System.assertEquals(1, mapList.size());
        Test.stopTest();
    }
    

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all cause should be retreived
     */
    @isTest
    static void testgetActivitiesFiltered() {
        Test.startTest();
        List<Master_Map__c> mapList = new List<Master_Map__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification' AND Description__c = 'Description'
        ];

        mapList = THOR_ItemController.getActivitiesFiltered(noti.Id, null);
        System.assertEquals(1, mapList.size());
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all cause should be retreived
     */
    @isTest
    static void testgetCausesRelatedToItem() {
        Test.startTest();
        List<Cause__c> causeList = new List<Cause__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification' AND Description__c = 'Description'
        ];
        Item__c ite = [SELECT Id FROM Item__c WHERE Notification__c = :noti.Id AND Text__c = 'Test Item'];

        causeList = THOR_ItemController.getCausesRelatedToItem(ite.Id);

        List<Cause__c> cList = [SELECT Id FROM Cause__c WHERE Item__c = :ite.Id AND isDeleted__c = false];
        System.assertEquals(clist.size(), causeList.size());
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then cause should be deleted
     */
    @isTest
    static void testdeleteCause() {
        Cause__c causeToDelete = [SELECT Id, isDeleted FROM Cause__c LIMIT 1];

        Test.startTest();

        THOR_ItemController.deleteCause(causeToDelete.Id);
        Cause__c isCauseToDelete = [SELECT Id, isDeleted, isDeleted__c FROM Cause__c WHERE Id = :causeToDelete.Id ALL ROWS];
        //System.assertEquals(true, isCauseToDelete.IsDeleted);
        System.assertEquals(true, isCauseToDelete.isDeleted__c);

        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then activity should be deleted
     */
    @isTest
    static void testdeleteActivity() {
        Activity__c activityToDelete = [SELECT Id, isDeleted FROM Activity__c LIMIT 1];

        Test.startTest();

        THOR_ItemController.deleteActivity(activityToDelete.Id);
        Activity__c isActivityToDelete = [
            SELECT Id, isDeleted, isDeleted__c
            FROM Activity__c
            WHERE Id = :activityToDelete.Id
            ALL ROWS
        ];
        //System.assertEquals(true, isActivityToDelete.IsDeleted);
        System.assertEquals(true, isActivityToDelete.IsDeleted__c);

        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all activities should be retreived
     */
    @isTest
    static void testgetActivitiesRelatedToItem() {
        Test.startTest();
        List<Activity__c> activityList = new List<Activity__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification' AND Description__c = 'Description'
        ];
        Item__c ite = [SELECT Id FROM Item__c WHERE Notification__c = :noti.Id AND Text__c = 'Test Item'];

        activityList = THOR_ItemController.getActivitiesRelatedToItem(ite.Id);

        List<Activity__c> aList = [SELECT Id FROM Activity__c WHERE Item__c = :ite.Id AND isDeleted__c = false];
        System.assertEquals(alist.size(), activityList.size());
        Test.stopTest();
    }

    /**
     * @given an Item with related Causes
     * @when the service to retrieve Item Causes is invoked
     * @then all non deleted Item Causes should be retrieved
     */
    @isTest
    static void testRetrieveItemCauses() {
        Item__c existingItem = getItem();
        Test.startTest();
        List<THOR_ObjectCardDTO> retrievedItemCauses = Thor_ItemController.retrieveItemCauses(existingItem.Id);
        Test.stopTest();

        System.assertEquals(5, retrievedItemCauses.size(), 'All non-deleted Item Causes should have been retrieved');
    }

    /**
     * @given an Item with related Activities
     * @when the service to retrieve Item Activities is invoked
     * @then all non deleted Item Activities should be retrieved
     */
    @isTest
    static void testRetrieveItemActivities() {
        Item__c existingItem = getItem();
        Test.startTest();
        List<THOR_ObjectCardDTO> retrievedItemActivities = Thor_ItemController.retrieveItemActivities(existingItem.Id);
        Test.stopTest();

        System.assertEquals(
            5,
            retrievedItemActivities.size(),
            'All non-deleted Item Causes should have been retrieved'
        );
    }

    /**
     * @given an Item with Causes and Activities and a service to mark the Item as deleted
     * @when the service is invoked
     * @then Item and it's related Causes and Activities are marked as deleted
     */
    @isTest
    static void testMarkItemAsDeleted() {
        Item__c existingItem = getItem();

        Test.startTest();
        Thor_ItemController.markItemAsDeleted(existingItem.Id);
        Test.stopTest();

        Item__c itemMarkedAsDeleted = getItem();
        System.assert(itemMarkedAsDeleted.isDeleted__c, 'Item should have been marked as deleted');

        List<Cause__c> itemCauses = getCausesByItemId(existingItem.Id);
        for (Integer i = 0; i < itemCauses.size(); i++) {
            System.assert(itemCauses.get(i).isDeleted__c, 'Cause should have been marked as deleted');
        }
        List<Activity__c> itemActivities = getActivitiesByItemId(existingItem.Id);
        for (Integer i = 0; i < itemActivities.size(); i++) {
            System.assert(itemActivities.get(i).isDeleted__c, 'Activity should have been marked as deleted');
        }
    }

    @isTest
    static void testSearchCodeGroups() {
        List<Master_Map__c> exampleMM = [SELECT Id, Code__c, Type__c, Description__c FROM Master_Map__c WHERE Type__c = 'Code Group'];
        String exampleSearchTrue = 'IEC-133';
        String ExampleSearchFalse = 'WWWW';

        Test.startTest();
        List<Master_Map__c> searchResults = Thor_ItemController.searchCodeGroups(exampleSearchTrue, exampleMM);
        List<Master_Map__c> emptyResults = Thor_ItemController.searchCodeGroups(exampleSearchFalse, exampleMM);
        Test.stopTest();

        System.assertEquals(
            1,
            searchResults.size(),
            'Search should have found one result'
        );
        System.assertEquals(
            0,
            emptyResults.size(),
            'No results should have been found'
        );

    }

    @isTest
    static void testSearchCauses() {
        List<Master_Map__c> exampleMM = [SELECT Id, Code__c, Type__c, Description__c FROM Master_Map__c WHERE Type__c = 'CatelogCause'];
        String exampleSearchTrue = 'Loose';
        String ExampleSearchFalse = 'WWWW';

        Test.startTest();
        List<Master_Map__c> searchResults = Thor_ItemController.searchCodeGroups(exampleSearchTrue, exampleMM);
        List<Master_Map__c> emptyResults = Thor_ItemController.searchCodeGroups(exampleSearchFalse, exampleMM);
        Test.stopTest();

        System.assertEquals(
            1,
            searchResults.size(),
            'Search should have found one result'
        );
        System.assertEquals(
            0,
            emptyResults.size(),
            'No results should have been found'
        );
    }

    @isTest
    static void testSearchActivities() {
        List<Master_Map__c> exampleMM = [SELECT Id, Code__c, Type__c, Description__c FROM Master_Map__c WHERE Type__c = 'CatelogActivity'];
        String exampleSearchTrue = 'Tighten';
        String ExampleSearchFalse = 'WWWW';

        Test.startTest();
        List<Master_Map__c> searchResults = Thor_ItemController.searchCodeGroups(exampleSearchTrue, exampleMM);
        List<Master_Map__c> emptyResults = Thor_ItemController.searchCodeGroups(exampleSearchFalse, exampleMM);
        Test.stopTest();

        System.assertEquals(
            1,
            searchResults.size(),
            'Search should have found one result'
        );
        System.assertEquals(
            0,
            emptyResults.size(),
            'No results should have been found'
        );
    }

    private static Item__c getItem() {
        return [SELECT Id, isDeleted__c FROM Item__c];
    }

    private static List<Cause__c> getCausesByItemId(Id itemId) {
        return [SELECT Id, isDeleted__c FROM Cause__c WHERE Id = :itemId];
    }

    private static List<Activity__c> getActivitiesByItemId(Id itemId) {
        return [SELECT Id, isDeleted__c FROM Activity__c WHERE Id = :itemId];
    }

    //Object Part Code Group
    @isTest
    public static void testGetObjectPartCodeGroupEquipmentAndFL(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        //Catelog Profile
        Master_Map__c catelogEquipment = new Master_Map__c(Name='ELEC-0002',Description__c='EquipmentCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogEquipment;

        Equipment__c equipment =  new Equipment__c(Name='EquipmentTest',CatelogProfile__c = catelogEquipment.id);
        insert equipment;
        Functional_Location__c functionalLocation = new Functional_Location__c();
        insert functionalLocation;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='ObjectPart', RelatedMasterMap1__c=catelogEquipment.id, RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Equipment__c = equipment.id;
        notification.Functional_Location__c = functionalLocation.id;
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> objectPartCodeGroups = THOR_ItemController.getObjectPartCodeGroup(notification.Id);

        System.assertEquals(
            1,
            objectPartCodeGroups.size(),
            'The Object Part Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    @isTest
    public static void testGetObjectPartCodeGroupFL(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        //Catelog Profile
        Master_Map__c catelogFunctional = new Master_Map__c(Name='ELEC-0005',Description__c='FLCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogFunctional;

        Functional_Location__c functionalLocation = new Functional_Location__c(CatelogProfile__c=catelogFunctional.id);
        insert functionalLocation;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='ObjectPart', RelatedMasterMap1__c=catelogFunctional.id, RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Functional_Location__c = functionalLocation.id;
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> objectPartCodeGroups = THOR_ItemController.getObjectPartCodeGroup(notification.Id);

        System.assertEquals(
            1,
            objectPartCodeGroups.size(),
            'The Object Part Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    @isTest
    public static void testGetObjectPartCodeGroupFLEquipmentNoCatelog(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        //Catelog Profile
        Master_Map__c catelogFunctional = new Master_Map__c(Name='ELEC-0005',Description__c='FLCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogFunctional;

        Equipment__c equipment =  new Equipment__c();
        insert equipment;
        Functional_Location__c functionalLocation = new Functional_Location__c(CatelogProfile__c=catelogFunctional.id);
        insert functionalLocation;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='ObjectPart', RelatedMasterMap1__c=catelogFunctional.id, RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Functional_Location__c = functionalLocation.id;
        notification.Equipment__c = equipment.id;
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> objectPartCodeGroups = THOR_ItemController.getObjectPartCodeGroup(notification.Id);

        System.assertEquals(
            1,
            objectPartCodeGroups.size(),
            'The Object Part Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    @isTest
    public static void testGetObjectPartCodeGroupFLEquipmentNoRows(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        //Catelog Profile
        Master_Map__c catelogFunctional = new Master_Map__c(Name='ELEC-0005',Description__c='FLCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogFunctional;
        Master_Map__c catelogEquipment = new Master_Map__c(Name='ELEC-0002',Description__c='EquipmentCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogEquipment;

        Equipment__c equipment =  new Equipment__c(CatelogProfile__c = catelogEquipment.id);
        insert equipment;
        Functional_Location__c functionalLocation = new Functional_Location__c(CatelogProfile__c=catelogFunctional.id);
        insert functionalLocation;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='ObjectPart', RelatedMasterMap1__c=catelogFunctional.id, RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Functional_Location__c = functionalLocation.id;
        notification.Equipment__c = equipment.id;
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> objectPartCodeGroups = THOR_ItemController.getObjectPartCodeGroup(notification.Id);

        System.assertEquals(
            1,
            objectPartCodeGroups.size(),
            'The Object Part Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    @isTest
    public static void testGetObjectPartCodeGroupNoFilter(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='ObjectPart', Type__c='CatalogType', RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> objectPartCodeGroups = THOR_ItemController.getObjectPartCodeGroup(notification.Id);

        System.assertEquals(
            1,
            objectPartCodeGroups.size(),
            'The Object Part Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    @isTest
    public static void testGetObjectPartCodeGroupNoFilterEquipmentAndFL(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        Equipment__c equipment =  new Equipment__c();
        insert equipment;
        Functional_Location__c functionalLocation = new Functional_Location__c();
        insert functionalLocation;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='ObjectPart', Type__c='CatalogType', RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Functional_Location__c = functionalLocation.id;
        notification.Equipment__c = equipment.id;
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> objectPartCodeGroups = THOR_ItemController.getObjectPartCodeGroup(notification.Id);

        System.assertEquals(
            1,
            objectPartCodeGroups.size(),
            'The Object Part Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    @isTest
    public static void testGetObjectPartCodeGroupNoFilterEquipmentAndFLNoRows(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        Master_Map__c catelogFunctional = new Master_Map__c(Name='ELEC-0005',Description__c='FLCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogFunctional;
        Master_Map__c catelogEquipment = new Master_Map__c(Name='ELEC-0002',Description__c='EquipmentCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogEquipment;

        Equipment__c equipment =  new Equipment__c(CatelogProfile__c = catelogEquipment.id);
        insert equipment;
        Functional_Location__c functionalLocation = new Functional_Location__c(CatelogProfile__c=catelogFunctional.id);
        insert functionalLocation;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='ObjectPart', Type__c='CatalogType', RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Functional_Location__c = functionalLocation.id;
        notification.Equipment__c = equipment.id;
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> objectPartCodeGroups = THOR_ItemController.getObjectPartCodeGroup(notification.Id);

        System.assertEquals(
            1,
            objectPartCodeGroups.size(),
            'The Object Part Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    //Object Part Code
    @isTest
    public static void testObjectCodeEquipmentAndFL(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        Master_Map__c objectPartCodeGroup = new Master_Map__c(Master_Map_Set__c = mms.id);
        insert objectPartCodeGroup;
        Master_Map__c data2 = new Master_Map__c(Master_Map_Set__c = mms.id);
        insert data2;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, RelatedMasterMap1__c=objectPartCodeGroup.id, RelatedMasterMap2__c=data2.id, Type__c='CatelogObjectPart');
        insert data1;
        
        List<Master_Map__c> objectPartCode = THOR_ItemController.getObjectPartCode(objectPartCodeGroup.Id);

        System.assertEquals(
            1,
            objectPartCode.size(),
            'The Object Part Code is not being retrieved correctly'
        );
        Test.stopTest();
    }

    //Damage Code Group
    @isTest
    public static void testGetDamageCodeGroupEquipmentAndFL(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        //Catelog Profile
        Master_Map__c catelogEquipment = new Master_Map__c(Name='ELEC-0002',Description__c='EquipmentCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogEquipment;

        Equipment__c equipment =  new Equipment__c(CatelogProfile__c = catelogEquipment.id);
        insert equipment;
        Functional_Location__c functionalLocation = new Functional_Location__c();
        insert functionalLocation;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='Damage', RelatedMasterMap1__c=catelogEquipment.id, RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Equipment__c = equipment.id;
        notification.Functional_Location__c = functionalLocation.id;
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> damageCodeGroups = THOR_ItemController.getDamageCodeGroup(notification.Id);

        System.assertEquals(
            1,
            damageCodeGroups.size(),
            'The Damage Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    @isTest
    public static void testGetDamageCodeGroupFL(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        //Catelog Profile
        Master_Map__c catelogFunctional = new Master_Map__c(Name='ELEC-0005',Description__c='FLCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogFunctional;

        Functional_Location__c functionalLocation = new Functional_Location__c(CatelogProfile__c=catelogFunctional.id);
        insert functionalLocation;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='Damage', RelatedMasterMap1__c=catelogFunctional.id, RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Functional_Location__c = functionalLocation.id;
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> damageCodeGroups = THOR_ItemController.getDamageCodeGroup(notification.Id);

        System.assertEquals(
            1,
            damageCodeGroups.size(),
            'The Damage Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    @isTest
    public static void testGetDamageCodeGroupFLEquipmentNoCatelog(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        //Catelog Profile
        Master_Map__c catelogFunctional = new Master_Map__c(Name='ELEC-0005',Description__c='FLCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogFunctional;

        Functional_Location__c functionalLocation = new Functional_Location__c(CatelogProfile__c=catelogFunctional.id);
        insert functionalLocation;
        Equipment__c equipment =  new Equipment__c();
        insert equipment;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='Damage', RelatedMasterMap1__c=catelogFunctional.id, RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Functional_Location__c = functionalLocation.id;
        notification.Equipment__c = equipment.id;
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> damageCodeGroups = THOR_ItemController.getDamageCodeGroup(notification.Id);

        System.assertEquals(
            1,
            damageCodeGroups.size(),
            'The Damage Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    @isTest
    public static void testGetDamageCodeGroupFLEquipmentNoRow(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        //Catelog Profile
        Master_Map__c catelogFunctional = new Master_Map__c(Name='ELEC-0005',Description__c='FLCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogFunctional;
        Master_Map__c catelogEquipment = new Master_Map__c(Name='ELEC-0002',Description__c='EquipmentCatelogProfile', Master_Map_Set__c = mms.id);
        insert catelogEquipment;

        Functional_Location__c functionalLocation = new Functional_Location__c(CatelogProfile__c=catelogFunctional.id);
        insert functionalLocation;
        Equipment__c equipment =  new Equipment__c(CatelogProfile__c = catelogEquipment.id);
        insert equipment;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='Damage', RelatedMasterMap1__c=catelogFunctional.id, RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Functional_Location__c = functionalLocation.id;
        notification.Equipment__c = equipment.id;
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> damageCodeGroups = THOR_ItemController.getDamageCodeGroup(notification.Id);

        System.assertEquals(
            1,
            damageCodeGroups.size(),
            'The Damage Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    @isTest
    public static void testGetDamageCodeGroupNoFilter(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        Master_Map__c eo1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='TestDescription');
        insert eo1;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, Description__c='Damage', Type__c='CatalogType', RelatedMasterMap2__c=eo1.id);
        insert data1;

        Notification__c notification = new Notification__c();
        notification.Description__c = 'This is a test description...';
        //notification.AssignedTo__c = userInfo.getUserId();
        insert notification;

        List<Master_Map__c> damageCodeGroups = THOR_ItemController.getDamageCodeGroup(notification.Id);

        System.assertEquals(
            1,
            damageCodeGroups.size(),
            'The Damage Code Groups is not being retrieved correctly'
        );
        Test.stopTest();
    }

    //Damage Code
    @isTest
    public static void testDamageCodeEquipmentAndFL(){
        Test.startTest();
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;

        Master_Map__c damageCodeGroup = new Master_Map__c(Master_Map_Set__c = mms.id);
        insert damageCodeGroup;
        Master_Map__c data2 = new Master_Map__c(Master_Map_Set__c = mms.id);
        insert data2;
        Master_Map__c data1 = new Master_Map__c(Master_Map_Set__c = mms.id, RelatedMasterMap1__c=damageCodeGroup.id, RelatedMasterMap2__c=data2.id, Type__c='CatelogDamage');
        insert data1;
        
        List<Master_Map__c> damageCode = THOR_ItemController.getDamageCode(damageCodeGroup.Id);

        System.assertEquals(
            1,
            damageCode.size(),
            'The Damage Code is not being retrieved correctly'
        );
        Test.stopTest();
    }

    //Damage Code
    @isTest
    public static void testSearchCodeGroupsByNameAndDescription(){
        Test.startTest();
        List<Master_Map__c> codeGroups = [SELECT Id, Name, Description__c FROM Master_Map__c WHERE Description__c != null AND Name != null];
        
        List<Master_Map__c> filteredCodeGroups = THOR_ItemController.searchCodeGroupsByNameAndDescription('IEA-133', codeGroups);

        System.assertEquals(
            1,
            filteredCodeGroups.size(),
            'The Filtered Code Group is not being retrieved correctly'
        );
        Test.stopTest();
    }

    //Damage Code
    @isTest
    public static void testSearchCodeGroupsByNameAndDescriptionModified(){
        Test.startTest();
        List<Master_Map__c> codeGroups = [SELECT Id, Name, Description__c, RelatedMasterMap2__r.Name FROM Master_Map__c WHERE Description__c != null AND RelatedMasterMap2__c != null];

        List<Master_Map__c> filteredCodeGroups = THOR_ItemController.searchCodeGroupsByNameAndDescriptionModified('IEA-133', codeGroups);

        System.assertEquals(
            1,
            filteredCodeGroups.size(),
            'The Filtered Code Group is not being retrieved correctly'
        );
        Test.stopTest();
    }

    

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all cause should be retreived
     */
    @isTest
    static void testgetCauses() {
        Test.startTest();
        List<Cause__c> causeList = new List<Cause__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification' AND Description__c = 'Description'
        ];
        Item__c ite = [SELECT Id FROM Item__c WHERE Notification__c = :noti.Id AND Text__c = 'Test Item'];

        causeList = THOR_ItemController.getCauses(ite.Id);

        List<Cause__c> cList = [SELECT Id FROM Cause__c WHERE Item__c = :ite.Id AND isDeleted__c = false];
        System.assertEquals(clist.size(), causeList.size());
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all activities should be retreived
     */
    @isTest
    static void testgetActivities() {
        Test.startTest();
        List<Activity__c> activityList = new List<Activity__c>();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification' AND Description__c = 'Description'
        ];
        Item__c ite = [SELECT Id FROM Item__c WHERE Notification__c = :noti.Id AND Text__c = 'Test Item'];

        activityList = THOR_ItemController.getActivities(ite.Id);

        List<Activity__c> aList = [SELECT Id FROM Activity__c WHERE Item__c = :ite.Id AND isDeleted__c = false];
        System.assertEquals(alist.size(), activityList.size());
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all activities should be retreived
     */
    @isTest
    static void testgetItemById() {
        Test.startTest();
        Item__c ite = [SELECT Id, Name FROM Item__c WHERE Text__c = 'Test Item' LIMIT 1];
        Item__c item = THOR_ItemController.getItemById(ite.Id);

        System.assertEquals(ite.Name, item.Name);
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all activities should be retreived
     */
    @isTest
    static void testgetCauseById() {
        Test.startTest();
        Cause__c cau = [SELECT Id, Name FROM Cause__c WHERE Text__c = 'Cause1' LIMIT 1];

        Cause__c cause = THOR_ItemController.getCauseById(cau.Id);

        System.assertEquals(cau.Name, cause.Name);
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all activities should be retreived
     */
    @isTest
    static void testgetActivityById() {
        Test.startTest();
        Activity__c act = [SELECT Id, Name FROM Activity__c WHERE Text__c = 'Activity1' LIMIT 1];

        Activity__c activity = THOR_ItemController.getActivityById(act.Id);

        System.assertEquals(act.Name, activity.Name);
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all activities should be retreived
     */
    @isTest
    static void testsendToSAP() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new THOR_IRPAMock());
        
        THORIntegration__c cs =new THORIntegration__c();
        cs.iRPA_Client_Id__c = 'sb-d73afc64-431a-4de2-a617-906f7c41942c!b14053|sapmlirpa--irpatrial--trial--uaa-service-broker!b3516';
        cs.iRPA_Client_Secret_Id__c = 'ikiVy26FO2hT1r1gZ/MfOh4MrnI=';
        cs.iRPA_Token_Endpoint__c = 'https://1aa5670atrial.authentication.us10.hana.ondemand.com/oauth/token';
        cs.iRPA_Item_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/379306a7-6d2f-4e41-a453-a97571d2ae46/runs';
        cs.iRPA_API_Key_Header__c = 'irpa-api-key';
        cs.iRPA_API_Key__c = 's_Xcdb1AHvP3NSkcTjl7JqlEdf-OtU3A';
        
        insert cs;

        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification' AND Description__c = 'Description'
        ];
        Item__c ite = [SELECT Id FROM Item__c WHERE Notification__c = :noti.Id AND Text__c = 'Test Item'];

        THOR_ItemController.sendToSAP(ite.Id);
        Test.stopTest();
    }

    /**
     * @given an Item Id
     * @when a cause is being created from Notification > Related > add Item
     * @then all activities should be retreived
     */
    @isTest
    static void testUpdateAndDeleteItem() {
        Test.startTest();
        Notification__c noti = [
            SELECT Id
            FROM Notification__c
            WHERE Name = 'Test Notification' AND Description__c = 'Description'
        ];
        Item__c ite = new Item__c();
        ite.Notification__c = noti.Id;
        insert ite;

        ite.Text__c = 'Test Item 2';
        update ite;

        delete ite;
        Test.stopTest();
    }
}