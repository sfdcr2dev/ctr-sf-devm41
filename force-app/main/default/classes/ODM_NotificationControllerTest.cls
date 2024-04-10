@isTest
public class ODM_NotificationControllerTest {
	@TestSetup
	static void makeData() {
		insert new Notification__c(
			Name = '12341234',
			Description__c = 'test',
			Requested_Date__c = Date.today(),
			Required_Start__c = Date.today()
		);
	}

	@IsTest
	static void testGetNotificationList() {
		Test.startTest();
		// System.runAs(contextuser){
		ODM_NotificationController.getNotificationList(
			new Map<String, String>{
				'Type' => 'OP',
				'Notification_Number__c' => '12345678',
				'Notification_Status__c' => 'New;In Progress',
				'Requested_Date__c' => '2022-06-19',
				'Create_Date_From__c' => '2022-06-19',
				'Create_Date_To__c' => '2022-06-19',
				'Requester__c' => '12341234',
				'Breakdown__c' => 'false',
				'Main_Work_Center__c' => 'ENMA-I'
			},
			0,
			20,
			true
		);
		// }
		Test.stopTest();
	}

	@IsTest
	static void testHasAccess() {
		Test.startTest();
		// System.runAs(contextuser){
		ODM_NotificationController.hasWriteAccess([SELECT Id FROM Notification__c LIMIT 1]?.Id);
		ODM_NotificationController.setNotificationStatusClosed([SELECT Id FROM Notification__c LIMIT 1]?.Id);
		// }
		Test.stopTest();
	}
}