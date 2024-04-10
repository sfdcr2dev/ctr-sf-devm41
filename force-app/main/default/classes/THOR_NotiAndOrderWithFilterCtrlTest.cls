@isTest
public with sharing class THOR_NotiAndOrderWithFilterCtrlTest {
	@TestSetup
	static void makeData() {
	}

	@isTest
	public static void testFilterMethods() {
		Test.startTest();

		THOR_FilterController.getExcludedFilter();
		THOR_FilterController.getMyFilter('HomeNotification', 'THOR_FilterHomeNotificationFrom');
		THOR_FilterController.getDescribeFieldResult('Filter_type__c', 'THOR_Filter__c');
		THOR_FilterController.getMasterMapByTpye('Filter', 'Test');
		THOR_FilterController.getMasterMapReversed('%', 'Test');
		THOR_FilterController.fetchRecordsRecently(
			'Notification__c',
			'Test',
			new List<String>{ 'Notification_Number__c', 'Priority__c' }
		);

		try {
			Order__c orderObj = new Order__c(
				Name = '12344321',
				Order_Number__c = '12344321',
				Order_Status__c = 'New'
			);
			insert orderObj;
			THOR_FilterController.getRecordInfo(orderObj.Id);
		} catch (Exception e) {
		}
		try {
			THOR_FilterController.getMyFilter('HomeNotification', null);
		} catch (Exception e) {
		}
		Test.stopTest();
	}

	@isTest
	public static void testGetNotification() {
		Test.startTest();
		THOR_NotificationAndOrderCtrl.getNotificationsByFilter(
			new Map<String, Object>{
				'Notification_Number__c' => 'Notification_Number__c',
				'Notification_Type__c' => 'Notification_Type__c',
				'Functional_Location__c' => 'Functional_Location__c',
				'Create_Date_From__c' => '2021-07-29',
				'Create_Date_To__c' => '2021-07-29',
				'Description__c' => 'Description__c',
				'Priority__c' => 'Priority__c',
				'Main_Work_Center__c' => 'Main_Work_Center__c',
				'Location__c' => 'Location__c',
				'Plant_Section__c' => 'Plant_Section__c',
				'Maintenance_Plant__c' => 'Maintenance_Plant__c',
				'Breakdown__c' => true,
				'My_Tasks__c' => true,
				'User__c' => UserInfo.getUserId()
			}
		);
		Test.stopTest();
	}

	@isTest
	public static void testGetOrder() {
		Test.startTest();
		THOR_NotificationAndOrderCtrl.getOrdersByFilter(
			new Map<String, Object>{
				'Order_Number__c' => 'Order_Number__c',
				'Order_Type__c' => 'Order_Type__c',
				'Functional_Location__c' => 'Functional_Location__c',
				'Create_Date_From__c' => '2021-07-29',
				'Create_Date_To__c' => '2021-07-29',
				'Description__c' => 'Description__c',
				'Priority__c' => 'Priority__c',
				'Main_Work_Center__c' => 'Main_Work_Center__c',
				'Location__c' => 'Location__c',
				'Plant_Section__c' => 'Plant_Section__c',
				'Maintenance_Plant__c' => 'Maintenance_Plant__c',
				'Responsible_Person__c' => '01235'
			}
		);
		Test.stopTest();
	}
}