@isTest
public class THOR_HistoricalSearchCtrlTest {
	@TestSetup
	static void makeData() {
	


		List<Master_Map__c> masterList = new List<Master_Map__c>();

		Master_Map__c mainWorkCenter = new Master_Map__c();
        mainWorkCenter.Code__c = 'ENMA-I';
        mainWorkCenter.Name = 'ENMA-I';
        mainWorkCenter.Type__c = 'Main Work Center';
		

		Master_Map__c plant = new Master_Map__c();
		plant.Code__c = '2200';
		plant.Type__c = 'Plant';
		
		
		Master_Map__c plantsection = new Master_Map__c();
		plantsection.Code__c = 'MO';
		plantsection.Type__c = 'Plant Section';
		
		
		Master_Map__c location = new Master_Map__c();
		location.Code__c = '02200';
		location.Type__c = 'Location';
	
		masterList.add(plant);
		masterList.add(mainWorkCenter);
		masterList.add(plantsection);
		masterList.add(location);
		
		insert masterList;

		List<Master_Map__c> masterList2 = new List<Master_Map__c>();

		Master_Map__c plantsectionwithplant = new Master_Map__c();
		plantsectionwithplant.Type__c = 'PlantSectionWithPlant';
		plantsectionwithplant.RelatedMasterMap1__c = plant.Id;
		plantsectionwithplant.RelatedMasterMap2__c = plantsection.Id;
	

		Master_Map__c mwc = [SELECT id, Name, Code__c FROM Master_Map__c WHERE Type__c = 'Main Work Center' LIMIT 1];

		Master_Map__c category = new Master_Map__c();
		category.Code__c = '10005157';
		category.Type__c = 'CategoryWithMainWorkCenterWithPlant';
		category.RelatedMasterMap1__c = mwc.Id;
		category.RelatedMasterMap2__c = plant.Id;
	
		masterList2.add(plantsectionwithplant);
		masterList2.add(category);

		Functional_Location__c fuctionnaLocation = new Functional_Location__c();
		fuctionnaLocation.Name = 'TOP-TOC5';
		fuctionnaLocation.MainWorkCenter__c = mwc.id;
		fuctionnaLocation.Maintenance_Plant__c = plant.id;
		fuctionnaLocation.Location__c = location.id;
		fuctionnaLocation.PlantSection__c = 'MO';

		insert fuctionnaLocation;
		
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
		User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
		 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
		 LocaleSidKey='en_US', ProfileId = p.Id, Employee_Id__c = '12345',
		 TimeZoneSidKey='America/Los_Angeles', UserName='standarduserfortesting@testorg.com');

		 insert u;
		 
		List<Notification__c> NotiList = new List<Notification__c>();

		Notification__c noti1 = new Notification__c();
		noti1.Name = 'Notification 1';
		noti1.Notification_Number__c = '100';
		noti1.Notification_Status__c = 'New';
		noti1.Priority__c = 'Normal';
		noti1.Type__c = 'PM';
		noti1.Breakdown__c = true;
		noti1.Main_Work_Center__c = mwc.Id;
		noti1.AssignedTo__c = UserInfo.getUserId();
		// noti1.mainWorkCenterPlant__c = plant.Id;
		 
	  

		Notification__c noti2 = new Notification__c();
		noti2.AssignedTo__c = u.Id;
		noti2.Name = 'Notification 2';
		noti2.Notification_Number__c = '101';
		noti2.Notification_Status__c = 'New';
		noti2.Priority__c = 'Normal';
		noti2.Type__c = 'PM';
		noti2.Breakdown__c = true;
		noti2.Main_Work_Center__c = mwc.Id;
		noti2.mainWorkCenterPlant__c = plant.Id;

		NotiList.add(noti1);
		NotiList.add(noti2);

		insert NotiList;
		Test.setCreatedDate(noti1.Id, DateTime.newInstance(2021,12,12));
		Test.setCreatedDate(noti2.Id, DateTime.newInstance(2021,12,12));


		Order__c order = new Order__c();
		order.Name = 'Order';

		Order__c order1 = new Order__c();
		order1.Name = 'Order 1';
		order1.Order_Number__c = '100';
		order1.Order_Status__c = 'New';
		order1.Priority__c = 'Normal';
		order1.Order_Type__c = 'CM01';
		order1.Main_Work_Center__c = mwc.Id;
		order1.mainWorkCenterPlant__c = plant.Id;
		order1.Notification__c = noti1.id;
		//order1.Super_Order__c = order.id;
		order1.Functional_Location__c = fuctionnaLocation.id;
		
