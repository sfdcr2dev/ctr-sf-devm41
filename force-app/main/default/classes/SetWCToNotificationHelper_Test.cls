@isTest
public class SetWCToNotificationHelper_Test {
    @TestSetup
    static void makeData(){
        THOR_MakeMockData.makeMockData();
    }

    /**
     * @given List of Work_Clearance__c
     * @when Work_Clearance__c has related Notification
     * @then related Notifications have their Work_Clearance__r.Id updated
     */
    @isTest
    public static void testUpdateNotification(){
        List<Work_Clearance__c> mockWorkClearance = getMockWorkClearance();
        List<Notification__c> removeWC = getMockNotifications();
        removeWC[0].Work_Clearance__c = null;
        update removeWC;

        Test.startTest();
            SetWCToNotificationHelper.updateNotification(mockWorkClearance);
        Test.stopTest();

        List<Notification__c> actual = getMockNotifications();
        System.assertEquals(
            mockWorkClearance[0].Id,
            actual[0].Work_Clearance__c,
            'Notification should not be null and have a Work_Clearance__r.Id set to related WC'
        );

    }

    private static List<Work_Clearance__c>  getMockWorkClearance(){
        return [SELECT Id, Name, Notification__c, CreatedDate FROM Work_Clearance__c];
    }

    private static List<Notification__c> getMockNotifications(){
        return [SELECT Id, Work_Clearance__c FROM Notification__c];
    }
}