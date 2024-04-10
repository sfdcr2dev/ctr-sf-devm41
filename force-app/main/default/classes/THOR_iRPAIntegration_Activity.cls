public with sharing class THOR_iRPAIntegration_Activity {
	/**
	 * @WrapperClass for sending to SAP
	 */
	class ActivityToSAP {
		String notificationno;
		String itemno;
		String codegroup;
		String activitycode;
		String activitytext;
		String activityno;
		String flag;
	}
	class ActivityItemStructure {
		String itemno;
		List<ActivityToSAP> activity;
	}
	class ActivityNotiStructure {
		String notification;
		List<ActivityItemStructure> item;
	}
	class ActivityDataWrapper {
		List<ActivityNotiStructure> activity;
	}
	class ActivityInput {
		ActivityDataWrapper ActivityData;
	}
	class ActivityRequestWrapper {
		String invocationContext;
		ActivityInput input;
	}

	public static void checkIsSOAP_Activity(List<object> aList) {
		for (Object n : aList) {
			Activity__c nActivity = (Activity__c) n;

			if (nActivity.isSOAP__c) {
				nActivity.isSOAP__c = false;
				nActivity.isIRPA__c = false;
			} else {
				nActivity.isIRPA__c = true;
			}
		}
	}

	public static void checkActivity_afterInsert(Map<Id, SObject> newItems) {
		boolean isChanged = false;
		for (Object n : newItems.values()) {
			Activity__c nItem = (Activity__c) n;
			if (nItem.isIRPA__c) {
				isChanged = nItem.isIRPA__c;
				break;
			}
		}
		if (isChanged) {
			sendActivityToSAP(newItems.values(), 'insert');
		}
	}

	public static void checkActivity_afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		boolean isChanged = false;
		for (Object n : newItems.values()) {
			Activity__c nItem = (Activity__c) n;
			Activity__c oItem = (Activity__c) oldItems.get(nItem.id);

			if (
				(nItem.Name != oItem.Name ||
				nItem.Activity_No__c != oItem.Activity_No__c ||
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
			sendActivityToSAP(newItems.values(), 'update');
		}
	}

	public static void sendActivityToSAP(List<Activity__c> activityList, String flag) {
		set<String> activitySFIDSet = new Set<String>();

		List<ActivityToSAP> activitySAPList = new List<ActivityToSAP>();

		for (Activity__c activitySF : activityList) {
			activitySFIDSet.add(activitySF.id);
		}
		List<Activity__c> activitySFList = [
			SELECT
				id,
				Name,
				Text__c,
				Activity_No__c,
				IsDeleted__c,
				Notification__c,
				Code_Group__c,
				Code__c,
				Item__c,
				Notification__r.Name,
				Code_Group__r.Name,
				Code__r.Name,
				Item__r.Item_No__c
			FROM Activity__c
			WHERE id IN :activitySFIDSet
		];

		map<String, String> itemSFMap = new Map<String, String>();

		map<String, List<ActivityToSAP>> itemMap = new Map<String, List<ActivityToSAP>>();
		for (Activity__c activitySF : activitySFList) {
			String noti = ''; //notiSFMap.get(activitySF.Notification__c);
			ActivityToSAP activitySAP = new ActivityToSAP();
			if (activitySF.Notification__c != null) {
				activitySAP.notificationno = activitySF.Notification__r.Name; //notiSFMap.get(activitySF.Notification__c);
				noti = activitySF.Notification__r.Name;
			}
			if (activitySF.Item__c != null) {
				activitySAP.itemno = activitySF.Item__r.Item_No__c; //itemSFMap.get(activitySF.Item__c);
				itemSFMap.put(activitySF.Item__c, activitySF.Item__r.Item_No__c);
			}

			if (activitySF.Code_Group__c != null) {
				activitySAP.codegroup = activitySF.Code_Group__r.Name; //masterSFMap.get(activitySF.Code_Group__c);
			}
			if (activitySF.Code__c != null) {
				activitySAP.activitycode = activitySF.Code__r.Name; //masterSFMap.get(activitySF.Code__c);
			}
			String actext = '';
			if (activitySF.Text__c != null && activitySF.Text__c != '') {
				actext = activitySF.Text__c;
			}
			activitySAP.activitytext = actext;

			if (activitySF.Activity_No__c != null && activitySF.Activity_No__c != '') {
				Decimal activityNoDecimal = Decimal.valueOf(activitySF.Activity_No__c);
				String convertedactivityNo = String.valueOf(activityNoDecimal);
				activitySAP.activityno = convertedactivityNo;
			} else {
				activitySAP.activityno = '';
			}

			if (activitySF.IsDeleted__c) {
				activitySAP.flag = 'delete';
			} else {
				activitySAP.flag = flag;
			}

			List<ActivityToSAP> addedActivityList = new List<ActivityToSAP>();
			if (itemMap.containsKey(noti)) {
				addedActivityList = itemMap.get(noti);
				addedActivityList.add(activitySAP);
				itemMap.put(activitySF.Item__c, addedActivityList);
			} else {
				addedActivityList.add(activitySAP);
				itemMap.put(activitySF.Item__c, addedActivityList);
			}
		}

		List<ActivityItemStructure> itemStrList = new List<ActivityItemStructure>();
		map<String, List<ActivityItemStructure>> itemStrMap = new Map<String, List<ActivityItemStructure>>();
		for (String item : itemMap.keySet()) {
			String itemNo = itemSFMap.get(item);
			ActivityItemStructure itemStr = new ActivityItemStructure();
			itemStr.itemno = itemNo;
			itemStr.activity = itemMap.get(item);
			itemStrList.add(itemStr);
			itemStrMap.put(item, itemStrList);
		}

		List<ActivityItemStructure> activityNotiList = new List<ActivityItemStructure>();
		map<String, List<ActivityItemStructure>> activityNotiMap = new Map<String, List<ActivityItemStructure>>();
		for (Activity__c activitySF : activitySFList) {
			String noti = activitySF.Notification__r.Name; //notiSFMap.get(activitySF.Notification__c);
			if (activityNotiMap.containsKey(noti)) {
				activityNotiList = activityNotiMap.get(noti);
				activityNotiList.addAll(itemStrMap.get(activitySF.Item__c));
				activityNotiMap.put(noti, activityNotiList);
			} else {
				activityNotiMap.put(noti, itemStrMap.get(activitySF.Item__c));
			}
		}

		List<ActivityNotiStructure> addedactivityNotiList = new List<ActivityNotiStructure>();
		for (String noti : activityNotiMap.keyset()) {
			ActivityNotiStructure activityNoti = new ActivityNotiStructure();
			activityNoti.notification = noti;
			activityNoti.item = activityNotiMap.get(noti);
			addedactivityNotiList.add(activityNoti);
		}

		ActivityDataWrapper activityData = new ActivityDataWrapper();
		activityData.activity = addedactivityNotiList;

		ActivityInput activityinput = new ActivityInput();
		activityinput.ActivityData = activityData;

		ActivityRequestWrapper activityRequest = new ActivityRequestWrapper();
		activityRequest.invocationContext = '${invocation_context}';
		activityRequest.input = activityinput;
		String activityJSON = JSON.serialize(activityRequest);
		system.debug('activityJSON----' + activityJSON);

		calloutToIRPA_Activity(activityJSON);
	}

	@future(callout=true)
	public static void calloutToIRPA_Activity(String bodyJson) {
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
				httpReq.setEndpoint(CS.iRPA_Activity_Endpoint__c);
				httpReq.setHeader('Content-Type', 'application/json');
				httpReq.setHeader(CS.iRPA_API_Key_Header__c, CS.iRPA_API_Key__c);
				//httpReq.setHeader('irpa-trigger-token', CS.iRPA_Activity_Token__c);
				httpReq.setHeader('Authorization', 'Bearer ' + access_token);
				HttpResponse httpRes = http.send(httpReq);
				system.debug('---Activity-----' + httpRes.getBody());
				system.debug('---Activity-----' + httpRes.getStatusCode());
			}
		} catch (Exception e) {
			system.debug('THOR_IRPAIntegation---' + e.getMessage() + ' Line:' + e.getLineNumber());
		}
	}
}