		insert order1;
		Test.setCreatedDate(order1.Id, DateTime.newInstance(2021,12,12));

		Order__c order2 = new Order__c();
		order2.Name = 'Order 2';
		order2.Order_Number__c = '101';
		order2.Order_Status__c = 'New';
		order2.Priority__c = 'Normal';
		order2.Order_Type__c = 'PM01';
		order2.Main_Work_Center__c = mwc.Id;
		order2.mainWorkCenterPlant__c = plant.Id;
		order2.Notification__c = noti2.id;
		order2.Super_Order__c = order1.id;
		order2.Functional_Location__c = fuctionnaLocation.id;
		insert order2;
		Test.setCreatedDate(order2.Id, DateTime.newInstance(2021,12,12));

		

		PISUsers__c pisuser = new PISUsers__c();
        pisuser.User__c = UserInfo.getUserId();
        pisuser.Name = 'Integration R2';
        pisuser.ENFIRSTNAME__c = 'Integration';
        pisuser.ENLASTNAME__c = 'R2';
        pisuser.THFIRSTNAME__c = 'Integration';
        pisuser.THLASTNAME__c = 'R2';
        pisuser.EMPLOYEEID__c = 'R2-00001';
        pisuser.DEPARTMENT__c = '001';
        pisuser.ORGID__c = '';
        insert pisuser;

        THOR_Applicant_Bearer__c bearer = new THOR_Applicant_Bearer__c();
        bearer.Name = 'B-180001';
        bearer.Code__c = 'B-180001';
        bearer.Applicant_ID__c = '10004001';
        bearer.Description__c = 'B-180001, ADPE';
        insert bearer;

        Safety_Permit__c safety = new Safety_Permit__c();
        safety.Name = '300024001';
        insert safety;

	

