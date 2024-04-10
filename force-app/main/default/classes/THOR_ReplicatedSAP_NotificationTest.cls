/**
 * @description       :
 * @author            : narathip.s@roundtwosolutions.com
 * @group             :
 * @last modified on  : 04-28-2022
 * @last modified by  : narathip.s@roundtwosolutions.com
 **/
@isTest
public class THOR_ReplicatedSAP_NotificationTest {
	@TestSetup
	static void makeData() {
		insert new List<PISUsers__c>{
			new PISUsers__c(
				Name = 'PisUser-01',
				EMPLOYEEID__c = '00000001',
				HOST_ID__c = '00000001',
				HOME_ID__c = '00000001'
			),
			new PISUsers__c(
				Name = 'PisUser-02',
				EMPLOYEEID__c = '00000002',
				HOST_ID__c = '00000002',
				HOME_ID__c = '00000002'
			)
		};

		insert new Equipment__c(Name = '30000682');
		insert new Functional_Location__c(Name = 'TPX-76-LG-033B');

		Master_Map__c M_FAN = new Master_Map__c(Name = 'M-FAN', Code__c = 'M-FAN', Type__c = 'Code Group');
		Master_Map__c MO01 = new Master_Map__c(Name = 'MO01', Code__c = 'MO01', Type__c = 'Object Part');
		insert new List<Master_Map__c>{
			new Master_Map__c(Name = 'ENMF-M', Code__c = 'ENMF-M', Type__c = 'Main Work Center'),
                new Master_Map__c(Name = 'IDD', Code__c = 'IDD', Type__c = 'PlannerGroup'), //ODM
			new Master_Map__c(Name = 'MF37', Code__c = 'MF37', Type__c = 'FaultCode'),
			new Master_Map__c(Name = 'M-PUMP', Code__c = 'M-PUMP', Type__c = 'Code Group'),
			new Master_Map__c(Name = '1200', Code__c = '1200', Type__c = 'Plant'),
			new Master_Map__c(Name = 'EE-CHG', Code__c = 'EE-CHG', Type__c = 'Code Group'),
			new Master_Map__c(Name = 'E01', Code__c = 'E01', Type__c = 'Damage'),
			new Master_Map__c(Name = 'E01', Code__c = 'E01', Type__c = 'Object Part'),
                new Master_Map__c(Name = 'ELEC-DA', Code__c = 'ELEC-DA', Type__c = 'Object Part'),
			MO01,
			M_FAN,
			new Master_Map__c(Name = 'ELEC-DA', Code__c = 'ELEC-DA', Type__c = 'Object Part'),
			new Master_Map__c(Name = 'M-DAM01', Code__c = 'M-DAM01', Type__c = 'Code Group'),
			new Master_Map__c(Name = 'MD01', Code__c = 'MD01', Type__c = 'Damage'),
			new Master_Map__c(Name = 'MC01', Code__c = 'MC01', Type__c = 'Code Group'),
			new Master_Map__c(Name = 'M-CAU01', Code__c = 'M-CAU01', Type__c = 'Code Group'),
			new Master_Map__c(Name = 'M-ACT01', Code__c = 'M-ACT01', Type__c = 'Code Group'),
			new Master_Map__c(Name = 'MA01', Code__c = 'MA01', Type__c = 'Code Group')
		};

		insert new List<Master_Map__c>{
			new Master_Map__c(
				Type__c = 'CatelogObjectPart',
				RelatedMasterMap1__c = M_FAN.Id,
				RelatedMasterMap2__c = MO01.Id
			),
			new Master_Map__c(
				Type__c = 'CatelogDamage',
				RelatedMasterMap1__r = new Master_Map__c(Name = 'M-DAM01'),
				RelatedMasterMap2__r = new Master_Map__c(Name = 'MD01')
			),
			new Master_Map__c(
				Type__c = 'CatelogCause',
				RelatedMasterMap1__r = new Master_Map__c(Name = 'M-CAU01'),
				RelatedMasterMap2__r = new Master_Map__c(Name = 'MC01')
			),
			new Master_Map__c(
				Type__c = 'CatelogActivity',
				RelatedMasterMap1__r = new Master_Map__c(Name = 'M-ACT01'),
				RelatedMasterMap2__r = new Master_Map__c(Name = 'MA01')
			)
			// new Master_Map__c(Name = 'MF37', Type__c = 'FaultCode'),
			// new Master_Map__c(Name = 'M-PUMP', Type__c = 'Code Group'),
			// new Master_Map__c(Name = '1200', Type__c = 'Plant'),
			// new Master_Map__c(Name = 'EE-CHG', Type__c = 'Code Group'),
			// new Master_Map__c(Name = 'E01', Type__c = 'Damage'),
			// new Master_Map__c(Name = 'E01', Type__c = 'Object Part'),
			// new Master_Map__c(Name = 'M-FAN', Type__c = 'Code Group'),
			// new Master_Map__c(Name = 'MO01', Type__c = 'Object Part'),
			// new Master_Map__c(Name = 'ELEC-DA', Type__c = 'Object Part')
		};
	}

