public class THOR_IRPAIntegration_Component {
	class SparePartRequestToSAP {
		String operationno;
		String itemno;
		String materialno;
		String quantity;
		String um;
		String ic;
		String flag;
		String sf_id;
	}

	class SparePartRequestRequestWrapper {
		String invocationContext;
		SparePartRequestInputWrapper input;
	}

	class SparePartRequestInputWrapper {
		SparePartRequestDataWrapper ComponentData;
	}

	class SparePartRequestDataWrapper {
		List<SparePartRequestStructureWrapper> sparepartrequest;
		String order_id;
		String uuid;
	}

	class SparePartRequestStructureWrapper {
		String orderno;
		String planningplant;
		List<SparePartRequestToSAP> sparepart;
	}

	public static void checkSparePartRequest_beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		for (Object spr : newItems.values()) {
			Spare_Part_Request__c req = (Spare_Part_Request__c) spr;
			Spare_Part_Request__c oldReq = (Spare_Part_Request__c) oldItems.get(req.Id);

			// if (req.Request_Status__c == 'Pending for Approval' && req.Deleted__c == false) {
			// 	req.Integration_Status__c = 'In Progress';
			// }
		}
	}

	public static void checkSparePartRequest_afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		List<Spare_Part_Request__c> submittedRequestList = new List<Spare_Part_Request__c>();
		for (Object spr : newItems.values()) {
			Spare_Part_Request__c req = (Spare_Part_Request__c) spr;
			Spare_Part_Request__c oreq = (Spare_Part_Request__c) oldItems.get(req.id);
			// if (req.Request_Status__c == 'Pending for Approval' && req.Request_Status__c != oreq.Request_Status__c && req.isIRPA__c) {

			if (req.Integration_Status__c == 'In Progress' && req.Request_Status__c == 'Draft' && req.Deleted__c == false) {
				submittedRequestList.add(req);
			}
		}

		if (submittedRequestList.size() > 0) {
			THOR_IRPAIntegration_Component.sendSparePartRequestToSAP(submittedRequestList, 'insert');
		}
	}

	public static void sendSparePartRequestToSAP(List<Spare_Part_Request__c> sprList, String flag) {
		// set<String> orderSFIDSet = new Set<String>();
		// set<String> orderOperationSFIDSet = new Set<String>();
		// set<String> sparePartSFIDSet = new Set<String>();
		Set<Id> sparePartRequsetSFIDSet = new Map<Id, Spare_Part_Request__c>(sprList).keySet();
		List<SparePartRequestToSAP> itemSAPList = new List<SparePartRequestToSAP>();

		// for (Spare_Part_Request__c sprSF : sprList) {
		// 	sparePartRequsetSFIDSet.add(sprSF.id);
		// 	if (sprSF.Order__c != null) {
		// 		orderSFIDSet.add(sprSF.Order__c);
		// 	}
		// 	if (sprSF.Order_Operation__c != null) {
		// 		orderOperationSFIDSet.add(sprSF.Order_Operation__c);
		// 	}
		// 	if (sprSF.Spare_Part__c != null) {
		// 		sparePartSFIDSet.add(sprSF.Spare_Part__c);
		// 	}
		// }
		List<Spare_Part_Request__c> sprSFList = [
			SELECT
				id,
				Name,
				Order__c,
				Order__r.Planning_Plant__r.Code__c,
				Order_Operation__c,
				Spare_Part__c,
				UM__c,
				IC__c,
				Request_Material_Quantity__c,
				Item_No__c,
				Deleted__c,
				Order__r.Name,
				Order_Operation__r.Name,
				Order_Operation__r.Operation_Text__c,
				Spare_Part__r.Name,
				Spare_Part__r.Material_Number__c
			FROM Spare_Part_Request__c
			WHERE id IN :sparePartRequsetSFIDSet
		];

		List<SparePartRequestToSAP> sprToSAPList = new List<SparePartRequestToSAP>();
		map<String, List<SparePartRequestToSAP>> sprMap = new Map<String, List<SparePartRequestToSAP>>();
		String order_id;
		String planningplant;
		for (Spare_Part_Request__c sprSF : sprSFList) {
			order_id = sprSF.Order__c;
			planningplant = sprSF.Order__r.Planning_Plant__r?.Code__c;

			String order = sprSF.Order__r.Name; //orderSFMap.get(sprSF.Order__c);
			SparePartRequestToSAP sprSAP = new SparePartRequestToSAP();
			sprSAP.sf_id = sprSF.id;
			sprSAP.ic = 'L'; //default L

			if (sprSF.Order_Operation__c != null) {
				sprSAP.operationno = sprSF.Order_Operation__r.Operation_Text__c; //orderOperationSFMap.get(sprSF.Order_Operation__c);
			} else {
				sprSAP.operationno = '';
			}

			if (sprSF.Request_Material_Quantity__c != null) {
				sprSAP.quantity = String.valueOf(sprSF.Request_Material_Quantity__c);
			} else {
				sprSAP.quantity = '';
			}
			String itemno = '';
			if (sprSF.Item_No__c != null) {
				itemno = sprSF.Item_No__c;
			}
			sprSAP.itemno = itemno;

			String um = '';
			if (sprSF.UM__c != null && sprSF.UM__c != '') {
				um = sprSF.UM__c;
			}
			sprSAP.um = um;

			if (sprSF.Spare_Part__c != null) {
				sprSAP.materialno = sprSF.Spare_Part__r.Material_Number__c?.leftPad(18, '0'); //sparePartSFMap.get(sprSF.Spare_Part__c);
			} else {
				sprSAP.materialno = '';
			}

			if (sprSF.Deleted__c) {
				sprSAP.flag = 'delete';
			} else {
				sprSAP.flag = flag;
			}

			if (!sprMap.containsKey(order)) {
				sprMap.put(order, new List<SparePartRequestToSAP>());
			}
			sprMap.get(order).add(sprSAP);
		}

		List<SparePartRequestStructureWrapper> sprStrList = new List<SparePartRequestStructureWrapper>();
		for (String order : sprMap.keySet()) {
			SparePartRequestStructureWrapper sprStr = new SparePartRequestStructureWrapper();
			sprStr.orderno = order;
			sprStr.planningplant = planningplant;
			sprStr.sparepart = sprMap.get(order);
			sprStrList.add(sprStr);
		}

		String uuid = Uuid.randomUUID();
		SparePartRequestDataWrapper sprdata = new SparePartRequestDataWrapper();
		sprdata.sparepartrequest = sprStrList;
		sprdata.uuid = uuid;
		sprdata.order_id = order_id;

		SparePartRequestInputWrapper sprinput = new SparePartRequestInputWrapper();
		sprinput.ComponentData = sprdata;

		SparePartRequestRequestWrapper sprRequest = new SparePartRequestRequestWrapper();
		sprRequest.invocationContext = '${invocation_context}';
		sprRequest.input = sprinput;
		String sprJSON = JSON.serialize(sprRequest);
		system.debug('itemJSON----' + sprJSON);

		calloutToIRPA_SparePartRequest(sprJSON, order_id, uuid);
	}

	@future(callout=true)
	public static void calloutToIRPA_SparePartRequest(String bodyJson, String order_id, String uuid) {
		Application_Log__c applog = new Application_Log__c(External_ID__c = uuid);
		applog.Integration_Name__c = 'calloutToIRPA_SparePartRequest';
		applog.Method__c = 'Create';
		applog.Message_Type__c = 'In Progress';
		applog.Request_Body__c = bodyJson;
		applog.Reference_ID__c = order_id;

		THORIntegration__c CS = THORIntegration__c.getInstance();
		try {
			String reqbody = 'grant_type=client_credentials&client_id=' + CS.iRPA_Client_Id__c + '&client_secret=' + CS.iRPA_Client_Secret_Id__c;

			Http h = new Http();
			HttpRequest req = new HttpRequest();
			req.setBody(reqbody);
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_Token_Endpoint__c);
			HttpResponse res = h.send(req);
			system.debug('--------' + res.getBody());
			String token = res.getBody();

			Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(token);
			String access_token = result.containsKey('access_token') ? (String) result.get('access_token') : '';
			system.debug('access_token----' + access_token);

			Http http = new Http();
			HttpRequest httpReq = new HttpRequest();
			httpReq.setMethod('POST');
			httpReq.setEndpoint(CS.iRPA_Spare_Part_Request_Endpoint__c);
			httpReq.setHeader('Authorization', 'Bearer ' + access_token);
			httpReq.setHeader('Content-Type', 'application/json');
			//httpReq.setHeader('irpa-trigger-token', CS.iRPA_Spare_Part_Request_Token__c);
			httpReq.setHeader(CS.iRPA_API_Key_Header__c, CS.iRPA_API_Key__c);
			httpReq.setBody(bodyJson);
			HttpResponse httpRes = http.send(httpReq);
			system.debug('---spr-----' + httpRes?.getBody());
			system.debug('---spr-----' + httpRes?.getStatusCode());
			applog.Response_Body__c = httpRes.getBody();

			Map<String, Object> resultV = (Map<String, Object>) JSON.deserializeUntyped(httpRes.getBody());
			if (resultV.containsKey('severity') && String.valueOf(resultV.get('severity')).equalsIgnoreCase('ERROR')) {
				applog.Message_Type__c = 'Fail';
			}
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Spare_Part_Request_Endpoint__c, applog);
		} catch (Exception e) {
			String msg = String.format('calloutToIRPA_Notification: {0} \r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() });
			applog.Message_Type__c = 'Fail';
			applog.Error_Message__c = msg;
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Spare_Part_Request_Endpoint__c, applog);
			system.debug('THOR_IRPAIntegration_Component---' + e.getMessage() + ' Line:' + e.getLineNumber());
		}
	}
}