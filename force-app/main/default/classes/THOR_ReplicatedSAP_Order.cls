public class THOR_ReplicatedSAP_Order extends MethodUtils implements Database.Batchable<Object>, Database.Stateful {

	private static final Map<String, Map<String, PISUsers__c>> PISUSERMAPEMP {
		get {
			if (PISUSERMAPEMP == null) {
				PISUSERMAPEMP = new Map<String, Map<String, PISUsers__c>>{'HOST_ID__c' => new Map<String, PISUsers__c>(),'HOME_ID__c' => new Map<String, PISUsers__c>()};
				for (PISUsers__c pisuser : [SELECT Id, EMPLOYEEID__c, HOST_ID__c, HOME_ID__c FROM PISUsers__c ORDER BY CreatedDate DESC, EMPLOYEEID__c]) {
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

	public class dto_response extends WebServiceExtend.dto_response {
	}

	public class OrderFromSAP {
		public String orderNumber;
		public String orderType;
		public String FL;
		public String equipment;
		public String description;
		public String notificationNumber;
		public String pmActivityType;
		public String systemStatus;
		public String userStatus;
		public String superOrder;
		public String mainWorkCenter;
		public String requestedDate;
		public String priority;
		public String startDate;
		public String finishedDate;
		public String requestor;
		public String responsiblePerson;
		public String planningPlant;
		public String grouptask;
		public String groupcount;
		public String mainWorkCenterPlant;
		public String wbs;
		public List<OperationOrderFromSAP> operationList;
		public List<SparePartRequestFromSAP> sparePartRequestList;
	}

	public class OperationOrderFromSAP {
		public String order;
		public String operationNo;
		public String workCenter;
		public String plant;
		public String controlKey;
		public String operationText;
		public String SubOperation;
	}

	public class SparePartRequestFromSAP {
		public String orderNo;
		public String operationNo;
		public String itemNo;
		public String materialNo;
		public String quantity;
		public String unit;
		public String itemCategory;
		public String plant;
		public String IC;
		public String status;
		public String description;
		public String avaliableQuantity;
	}

	public static dto_response parse(String json) {
		return (dto_response) System.JSON.deserialize(json, dto_response.class);
	}

	public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
		String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
		String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')) : '';

		if (body.length() > 1000) {
			Database.executeBatch(new THOR_ReplicatedSAP_Order(request.requestURI, body), 50);

			Application_Log__c applog = new Application_Log__c( External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_Order', Method__c = 'Upsert', Message_Type__c = 'Success', Request_Body__c = JSON.serialize(requestBody).left(121071), Response_Body__c = JSON.serialize(new Map<String, Object>{'description' => new Map<String, Object>{ 'success' => true, 'message' => '', 'linkurl' => '' },'recordIds' => null})); ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

			return dto_response.parse(applog.Response_Body__c);
		} else {
			Application_Log__c applog = new Application_Log__c( External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_Order', Method__c = 'Upsert', Message_Type__c = 'Success' );

			List<Order__c> savedOrderList;
			try {
				Object parsedBodyObj = System.JSON.deserializeUntyped(body);
				Map<String, Object> parsedBody = (Map<String, Object>) parsedBodyObj;
				Map<String, List<String>> errors = new Map<String, List<String>>();

                applog.Request_Body__c = JSON.serialize(MethodUtils.setResultByKeypath('body', parsedBodyObj, requestBody)).left(121071);

				savedOrderList = saveOrder((List<Object>) parsedBody.get('ORDERLIST'), errors);
			} catch (Exception ex) {
				applog.Error_Message__c = ex.getMessage();
				applog.Message_Type__c = 'Fail';
				applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => false, 'message' => ex.getMessage(), 'linkurl' => applog.External_ID__c } } );
				ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
				return dto_response.parse(applog.Response_Body__c);
			}

			applog.Response_Body__c = JSON.serialize( new Map<String, Object>{ 'description' => new Map<String, Object>{ 'success' => savedOrderList.size() > 0, 'message' => savedOrderList.size() > 0 ? '' : 'Not found Order Information', 'linkurl' => applog.External_ID__c }, 'recordIds' => (new Map<Id, Order__c>(savedOrderList)).keySet() } );
			ApplicationLogUtils.saveLogInbound(request.requestURI, applog);

			return dto_response.parse(applog.Response_Body__c);
		}

	}

	private static List<OrderFromSAP> parseJSONInputs(List<Object> orderList) {
		List<OrderFromSAP> inputs = new List<OrderFromSAP>();
		for (Object rawInput : orderList) {
			Map<String, Object> input = (Map<String, Object>) rawInput;

			OrderFromSAP ord = new OrderFromSAP();

			ord.orderNumber = String.valueOf(input.get('ORDERNUM'));
			ord.orderType = String.valueOf(input.get('ORDERTYPE'));
			ord.FL = String.valueOf(input.get('FUNCLOC'));
			ord.equipment = String.valueOf(input.get('EQNUM'));
			ord.description = String.valueOf(input.get('ORDERDESC'));
			ord.notificationNumber = String.valueOf(input.get('NOTFNUM'));
			ord.pmActivityType = String.valueOf(input.get('PMACTTYPE'));
			ord.systemStatus = String.valueOf(input.get('SYSSTATUS'));
			ord.userStatus = String.valueOf(input.get('USERSTATUS'));
			ord.superOrder = String.valueOf(input.get('SUPORDER'));
			ord.mainWorkCenter = String.valueOf(input.get('MAINWC'));
			ord.requestedDate = String.valueOf(input.get('CREATEDATE'));
			ord.priority = String.valueOf(input.get('PRIORITY'));
			ord.startDate = String.valueOf(input.get('BSCSTART'));
			ord.finishedDate = String.valueOf(input.get('BSCFIN'));
			ord.requestor = String.valueOf(input.get('REQUESTER'));
			ord.responsiblePerson = String.valueOf(input.get('RESPPERNO'));
			ord.planningPlant = String.valueOf(input.get('PLANNINGPLANT'));
			ord.grouptask = String.valueOf(input.get('GROUP'));
			ord.groupcount = String.valueOf(input.get('GROUPCOUNT'));
			ord.mainWorkCenterPlant = String.valueOf(input.get('MAINWORKCENTERPLANT'));
			ord.wbs = String.valueOf(input.get('WBS'));

			List<Object> operationListObj = (List<Object>) input.get('OPERATIONLIST');
			List<OperationOrderFromSAP> operationList = new List<OperationOrderFromSAP>();
			for (Object rawInput1 : operationListObj) {
				Map<String, Object> input1 = (Map<String, Object>) rawInput1;

				OperationOrderFromSAP operation = new OperationOrderFromSAP();
				operation.order = String.valueOf(input1.get('ORDERNUM'));
				operation.operationNo = String.valueOf(input1.get('OPERATION'));
				operation.workCenter = String.valueOf(input1.get('MAINWC'));
				operation.plant = String.valueOf(input1.get('WCPLANT'));
				operation.controlKey = String.valueOf(input1.get('CONTROLKEY'));
				operation.operationText = String.valueOf(input1.get('OPETEXT'));
				operation.SubOperation = String.valueOf(input1.get('SUBOPERATION'));
				operationList.add(operation);
			}
			ord.operationList = operationList;

			List<Object> sparePartRequestListObj = (List<Object>) input.get('SPAREPARTLIST');
			List<SparePartRequestFromSAP> sparePartRequestList = new List<SparePartRequestFromSAP>();

			for (Object rawInput2 : sparePartRequestListObj) {
				Map<String, Object> input2 = (Map<String, Object>) rawInput2;

				SparePartRequestFromSAP sparePart = new SparePartRequestFromSAP();
				sparePart.orderNo = String.valueOf(input2.get('ORDERNUM'));
				sparePart.operationNo = String.valueOf(input2.get('OPERATION'));
				sparePart.itemNo = String.valueOf(input2.get('ITEMNUM'));
				sparePart.materialNo = String.valueOf(input2.get('COMPONENT'));
				sparePart.quantity = String.valueOf(input2.get('REQQNT'));
				sparePart.unit = String.valueOf(input2.get('UNIT'));
				sparePart.itemCategory = String.valueOf(input2.get('ITEMCATE'));
				sparePart.plant = String.valueOf(input2.get('PPLANT'));
				sparePart.IC = String.valueOf(input2.get('IC'));
				sparePart.status = String.valueOf(input2.get('SYSSTATUS'));
				sparePart.description = String.valueOf(input2.get('COMDESC'));
				sparePart.avaliableQuantity = String.valueOf(input2.get('AVAIQNT'));
				sparePartRequestList.add(sparePart);
			}
			ord.sparePartRequestList = sparePartRequestList;

			inputs.add(ord);
		}

		return inputs;
	}

	private static Map<String, User> getMapUser() {
		Map<String, User> userMap = new Map<String, User>();

		for (User u : [SELECT Id, Employee_Id__c FROM User WHERE Employee_Id__c != NULL]) {
			userMap.put(u.Employee_Id__c, u);
		}

		return userMap;
	}

	private static Map<String, Master_Map__c> getMapMasterMap() {
		Map<String, Master_Map__c> masterMap = new Map<String, Master_Map__c>();
		for (Master_Map__c master : [SELECT Id, Name FROM Master_Map__c WHERE Type__c = 'Plant' OR Type__c = 'MaintActivityType' OR Type__c = 'Main Work Center']) {
			masterMap.put(master.Name, master);
		}

		return masterMap;
	}

	private static Map<String, Functional_Location__c> getMapFunctionalLocation(List<OrderFromSAP> orderList) {
		List<String> flstrList = new List<String>();
		for (OrderFromSAP orderSAP : orderList) {
			if (orderSAP.FL != null) {
				String FLStr = orderSAP.FL.trim();
				if (FLStr != '') {
					flstrList.add(FLStr);
				}
			}
		}

		Map<String, Functional_Location__c> flMap = new Map<String, Functional_Location__c>();
		for (Functional_Location__c fl : [SELECT Id, Name, MainWorkCenter__c, MainWorkCenter__r.Name FROM Functional_Location__c WHERE NAME IN :flstrList]) {
			flMap.put(fl.name, fl);
		}
		return flMap;
	}

	private static Map<String, Equipment__c> getMapEquipment(List<OrderFromSAP> orderList) {
		List<String> eqstrList = new List<String>();
		for (OrderFromSAP orderSAP : orderList) {
			if (orderSAP.equipment != null) {
				String eqpStr = orderSAP.equipment.trim();
				if (eqpStr != '') {
					eqstrList.add(eqpStr);
				}
			}
		}

		Map<String, Equipment__c> eqMap = new Map<String, Equipment__c>();
		for (Equipment__c eq : [SELECT Id, Name FROM Equipment__c WHERE NAME IN :eqstrList]) {
			eqMap.put(eq.Name, eq);
		}
		return eqMap;
	}

	private static Map<String, Notification__c> getMapNotification(List<OrderFromSAP> orderList) {
		List<String> notistrList = new List<String>();
		for (OrderFromSAP orderSAP : orderList) {
			if (orderSAP.notificationNumber != null) {
				String notiStr = orderSAP.notificationNumber.trim();
				if (notiStr != '') {
					notistrList.add(notiStr);
				}
			}
		}

		Map<String, Notification__c> notiMap = new Map<String, Notification__c>();
		for (Notification__c noti : [SELECT id, Notification_Number__c FROM Notification__c WHERE Notification_Number__c IN :notistrList]) {
			notiMap.put(noti.Notification_Number__c, noti);
		}

		return notiMap;
	}

	private static Map<String, Order__c> getMapOrder(List<OrderFromSAP> orderList) {
		List<String> supOrderstrList = new List<String>();
		for (OrderFromSAP orderSAP : orderList) {
			if (orderSAP.superOrder != null) {
				String orderSup = orderSAP.superOrder.trim();
				if (orderSup != '') {
					supOrderstrList.add(orderSup);
				}
			}
		}

		Map<String, Order__c> supOMap = new Map<String, Order__c>();
		for (Order__c supO : [SELECT Id, Order_Number__c FROM Order__c WHERE Order_Number__c IN :supOrderstrList]) {
			supOMap.put(supO.Order_Number__c, supO);
		}
		return supOMap;
	}

	public static List<Order__c> saveOrder(
		List<Object> sapOrderList,
		Map<String, List<String>> errors
	) {
		List<OrderFromSAP> orderList = parseJSONInputs(sapOrderList);

		List<Order__c> orderListSF = new List<Order__c>();

		Map<String, String> priorityMap = new Map<String, String>{ '1' => 'Immediately', '2' => 'Urgent', '3' => 'Normal', 'A' => 'Float Time - 1M', 'C' => 'Float Time - 3M', 'F' => 'Float Time - 6M', 'I' => 'Float Time - 9M', 'L' => 'Float Time - 12M', 'O' => 'Float Time - 15M', 'R' => 'Float Time - 18M' };

		if (orderList.size() > 0) {
			Map<String, User> userMap = getMapUser();
			Map<String, Master_Map__c> masterMap = getMapMasterMap();
			Map<String, Functional_Location__c> flMap = getMapFunctionalLocation(orderList);
			Map<String, Equipment__c> eqMap = getMapEquipment(orderList);
			Map<String, Notification__c> notiMap = getMapNotification(orderList);
			Map<String, Order__c> supOMap = getMapOrder(orderList);
			Map<String, String> orderUserStatusMap = new Map<String, String>();
			 Map<String, String> sparePartMap = new Map<String, String>();

			Set<String> sparePartSet = new Set<String>();
			Map<String, Spare_Part__c> upsertedSparePart = new Map<String, Spare_Part__c>();
			for (OrderFromSAP orderSAP : orderList) {
				if (orderSAP.sparePartRequestList != null) {
					for (SparePartRequestFromSAP iSparePartRequest : orderSAP.sparePartRequestList) {
						if (iSparePartRequest.materialNo != null) {
							sparePartSet.add(iSparePartRequest.materialNo);
							Spare_Part__c iSp = new Spare_Part__c();
							iSp.Material_Number__c = iSparePartRequest.materialNo;
							iSp.Name = iSparePartRequest.materialNo;
							iSp.Base_Unit__c = iSparePartRequest.unit;
							iSp.Material_Description__c = iSparePartRequest.description;
							upsertedSparePart.put(iSp.Name, iSp);
						}
					}
				}
			}

			if (upsertedSparePart.values().size() > 0) {
				upsert upsertedSparePart.values() Name;
				for (Spare_Part__c sp : upsertedSparePart.values()) {
					sparePartMap.put(sp.Name, sp.Id);
				}
			}

			for (OrderFromSAP orderSAP : orderList) {
				Order__c iOrder = new Order__c();
				iOrder.Integration_Status__c = 'Success';
				iOrder.Order_Type__c = orderSAP.orderType;
				iOrder.Order_Number__c = orderSAP.orderNumber;
				iOrder.Name = orderSAP.orderNumber;
				iOrder.grouptask__c = orderSAP.grouptask;
				iOrder.groupcount__c = orderSAP.groupcount;
				iOrder.WBS__c = orderSAP.wbs;
				iOrder.Description__c = orderSAP.description.unescapeHtml4();
				iOrder.System_Status_Text__c = orderSAP.systemStatus;
				iOrder.User_Status__c = orderSAP.userStatus;
				iOrder.User_Status_Text__c = orderSAP.userStatus;
				iOrder.isSOAP__c = true;
				iOrder.Priority__c = priorityMap.get(orderSAP.priority?.trim());

				orderUserStatusMap.put(orderSAP.orderNumber, orderSAP.userStatus);

				String FLStr = (orderSAP.FL != null) ? orderSAP.FL.trim() : '';
				if (flMap.containskey(FLStr)) {
					iOrder.Functional_Location__c = flMap.get(FLStr).Id;
					iOrder.Main_Work_Center__c = flMap.get(FLStr).MainWorkCenter__c;
					iOrder.Main_Work_Center_Text__c = flMap.get(FLStr).MainWorkCenter__r.Name;
				}

				String pmActivityType = (orderSAP.pmActivityType != null) ? orderSAP.pmActivityType.trim() : '';
				iOrder.PM_Activity_Type__c = masterMap.containsKey(pmActivityType) ? masterMap.get(pmActivityType).Id : null;

				String mainWorkCenter = (orderSAP.mainWorkCenter != null) ? orderSAP.mainWorkCenter.trim() : '';
				if (masterMap.containsKey(mainWorkCenter)) {
					iOrder.Main_Work_Center__c = masterMap.get(mainWorkCenter).Id;
					iOrder.Main_Work_Center_Text__c = masterMap.get(mainWorkCenter).Name;
				}

				String planningPlant = (orderSAP.planningPlant != null) ? orderSAP.planningPlant.trim() : '';
				iOrder.Planning_Plant__c = masterMap.containsKey(planningPlant) ? masterMap.get(planningPlant).Id : null;

				String mainWorkCenterPlant = (orderSAP.mainWorkCenterPlant != null) ? orderSAP.mainWorkCenterPlant.trim() : '';
				iOrder.mainWorkCenterPlant__c = masterMap.containsKey(mainWorkCenterPlant) ? masterMap.get(mainWorkCenterPlant).Id : null;

				String eqpStr = (orderSAP.equipment != null) ? orderSAP.equipment.trim() : '';
				iOrder.Equipment__c = eqMap.containsKey(eqpStr) ? eqMap.get(eqpStr).Id : null;

				String notiStr = (orderSAP.notificationNumber != null) ? orderSAP.notificationNumber.trim() : '';
				iOrder.Notification__c = notiMap.containsKey(notiStr) ? notiMap.get(notiStr).Id : null;

				String orderSup = (orderSAP.superOrder != null) ? orderSAP.superOrder.trim() : '';
				iOrder.Super_Order__c = supOMap.containskey(orderSup) ? supOMap.get(orderSup).Id : null;

				if (orderSAP.systemStatus != null) {
					iOrder.Order_Status__c = orderSAP.systemStatus.contains('CRTD') ? 'New' : orderSAP.systemStatus.contains('REL') ? 'In Progress' : orderSAP.systemStatus.contains('TECO') ? 'Closed' : null;
				}

				if (orderSAP.requestedDate != null) {
					iOrder.Requested_Date__c = orderSAP.requestedDate.trim() != '' ?  Date.valueOf(orderSAP.requestedDate) : null;
				}
				iOrder.Start_Date__c = orderSAP.startDate != null && orderSAP.startDate.trim() != '' ? Date.valueOf(orderSAP.startDate) : null;
				iOrder.Finished_Date__c = orderSAP.finishedDate != null && orderSAP.finishedDate.trim() != '' ? Date.valueOf(orderSAP.finishedDate) : null;

				if (String.isNotEmpty(orderSAP.requestor)) {
					String requestor = orderSAP.requestor.trim();
					iOrder.Requester__c = userMap.containsKey(requestor) ? userMap.get(requestor).Id : null;

					String pisRequestor = String.isNotEmpty(requestor) ? requestor.leftPad(8, '0') : '';
					iOrder.Requester_PISUser__c = PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisRequestor) ? PISUSERMAPEMP.get('HOST_ID__c').get(pisRequestor).Id : PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisRequestor) ? PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor).Id : null;
				}
				if (String.isNotEmpty(orderSAP.responsiblePerson)) {
					String responsiblePerson = orderSAP.responsiblePerson.trim();
					iOrder.ResponsiblePerson_PISUser_Text__c = responsiblePerson?.leftPad(8, '0');
					iOrder.Responsible_person__c = userMap.containsKey(responsiblePerson) ?  userMap.get(responsiblePerson).Id : null;

					String pisResponsiblePerson = (String.isNotEmpty(responsiblePerson)) ? responsiblePerson.leftPad(8, '0') : '';
					iOrder.Responsible_person_PISUser__c = PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisResponsiblePerson) ? PISUSERMAPEMP.get('HOST_ID__c').get(pisResponsiblePerson).Id : PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisResponsiblePerson) ? PISUSERMAPEMP.get('HOME_ID__c').get(pisResponsiblePerson).Id : null;
				}

				orderListSF.add(iOrder);
			}

			if (orderListSF.size() > 0) {
				upsert orderListSF Name;

				Map<String, String> upsertedOrderMap = new Map<String, String>();
				Map<String, Order_Operation__c> orderOperationList = new Map<String, Order_Operation__c>();
				String plant = '';

				for (Order__c iOrder : orderListSF) {
					upsertedOrderMap.put(iOrder.Order_Number__c, iOrder.Id);
				}

				for (OrderFromSAP iOrderFromSAP : orderList) {
					if (iOrderFromSAP.operationList != null) {
						for (OperationOrderFromSAP iOperation : iOrderFromSAP.operationList) {
							Order_Operation__c iOP = new Order_Operation__c();
							iOP.Order__c = upsertedOrderMap.get(iOperation.order);
							iOP.SubOperation__c = iOperation.SubOperation;
							iOP.Operation_Text__c = iOperation.operationNo;
							iOP.Control_Key__c = iOperation.controlKey;
							iOP.Operation_Shot_Text__c = iOperation.operationText;
							iOP.Main_Work_Center__c = masterMap.containskey(iOperation.workCenter) ? masterMap.get(iOperation.workCenter).Id : null;
							
							if (masterMap.containskey(iOperation.plant)) {
								iOP.Plant__c = masterMap.get(iOperation.plant).Id;
								plant = masterMap.get(iOperation.plant).Id;
							}
							if (iOperation.SubOperation != null && iOperation.SubOperation != '') {
								iOP.OrderOperation__c =
									iOperation.order?.trim() +
									iOperation.operationNo?.trim() +
									iOperation.SubOperation?.trim();
							} else {
								iOP.OrderOperation__c = iOperation.order.trim() + iOperation.operationNo.trim();
							}

							orderOperationList.put(iOP.OrderOperation__c, iOP);
						}
					}
				}

				if (orderOperationList.values().size() > 0) {
					upsert orderOperationList.values() OrderOperation__c;

					Map<String, String> orderOperationMap = new Map<String, String>();

					Map<String, Spare_Part_Request__c> spRequestList = new Map<String, Spare_Part_Request__c>();

					for (Order_Operation__c iOP : orderOperationList.values()) {
						orderOperationMap.put(iOP.OrderOperation__c, iOP.Id);
					}

					List<Spare_Part_Stock__c> stockList = [SELECT Spare_Part__r.Name, Spare_Part__c, Available_Quantity__c FROM Spare_Part_Stock__c WHERE Plant__c = :plant AND Spare_Part__r.Name IN :sparePartSet];

					Map<String, Double> stockMap = new Map<String, Double>();
					for (Spare_Part_Stock__c istock : stockList) {
						stockMap.put(istock.Spare_Part__c, istock.Available_Quantity__c);
					}

					for (OrderFromSAP iOrderFromSAP : orderList) {
						if (iOrderFromSAP.sparePartRequestList != null) {
							for (SparePartRequestFromSAP iSparePartRequest : iOrderFromSAP.sparePartRequestList) {
								Spare_Part_Request__c sp = new Spare_Part_Request__c();
								String orderOperationKey = iSparePartRequest.orderNo + iSparePartRequest.operationNo;
								sp.Order__c = upsertedOrderMap.get(iSparePartRequest.orderNo);
								sp.Item_No__c = iSparePartRequest.itemNo;
								sp.Request_Material_Quantity__c = Double.valueOf(iSparePartRequest.quantity); //Decimal.valueOf(iSparePartRequest.quantity);
								sp.UM__c = iSparePartRequest.unit;
								sp.IC__c = iSparePartRequest.IC;
								sp.Description__c = iSparePartRequest.description;
								sp.isSOAP__c = true;
								sp.Order_Operation__c = orderOperationMap.containskey(orderOperationKey) ? orderOperationMap.get(orderOperationKey) : null;


								if (iSparePartRequest.materialNo != null) {
									sp.Spare_Part__c = sparePartMap.containskey(iSparePartRequest.materialNo) ? sparePartMap.get(iSparePartRequest.materialNo) : null;
								}

								String spStatus = '';
								if (orderUserStatusMap.containskey(iSparePartRequest.orderNo)) {
									String orderUserStatus = orderUserStatusMap.get(iSparePartRequest.orderNo);
									spStatus = orderUserStatus != null && orderUserStatus.contains('COMP') ? 'Approved' : orderUserStatus != null && orderUserStatus.contains('REJT') ? 'Rejected' : 'Pending for Approval';
								}
								sp.Request_Status__c = spStatus;
								sp.Plant__c = masterMap.containsKey(iSparePartRequest.plant) ? masterMap.get(iSparePartRequest.plant).Id : null;

								if (sp.Spare_Part__c != null) {
									sp.Available_Quantity__c = stockMap.containskey(sp.Spare_Part__c) ? stockMap.get(sp.Spare_Part__c) : null;
								}

								sp.OrderOrderOperation__c =iSparePartRequest.orderNo?.trim() +iSparePartRequest.operationNo?.trim() +iSparePartRequest.itemNo?.trim(); // + iSparePartRequest.materialNo;
								spRequestList.put(sp.OrderOrderOperation__c, sp);
							}
						}
					}
					if (spRequestList.values().size() > 0) {
						upsert spRequestList.values() OrderOrderOperation__c;
					}
				}
			}
		}
		return orderListSF;
	}

