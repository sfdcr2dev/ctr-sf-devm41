/**
 * @description       :
 * @author            : narathip.s@roundtwosolutions.com
 * @group             :
 * @last modified on  : 05-20-2022
 * @last modified by  : narathip.s@roundtwosolutions.com
 **/
public with sharing class THOR_ReplicatedSAP_Notification extends MethodUtils {
	private static final Map<String, Map<String, PISUsers__c>> PISUSERMAPEMP {
		get {
			if (PISUSERMAPEMP == null) {
				PISUSERMAPEMP = new Map<String, Map<String, PISUsers__c>>{'HOST_ID__c' => new Map<String, PISUsers__c>(),'HOME_ID__c' => new Map<String, PISUsers__c>()};
				for (PISUsers__c pisuser : [SELECT Id, EMPLOYEEID__c, HOST_ID__c, HOME_ID__c, USER__c, ORGID__c, HOME_ORGID__c, Active__c, USER__r.IsActive FROM PISUsers__c ORDER BY CreatedDate DESC, EMPLOYEEID__c]) {
					if (!PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisuser.HOST_ID__c)) {
						PISUSERMAPEMP.get('HOST_ID__c').put(pisuser.HOST_ID__c, pisuser);
					}
					if (!PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisuser.HOME_ID__c)) {
						PISUSERMAPEMP.get('HOME_ID__c').put(pisuser.HOME_ID__c, pisuser);
					}
				}
			}
			return PISUSERMAPEMP;
		}
		set;
	}
    
	private static final Map<String, Map<String, Master_Map__c>> masterMapByStatus {
		get {
			if (masterMapByStatus == null) {
				masterMapByStatus = new Map<String, Map<String, Master_Map__c>>();
				for (Master_Map__c m : [ SELECT Id, Name, Description__c, RelatedMasterMap1__c, RelatedMasterMap2__c, RelatedMasterMap1__r.Name, RelatedMasterMap2__r.Name, Type__c FROM Master_Map__c WHERE Type__c IN ( 'Activity', 'CatelogDamage', 'CatelogActivity', 'CatelogCause', 'CatelogObjectPart', 'Cause', 'Damage', 'Object Part', 'Code Group', 'Plant', 'Main Work Center', 'FaultCode', 'PlannerGroup' ) ORDER BY Type__c, Name ]) {
					if (!masterMapByStatus.containsKey(m.Type__c)) {
						masterMapByStatus.put(m.Type__c, new Map<String, Master_Map__c>());
					}
					if (m.RelatedMasterMap1__c != null && m.Type__c != 'Main Work Center') {
						String key = m.RelatedMasterMap1__r.Name + (m.RelatedMasterMap2__r?.Name != null ? m.RelatedMasterMap2__r?.Name : '');
						masterMapByStatus.get(m.Type__c).put(key.trim(), m);
					} else {
						masterMapByStatus.get(m.Type__c).put(m.Name.trim(), m);
					}
				}
			}
// System.debug(JSON.serializePretty(masterMapByStatus));
			return masterMapByStatus;
		}
		set;
	}

	public class ParseException extends Exception {
	}

	public class dto_response extends WebServiceExtend.dto_response {
		public Map<Integer, String> recordIds { get; set; }
	}

	public static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}

	public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
		String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : null;
		String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')) : null;

		Application_Log__c applog = new Application_Log__c( External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_Notification', Method__c = 'Upsert', Message_Type__c = 'Success', Request_Body__c = JSON.serialize(requestBody).left(125000) );

		Object dataObj;
		try {
			dataObj = JSON.deserializeUntyped(body);
			applog.Request_Body__c = JSON.serialize(MethodUtils.setResultByKeypath('body', dataObj, requestBody)).left(125000);
		} catch (System.JSONException ex) {
			// throw new ParseException('Unknown string format, cannot parse body data. Please try XML or JSON format');
			applog.Error_Message__c = ex.getMessage();
			applog.Message_Type__c = 'Fail';
			applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => false, 'message' => 'Unknown string format, cannot parse body data. Please try JSON format.', 'linkurl' => applog.External_ID__c } } );

			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
			return dto_response.parse(applog.Response_Body__c);
		}

