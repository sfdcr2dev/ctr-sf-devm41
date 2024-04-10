public with sharing class THOR_IRPAIntegration_Item {
	class ItemToSAP {
		String notificationno;
		String itemno;
		String sortno;
		String codegroupofobjectpart;
		String objectpart;
		String codegroupofdamange;
		String damangecode;
		String itemtext;
		String flag;
// DATE: 2021-11-30
// BEGIN
		String sf_id;
		List<CauseToSAP> causes;
		List<ActivityToSAP> activities;
// END
	}

// DATE: 2021-11-30
// BEGIN
	class CauseToSAP {
		String sf_id;
		String notificationno;
		String itemno;
		String sortno;
		String codegroup;
		String causecode;
		String causetext;
		String causeno;
		String flag;
	}
	
	class ActivityToSAP {
		String sf_id;
		String notificationno;
		String itemno;
		String sortno;
		String codegroup;
		String activitycode;
		String activitytext;
		String activityno;
		String flag;
	}
// END

	class ItemRequestWrapper {
		String invocationContext;
		ItemInputWrapper input;
	}

	class ItemInputWrapper {
		ItemDataWrapper ItemData;
	}

	class ItemDataWrapper {
		List<ItemStructureWrapper> item;
		String uuid;
	}

	class ItemStructureWrapper {
		String notification;
		List<ItemToSAP> item;
	}

	public static void checkItem_afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		boolean isChanged = false;
		for (Object n : newItems.values()) {
			Item__c nItem = (Item__c) n;
			Item__c oItem = (Item__c) oldItems.get(nItem.id);

			if (
				(nItem.Name != oItem.Name ||
				nItem.Item_No__c != oItem.Item_No__c ||
				nItem.Text__c != oItem.Text__c ||
				nItem.Notification__c != oItem.Notification__c ||
				nItem.Object_Part_Code_Group__c != oItem.Object_Part_Code_Group__c ||
				nItem.Object_Part__c != oItem.Object_Part__c ||
				nItem.Damage_Code_Group__c != oItem.Damage_Code_Group__c ||
				nItem.Damage__c != oItem.Damage__c ||
				nItem.isDeleted__c != oItem.isDeleted__c) && (nItem.isIRPA__c)
			) {
				isChanged = true;
//				nItem.Integration_Flag__c = 'Updated';
			}
//			else {
//				nItem.Integration_Flag__c = '';
//			}
		}
//		if (isChanged) {
//			sendItemToSAP(newItems.values(), 'update');
//		}
	}

	public static void checkItem_afterInsert(Map<Id, SObject> newItems) {
		boolean isChanged = false;
		for (Object n : newItems.values()) {
			Item__c nItem = (Item__c) n;
			if (nItem.isIRPA__c) {
				isChanged = nItem.isIRPA__c;
				break;
			}
		}
//		if (isChanged) {
//			sendItemToSAP(newItems.values(), 'insert');
//		}
	}

	public static void checkIsSOAP_Item(List<object> itemList, Map<Id, SObject> oldItems) {
		for (Object n : itemList) {
			Item__c nItem = (Item__c) n;
			Item__c oItem = (Item__c) oldItems?.get(nItem.Id);

//			if (oItem != null && !checkChangingData(nItem, oItem)) {
//				nItem.Integration_Flag__c = 'Sub';
//			}

			if (nItem.isSOAP__c) {
				nItem.isSOAP__c = false;
				nItem.isIRPA__c = false;
			} else {
				nItem.isIRPA__c = true;
			}

//			if (oItem != null && nItem.Integration_Flag__c == 'Updated'
//				&& (nItem.Last_Activity__c == oItem?.Last_Activity__c
//				|| nItem.Last_Cause__c == oItem?.Last_Cause__c))
//			{
//				if (
//					(nItem.Name != oItem.Name ||
//					nItem.Item_No__c != oItem.Item_No__c ||
//					nItem.Text__c != oItem.Text__c ||
//					nItem.Notification__c != oItem.Notification__c ||
//					nItem.Object_Part_Code_Group__c != oItem.Object_Part_Code_Group__c ||
//					nItem.Object_Part__c != oItem.Object_Part__c ||
//					nItem.Damage_Code_Group__c != oItem.Damage_Code_Group__c ||
//					nItem.Damage__c != oItem.Damage__c ||
//					nItem.isDeleted__c != oItem.isDeleted__c)// && (nItem.isIRPA__c)
//				) {
//					//isChanged = true;
//					nItem.Integration_Flag__c = 'Updated';
//				} else {
//					nItem.Integration_Flag__c = '';
//				}
//			}
		}
	}

