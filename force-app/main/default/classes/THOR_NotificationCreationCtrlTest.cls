@isTest
public class THOR_NotificationCreationCtrlTest {
	@TestSetup
	public static void makeData() {
		List<Master_Map__c> plantMap = new List<Master_Map__c>{
			new Master_Map__c(Name = '1200', Code__c = '1200', Type__c = 'Plant'),
			new Master_Map__c(Name = '2200', Code__c = '2200', Type__c = 'Plant'),
			new Master_Map__c(Name = '3200', Code__c = '3200', Type__c = 'Plant'),
			new Master_Map__c(Name = '4200', Code__c = '4200', Type__c = 'Plant'),
			new Master_Map__c(Name = '7200', Code__c = '7200', Type__c = 'Plant'),
			new Master_Map__c(Name = '8200', Code__c = '8200', Type__c = 'Plant')
		};
		insert plantMap;
		System.debug(plantMap);

		List<Master_Map__c> plannerGroupMap = new List<Master_Map__c>{
			new Master_Map__c(Name = 'CE', Code__c = 'CE', Type__c = 'PlannerGroup'),
			new Master_Map__c(Name = 'SQA', Code__c = 'SQA', Type__c = 'PlannerGroup'),
			new Master_Map__c(Name = 'EAB', Code__c = 'EAB', Type__c = 'PlannerGroup'),
			new Master_Map__c(Name = 'IAA', Code__c = 'IAA', Type__c = 'PlannerGroup')
		};
		insert plannerGroupMap;
		System.debug(plannerGroupMap);

		List<Master_Map__c> plannerGroupWithPlantOrderMap = new List<Master_Map__c>{
			new Master_Map__c(
				Type__c = 'PlannerGroupWithPlantOrder',
				RelatedMasterMap1__c = plannerGroupMap.get(0).Id,
				RelatedMasterMap2__c = plantMap.get(0).Id
			)
		};
		insert plannerGroupWithPlantOrderMap;
	}

	@isTest
	public static void testGetEquipmentByFL() {
		Test.startTest();
		Functional_Location__c fl = new Functional_Location__c();
		fl.Name = 'Test FL';
		insert fl;

		THOR_NotificationCreationCtrl.getEquipmentByFL(fl.Id);
		Test.stopTest();
	}

	@isTest
	public static void testGetFunctionLocationDetail() {
		Test.startTest();
		Functional_Location__c fl = new Functional_Location__c();
		fl.Name = 'Test FL';
		insert fl;

		Functional_Location__c retrieved = (Functional_Location__c) THOR_NotificationCreationCtrl.getFunctionLocationDetail(
			fl.Id
		);

		System.assertEquals('Test FL', retrieved.Name);
		Test.stopTest();
	}

	@isTest
	public static void testGetMainWorkCenterPlants() {
		Test.startTest();
		Master_Map_Set__c mastermapset = new Master_Map_Set__c();
		insert mastermapset;

		Master_Map__c mainworkcenter = new Master_Map__c();
		mainworkcenter.Code__c = 'ENMA-I';
		mainworkcenter.Name = 'ENMA-I';
		mainworkcenter.Type__c = 'Main Work Center';
		mainworkcenter.Master_Map_Set__c = mastermapset.id;
		insert mainworkcenter;

		Master_Map__c mainworkcenterplant = new Master_Map__c();
		mainworkcenterplant.Code__c = '10000023';
		mainworkcenterplant.RelatedMasterMap1__c = mainworkcenter.Id;
		mainworkcenterplant.Name = '10000023';
		mainworkcenterplant.Type__c = 'CategoryWithMainWorkCenterWithPlant';
		mainworkcenterplant.Master_Map_Set__c = mastermapset.id;
		insert mainworkcenterplant;

		THOR_NotificationCreationCtrl.getMainWorkCenterPlants(mainworkcenter.Id);
		Test.stopTest();
	}

	@isTest
	public static void testGetMainWorkCenters() {
		Test.startTest();
		Master_Map_Set__c mastermapset = new Master_Map_Set__c();
		insert mastermapset;

		Master_Map__c mainworkcenter = new Master_Map__c();
		mainworkcenter.Code__c = 'ENMA-I';
		mainworkcenter.Name = 'ENMA-I';
		mainworkcenter.Type__c = 'Main Work Center';
		mainworkcenter.Master_Map_Set__c = mastermapset.id;
		insert mainworkcenter;

		Master_Map__c mainworkcenterplant = new Master_Map__c();
		mainworkcenterplant.Code__c = '10000023';
		mainworkcenterplant.RelatedMasterMap1__c = mainworkcenter.Id;
		mainworkcenterplant.Name = '10000023';
		mainworkcenterplant.Type__c = 'CategoryWithMainWorkCenterWithPlant';
		mainworkcenterplant.Master_Map_Set__c = mastermapset.id;
		insert mainworkcenterplant;

		THOR_NotificationCreationCtrl.getMainWorkCenters(mainworkcenterplant.Id);
		Test.stopTest();
	}

	@isTest
	public static void testGetDepartmentResp() {
		Test.startTest();
		PISUsers__c pisuser = new PISUsers__c();
		pisuser.User__c = UserInfo.getUserId();
		pisuser.ORGID__c = 'R2';
		insert pisuser;

		String orgid = THOR_NotificationCreationCtrl.getDepartmentResp(pisuser.Id);

		System.assertEquals('R2', orgid);
		Test.stopTest();
	}

	@isTest
	public static void testGetPISRequester() {
		Test.startTest();
		PISUsers__c pisuser = new PISUsers__c();
		pisuser.User__c = UserInfo.getUserId();
		pisuser.Name = 'Integration';
		pisuser.ENFIRSTNAME__c = 'Integration';
		pisuser.ENLASTNAME__c = 'R2';
		pisuser.THFIRSTNAME__c = 'Integration';
		pisuser.THLASTNAME__c = 'R2';
		pisuser.EMPLOYEEID__c = 'R2-00001';
		pisuser.DEPARTMENT__c = '001';
		pisuser.ORGID__c = '';
		insert pisuser;

		List<SObject> pisusers = THOR_NotificationCreationCtrl.getPISRequester('');
		pisusers = THOR_NotificationCreationCtrl.getPISRequester('Integration');
		pisusers = FunctionalLocationController.getPISRequester('Integration');

		System.assertEquals(1, pisusers.size());
		Test.stopTest();
	}

	@isTest
	public static void testGetOrdersDetailById() {
		Test.startTest();
		Order__c order = new Order__c();
		order.Name = 'Test';
		insert order;

		Notification__c noti = (Notification__c) THOR_NotificationCreationCtrl.getOrdersDetailById(order.Id);

		System.assertEquals(order.Id, noti.Order__c);
		Test.stopTest();
	}

	@IsTest
	static void testPlanGroup_noparam() {
		Test.startTest();
		THOR_NotificationCreationCtrl.getPlannerGroupList(null);
		THOR_NotificationCreationCtrl.getPlanningPlantList(null);
		Test.stopTest();
	}

	@IsTest
	static void testPlanGroup_withparam() {
		Test.startTest();
		THOR_NotificationCreationCtrl.getPlannerGroupList(
			[SELECT Id FROM Master_Map__c WHERE Type__c = 'Plant' LIMIT 1]
			?.Id
		);
		THOR_NotificationCreationCtrl.getPlanningPlantList(
			[SELECT Id FROM Master_Map__c WHERE Type__c = 'PlannerGroup' LIMIT 1]
			?.Id
		);
		Test.stopTest();
	}
}