// if(numberOfMB > 3) {
// 	Database.executeBatch(new THOR_ReplicatedSAP_Notification(body), 200);
// } else {

// }
		applog = processRecords(applog, (List<Object>) getResult('NOTILIST', dataObj));
		ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
		return dto_response.parse(applog.Response_Body__c);
	}

	private static Application_Log__c processRecords(Application_Log__c applog, List<Object> scope) {
/**
		 * TODO: Upsert notification here...
			{
				"NOTILIST": [
					{
					"NOTIFNUM": "10007142 ",
					"NOTIFTYP": "CM",
					"FUNCLOC": "TOP-TOC5",
					"EQNUM": "10000010 ",
					"ORDERNUM": "",
					"WCNUM": "",
					"SYSSTATUS": "NOPR ORAS",
					"USERSTATUS": "NNCP",
					"RESPPERNO": "",
					"MAINWC": "ENMA-I",
					"PRIORITY": "3",
					"REQDATE": "2021-05-27",
					"REQSTART": "2021-06-25",
					"REQEND": "2021-07-25",
					"NOTIFDESC": "test1#SFff",
					"BREAKDOWN": "",
					"FAULTCODE": "MF47",
					"HISTORY": [
						{
						"NOTIFNUM": "10007142 ",
						"TDLINE": "* 01.12.2020 11:29:37 THIPWARIN SAENGKAEW (ZTHIPWARIN)"
						},
						{
						"NOTIFNUM": "10007142 ",
						"TDLINE": "* test"
						},
						{
						"NOTIFNUM": "10007142 ",
						"TDLINE": "* 27.06.2021 10:19:00 THIPWARIN SAENGKAEW (ZTHIPWARIN)"
						},
						{
						"NOTIFNUM": "10007142 ",
						"TDLINE": "* 2test"
						},
						{
						"NOTIFNUM": "10007142 ",
						"TDLINE": "* 22.09.2021 13:53:48 THIPWARIN SAENGKAEW (ZTHIPWARIN)"
						},
						{
						"NOTIFNUM": "10007142 ",
						"TDLINE": "* 8. Wire arc thermal spray shaft on DE(#ตำแหน่ง Bearing) 9. Wire arc"
						},
						{
						"NOTIFNUM": "10007142 ",
						"TDLINE": " thermal spray shaft on DE(#ตำแหน่งฝาประกับ)"
						}
					],
					"CODEGROUP": "M-PUMP",
					"ITEMLIST": [
						{
						"NOTIFNUM": "10007142 ",
						"ITEMNUM": "0001",
						"OBJCODEGROUP": "EE-CHG",
						"OBJCODE": "E01",
						"DAMCODEGROUP": "ELEC-DA",
						"DAMCODE": "ED01",
						"ITEMTEXT": ""
						}
					],
					"CAUSELIST": [
						{
						"NOTIFNUM": "10007142 ",
						"ITEMNUM": "0001",
						"CAUSENUM": "0001",
						"CAUCODEGROUP": "EE-CA",
						"CAUCODE": "E02",
						"CAUSETEXT": ""
						}
					],
					"ACTIVITYLIST": [
						{
						"NOTIFNUM": "10007142 ",
						"ITEMNUM": "0001",
						"ACTNUM": "0001",
						"ACTCODEGROUP": "EE-AC",
						"ACTCODE": "E12",
						"ACTTEXT": ""
						}
					],
					"REQUESTER": "616 ",
					"MAINWORKCENTERPLANT": "1200"
					}
				]
			}
		 */

		Savepoint sp = Database.setSavepoint();
		String errorMessage;
		Map<String, Order__c> ordersBeforeUpsert = new Map<String, Order__c>();
		List<Notification__c> notifications = new List<Notification__c>();
		Map<String, List<Item__c>> itemsAfterUpsert = new Map<String, List<Item__c>>();
		Map<String, List<Cause__c>> causeAfterUpsert = new Map<String, List<Cause__c>>();
		Map<String, List<Activity__c>> activityAfterUpsert = new Map<String, List<Activity__c>>();

		try {
			for (Object noti : scope) {
				Map<String, Object> item = (Map<String, Object>) noti;

				Notification__c iNoti = new Notification__c();
//---------------Add for ODM-------------------------------------
                String plannerGroup = (String) item.get('PLANGROUP');
				iNoti.Planner_Group__c = masterMapByStatus.get('PlannerGroup').get(plannerGroup?.trim())?.Id;
				iNoti.Report_By__c = ((String) item.get('REPORTEDBY'))?.trim();
                
                String PlanningPlant = (String) item.get('PLANPLANT');
                iNoti.Planning_Plant__c = masterMapByStatus.get('Plant').get(PlanningPlant?.trim())?.Id;
//---------------------------------------------------
				if (isNotEmpty(item, 'ORDERNUM')) {
					String ord = ((String) item.get('ORDERNUM'))?.trim();
					iNoti.Order_Name_Text__c = ord;
					iNoti.Order__r = new Order__c(Order_Number__c = ord);
					ordersBeforeUpsert.put(ord, new Order__c(Name = ord, Order_Number__c = ord));
				}

				iNoti.Integration_Status__c = 'Success';
				iNoti.Name = ((String) item.get('NOTIFNUM'))?.trim();
				iNoti.Notification_Number__c = ((String) item.get('NOTIFNUM'))?.trim();
				iNoti.Type__c = ((String) item.get('NOTIFTYP'))?.trim();
				iNoti.Functional_Location__r = item.containsKey('FUNCLOC') ? new Functional_Location__c(Name = ((String) item.get('FUNCLOC'))?.trim()) : null;
				iNoti.Equipment__r = isNotEmpty(item, 'EQNUM') ? new Equipment__c(Name = ((String) item.get('EQNUM'))?.trim()) : null;
				iNoti.System_Status_Text__c = isNotEmpty(item, 'SYSSTATUS') ? ((String) item.get('SYSSTATUS'))?.trim() : 'OSNO';
				iNoti.Notification_Status__c = iNoti.System_Status_Text__c?.contains('NOPR') ? 'In Progress' : iNoti.System_Status_Text__c?.contains('NOCO') ? 'Closed' : iNoti.System_Status_Text__c?.contains('OSNO') ? 'New' : null;

// Mapping PisUser lookup fields with employee id related
				String pisRequestor = ((String) item.get('REQUESTER'))?.trim().leftPad(8, '0');
				pisRequestor = pisRequestor != '00000000' ? pisRequestor : '';
                iNoti.Requester_PISUser_Text__c = pisRequestor; // 20220517 - Fix notification's requester deafult empty
				iNoti.Requester_PISUser__c = PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisRequestor)? PISUSERMAPEMP.get('HOST_ID__c').get(pisRequestor)?.Id: PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisRequestor)? PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor)?.Id: null;
				iNoti.Department_Resp__c = PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisRequestor)? PISUSERMAPEMP.get('HOST_ID__c').get(pisRequestor)?.ORGID__c: PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisRequestor)? String.isNotBlank(PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor)?.HOME_ORGID__c)? PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor)?.HOME_ORGID__c: PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor)?.ORGID__c: null;