//	private static Boolean checkChangingData(Item__c nItem, Item__c oItem) {
//		return (nItem.Damage__c != oItem?.Damage__c)
//			|| (nItem.Damage_Code_Group__c != oItem?.Damage_Code_Group__c)
//			|| (nItem.damage_code_group_description__c != oItem?.damage_code_group_description__c)
//			|| (nItem.DamageText__c != oItem?.DamageText__c)
//			|| (nItem.End_Date__c != oItem?.End_Date__c)
//			|| (nItem.Item_No__c != oItem?.Item_No__c)
//			|| (nItem.Name != oItem?.Name)
//			|| (nItem.Last_Activity__c != oItem?.Last_Activity__c)
//			|| (nItem.Last_Cause__c != oItem?.Last_Cause__c)
//			|| (nItem.Notification__c != oItem?.Notification__c)
//			|| (nItem.Object_Part__c != oItem?.Object_Part__c)
//			|| (nItem.Object_Part_Code_Group__c != oItem?.Object_Part_Code_Group__c)
//			|| (nItem.Object_Part_Code_Group_Text__c != oItem?.Object_Part_Code_Group_Text__c)
//			|| (nItem.Object_Part_Code_Text__c != oItem?.Object_Part_Code_Text__c)
//			|| (nItem.Start_Date__c != oItem?.Start_Date__c)
//			|| (nItem.Text__c != oItem?.Text__c);
//	}

	public static void sendItemToSAP(List<Item__c> itemList, String flag) {
		set<String> itemSFIDSet = new Set<String>();

		List<ItemToSAP> itemSAPList = new List<ItemToSAP>();

		for (Item__c itemSF : itemList) {
			itemSFIDSet.add(itemSF.id);
		}
		List<Item__c> itemSFList = [ SELECT id, Name, Item_No__c, Text__c, isDeleted__c, Notification__c, Object_Part_Code_Group__c, Object_Part__c, Damage_Code_Group__c, Damage__c, Notification__r.Name, Object_Part_Code_Group__r.Name, Object_Part__r.Name, Damage_Code_Group__r.Name, Damage__r.Name, Integration_Flag__c FROM Item__c WHERE id IN :itemSFIDSet AND Integration_Status__c = 'In Progress' ];
        
// DATE: 2021-11-30
// BEGIN
		List<Cause__c> causeSFList = [ SELECT Id, Name, Text__c, Cause_No__c, Sort_No__c, IsDeleted__c, Notification__c, Code_Group__c, Code__c, Item__c, Notification__r.Name, Code_Group__r.Name, Code__r.Name, Item__r.Item_No__c, Integration_Flag__c FROM Cause__c WHERE Item__c IN :itemSFIDSet AND Integration_Status__c = 'In Progress' ];

		List<Activity__c> activitySFList = [ SELECT id, Name, Text__c, Activity_No__c, Sort_No__c, IsDeleted__c, Notification__c, Code_Group__c, Code__c, Item__c, Notification__r.Name, Code_Group__r.Name, Code__r.Name, Item__r.Item_No__c, Integration_Flag__c FROM Activity__c WHERE Item__c IN :itemSFIDSet AND Integration_Status__c = 'In Progress' ];
// END

		List<ItemToSAP> itemToSAPList = new List<ItemToSAP>();

		Map<String, List<ItemToSAP>> itemMap = new Map<String, List<ItemToSAP>>();

		for (Item__c itemSF : itemSFList) {
			String noti = ''; //notiSFMap.get(itemSF.Notification__c);
			ItemToSAP itemSAP = new ItemToSAP();

			noti = itemSF.Notification__r?.Name;
            itemSAP.sf_id = String.valueOf(itemSF.Id);
			itemSAP.notificationno = itemSF.Notification__r?.Name.leftPad(12, '0');
			itemSAP.itemno = String.isNotEmpty(itemSF.Item_No__c) ? String.valueOf(Decimal.valueOf(itemSF.Item_No__c)) : '';
			itemSAP.sortno = String.isNotEmpty(itemSF.Item_No__c) ? String.valueOf(Decimal.valueOf(itemSF.Item_No__c)) : '';
			itemSAP.codegroupofobjectpart = itemSF.Object_Part_Code_Group__r?.Name != null ? itemSF.Object_Part_Code_Group__r.Name : '';
			itemSAP.objectpart = itemSF.Object_Part__r?.Name != null ? itemSF.Object_Part__r.Name : '';
			itemSAP.codegroupofdamange = itemSF.Damage_Code_Group__r?.Name != null ? itemSF.Damage_Code_Group__r?.Name : '';
			itemSAP.damangecode = itemSF.Damage__r?.Name != null ? itemSF.Damage__r?.Name : '';
			itemSAP.itemtext = String.isNotEmpty(itemSF.Text__c) ? itemSF.Text__c : '';
//itemSAP.flag = itemSF.isDeleted__c ? 'delete' : flag;
//itemSAP.flag = itemSF.Integration_Flag__c;

// DATE: 2021-11-30
// BEGIN
			itemSAP.causes = new List<CauseToSAP>();
			itemSAP.activities = new List<ActivityToSAP>();
			
			for (Cause__c causeSF : causeSFList) {
				if (causeSF.Item__r.Item_No__c == itemSF.Item_No__c) {
					CauseToSAP causeSAP = new CauseToSAP();
					causeSAP.sf_id = String.valueOf(causeSF.Id);
					causeSAP.notificationno = causeSF.Notification__r?.Name.leftPad(12, '0');
					causeSAP.itemno = causeSF.Item__r?.Item_No__c != null ? causeSF.Item__r.Item_No__c : '';
					causeSAP.sortno = causeSF.Sort_No__c != null ? causeSF.Sort_No__c : '';
					causeSAP.codegroup = causeSF.Code_Group__r?.Name != null ? causeSF.Code_Group__r.Name : '';
					causeSAP.causecode = causeSF.Code__r?.Name != null ? causeSF.Code__r.Name : '';
					causeSAP.causetext = String.isNotEmpty(causeSF.Text__c) ? causeSF.Text__c : '';
					causeSAP.causeno = String.isNotEmpty(causeSF.Cause_No__c) ? String.valueOf(Decimal.valueOf(causeSF.Cause_No__c)) : '';
//causeSAP.flag = causeSF.isDeleted__c ? 'delete' : flag;
					causeSAP.flag = causeSF.Integration_Flag__c;
					itemSAP.causes.add(causeSAP);
				}
			}

			for (Activity__c activitySF : activitySFList) {
				if (activitySF.Item__r.Item_No__c == itemSF.Item_No__c) {
					ActivityToSAP activitySAP = new ActivityToSAP();
					activitySAP.sf_id = String.valueOf(activitySF.Id);
					activitySAP.notificationno = activitySF.Notification__r?.Name.leftPad(12, '0');
					activitySAP.itemno = activitySF.Item__r?.Item_No__c != null ? activitySF.Item__r.Item_No__c : '';
					activitySAP.sortno = activitySF.Sort_No__c != null ? activitySF.Sort_No__c : '';
					activitySAP.codegroup = activitySF.Code_Group__r?.Name != null ? activitySF.Code_Group__r.Name : '';
					activitySAP.activitycode = activitySF.Code__r?.Name != null ? activitySF.Code__r.Name : '';
					activitySAP.activitytext = String.isNotEmpty(activitySF.Text__c) ? activitySF.Text__c : '';
					activitySAP.activityno = String.isNotEmpty(activitySF.Activity_No__c) ? String.valueOf(Decimal.valueOf(activitySF.Activity_No__c)) : '';
//activitySAP.flag = activitySF.isDeleted__c ? 'delete' : flag;
					activitySAP.flag = activitySF.Integration_Flag__c;
					itemSAP.activities.add(activitySAP);
				}
			}

			itemSAP.flag = itemSF.Integration_Flag__c;
			if (itemSAP.causes.size() > 0 || itemSAP.activities.size() > 0) {
			itemSAP.flag = itemSF.Integration_Flag__c != null ? itemSF.Integration_Flag__c + 'Sub' : 'Sub';
			}
// END

			List<ItemToSAP> addedItemList = itemMap.containsKey(noti) ? itemMap.get(noti) : new List<ItemToSAP>();
			addedItemList.add(itemSAP);
			itemMap.put(noti, addedItemList);
		}

		List<ItemStructureWrapper> itemStrList = new List<ItemStructureWrapper>();
		for (String noti : itemMap.keySet()) {
			ItemStructureWrapper itemStr = new ItemStructureWrapper();
			itemStr.notification = noti;
			itemStr.item = itemMap.get(noti);
			itemStrList.add(itemStr);
		}

		ItemDataWrapper itemdata = new ItemDataWrapper();
		itemdata.item = itemStrList;
		itemdata.uuid = Uuid.randomUUID();

		ItemInputWrapper iteminput = new ItemInputWrapper();
		iteminput.ItemData = itemdata;

		ItemRequestWrapper itemRequest = new ItemRequestWrapper();
		itemRequest.invocationContext = '${invocation_context}';
		itemRequest.input = iteminput;
		String itemJSON = JSON.serialize(itemRequest);

		calloutToIRPA_Item(itemdata.uuid, itemJSON);
	}

	@future(callout=true)
	public static void calloutToIRPA_Item(String uuid, String bodyJson) {
		THORIntegration__c CS = THORIntegration__c.getInstance();
		Application_Log__c applog = new Application_Log__c();
		applog.External_ID__c = uuid;
		applog.Integration_Name__c = 'calloutToIRPA_Item';
		applog.Method__c = 'Create';
		applog.Message_Type__c = 'In Progress';
		applog.Request_Body__c = bodyJson;

		try {
			Http http = new Http();
			HttpRequest req = new HttpRequest();
			req.setBody( String.format( 'grant_type=client_credentials&client_id={0}&client_secret={1}', new List<String>{ CS.iRPA_Client_Id__c, CS.iRPA_Client_Secret_Id__c } ) );
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_Token_Endpoint__c);
			HttpResponse res = http.send(req);
			Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(String.isNotEmpty(res?.getBody()) ? res.getBody() : '{}');
			String access_token = result.containsKey('access_token') ? (String) result.get('access_token') : '';

			http = new Http();
			req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_Item_Endpoint__c);
			req.setHeader('Authorization', 'Bearer ' + access_token);
			req.setHeader('Content-Type', 'application/json');
			req.setHeader(CS.iRPA_API_Key_Header__c, CS.iRPA_API_Key__c);
			req.setBody(bodyJson);
//req.setHeader('irpa-trigger-token', CS.iRPA_Item_Token__c);

			res = http.send(req);
			
			applog.Response_Body__c = res.getBody();
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Item_Endpoint__c, applog);

			result = (Map<String, Object>) JSON.deserializeUntyped(String.isNotEmpty(res?.getBody()) ? res.getBody() : '{}');
			applog.Message_Type__c = result.containsKey('severity') && String.valueOf(result.get('severity')).equalsIgnoreCase('ERROR') ? 'Fail' : 'In Progress';

		} catch (Exception e) {
			String msg = String.format('calloutToIRPA_Item: {0} \r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() });
//System.debug(System.LoggingLevel.Error, msg);

			applog.Message_Type__c = 'Fail';
			applog.Error_Message__c = msg;
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Item_Endpoint__c, applog);
		}
	}
}