	@IsTest
	static void testWebService() {
		Test.startTest();
		THOR_ReplicatedSAP_Notification.dto_response dto = new THOR_ReplicatedSAP_Notification.dto_response();
		Object recordIds = dto.recordIds;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/notification';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{"NOTILIST":[{"NOTIFNUM":"10728582    ","NOTIFTYP":"CM","FUNCLOC":"TPX-76-LG-033B","EQNUM":"30000682          ","ORDERNUM":"10730984","WCNUM":"","SYSSTATUS":"OSNO","USERSTATUS":"","RESPPERNO":"","MAINWC":"ENMF-M","PRIORITY":"3","REQDATE":"2022-03-31","REQSTART":"2022-03-31","REQEND":"2022-04-29","NOTIFDESC":"UATNotif#4","BREAKDOWN":"","FAULTCODE":"MF37","HISTORY":[{"NOTIFNUM":"10728582 ","TDLINE":"* 01.12.2020 11:29:37 THIPWARIN SAENGKAEW (ZTHIPWARIN)"},{"NOTIFNUM":"10728582 ","TDLINE":"* test"},{"NOTIFNUM":"10728582 ","TDLINE":"* 27.06.2021 10:19:00 THIPWARIN SAENGKAEW (ZTHIPWARIN)"},{"NOTIFNUM":"10728582 ","TDLINE":"* 2test"},{"NOTIFNUM":"10728582 ","TDLINE":"* 22.09.2021 13:53:48 THIPWARIN SAENGKAEW (ZTHIPWARIN)"},{"NOTIFNUM":"10728582 ","TDLINE":"* 8. Wire arc thermal spray shaft on DE(#ตำแหน่ง Bearing) 9. Wire arc"},{"NOTIFNUM":"10728582 ","TDLINE":" thermal spray shaft on DE(#ตำแหน่งฝาประกับ)"}],"CODEGROUP":"M-LG","ITEMLIST":[{"NOTIFNUM":"10728582    ","ITEMNUM":"0001","OBJCODEGROUP":"M-FAN","OBJCODE":"MO01","DAMCODEGROUP":"M-DAM01","DAMCODE":"MD01","ITEMTEXT":""}],"CAUSELIST":[{"NOTIFNUM":"10728582    ","ITEMNUM":"0001","CAUSENUM":"0001","CAUCODEGROUP":"M-CAU01","CAUCODE":"MC01","CAUSETEXT":""}],"ACTIVITYLIST":[{"NOTIFNUM":"10728582    ","ITEMNUM":"0001","ACTNUM":"0001","ACTCODEGROUP":"M-ACT01","ACTCODE":"MA01","ACTTEXT":""}],"REQUESTER":"616         ","MAINWORKCENTERPLANT":"3200"}]}'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		THOR_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}

	@IsTest
	static void testWebServiceJsonParse() {
		Test.startTest();
		THOR_ReplicatedSAP_Notification.dto_response dto = new THOR_ReplicatedSAP_Notification.dto_response();
		Object recordIds = dto.recordIds;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/notification';
		req.requestBody = Blob.valueof(
			JSON.serialize(new Map<String, OBject>{ 'gateway_id' => uuidTxt, 'body' => '{"NOTILIST":[{]}' })
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => uuidTxt }));
		RestContext.response = res;

		THOR_ReplicatedSAPWebServices.httpPostWebservice();
		Test.stopTest();
	}
}