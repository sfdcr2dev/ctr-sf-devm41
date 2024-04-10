@isTest
public class THOR_ReplicatedSAP_OrderTest {
    @IsTest
	static void testWebService() {
		Test.startTest();
		THOR_ReplicatedSAP_Order.dto_response dto = new THOR_ReplicatedSAP_Order.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/order';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"ORDERLIST\":[{\"ORDERNUM\":\"10730964\",\"SUPORDER\":\"\",\"ORDERTYPE\":\"CM01\",\"FUNCLOC\":\"PM-9501B\",\"EQNUM\":\"10011025\",\"ORDERDESC\":\"Test on 25.03.2022 (2)\",\"NOTFNUM\":\"\",\"PMACTTYPE\":\"M01\",\"SYSSTATUS\":\"WCM  CRTD MANC NTUP\",\"USERSTATUS\":\"INIL\",\"RESPPERNO\":\"1219\",\"MAINWC\":\"ENMC-M\",\"PRIORITY\":\"3\",\"CREATEDATE\":\"2022-03-25\",\"BSCSTART\":\"2022-03-25\",\"BSCFIN\":\"2022-05-17\",\"OPERATIONLIST\":[{\"ORDERNUM\":\"10730964\",\"OPERATION\":\"0010\",\"MAINWC\":\"ENMC-M\",\"WCPLANT\":\"1200\",\"CONTROLKEY\":\"ZPM1\",\"OPETEXT\":\"Test on 25.03.2022 (2)\",\"SUBOPERATION\":\"\"}],\"SPAREPARTLIST\":[{\"ORDERNUM\":\"10731004\",\"OPERATION\":\"0010\",\"ITEMNUM\":\"0010\",\"COMPONENT\":\"2362050133\",\"REQQNT\":\"1.000 \",\"UNIT\":\"PC\",\"IC\":\"L\",\"ITEMCATE\":\"L\",\"PPLANT\":\"3200\",\"SYSSTATUS\":\"\",\"AVAIQNT\":\"\",\"COMDESC\":\"BACK-UP RING,COUPLING HUB\"}],\"REQUESTOR\":\"1777\",\"PLANNINGPLANT\":\"1200\",\"GROUPTASK\":\"\",\"GROUPCOUNT\":\"\",\"MAINWORKCENTERPLANT\":\"1200\",\"WBS\":\"A-1100000-CE-09500\"}]}'
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
	static void testWebServiceBatch() {
		Test.startTest();
		THOR_ReplicatedSAP_Order.dto_response dto = new THOR_ReplicatedSAP_Order.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/order';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"ORDERLIST\":[{\"ORDERNUM\":\"10730964\",\"SUPORDER\":\"\",\"ORDERTYPE\":\"CM01\",\"FUNCLOC\":\"PM-9501B\",\"EQNUM\":\"10011025\",\"ORDERDESC\":\"Test on 25.03.2022 (2)\",\"NOTFNUM\":\"\",\"PMACTTYPE\":\"M01\",\"SYSSTATUS\":\"WCM  CRTD MANC NTUP\",\"USERSTATUS\":\"INIL\",\"RESPPERNO\":\"1219\",\"MAINWC\":\"ENMC-M\",\"PRIORITY\":\"3\",\"CREATEDATE\":\"2022-03-25\",\"BSCSTART\":\"2022-03-25\",\"BSCFIN\":\"2022-05-17\",\"OPERATIONLIST\":[{\"ORDERNUM\":\"10730964\",\"OPERATION\":\"0010\",\"MAINWC\":\"ENMC-M\",\"WCPLANT\":\"1200\",\"CONTROLKEY\":\"ZPM1\",\"OPETEXT\":\"Test on 25.03.2022 (2)\",\"SUBOPERATION\":\"\"}],\"SPAREPARTLIST\":[{\"ORDERNUM\":\"10731004\",\"OPERATION\":\"0010\",\"ITEMNUM\":\"0010\",\"COMPONENT\":\"2362050133\",\"REQQNT\":\"1.000 \",\"UNIT\":\"PC\",\"IC\":\"L\",\"ITEMCATE\":\"L\",\"PPLANT\":\"3200\",\"SYSSTATUS\":\"\",\"AVAIQNT\":\"\",\"COMDESC\":\"BACK-UP RING,COUPLING HUB\"}],\"REQUESTOR\":\"1777\",\"PLANNINGPLANT\":\"1200\",\"GROUPTASK\":\"\",\"GROUPCOUNT\":\"\",\"MAINWORKCENTERPLANT\":\"1200\",\"WBS\":\"A-1100000-CE-09500\"},{\"ORDERNUM\":\"10730965\",\"SUPORDER\":\"\",\"ORDERTYPE\":\"CM01\",\"FUNCLOC\":\"PM-9501B\",\"EQNUM\":\"10011025\",\"ORDERDESC\":\"Test on 25.03.2022 (2)\",\"NOTFNUM\":\"\",\"PMACTTYPE\":\"M01\",\"SYSSTATUS\":\"WCM  CRTD MANC NTUP\",\"USERSTATUS\":\"INIL\",\"RESPPERNO\":\"1219\",\"MAINWC\":\"ENMC-M\",\"PRIORITY\":\"3\",\"CREATEDATE\":\"2022-03-25\",\"BSCSTART\":\"2022-03-25\",\"BSCFIN\":\"2022-05-17\",\"OPERATIONLIST\":[{\"ORDERNUM\":\"10730964\",\"OPERATION\":\"0010\",\"MAINWC\":\"ENMC-M\",\"WCPLANT\":\"1200\",\"CONTROLKEY\":\"ZPM1\",\"OPETEXT\":\"Test on 25.03.2022 (2)\",\"SUBOPERATION\":\"\"}],\"SPAREPARTLIST\":[{\"ORDERNUM\":\"10731004\",\"OPERATION\":\"0010\",\"ITEMNUM\":\"0010\",\"COMPONENT\":\"2362050133\",\"REQQNT\":\"1.000 \",\"UNIT\":\"PC\",\"IC\":\"L\",\"ITEMCATE\":\"L\",\"PPLANT\":\"3200\",\"SYSSTATUS\":\"\",\"AVAIQNT\":\"\",\"COMDESC\":\"BACK-UP RING,COUPLING HUB\"}],\"REQUESTOR\":\"1777\",\"PLANNINGPLANT\":\"1200\",\"GROUPTASK\":\"\",\"GROUPCOUNT\":\"\",\"MAINWORKCENTERPLANT\":\"1200\",\"WBS\":\"A-1100000-CE-09500\"},{\"ORDERNUM\":\"10730966\",\"SUPORDER\":\"\",\"ORDERTYPE\":\"CM01\",\"FUNCLOC\":\"PM-9501B\",\"EQNUM\":\"10011025\",\"ORDERDESC\":\"Test on 25.03.2022 (2)\",\"NOTFNUM\":\"\",\"PMACTTYPE\":\"M01\",\"SYSSTATUS\":\"WCM  CRTD MANC NTUP\",\"USERSTATUS\":\"INIL\",\"RESPPERNO\":\"1219\",\"MAINWC\":\"ENMC-M\",\"PRIORITY\":\"3\",\"CREATEDATE\":\"2022-03-25\",\"BSCSTART\":\"2022-03-25\",\"BSCFIN\":\"2022-05-17\",\"OPERATIONLIST\":[{\"ORDERNUM\":\"10730964\",\"OPERATION\":\"0010\",\"MAINWC\":\"ENMC-M\",\"WCPLANT\":\"1200\",\"CONTROLKEY\":\"ZPM1\",\"OPETEXT\":\"Test on 25.03.2022 (2)\",\"SUBOPERATION\":\"\"}],\"SPAREPARTLIST\":[{\"ORDERNUM\":\"10731004\",\"OPERATION\":\"0010\",\"ITEMNUM\":\"0010\",\"COMPONENT\":\"2362050133\",\"REQQNT\":\"1.000 \",\"UNIT\":\"PC\",\"IC\":\"L\",\"ITEMCATE\":\"L\",\"PPLANT\":\"3200\",\"SYSSTATUS\":\"\",\"AVAIQNT\":\"\",\"COMDESC\":\"BACK-UP RING,COUPLING HUB\"}],\"REQUESTOR\":\"1777\",\"PLANNINGPLANT\":\"1200\",\"GROUPTASK\":\"\",\"GROUPCOUNT\":\"\",\"MAINWORKCENTERPLANT\":\"1200\",\"WBS\":\"A-1100000-CE-09500\"},{\"ORDERNUM\":\"10730967\",\"SUPORDER\":\"\",\"ORDERTYPE\":\"CM01\",\"FUNCLOC\":\"PM-9501B\",\"EQNUM\":\"10011025\",\"ORDERDESC\":\"Test on 25.03.2022 (2)\",\"NOTFNUM\":\"\",\"PMACTTYPE\":\"M01\",\"SYSSTATUS\":\"WCM  CRTD MANC NTUP\",\"USERSTATUS\":\"INIL\",\"RESPPERNO\":\"1219\",\"MAINWC\":\"ENMC-M\",\"PRIORITY\":\"3\",\"CREATEDATE\":\"2022-03-25\",\"BSCSTART\":\"2022-03-25\",\"BSCFIN\":\"2022-05-17\",\"OPERATIONLIST\":[{\"ORDERNUM\":\"10730964\",\"OPERATION\":\"0010\",\"MAINWC\":\"ENMC-M\",\"WCPLANT\":\"1200\",\"CONTROLKEY\":\"ZPM1\",\"OPETEXT\":\"Test on 25.03.2022 (2)\",\"SUBOPERATION\":\"\"}],\"SPAREPARTLIST\":[{\"ORDERNUM\":\"10731004\",\"OPERATION\":\"0010\",\"ITEMNUM\":\"0010\",\"COMPONENT\":\"2362050133\",\"REQQNT\":\"1.000 \",\"UNIT\":\"PC\",\"IC\":\"L\",\"ITEMCATE\":\"L\",\"PPLANT\":\"3200\",\"SYSSTATUS\":\"\",\"AVAIQNT\":\"\",\"COMDESC\":\"BACK-UP RING,COUPLING HUB\"}],\"REQUESTOR\":\"1777\",\"PLANNINGPLANT\":\"1200\",\"GROUPTASK\":\"\",\"GROUPCOUNT\":\"\",\"MAINWORKCENTERPLANT\":\"1200\",\"WBS\":\"A-1100000-CE-09500\"},{\"ORDERNUM\":\"10730968\",\"SUPORDER\":\"\",\"ORDERTYPE\":\"CM01\",\"FUNCLOC\":\"PM-9501B\",\"EQNUM\":\"10011025\",\"ORDERDESC\":\"Test on 25.03.2022 (2)\",\"NOTFNUM\":\"\",\"PMACTTYPE\":\"M01\",\"SYSSTATUS\":\"WCM  CRTD MANC NTUP\",\"USERSTATUS\":\"INIL\",\"RESPPERNO\":\"1219\",\"MAINWC\":\"ENMC-M\",\"PRIORITY\":\"3\",\"CREATEDATE\":\"2022-03-25\",\"BSCSTART\":\"2022-03-25\",\"BSCFIN\":\"2022-05-17\",\"OPERATIONLIST\":[{\"ORDERNUM\":\"10730964\",\"OPERATION\":\"0010\",\"MAINWC\":\"ENMC-M\",\"WCPLANT\":\"1200\",\"CONTROLKEY\":\"ZPM1\",\"OPETEXT\":\"Test on 25.03.2022 (2)\",\"SUBOPERATION\":\"\"}],\"SPAREPARTLIST\":[{\"ORDERNUM\":\"10731004\",\"OPERATION\":\"0010\",\"ITEMNUM\":\"0010\",\"COMPONENT\":\"2362050133\",\"REQQNT\":\"1.000 \",\"UNIT\":\"PC\",\"IC\":\"L\",\"ITEMCATE\":\"L\",\"PPLANT\":\"3200\",\"SYSSTATUS\":\"\",\"AVAIQNT\":\"\",\"COMDESC\":\"BACK-UP RING,COUPLING HUB\"}],\"REQUESTOR\":\"1777\",\"PLANNINGPLANT\":\"1200\",\"GROUPTASK\":\"\",\"GROUPCOUNT\":\"\",\"MAINWORKCENTERPLANT\":\"1200\",\"WBS\":\"A-1100000-CE-09500\"},{\"ORDERNUM\":\"10730969\",\"SUPORDER\":\"\",\"ORDERTYPE\":\"CM01\",\"FUNCLOC\":\"PM-9501B\",\"EQNUM\":\"10011025\",\"ORDERDESC\":\"Test on 25.03.2022 (2)\",\"NOTFNUM\":\"\",\"PMACTTYPE\":\"M01\",\"SYSSTATUS\":\"WCM  CRTD MANC NTUP\",\"USERSTATUS\":\"INIL\",\"RESPPERNO\":\"1219\",\"MAINWC\":\"ENMC-M\",\"PRIORITY\":\"3\",\"CREATEDATE\":\"2022-03-25\",\"BSCSTART\":\"2022-03-25\",\"BSCFIN\":\"2022-05-17\",\"OPERATIONLIST\":[{\"ORDERNUM\":\"10730964\",\"OPERATION\":\"0010\",\"MAINWC\":\"ENMC-M\",\"WCPLANT\":\"1200\",\"CONTROLKEY\":\"ZPM1\",\"OPETEXT\":\"Test on 25.03.2022 (2)\",\"SUBOPERATION\":\"\"}],\"SPAREPARTLIST\":[{\"ORDERNUM\":\"10731004\",\"OPERATION\":\"0010\",\"ITEMNUM\":\"0010\",\"COMPONENT\":\"2362050133\",\"REQQNT\":\"1.000 \",\"UNIT\":\"PC\",\"IC\":\"L\",\"ITEMCATE\":\"L\",\"PPLANT\":\"3200\",\"SYSSTATUS\":\"\",\"AVAIQNT\":\"\",\"COMDESC\":\"BACK-UP RING,COUPLING HUB\"}],\"REQUESTOR\":\"1777\",\"PLANNINGPLANT\":\"1200\",\"GROUPTASK\":\"\",\"GROUPCOUNT\":\"\",\"MAINWORKCENTERPLANT\":\"1200\",\"WBS\":\"A-1100000-CE-09500\"}]}'
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
	static void testWebServiceEndPointNotFound() {
		Test.startTest();
		THOR_ReplicatedSAP_Order.dto_response dto = new THOR_ReplicatedSAP_Order.dto_response();
		//List<String> recordIds = dto.recordIds;
		//Map<Integer, String> errors = dto.errors;

		String uuidTxt = Uuid.randomUUID();
		RestRequest req = new RestRequest();
		req.httpMethod = 'POST';
		req.requestUri = '/services/apexrest/api/replicated/sap/orders';
		req.requestBody = Blob.valueof(
			JSON.serialize(
				new Map<String, OBject>{
					'gateway_id' => uuidTxt,
					'body' => '{\"ORDERLIST\":[{\"ORDERNUM\":\"10730964\",\"SUPORDER\":\"\",\"ORDERTYPE\":\"CM01\",\"FUNCLOC\":\"PM-9501B\",\"EQNUM\":\"10011025\",\"ORDERDESC\":\"Test on 25.03.2022 (2)\",\"NOTFNUM\":\"\",\"PMACTTYPE\":\"M01\",\"SYSSTATUS\":\"WCM  CRTD MANC NTUP\",\"USERSTATUS\":\"INIL\",\"RESPPERNO\":\"1219\",\"MAINWC\":\"ENMC-M\",\"PRIORITY\":\"3\",\"CREATEDATE\":\"2022-03-25\",\"BSCSTART\":\"2022-03-25\",\"BSCFIN\":\"2022-05-17\",\"OPERATIONLIST\":[{\"ORDERNUM\":\"10730964\",\"OPERATION\":\"0010\",\"MAINWC\":\"ENMC-M\",\"WCPLANT\":\"1200\",\"CONTROLKEY\":\"ZPM1\",\"OPETEXT\":\"Test on 25.03.2022 (2)\",\"SUBOPERATION\":\"\"}],\"SPAREPARTLIST\":[{\"ORDERNUM\":\"10731004\",\"OPERATION\":\"0010\",\"ITEMNUM\":\"0010\",\"COMPONENT\":\"2362050133\",\"REQQNT\":\"1.000 \",\"UNIT\":\"PC\",\"IC\":\"L\",\"ITEMCATE\":\"L\",\"PPLANT\":\"3200\",\"SYSSTATUS\":\"\",\"AVAIQNT\":\"\",\"COMDESC\":\"BACK-UP RING,COUPLING HUB\"}],\"REQUESTOR\":\"1777\",\"PLANNINGPLANT\":\"1200\",\"GROUPTASK\":\"\",\"GROUPCOUNT\":\"\",\"MAINWORKCENTERPLANT\":\"1200\",\"WBS\":\"A-1100000-CE-09500\"}]}'
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
//	@IsTest
//	static void testWebServiceBatchJob() {
//		Test.startTest();
//
//		String uuidTxt = Uuid.randomUUID();
//		THOR_ReplicatedSAP_Order batchJob = new THOR_ReplicatedSAP_Order('/sap/order', JSON.serialize(
//			new Map<String, OBject>{
//				'gateway_id' => uuidTxt,
//				'body' => '{\"ORDERLIST\":[{\"ORDERNUM\":\"10730964\",\"SUPORDER\":\"\",\"ORDERTYPE\":\"CM01\",\"FUNCLOC\":\"PM-9501B\",\"EQNUM\":\"10011025\",\"ORDERDESC\":\"Test on 25.03.2022 (2)\",\"NOTFNUM\":\"\",\"PMACTTYPE\":\"M01\",\"SYSSTATUS\":\"WCM  CRTD MANC NTUP\",\"USERSTATUS\":\"INIL\",\"RESPPERNO\":\"1219\",\"MAINWC\":\"ENMC-M\",\"PRIORITY\":\"3\",\"CREATEDATE\":\"2022-03-25\",\"BSCSTART\":\"2022-03-25\",\"BSCFIN\":\"2022-05-17\",\"OPERATIONLIST\":[{\"ORDERNUM\":\"10730964\",\"OPERATION\":\"0010\",\"MAINWC\":\"ENMC-M\",\"WCPLANT\":\"1200\",\"CONTROLKEY\":\"ZPM1\",\"OPETEXT\":\"Test on 25.03.2022 (2)\",\"SUBOPERATION\":\"\"}],\"SPAREPARTLIST\":[{\"ORDERNUM\":\"10731004\",\"OPERATION\":\"0010\",\"ITEMNUM\":\"0010\",\"COMPONENT\":\"2362050133\",\"REQQNT\":\"1.000 \",\"UNIT\":\"PC\",\"IC\":\"L\",\"ITEMCATE\":\"L\",\"PPLANT\":\"3200\",\"SYSSTATUS\":\"\",\"AVAIQNT\":\"\",\"COMDESC\":\"BACK-UP RING,COUPLING HUB\"}],\"REQUESTOR\":\"1777\",\"PLANNINGPLANT\":\"1200\",\"GROUPTASK\":\"\",\"GROUPCOUNT\":\"\",\"MAINWORKCENTERPLANT\":\"1200\",\"WBS\":\"A-1100000-CE-09500\"}]}'
//			}
//		));
//
//		Database.executeBatch(batchJob);
//		Test.stopTest();
//	}
}