/*
iNoti.OwnerId = PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisRequestor)
? PISUSERMAPEMP.get('HOST_ID__c').get(pisRequestor)?.User__c
: PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisRequestor)
? PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor)?.User__c
: UserInfo.getUserId();*/
				if(PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisRequestor))
				{
					if(PISUSERMAPEMP.get('HOST_ID__c').get(pisRequestor).User__c != null && PISUSERMAPEMP.get('HOST_ID__c').get(pisRequestor).User__r.IsActive)
					{
						iNoti.OwnerId = PISUSERMAPEMP.get('HOST_ID__c').get(pisRequestor).User__c;
					}
					else if(PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisRequestor))
					{
						iNoti.OwnerId = PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor).User__c != null && PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor).User__r.IsActive ? PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor).User__c : UserInfo.getUserId();
					}
					else
					{
						iNoti.OwnerId = UserInfo.getUserId();
					}
				}
				else if(PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisRequestor))
				{
					iNoti.OwnerId = PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor).User__c != null && PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor).User__r.IsActive ? PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor).User__c : UserInfo.getUserId();
				}
				else
				{
					iNoti.OwnerId = UserInfo.getUserId();
				}
                

				iNoti.Requested_Date__c = isNotEmpty(item, 'REQDATE')? Date.valueOf(((String) item.get('REQDATE'))?.trim()): null;
				iNoti.Required_Start__c = isNotEmpty(item, 'REQSTART')? Date.valueOf(((String) item.get('REQSTART'))?.trim()): null;
				iNoti.Required_End__c = isNotEmpty(item, 'REQEND')? Date.valueOf(((String) item.get('REQEND'))?.trim()): null;
				iNoti.Description__c = (String) item.get('NOTIFDESC');
				iNoti.Breakdown__c = isNotEmpty(item, 'BREAKDOWN') ? (String) item.get('BREAKDOWN') == 'X' : false;

				String faultCode = (String) item.get('FAULTCODE');
				iNoti.Fault_Code__c = masterMapByStatus.get('FaultCode').get(faultCode?.trim())?.Id;

				String codeGroup = (String) item.get('CODEGROUP');
				iNoti.Code_Group__c = masterMapByStatus.get('Code Group').get(codeGroup?.trim())?.Id;

				String mainWorkCenter = (String) item.get('MAINWC');
				iNoti.Main_Work_Center__c = masterMapByStatus.get('Main Work Center').get(mainWorkCenter?.trim())?.Id;

				String mainWorkCenterPlant = (String) item.get('MAINWORKCENTERPLANT');
				iNoti.mainWorkCenterPlant__c = masterMapByStatus.get('Plant').get(mainWorkCenterPlant?.trim())?.Id;

				String hisDetailText = '';
				for (Object iHis : (List<Object>) item.get('HISTORY')) {
					String textHis = (String) getResult('TDLINE', iHis);
					if (String.isNotEmpty(textHis)) {
						hisDetailText += textHis.replace('*', '')?.trim() + '\n';
					}
				}
				iNoti.History_Detail__c = hisDetailText;
