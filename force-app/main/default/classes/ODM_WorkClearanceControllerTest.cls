@isTest
public class ODM_WorkClearanceControllerTest {
	@TestSetup
	static void makeData() {
		insert new Work_Clearance__c(
			Name = '9012341234',
			Integration_Status__c = 'Success',
			System_Status__c = 'PREP',
			User_Status__c = 'WCCL'
		);
	}

	@IsTest
	static void testGetUser() {
		Test.startTest();
		User u = (User) ODM_WorkClearanceController.getUser();
		System.assertEquals(UserInfo.getUserId(), u.Id);
		Test.stopTest();
	}

	@IsTest
	static void testGetWcList() {
		Test.startTest();

		ODM_WorkClearanceController.getWcList(
			new Map<String, String>{
				'Work_Clearance_Status__c' => 'Created;In Progress',
				'Create_Date_From__c' => '2022-06-01',
				'Create_Date_To__c' => '2022-06-30',
				'Requested_Date_Form__c' => '2022-06-01',
				'Requested_Date_To__c' => '2022-06-30',
				'Clearance_Number__c' => '9012341234',
				'Functional_Location__c' => 'Test',
				'Notification_Number__c' => '1234',
				'Notification_Type__c' => 'New',
				'Order_Number__c' => '4321',
				'Order_Type__c' => 'New',
				'Requester__c' => 'Test user',
				'Priority__c' => 'Normal;Urgent',
				'Created_By__c' => 'test',
				'Area__c' => 'test'
			},
			20,
			0,
			true
		);
		ODM_WorkClearanceController.getWcList(
			new Map<String, String>{
				'Work_Clearance_Status__c' => 'Created;In Progress',
				'Create_Date_From__c' => '2022-06-01',
				'Create_Date_To__c' => '2022-06-30',
				'Requested_Date_Form__c' => '2022-06-01',
				'Requested_Date_To__c' => '2022-06-30',
				'Clearance_Number__c' => '9012341234',
				'Functional_Location__c' => 'Test',
				'Notification_Number__c' => '1234',
				'Notification_Type__c' => 'New',
				'Order_Number__c' => '4321',
				'Order_Type__c' => 'New',
				'Requester__c' => 'Test user',
				'Priority__c' => 'Normal;Urgent',
				'Created_By__c' => 'test',
				'Area__c' => 'test'
			},
			20,
			0,
			false
		);

		Test.stopTest();
	}

	@IsTest
	static void testGetWcVerificationList() {
		Test.startTest();

		ODM_WorkClearanceController.getWcVerificationList(
			new Map<String, String>{
				'Work_Clearance_Status__c' => 'Created;In Progress',
				'Create_Date_From__c' => '2022-06-01',
				'Create_Date_To__c' => '2022-06-30',
				'Requested_Date_Form__c' => '2022-06-01',
				'Requested_Date_To__c' => '2022-06-30',
				'Clearance_Number__c' => '9012341234',
				'Functional_Location__c' => 'Test',
				'Notification_Number__c' => '1234',
				'Notification_Type__c' => 'New',
				'Order_Number__c' => '4321',
				'Order_Type__c' => 'New',
				'Requester__c' => 'Test user',
				'Priority__c' => 'Normal;Urgent',
				'Created_By__c' => 'test'
			},
			20,
			0,
			true
		);
		ODM_WorkClearanceController.getWcVerificationList(
			new Map<String, String>{
				'Work_Clearance_Status__c' => 'Created;In Progress',
				'Create_Date_From__c' => '2022-06-01',
				'Create_Date_To__c' => '2022-06-30',
				'Requested_Date_Form__c' => '2022-06-01',
				'Requested_Date_To__c' => '2022-06-30',
				'Clearance_Number__c' => '9012341234',
				'Functional_Location__c' => 'Test',
				'Notification_Number__c' => '1234',
				'Notification_Type__c' => 'New',
				'Order_Number__c' => '4321',
				'Order_Type__c' => 'New',
				'Requester__c' => 'Test user',
				'Priority__c' => 'Normal;Urgent',
				'Created_By__c' => 'test'
			},
			20,
			0,
			false
		);

		Test.stopTest();
	}

