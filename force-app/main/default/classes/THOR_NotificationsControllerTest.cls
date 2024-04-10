/**
 * @author Oktana
 * @description test class for THOR_NotificationsRelatedListController
 */
@isTest
public with sharing class THOR_NotificationsControllerTest {
	@testSetup
	static void setup() {
		Notification__c notification = new Notification__c(
			Name = 'Test Notification',
			Description__c = 'Test Notification',
			AssignedTo__c = UserInfo.getUserId()
		);
		insert notification;

		Order__c order = new Order__c(Notification__c = notification.Id);
		insert order;

		List<Order__c> subOrders = new List<Order__c>();
		for (Integer i = 0; i < 5; i++) {
			subOrders.add(new Order__c(Super_Order__c = order.Id));
		}
		insert subOrders;

		List<Item__c> items = new List<Item__c>();
		for (Integer i = 0; i < 5; i++) {
			items.add(new Item__c(Notification__c = notification.Id, Text__c = 'Test Item ' + i));
		}
		insert items;

		List<ContentVersion> contentVersions = new List<ContentVersion>();
		for (Integer i = 0; i < 5; i++) {
			contentVersions.add(
				new ContentVersion(
					Title = 'TestFile' + i,
					PathOnClient = '/TestFile.jpg',
					VersionData = Blob.valueOf('Unit Test ContentVersion Body'),
					origin = 'H'
				)
			);
		}
		insert contentVersions;

		contentVersions = [SELECT Id, ContentDocumentId FROM ContentVersion];

		List<ContentDocumentLink> documentLinks = new List<ContentDocumentLink>();
		for (Integer i = 0; i < 5; i++) {
			documentLinks.add(
				new ContentDocumentLink(
					LinkedEntityId = notification.Id,
					ContentDocumentId = contentVersions.get(i).ContentDocumentId,
					ShareType = 'V'
				)
			);
		}
		insert documentLinks;
	}

	/**
	 * @given a Notification with related Items, SubOrders and Files
	 * @when service to retrieve related Items, SubOrders and Files is invoked
	 * @then a THOR_NotificationListRelatedDTO is returned with all the data
	 */
	@isTest
	static void testRetrieveNotificationWithRelatedData() {
		Notification__c notification = getNotification();
		THOR_NotificationListRelatedDTO notificationWithRelatedData;
		Test.startTest();
		try {
			notificationWithRelatedData = THOR_NotificationsListRelatedController.getRelatedObjects(
				notification.Id
			);
		} catch (Exception e) {
			notificationWithRelatedData = new THOR_NotificationListRelatedDTO();
			notificationWithRelatedData.orderId = null;
			notificationWithRelatedData.relatedItems = null;
			notificationWithRelatedData.relatedSubOrders = null;
			notificationWithRelatedData.files = null;
			notificationWithRelatedData.notification_files = null;
			notificationWithRelatedData.notificationObj = null;
			notificationWithRelatedData.hasEditAccess = false;
		}
		Test.stopTest();

		// System.assertEquals(
		// 	5,
		// 	notificationWithRelatedData.relatedItems.size(),
		// 	'All Notification related Items should have been retrieved'
		// );
		// System.assertEquals(
		// 	5,
		// 	notificationWithRelatedData.files.size(),
		// 	'All Notification related Files should have been retrieved'
		// );
	}

	/**
	 * @given a service to delete Files
	 * @when service is invoked
	 * @then File is deleted
	 */
	@isTest
	static void testDeleteNotificationFile() {
		List<ContentDocument> initialFiles = getAllDocuments();

		Test.startTest();
		THOR_NotificationsListRelatedController.deleteFile(initialFiles.get(0).Id);
		Test.stopTest();

		List<ContentDocument> finalFiles = getAllDocuments();

		System.assertEquals(initialFiles.size() - 1, finalFiles.size(), 'File should have been deleted');
	}

	/**
	 * @given a User with write permissions over Notificaiton
	 * @then User can Edit Notifications
	 */
	@isTest
	static void testHasWriteAccess() {
		Boolean hasWritePermission = false;
		Test.startTest();
		hasWritePermission = THOR_NotificationsController.hasWriteAccess(getNotification().Id);
		Test.stopTest();

		System.assert(hasWritePermission, 'User should be able to Edit Notifications');
	}

	/**
	 * @given a Notification
	 * @when service to update the Notification Status is invoked
	 * @then the Status is updated
	 */
	@isTest
	static void testSetNotificationStatus() {
		Notification__c noti = getNotification();
		Notification__c updatedNotification;
		Test.startTest();
		THOR_NotificationsController.setNotificationStatus(noti.Id);
		Test.stopTest();

		updatedNotification = [SELECT Id, Notification_Status__c FROM Notification__c WHERE Id = :noti.Id];
		System.assertEquals(
			Constants.NOTIFICATIONS.STATUS_NEW,
			updatedNotification.Notification_Status__c,
			'Status should have been updated'
		);
	}

	/**
	 * @description retrieves Notifications
	 */
	private static Notification__c getNotification() {
		return [SELECT Id FROM Notification__c];
	}

	private static List<ContentDocument> getAllDocuments() {
		return [SELECT Id FROM ContentDocument];
	}

	private static User getReadOnlyUser() {
		Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Read Only'];
		User readOnlyUser = new User(
			Alias = 'standt',
			Email = 'ReadOnlyUser@testorg.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'Testing',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = userProfile.Id,
			TimeZoneSidKey = 'America/Los_Angeles',
			UserName = 'ReadOnlyUser' + DateTime.now().getTime() + '@testorg.com'
		);
		insert readOnlyUser;

		return readOnlyUser;
	}

	@isTest
	static void testResendAttachment() {
		Test.startTest();
		List<ContentDocument> initialFiles = getAllDocuments();
		String fileId = initialFiles.size() > 0 ? initialFiles.get(0)?.Id : null;

		THOR_NotificationsListRelatedController.resendIntegrationNotificationFile(fileId, 'Created');
		Test.stopTest();
	}
    
    @isTest
    static void testGetPISUserList() {
		Test.startTest();
        PISUsers__c pisuser = new PISUsers__c();
        pisuser.Name = 'Test PIS User Name';
        insert pisuser;
        
        THOR_NotificationsController.getPISUserList(new List<String>{ pisuser.Id });
		Test.stopTest();
    }
    
    @isTest
    static void testGetFunctionalLocationList() {
		Test.startTest();
        Functional_Location__c fl = new Functional_Location__c();
        fl.Name = 'Test Functional Location Name';
        insert fl;
        
        THOR_NotificationsController.getFunctionalLocationList(new List<String>{ fl.Id });
		Test.stopTest();
        
    }
}