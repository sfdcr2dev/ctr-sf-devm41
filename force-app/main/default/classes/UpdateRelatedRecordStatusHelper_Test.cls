@isTest
public with sharing class UpdateRelatedRecordStatusHelper_Test {
    @isTest
    public static void givenNotificationAndStatusSetWhenCallingUpdateRecordStatusExepectArrayOfNotification() {
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;
        Master_Map_Set__c mms2 = new Master_Map_Set__c();
        insert mms2;
        Master_Map_Set__c mms3 = new Master_Map_Set__c();
        insert mms3;

        Master_Map__c mm = new Master_Map__c();
        mm.name = 'OSNO';
        mm.Master_Map_Set__c = mms.id;
        insert mm;

        Master_Map__c mm2 = new Master_Map__c();
        mm2.name = 'NOCO';
        mm2.Master_Map_Set__c = mms2.id;
        insert mm2;

        Master_Map__c mm3 = new Master_Map__c();
        mm3.name = 'NOPR';
        mm3.Master_Map_Set__c = mms3.id;
        insert mm3;

        Notification__c n = new Notification__c();
        n.Type__c = 'SH';
        n.Description__c = 'Desc test 1';
        n.Priority__c = 'Normal';
        n.Requested_Date__c = Date.today();
        n.Notification_Status_Set__c = mms.id;
        insert n;

        Notification__c n2 = new Notification__c();
        n2.Type__c = 'SH';
        n2.Description__c = 'Desc test 1';
        n2.Priority__c = 'Normal';
        n2.Requested_Date__c = Date.today();
        n2.AssignedTo__c = UserInfo.getUserId();
        n2.Notification_Status_Set__c = mms2.id;
        n2.System_Status_Text__c = 'NOPR';
        n2.Notification_Status__c = 'In Progress';

        insert n2;

        Notification__c n3 = new Notification__c();
        n3.Type__c = 'SH';
        n3.Description__c = 'Desc test 1';
        n3.Priority__c = 'Normal';
        n3.Requested_Date__c = Date.today();
        n3.Notification_Status_Set__c = mms3.id;
        insert n3;
        n3.Fault_Code__c = mm3.id;
        update n3;
        n3.System_Status_Text__c = 'NOCO';
        n3.Notification_Status__c = 'Closed';
        update n3;

        List<Notification__c> notificationsNew = [SELECT id FROM Notification__c WHERE Notification_Status__c = 'New'];
        List<Notification__c> notificationsProgress = [
            SELECT id
            FROM Notification__c
            WHERE Notification_Status__c = 'In Progress'
        ];
        List<Notification__c> notificationsClosed = [
            SELECT id
            FROM Notification__c
            WHERE Notification_Status__c = 'Closed'
        ];

        System.assertEquals(1, notificationsNew.size(), 'Number of new notifications <> 1');
        System.assertEquals(1, notificationsProgress.size(), 'Number of in progress notifications <> 1');
        System.assertEquals(1, notificationsClosed.size(), 'Number of closed notifications <> 1');
    }

    @isTest
    public static void givenOrderAndStatusSetWhenCallingUpdateRecordStatusExepectArrayOfOrder() {
        Master_Map_Set__c mms = new Master_Map_Set__c();
        insert mms;
        Master_Map_Set__c mms2 = new Master_Map_Set__c();
        insert mms2;

        Order__c o = new Order__c();
        o.Description__c = 'Lorem Ipsum 3';
        o.Order_Status__c = 'New';
        o.System_Status_Text__c = 'CRTD';
        o.Requested_Date__c = Date.today();
        insert o;

        Order__c o2 = new Order__c();
        o2.Description__c = 'Lorem Ipsum 4';
        o2.Order_Status__c = 'New';
        o.System_Status_Text__c = 'CRTD';
        o2.Requested_Date__c = Date.today();
        insert o2;
        o2.System_Status_Text__c = 'REL';
        o2.Order_Status__c = 'In Progress';
        update o2;

        Order__c o3 = new Order__c();
        o3.Description__c = 'Lorem Ipsum 4';
        o3.Order_Status__c = 'New';
        o.System_Status_Text__c = 'CRTD';
        o3.Requested_Date__c = Date.today();
        insert o3;
        o3.System_Status_Text__c = 'TECO';
        o3.Order_Status__c = 'Closed';
        update o3;

        Master_Map__c mm = new Master_Map__c();
        mm.name = 'REL';
        mm.Master_Map_Set__c = mms.id;
        insert mm;

        Master_Map__c mm2 = new Master_Map__c();
        mm2.name = 'TECO';
        mm2.Master_Map_Set__c = mms2.id;
        insert mm2;

        List<Order__c> ordersNew = [SELECT id FROM Order__c WHERE Order_Status__c = 'New'];

        List<Order__c> ordersProgress = [SELECT id FROM Order__c WHERE Order_Status__c = 'In Progress'];

        List<Order__c> ordersClose = [SELECT id FROM Order__c WHERE Order_Status__c = 'Closed'];

        System.assert(ordersNew.size() == 1, 'Number of new orders = ' + ordersNew.size());
        System.assert(ordersProgress.size() == 1, 'Number of in progress orders = ' + ordersProgress.size());
        System.assert(ordersClose.size() == 1, 'Number of close orders = ' + ordersClose.size());
    }
}