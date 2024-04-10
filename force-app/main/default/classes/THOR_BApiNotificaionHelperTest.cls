@isTest
public class THOR_BApiNotificaionHelperTest {
	@TestSetup
	static void makeData() {
		insert new THORIntegration__c(
			iRPA_Activity_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/62809190-58e0-4569-a1b0-5ada28cf6999/runs',
			iRPA_Cause_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/9b66fcb5-afd2-4efc-8df4-02cd388763d5/runs',
			iRPA_Item_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/379306a7-6d2f-4e41-a453-a97571d2ae46/runs',
			iRPA_Notification_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/da5e1e42-b930-488c-9a3f-2dfd83a847c2/runs',
			iRPA_Order_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/796827c3-2153-4e9c-8f95-3b2ec33a4c8d/runs',
			iRPA_Spare_Part_Request_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/796827c3-2153-4e9c-8f95-3b2ec33a4c8d/runs',
			iRPA_Notification_File_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/f857551a-f217-4ec2-a88c-f0b437a2a386/runs',
			iRPA_Token_Endpoint__c = 'https://thaioilgroup.authentication.ap10.hana.ondemand.com/oauth/token',
			iRPA_Client_Id__c = 'asdfhaskldhfjaksehkfjahsekfahjsdlfasjkdfjakls;dfjakls;ej;asefasefl;akse;;lefk',
			iRPA_Client_Secret_Id__c = 'qwefasdkjhfl/hqwuyqiouwhadkfal;shdf;k=',
			iRPA_API_Key_Header__c = 'irpa-api-key',
			iRPA_API_Key__c = 'ahsguegasdhlaksdgjal;skdjklge;hl'
		);

		Functional_Location__c fl = new Functional_Location__c(Name = 'Test-TPX-76-LG-033B');
		insert fl;
		Equipment__c eq = new Equipment__c(Name = 'Test Equipment', FL__c = fl.Id);
		insert eq;
		insert new Notification__c(
			// Name
			Priority__c = 'Normal',
			Type__c = '',
			Functional_Location__c = fl.Id,
			Equipment__c = eq.Id,
			Requested_Date__c = Date.today(),
			Required_Start__c = Date.today(),
			Required_End__c = Date.today(),
			Description__c = 'Test create order under noti2',
			Integration_Status__c = 'In Progress'
		);

		THOR_BApiNotificaionHelper.dto_response dto = new THOR_BApiNotificaionHelper.dto_response();
		dto.result = null;
	}

	@isTest
	static void testHttpPost_NotiCreate() {
		RestRequest req = new RestRequest();

		Test.startTest();

		Notification__c noti = [SELECT Id FROM Notification__c LIMIT 1];

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZPI_BAPI_ALM_NOTIF_CREATE';
		req.requestBody = Blob.valueof(
			'{"Notification__c":{"Id":"' + noti.Id + '","Notification_Number__c":"000010728305","Integration_Status__c":"Success","Integration_Message__c":"Create Success","System_Status_Text__c":"","User_Status__c":""},"uuid":"2c8c6e1b-e813-42a2-8181-1934fe8c01a9"}'
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9' }));
		RestContext.response = res;

		THOR_SapBApiWebservices.httpPostWebservice();
		Test.stopTest();
	}

	@isTest
	static void testHttpPost_NotiCreate_DMLException() {
		RestRequest req = new RestRequest();

		Notification__c noti = [SELECT Id FROM Notification__c LIMIT 1];

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZPI_BAPI_ALM_NOTIF_CREATE';
		req.requestBody = Blob.valueof(
			'{"Notification__c":{"Id":"' + noti.Id + '","Notification_Number__c":"100000000000000000001","Integration_Status__c":"Success","Integration_Message__c":"Create Success","System_Status_Text__c":"","User_Status__c":""},"uuid":"2c8c6e1b-e813-42a2-8181-1934fe8c01a9"}'
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9' }));
		RestContext.response = res;

		Test.startTest();
    try {
      THOR_SapBApiWebservices.httpPostWebservice();
    } catch (Exception e) {
      System.debug(e.getMessage());
    }
		Test.stopTest();
	}

	@isTest
	static void testHttpPost_NotiClose() {
		RestRequest req = new RestRequest();

		Notification__c noti = [SELECT Id FROM Notification__c LIMIT 1];

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZPI_BAPI_ALM_NOTIF_CREATE';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, Object>{
					'Notification__c' => new Map<String, Object>{
						'Id' => noti.Id,
						'Notification_Number__c' => '000010728305',
						'Integration_Status__c' => 'Success',
						'Integration_Message__c' => 'Create Success',
						'System_Status_Text__c' => 'NOCO',
						'User_Status__c' => ''
					},
					'uuid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9' }));
		RestContext.response = res;

		Test.startTest();
		THOR_SapBApiWebservices.httpPostWebservice();
		Test.stopTest();
	}

	@isTest
	static void testHttpPost_Fail() {
		RestRequest req = new RestRequest();

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZPI_BAPI_ALM_NOTIF_CREATE';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, Object>{
					'Notification__c' => new Map<String, Object>{
						'Integration_Status__c' => 'Failed',
						'Integration_Message__c' => 'Some went wrong.',
						'Required_Start__c' => null,
						'Required_End__c' => null
					},
					'uuid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9' }));
		RestContext.response = res;

		Test.startTest();
		THOR_SapBApiWebservices.httpPostWebservice();
		Test.stopTest();
	}
}