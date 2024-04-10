@isTest
public class C360_SapBApiWebservicesTest {
    @TestSetup
	static void makeData() {
		insert new C360Integration__c(
			iRPA_FinancialInfo_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/4d27c00d-88d0-42b2-903d-635b7f6417e6/runs',
            /*
			iRPA_Cause_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/9b66fcb5-afd2-4efc-8df4-02cd388763d5/runs',
			iRPA_Item_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/379306a7-6d2f-4e41-a453-a97571d2ae46/runs',
			iRPA_Notification_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/da5e1e42-b930-488c-9a3f-2dfd83a847c2/runs',
			iRPA_Order_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/796827c3-2153-4e9c-8f95-3b2ec33a4c8d/runs',
			iRPA_Spare_Part_Request_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/796827c3-2153-4e9c-8f95-3b2ec33a4c8d/runs',
			iRPA_Notification_File_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/f857551a-f217-4ec2-a88c-f0b437a2a386/runs',
			iRPA_WorkClearance_Endpoint__c = 'https://api.irpa.cfapps.ap10.hana.ondemand.com/runtime/v1/apiTriggers/fea37188-6d8e-41b6-8754-c4c346591e1c/runs',
			*/
			iRPA_Token_Endpoint__c = 'https://thaioilgroup.authentication.ap10.hana.ondemand.com/oauth/token',
			iRPA_Client_Id__c = 'sb-761730fd-61a8-4d2b-bb32-38a3a87c4937!b392|sapmlirpa--irpa--production--uaa-service-broker!b68',
			iRPA_Client_Secret_Id__c = 'mBfD57T9/SwUen1EAngURpgKEy4=',
			iRPA_API_Key_Header__c = 'irpa-api-key',
			iRPA_API_Key__c = 'TuibUORAfwohHT_FzvhM-6AKB14_GYiW'
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
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.AccountNumber__c = '0000000001';
        insert acc;
	}

    @isTest
	static void testHttpPost_Log() {
		RestRequest req = new RestRequest();

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/C360bapi/LOG';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, Object>{
					'sparePartRequests' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                            'Id' => 'a0N9D0000019PvwUAE',
                            'Integration_Status__c' => 'Success',
                            'Integration_Message__c' => 'Create Success'
                        }
                    },
					'orderId' => 'a0M9D000001Fh3LUAS',
					'uuid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9'
				}
			)
		);
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9' }));
		RestContext.response = res;

		Test.startTest();
		C360_SapBApiWebservices.httpPostWebservice();
		Test.stopTest();
	}

    @isTest
	static void testHttpPost_Financial() {
	 	RestRequest req = new RestRequest();

	 	req.httpMethod = 'POST';
	 	req.requestUri = '/services/apexrest/C360bapi/BAPI_FINANCIAL_INFO';
	 	req.requestBody = Blob.valueof(
	 		JSON.serialize(
	 			new Map<String, Object>{
	 				'C360_FinancialInfo__c' => new Map<String, Object>{
	 					'CompanyName__c' => '000010728305',
                         'CompanyCode__c' => '000010728305',
                         'CreditControlArea__c' => '000010728305',
                         'CreditLimit__c' => '000010728305',
                         'CreditBalance__c' => '000010728305',
                         'Outstanding__c' => '000010728305'
	 				},
	 				'uuid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9'
	 			}
	 		)
	 	);
	 	RestContext.request = req;

	 	RestResponse res = new RestResponse();
	 	res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9','CompanyName__c' => '000010728305',
                         'CompanyCode__c' => '000010728305',
                         'CreditControlArea__c' => '000010728305',
                         'CreditLimit__c' => '000010728305',
                         'CreditBalance__c' => '000010728305',
                         'Outstanding__c' => '000010728305',
           				 'Message_Type__c' => 'Success',
                         'Response_Body__c' => 'b17529a1-54b2-4726-a8ca-a9ff9d61cc0e'}));
	 	RestContext.response = res;

	 	Test.startTest();
	 	C360_SapBApiWebservices.httpPostWebservice();
	 	Test.stopTest();
	}
    
    @isTest
    public static void executeTest()
    {
        
        String jsonSTR = '{"results" : [ { "BUKRS" : "1400", "KKBER" : "1400", "CASHC" : "THB", "KUNNR" : "0000000001", "KLIMK" : "6000000.00", "KNKLI" : "0000000001", "KLPRZ" : "0.00", "SKFOR" : "0.00", "SSOBL" : "0.00", "SAUFT" : "0.00", "OBLIG" : "0.00", "ABSBT" : "0.00", "CTLPC" : "B", "CRBLB" : "X"}]}, "gateway_id"="2304a315-9df9-42c8-99a6-ca656ad759cb"}';

        Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR); 
        
        Test.startTest(); 
        C360_BApiFinancialInfoHelper.execute('component_endpoint',response_value);
        Test.stopTest();
        
        List<Application_Log__c> log = [select id from Application_Log__c];
        
        system.assert(log.size() > 0);
    }