/**
				 * Add priority
				 *
				 * 1 Immediately
				 * 2 Urgent
				 * 3 Normal
				 * A Float Time - 1M
				 * C Float Time - 3M
				 * F Float Time - 6M
				 * I Float Time - 9M
				 * L Float Time - 12M
				 * O Float Time - 15M
				 * R Float Time - 18M
				 */
				iNoti.Priority__c = new Map<String, String>{ '3' => 'Normal', '2' => 'Urgent', '1' => 'Immediately', 'A' => 'Float Time - 1M', 'C' => 'Float Time - 3M', 'F' => 'Float Time - 6M', 'I' => 'Float Time - 9M', 'L' => 'Float Time - 12M', 'O' => 'Float Time - 15M', 'R' => 'Float Time - 18M' } .get(((String) item.get('PRIORITY'))?.trim());
// Default value when is null value
				iNoti.Priority__c = iNoti.Priority__c != null ? iNoti.Priority__c : 'Normal';
				iNoti.User_Status_Text__c = (String) item.get('USERSTATUS');
				iNoti.User_Status__c = iNoti.User_Status_Text__c;
				iNoti.isSOAP__c = true;
				notifications.add(iNoti);

/**
				 * Add item for notification
				 */
				if (item.containsKey('ITEMLIST')) {
					itemsAfterUpsert.put(iNoti.Name, new List<Item__c>());
					for (Object oItem : (List<Object>) item.get('ITEMLIST')) {
						itemsAfterUpsert.get(iNoti.Name).add(mappingItem(iNoti, (Map<String, Object>) oItem));
					}
				}

/**
				 * Add cause for notification
				 */
				if (item.containsKey('CAUSELIST')) {
					causeAfterUpsert.put(iNoti.Name, new List<Cause__c>());
					for (Object oItem : (List<Object>) item.get('CAUSELIST')) {
						causeAfterUpsert.get(iNoti.Name).add(mappingCause(iNoti, (Map<String, Object>) oItem));
					}
				}

