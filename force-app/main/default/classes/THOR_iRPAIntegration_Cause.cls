public with sharing class THOR_iRPAIntegration_Cause {
	/**
	 * @WrapperClass for sending to SAP
	 */
	class CauseToSAP {
		String notificationno;
		String itemno;
		String codegroup;
		String causecode;
		String causetext;
		String causeno;
		String flag;
	}

	class CauseItemStructure {
		String itemno;
		List<CauseToSAP> cause;
	}

	class CauseNotiStructure {
		String notification;
		List<CauseItemStructure> item;
	}
	class CauseDataWrapper {
		List<CauseNotiStructure> cause;
	}
	class CauseInput {
		CauseDataWrapper CauseData;
	}
	class CauseRequestWrapper {
		String invocationContext;
		CauseInput input;
	}

	public static void checkIsSOAP_Cause(List<sObject> cList) {
		for (Object n : cList) {
			Cause__c nCause = (Cause__c) n;

			if (nCause.isSOAP__c) {
				nCause.isSOAP__c = false;
				nCause.isIRPA__c = false;
			} else {
				nCause.isIRPA__c = true;
			}
		}
	}

	public static void checkCause_afterInsert(Map<Id, SObject> newItems) {
		boolean isChanged = false;
		for (Object n : newItems.values()) {
			Cause__c nItem = (Cause__c) n;
			if (nItem.isIRPA__c) {
				isChanged = nItem.isIRPA__c;
				break;
			}
		}
		if (isChanged) {
			THOR_IRPAIntegration_Cause.sendCauseToSAP(newItems.values(), 'insert');
		}
	}

	public static void checkCause_afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		boolean isChanged = false;
		for (Object n : newItems.values()) {
			Cause__c nItem = (Cause__c) n;
			Cause__c oItem = (Cause__c) oldItems.get(nItem.id);

			if (
				(nItem.Name != oItem.Name ||
				nItem.Cause_No__c != oItem.Cause_No__c ||
				nItem.Text__c != oItem.Text__c ||
				nItem.Notification__c != oItem.Notification__c ||
				nItem.Code_Group__c != oItem.Code_Group__c ||
				nItem.Code__c != oItem.Code__c ||
				nItem.Item__c != oItem.Item__c ||
				nItem.IsDeleted__c != oItem.IsDeleted__c) && (nItem.isIRPA__c)
			) {
				isChanged = true;
			}
		}
		if (isChanged) {
			sendCauseToSAP(newItems.values(), 'update');
		}
	}

	public static void sendCauseToSAP(List<Cause__c> causeList, String flag) {
		set<String> causeSFIDSet = new Set<String>();

		List<CauseToSAP> causeSAPList = new List<CauseToSAP>();

		for (Cause__c causeSF : causeList) {
			causeSFIDSet.add(causeSF.id);
		}
		List<Cause__c> causeSFList = [
			SELECT
				id,
				Name,
				Text__c,
				Cause_No__c,
				IsDeleted__c,
				Notification__c,
				Code_Group__c,
				Code__c,
				Item__c,
				Notification__r.Name,
				Code_Group__r.Name,
				Code__r.Name,
				Item__r.Item_No__c
			FROM Cause__c
			WHERE id IN :causeSFIDSet
		];

		Map<String, List<CauseToSAP>> itemMap = new Map<String, List<CauseToSAP>>();
		Map<String, String> itemSFMap = new Map<String, String>();
		for (Cause__c causeSF : causeSFList) {
			String noti = ''; //notiSFMap.get(causeSF.Notification__c);
			CauseToSAP causeSAP = new CauseToSAP();
			if (causeSF.Notification__c != null) {
				causeSAP.notificationno = causeSF.Notification__r.Name; //notiSFMap.get(causeSF.Notification__c);
				noti = causeSF.Notification__r.Name;
			} else {
				causeSAP.notificationno = '';
			}
			if (causeSF.Item__c != null) {
				causeSAP.itemno = causeSF.Item__r.Item_No__c; //itemSFMap.get(causeSF.Item__c);
				itemSFMap.put(causeSF.Item__c, causeSF.Item__r.Item_No__c);
			} else {
				causeSAP.itemno = '';
			}

			if (causeSF.Code_Group__c != null) {
				causeSAP.codegroup = causeSF.Code_Group__r.Name; //masterSFMap.get(causeSF.Code_Group__c);
			} else {
				causeSAP.codegroup = '';
			}
			if (causeSF.Code__c != null) {
				causeSAP.causecode = causeSF.Code__r.Name; //masterSFMap.get(causeSF.Code__c);
			}
			String ctext = '';
			if (causeSF.Text__c != null && causeSF.Text__c != '') {
				ctext = causeSF.Text__c;
			}

			causeSAP.causetext = ctext;

			if (causeSF.Cause_No__c != null && causeSF.Cause_No__c != '') {
				Decimal causeNoDecimal = Decimal.valueOf(causeSF.Cause_No__c);
				String convertedcauseNo = String.valueOf(causeNoDecimal);
				causeSAP.causeno = convertedcauseNo;
			} else {
				causeSAP.causeno = '';
			}

			if (causeSF.IsDeleted__c) {
				causeSAP.flag = 'delete';
			} else {
				causeSAP.flag = flag;
			}

			List<CauseToSAP> addedCauseList = new List<CauseToSAP>();
			if (itemMap.containsKey(noti)) {
				addedCauseList = itemMap.get(noti);
				addedCauseList.add(causeSAP);
				itemMap.put(causeSF.Item__c, addedCauseList);
			} else {
				addedCauseList.add(causeSAP);
				itemMap.put(causeSF.Item__c, addedCauseList);
			}
		}

		List<CauseItemStructure> itemStrList = new List<CauseItemStructure>();
		Map<String, List<CauseItemStructure>> itemStrMap = new Map<String, List<CauseItemStructure>>();
		for (String item : itemMap.keySet()) {
			String itemNo = itemSFMap.get(item);
			CauseItemStructure itemStr = new CauseItemStructure();
			itemStr.itemno = itemNo;
			itemStr.cause = itemMap.get(item);
			itemStrList.add(itemStr);
			itemStrMap.put(item, itemStrList);
		}

		List<CauseItemStructure> causeNotiList = new List<CauseItemStructure>();
		Map<String, List<CauseItemStructure>> causeNotiMap = new Map<String, List<CauseItemStructure>>();
		for (Cause__c causeSF : causeSFList) {
			String noti = causeSF.Notification__r.Name; //notiSFMap.get(causeSF.Notification__c);
			if (causeNotiMap.containsKey(noti)) {
				causeNotiList = causeNotiMap.get(noti);
				causeNotiList.addAll(itemStrMap.get(causeSF.Item__c));
				causeNotiMap.put(noti, causeNotiList);
			} else {
				causeNotiMap.put(noti, itemStrMap.get(causeSF.Item__c));
			}
		}

		List<CauseNotiStructure> addedcauseNotiList = new List<CauseNotiStructure>();
		for (String noti : causeNotiMap.keyset()) {
			CauseNotiStructure causeNoti = new CauseNotiStructure();
			causeNoti.notification = noti;
			causeNoti.item = causeNotiMap.get(noti);
			addedcauseNotiList.add(causeNoti);
		}

		CauseDataWrapper causeData = new CauseDataWrapper();
		causeData.cause = addedcauseNotiList;

		CauseInput causeinput = new CauseInput();
		causeinput.CauseData = causeData;

		CauseRequestWrapper causeRequest = new CauseRequestWrapper();
		causeRequest.invocationContext = '${invocation_context}';
		causeRequest.input = causeinput;
		String causeJSON = JSON.serialize(causeRequest);
		system.debug('causeJSON----' + causeJSON);

		calloutToIRPA_Cause(causeJSON);
	}

	@future(callout=true)
	public static void calloutToIRPA_Cause(String bodyJson) {
		try {
			THORIntegration__c CS = THORIntegration__c.getInstance();
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
			if (result.containsKey('access_token')) {
				String access_token = (String) result.get('access_token');
				system.debug('access_token----' + access_token);

				Http http = new Http();
				HttpRequest httpReq = new HttpRequest();
				httpReq.setBody(bodyJson);
				httpReq.setMethod('POST');
				httpReq.setEndpoint(CS.iRPA_Cause_Endpoint__c);
				httpReq.setHeader('Content-Type', 'application/json');
				httpReq.setHeader(CS.iRPA_API_Key_Header__c, CS.iRPA_API_Key__c);
				//httpReq.setHeader('irpa-trigger-token', CS.iRPA_Cause_Token__c);
				httpReq.setHeader('Authorization', 'Bearer ' + access_token);
				HttpResponse httpRes = http.send(httpReq);
				system.debug('---Cause-----' + httpRes.getBody());
				system.debug('---Cause-----' + httpRes.getStatusCode());
			}
		} catch (Exception e) {
			system.debug('THOR_IRPAIntegation---' + e.getMessage() + ' Line:' + e.getLineNumber());
		}
	}
}