/*
    @isTest
	static void testHttpPost_NotiFile() {
		RestRequest req = new RestRequest();

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZIPM0021';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, Object>{
					'Notification_File__c' => new Map<String, Object>{
						'Id' => 'a0a9D000002XOJaQAO',
						'Integration_Status__c' => 'Success',
						'Integration_Message__c' => 'Create Success'
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
	static void testHttpPost_Order() {
		RestRequest req = new RestRequest();

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZPI_BAPI_ALM_ORDER_CREATE';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, Object>{
					'Order__c' => new Map<String, Object>{
						'Id' => 'a0M9D000001Fh3LUAS',
						'Name' => '000010730677',
                        'Requested_Date__c' => '2021-11-03',
						'Integration_Status__c' => 'Success',
						'Integration_Message__c' => 'Create Success',
						'System_Status_Text__c' => '',
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
	static void testHttpPost_Component() {
		RestRequest req = new RestRequest();

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZPM_BAPI_COMPONENT';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, Object>{
					'Log' => new Map<String, Object>{
						'Status' => 'Success',
						'Message' => 'Notification Created Successfully'
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
	static void testHttpPost_WorkClearance() {
		Work_Clearance__c wc = new Work_Clearance__c();
        wc.Name = '900444001';
        wc.Integration_Status__c = 'In Progress';
        insert wc;

		RestRequest req = new RestRequest();

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZPM_CREATE_CC_NOTIF';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, Object>{
					'Work_Clearance__c' => new Map<String, Object>{
						'Id' => wc.Id,
						'Name' => '900444001',
                        'Extend_No__c' => '',
						'Integration_Status__c' => 'Success',
						'Integration_Message__c' => 'Operational WCD was saved with number 900444001',
						'System_Status_Text__c' => 'CRTE',
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
	static void testHttpPost_Item() {
		Notification__c noti = new Notification__c();
        noti.Name = '10728301';
        insert noti;

		Item__c item = new Item__c();
		item.Notification__c = noti.Id;
		insert item;

		Cause__c cause = new Cause__c();
		cause.Item__c = item.Id;
		insert cause;

		Activity__c activity = new Activity__c();
		activity.Item__c = item.Id;
		activity.Notification__c = noti.Id;
		insert activity;

		RestRequest req = new RestRequest();

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/bapi/ZPI_BAPI_ALM_ITEM_CREATE';
		req.requestBody = Blob.valueof('{ \"items\" : [ { \"Id\" : \"' + item.Id + '\", \"Sort_No__c\" : \"0001\", \"Item_No__c\" : \"0001\", \"Integration_Status__c\" : \"Success\", \"Integration_Message__c\" : \"Notification 000010728376 saved\", \"Cause__c\" : [ { \"Id\" : \"' + cause.Id + '\", \"Sort_No__c\" : \"0001\", \"Cause_No__c\" : \"0001\", \"Integration_Status__c\" : \"Success\", \"Integration_Message__c\" : \"Notification 000010728376 saved\" } ], \"Activity__c\" : [ { \"Id\" : \"' + activity.Id + '\", \"Sort_No__c\" : \"0001\", \"Activity_No__c\" : \"0001\", \"Integration_Status__c\" : \"Success\", \"Integration_Message__c\" : \"Notification 000010728376 saved\" } ] } ], \"uuid\" : \"36341b92-1824-46f6-a7a7-5b4dc4aeb69a\" }');
		RestContext.request = req;

		RestResponse res = new RestResponse();
		res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{ 'jobUid' => '2c8c6e1b-e813-42a2-8181-1934fe8c01a9' }));
		RestContext.response = res;

		Test.startTest();
		THOR_SapBApiWebservices.httpPostWebservice();
		Test.stopTest();
	}
*/
    @isTest
	static void testHttpPost_NoMethodFound() {
		RestRequest req = new RestRequest();

		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/C360bapi/ZPM_BAPI_NO_METHOD';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, Object>{
					'Order__c' => new Map<String, Object>{
						'Id' => 'a0M9D000001Fh3LUAS',
						'Name' => '000010730677',
                        'Requested_Date__c' => '2021-11-03',
						'Integration_Status__c' => 'Success',
						'Integration_Message__c' => 'Create Success',
						'System_Status_Text__c' => '',
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
		C360_SapBApiWebservices.httpPostWebservice();
		Test.stopTest();
	}

    @isTest
	static void testWebServiceExtend() {
        WebserviceExtend.dto_response dto = WebServiceExtend.parse(JSON.serialize(
            new Map<String, Object>{
                'description' => new Map<String, Object>{
                    'success' => true,
                    'message' => 'Create Success',
                    'linkurl' => 'https://login.salesforce.com/'
                }
            }
        ));

        System.assertEquals(true, dto.description.success);
        System.assertEquals('Create Success', dto.description.message);
        System.assertEquals('https://login.salesforce.com/', dto.description.linkurl);

        String json = dto.parseToJSON();
    }

    @isTest
	static void testWebServiceExtend_GetErrorMessageDMLException() {
        try {
            Notification__c noti = new Notification__c();
            noti.Notification_Number__c = '100000000000000000001';
            insert noti;
        } catch(DmlException e) {
            WebserviceExtend.getErrorMessageException(e);
        } catch (Exception e) {
            WebserviceExtend.getErrorMessageException(e);
        }
    }

    @isTest
	static void testWebServiceExtend_GetErrorMessageException() {
        try {
            Notification__c noti = new Notification__c();
            noti.Notification_Number__c = '100000000000000000001';
            insert noti;
        } catch (Exception e) {
            WebserviceExtend.getErrorMessageException(e);
        }
    }
}