//	public static List<Order__c> saveOrder(
//		List<Object> sapOrderList,
//		Map<String, List<String>> errors
//	) {
//
//		List<OrderFromSAP> orderList = parseJSONInputs(sapOrderList);
//
//		List<User> userList;
//		List<Master_Map__c> MasterList;
//		List<Order__c> orderListSF = new List<Order__c>();
//		if (orderList.size() > 0) {
//			userList = [SELECT id, Employee_Id__c FROM User WHERE Employee_Id__c != NULL];
//
//			map<String, String> userMap = new Map<String, String>();
//			for (User u : userList) {
//				userMap.put(u.Employee_Id__c, u.id);
//			}
//
//			MasterList = [
//				SELECT Id, Name
//				FROM Master_Map__c
//				WHERE Type__c = 'Plant' OR Type__c = 'MaintActivityType' OR Type__c = 'Main Work Center'
//			];
//
//			map<String, Master_Map__c> masterMap = new Map<String, Master_Map__c>();
//			for (Master_Map__c master : MasterList) {
//				masterMap.put(master.Name, master);
//			}
//
//			//List<Order__c> orderListSF = new List<Order__c>();
//			Map<String, String> orderUserStatusMap = new Map<String, String>();
//			List<String> flstrList = new List<String>();
//			List<String> eqstrList = new List<String>();
//			List<String> notistrList = new List<String>();
//			List<String> supOrderstrList = new List<String>();
//			set<String> sparePartSet = new Set<String>();
//			map<String, Spare_Part__c> upsertedSparePart = new Map<String, Spare_Part__c>();
//			map<String, String> sparePartMap = new Map<String, String>();
//
//			for (OrderFromSAP orderSAP : orderList) {
//				if (orderSAP.FL != null) {
//					String FLStr = orderSAP.FL.trim();
//					if (FLStr != '') {
//						flstrList.add(FLStr);
//					}
//				}
//
//				if (orderSAP.equipment != null) {
//					String eqpStr = orderSAP.equipment.trim();
//					if (eqpStr != '') {
//						eqstrList.add(eqpStr);
//					}
//				}
//				if (orderSAP.notificationNumber != null) {
//					String notiStr = orderSAP.notificationNumber.trim();
//					if (notiStr != '') {
//						notistrList.add(notiStr);
//					}
//				}
//
//				String orderSup = '';
//				if (orderSAP.superOrder != null) {
//					orderSup = orderSAP.superOrder.trim();
//					supOrderstrList.add(orderSup);
//				}
//				if (orderSAP.sparePartRequestList != null) {
//					for (SparePartRequestFromSAP iSparePartRequest : orderSAP.sparePartRequestList) {
//						if (iSparePartRequest.materialNo != null) {
//							sparePartSet.add(iSparePartRequest.materialNo);
//							Spare_Part__c iSp = new Spare_Part__c();
//							iSp.Material_Number__c = iSparePartRequest.materialNo;
//							iSp.Name = iSparePartRequest.materialNo;
//							iSp.Base_Unit__c = iSparePartRequest.unit;
//							iSp.Material_Description__c = iSparePartRequest.description;
//							upsertedSparePart.put(iSp.Name, iSp);
//						}
//					}
//				}
//			}
//
//			if (upsertedSparePart.values().size() > 0) {
//				upsert upsertedSparePart.values() Name;
//				for (Spare_Part__c sp : upsertedSparePart.values()) {
//					sparePartMap.put(sp.Name, sp.Id);
//				}
//			}
//
//			List<Functional_Location__c> flList = [
//				SELECT id, name, MainWorkCenter__c, MainWorkCenter__r.Name
//				FROM Functional_Location__c
//				WHERE NAME IN :flstrList
//			];
//			List<Equipment__c> eqList = [SELECT id, name FROM Equipment__c WHERE NAME IN :eqstrList];
//			List<Notification__c> notiList = [
//				SELECT id, Notification_Number__c
//				FROM Notification__c
//				WHERE Notification_Number__c IN :notistrList
//			];
//			List<Order__c> sforderList = [
//				SELECT id, Order_Number__c
//				FROM Order__c
//				WHERE Order_Number__c IN :supOrderstrList
//			];
//
//			map<String, Functional_Location__c> flMap = new Map<String, Functional_Location__c>();
//			for (Functional_Location__c fl : flList) {
//				flMap.put(fl.name, fl);
//			}
//
//			map<String, String> eqMap = new Map<String, String>();
//			for (Equipment__c eq : eqList) {
//				eqMap.put(eq.name, eq.id);
//			}
//
//			map<String, String> notiMap = new Map<String, String>();
//			for (Notification__c noti : notiList) {
//				notiMap.put(noti.Notification_Number__c, noti.id);
//			}
//
//			map<String, String> supOMap = new Map<String, String>();
//			for (Order__c supO : sforderList) {
//				supOMap.put(supO.Order_Number__c, supO.id);
//			}
//
//			for (OrderFromSAP orderSAP : orderList) {
//				Order__c iOrder = new Order__c();
//				iOrder.Integration_Status__c = 'Success';
//				iOrder.Order_Type__c = orderSAP.orderType;
//				iOrder.Order_Number__c = orderSAP.orderNumber;
//				iOrder.Name = orderSAP.orderNumber;
//				iOrder.grouptask__c = orderSAP.grouptask;
//				iOrder.groupcount__c = orderSAP.groupcount;
//				iOrder.WBS__c = orderSAP.wbs;
//
//				String FLStr = orderSAP.FL.trim();
//				if (FLStr != '') {
//					if (flMap.containskey(FLStr)) {
//						iOrder.Functional_Location__c = flMap.get(FLStr).Id;
//						iOrder.Main_Work_Center__c = flMap.get(FLStr).MainWorkCenter__c;
//						iOrder.Main_Work_Center_Text__c = flMap.get(FLStr).MainWorkCenter__r.Name;
//					}
//				}
//
//				if (masterMap.containsKey(orderSAP.pmActivityType)) {
//					iOrder.PM_Activity_Type__c = masterMap.get(orderSAP.pmActivityType).Id;
//				}
//
//				if (masterMap.containsKey(orderSAP.mainWorkCenter)) {
//					iOrder.Main_Work_Center__c = masterMap.get(orderSAP.mainWorkCenter).Id;
//					iOrder.Main_Work_Center_Text__c = masterMap.get(orderSAP.mainWorkCenter).Name;
//				}
//				if (masterMap.containsKey(orderSAP.planningPlant)) {
//					iOrder.Planning_Plant__c = masterMap.get(orderSAP.planningPlant).Id;
//				}
//				if (masterMap.containsKey(orderSAP.mainWorkCenterPlant)) {
//					iOrder.mainWorkCenterPlant__c = masterMap.get(orderSAP.mainWorkCenterPlant).Id;
//				}
//
//				if (orderSAP.equipment != null) {
//					String eqpStr = orderSAP.equipment.trim();
//					if (eqpStr != '') {
//						if (eqMap.containsKey(eqpStr)) {
//							iOrder.Equipment__c = eqMap.get(eqpStr);
//						}
//					}
//				}
//
//				iOrder.Description__c = orderSAP.description.unescapeHtml4();
//				if (orderSAP.notificationNumber != null) {
//					String notiStr = orderSAP.notificationNumber.trim();
//					if (notiStr != '') {
//						if (notiMap.containsKey(notiStr)) {
//							iOrder.Notification__c = notiMap.get(notiStr);
//						}
//					}
//				}
//
//				if (orderSAP.systemStatus != null) {
//					if (orderSAP.systemStatus.contains('CRTD')) {
//						iOrder.Order_Status__c = 'New';
//					} else if (orderSAP.systemStatus.contains('REL')) {
//						iOrder.Order_Status__c = 'In Progress';
//					} else if (orderSAP.systemStatus.contains('TECO')) {
//						iOrder.Order_Status__c = 'Closed';
//					}
//				}
//
//				iOrder.System_Status_Text__c = orderSAP.systemStatus;
//				iOrder.User_Status__c = orderSAP.userStatus;
//				iOrder.User_Status_Text__c = orderSAP.userStatus;
//
//				orderUserStatusMap.put(orderSAP.orderNumber, orderSAP.userStatus);
//				String orderSup = '';
//				if (orderSAP.superOrder != null) {
//					orderSup = orderSAP.superOrder.trim();
//				}
//
//				if (orderSup != '') {
//					if (supOMap.containskey(orderSup)) {
//						iOrder.Super_Order__c = supOMap.get(orderSup);
//					}
//				}
//
//				if (orderSAP.requestedDate != null) {
//					if (orderSAP.requestedDate.trim() != '') {
//						//						String day = orderSAP.requestedDate.substring(0, 2);
//						//						String month = orderSAP.requestedDate.substring(3, 5);
//						//						String year = orderSAP.requestedDate.substring(
//						//							orderSAP.requestedDate.length() - 4,
//						//							orderSAP.requestedDate.length()
//						//						);
//						//
//						//						String dateStr = day + '/' + month + '/' + year;
//						//						iOrder.Requested_Date__c = date.parse(dateStr);
//						iOrder.Requested_Date__c = Date.valueOf(orderSAP.requestedDate);
//					}
//				}
//
//				if (orderSAP.startDate != null) {
//					if (orderSAP.startDate.trim() != '') {
//						//						String day = orderSAP.startDate.substring(0, 2);
//						//						String month = orderSAP.startDate.substring(3, 5);
//						//						String year = orderSAP.startDate.substring(
//						//							orderSAP.startDate.length() - 4,
//						//							orderSAP.startDate.length()
//						//						);
//						//
//						//						String dateStr = day + '/' + month + '/' + year;
//						//
//						//						iOrder.Start_Date__c = date.parse(dateStr);
//						iOrder.Start_Date__c = Date.valueOf(orderSAP.startDate);
//					}
//				}
//
//				if (orderSAP.finishedDate != null) {
//					if (orderSAP.finishedDate.trim() != '') {
//						//						String day = orderSAP.finishedDate.substring(0, 2);
//						//						String month = orderSAP.finishedDate.substring(3, 5);
//						//						String year = orderSAP.finishedDate.substring(
//						//							orderSAP.finishedDate.length() - 4,
//						//							orderSAP.finishedDate.length()
//						//						);
//						//
//						//						String dateStr = day + '/' + month + '/' + year;
//						//						iOrder.Finished_Date__c = date.parse(dateStr);
//						iOrder.Finished_Date__c = Date.valueOf(orderSAP.finishedDate);
//					}
//				}
//
//				if (String.isNotEmpty(orderSAP.requestor)) {
//					String requestor = orderSAP.requestor.trim();
//					if (userMap.containsKey(requestor)) {
//						iOrder.Requester__c = userMap.get(requestor);
//					}
//
//					String pisRequestor = String.isNotEmpty(requestor) ? requestor.leftPad(8, '0') : '';
//					if (PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisRequestor)) {
//						iOrder.Requester_PISUser__c = PISUSERMAPEMP.get('HOST_ID__c').get(pisRequestor).Id;
//					} else if (PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisRequestor)) {
//						iOrder.Requester_PISUser__c = PISUSERMAPEMP.get('HOME_ID__c').get(pisRequestor).Id;
//					} else {
//						iOrder.Requester_PISUser__c = null;
//					}
//				}
//				if (String.isNotEmpty(orderSAP.responsiblePerson)) {
//					String responsiblePerson = orderSAP.responsiblePerson.trim();
//					iOrder.ResponsiblePerson_PISUser_Text__c = responsiblePerson?.leftPad(8, '0');
//					if (userMap.containsKey(responsiblePerson)) {
//						iOrder.Responsible_person__c = userMap.get(responsiblePerson);
//					}
//
//					String pisResponsiblePerson = (String.isNotEmpty(responsiblePerson)) ? responsiblePerson.leftPad(8, '0') : '';
//					if (PISUSERMAPEMP.get('HOST_ID__c').containsKey(pisResponsiblePerson)) {
//						iOrder.Responsible_person_PISUser__c = PISUSERMAPEMP.get('HOST_ID__c').get(pisResponsiblePerson).Id;
//					} else if (PISUSERMAPEMP.get('HOME_ID__c').containsKey(pisResponsiblePerson)) {
//						iOrder.Responsible_person_PISUser__c = PISUSERMAPEMP.get('HOME_ID__c').get(pisResponsiblePerson).Id;
//					} else {
//						iOrder.Responsible_person_PISUser__c = null;
//					}
//				}
//
//				// if (orderSAP.priority == '3') {
//				// 	iOrder.Priority__c = 'Normal';
//				// } else if (orderSAP.priority == '2') {
//				// 	iOrder.Priority__c = 'Urgent';
//				// } else if (orderSAP.priority == '1') {
//				// 	iOrder.Priority__c = 'Immediately';
//				// } else {
//				// }
//				iOrder.Priority__c = new Map<String, String>{ '3' => 'Normal', '2' => 'Urgent', '1' => 'Immediately' }
//					.get(orderSAP.priority?.trim());
//				iOrder.isSOAP__c = true;
//				orderListSF.add(iOrder);
//			}
//
//			if (orderListSF.size() > 0) {
//				upsert orderListSF Name;
//
//				map<String, String> upsertedOrderMap = new Map<String, String>();
//				map<String, Order_Operation__c> orderOperationList = new Map<String, Order_Operation__c>();
//				String plant = '';
//
//				for (Order__c iOrder : orderListSF) {
//					upsertedOrderMap.put(iOrder.Order_Number__c, iOrder.Id);
//				}
//
//				for (OrderFromSAP iOrderFromSAP : orderList) {
//					if (iOrderFromSAP.operationList != null) {
//						for (OperationOrderFromSAP iOperation : iOrderFromSAP.operationList) {
//							Order_Operation__c iOP = new Order_Operation__c();
//							iOP.Order__c = upsertedOrderMap.get(iOperation.order);
//							iOP.SubOperation__c = iOperation.SubOperation;
//							iOP.Operation_Text__c = iOperation.operationNo;
//
//							if (masterMap.containskey(iOperation.workCenter)) {
//								iOP.Main_Work_Center__c = masterMap.get(iOperation.workCenter).Id;
//							}
//							if (masterMap.containskey(iOperation.plant)) {
//								iOP.Plant__c = masterMap.get(iOperation.plant).Id;
//								plant = masterMap.get(iOperation.plant).Id;
//							}
//							iOP.Control_Key__c = iOperation.controlKey;
//							iOP.Operation_Shot_Text__c = iOperation.operationText;
//							//system.debug('iOperation.SubOperation---'+iOperation.SubOperation);
//							if (iOperation.SubOperation != null && iOperation.SubOperation != '') {
//								iOP.OrderOperation__c =
//									iOperation.order.trim() +
//									iOperation.operationNo.trim() +
//									iOperation.SubOperation.trim();
//							} else {
//								iOP.OrderOperation__c = iOperation.order.trim() + iOperation.operationNo.trim();
//							}
//							orderOperationList.put(iOP.OrderOperation__c, iOP);
//						}
//					}
//				}
//
//				if (orderOperationList.values().size() > 0) {
//					System.debug('orderOperationList' + orderOperationList);
//					upsert orderOperationList.values() OrderOperation__c;
//
//					map<String, String> orderOperationMap = new Map<String, String>();
//
//					map<String, Spare_Part_Request__c> spRequestList = new Map<String, Spare_Part_Request__c>();
//
//					for (Order_Operation__c iOP : orderOperationList.values()) {
//						orderOperationMap.put(iOP.OrderOperation__c, iOP.Id);
//					}
//
//					List<Spare_Part_Stock__c> stockList = [
//						SELECT Spare_Part__r.Name, Spare_Part__c, Available_Quantity__c
//						FROM Spare_Part_Stock__c
//						WHERE Plant__c = :plant AND Spare_Part__r.Name IN :sparePartSet
//					];
//					//system.debug('stockList.size()---- '+stockList.size());
//					map<String, Double> stockMap = new Map<String, Double>();
//					for (Spare_Part_Stock__c istock : stockList) {
//						stockMap.put(istock.Spare_Part__c, istock.Available_Quantity__c);
//					}
//
//					for (OrderFromSAP iOrderFromSAP : orderList) {
//						if (iOrderFromSAP.sparePartRequestList != null) {
//							for (SparePartRequestFromSAP iSparePartRequest : iOrderFromSAP.sparePartRequestList) {
//								Spare_Part_Request__c sp = new Spare_Part_Request__c();
//								sp.Order__c = upsertedOrderMap.get(iSparePartRequest.orderNo);
//								String orderOperationKey = iSparePartRequest.orderNo + iSparePartRequest.operationNo;
//								if (orderOperationMap.containskey(orderOperationKey)) {
//									sp.Order_Operation__c = orderOperationMap.get(orderOperationKey);
//								}
//
//								sp.Item_No__c = iSparePartRequest.itemNo;
//
//								if (iSparePartRequest.materialNo != null) {
//									if (sparePartMap.containskey(iSparePartRequest.materialNo)) {
//										sp.Spare_Part__c = sparePartMap.get(iSparePartRequest.materialNo);
//									}
//								}
//
//								sp.Request_Material_Quantity__c = Double.valueOf(iSparePartRequest.quantity); //Decimal.valueOf(iSparePartRequest.quantity);
//								sp.UM__c = iSparePartRequest.unit;
//								sp.IC__c = iSparePartRequest.IC;
//
//								String spStatus = '';
//
//								if (orderUserStatusMap.containskey(iSparePartRequest.orderNo)) {
//									String orderUserStatus = orderUserStatusMap.get(iSparePartRequest.orderNo);
//									if (orderUserStatus != null && orderUserStatus.contains('COMP')) {
//										spStatus = 'Approved';
//									} else if (orderUserStatus != null && orderUserStatus.contains('REJT')) {
//										spStatus = 'Rejected';
//									} else {
//										spStatus = 'Pending for Approval';
//									}
//								}
//
//								sp.Request_Status__c = spStatus;
//								sp.Description__c = iSparePartRequest.description;
//
//								if (masterMap.containsKey(iSparePartRequest.plant)) {
//									sp.Plant__c = masterMap.get(iSparePartRequest.plant).Id;
//								}
//
//								if (sp.Spare_Part__c != null) {
//									if (stockMap.containskey(sp.Spare_Part__c)) {
//										sp.Available_Quantity__c = stockMap.get(sp.Spare_Part__c);
//									}
//								}
//								sp.OrderOrderOperation__c =
//									iSparePartRequest.orderNo +
//									iSparePartRequest.operationNo +
//									iSparePartRequest.itemNo; // + iSparePartRequest.materialNo;
//								sp.isSOAP__c = true;
//								spRequestList.put(sp.OrderOrderOperation__c, sp);
//							}
//						}
//					}
//					if (spRequestList.values().size() > 0) {
//						upsert spRequestList.values() OrderOrderOperation__c;
//					}
//				}
//			}
//		}
//		return orderListSF;
//	}

	private String inputs;
	private String requestURI;
	private Map<String, List<String>> errors;

	public THOR_ReplicatedSAP_Order(String uri, String inputs) {
		this.inputs = inputs;
		this.requestURI = uri;
		this.errors = new Map<String, List<String>>();
	}

	public Iterable<Object> start(Database.BatchableContext BC) {
		Map<String, Object> parsedBody = (Map<String, Object>) System.JSON.deserializeUntyped(inputs);
		return (List<Object>) parsedBody.get('ORDERLIST');
	}

	public void execute(Database.BatchableContext BC, List<Object> scope) {
		try {
			List<Order__c> upsertedFL = saveOrder(scope, errors);

			Application_Log__c applog = new Application_Log__c( External_ID__c = Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_Order', Method__c = 'Upsert', Message_Type__c = 'Success', Request_Body__c = System.JSON.serialize(scope).left(121071), Response_Body__c = '' );

			ApplicationLogUtils.saveLogInbound(requestURI, applog);
		} catch (System.DmlException ex) {
			Application_Log__c applog = new Application_Log__c( External_ID__c = Uuid.randomUUID(), Integration_Name__c = 'THOR_ReplicatedSAP_Order', Method__c = 'Upsert', Message_Type__c = 'Fail', Error_Message__c = ex.getMessage(), Request_Body__c = JSON.serialize(scope).left(121071), Response_Body__c = '' );

			ApplicationLogUtils.saveLogInbound(requestURI, applog);
		}
	}

	public void finish(Database.BatchableContext BC) {
	}
}