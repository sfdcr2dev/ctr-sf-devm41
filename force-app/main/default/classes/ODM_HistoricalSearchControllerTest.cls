@isTest
public class ODM_HistoricalSearchControllerTest {
	@TestSetup
    static void makeData() {       
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, Employee_Id__c = '12345',
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduserfortesting@testorg.com');
    
        insert u;
		
		Master_Map_Set__c masterMapSet = new Master_Map_Set__c();
        insert masterMapSet;

		List<Master_Map__c> masterList = new List<Master_Map__c>();

		Master_Map__c mainWorkCenter = new Master_Map__c();
        mainWorkCenter.Code__c = 'ENMA-I';
        mainWorkCenter.Name = 'ENMA-I';
        mainWorkCenter.Type__c = 'Main Work Center';
		mainWorkCenter.Master_Map_Set__c = masterMapSet.Id;


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
		Notification__c noti1 = new Notification__c();
		noti1.Name = 'Notification 1';
		noti1.Notification_Number__c = '100';
		noti1.Notification_Status__c = 'New';
		noti1.Priority__c = 'Normal';
		noti1.Type__c = 'PM';
		noti1.Breakdown__c = true;
		// noti1.Main_Work_Center__c = mwc.Id;
		noti1.AssignedTo__c = UserInfo.getUserId();
        insert noti1;

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

		Work_Clearance__c wc1 = new Work_Clearance__c();
        wc1.Name = '900444001';
        wc1.Notification__c = noti1.Id;
        wc1.Order__c = order1.Id;
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
		wc1.Integration_Status__c = 'Success';
		wc1.Description__c = 'Test Description';

		insert wc1;


        THOR_Filter__c thorFilterNoti = new THOR_Filter__c();
        thorFilterNoti.Notification_Number__c = '100';
        thorFilterNoti.Breakdown__c = true;
        thorFilterNoti.StatusMulti__c = 'New';
        thorFilterNoti.NotificationTypeMulti__c = 'PM';
        thorFilterNoti.Create_Date_From__c = Date.today();
        thorFilterNoti.Create_Date_To__c = Date.today();
        thorFilterNoti.Functional_Location__c ='TOP-TOC5';
        thorFilterNoti.Notification_Date__c = Date.today();
        thorFilterNoti.Main_Work_Center__c = 'ENMA-I';
        thorFilterNoti.User__c =  UserInfo.getUserId();
        thorFilterNoti.Filter_Type__c = 'ODM_HistoricalNotification';
		insert thorFilterNoti;

		THOR_Filter__c thorFilterWc = new THOR_Filter__c();
		thorFilterWc.PriorityMulti__c = 'Normal';
		thorFilterWc.Created_By__c = '12345';
		thorFilterWc.StatusMulti__c = 'Created';
		thorFilterWc.Notification_Number__c = '100';
		thorFilterWc.Order_Number__c = '100';	
		thorFilterWc.NotificationTypeMulti__c = 'PM';
		thorFilterWc.OrderTypeMulti__c = 'PM01';
		thorFilterWc.Main_Work_Center__c = 'ENMA-I';
		// thorFilterWc.Functional_Location__c ='TOP-TOC5';
		thorFilterWc.Clearance_Number__c = '900444001';
		thorFilterWc.Filter_Type__c = 'ODM_HistoricalWorkClearance';
		thorFilterWc.Requested_Date_Form__c = Date.today();
		thorFilterWc.Requested_Date_To__c = Date.today();
		thorFilterWc.Create_Date_From__c = Date.today();
		thorFilterWc.Create_Date_To__c = Date.today();
		thorFilterWc.Functional_Location__c = fuctionnaLocation.Id;
		thorFilterWc.Main_Work_Center__c = mwc.Id;
		thorFilterWc.Location__c = location.id;
		insert thorFilterWc;
    }

    @isTest
	public static void testGetNewNotificationsByFilter() {
		THOR_Filter__c savedFilters = [
			SELECT Id, Name, Filter_type__c, Notification_Type__c
			FROM THOR_Filter__c
			WHERE Filter_type__c = 'ODM_HistoricalNotification'
			LIMIT 1
		];

		Test.startTest();
		Object notifications = ODM_HistoricalSearchController.getHistoricalNotificationList(String.valueOf(savedFilters.Id),0,20,false);
		Test.stopTest();

		System.assertNotEquals(null, notifications);
	}
	@isTest
	public static void testGetNewWcByFilter() {
		THOR_Filter__c savedFilters = [
			SELECT Id, Name, Filter_type__c, Notification_Type__c
			FROM THOR_Filter__c
			WHERE Filter_type__c = 'ODM_HistoricalWorkClearance'
			LIMIT 1
		];

		Test.startTest();
		Object wc = ODM_HistoricalSearchController.getHistoricalWcList(String.valueOf(savedFilters.Id),0,20,false);
		Test.stopTest();

		System.assertNotEquals(null, wc);
	}
	// public static void  testGetwcList() {
	// 	Test.startTest();
	// 	// System.runAs(contextuser){
	// 	ODM_HistoricalSearchController.getHistoricalWcList(String.valueOf(
	// 		new Map<String, String>{
	// 			'Clearance_Number__c' => '12345678',
	// 			'Work_Clearance_Status__c' => 'New;In Progress',
	// 			'Functional_Location__c' => 'TOP-TOC5',
	// 			'Notification_Number__c' => 'TOP-TOC5',
	// 			'Notification_Type__c' => 'OP',
	// 			'Order_Number__c' => 'TOP-TOC5',
	// 			'Order_Type__c' => 'CM01',
	// 			'Requester__c' => 'Integration R2'
				
	// 		},
			
	// 		0,
	// 		20,
	// 		false
	// 	));
	// 	// }
	// 	Test.stopTest();
	//}
    @isTest
	public static void testGetMyFilter() {
		THOR_Filter__c savedFilters = [
			SELECT Id, Name, Filter_type__c, Notification_Type__c
			FROM THOR_Filter__c
			WHERE Filter_type__c = 'ODM_HistoricalNotification'
			LIMIT 1
		];		
		Test.startTest();
		Object result = ODM_HistoricalSearchController.getMyFilter(String.valueOf(savedFilters.Id));
		Test.stopTest();

        System.assertNotEquals(null, result);

	}

    @isTest
	public static void testGetMyFilterNull() {
		Notification__c savedFilters = [
			SELECT Id
			FROM Notification__c
			LIMIT 1
		];		
		Test.startTest();
		Object result = ODM_HistoricalSearchController.getMyFilter(String.valueOf(savedFilters.Id));
		Test.stopTest();

        System.assertEquals(null, result);
    }
    @isTest
	public static void getMyFilterHistoricalSearch() {
		
        List<String> a = new List<String>();
		a.add('id');
		Test.startTest();
		Object result = ODM_HistoricalSearchController.getMyFilterHistoricalSearch('ODM_HistoricalNotification',a);
		// Object result1 = ODM_HistoricalSearchController.getMyFilterHistoricalSearch('ODM_HistoricalWorkClearance',a);

		Test.stopTest();

        System.assertNotEquals(null, result);
    }
}