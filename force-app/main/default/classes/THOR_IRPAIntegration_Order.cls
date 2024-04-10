public class THOR_IRPAIntegration_Order {
	class OrderToSAP {
		String ordernumber;
		String ordertype;
		String fl;
		String equipment;
		String description;
		String noti_id;
		String notificationnumber;
		String pmactivitytype;
		String systemstatus;
		String userstatus;
		String superorder;
		String mainworkcenter;
		String requesteddate;
		String priority;
		String startdate;
		String finisheddate;
		String responsibleperson;
		String responsibleperson_old;
		String planningplant;
		String flag;
		String sf_id;
		String requestor;
		String mainworkcenterplant;
		String wbs_element;
		String requestor_role { get { return 'ZP'; } }
		String responsibleperson_role { get { return 'ZR'; } }
	}
	class OrderRequestWrapper {
		String invocationContext;
		OrderInputWrapper input;
	}
	class OrderInputWrapper {
		OrderDataWrapper OrderData;
	}
	class OrderDataWrapper {
		List<OrderToSAP> order;
		String uuid;
	}
	public static void checkOrder_beforeTrigger(List<SObject> newItems, Map<Id, SObject> oldItems) {
		Set<Id> notiSetId = new Set<Id>();
		for (Order__c ord : (List<Order__c>) newItems) {
			if (ord.Notification__c != null) notiSetId.add(ord.Notification__c);
		}
		Map<Id, Notification__c> childOrderMap = new Map<Id, Notification__c>( [SELECT Id, Requester_PISUser__c, Requester_PISUser_Text__c FROM Notification__c WHERE Id IN :notiSetId] );
		for (Object iorder : newItems) {
			Order__c newOrder = (Order__c) iorder;
			Order__c oldOrder = (Order__c) oldItems.get(newOrder.Id);
			if (newOrder.Order_Status__c == 'Closed') newOrder.Integration_Status__c = 'Success';
			if (newOrder.Requester_PISUser__c != null && newOrder.Requester__c == null) newOrder.Requester__c = THOR_IRPAIntegration.pisUserMap.get(newOrder.Requester_PISUser__c)?.User__c;
			if (newOrder.Responsible_person_PISUser__c != null && newOrder.Responsible_person__c == null) newOrder.Responsible_person__c = THOR_IRPAIntegration.pisUserMap.get( newOrder.Responsible_person_PISUser__c ) ?.User__c;
			if ( !THOR_IRPAIntegration.ISADMIN && (String.isEmpty(newOrder.Requester_PISUser_Text__c) || (newOrder.Requester_PISUser__c != oldOrder?.Requester_PISUser__c)) ) {
				String hostId = THOR_IRPAIntegration.pisUserMap.get(newOrder.Requester_PISUser__c)?.HOST_ID__c;
				String homeId = THOR_IRPAIntegration.pisUserMap.get(newOrder.Requester_PISUser__c)?.HOME_ID__c;
				newOrder.Requester_PISUser_Text__c = hostId != null ? hostId : homeId;
			}
// else if (
// 	/**
// 	 * @description when create order under notification should be get requester text information from notification
// 	 */
// 	childOrderMap.containsKey(newOrder.Notification__c) &&
// 	newOrder.Requester_PISUser__c == childOrderMap.get(newOrder.Notification__c)?.Requester_PISUser__c
// ) {
// 	newOrder.Requester_PISUser_Text__c = childOrderMap.get(newOrder.Notification__c)
// 		?.Requester_PISUser_Text__c;
// }
			if ( !THOR_IRPAIntegration.ISADMIN && (String.isEmpty(newOrder.Requester_PISUser_Text__c) || (newOrder.Responsible_person_PISUser__c != oldOrder?.Responsible_person_PISUser__c)) ) {
				String hostId = THOR_IRPAIntegration.pisUserMap.get(newOrder.Responsible_person_PISUser__c)?.HOST_ID__c;
				String homeId = THOR_IRPAIntegration.pisUserMap.get(newOrder.Responsible_person_PISUser__c)?.HOME_ID__c;
				newOrder.ResponsiblePerson_PISUser_Text__c = hostId != null ? hostId : homeId;
			}
			if (newOrder.Integration_Status__c == 'In Progress') newOrder.isIRPA__c = true;
		}
	}
// public static void checkOrder_beforeTrigger(Map<Id, SObject> newItems) {
// 	for (Object iorder : newItems.values()) {
// 		Order__c req = (Order__c) iorder;
// 		if (req.Integration_Status__c == 'In Progress' || String.isEmpty(req.Integration_Status__c)) {
// 			req.Integration_Status__c = 'In Progress';
// 		}
// 	}
// }
	public static void checkOrder_afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		Boolean isChanged = false;
		List<Order__c> orderList = new List<Order__c>();
		for (SObject o : newItems.values()) {
			Order__c oNew = (Order__c) o;
			Order__c oOld = (Order__c) oldItems.get(oNew.id);
			if ( oNew.Integration_Status__c == 'In Progress' && oNew.Integration_Status__c != oOld?.Integration_Status__c && oNew.isIRPA__c ) orderList.add(oNew);
		}
		if (orderList.size() > 0) THOR_IRPAIntegration_Order.sendOrderToSAP(orderList, (Map<Id, Order__c>) oldItems, 'Updated');
	}
	public static void checkOrder_afterInsert(Map<Id, SObject> newItems) {
		List<Order__c> orderList = new List<Order__c>();
		for (Object n : newItems.values()) {
			Order__c oNew = (Order__c) n;
			if (oNew.isIRPA__c) orderList.add(oNew);
		}
		if (orderList.size() > 0) THOR_IRPAIntegration_Order.sendOrderToSAP(orderList, new Map<Id, Order__c>(), 'Created');
	}
	//Order
	public static void sendOrderToSAP(List<Order__c> orderList, Map<Id, Order__c> oldOrderMap, String flag) {
		try {
			Map<Id, Order__c> newOrderMap = new Map<Id, Order__c>(orderList);
			Set<String> userSFIDSet = new Set<String>();
			Set<String> orderIDSet = new Set<String>();
			for (Order__c orderSF : orderList) {
				orderIDSet.add(orderSF.id);
			}
			List<Order__c> orderSFList = [ SELECT Id, Functional_Location__r.Name, Equipment__r.Name, Super_Order__r.Name, Name, Order_Number__c, Order_Type__c, Description__c, System_Status_Text__c, User_Status__c, Requested_Date__c, Priority__c, Start_Date__c, Finished_Date__c, Order_Status__c, mainWorkCenterPlantText__c, Notification__c, PM_Activity_Type__c, Main_Work_Center__c, Planning_Plant__c, Requester__c, Responsible_person__c, Notification__r.Name, PM_Activity_Type__r.Name, Main_Work_Center__r.Name, Planning_Plant__r.Name, Requester_PISUser__r.EMPLOYEEID__c, Responsible_person_PISUser__r.EMPLOYEEID__c, Super_Order__c, Request_Close__c, Requester_PISUser_Text__c, ResponsiblePerson_PISUser_Text__c, WBS__c FROM Order__c WHERE id IN :orderIDSet ];
			List<OrderToSAP> orderToSAPList = new List<OrderToSAP>();
			map<String, String> userMap = new Map<String, String>();
			for (Order__c orderSF : orderSFList) {
				Order__c newOrder = newOrderMap.get(orderSF.Id);
				OrderToSAP orderToSAP = new OrderToSAP();
				orderToSAP.ordernumber = orderSF.Name;
				orderToSAP.ordertype = String.isNotEmpty(orderSF.Order_Type__c) ? orderSF.Order_Type__c : '';
				orderToSAP.description = (orderSF.Description__c != null)?orderSF.Description__c:'';
                orderToSAP.systemstatus = (orderSF.System_Status_Text__c != null)?orderSF.System_Status_Text__c:'';
				orderToSAP.userstatus = (orderSF.User_Status__c != null)?orderSF.User_Status__c:'';
				orderToSAP.priority = (orderSF.Priority__c != null)?new Map<String, String>{ 'Normal' => '3', 'Urgent' => '2', 'Immediately' => '1', 'Float Time - 1M' => 'A', 'Float Time - 3M' => 'C', 'Float Time - 6M' => 'F', 'Float Time - 9M' => 'I', 'Float Time - 12M' => 'L', 'Float Time - 15M' => 'O', 'Float Time - 18M' => 'R' } .get(orderSF.Priority__c):'';
				orderToSAP.requesteddate = orderSF.Requested_Date__c != null ? ((Datetime) orderSF.Requested_Date__c).formatGMT('dd.MM.yyyy') : '';
				orderToSAP.startdate = orderSF.Start_Date__c != null ? ((Datetime) orderSF.Start_Date__c).formatGMT('dd.MM.yyyy') : '';
				orderToSAP.finisheddate = orderSF.Finished_Date__c != null ? ((Datetime) orderSF.Finished_Date__c).formatGMT('dd.MM.yyyy') : '';
				orderToSAP.flag = (orderSF.Request_Close__c == true)?'Closed':orderSF.Order_Number__c?.length() <= 12 ? flag : 'Created';
				orderToSAP.sf_id = orderSF.id;
				if (orderToSAP.flag.equalsIgnoreCase('Updated')) {
					List<String> filteredUserStatus = retrieveUserStatusForOrder(orderSF.Order_Type__c);
					List<String> userStatusTemp = orderToSAP.userstatus.split(' ');
					orderToSAP.userstatus = '';
					for (String userStatus : userStatusTemp) {
						if (filteredUserStatus.indexOf(userStatus) > -1) orderToSAP.userstatus = orderToSAP.userstatus + ' ' + userStatus;
					}
					orderToSAP.userstatus = orderToSAP.userstatus.trim();
				}
				orderToSAP.fl = (orderSF.Functional_Location__c != null)?orderSF.Functional_Location__r.Name:'';
				orderToSAP.equipment = orderSF.Equipment__r?.Name != null ? orderSF.Equipment__r.Name.leftPad(18, '0') : '';
				orderToSAP.noti_id = orderSF.Notification__c != null ? String.valueOf(orderSF.Notification__c) : '';
				orderToSAP.notificationnumber = (orderSF.Notification__c != null)?orderSF.Notification__r.Name:'';
                orderToSAP.pmactivitytype = (orderSF.PM_Activity_Type__c != null)?orderSF.PM_Activity_Type__r.Name:'';
                orderToSAP.superorder = (orderSF.Super_Order__c != null)?orderSF.Super_Order__r.Name:'';
                orderToSAP.mainworkcenter = (orderSF.Main_Work_Center__c != null)?orderSF.Main_Work_Center__r.Name:'';
				orderToSAP.requestor = newOrder.Requester_PISUser_Text__c != null ? newOrder.Requester_PISUser_Text__c : '';
				orderToSAP.responsibleperson = newOrder.ResponsiblePerson_PISUser_Text__c != null ? newOrder.ResponsiblePerson_PISUser_Text__c : '';
				orderToSAP.responsibleperson_old = oldOrderMap.containsKey(orderSF.Id) && oldOrderMap.get(orderSF.Id)?.ResponsiblePerson_PISUser_Text__c != null ? oldOrderMap.get(orderSF.Id)?.ResponsiblePerson_PISUser_Text__c : '';
				orderToSAP.planningplant = orderSF.Planning_Plant__c != null ? orderSF.Planning_Plant__r.Name : '';
				orderToSAP.mainworkcenterplant = String.isNotEmpty(orderSF.mainWorkCenterPlantText__c) ? orderSF.mainWorkCenterPlantText__c : '';
				orderToSAP.wbs_element = orderSF.WBS__c != null ? orderSF.WBS__c : '';
				orderToSAPList.add(orderToSAP);
			}
			String orderJSON = JSON.serialize(orderToSAPList);
			String uuid = Uuid.randomUUID();
			OrderDataWrapper orderWrapper = new OrderDataWrapper();
			orderWrapper.order = orderToSAPList;
			orderWrapper.uuid = uuid;
			OrderInputWrapper inputWrapper = new OrderInputWrapper();
			inputWrapper.orderData = orderWrapper;
			OrderRequestWrapper request = new OrderRequestWrapper();
            request.invocationContext = '${invocation_context}';
            request.input = inputWrapper;
            String requestJSON = JSON.serialize(request);
            calloutToIRPA_Order(requestJSON, orderSFList[0].id, uuid);
        } catch (Exception e) { system.debug('THOR_IRPAIntegation_Order---' + e.getMessage() + ' Line:' + e.getLineNumber()); }
	}
	public static List<String> retrieveUserStatusForOrder(String orderType) {
		List<String> res = new List<String>();
		Master_Map__c mmTemp = null;
		List<Master_Map__c> masterMapListTemp = [ SELECT Id, RelatedMasterMap2__r.Name FROM Master_Map__c WHERE Type__c = 'OrderTypewithStatusProfile' AND RelatedMasterMap1__r.Name = :orderType LIMIT 1 ];
		if (masterMapListTemp.size() > 0) {
			mmTemp = masterMapListTemp[0];
			masterMapListTemp = [ SELECT Id, RelatedMasterMap2__r.Name, RelatedMasterMap2__r.Description__c, RelatedMasterMap2__r.Type__c FROM Master_Map__c WHERE Type__c = 'OrderStatusProfileWithUserStatus' AND RelatedMasterMap1__r.Name = :mmTemp.RelatedMasterMap2__r.Name AND Status_Number__c = '' ];
			for (Master_Map__c mm : masterMapListTemp) {
				res.add(mm.RelatedMasterMap2__r.Name);
			}
		}
		return res;
	}
	@future(callout=true)
	public static void calloutToIRPA_Order(String bodyJson, String orderid, String externalid) {
		THORIntegration__c CS = THORIntegration__c.getInstance();
		Application_Log__c applog = new Application_Log__c(
			External_ID__c = externalid,
			Message_Type__c = 'In Progress',
			Integration_Name__c = 'calloutToIRPA_Order',
			Method__c = 'Create',
			Request_Body__c = bodyJson,
			Reference_ID__c = orderid
		);
		try {
			String reqbody = 'grant_type=client_credentials&client_id=' + CS.iRPA_Client_Id__c + '&client_secret=' + CS.iRPA_Client_Secret_Id__c;
			Http h = new Http();
			HttpRequest req = new HttpRequest();
			req.setBody(reqbody);
			req.setMethod('POST');
			req.setEndpoint(CS.iRPA_Token_Endpoint__c);
			HttpResponse res = h.send(req);
			String token = res.getBody();
			Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(token);
			String access_token = result.containsKey('access_token') ? (String) result.get('access_token') : '';
			Http http = new Http();
			HttpRequest httpReq = new HttpRequest();
			httpReq.setBody(bodyJson);
			httpReq.setMethod('POST');
			httpReq.setEndpoint(CS.iRPA_Order_Endpoint__c);
			httpReq.setHeader('Content-Type', 'application/json');
			httpReq.setHeader(CS.iRPA_API_Key_Header__c, CS.iRPA_API_Key__c);
			httpReq.setHeader('Authorization', 'Bearer ' + access_token);
			httpReq.setTimeout(60 * 1000);
			HttpResponse httpRes = http.send(httpReq);
			Map<String, Object> resultV = (Map<String, Object>) JSON.deserializeUntyped( httpRes?.getBody() != null ? httpRes.getBody() : '{}' );
			applog.Response_Body__c = httpRes.getBody();

			if ( resultV.isEmpty() || (resultV.containsKey('severity') && String.valueOf(resultV.get('severity')).equalsIgnoreCase('ERROR')) ) {
				Order__c updatedOrder = new Order__c(Id = orderid, isIRPA__c = false);
				updatedOrder.Integration_Status__c = 'Failed';
				updatedOrder.Integration_Message__c = resultV.containsKey('message') ? String.valueOf(resultV.get('message')) : MethodUtils.getValuesWithRegex(res.getBody(), new List<String>{ 'message' })?.get('message');
				update updatedOrder;
				applog.Message_Type__c = 'Fail';
			}
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Order_Endpoint__c, applog);
		} catch (Exception e) {
			applog.Integration_Name__c = 'calloutToIRPA_Order';
			applog.Method__c = 'Create';
			applog.Message_Type__c = 'In Progress';
			applog.Request_Body__c = bodyJson;
			applog.Reference_ID__c = orderid;
			ApplicationLogUtils.saveLogOutbound(CS.iRPA_Order_Endpoint__c, applog);
			system.debug('THOR_IRPAIntegation_Order---' + e.getMessage() + ' Line:' + e.getLineNumber());
			system.debug(e.getStackTraceString());
		}
	}
	public static void pushNotificationIntegrationSAP(List<Order__c> orderList) {
		Id customNotiTypeId = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'THOR_Push_Notification'] ?.Id;
