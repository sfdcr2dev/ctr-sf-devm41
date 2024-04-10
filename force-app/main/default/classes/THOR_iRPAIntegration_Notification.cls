/**
 * @description       : Apex Class handler for Notificaiton trigger
 * @author            : narathip.s@roundtwosolutions.com
 * @group             :
 * @last modified on  : 06-17-2022
 * @last modified by  : narathip.s@roundtwosolutions.com
 **/
public with sharing class THOR_iRPAIntegration_Notification {
	class NotificationToSAP {
		String sf_id;
		String notification_number;
		String type;
		String functionallocation;
		String equipment;
		String order;
		String notificationstatus;
		String userstatus;
		String requesteddate;
		String priority;
		String requiredstart;
		String requiredend;
		String description;
		String breakdown;
		String faultcode;
		String mainworkcenter;
		String requestor;
		String requestor_old;
		String department_resp;
		String department_resp_old;
		String flag;
		String codegroup;
		String mainworkcenterplant;
		String plannergroup;
		String planningplant;

		String requestor_role {
			get {
				return 'ZP';
			}
		}
		String department_resp_role {
			get {
				return 'AB';
			}
		}
		List<Notification_HistoryDetail_ToSAP> historydetail;
	}

	class Notification_HistoryDetail_ToSAP {
		String notificationno;
		String text;
	}

	class NotiRequestWrapper {
		String invocationContext;
		InputWrapper input;
	}

	class InputWrapper {
		NotificationDataWrapper NotificationData;
	}

	class NotificationDataWrapper {
		List<NotificationToSAP> notification;
		String uuid;
	}

	public static void stampFaultCode(List<sObject> notiList, Map<Id, SObject> oldItems) {
		for (Notification__c noti : (List<Notification__c>) notiList) {
			if (noti.Fault_Code__c != null && noti.Code_Group__c == null) {
				noti.Code_Group__c = String.isNotEmpty(THOR_IRPAIntegration.catelogFaultCode.get(noti.Fault_Code__c))? THOR_IRPAIntegration.catelogFaultCode.get(noti.Fault_Code__c): (Id) noti.get('Code_Group__c');
			}
		}
	}

	public static void checkIsSOAP_Noti(List<sObject> notiList, Map<Id, SObject> oldItems) {
		// Break looping update notification
		for (sObject n : notiList) {
			Notification__c nNoti = (Notification__c) n;
			Notification__c oNoti = (Notification__c) oldItems.get(nNoti.Id);
/**
* @Project Thor2 Integration
* @description Integration iRPA services
* Integration Status changes every times as update notificaitons
*/
            nNoti.Requester__c = THOR_IRPAIntegration.pisUserMap.get(nNoti.Requester_PISUser__c)?.User__c;
            if (!THOR_IRPAIntegration.ISADMIN &&(String.isEmpty(nNoti.Requester_PISUser_Text__c) ||(nNoti.Requester_PISUser__c != oNoti?.Requester_PISUser__c) && oNoti != null) ) {
                String hostId = THOR_IRPAIntegration.pisUserMap.get(nNoti.Requester_PISUser__c)?.HOST_ID__c;
                String homeId = THOR_IRPAIntegration.pisUserMap.get(nNoti.Requester_PISUser__c)?.HOME_ID__c;
                nNoti.Requester_PISUser_Text__c = hostId != null ? hostId : homeId;
            }
            
            if (nNoti.Integration_Status__c == 'In Progress') {
                nNoti.isIRPA__c = true;
            }

            nNoti.Requester__c = THOR_IRPAIntegration.pisUserMap.get(nNoti.Requester_PISUser__c)?.User__c;
            if (
                !THOR_IRPAIntegration.ISADMIN &&
                (String.isEmpty(nNoti.Requester_PISUser_Text__c) ||
                nNoti.Requester_PISUser__c != oNoti?.Requester_PISUser__c)
            ) {
                String hostId = THOR_IRPAIntegration.pisUserMap.get(nNoti.Requester_PISUser__c)?.HOST_ID__c;
                String homeId = THOR_IRPAIntegration.pisUserMap.get(nNoti.Requester_PISUser__c)?.HOME_ID__c;
                nNoti.Requester_PISUser_Text__c = hostId != null ? hostId : homeId;
            }
		}
	}

	public static void checkNotification_afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		Map<Id, Notification__c> notiMap = new Map<Id, Notification__c>();
		boolean isChanged = false;
		for (Object n : newItems.values()) {
			Notification__c nNoti = (Notification__c) n;
			Notification__c oNoti = (Notification__c) oldItems.get(nNoti.id);
			isChanged = nNoti.Integration_Status__c == 'In Progress' && nNoti.Integration_Status__c != oNoti.Integration_Status__c && nNoti.isIRPA__c ? true : false ;
			if (isChanged) {
				notiMap.put(nNoti.id, nNoti);
				isChanged = false;
			}
		}

		if (notiMap.size() > 0) {
			Map<Id, Notification__c> oldItemMaps = (Map<Id, Notification__c>) oldItems;
			THOR_iRPAIntegration_Notification.sendNotificationToSAP(notiMap, oldItemMaps, 'Updated');
		}
	}

	public static void checkNotification_afterCreate(Map<Id, SObject> newItems) {
		Map<Id, Notification__c> notiMap = (Map<Id, Notification__c>) newItems;
		List<Notification__c> notiLst = new List<Notification__c>();
		for (Notification__c noti : notiMap.values()) {
			if (noti.isIRPA__c == true && noti.isSOAP__c == false) {
				notiLst.add(noti);
			}
		}
		if (notiLst.size() > 0) {
			THOR_iRPAIntegration_Notification.sendNotificationToSAP(new Map<Id, Notification__c>(notiLst), null, 'Created');
		}
	}

	public static void sendNotificationToSAP(Map<Id, Notification__c> notiMap, Map<Id, Notification__c> oldItems, String flag) {
		try {
			Set<String> notiSFIDSet = new Set<String>();
			map<String, String> updatedNotiMap = new Map<String, String>();

			for (Id notiId : notiMap.keySet()) {
				notiSFIDSet.add(notiId);
			}

			List<Notification__c> notiSFList = [ SELECT Id, Name, Notification_Number__c, Type__c, System_Status_Text__c, User_Status__c, Requested_Date__c, Priority__c, Required_Start__c, Required_End__c, Description__c, Breakdown__c, History_Detail__c, Notification_Status__c, mainWorkCenterPlantText__c, MainWorkCenterText__c, Main_Work_Center__c, Fault_Code__c, Code_Group__c, Functional_Location__c, Equipment__c, Order__c, Requester_PISUser__c, Main_Work_Center__r.Code__c, Fault_Code__r.Code__c, Code_Group__r.Code__c, Functional_Location__r.Name, Equipment__r.Name, Order__r.Name, Requester_PISUser_Text__c, Requester_PISUser__r.EMPLOYEEID__c, Requester_PISUser__r.User__r.Employee_Id__c, Requester_PISUser__r.ORGID__c, Department_Resp__c, Planner_Group__r.Code__c, Planning_Plant__r.Code__c FROM Notification__c WHERE id IN :notiSFIDSet ];
			List<NotificationToSAP> notiToSAPList = new List<NotificationToSAP>();
			List<Notification__c> updatedNotiList = new List<Notification__c>();

			for (Notification__c notiSF : notiSFList) {
				NotificationToSAP notiToSAP = new NotificationToSAP();
				notiToSAP.sf_id = notiSF.Id;
				notiToSAP.notification_number = notiSF.Name;
				notiToSAP.type = notiSF.Type__c;
//-----------ODM---------
				notiToSAP.plannergroup = notiSF.Planner_Group__r?.Code__c != null? notiSF.Planner_Group__r?.Code__c: '';
				notiToSAP.planningplant = notiSF.Planning_Plant__r?.Code__c != null? notiSF.Planning_Plant__r?.Code__c: '';
//------------------
				notiToSAP.functionallocation = notiSF.Functional_Location__r?.Name != null? notiSF.Functional_Location__r?.Name: '';
				notiToSAP.equipment = notiSF.Equipment__r?.Name != null ? notiSF.Equipment__r?.Name : '';
				notiToSAP.order = notiSF.Order__r?.Name != null ? notiSF.Order__r?.Name : '';
				notiToSAP.notificationstatus = notiSF.System_Status_Text__c != null ? notiSF.System_Status_Text__c : '';
				notiToSAP.userstatus = notiSF.User_Status__c != null ? notiSF.User_Status__c : '';

				notiToSAP.priority = new Map<String, String>{ 'Normal' => '3', 'Urgent' => '2', 'Immediately' => '1', 'Float Time - 1M' => 'A', 'Float Time - 3M' => 'C', 'Float Time - 6M' => 'F', 'Float Time - 9M' => 'I', 'Float Time - 12M' => 'L', 'Float Time - 15M' => 'O', 'Float Time - 18M' => 'R' }.get(notiSF.Priority__c);
				notiToSAP.priority = notiToSAP.priority != null ? notiToSAP.priority : '';

				notiToSAP.requesteddate = notiSF.Requested_Date__c != null? ((Datetime) notiSF.Requested_Date__c).formatGMT('dd.MM.yyyy'): '';
				notiToSAP.requiredstart = notiSF.Required_Start__c != null? ((Datetime) notiSF.Required_Start__c).formatGMT('dd.MM.yyyy'): '';
				notiToSAP.requiredend = notiSF.Required_End__c != null? ((Datetime) notiSF.Required_End__c).formatGMT('dd.MM.yyyy'): '';

				notiToSAP.description = notiSF.Description__c != null ? notiSF.Description__c : '';
				notiToSAP.breakdown = notiSF.Breakdown__c ? 'X' : ''; // X => True , = False
				notiToSAP.faultcode = notiSF.Fault_Code__r?.Code__c != null? notiToSAP.faultcode = notiSF.Fault_Code__r?.Code__c: '';
				notiToSAP.codegroup = notiSF.Code_Group__r?.Code__c != null ? notiSF.Code_Group__r?.Code__c : '';
				notiToSAP.requestor = notiSF.Requester_PISUser_Text__c != null ? notiSF.Requester_PISUser_Text__c : ''; // Requester_PISUser_Text__c => Adjust improve mapping from SAP Interface
				notiToSAP.department_resp = notiSF.Requester_PISUser__r?.ORGID__c != null? notiSF.Requester_PISUser__r?.ORGID__c : '';
				notiToSAP.requestor_old = '';
				notiToSAP.department_resp_old = '';
				if (oldItems != null) {
					notiToSAP.requestor_old = (oldItems.get(notiToSAP.sf_id)?.Requester_PISUser_Text__c != null) ? oldItems.get(notiToSAP.sf_id)?.Requester_PISUser_Text__c : '';
					notiToSAP.department_resp_old = (oldItems.get(notiToSAP.sf_id)?.Department_Resp__c != null) ? oldItems.get(notiToSAP.sf_id)?.Department_Resp__c : '';
				}
                System.debug(notiSF.MainWorkCenterText__c);
				System.debug(notiSF.mainWorkCenterPlantText__c);
				notiToSAP.mainworkcenter = THOR_IRPAIntegration.categoryWithMainWorkCenterWithPlant.containsKey(notiSF.MainWorkCenterText__c + notiSF.mainWorkCenterPlantText__c) ? (THOR_IRPAIntegration.categoryWithMainWorkCenterWithPlant.get( notiSF.MainWorkCenterText__c + notiSF.mainWorkCenterPlantText__c ) != null ? THOR_IRPAIntegration.categoryWithMainWorkCenterWithPlant.get( notiSF.MainWorkCenterText__c + notiSF.mainWorkCenterPlantText__c ) : '') : '';
				notiToSAP.mainworkcenterplant = ''; // Empty default to iRPA
// "mainworkcenter" : "10000026",

				List<Notification_HistoryDetail_ToSAP> hisDetailList = new List<Notification_HistoryDetail_ToSAP>();
// Notification__c updatedNoti = new Notification__c(Id = notiSF.Id, isSOAP__c = true);
				if (String.isNotEmpty(notiSF.History_Detail__c)) {
					List<String> lineList = notiSF.History_Detail__c.split('\n');
					List<String> newHistoryLine = new List<String>();
					Boolean bypass = false;
					for (String line : lineList) {
						if (bypass || line.startsWith('* ')) {
							bypass = true;
							newHistoryLine.add(line);
						}
					}
					for (String line : newHistoryLine) {
						String historyText = line?.trim().replaceAll('</p><p>', '</p><br/><p>'); // Add <br> to separate paragraphs
						historyText = historyText.replaceAll('<p><br/></p>', ''); // Remove duplicate new line in paragraphs
						historyText = historyText.stripHtmlTags()?.replace('* ', ''); // Convert HTML to plain text and remove * character for beginning of line

						for (String histText : historyText.split('\n')) {
							while (histText.length() > 0) {
								Integer lastIndex = histText.length() > 132 ? 132 : histText.length();
								String textSplit = histText.substring(0, lastIndex);
								histText = histText.substring(lastIndex);
	
								Notification_HistoryDetail_ToSAP detail = new Notification_HistoryDetail_ToSAP();
								detail.notificationno = notiSF.Notification_Number__c != null
									? notiSF.Notification_Number__c
									: ''; // notiSF.Name
								detail.text = textSplit;
								hisDetailList.add(detail);
							}
						}
					}
				}
				notiToSAP.historydetail = hisDetailList.size() > 0 ? hisDetailList : new List<Notification_HistoryDetail_ToSAP>();
				notiToSAP.flag = notiSF.System_Status_Text__c != null && notiSF.System_Status_Text__c?.equalsIgnoreCase('NOCO') ? 'Closed' : String.isEmpty(notiSF.Notification_Number__c) ? 'Created' : flag;
// updatedNotiList.add(updatedNoti);
				notiToSAPList.add(notiToSAP);
			}

			NotificationDataWrapper notiWrapper = new NotificationDataWrapper();
			notiWrapper.notification = notiToSAPList;
			InputWrapper inputWrapper = new InputWrapper();
			inputWrapper.NotificationData = notiWrapper;
			NotiRequestWrapper request = new NotiRequestWrapper();
			request.invocationContext = '${invocation_context}';
			request.input = inputWrapper;
			if (notiToSAPList.size() > 0) {
// update updatedNotiList;
				THORIntegration__c CS = THORIntegration__c.getInstance();
				String notificationId = !notiMap.isEmpty() ? (Id) notiMap.values().get(0).Id : null;
				String uuid = Uuid.randomUUID();
				notiWrapper.uuid = uuid;
				String requestBody = JSON.serialize(request);
				Application_Log__c applog = new Application_Log__c();
				applog.Integration_Name__c = 'calloutToIRPA_Notification';
				applog.Method__c = new Map<String, String>{ 'created' => 'Create', 'updated' => 'Update' }.get(flag.toLowerCase());
				applog.Message_Type__c = 'In Progress';
				applog.Request_Body__c = requestBody;
				applog.Reference_ID__c = notificationId;
				applog.External_ID__c = uuid;
				ApplicationLogUtils.saveLogOutbound(CS.iRPA_Notification_Endpoint__c, applog);
				THOR_iRPAIntegration_Notification.calloutToIRPA_Notification( notificationId, applog.Id, applog.External_ID__c, requestBody );
			}
		} catch (Exception e) {
			List<Notification__c> updateFiled = new List<Notification__c>();
			for (Notification__c noti : notiMap.values()) {
				updateFiled.add( new Notification__c( Id = noti.Id, Integration_Status__c = 'Failed', Integration_Message__c = e.getMessage() ) );
			}
			update updateFiled;
		}
	}

	@future(callout=true)
	public static void calloutToIRPA_Notification( String notificationId, String applicationLogId, String externalId, String bodyJson ) {
		Application_Log__c applog = new Application_Log__c(Id = applicationLogId, External_ID__c = externalId);
		Notification__c noti = new Notification__c(Id = notificationId);
		THORIntegration__c CS = THORIntegration__c.getInstance();
		try {
			Http http = new Http();
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_Token_Endpoint__c);
			req.setBody( 'grant_type=client_credentials&client_id=' + CS.iRPA_Client_Id__c + '&client_secret=' + CS.iRPA_Client_Secret_Id__c );
			HttpResponse res = http.send(req);
			Map<String, Object> tokenMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
			req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_Notification_Endpoint__c);
			req.setHeader(CS.iRPA_API_Key_Header__c, CS.iRPA_API_Key__c);
			req.setHeader('Content-Type', 'application/json');
			req.setHeader( 'Authorization', String.format( 'Bearer {0}', new List<String>{ tokenMap.containsKey('access_token') ? (String) tokenMap.get('access_token') : '' } ) );
			req.setTimeout(120 * 1000);
			req.setBody(bodyJson);
			res = http.send(req);
			Map<String, Object> result = res != null? (Map<String, Object>) JSON.deserializeUntyped(res?.getBody()): new Map<String, Object>();
			if (result.containsKey('severity') && String.valueOf(result.get('severity')).equalsIgnoreCase('ERROR')) {
				noti.Integration_Status__c = 'Failed';
				noti.Integration_Message__c = result.containsKey('message')? String.valueOf(result.get('message')): MethodUtils.getValuesWithRegex(res.getBody(), new List<String>{ 'message' })?.get('message');
				noti.isIRPA__c = false;
				update noti;
				applog.Message_Type__c = 'Fail';
			}

			applog.Response_Body__c = res.getBody();
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Notification_Endpoint__c, applog);
		} catch (Exception e) {
			String msg = String.format( 'calloutToIRPA_Notification: {0} \r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() } );
			noti.Integration_Status__c = 'Failed';
			noti.Integration_Message__c = e.getMessage();
			update noti;
			applog.Message_Type__c = 'Fail';
			applog.Error_Message__c = msg;
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Notification_Endpoint__c, applog);
		}
	}

	public static void pushNotificationIntegrationSAP(List<Notification__c> newNotifications) {
		Id customNotiTypeId = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'THOR_Push_Notification']?.Id;
		try {
			for (Notification__c noti : newNotifications) {
				if ( noti.Integration_Status__c != null && !noti.Integration_Status__c?.equalsIgnoreCase('In Progress') ) {
					CustomNotificationHelper.sendAlert( CustomNotificationHelper.buildAlert( customNotiTypeId, JSON.serialize( new Map<String, Object>{ 'type' => 'standard__recordPage', 'attributes' => new Map<String, Object>{ 'recordId' => noti.Id, 'objectApiName' => Notification__c.getSObjectType().getDescribe().getName(), 'actionName' => 'view' } } ), String.format( 'Notification : {1}\r\n{2}\r\n{0}', new List<String>{ noti.Integration_Status__c?.equalsIgnoreCase('Success') ? '' : 'Please contact system admin\r\n', noti.Integration_Status__c?.equalsIgnoreCase('Success') ? noti.Notification_Number__c : noti.Name, String.format('FL : {0}', new List<String>{ noti.Functional_Location_Text__c }) } ), String.format( '{0}', new List<String>{ noti.Integration_Status__c?.equalsIgnoreCase('Success') ? 'Integration Success :' : 'Integration Failed :' } ) ), new Set<String>{ noti.CreatedById } );
				}
			}
		} catch (Exception e) {
//System.debug(System.LoggingLevel.ERROR,String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() }));
		}
	}
}