		// System.runAs(u) {
		Work_Clearance__c wc1 = new Work_Clearance__c();
        wc1.Name = '900444001';
        wc1.Notification__c = noti2.Id;
        wc1.Order__c = order2.Id;
		wc1.Requester_UI__c = pisuser.Id;
        wc1.Thaioil_Supervisor_Indicator_UI__c = pisuser.Id;
        wc1.Applicant_or_Bearer_UI__c = bearer.Id;
        wc1.Close_Applicant_or_Bearer_UI__c = pisuser.Id;
        wc1.Extend_Applicant_or_Bearer_UI__c = pisuser.Id;
        wc1.Bearer1_UI__c = bearer.Id;
        wc1.Bearer2_UI__c = bearer.Id;
        wc1.Bearer3_UI__c = bearer.Id;
        wc1.Bearer4_UI__c = bearer.Id;
        wc1.Bearer4_UI__c = bearer.Id;
		wc1.Priority__c = '3';
        wc1.Safety_Permit1_UI__c = safety.Id;
        wc1.Safety_Permit2_UI__c = safety.Id;
        wc1.Safety_Permit3_UI__c = safety.Id;
        wc1.System_Status__c = 'CRTE';
        wc1.Work_Detail__c = '1. Work Detail 1\n2. Work Detail 2\n3. Work Detail 3\n4. Work Detail 4';
		wc1.FunctionalLocation__c = fuctionnaLocation.id;
		wc1.Main_Work_Center__c = mwc.Id;
		wc1.Main_Work_Center_Text__c = 'ENMA-I';
		insert wc1;
		Test.setCreatedDate(wc1.Id, DateTime.newInstance(2021,12,12));
		// }

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
					Form_Name__c = 'Tank',
                    Form_Questions__c = 5
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
			headers.add(new EQCC_Header__c(
				FunctionalLocation__c = fuctionnaLocation.id, 
				Notification__c = noti2.Id,
				Order__c = order2.Id
				
			));
		}
		insert headers;

		List<EQCC_Checked_Sheet__c> draftSheets = new List<EQCC_Checked_Sheet__c>();
		for (i = 0; i < 5; i++) {
			draftSheets.add(
				new EQCC_Checked_Sheet__c(
					Status__c = Constants.CHECKED_SHEETS.STATUS_DRAFT,
					Form_Type__c = formType.DeveloperName,
					Sheet_Code__c = 'CODE',
                    Form_Questions__c = 5
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
		List<THOR_Filter__c> filterList = new List<THOR_Filter__c>();

		THOR_Filter__c thorFilterNoti = new THOR_Filter__c();
		thorFilterNoti.Notification_Number__c = '100';
		thorFilterNoti.Order_Number__c = '100';
		thorFilterNoti.Breakdown__c = true;
		thorFilterNoti.PriorityMulti__c = 'Normal';
		thorFilterNoti.StatusMulti__c = 'New';
		thorFilterNoti.NotificationTypeMulti__c = 'PM';
		thorFilterNoti.Create_Date_From__c = Date.newInstance(2021,12,12);
		thorFilterNoti.Create_Date_To__c = Date.newInstance(2021,12,12);
		thorFilterNoti.Functional_Location__c ='TOP-TOC5';
		thorFilterNoti.Location__c ='2200';
		thorFilterNoti.Main_Work_Center__c = 'ENMA-I';
		thorFilterNoti.User__c =  u.id;
		thorFilterNoti.My_Tasks__c = true;

		thorFilterNoti.Filter_Type__c = 'NotificationHistorical';


		//Order__c bigOrder = [SELECT Id, Name, Order_Type__c FROM Order__c WHERE Order_Type__c = 'CM01' LIMIT 1];
		THOR_Filter__c thorFilterOrder = new THOR_Filter__c();
		thorFilterOrder.Filter_Type__c = 'OrderHistorical';
		thorFilterOrder.Notification_Number__c = '100';
		thorFilterOrder.Order_Number__c = '100';
		thorFilterOrder.Super_Order__c = 'Order 1';
		thorFilterOrder.PriorityMulti__c = 'Normal';
		thorFilterOrder.StatusMulti__c = 'New';
		thorFilterOrder.OrderTypeMulti__c = 'PM01';
		thorFilterOrder.Create_Date_From__c = Date.newInstance(2021,12,12);
		thorFilterOrder.Create_Date_To__c = Date.newInstance(2021,12,12);
		thorFilterOrder.Functional_Location__c ='TOP-TOC5';
		thorFilterOrder.Main_Work_Center__c = 'ENMA-I';


  
		THOR_Filter__c thorFilterWc = new THOR_Filter__c();
		thorFilterWc.PriorityMulti__c = 'Normal';
		thorFilterWc.Created_By__c = '12345';
		thorFilterWc.StatusMulti__c = 'Created';
		thorFilterWc.Notification_Number__c = '100';
		thorFilterWc.Order_Number__c = '100';	
		thorFilterWc.NotificationTypeMulti__c = 'PM';
		thorFilterWc.OrderTypeMulti__c = 'PM01';
		thorFilterWc.Main_Work_Center__c = 'ENMA-I';
		thorFilterWc.Functional_Location__c ='TOP-TOC5';
		thorFilterWc.Clearance_Number__c = '900444001';
		thorFilterWc.Filter_Type__c = 'WorkClearanceHistorical';
		thorFilterWc.Requested_Date_Form__c = Date.newInstance(2021,12,12);
		thorFilterWc.Requested_Date_To__c = Date.newInstance(2021,12,12);
	
		THOR_Filter__c thorFilterEQCC= new THOR_Filter__c();
		// thorFilterEQCC.PriorityMulti__c = 'Normal';
		thorFilterEQCC.Notification_Number__c = '100';
		thorFilterEQCC.Order_Number__c = '100';	
		thorFilterEQCC.EQCC_Code__c = 'CODE';
		thorFilterEQCC.EQCC_Name__c = 'Tank';
		thorFilterEQCC.Maintenance_Plant__c = '2200';
		thorFilterEQCC.Location__c = '02200';
		thorFilterEQCC.Plant_Section__c = 'MO';
		thorFilterEQCC.Creator__c = 'Working Team';
		thorFilterEQCC.Created_By__c = 'Working Team';


		// thorFilterWc.NotificationTypeMulti__c = 'PM';
		// thorFilterWc.OrderTypeMulti__c = 'PM01';
		thorFilterEQCC.Main_Work_Center__c = 'ENMA-I';
		thorFilterEQCC.Functional_Location__c ='TOP-TOC5';
		thorFilterEQCC.Filter_Type__c = 'EQCCHistorical';
		thorFilterEQCC.Create_Date_From__c = Date.newInstance(2021,12,12);
		thorFilterEQCC.Create_Date_To__c = Date.newInstance(2021,12,12);


		filterList.add(thorFilterNoti);
		filterList.add(thorFilterOrder);
		filterList.add(thorFilterEQCC);
		filterList.add(thorFilterWc);
		insert filterList;
	}

	@isTest
	public static void testGetNewNotificationsByFilter() {
		THOR_Filter__c savedFilters = [
			SELECT Id, Name, Filter_type__c, Notification_Type__c
			FROM THOR_Filter__c
			WHERE Filter_type__c = 'NotificationHistorical'
			LIMIT 1
		];

		Test.startTest();
		List<Object> notifications = THOR_HistoricalSearchCtrl.doHistoricalSearch(savedFilters.Id, 0, 50000);
		Integer countNotifications = THOR_HistoricalSearchCtrl.getCountNewNotificationsByFilter(savedFilters.Id);
		Test.stopTest();

		System.assertEquals(0, notifications.size());
		System.assertEquals(0, countNotifications);
	}


	@isTest
	public static void testGetNewOrderByFilter() {
		THOR_Filter__c savedFilters = [
			SELECT Id, Name, Filter_type__c
			FROM THOR_Filter__c
			WHERE Filter_type__c = 'OrderHistorical' AND Super_Order__c != NULL
			LIMIT 1
		];

		
		Test.startTest();

		List<Object> Order = THOR_HistoricalSearchCtrl.doHistoricalSearch(savedFilters.Id, 0, 50000);
		Integer countOrder = THOR_HistoricalSearchCtrl.getCountNewOrdersByFilter(savedFilters.Id);
		Test.stopTest();

		//System.assertEquals(1, Order.size());
		//System.assertEquals(1, countOrder);
	}


	@isTest
	
    static void testGetWorkClearanceByFilter() {
		THOR_Filter__c savedFilters = [
			SELECT Id, Name, Filter_type__c
			FROM THOR_Filter__c
			WHERE Filter_type__c = 'WorkClearanceHistorical' 
			LIMIT 1
		];
		
		Test.startTest();
		List<Object> WorkClearance = THOR_HistoricalSearchCtrl.doHistoricalSearch(savedFilters.Id, 0, 50000);
		Integer countWc = THOR_HistoricalSearchCtrl.getCountNewWorkClearanceByFilter(savedFilters.Id);
		Test.stopTest();

		System.assertEquals(0, WorkClearance.size());
		System.assertEquals(0, countWc);
	}
	@isTest
	public static void testGetInProgressEQCCsByFilter() {
		THOR_Filter__c savedFilters = [
			SELECT Id, Name, Filter_type__c
			FROM THOR_Filter__c
			WHERE Filter_type__c = 'EQCCHistorical' 
			LIMIT 1
		];
		
		Test.startTest();
		List<Object> eqccs = THOR_HistoricalSearchCtrl.doHistoricalSearch(savedFilters.Id, 0, 20);
		Integer countEqccs = THOR_HistoricalSearchCtrl.getCountInProgressEQCCsByFilter(savedFilters.Id);
		Test.stopTest();

		System.assertEquals(0, eqccs.size());
		System.assertEquals(0, countEqccs);
	}

		@isTest
	public static void testGetMyFilter() {
		List<String> fieldsList = new List<String>();
		fieldsList.add('Create_Date_To__c');
		fieldsList.add('Create_Date_From__c');

		User u = [SELECT Id, Alias FROM User WHERE Alias = 'standt' LIMIT 1];
		
		Test.startTest();
		System.runAs(u) {
		Object result = THOR_HistoricalSearchCtrl.getMyFilterHistoricalSearch('NotificationHistorical', fieldsList);

		}
		Test.stopTest();

	}


	@isTest
	public static void testCheckedSheetWrapper() {
		Test.startTest();

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

		CheckedSheetWrapper checkSheetWrapper3 = new CheckedSheetWrapper(
			new EQCC_Checked_Sheet__c(),
			'status',
			'requester',
			System.today(),
			System.today(),
			false,
			null,
			false,
			'headerSheetName',
			new List<EQCC_Step__c>()
		);
		Test.stopTest();

	}
}