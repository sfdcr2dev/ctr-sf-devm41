@isTest
public class THOR_NotificationListPagingCtrlTest {
	@TestSetup
	static void makeData() {
		Master_Map__c mainWorkCenter = new Master_Map__c();
		mainWorkCenter.Code__c = 'CMPS';
		mainWorkCenter.Type__c = 'Main Work Center';
		insert mainWorkCenter;

		Master_Map__c plant = new Master_Map__c();
		plant.Code__c = '2200';
		plant.Type__c = 'Plant';
		insert plant;

		Master_Map__c category = new Master_Map__c();
		category.Code__c = '10005157';
		category.Type__c = 'CategoryWithMainWorkCenterWithPlant';
		category.RelatedMasterMap1__c = mainWorkCenter.Id;
		category.RelatedMasterMap2__c = plant.Id;
		insert category;

		Notification__c noti1 = new Notification__c();
		noti1.Name = 'Notification 1';
		noti1.Main_Work_Center__c = mainWorkCenter.Id;
		noti1.mainWorkCenterPlant__c = plant.Id;
		noti1.Notification_Status__c = 'New';
		insert noti1;

		Notification__c noti2 = new Notification__c();
		noti2.Name = 'Notification 2';
		noti2.Main_Work_Center__c = mainWorkCenter.Id;
		noti2.mainWorkCenterPlant__c = plant.Id;
		insert noti2;

		noti2.Notification_Status__c = 'In Progress';
		update noti2;

		Order__c order1 = new Order__c();
		order1.Name = 'Order 1';
		order1.Main_Work_Center__c = mainWorkCenter.Id;
		order1.mainWorkCenterPlant__c = plant.Id;
		order1.Order_Status__c = 'New';
		insert order1;

		Order__c order2 = new Order__c();
		order2.Name = 'Order 2';
		order2.Main_Work_Center__c = mainWorkCenter.Id;
		order2.mainWorkCenterPlant__c = plant.Id;
		order2.Order_Status__c = 'New';
		insert order2;

		Checked_Sheet_Pointer__mdt formType = [
			SELECT Id, MasterLabel, DeveloperName
			FROM Checked_Sheet_Pointer__mdt
			WHERE DeveloperName = 'Tank_Gauge_Level_Maintenance_Record'
			LIMIT 1
		];

		List<Header_Sheet__c> headerSheets = new List<Header_Sheet__c>();

		List<EQCC_Header__c> headersWithOrder = new List<EQCC_Header__c>();
		for (Integer i = 0; i < 5; i++) {
			headersWithOrder.add(new EQCC_Header__c(Order__c = order1.Id));
		}
		insert headersWithOrder;

		List<EQCC_Checked_Sheet__c> sheets = new List<EQCC_Checked_Sheet__c>();
		for (Integer i = 0; i < 5; i++) {
			sheets.add(
				new EQCC_Checked_Sheet__c(
					Status__c = Constants.CHECKED_SHEETS.STATUS_DRAFT,
					Form_Type__c = formType.DeveloperName,
					Sheet_Code__c = 'CODE',
					Form_Questions__c = 1
				)
			);
		}
		insert sheets;

		Integer i = 0;
		for (EQCC_Header__c header : headersWithOrder) {
			headerSheets.add(
				new Header_Sheet__c(
					Header__c = headersWithOrder.get(i).Id,
					Sheet__c = sheets.get(i).Id,
					Requester__c = 'Working Team'
				)
			);
			i++;
		}
		insert headerSheets;

		List<EQCC_Header__c> headers = new List<EQCC_Header__c>();

		for (i = 0; i < 5; i++) {
			headers.add(new EQCC_Header__c());
		}
		insert headers;

		List<EQCC_Checked_Sheet__c> draftSheets = new List<EQCC_Checked_Sheet__c>();
		for (i = 0; i < 5; i++) {
			draftSheets.add(
				new EQCC_Checked_Sheet__c(
					Status__c = Constants.CHECKED_SHEETS.STATUS_DRAFT,
					Form_Type__c = formType.DeveloperName,
					Sheet_Code__c = 'CODE',
					Form_Questions__c = 1
				)
			);
		}
		insert draftSheets;

		i = 0;
		for (EQCC_Header__c header : headers) {
			headerSheets.add(
				new Header_Sheet__c(
					Header__c = header.Id,
					Sheet__c = draftSheets.get(i).Id,
					isManuallyCreated__c = true,
					Requester__c = 'Working Team'
				)
			);
			i++;
		}
		upsert headerSheets;
	}

