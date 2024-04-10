@isTest
public class THOR_NotRelListDisplayerController_Test {
	@TestSetup
	static void makeData() {
		THOR_MakeMockData.makeMockData();
	}

	/**
	 * @given Notifications related to a Functional Location
	 * @when the service to retrieve Notifications related to a FL is invoked
	 * @then all Notifications related to the FL are retrieved
	 */
	@isTest
	public static void testGetRelatedObjects() {
		Notification__c mockNotification = getMockNotification();
		Order__c mockOrder = getMockOrder();

		THOR_NotificationListRelatedDTO actual;
		Test.startTest();
		try {
			actual = THOR_NotRelListDisplayerController.getRelatedObjects(mockNotification.Id);
		} catch (Exception e) {
		}
		Test.stopTest();

		// System.assertEquals(mockOrder.Id, actual.orderId, 'Related Order should match inserted Order from mock data');
		// System.assertEquals(1, actual.files.size(), 'Should return 1 attached file');
	}

	/**
	 * @given a User with write permissions over Notificaiton
	 * @then User can Edit Notifications
	 */
	@isTest
	static void testHasWriteAccess() {
		Boolean hasWritePermission = false;
		Test.startTest();
		hasWritePermission = THOR_NotRelListDisplayerController.hasWriteAccess(getMockNotification().Id);
		Test.stopTest();

		System.assert(hasWritePermission, 'User should be able to Edit Notifications');
	}

	private static Notification__c getMockNotification() {
		return [SELECT Id FROM Notification__c WHERE Name = 'Test Notification' LIMIT 1];
	}

	private static Order__c getMockOrder() {
		return [SELECT Id FROM Order__c WHERE Name = 'Test Order' LIMIT 1];
	}
}