@isTest
public with sharing class FunctionalLocationControllerTest {
	@isTest
	public static void testRetrieveFaultCodesBothIds() {
		Master_Map_Set__c mms = new Master_Map_Set__c();
		insert mms;

		//Catelog Profile
		Master_Map__c catelogEquipment = new Master_Map__c(
			Name = 'ELEC-0002',
			Description__c = 'EquipmentCatelogProfile',
			Master_Map_Set__c = mms.id
		);
		insert catelogEquipment;
		Master_Map__c catelogFunctional = new Master_Map__c(
			Name = 'ELEC-0005',
			Description__c = 'FLCatelogProfile',
			Master_Map_Set__c = mms.id
		);
		insert catelogFunctional;

		//For Equipment
		Equipment__c equipment = new Equipment__c(CatelogProfile__c = catelogEquipment.id);
		insert equipment;
		Master_Map__c eegnl = new Master_Map__c(Name = 'EE-GNL', Master_Map_Set__c = mms.id);
		insert eegnl;
		Master_Map__c data1 = new Master_Map__c(
			Name = 'DATA1',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap1__c = catelogEquipment.id,
			RelatedMasterMap2__c = eegnl.id
		);
		insert data1;
		Master_Map__c e01 = new Master_Map__c(
			Name = 'E01',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest1Equipment'
		);
		insert e01;
		Master_Map__c e02 = new Master_Map__c(
			Name = 'E02',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest2Equipment'
		);
		insert e02;
		Master_Map__c e03 = new Master_Map__c(
			Name = 'E03',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest2Equipment'
		);
		insert e03;
		Master_Map__c data11 = new Master_Map__c(
			Name = 'DATA11',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatelogFaultCode',
			RelatedMasterMap1__c = eegnl.id,
			RelatedMasterMap2__c = e01.id
		);
		insert data11;
		Master_Map__c data12 = new Master_Map__c(
			Name = 'DATA12',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatelogFaultCode',
			RelatedMasterMap1__c = eegnl.id,
			RelatedMasterMap2__c = e02.id
		);
		insert data12;
		Master_Map__c data13 = new Master_Map__c(
			Name = 'DATA13',
			Master_Map_Set__c = mms.id,
			Type__c = 'NotCatelogFaultCode',
			RelatedMasterMap1__c = eegnl.id,
			RelatedMasterMap2__c = e03.id
		);
		insert data13;

		Functional_Location__c functionalLocation = new Functional_Location__c(
			Name = 'TEST-FL-01',
			CatelogProfile__c = catelogFunctional.id
		);
		insert functionalLocation;
		System.assertEquals(
			FunctionalLocationController.hasCatelogProfileByEquipIdOrFuncId(functionalLocation.Id),
			String.valueOf(functionalLocation.CatelogProfile__c).left(15),
			'Catalog Profile should be existing'
		);
		System.assertEquals(
			FunctionalLocationController.retrieveCodeGroup(catelogFunctional.Name).size(),
			1,
			'The Code Group is has one'
		);

		//First Case
		//retrieveFaultCodes recieves Functional_Location__c and Equipment__c
		//It should retrieve the CatelogProfile__c of the Equipment__c
		//List<MasterMapWrapper> faultCodes1 = FunctionalLocationController.retrieveFaultCodes(equipment.id,functionalLocation.id);
		System.assertEquals(
			FunctionalLocationController.retrieveFaultCodes(equipment.id, functionalLocation.id, null).size(),
			2,
			'The Fault Codes is not being retrieved correctly'
		);
	}

	@isTest
	public static void testRetrieveFaultCodesBothIdsNoEquipmetCatelog() {
		Master_Map_Set__c mms = new Master_Map_Set__c();
		insert mms;

		Master_Map__c catelogFunctional = new Master_Map__c(
			Name = 'ELEC-0005',
			Description__c = 'FLCatelogProfile',
			Master_Map_Set__c = mms.id
		);
		insert catelogFunctional;

		Equipment__c equipment = new Equipment__c();
		insert equipment;
		Functional_Location__c functionalLocation = new Functional_Location__c(
			CatelogProfile__c = catelogFunctional.id
		);
		insert functionalLocation;
		Master_Map__c ttgnl = new Master_Map__c(Name = 'TT-GNL', Master_Map_Set__c = mms.id);
		insert ttgnl;
		Master_Map__c data2 = new Master_Map__c(
			Name = 'DATA2',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap1__c = catelogFunctional.id,
			RelatedMasterMap2__c = ttgnl.id
		);
		insert data2;
		Master_Map__c t01 = new Master_Map__c(
			Name = 'T01',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest1FL'
		);
		insert t01;
		Master_Map__c t02 = new Master_Map__c(
			Name = 'T02',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest2FL'
		);
		insert t02;
		Master_Map__c t03 = new Master_Map__c(
			Name = 'T03',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest3FL'
		);
		insert t03;
		Master_Map__c data21 = new Master_Map__c(
			Name = 'DATA21',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatelogFaultCode',
			RelatedMasterMap1__c = ttgnl.id,
			RelatedMasterMap2__c = t01.id
		);
		insert data21;
		Master_Map__c data22 = new Master_Map__c(
			Name = 'DATA22',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatelogFaultCode',
			RelatedMasterMap1__c = ttgnl.id,
			RelatedMasterMap2__c = t02.id
		);
		insert data22;
		Master_Map__c data23 = new Master_Map__c(
			Name = 'DATA23',
			Master_Map_Set__c = mms.id,
			Type__c = 'NotCatelogFaultCode',
			RelatedMasterMap1__c = ttgnl.id,
			RelatedMasterMap2__c = t03.id
		);
		insert data23;

		//List<MasterMapWrapper> faultCodes2 = FunctionalLocationController.retrieveFaultCodes(equipment.id,functionalLocation.id);
		System.assertEquals(
			FunctionalLocationController.retrieveFaultCodes(equipment.id, functionalLocation.id, data2.Id).size(),
			0,
			'The Fault Codes is not being retrieved correctly'
		);
	}

	@isTest
	public static void testRetrieveFaultCodesBothIdsEquipmetFaultCodeNoRows() {
		Master_Map_Set__c mms = new Master_Map_Set__c();
		insert mms;

		Master_Map__c catelogEquipment = new Master_Map__c(
			Name = 'ELEC-0002',
			Description__c = 'EquipmentCatelogProfile',
			Master_Map_Set__c = mms.id
		);
		insert catelogEquipment;
		Master_Map__c catelogFunctional = new Master_Map__c(
			Name = 'ELEC-0005',
			Description__c = 'FLCatelogProfile',
			Master_Map_Set__c = mms.id
		);
		insert catelogFunctional;

		Equipment__c equipment = new Equipment__c(CatelogProfile__c = catelogEquipment.id);
		insert equipment;
		Functional_Location__c functionalLocation = new Functional_Location__c(
			CatelogProfile__c = catelogFunctional.id
		);
		insert functionalLocation;
		Master_Map__c ttgnl = new Master_Map__c(Name = 'TT-GNL', Master_Map_Set__c = mms.id);
		insert ttgnl;
		Master_Map__c data2 = new Master_Map__c(
			Name = 'DATA2',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap1__c = catelogFunctional.id,
			RelatedMasterMap2__c = ttgnl.id
		);
		insert data2;
		Master_Map__c t01 = new Master_Map__c(
			Name = 'T01',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest1FL'
		);
		insert t01;
		Master_Map__c t02 = new Master_Map__c(
			Name = 'T02',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest2FL'
		);
		insert t02;
		Master_Map__c t03 = new Master_Map__c(
			Name = 'T03',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest3FL'
		);
		insert t03;
		Master_Map__c data21 = new Master_Map__c(
			Name = 'DATA21',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatelogFaultCode',
			RelatedMasterMap1__c = ttgnl.id,
			RelatedMasterMap2__c = t01.id
		);
		insert data21;
		Master_Map__c data22 = new Master_Map__c(
			Name = 'DATA22',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatelogFaultCode',
			RelatedMasterMap1__c = ttgnl.id,
			RelatedMasterMap2__c = t02.id
		);
		insert data22;
		Master_Map__c data23 = new Master_Map__c(
			Name = 'DATA23',
			Master_Map_Set__c = mms.id,
			Type__c = 'NotCatelogFaultCode',
			RelatedMasterMap1__c = ttgnl.id,
			RelatedMasterMap2__c = t03.id
		);
		insert data23;

		//List<MasterMapWrapper> faultCodes2 = FunctionalLocationController.retrieveFaultCodes(equipment.id,functionalLocation.id);
		System.assertEquals(
			FunctionalLocationController.retrieveFaultCodes(equipment.id, functionalLocation.id, ttgnl.id).size(),
			2,
			'The Fault Codes is not being retrieved correctly'
		);
	}

	@isTest
	public static void testRetrieveFaultCodesJustFLId() {
		Master_Map_Set__c mms = new Master_Map_Set__c();
		insert mms;

		Master_Map__c catelogFunctional = new Master_Map__c(
			Name = 'ELEC-0005',
			Description__c = 'FLCatelogProfile',
			Master_Map_Set__c = mms.id
		);
		insert catelogFunctional;

		Functional_Location__c functionalLocation = new Functional_Location__c(
			CatelogProfile__c = catelogFunctional.id
		);
		insert functionalLocation;
		Master_Map__c ttgnl = new Master_Map__c(Name = 'TT-GNL', Master_Map_Set__c = mms.id);
		insert ttgnl;
		Master_Map__c data2 = new Master_Map__c(
			Name = 'DATA2',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap1__c = catelogFunctional.id,
			RelatedMasterMap2__c = ttgnl.id
		);
		insert data2;
		Master_Map__c t01 = new Master_Map__c(
			Name = 'T01',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest1FL'
		);
		insert t01;
		Master_Map__c t02 = new Master_Map__c(
			Name = 'T02',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest2FL'
		);
		insert t02;
		Master_Map__c t03 = new Master_Map__c(
			Name = 'T03',
			Master_Map_Set__c = mms.id,
			Description__c = 'FaultCodeTest3FL'
		);
		insert t03;
		Master_Map__c data21 = new Master_Map__c(
			Name = 'DATA21',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatelogFaultCode',
			RelatedMasterMap1__c = ttgnl.id,
			RelatedMasterMap2__c = t01.id
		);
		insert data21;
		Master_Map__c data22 = new Master_Map__c(
			Name = 'DATA22',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatelogFaultCode',
			RelatedMasterMap1__c = ttgnl.id,
			RelatedMasterMap2__c = t02.id
		);
		insert data22;
		Master_Map__c data23 = new Master_Map__c(
			Name = 'DATA23',
			Master_Map_Set__c = mms.id,
			Type__c = 'NotCatelogFaultCode',
			RelatedMasterMap1__c = ttgnl.id,
			RelatedMasterMap2__c = t03.id
		);
		insert data23;

		//Second Case
		//retrieveFaultCodes recieves Functional_Location__c
		//It should retrieve the CatelogProfile__c of the Functional_Location__c
		//List<MasterMapWrapper> faultCodes2 = FunctionalLocationController.retrieveFaultCodes(null,functionalLocation.id);
		System.assertEquals(
			FunctionalLocationController.retrieveFaultCodes(null, functionalLocation.id, null).size(),
			2,
			'The Fault Codes is not being retrieved correctly'
		);
	}

	@isTest
	public static void testRetrieveFaultCodesNoFilterData() {
		Master_Map_Set__c mms = new Master_Map_Set__c();
		insert mms;

		Master_Map__c noFilterTest1 = new Master_Map__c(Name = 'NoFilterTest1', Master_Map_Set__c = mms.id);
		insert noFilterTest1;
		noFilterTest1.Name = 'NoFilterTest1';
		update noFilterTest1;
		Master_Map__c noFilterTest2 = new Master_Map__c(Name = 'NoFilterTest1', Master_Map_Set__c = mms.id);
		insert noFilterTest2;
		noFilterTest2.Name = 'NoFilterTest1';
		update noFilterTest2;
		Master_Map__c noFilterTest3 = new Master_Map__c(Name = 'NoFilterTest2', Master_Map_Set__c = mms.id);
		insert noFilterTest3;
		noFilterTest3.Name = 'NoFilterTest2';
		update noFilterTest3;

		Master_Map__c data3 = new Master_Map__c(
			Name = 'DATA3',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap2__c = noFilterTest1.id
		);
		insert data3;
		Master_Map__c data31 = new Master_Map__c(
			Name = 'DATA31',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap2__c = noFilterTest2.id
		);
		insert data31;
		Master_Map__c data32 = new Master_Map__c(
			Name = 'DATA32',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap2__c = noFilterTest3.id
		);
		insert data32;

		Master_Map__c nofilterTest11 = new Master_Map__c(
			Name = 'NoFilterTest1',
			Master_Map_Set__c = mms.id,
			Type__c = 'Code Group',
			Description__c = 'TestDescription'
		);
		insert nofilterTest11;
		nofilterTest11.Name = 'NoFilterTest2';
		update nofilterTest11;
		Master_Map__c nofilterTest12 = new Master_Map__c(
			Name = 'NoFilterTest2',
			Master_Map_Set__c = mms.id,
			Type__c = 'Code Group',
			Description__c = 'TestDescriptionTwo'
		);
		insert nofilterTest12;
		nofilterTest12.Name = 'NoFilterTest2';
		update nofilterTest12;

		//Third Case
		//retrieveFaultCodes recieves no parameters
		//List<MasterMapWrapper> faultCodes = FunctionalLocationController.retrieveFaultCodes(null,null);
		System.assertEquals(
			FunctionalLocationController.retrieveFaultCodes(null, null, null).size(),
			0,
			'The Fault Codes is not being retrieved correctly'
		);
	}

	@isTest
	public static void testRetrieveFaultCodesNoFLCatelog() {
		Master_Map_Set__c mms = new Master_Map_Set__c();
		insert mms;

		Functional_Location__c functionalLocation = new Functional_Location__c();
		insert functionalLocation;

		Master_Map__c noFilterTest1 = new Master_Map__c(Name = 'NoFilterTest1', Master_Map_Set__c = mms.id);
		insert noFilterTest1;
		noFilterTest1.Name = 'NoFilterTest1';
		update noFilterTest1;
		Master_Map__c noFilterTest2 = new Master_Map__c(Name = 'NoFilterTest1', Master_Map_Set__c = mms.id);
		insert noFilterTest2;
		noFilterTest2.Name = 'NoFilterTest1';
		update noFilterTest2;
		Master_Map__c noFilterTest3 = new Master_Map__c(Name = 'NoFilterTest2', Master_Map_Set__c = mms.id);
		insert noFilterTest3;
		noFilterTest3.Name = 'NoFilterTest2';
		update noFilterTest3;

		Master_Map__c data3 = new Master_Map__c(
			Name = 'DATA3',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap2__c = noFilterTest1.id
		);
		insert data3;
		Master_Map__c data31 = new Master_Map__c(
			Name = 'DATA31',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap2__c = noFilterTest2.id
		);
		insert data31;
		Master_Map__c data32 = new Master_Map__c(
			Name = 'DATA32',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap2__c = noFilterTest3.id
		);
		insert data32;

		Master_Map__c nofilterTest11 = new Master_Map__c(
			Name = 'NoFilterTest1',
			Master_Map_Set__c = mms.id,
			Type__c = 'Code Group',
			Description__c = 'TestDescription'
		);
		insert nofilterTest11;
		nofilterTest11.Name = 'NoFilterTest2';
		update nofilterTest11;
		Master_Map__c nofilterTest12 = new Master_Map__c(
			Name = 'NoFilterTest2',
			Master_Map_Set__c = mms.id,
			Type__c = 'Code Group',
			Description__c = 'TestDescriptionTwo'
		);
		insert nofilterTest12;
		nofilterTest12.Name = 'NoFilterTest2';
		update nofilterTest12;

		//List<MasterMapWrapper> faultCodes = FunctionalLocationController.retrieveFaultCodes(null,functionalLocation.id);
		System.assertEquals(
			FunctionalLocationController.retrieveFaultCodes(null, functionalLocation.id, null).size(),
			0,
			'The Fault Codes is not being retrieved correctly'
		);
	}

	@isTest
	public static void testRetrieveFaultCodesFLFaultCodeNoRows() {
		Master_Map_Set__c mms = new Master_Map_Set__c();
		insert mms;

		Master_Map__c catelogFunctional = new Master_Map__c(
			Name = 'ELEC-0005',
			Description__c = 'FLCatelogProfile',
			Master_Map_Set__c = mms.id
		);
		insert catelogFunctional;

		Functional_Location__c functionalLocation = new Functional_Location__c(
			CatelogProfile__c = catelogFunctional.id
		);
		insert functionalLocation;
		Master_Map__c noFilterTest1 = new Master_Map__c(Name = 'NoFilterTest1', Master_Map_Set__c = mms.id);
		insert noFilterTest1;
		noFilterTest1.Name = 'NoFilterTest1';
		update noFilterTest1;
		Master_Map__c noFilterTest2 = new Master_Map__c(Name = 'NoFilterTest1', Master_Map_Set__c = mms.id);
		insert noFilterTest2;
		noFilterTest2.Name = 'NoFilterTest1';
		update noFilterTest2;
		Master_Map__c noFilterTest3 = new Master_Map__c(Name = 'NoFilterTest2', Master_Map_Set__c = mms.id);
		insert noFilterTest3;
		noFilterTest3.Name = 'NoFilterTest2';
		update noFilterTest3;

		Master_Map__c data3 = new Master_Map__c(
			Name = 'DATA3',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap2__c = noFilterTest1.id
		);
		insert data3;
		Master_Map__c data31 = new Master_Map__c(
			Name = 'DATA31',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap2__c = noFilterTest2.id
		);
		insert data31;
		Master_Map__c data32 = new Master_Map__c(
			Name = 'DATA32',
			Master_Map_Set__c = mms.id,
			Type__c = 'CatalogType',
			Description__c = 'FaultCode',
			RelatedMasterMap2__c = noFilterTest3.id
		);
		insert data32;

		Master_Map__c nofilterTest11 = new Master_Map__c(
			Name = 'NoFilterTest1',
			Master_Map_Set__c = mms.id,
			Type__c = 'Code Group',
			Description__c = 'TestDescription'
		);
		insert nofilterTest11;
		nofilterTest11.Name = 'NoFilterTest2';
		update nofilterTest11;
		Master_Map__c nofilterTest12 = new Master_Map__c(
			Name = 'NoFilterTest2',
			Master_Map_Set__c = mms.id,
			Type__c = 'Code Group',
			Description__c = 'TestDescriptionTwo'
		);
		insert nofilterTest12;
		nofilterTest12.Name = 'NoFilterTest2';
		update nofilterTest12;

		//List<MasterMapWrapper> faultCodes = FunctionalLocationController.retrieveFaultCodes(null,functionalLocation.id);
		System.assertEquals(
			FunctionalLocationController.retrieveFaultCodes(null, functionalLocation.id, null).size(),
			0,
			'The Fault Codes is not being retrieved correctly'
		);
	}

	@isTest
	public static void testGetUserName() {
		Test.startTest();
		String userName = FunctionalLocationController.getUserName();
		Test.stopTest();
		String expectedName = UserInfo.getUserName();
		System.assertEquals(expectedName, userName, 'User name does not match');
	}

	@isTest
	public static void testParentNotification() {
		Test.startTest();
		Notification__c noti = new Notification__c(
			Notification_Number__c = '10676451',
			Integration_Status__c = 'Success'
		);
		insert noti;
		FunctionalLocationController.getParentNotification(noti.Id);
		FunctionalLocationController.getNotificationById(noti.Id);
		Test.stopTest();
	}

	@isTest
	public static void testPositiveCase() {
		Test.startTest();
		Master_Map_Set__c mms = new Master_Map_Set__c();
		insert mms;
		Master_Map__c pl01 = new Master_Map__c(
			Name = 'P01',
			Master_Map_Set__c = mms.id,
			Description__c = 'Plant',
			Type__c = 'Plant'
		);
		insert pl01;
		FunctionalLocationController.getMainWorkCenter();
		FunctionalLocationController.hasCatelogProfileByEquipIdOrFuncId(null);

		List<Master_Map__c> mainworkcenterplantLst = FunctionalLocationController.getAllMainWorkCenterPlants();
		FunctionalLocationController.getMainWorkCenterPlants(mainworkcenterplantLst?.get(0)?.Id);
		FunctionalLocationController.getPMActivityType('CM01');

		FunctionalLocationController.MasterMapWrapper masterWrpa = new FunctionalLocationController.MasterMapWrapper();
		masterWrpa.id = pl01.Id;
		masterWrpa.name = pl01.Name;
		masterWrpa.description = pl01.Description__c;

		FunctionalLocationController.searchFaultCodeByNameAndDescription(
			'plant',
			new List<FunctionalLocationController.MasterMapWrapper>{ masterWrpa }
		);
		FunctionalLocationController.searchPMActivityTypeByNameAndDescription('plant', new List<Master_Map__c>{ pl01 });

		FunctionalLocationController.searchMainWorkCenterByNameAndDescription(
			'plant',
			new List<Master_Map__c>{
				new Master_Map__c(RelatedMasterMap1__r = new Master_Map__c(Name = 'Plant', Description__c = 'Plant'))
			}
		);
		FunctionalLocationController.searchMainWorkCenterPlantByNameAndDescription(
			'plant',
			new List<Master_Map__c>{ new Master_Map__c(Name = 'Plant', Description__c = 'Plant') }
		);

		Test.stopTest();
	}
}