	@isTest
	public static void getNewNotificationsByFilter() {
		Map<String, Object> filter = new Map<String, Object>{ 'Main_Work_Center__c' => 'CMPS' };

		List<Notification__c> notifications = THOR_NotificationListPagingCtrl.getNewNotificationsByFilter(
			filter,
			0,
			20,
			new List<String>()
		);
		Integer countNotifications = THOR_NotificationListPagingCtrl.getCountNewNotificationsByFilter(
			filter,
			new List<String>()
		);

		System.assertEquals(1, notifications.size());
		System.assertEquals(1, countNotifications);
	}

	@isTest
	public static void getInProgressNotificationsByFilter() {
		Map<String, Object> filter = new Map<String, Object>{ 'Main_Work_Center__c' => 'CMPS' };

		List<Notification__c> notifications = THOR_NotificationListPagingCtrl.getInProgressNotificationsByFilter(
			filter,
			0,
			20,
			new List<String>()
		);
		Integer countNotifications = THOR_NotificationListPagingCtrl.getCountInProgressNotificationsByFilter(
			filter,
			new List<String>()
		);

		System.assertEquals(1, notifications.size());
		System.assertEquals(1, countNotifications);
	}

	@isTest
	public static void getNewOrdersByFilter() {
		Map<String, Object> filter = new Map<String, Object>{ 'Main_Work_Center__c' => 'CMPS' };

		List<Order__c> orders = THOR_NotificationListPagingCtrl.getNewOrdersByFilter(filter, 0, 20, new List<String>());
		Integer countOrders = THOR_NotificationListPagingCtrl.getCountNewOrdersByFilter(filter, new List<String>());

		System.assertEquals(2, orders.size());
		System.assertEquals(2, countOrders);
	}

	@isTest
	public static void getInProgressOrdersByFilter() {
		Map<String, Object> filter = new Map<String, Object>{ 'Main_Work_Center__c' => 'CMPS' };

		List<Order__c> orders = THOR_NotificationListPagingCtrl.getInProgressOrdersByFilter(
			filter,
			0,
			20,
			new List<String>()
		);
		Integer countOrders = THOR_NotificationListPagingCtrl.getCountInProgressOrdersByFilter(
			filter,
			new List<String>()
		);

		System.assertEquals(0, orders.size());
		System.assertEquals(0, countOrders);
	}

	@isTest
	public static void getWithoutNotificationOrOrderEQCCsByFilter() {
		Map<String, String> filter = new Map<String, String>{
			'Requester__c' => '647',
			'Check_Sheet_Code__c' => 'Test',
			'Check_Sheet_Name__c' => 'Test',
			'Equipment__c' => 'Test',
			'Notification_Number__c' => 'Test',
			'Functional_Location__c' => 'Test',
			'Order_Number__c' => 'Test',
			'Maintenance_Plant__c' => 'Test',
			'Location__c' => 'Test',
			'Plant_Section__c' => 'Test',
			'Main_Work_Center__c' => 'Test',
			'Create_Date_From__c' => String.valueOf(Date.today()),
			'Create_Date_To__c' => String.valueOf(Date.today())
		};

		List<Object> eqccs = THOR_NotificationListPagingCtrl.getWithoutNotificationOrOrderEQCCsByFilter(filter, 0, 20);
		Integer countEqccs = THOR_NotificationListPagingCtrl.getCountWithoutNotificationOrOrderEQCCsByFilter(filter);

		// System.assertEquals(5, eqccs.size());
		// System.assertEquals(5, countEqccs);
	}

	@isTest
	public static void getInProgressEQCCsByFilter() {
		Map<String, String> filter = new Map<String, String>{ 'Requester__c' => 'Working' };

		List<Object> eqccs = THOR_NotificationListPagingCtrl.getInProgressEQCCsByFilter(filter, 0, 20);
		Integer countEqccs = THOR_NotificationListPagingCtrl.getCountInProgressEQCCsByFilter(filter);

		// System.assertEquals(5, eqccs.size());
		// System.assertEquals(5, countEqccs);
	}

	@isTest
	public static void getEqccStep() {
		Test.startTest();
		List<String> headersheetIds = new List<String>(new Map<String, Header_Sheet__c>([SELECT Id FROM Header_Sheet__c]).keySet());
		THOR_NotificationListPagingCtrl.getEqccCurrentStep(headersheetIds);
		Test.stopTest();
	}

	@isTest
	public static void testCheckedSheetWrapper() {
		CheckedSheetWrapper checkSheetWrapper1 = new CheckedSheetWrapper(
			new EQCC_Checked_Sheet__c(),
			'status',
			'requester',
			System.today(),
			false,
			null,
			false
		);

		CheckedSheetWrapper checkSheetWrapper2 = new CheckedSheetWrapper(
			new EQCC_Checked_Sheet__c(),
			'status',
			'requester',
			System.today(),
			false,
			null,
			false,
			'headerSheetName'
		);
	}
}