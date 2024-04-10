/**
 * @author Oktana
 * @description test class for PB 'Notification_Process'
 */
@isTest
public class NotificationProcessTest {
    /**
     * @given PB Notification_Process
     * @when a Notification is updated and assigned to another User
     * @then the User becomes the Notification's Owner
     */
    @IsTest
    private static void testUpdateOwnerAfterReassigningNotification() {
        User testUser = createUser();
        Notification__c notification = buildNotification();
        insert notification;
        Test.startTest();
        System.runAs(testUser) {
            notification.AssignedTo__c = testUser.Id;
            update notification;
        }
        Test.stopTest();

        Notification__c updatedNotification = getNotification();
        System.assertEquals(
            updatedNotification.OwnerId,
            testUser.Id,
            'Notification Owner should have been updated to the User it was assigned to'
        );
    }

    /**
     * @given PB Notification_Process
     * @when a Notification is updated and not reassigned
     * @then Notification's Owner is not updated
     */
    @IsTest
    private static void testOwnerNotUpdateWhenNotReassigningNotification() {
        User testUser = createUser();
        Notification__c notification = buildNotification();
        insert notification;
        Test.startTest();
        System.runAs(testUser) {
            notification.Description__c = 'Another description';
            update notification;
        }
        Test.stopTest();

        Notification__c updatedNotification = getNotification();
        System.assertEquals(
            UserInfo.getUserId(),
            updatedNotification.OwnerId,
            'Notification Owner should not have been updated'
        );
    }

    /**
     * @given PB Notification_Process
     * @when a Notification is created
     * @then Notification's Main Work Center Text is updated
     */
    @IsTest
    private static void testMWCTextNameUpdateWhenCreatingNotification() {
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        Master_Map__c masterMapMWC = new Master_Map__c(
            Name = 'ENMA-E',
            Code__c = 'ENMA-E',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = masterMapSet.Id
        );
        insert masterMapMWC;

        Notification__c notification = buildNotification();

        notification.Main_Work_Center__c = masterMapMWC.Id;

        Test.startTest();
        insert notification;
        Test.stopTest();

        Notification__c updatedNotification = getNotification();

        System.assertEquals(
            masterMapMWC.Name,
            updatedNotification.Main_Work_Center_Text__c,
            'Main Work Center Name was not updated'
        );
    }

    /**
     * @given PB Notification_Process
     * @when a Notification is updated
     * @then Notification's Main Work Center Text is updated
     */
    @IsTest
    private static void testMWCTextNameUpdateWhenUpdatingNotification() {
        Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

        Master_Map__c masterMapMWC = new Master_Map__c(
            Name = 'ENMA-E',
            Code__c = 'ENMA-E',
            Type__c = 'Main Work Center',
            Master_Map_Set__c = masterMapSet.Id
        );
        insert masterMapMWC;

        Notification__c notification = buildNotification();

        insert notification;

        notification.Main_Work_Center__c = masterMapMWC.Id;

        Test.startTest();
        update notification;
        Test.stopTest();

        Notification__c updatedNotification = getNotification();

        System.assertEquals(
            masterMapMWC.Name,
            updatedNotification.Main_Work_Center_Text__c,
            'Main Work Center Name was not updated'
        );
    }

    private static Notification__c getNotification() {
        return [
            SELECT
                Id,
                OwnerId,
                AssignedTo__c,
                Notification_Status__c,
                Main_Work_Center_Text__c,
                Main_Work_Center__r.Name
            FROM Notification__c
            LIMIT 1
        ];
    }

    private static Notification__c buildNotification() {
        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            AssignedTo__c = UserInfo.getUserId()
        );

        return notification;
    }

    private static Notification__c buildNewNotificationWithOutUser() {
        Notification__c notification = new Notification__c(
            Name = 'Test Notification',
            Description__c = 'Test Description',
            Notification_Status__c = 'New'
        );

        return notification;
    }

    private static User createUser() {
        //using System Administrator Profile since this is the only one available
        //works with any profile with permissions to access Notification__c and Order__c
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueOf(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(
            FirstName = 'test',
            LastName = 'user',
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator']
            .Id
        );
        insert tuser;
        return tuser;
    }

    /**
     * @given PB Notification_Process
     * @when a Notification is updated and assigned to another User
     * @then the Status becomes In Progress
     */
    @IsTest
    private static void testUpdateStatusAfterReassigningNotification() {
        User testUser = createUser();
        Notification__c notification = buildNewNotificationWithOutUser();
        insert notification;
        Test.startTest();
        System.runAs(testUser) {
            notification.AssignedTo__c = testUser.Id;
            update notification;
        }
        Test.stopTest();

        Notification__c updatedNotification = getNotification();
        System.assertEquals(
            updatedNotification.Notification_Status__c,
            'In Progress',
            'Notification Status should have been updated to In Progress'
        );
    }
}