/**
				 * Add activity for notification
				 */
				if (item.containsKey('ACTIVITYLIST')) {
					activityAfterUpsert.put(iNoti.Name, new List<Activity__c>());
					for (Object oItem : (List<Object>) item.get('ACTIVITYLIST')) {
						activityAfterUpsert.get(iNoti.Name).add(mappingActivity(iNoti, (Map<String, Object>) oItem));
					}
				}
			}

			if (ordersBeforeUpsert.size() > 0) {
				upsert ordersBeforeUpsert.values() Name;
			}

			if (notifications.size() > 0) {
				upsert notifications Name;
// System.debug(JSON.serializePretty(notifications, true));

				Map<String, Notification__c> notifiMapNumber = new Map<String, Notification__c>();
				for (Notification__c noti : notifications) {
					notifiMapNumber.put(noti.Name, noti);
				}

// Remove records related when notification replicate data
				List<Id> notiIds = new List<Id>((new Map<Id, Notification__c>(notifiMapNumber.values())).keySet());
				if (notiIds.size() > 0) {
					Map<Id, Item__c> itemsMap = new Map<Id, Item__c>([SELECT Id FROM Item__c WHERE Notification__c IN :notiIds]);
					delete [SELECT Id FROM Cause__c WHERE Notification__c IN :notiIds AND Item__c IN :itemsMap.keySet()];
					delete [SELECT Id FROM Activity__c WHERE Notification__c IN :notiIds AND Item__c IN :itemsMap.keySet()];
					delete itemsMap.values();
				}

				Set<Id> itemIds = new Set<Id>();
				if (itemsAfterUpsert.size() > 0) {
					Set<Id> oldItemNotiIds = new Set<Id>();
					List<Item__c> itemsList = new List<Item__c>();
					for (String key : itemsAfterUpsert.keySet()) {
						String notiId = String.valueOf(notifiMapNumber.get(key)?.Id);
						if (itemsAfterUpsert.containsKey(key) && itemsAfterUpsert.get(key).size() > 0) {
							oldItemNotiIds.add(notiId);
						}
/**
						 * update with external id (notificaiton id + item no (remove first nonzero digit))
						 */
// for (Item__c oItem : itemsAfterUpsert.get(key)) {
// 	oItem.NotiItem__c = oItem.NotiItem__c.replace(key, notiId);
// }
						itemsList.addAll(itemsAfterUpsert.get(key));
					}

					upsert itemsList NotiItem__c;
					itemIds.addAll((new Map<Id, Item__c>(itemsList).keySet()));
// System.debug(JSON.serializePretty(itemsList));
				}

				if (causeAfterUpsert.size() > 0) {
					Set<Id> oldCauseNotiIds = new Set<Id>();
					List<Cause__c> causeList = new List<Cause__c>();
					for (String key : causeAfterUpsert.keySet()) {
						String notiId = String.valueOf(notifiMapNumber.get(key)?.Id);
						if (causeAfterUpsert.containsKey(key) && causeAfterUpsert.get(key).size() > 0) {
							oldCauseNotiIds.add(notiId);
						}
/**
						 * update with external id (notificaiton id + item no (remove first nonzero digit) + cause no)
						 */
// for (Cause__c oItem : causeAfterUpsert.get(key)) {
// 	oItem.Item__r = new Item__c(NotiItem__c = oItem.Item__r.NotiItem__c?.replace(key, notiId));
// 	oItem.ItemCause__c = oItem.ItemCause__c.replace(key, notiId);
// }
						causeList.addAll(causeAfterUpsert.get(key));
					}

					upsert causeList ItemCause__c;
// System.debug(JSON.serializePretty(causeList));
				}

				if (activityAfterUpsert.size() > 0) {
					Set<Id> oldActivityNotiIds = new Set<Id>();
					List<Activity__c> activityList = new List<Activity__c>();
					for (String key : activityAfterUpsert.keySet()) {
						String notiId = String.valueOf(notifiMapNumber.get(key)?.Id);
						if (causeAfterUpsert.containsKey(key) && causeAfterUpsert.get(key).size() > 0) {
							oldActivityNotiIds.add(notiId);
						}
/**
						 * update with external id (notificaiton id + item no (remove first nonzero digit) + activity no)
						 */
// for (Activity__c oItem : activityAfterUpsert.get(key)) {
// 	oItem.Item__r = new Item__c(NotiItem__c = oItem.Item__r.NotiItem__c?.replace(key, notiId));
// 	oItem.ItemActivity__c = oItem.ItemActivity__c.replace(key, notiId);
// }
						activityList.addAll(activityAfterUpsert.get(key));
					}

					upsert activityList ItemActivity__c;
// System.debug(JSON.serializePretty(activityList));
				}
			}
			errorMessage = notifications.size() > 0 ? '' : 'Not found Notification Information';
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
			applog.Error_Message__c = dto_response.getErrorMessageException(ex);
			applog.Message_Type__c = 'Fail';
			Database.rollback(sp);
