/**
 * @author Sebastian Bucalo, Jose Mascaro
 * @description test class for PB 'Update_Notification_Status'
 */
@isTest
public with sharing class UpdateNotificationStatusProcess_Test {
    /**
     * @given PB Update_Notification_Status
     * @when A Notification is created with System_status_text__c = 'OSNO'
     * @then Notification status changes to New
     */
    @IsTest
    private static void testUpdateStatusAfterCreateOSNO() {
        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            System_Status_Text__c = 'OSNO'
        );
        Test.startTest();
        insert notification;
        Test.stopTest();
        Notification__c insertedNotification = [
            SELECT Id, System_status_text__c, Notification_Status__c
            FROM Notification__c
            WHERE Id = :notification.Id
        ];
        System.assertEquals(
            'New',
            insertedNotification.Notification_Status__c,
            'Notification status was not updated to New'
        );
    }

    /**
     * @given PB Update_Notification_Status
     * @when A Notification is created with An User Assigned
     * @then Notification status changes to In Progress
     */
    @IsTest
    private static void testUpdateStatusAfterCreateNOPR() {
        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            AssignedTo__c = UserInfo.getUserId(),
            System_Status_Text__C = 'NOPR'
        );

        Test.startTest();
        insert notification;
        Test.stopTest();

        Notification__c insertedNotification = [
            SELECT Id, System_status_text__c, Notification_Status__c
            FROM Notification__c
            WHERE Id = :notification.Id
        ];
        System.assertEquals(
            'In Progress',
            insertedNotification.Notification_Status__c,
            'Notification status was not updated to In Progress'
        );
    }

    /**
     * @given PB Update_Notification_Status
     * @when System status text changes
     * @then Notification status changes to In Progress
     */
    @IsTest
    private static void testUpdateStatusAfterUpdateToOSNO() {
        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            System_status_text__c = ''
        );
        insert notification;
        Notification__c insertedNotification = [
            SELECT Id, System_status_text__c, Notification_Status__c
            FROM Notification__c
            WHERE Id = :notification.Id
        ];
        insertedNotification.System_status_text__c = 'OSNO';
        Test.startTest();
        update insertedNotification;
        Test.stopTest();
        Notification__c updatedNotification = [
            SELECT Id, System_status_text__c, Notification_Status__c
            FROM Notification__c
            WHERE Id = :notification.Id
        ];
        System.assertEquals(
            'New',
            updatedNotification.Notification_Status__c,
            'Notification status was not updated to New'
        );
    }

    /**
     * @given PB Update_Notification_Status
     * @when System status text changes (adds NOPR)
     * @then Notification status changes to In Progress
     */
    @IsTest
    private static void testUpdateStatusAfterUpdateToNOPR() {
        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            AssignedTo__c = UserInfo.getUserId()
        );
        insert notification;
        Notification__c insertedNotification = [
            SELECT Id, System_status_text__c, Notification_Status__c
            FROM Notification__c
            WHERE Id = :notification.Id
        ];

        insertedNotification.System_status_text__c = 'NOPR';

        Test.startTest();
        update insertedNotification;
        Test.stopTest();

        Notification__c updatedNotification = [
            SELECT Id, System_status_text__c, Notification_Status__c
            FROM Notification__c
            WHERE Id = :notification.Id
        ];
        System.assertEquals(
            'In Progress',
            updatedNotification.Notification_Status__c,
            'Notification status was not updated to In Progress'
        );
    }
    @isTest
    private static void testUpdateNotificationStatusAfterUpdateToNOCO() {
        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            System_status_text__c = 'OSNO'
        );
        insert notification;
        Notification__c insertedNotification = [
            SELECT Id, System_status_text__c, Notification_Status__c
            FROM Notification__c
            WHERE Id = :notification.Id
        ];

        Master_Map__c faultCode = getFaultCode();

        insertedNotification.AssignedTo__c = null;
        insertedNotification.System_Status_Text__c = 'NOCO';
        insertedNotification.Fault_Code__c = faultCode.Id;

        Test.startTest();
        update insertedNotification;
        Test.stopTest();

        Notification__c updatedNotification = [
            SELECT Id, System_status_text__c, Notification_Status__c
            FROM Notification__c
            WHERE Id = :notification.Id
        ];
        System.assertEquals(
            'Closed',
            updatedNotification.Notification_Status__c,
            'Notification status was not updated to Closed'
        );
    }

    /**
     * @given PB Update_Notification_Status
     * @when A Notification is created with An User assigned  and updated to delete that User
     * @then Notification Status goes back to new
     */
    @IsTest
    private static void testUpdateNotificationStatusAfterGoBackToNew() {
        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            AssignedTo__c = UserInfo.getUserId()
        );
        Test.startTest();
        insert notification;
        Test.stopTest();
        Notification__c insertedNotification = [
            SELECT Id, System_status_text__c, Notification_Status__c
            FROM Notification__c
            WHERE Id = :notification.Id
        ];

        insertedNotification.AssignedTo__c = null;
        update insertedNotification;

        insertedNotification = [
            SELECT Id, System_status_text__c, Notification_Status__c
            FROM Notification__c
            WHERE Id = :notification.Id
        ];

        System.assertEquals(
            'New',
            insertedNotification.Notification_Status__c,
            'Notification status was not updated to New'
        );
    }

    private static Master_Map__c getFaultCode() {
        Master_Map_Set__c mSet = new Master_Map_Set__c();
        insert mSet;

        Master_Map__c mMap = new Master_Map__c(Master_Map_Set__c = mSet.Id);

        insert mMap;
        return mMap;
    }
}