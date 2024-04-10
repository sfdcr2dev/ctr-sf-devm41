global class EMOC_OrderController {
	@RemoteAction
    global static List<Map<String, String>> getLookupMasterMap(String searchParam) {
        return EMOC_MasterController.getLookupMasterMap(searchParam);
    }
    @RemoteAction
    global static List<Map<String, String>> getLookupPMActivity(String searchParam) {
        return EMOC_MasterController.getLookupPMActivity(searchParam);
    }
    @RemoteAction
    global static List<Map<String, String>> getLookupFncLocation(String searchParam) {
        return EMOC_MasterController.getLookupFncLocation(searchParam, 'Order');
    }
    @RemoteAction
    global static List<Map<String, String>> getLookupUser(String searchParam) {
       	return EMOC_MasterController.getLookupUser(searchParam);
    }
    @RemoteAction
    global static List<Map<String, String>> getLookupMainWorkCenterPlan(String searchParam) {
        return EMOC_MasterController.getLookupMainWorkCenterPlan(searchParam);
    }
    @RemoteAction
    global static MAP<String,Object> getOrder(MAP<String, String> searchParam) {
        String emocApplicationId = searchParam.get('emocApplicationId');
        E_MOC_Application__c emocApplication = [SELECT Id                 
                ,Functional_Location__c
                ,Functional_Location_Description__c
                ,Plant_of_Main_Work_Center__c
                ,Main_Work_Center__c
                ,Requestor_ID__c
                ,Requestor_Name__c
                ,Department_Resp__c   
                ,Notification__c
                ,Notification__r.Name
               	,wbs_element__c
                ,Name
                FROM E_MOC_Application__c
                WHERE Id = :emocApplicationId];
        Map<String, Object> emocReturn = new Map<String, Object>();
       	Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(emocApplication));
        emocReturn.put('E_MOC_Application_No__c', emocApplication.Name);
        emocReturn.put('E_MOC_Application_No__c_id', emocApplicationId);
        emocReturn.put('Notification__c', emocApplication.Notification__r.Name);    
        emocReturn.put('Notification__c_id', emocApplication.Notification__c);    
        emocReturn.put('Start_Date__c', dateFormatMonddyyyy(String.valueOf(date.today())));
        emocReturn.put('Description__c', emocApplication.Name);
        Master_Map__c[] masterM = [SELECT Id,Name FROM Master_Map__c where Name = 'M01']; 
        if (masterM.size() > 0) {
            emocReturn.put('PM_Activity_Type__c', masterM[0].Id); // Default M01
        }
        
        PISUsers__c[] pisUserRequestor = [SELECT Id, EMPLOYEEID__c, HOST_ID__c, HOME_ID__c FROM PISUsers__c WHERE User__c = :emocApplication.Requestor_Name__c AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
        if (pisUserRequestor.size() > 0) {
		    emocReturn.put('Responsible_person_PISUser__c', pisUserRequestor[0].Id); 
            emocReturn.put('ResponsiblePerson_PISUser_Text__c', pisUserRequestor[0].EMPLOYEEID__c); 
            emocReturn.put('Requester_PISUser__c', pisUserRequestor[0].Id); 
            emocReturn.put('Requester_PISUser_Text__c', pisUserRequestor[0].EMPLOYEEID__c);
        }
        emocReturn.putAll(obj);
        if (emocApplication.Main_Work_Center__c != null) {
            String paramLike = '%' + emocApplication.Main_Work_Center__c + '%';
        	List<Master_Map__c> masterMap = [SELECT Id FROM Master_Map__c WHERE Type__c = 'Main Work Center' AND (Name LIKE :paramLike) limit 1]; //  OR Id = :emocApplication.Main_Work_Center__c
            if (masterMap.size() > 0) {
        		emocReturn.put('Main_Work_Center__c',  masterMap[0].Id);
            }
        }
        if (emocApplication.Plant_of_Main_Work_Center__c != null) {
            String paramLike = '%' + emocApplication.Plant_of_Main_Work_Center__c + '%';            
        	List<Master_Map__c> masterMap = [SELECT Id FROM Master_Map__c WHERE Type__c = 'Plant' AND (Name LIKE :paramLike) limit 1]; // OR Id = :emocApplication.Plant_of_Main_Work_Center__c
            if (masterMap.size() > 0) {
        		emocReturn.put('mainWorkCenterPlant__c',  masterMap[0].Id);
            }
        }
        
        Id userId = UserInfo.getUserId();
        User dataUser = [SELECT Id, Username, LastName, FirstName, ORG_ID__c, Employee_Id__c FROM User WHERE Id = :userId];
        emocReturn.put('Responsible_Person_Name__c', '');
        emocReturn.put('Responsible_Person_ID__c', dataUser.Employee_Id__c);
        if (emocApplication.Functional_Location__c != null) {
        	Functional_Location__c fl = [SELECT Planning_Plant__c FROM Functional_Location__c WHERE Id = :emocApplication.Functional_Location__c];
        	emocReturn.put('Planning_Plant__c', fl.Planning_Plant__c);
        }
		emocReturn.put('WBS__c', emocApplication.wbs_element__c);
        emocReturn.remove('Id');
        emocReturn.remove('Name');
        emocReturn.remove('Plant_of_Main_Work_Center__c');
        Map<String, Object> dataReturn = new Map<String, Object>();
        dataReturn.put('order', emocReturn);

        return dataReturn;
    }
    
    @RemoteAction
    global static MAP<String,Object> getOrderDetail(MAP<String, String> searchParam) {
        String orderId = searchParam.get('orderId');
        Id myId = searchParam.get('orderId');

        Schema.SObjectType sobjectType = myId.getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();

        if (sobjectName == 'E_MOC_Application__c') {
            Order__c paramOrder = [SELECT Id FROM Order__c WHERE E_MOC_Application_No__c = :myId LIMIT 1];
            orderId = paramOrder.Id;
        }

        Order__c order = [SELECT Id,Super_Order_Text__c
                            ,Sub_Order_Number__c
                            ,Order_Type__c
                            ,Functional_Location__c
                            ,Functional_Location_Description__c
                            ,mainWorkCenterPlant__c
                            ,Main_Work_Center__c
                          	,Main_Work_Center_Text__c
                            ,PM_Activity_Type__c
                            ,Requestor__c
                            ,Start_Date__c
                            ,Finished_Date__c
                            ,Responsible_Person_Name__c
                            ,Responsible_Person_ID__c
                          	,Notification__c
                            ,Notification__r.Name
                          	,Order_Status__c
                          	,Integration_Status__c
                          	,Integration_Message__c
                          	,Order_Number__c
                          	,E_MOC_Application_No__c
                          	,E_MOC_Application_No__r.Name
                          	,Name
                          	,wbs_element__c
                          	,Responsible_person_PISUser__c
                            ,Request_Close__c
                          FROM Order__c WHERE Id = :orderId];
        
       	Map<String, Object> orderReturn = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(order));
        String startDate = order.Start_date__c != null ? dateFormatMonddyyyy(String.valueOf(order.Start_date__c)) : '';
        orderReturn.put('Start_Date__c', startDate);
        String finishDate = order.Finished_Date__c != null ? dateFormatMonddyyyy(String.valueOf(order.Finished_Date__c)) : '';
        orderReturn.put('Finished_Date__c', finishDate);
        orderReturn.put('Notification__c', order.Notification__r.Name);        
        orderReturn.put('E_MOC_Application_No__c', order.E_MOC_Application_No__r.Name != null ? order.E_MOC_Application_No__r.Name : '');
        orderReturn.put('WBS__c', order.wbs_element__c);
        if (order.Requestor__c != '' && order.Requestor__c != null) {
            User dataUser1 = [SELECT Id, Username, LastName, FirstName, ORG_ID__c, Employee_Id__c FROM User WHERE Employee_Id__c = :order.Requestor__c Limit 1];
        	orderReturn.put('Requestor_Name__c', dataUser1.Id); 
        }
        List<Order__c> orderList = [SELECT Id,
                                        Name,
                                        Order_Status__c,
                                        Order_Type__c,
                                        Description__c
                                        FROM Order__c 
                                    	WHERE Super_Order__c = :orderId order by Name];

        List<Map<String, String>> orderListMsp = new List<Map<String, String>>();
        for(Order__c obj: orderList) {
            Map<String, String> objList = new Map<String, String>();
            objList.put('Id',obj.Id);
            objList.put('Name',obj.Name != null ? obj.Name : '');
			objList.put('Order_Status__c',obj.Order_Status__c != null ? obj.Order_Status__c : '');
            objList.put('Order_Type__c',obj.Order_Type__c != null ? obj.Order_Type__c : '');
            objList.put('Description__c',obj.Description__c != null ? obj.Description__c : '');
            orderReturn.put('disableBtnClose', (obj.Order_Status__c != null && obj.Order_Status__c != 'Closed') ? true : false); 
            orderListMsp.add(objList);
        }
        
        Map<String, Object> dataReturn = new Map<String, Object>();
        dataReturn.put('order', orderReturn);
        dataReturn.put('orderList', orderListMsp);
        
        return dataReturn;
    }
 
    @RemoteAction
    global static Map<String, Object> postOrder (String paramSave) {
        Map<String, Object> responseStatus = new Map<String, Object>();
        Map<String, Object> paramSaveMap = (Map<String, Object>) JSON.deserializeUntyped(paramSave);
        Map<String, Object> paramRenew = (Map<String, Object>) paramSaveMap.get('order');
        String orderObj = JSON.serialize(paramRenew); 

        Order__c insertOrder = (Order__c) JSON.deserialize(orderObj, Order__c.class);
        insertOrder.E_MOC_Application_No__c = String.valueof(paramRenew.get('E_MOC_Application_No__c_id'));
        insertOrder.Notification__c = String.valueof(paramRenew.get('Notification__c_id'));

        System.savepoint sp = Database.setSavepoint();
        try{
            insert insertOrder;
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Save successful!');
            responseStatus.put('Id', insertOrder.Id);
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage insert Order__c: '+ex.getMessage());
            responseStatus.put('errorMessage','insert Order__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        return responseStatus;
    }
    
    @RemoteAction
    global static Map<String, Object> putOrder (Map<String, String> paramSave) {
        Map<String, Object> responseStatus = new Map<String, Object>();
		String obj = JSON.serialize(paramSave);
        Order__c updateOrder = (Order__c) JSON.deserialize(obj, Order__c.class);
        System.savepoint sp = Database.setSavepoint();
        try{
            update updateOrder;
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Update successful!');
            responseStatus.put('Id', updateOrder.Id);
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage update Order__c: '+ex.getMessage());
            responseStatus.put('errorMessage','Update Order__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        
        return responseStatus;
    }
    
    @RemoteAction
    global static Map<String, Object> deleteOrder (Map<String, String> paramSave) {
        Map<String, Object> responseStatus = new Map<String, Object>();
		String obj = JSON.serialize(paramSave);
        Order__c deleteOrder = (Order__c) JSON.deserialize(obj, Order__c.class);
        System.savepoint sp = Database.setSavepoint();
        try{
            delete deleteOrder;
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Delete successful!');
            responseStatus.put('Id', deleteOrder.Id);
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage Delete Order__c: '+ex.getMessage());
            responseStatus.put('errorMessage','Delete Order__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        
        return responseStatus;
    }
    
    public static String dateFormatMonddyyyy(String dateOrder) {
        String[] parts = dateOrder.split(' ');
        return parts[0].substring(8,10)+'/'+parts[0].substring(5,7)+ '/'+parts[0].substring(0,4);
    }

	private static Boolean closeOrderHelper(Order__c order) {
		Boolean closed = false;
		try {
			order.Close_Date__c = Date.today();
			order.Request_Close__c = true;
			order.Integration_Status__c = 'In Progress';

			if (Schema.sObjectType.Order__c.isUpdateable()) {
				update order;
				closed = true;
			}
		} catch (Exception ex) {
			throw new AuraHandledException('Something went wrong...');
		}

		return closed;
	}
	@AuraEnabled @RemoteAction
    global static CloseOrderStatus getCloseOrderStatus (Map<String, String> paramSave) {
		Map<String, Object> responseStatus = new Map<String, Object>();
 		String orderId = paramSave.get('Id');

		CloseOrderStatus closeOrderStatus = null;
		Boolean disableButton = true;
		Boolean canClose = true;
		Boolean statusSuccess = true;
        
		Order__c order = [
			SELECT
				Id,
				Name,
				(SELECT Id, Name, System_Status_Text__c FROM Orders__r),
				(SELECT Id, Name, Fault_Code__c FROM Notifications__r),
				(SELECT Id, Name FROM Spare_Part_Requests__r),
				(SELECT Id, Name FROM Work_Clearances__r),
				Work_Clearance__c,
				System_Status_Text__c
			FROM Order__c
			WHERE Id = :orderId
			WITH SECURITY_ENFORCED
		];

		if (
			order.Orders__r.size() > 0 ||
			order.Notifications__r.size() > 0 ||
			order.Spare_Part_Requests__r.size() > 0
		) {

			if (order.Work_Clearances__r.size() > 0) {
				if (order.System_Status_Text__c == null || !order.System_Status_Text__c.contains('WOCO')) {
					closeOrderStatus = new closeOrderStatus(!disableButton,!canClose,'Order status does not contain WOCO', true, 'Order status does not contain WOCO',order.Id);
				}
			}

			if (closeOrderStatus == null) {
				closeOrderStatus = checkSubOrders(order, disableButton, canClose);
			}
		}

		if (closeOrderStatus == null) {
			closeOrderHelper(order);
			closeOrderStatus = new closeOrderStatus(disableButton, canClose, 'The order was closed', true, 'The order was closed', order.Id);
		}
	
		 return closeOrderStatus;
        
	}
    global class CloseOrderStatus {
		CloseOrderStatus(boolean disableButton, boolean canClose, String message, boolean statusSuccess, String errorMessage, String Id) {
			this.disableButton = disableButton;
			this.canClose = canClose;
			this.message = message;
            this.statusSuccess = statusSuccess;
            this.errorMessage = errorMessage;
            this.Id = Id;
		}

		@AuraEnabled
		public boolean disableButton { get; set; }

		@AuraEnabled
		public boolean canClose { get; set; }

		@AuraEnabled
		public String message { get; set; }
        
        @AuraEnabled
		public boolean statusSuccess { get; set; }
        @AuraEnabled
		public String errorMessage { get; set; }
        @AuraEnabled
		public String Id { get; set; }
	}

	private static CloseOrderStatus checkSubOrders(Order__c order, Boolean disableButton, Boolean canClose) {
		CloseOrderStatus closeOrderStatus = null;
		for (Order__c o : order.Orders__r) {
			if (o.System_Status_Text__c == null || !o.System_Status_Text__c.contains('TECO')) {
				closeOrderStatus = new closeOrderStatus(!disableButton,!canClose,'At least one suborder has not status TECO',true,'At least one suborder has not status TECO',o.Id);
				break;
			}
		}
		return closeOrderStatus;
	}
    
    public static void EMOC_OrderAfterTrigger(Map<Id, sObject> newOrders, Map<Id, sObject> oldOrders) {
        List<E_MOC_Application__c> recordsToUpdate = new List<E_MOC_Application__c>();
        for (Order__c newOrder : (List<Order__c>) newOrders.values()) {
            if (newOrder.Integration_Status__c != 'Failed' && newOrder.Integration_Status__c != null && newOrder.E_MOC_Application_No__c != null) {
                E_MOC_Application__c emoc = new E_MOC_Application__c();
                emoc.Id = newOrder.E_MOC_Application_No__c;
                emoc.Order_Trigger__c = true;                
				recordsToUpdate.add(emoc);
			}
        }
        update recordsToUpdate;
    }
}