//System.debug(System.LoggingLevel.ERROR, applog.Error_Message__c);
		}

		Map<Integer, Id> recordIds = new Map<Integer, Id>();
		for (Integer i = 0; i < notifications.size(); i++) {
			recordIds.put(i, notifications.get(0).Id);
		}
		applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => notifications.size() > 0 && String.isEmpty(errorMessage), 'message' => errorMessage, 'linkurl' => applog.External_ID__c }, 'recordIds' => recordIds } );
		return applog;
	}

	private static Item__c mappingItem(Notification__c iNoti, Map<String, Object> oItem) {
		Item__c iItem = new Item__c();
		iItem.Notification__r = new Notification__c(Name = iNoti.Name);

		String codeGroupOfObjectPart = ((String) oItem.get('OBJCODEGROUP'))?.trim();
		iItem.Object_Part_Code_Group__c = masterMapByStatus.get('Code Group').containsKey(codeGroupOfObjectPart) ? masterMapByStatus.get('Code Group').get(codeGroupOfObjectPart)?.Id : null;
		String objectPart = ((String) oItem.get('OBJCODE'))?.trim();
		iItem.Object_Part__c = masterMapByStatus.get('Object Part').containsKey(objectPart) ? masterMapByStatus.get('Object Part').get(objectPart)?.Id : null;

		String codeGroupOfDamange = ((String) oItem.get('DAMCODEGROUP'))?.trim();
		iItem.Damage_Code_Group__c = masterMapByStatus.get('Code Group').containsKey(codeGroupOfDamange) ? masterMapByStatus.get('Code Group').get(codeGroupOfDamange)?.Id : null;

		String damangeCode = ((String) oItem.get('DAMCODE'))?.trim();
		if (masterMapByStatus.get('Damage').containsKey(damangeCode)) {
			iItem.Damage__c = masterMapByStatus.get('Damage').get(damangeCode)?.Id;
			iItem.DamageText__c = masterMapByStatus.get('Damage').get(damangeCode)?.Description__c;
		}
		iItem.Object_Part_Code_Text__c = masterMapByStatus.get('CatelogObjectPart').containskey(codeGroupOfObjectPart + objectPart) ? masterMapByStatus.get('CatelogObjectPart').get(codeGroupOfObjectPart + objectPart)?.Description__c : null;

		iItem.damage_code_group_description__c = masterMapByStatus.get('CatelogDamage').containskey(codeGroupOfDamange + damangeCode) ? masterMapByStatus.get('CatelogDamage').get(codeGroupOfDamange + damangeCode)?.Description__c : null;

		iItem.Item_No__c = ((String) oItem.get('ITEMNUM'))?.trim();
		iItem.NotiItem__c = iItem.Notification__r.Name + iItem.Item_No__c?.replaceFirst('^0+', ''); // Maybe fix again
		iItem.Text__c = ((String) oItem.get('ITEMTEXT'))?.trim();
		iItem.Created_On__c = System.today();
		iItem.isSOAP__c = true;
		iItem.Integration_Status__c = 'Success';

		if (iItem.Item_No__c == null) {
			throw new ParseException('Missing Item no: ITEMNUM');
		}
		return iItem;
	}

	private static Cause__c mappingCause(Notification__c iNoti, Map<String, Object> oItem) {
		Cause__c iCause = new Cause__c();
		iCause.Notification__r = new Notification__c(Name = iNoti.Name);

		String itemNo = ((String) oItem.get('ITEMNUM')).replaceFirst('^0+', '');
		iCause.Item__r = new Item__c(NotiItem__c = iCause.Notification__r.Name + itemNo);

		String causeCode = ((String) oItem.get('CAUCODE'))?.trim();
		iCause.Code__c = masterMapByStatus.get('Code Group').containsKey(causeCode) ? masterMapByStatus.get('Code Group').get(causeCode)?.Id : null;

		String causeCodeGroup = ((String) oItem.get('CAUCODEGROUP'))?.trim();
		iCause.Code_Group__c = masterMapByStatus.get('Code Group').containsKey(causeCodeGroup) ? masterMapByStatus.get('Code Group').get(causeCodeGroup)?.Id :null;

		String keyCause = causeCodeGroup + causeCode;
		if (masterMapByStatus.get('CatelogCause').containskey(keyCause)) {
			iCause.Code_Text__c = masterMapByStatus.get('CatelogCause').get(keyCause).Description__c;
			iCause.Code_in_Text_Form__c = masterMapByStatus.get('CatelogCause').get(keyCause).RelatedMasterMap2__r.Name;
		}

		iCause.cause_no__c = ((String) oItem.get('CAUSENUM'))?.trim();
		iCause.Text__c = ((String) oItem.get('CAUSETEXT'))?.trim();
		iCause.ItemCause__c = iCause.Notification__r.Name + itemNo + iCause.cause_no__c?.replaceFirst('^0+', ''); // Maybe fix again
		iCause.isSOAP__c = true;
		iCause.Integration_Status__c = 'Success';

		return iCause;
	}

	private static Activity__c mappingActivity(Notification__c iNoti, Map<String, Object> oItem) {
		Activity__c iActivity = new Activity__c();
		iActivity.Notification__r = new Notification__c(Name = iNoti.Name);

		String itemNo = ((String) oItem.get('ITEMNUM')).replaceFirst('^0+', '');
		iActivity.Item__r = new Item__c(NotiItem__c = iActivity.Notification__r.Name + itemNo);

		String codeGroupOfActivity = ((String) oItem.get('ACTCODEGROUP'))?.trim();
		iActivity.Code_Group__c = masterMapByStatus.get('Code Group').containsKey(codeGroupOfActivity) ? masterMapByStatus.get('Code Group').get(codeGroupOfActivity)?.Id : null;

		String activityCode = ((String) oItem.get('ACTCODE'))?.trim();
		iActivity.Code__c = masterMapByStatus.get('Code Group').containsKey(activityCode) ? masterMapByStatus.get('Code Group').get(activityCode)?.Id : null;

		String ketAct = codeGroupOfActivity + activityCode;
		iActivity.Text_of_Code__c = masterMapByStatus.get('CatelogActivity').get(ketAct).Description__c;
		iActivity.Activity_Code_Text__c = masterMapByStatus.get('CatelogActivity').get(ketAct).Description__c;
		iActivity.Code_in_Text_Form__c = masterMapByStatus.get('CatelogActivity').get(ketAct).RelatedMasterMap2__r.Name;

		iActivity.Text__c = ((String) oItem.get('ACTTEXT'))?.trim();
		iActivity.activity_no__c = ((String) oItem.get('ACTNUM'))?.trim();
		iActivity.ItemActivity__c = iActivity.Notification__r.Name + itemNo + iActivity.activity_no__c?.replaceFirst('^0+', ''); // Maybe fix again
		iActivity.isSOAP__c = true;
		iActivity.Integration_Status__c = 'Success';

		return iActivity;
	}
}