// Integration failed : Please contact system admin
// Notification : (Salesforce ID)
		try {
			for (Order__c order : orderList) {
				if ( order.Integration_Status__c != null && !order.Integration_Status__c?.equalsIgnoreCase('In Progress') ) CustomNotificationHelper.sendAlert( CustomNotificationHelper.buildAlert( customNotiTypeId, JSON.serialize( new Map<String, Object>{ 'type' => 'standard__component', 'attributes' => new Map<String, Object>{ 'componentName' => 'c__THOR_OrderRecordDisplay' }, 'state' => new Map<String, Object>{ 'c__recordId' => order.Id } } ), String.format( 'Order : {1}\r\n{2}\r\n{0}', new List<String>{ order.Integration_Status__c?.equalsIgnoreCase('Success') ? '' : 'Please contact system admin\r\n', order.Integration_Status__c?.equalsIgnoreCase('Success') ? order.Order_Number__c : order.Name, String.format('FL : {0}', new List<String>{ order.Functional_Location_Text__c }) } ), String.format( '{0}', new List<String>{ order.Integration_Status__c?.equalsIgnoreCase('Success') ? 'Integration Success :' : 'Integration Failed :' } ) ), new Set<String>{ order.CreatedById } );
			}
		} catch (Exception e) { System.debug( System.LoggingLevel.ERROR, String.format('{0}\r\n{1}', new List<String>{ e.getMessage(), e.getStackTraceString() }) ); }
	}
}