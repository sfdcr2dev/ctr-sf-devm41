global class EMOC_NotificationController {
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
        return EMOC_MasterController.getLookupFncLocation(searchParam, 'Notification');
    }
    
    @RemoteAction
    global static List<Map<String, String>> getLookupUser(String searchParam) {
        return EMOC_MasterController.getLookupUser(searchParam);
    }
    
    @RemoteAction
    global static MAP<String,Object> getEmocApplication(MAP<String, String> searchParam) {
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
                ,Common_Workflow__c
                ,Functional_Override__c
               	,Normal__c 
                ,Emergency__c
                ,Notification_Closed_date__c
                FROM E_MOC_Application__c
                WHERE Id = :emocApplicationId limit 1];
        if (emocApplication.Notification__c != null) {
            MAP<String, String> objNoti = new MAP<String, String>();
			objNoti.put('id', emocApplication.Notification__c);
            return getNotification(objNoti);
        } 
        
        Map<String, Object> emocReturn = new Map<String, Object>();
       	Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(emocApplication));
        emocReturn.put('E_MOC_Application_No__c', emocApplicationId);
   
        E_MOC_Application__c emocApplication2 = [SELECT Id ,Name FROM E_MOC_Application__c  WHERE Id = :emocApplicationId limit 1];
        emocReturn.put('Description__c', emocApplication2.Name);
        
        if (emocApplication.Common_Workflow__c == true) {
			emocReturn.put('Notification_Type__c', 'CR');
        } else if (emocApplication.Functional_Override__c == true) {
            emocReturn.put('Notification_Type__c', 'FN');
        }
        
        emocReturn.putAll(obj);

        Id userId = emocApplication.Requestor_Name__c != null ? emocApplication.Requestor_Name__c : UserInfo.getUserId();
        User[] dataUser = [SELECT Id, Username, LastName, FirstName, ORG_ID__c, Employee_Id__c FROM User WHERE Id = :userId  limit 1];
        if (emocApplication.Requestor_Name__c == null) {
            if (dataUser.size() > 0) {
                PISUsers__c[] pisUser = [SELECT Id,EMPLOYEEID__c, HOST_ID__c, HOME_ID__c, INDICATOR__c FROM PISUsers__c WHERE User__c = :dataUser[0].Id AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
                emocReturn.put('Requestor_Name__c', dataUser[0].Id);
                emocReturn.put('Department_Resp__c', dataUser[0].ORG_ID__c);
                emocReturn.put('Requestor_ID__c', dataUser[0].Id);
                emocReturn.put('Employee_Id__c', dataUser[0].Employee_Id__c);
                emocReturn.put('Requester__c', dataUser[0].Id);
                if (pisUser.size() > 0) {
                    emocReturn.put('Indicator__c', pisUser[0].INDICATOR__c);
                    emocReturn.put('Requester_PISUser__c', pisUser[0].Id);
                    emocReturn.put('Requester_PISUser_Text__c', pisUser[0].HOST_ID__c == null ? pisUser[0].HOME_ID__c : pisUser[0].HOST_ID__c);
                    emocReturn.put('Employee_Id__c', dataUser[0].Employee_Id__c == null ? pisUser[0].EMPLOYEEID__c : dataUser[0].Employee_Id__c);
                }
            }
        } else if (dataUser.size() > 0) {
            emocReturn.put('Requester__c', dataUser[0].Id);
            PISUsers__c[] pisUser = [SELECT Id,EMPLOYEEID__c, HOST_ID__c,HOME_ID__c, INDICATOR__c  FROM PISUsers__c WHERE User__c = :dataUser[0].Id AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
            if (pisUser.size() > 0) {
                emocReturn.put('Indicator__c', pisUser[0].INDICATOR__c);
                emocReturn.put('Requester_PISUser__c', pisUser[0].Id);
                emocReturn.put('Requester_PISUser_Text__c', pisUser[0].HOST_ID__c == null ? pisUser[0].HOME_ID__c : pisUser[0].HOST_ID__c);
                emocReturn.put('Employee_Id__c', dataUser[0].Employee_Id__c == null ? pisUser[0].EMPLOYEEID__c : dataUser[0].Employee_Id__c);
            }
        }

        return emocReturn;
    }
    
    @RemoteAction
    global static MAP<String,Object> getNotification(MAP<String, String> searchParam) {
        String notiId = searchParam.get('id');
        Notification__c notiObj = [SELECT Id                 
                ,Functional_Location__c
                ,Main_Work_Center__c
                ,Main_Work_Center_Text__c
                ,Description__c
                ,Requester__c
                ,Requester__r.Employee_Id__c
                ,Department_Resp__c
      			,Integration_Status__c
      			,Integration_Message__c
                ,Order__c
      			,Order__r.Order_Number__c
      			,Notification_Status__c                 
      			,User_Status__c
      			,Priority__c
                ,Requester_PISUser__c
                ,Name
                ,Type__c
                ,E_MOC_Application_No__c
                FROM Notification__c
                WHERE Id = :notiId];
        Map<String, Object> notiReturn = new Map<String, Object>();
        Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(notiObj));
		notiReturn.putAll(obj);
        notiReturn.put('Notification__c', notiId);
        notiReturn.put('Requestor_ID__c', notiObj.Requester__c);
        notiReturn.put('Employee_Id__c', notiObj.Requester__r.Employee_Id__c);
        notiReturn.put('Requestor_Name__c', notiObj.Requester__c);
        notiReturn.put('Notification_Type__c', notiObj.Type__c);   
        notiReturn.put('Order__c', notiObj.Order__r.Order_Number__c); 
        
        PISUsers__c[] pisUser = [SELECT Id, INDICATOR__c FROM PISUsers__c WHERE User__c = :notiObj.Requester__c AND Active__c = true AND MAINPOSITION__c = true LIMIT 1];
        if (pisUser.size() > 0 && notiObj.Requester__c != null) {
           notiReturn.put('Indicator__c', pisUser[0].INDICATOR__c);
        }
        E_MOC_Application__c emocApp = [SELECT Id, Notification__c, Notification_Closed_date__c FROM E_MOC_Application__c WHERE Id = :notiObj.E_MOC_Application_No__c limit 1];
        String NotiCloseDate = emocApp.Notification_Closed_date__c != null ? dateFormatMonddyyyy(String.valueOf(emocApp.Notification_Closed_date__c)) : '';
        notiReturn.put('Notification_Closed_date__c', NotiCloseDate); 
        return notiReturn;
    }
    
    @RemoteAction
    global static Map<String, Object> submitNotification (Id emocId) {
        Map<String, Object> responseStatus = new Map<String, Object>();
        Map<String, Object> dataEmoc = getEmocApplication(new Map<String, String>{'emocApplicationId' => emocId});

        String NotiType = String.valueof(dataEmoc.get('Notification_Type__c'));
        
        dataEmoc.remove('Id');
        dataEmoc.remove('RecordTypeId');
        dataEmoc.remove('Notification_Type__c');
        dataEmoc.remove('Employee_Id__c');
            
        String notificationObj = JSON.serialize(dataEmoc);
        
        Notification__c insertNoti = (Notification__c) JSON.deserialize(notificationObj, Notification__c.class);

        List<Master_Map__c> masterMap = [SELECT Id FROM Master_Map__c where Name =: insertNoti.Main_Work_Center__c];
        insertNoti.Main_Work_Center__c = masterMap.size() > 0 ? masterMap[0].Id : null;
        
        insertNoti.Integration_Status__c = 'In Progress';
        insertNoti.Type__c = NotiType;
   
        System.savepoint sp = Database.setSavepoint();
        try{
            insert insertNoti;
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Save successful!');
            responseStatus.put('Id', insertNoti.Id);
            E_MOC_Application__c emocApplication = new E_MOC_Application__c(
                Id = insertNoti.E_MOC_Application_No__c,
                Notification__c = insertNoti.Id
            );
            update emocApplication;
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage insert Notification__c: '+ex.getMessage());
            responseStatus.put('errorMessage','insert Notification__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        
        return responseStatus;
    }
    
    @RemoteAction
    global static Map<String, Object> putNotification (Map<String, String> paramSave) {
        Map<String, Object> responseStatus = new Map<String, Object>();
		String notificationObj = JSON.serialize(paramSave);
        Notification__c updateNoti = (Notification__c) JSON.deserialize(notificationObj, Notification__c.class);
        updateNoti.System_Status_Text__c = 'NOCO';
        System.savepoint sp = Database.setSavepoint();
        try{
            update updateNoti;
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Update successful!');
            responseStatus.put('Id', updateNoti.Id);
            E_MOC_Application__c emocApplication = new E_MOC_Application__c(
                Id = updateNoti.E_MOC_Application_No__c,
                Notification_Closed_date__c = Date.today()
            );
            update emocApplication;
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage insert Notification__c: '+ex.getMessage());
            responseStatus.put('errorMessage','insert Notification__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        
        return responseStatus;
    }
    
    @RemoteAction
    global static Map<String, Object> deleteNotification (Map<String, String> paramSave) {
        Map<String, Object> responseStatus = new Map<String, Object>();
		String obj = JSON.serialize(paramSave);
        Notification__c deleteNoti = (Notification__c) JSON.deserialize(obj, Notification__c.class);
	
        System.savepoint sp = Database.setSavepoint();
        try{
            delete deleteNoti;
            responseStatus.put('statusSuccess', true);
            responseStatus.put('errorMessage', 'Delete successful!');
            responseStatus.put('Id', deleteNoti.Id);
            E_MOC_Application__c emocApplication = new E_MOC_Application__c(
                Id = deleteNoti.E_MOC_Application_No__c,
                Notification__c = null
            );
            update emocApplication;
        } catch (DmlException ex) {
            responseStatus.put('statusSuccess', false);
            system.debug('errorMessage Delete Notification__c: '+ex.getMessage());
            responseStatus.put('errorMessage','Delete Notification__c: '+ex.getMessage());
            Database.rollback(sp);
        }
        
        return responseStatus;
    }
    public static String dateFormatMonddyyyy(String dateOrder) {
        String[] parts = dateOrder.split(' ');
        return parts[0].substring(8,10)+'/'+parts[0].substring(5,7)+ '/'+parts[0].substring(0,4);
    }
}