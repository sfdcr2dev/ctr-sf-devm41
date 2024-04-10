@isTest
public class THOR_iRPAIntegration_AttachmentTest {
	@TestSetup
	static void makeData() {
		// OPP_FileUploaderHelper.uploadFile(base64, filename, recordId)
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

    insert new Notification_File__c(
      File_Id__c = '0699D000000a3RgQAI',
      File_Name__c = 'Notification_File__c',
      SAP_File_Id__c = 'SAP_1234'
    );
	}

	@isTest
	static void testCreateAttachmentNegative() {
		Test.startTest();
		String uuid = Uuid.randomUUID();
		String requestBody = JSON.serialize(
			new Map<String, Object>{
        'access_token' => 'access_token',
				'input' => new Map<String, Object>{
					'NotificationAttachmentData' => new Map<String, Object>{
						'notification_attachment' => new List<Object>{
							new Map<String, Object>{
								'notification_number' => '9012341234',
								'sap_file_id' => '000012341234',
								'file_Id' => '',
								'file_name' => 'Test name',
								'link' => 'https://example.com/',
								'action' => '1',
								'object_type' => 'BUS2038',
								'flag' => 'Created'
							}
						},
						'uuid' => uuid,
						'notification_id' => 'notificationId'
					}
				},
				'invocationContext' => '${invocation_context}',
        'severity' => 'ERROR'
			}
		);

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseTest(200, requestBody));
		THOR_iRPAIntegration_NotificationFile.calloutToIRPA_NotificationFile('notiBodyFiesIds', uuid, 'Created', requestBody);

		Test.stopTest();
	}


  @isTest
  static void testResponse_NotificationFile() {
	  RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZIPM0021';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, Object>{
					'Notification_File__c' => new Map<String, Object>{
						'Integration_Status__c' => 'Success',
						'Integration_Message__c' => 'Delete Success',
            'SAP_File_Id__c' => 'SAP_1234'
					},
          'notification_id' => 'a0J9D000001cuxtUAA',
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
  static void testResponse_NotificationFile_Fail() {
	  RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZIPM0021';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, Object>{
					'Notification_File__c' => new Map<String, Object>{
						'Integration_Status__c' => 'Success',
						'Integration_Message__c' => null,
            'SAP_File_Id__c' => 'SAP_1234'
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