	@IsTest
	static void testGetWcVerificationAllList() {
		Test.startTest();

		ODM_WorkClearanceController.getWcVerificationAllList(
			new Map<String, String>{
				'Work_Clearance_Status__c' => 'Created;In Progress',
				'Create_Date_From__c' => '2022-06-01',
				'Create_Date_To__c' => '2022-06-30',
				'Requested_Date_Form__c' => '2022-06-01',
				'Requested_Date_To__c' => '2022-06-30',
				'Clearance_Number__c' => '9012341234',
				'Functional_Location__c' => 'Test',
				'Notification_Number__c' => '1234',
				'Notification_Type__c' => 'New',
				'Order_Number__c' => '4321',
				'Order_Type__c' => 'New',
				'Requester__c' => 'Test user',
				'Priority__c' => 'Normal;Urgent',
				'Created_By__c' => 'test'
			},
			20,
			0,
			true
		);
		ODM_WorkClearanceController.getWcVerificationAllList(
			new Map<String, String>{
				'Work_Clearance_Status__c' => 'Created;In Progress',
				'Create_Date_From__c' => '2022-06-01',
				'Create_Date_To__c' => '2022-06-30',
				'Requested_Date_Form__c' => '2022-06-01',
				'Requested_Date_To__c' => '2022-06-30',
				'Clearance_Number__c' => '9012341234',
				'Functional_Location__c' => 'Test',
				'Notification_Number__c' => '1234',
				'Notification_Type__c' => 'New',
				'Order_Number__c' => '4321',
				'Order_Type__c' => 'New',
				'Requester__c' => 'Test user',
				'Priority__c' => 'Normal;Urgent',
				'Created_By__c' => 'test'
			},
			20,
			0,
			false
		);

		Test.stopTest();
	}

	@IsTest
	static void testGetWcInspectionList() {
		Test.startTest();

		ODM_WorkClearanceController.getWcInspectionList(
			new Map<String, String>{
				'Work_Clearance_Status__c' => 'Created;In Progress',
				'Create_Date_From__c' => '2022-06-01',
				'Create_Date_To__c' => '2022-06-30',
				'Clearance_Number__c' => '9012341234',
				'Functional_Location__c' => 'Test',
				'Notification_Number__c' => '1234',
				'Notification_Type__c' => 'New',
				'Order_Number__c' => '4321',
				'Order_Type__c' => 'New',
				'Requester__c' => 'Test user',
				'Priority__c' => 'Normal;Urgent',
				'Created_By__c' => 'test'
			},
			20,
			0,
			true
		);
		ODM_WorkClearanceController.getWcInspectionList(
			new Map<String, String>{
				'Work_Clearance_Status__c' => 'Created;In Progress',
				'Create_Date_From__c' => '2022-06-01',
				'Create_Date_To__c' => '2022-06-30',
				'Clearance_Number__c' => '9012341234',
				'Functional_Location__c' => 'Test',
				'Notification_Number__c' => '1234',
				'Notification_Type__c' => 'New',
				'Order_Number__c' => '4321',
				'Order_Type__c' => 'New',
				'Requester__c' => 'Test user',
				'Priority__c' => 'Normal;Urgent',
				'Created_By__c' => 'test'
			},
			20,
			0,
			false
		);

		Test.stopTest();
	}

	@IsTest
	static void testGetWcInspectionDoneList() {
		Test.startTest();

		ODM_WorkClearanceController.getWcInspectionDoneList(
			new Map<String, String>{
				'Work_Clearance_Status__c' => 'Created;In Progress',
				'Create_Date_From__c' => '2022-06-01',
				'Create_Date_To__c' => '2022-06-30',
				'Clearance_Number__c' => '9012341234',
				'Functional_Location__c' => 'Test',
				'Notification_Number__c' => '1234',
				'Notification_Type__c' => 'New',
				'Order_Number__c' => '4321',
				'Order_Type__c' => 'New',
				'Requester__c' => 'Test user',
				'Priority__c' => 'Normal;Urgent',
				'Created_By__c' => 'test'
			},
			20,
			0,
			true
		);
		ODM_WorkClearanceController.getWcInspectionDoneList(
			new Map<String, String>{
				'Work_Clearance_Status__c' => 'Created;In Progress',
				'Create_Date_From__c' => '2022-06-01',
				'Create_Date_To__c' => '2022-06-30',
				'Clearance_Number__c' => '9012341234',
				'Functional_Location__c' => 'Test',
				'Notification_Number__c' => '1234',
				'Notification_Type__c' => 'New',
				'Order_Number__c' => '4321',
				'Order_Type__c' => 'New',
				'Requester__c' => 'Test user',
				'Priority__c' => 'Normal;Urgent',
				'Created_By__c' => 'test'
			},
			20,
			0,
			false
		);

		Test.stopTest();
	}
}