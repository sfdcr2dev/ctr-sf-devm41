@isTest
public class SetLatestWCHelper_Test {
    @TestSetup
    static void makeData(){
        THOR_MakeMockData.makeMockData();
    }

    /**
     * @given List of Work_Clearance__c
     * @when Work_Clearance__c has related Notification and Order
     * @then related Notifications and Orders have their Work_Clearance__r.Id updated
     */
    @isTest
    public static void testUpdateNotificationAndOrder(){
        List<Work_Clearance__c> mockWorkClearance = getMockWorkClearance();

        Test.startTest();
            SetLatestWCHelper.updateNotificationAndOrder(mockWorkClearance,mockWorkClearance);
        Test.stopTest();

        List<Order__c> actualOrder = getMockOrders();
        List<Notification__c> actualNotification = getMockNotifications();

        System.assertEquals(
            mockWorkClearance[0].Id,
            actualOrder[0].Work_Clearance__c,
            'Order should be updated with related Work_Clearance__c'
        );
        System.assertEquals(
            mockWorkClearance[0].Id,
            actualNotification[0].Work_Clearance__c,
            'Notification should be updated with related Work_Clearance__c'
        );
    }
    
    @isTest
    public static void testUpdateNotificationAndOrderWithoutNotification(){
        List<Work_Clearance__c> mockWorkClearanceWithoutNotification = getMockWorkClearanceWithoutNotification();
		List<Work_Clearance__c> mockWorkClearance = getMockWorkClearance();
        Test.startTest();
            SetLatestWCHelper.updateNotificationAndOrder(mockWorkClearance,mockWorkClearanceWithoutNotification);
        Test.stopTest();

        List<Order__c> actualOrder = getMockOrders();
        List<Notification__c> actualNotification = getMockNotifications();

        System.assertEquals(
            mockWorkClearance[0].Id,
            actualOrder[0].Work_Clearance__c,
            'Order should be updated with related Work_Clearance__c'
        );
        System.assertEquals(
            null,
            actualNotification[0].Work_Clearance__c,
            'Notification should be updated with related Work_Clearance__c'
        );
    }
    
    @isTest
    public static void testUpdateNotificationAndOrderWithoutOrder(){
        List<Work_Clearance__c> mockWorkClearanceWithoutOrder = getMockWorkClearanceWithoutOrder();
		List<Work_Clearance__c> mockWorkClearance = getMockWorkClearance();
        Test.startTest();
            SetLatestWCHelper.updateNotificationAndOrder(mockWorkClearance,mockWorkClearanceWithoutOrder);
        Test.stopTest();

        List<Order__c> actualOrder = getMockOrders();
        List<Notification__c> actualNotification = getMockNotifications();

        System.assertEquals(
            null,
            actualOrder[0].Work_Clearance__c,
            'Order should be updated with related Work_Clearance__c'
        );
        System.assertEquals(
            mockWorkClearance[0].Id,
            actualNotification[0].Work_Clearance__c,
            'Notification should be updated with related Work_Clearance__c'
        );
    }

    private static List<Work_Clearance__c> getMockWorkClearance(){
        return [SELECT Id, CreatedDate, Notification__c, Order__c FROM Work_Clearance__c];
    }

    private static List<Order__c> getMockOrders(){
        return [SELECT Id, Work_Clearance__r.Id, Work_Clearance__r.CreatedDate FROM Order__c];
    }

    private static List<Notification__c> getMockNotifications(){
        return [SELECT Id, Work_Clearance__r.Id, Work_Clearance__r.CreatedDate FROM Notification__c];
    }
    
    private static List<Work_Clearance__c> getMockWorkClearanceWithoutNotification(){
        List<Work_Clearance__c> workClearances = [SELECT Id, CreatedDate, Notification__c, Order__c FROM Work_Clearance__c];
        List<Work_Clearance__c> newWorkClearance = new List <Work_Clearance__c>();
        for(Work_Clearance__c workClearance : workClearances){
            workClearance.Notification__c = null;
            newWorkClearance.add(workClearance);
        }
        update newWorkClearance;
        return newWorkClearance;
    }
    private static List<Work_Clearance__c> getMockWorkClearanceWithoutOrder(){
        List<Work_Clearance__c> workClearances = [SELECT Id, CreatedDate, Notification__c, Order__c FROM Work_Clearance__c];
        List<Work_Clearance__c> newWorkClearance = new List <Work_Clearance__c>();
        for(Work_Clearance__c workClearance : workClearances){
            workClearance.Order__c = null;
            newWorkClearance.add(workClearance);
        }
        update newWorkClearance;
        return newWorkClearance;
    }
    
    

}