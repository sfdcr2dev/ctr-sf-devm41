@RestResource(urlMapping='/ESSMSS_EmployeeExportUpdateStatus/*')

global class ESSMSS_REST_EmpExportUpdateStatusCtrl {

    /**
     * ถ้าSAPมีค่า Applicaion_Id ส่งกลับมา >> assign value ให้ ESS Master Employee Obj
     * ถ้าSAPไม่มีค่า Applicaion_Id ส่งกลับมา >> assign value ให้ Retirement Obj
     */
    global class EmployeeExportUpdateStatusWrapper{
        /** Status__c */
        String Status = '';
        /** Completed_Date__c */
        String Completed_Date = '';
        /** ESS_Master_Employee__c : SAP_JSON__c */
        String SAP_JSON = '';
        /** ESS_Master_Employee__c : Id */ 
        String Employee_Id = '';
        /** ESS_Application__c : Id */
        String Applicaion_Id = '';
    }

    global class ResponseWrapper{
        String messagetype = '';
        String messagetext = '';
    }

    @HttpPost
    global static List<ResponseWrapper>  employeeExportUpdateStatusPost(List<EmployeeExportUpdateStatusWrapper> SAPUpdateStatusList){

        try{
            List<ESS_Master_Employee__c> essmasteremployee_list = new List<ESS_Master_Employee__c>();
            List<ESS_Application__c> essapp_list = new List<ESS_Application__c>();
            List<ESS_Retirement__c> retirement_list  = new List<ESS_Retirement__c>();

            /**
             * Process of Retirement Object
             * Assign and Update/Upsert value from SAP to SF
             * (Loop Employee_ID__c from ESS_Employee__c to query ESS_Retirement__c)
             */
            Map<String, EmployeeExportUpdateStatusWrapper> empWrapperMap = new Map<String, EmployeeExportUpdateStatusWrapper>(); 
            List<String>  empWrapperList = new List<String>();
            for(EmployeeExportUpdateStatusWrapper each_SAPUpdateStatus: SAPUpdateStatusList)
            {
                empWrapperList.add(each_SAPUpdateStatus.Employee_Id);
                if(each_SAPUpdateStatus.Applicaion_Id == null || each_SAPUpdateStatus.Applicaion_Id == '' ){
                    empWrapperMap.put(each_SAPUpdateStatus.Employee_ID,each_SAPUpdateStatus); 
                }
            }

            List<ESS_Retirement__c> rtmIdList = [SELECT Id, Employee_ID__c, Retirement_Date__c,Submitted_Date__c,Sending_To_SAP_Date__c,Status__c, Completed_Date__c,SAP_JSON__c FROM ESS_Retirement__c WHERE Employee_ID__c IN :empWrapperList];
            Map<Id, ESS_Retirement__c> retirementMap = new Map<Id, ESS_Retirement__c>(rtmIdList);

            for (ESS_Retirement__c eachrtm : rtmIdList) {
                ESS_Retirement__c retirement = new ESS_Retirement__c();
                if(empWrapperMap.containsKey(eachrtm.Employee_ID__c)){
                    retirement.Employee_Id__c = empWrapperMap.get(eachrtm.Employee_ID__c).Employee_Id;
                    retirement.Id = eachrtm.Id;
                    retirement.Status__c =  (  (empWrapperMap.get(eachrtm.Employee_ID__c).Status != null) && (empWrapperMap.get(eachrtm.Employee_ID__c).Status != '') ) ? empWrapperMap.get(eachrtm.Employee_ID__c).Status : null;
                    retirement.Completed_Date__c = ( (empWrapperMap.get(eachrtm.Employee_ID__c).Completed_Date != null) && (empWrapperMap.get(eachrtm.Employee_ID__c).Completed_Date != '') ) ? Date.valueOf(empWrapperMap.get(eachrtm.Employee_ID__c).Completed_Date) : null;
                    retirement.SAP_JSON__c = ( (empWrapperMap.get(eachrtm.Employee_ID__c).SAP_JSON != null) && (empWrapperMap.get(eachrtm.Employee_ID__c).SAP_JSON != '') ) ? empWrapperMap.get(eachrtm.Employee_ID__c).SAP_JSON : null;    
                    retirement_list.add(retirement);
                }
            }
            
            /**
             * Process of ESS_Master_Employee__c Object & ESS_Application__c Object
             * Assign and Update/Upsert value from SAP to SF
             */
            for(EmployeeExportUpdateStatusWrapper each_SAPUpdateStatus: SAPUpdateStatusList){
                ESS_Master_Employee__c essMasterEmployee = new ESS_Master_Employee__c();
                ESS_Application__c essApplication = new ESS_Application__c();
                ESS_Retirement__c retirement = new ESS_Retirement__c();
                
                if(each_SAPUpdateStatus.Applicaion_Id != null && each_SAPUpdateStatus.Applicaion_Id != '' ){
                    String concatId = each_SAPUpdateStatus.Employee_Id + each_SAPUpdateStatus.Applicaion_Id;
                    /** Status__c */
                    essMasterEmployee.Status__c = ((each_SAPUpdateStatus.Status != null && each_SAPUpdateStatus.Status != '') && each_SAPUpdateStatus.Applicaion_Id != null) ? each_SAPUpdateStatus.Status : null;
                    essApplication.Status__c = ((each_SAPUpdateStatus.Status != null && each_SAPUpdateStatus.Status != '') && each_SAPUpdateStatus.Applicaion_Id != null) ? each_SAPUpdateStatus.Status : null;
                    /** Completed_Date__c */
                    essMasterEmployee.Completed_Date__c = (each_SAPUpdateStatus.Completed_Date != null && each_SAPUpdateStatus.Completed_Date != '') ? Date.valueOf(each_SAPUpdateStatus.Completed_Date) : null;
                    essApplication.Completed_Date__c = (each_SAPUpdateStatus.Completed_Date != null && each_SAPUpdateStatus.Completed_Date != '') ? Date.valueOf(each_SAPUpdateStatus.Completed_Date) : null;
                    /** SAP_JSON__c */
                    essMasterEmployee.SAP_JSON__c = (each_SAPUpdateStatus.SAP_JSON != null && each_SAPUpdateStatus.SAP_JSON != '') ? each_SAPUpdateStatus.SAP_JSON : null;
                    essApplication.SAP_JSON__c = (each_SAPUpdateStatus.SAP_JSON != null && each_SAPUpdateStatus.SAP_JSON != '') ? each_SAPUpdateStatus.SAP_JSON : null;
                    /** KEY */
                    essMasterEmployee.ExternalId__c = concatId;
                    essApplication.Id = each_SAPUpdateStatus.Applicaion_Id;
                    essmasteremployee_list.add(essMasterEmployee);
                    essapp_list.add(essApplication);
                }
            }

            List<Application_Log__c> appLogList = new List<Application_Log__c>();
            List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();

            /**ESS_Master_Employee__c : Upsert */
            Schema.SObjectField essMasterEmp_key = ESS_Master_Employee__c.Fields.ExternalId__c;
            Database.UpsertResult [] essMasterEmp_cr = Database.upsert(essmasteremployee_list, essMasterEmp_key, false);
            //Map<Id, ESS_Master_Employee__c> essmasterEmployeeMap = new Map<Id, ESS_Master_Employee__c>(essmasteremployee_list);
            List<String> empSuccessResultList = new List<String>();   
            List<String> empFailResultList = new List<String>(); 
            List<String> empErrorMessage = new List<String>();
            
            for(Database.upsertResult result : essMasterEmp_cr){
                if(result.isSuccess()){
                    /*
                    if(result.isCreated()){
                        empSuccessResultList.add(essmasterEmployeeMap.get(result.getId()).Status__c + ' was created (ESSEmpolyee)');
                    } else {
                        empSuccessResultList.add(essmasterEmployeeMap.get(result.getId()).Status__c + ' was updated (ESSEmpolyee)');
                    }*/
                    empSuccessResultList.add('success');
                }
                else
                {
                    for (Database.Error err : result.getErrors()){
                        empFailResultList.add('ERROR > '+ err.getStatusCode() + ' - ID : '+ result.getId() + ' - FIELDS :'+err.getFields() + ' - ERRMESSAGE : ' + err.getMessage() );
                    }
                    
                }
            }
            if( !empSuccessResultList.isEmpty()){
                Application_Log__c empSuccesLog = new Application_Log__c();
                empSuccesLog.Method__c = 'Upsert';
                empSuccesLog.Integration_Name__c = 'ESSMSS_REST_EmpExportUpdateStatus_MasterEmployee';
                empSuccesLog.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                empSuccesLog.Message_Type__c = 'Success';
                String requestBodySubStr = JSON.serialize(SAPUpdateStatusList);
                empSuccesLog.Request_Body__c = (requestBodySubStr.length() > 131072) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(essmasteremployee_list);
                empSuccesLog.Response_Body__c = (responseBodySubStr.length() > 131072) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                empSuccesLog.OwnerId = UserInfo.getUserId();
                appLogList.add(empSuccesLog);

                ResponseWrapper response = new ResponseWrapper();
                response.messagetype = 'SUCCESS';
                response.messagetext = 'ESSMSS_REST_EmpExportUpdateStatus_MasterEmployee Upsert Success ';

                responseWrapperList.add(response);
            }
            
            if( !empFailResultList.isEmpty()){
                empErrorMessage.addAll(empFailResultList);
                Application_Log__c empSuccessAndFailLog = new Application_Log__c();
                empSuccessAndFailLog.Method__c = 'Update';
                empSuccessAndFailLog.Integration_Name__c = 'ESSMSS_REST_EmpExportUpdateStatus_Employee';
                empSuccessAndFailLog.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                empSuccessAndFailLog.Message_Type__c = 'Fail';
                String requestBodySubStr = JSON.serialize(SAPUpdateStatusList);
                empSuccessAndFailLog.Request_Body__c = (requestBodySubStr.length() > 131072) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(essapp_list);
                empSuccessAndFailLog.Response_Body__c = (responseBodySubStr.length() > 131072) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                String errorMessageSubStr = String.join(empErrorMessage, '\n');
                empSuccessAndFailLog.Error_Message__c = (errorMessageSubStr.length() > 32768) ? errorMessageSubStr.substring(0, 32768) : errorMessageSubStr;
                empSuccessAndFailLog.OwnerId = UserInfo.getUserId();
                appLogList.add(empSuccessAndFailLog);

                ResponseWrapper response = new ResponseWrapper();
                response.messagetype = 'FAIL';
                response.messagetext = 'ESSMSS_REST_EmpExportUpdateStatus_Employee Update Fail';
                responseWrapperList.add(response);
            }

            /**ESS_Application__c : Update */
            Schema.SObjectField essApplication_key = ESS_Application__c.Fields.Id;
            Database.SaveResult [] essApplication_cr = Database.update(essapp_list,false);
            // Map<Id, ESS_Application__c> essApplicationMap = new Map<Id, ESS_Application__c>(essapp_list);
            List<String> appSuccessResultList = new List<String>();
            List<String> appFailResultList = new List<String>();  
            List<String> appErrorMessage = new List<String>();
            for(Database.SaveResult result : essApplication_cr){
                if(result.isSuccess()){
                    // appSuccessResultList.add(essApplicationMap.get(result.getId())+ ' was updated (ESSApplication)');
                    appSuccessResultList.add('success');
                } else {
                    for (Database.Error err : result.getErrors()){
                        appFailResultList.add('ERROR > '+ err.getStatusCode() + ' - ID : '+ result.getId() + ' - FIELDS :'+err.getFields() + ' - ERRMESSAGE : ' + err.getMessage() );
                    }
                }
            }
            if( !appSuccessResultList.isEmpty() ){
                Application_Log__c appSuccesLog = new Application_Log__c();
                appSuccesLog.Method__c = 'Update';
                appSuccesLog.Integration_Name__c = 'ESSMSS_REST_EmpExportUpdateStatus_Application';
                appSuccesLog.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                appSuccesLog.Message_Type__c = 'Success';
                String requestBodySubStr = JSON.serialize(SAPUpdateStatusList);
                appSuccesLog.Request_Body__c = (requestBodySubStr.length() > 131072) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(essapp_list);
                appSuccesLog.Response_Body__c = (responseBodySubStr.length() > 131072) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                appSuccesLog.OwnerId = UserInfo.getUserId();
                appLogList.add(appSuccesLog);

                ResponseWrapper response = new ResponseWrapper();
                response.messagetype = 'SUCCESS';
                response.messagetext = 'ESSMSS_REST_EmpExportUpdateStatus_Application Update Success';
                responseWrapperList.add(response); 
            }
            if( !appFailResultList.isEmpty() ){
                appErrorMessage.addAll(appFailResultList);
                Application_Log__c appFailLog = new Application_Log__c();
                appFailLog.Method__c = 'Update';
                appFailLog.Integration_Name__c = 'ESSMSS_REST_EmpExportUpdateStatus_Application';
                appFailLog.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                appFailLog.Message_Type__c = 'Fail';
                String requestBodySubStr = JSON.serialize(SAPUpdateStatusList);
                appFailLog.Request_Body__c = (requestBodySubStr.length() > 131072) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(essapp_list);
                appFailLog.Response_Body__c = (responseBodySubStr.length() > 131072) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                String errorMessageSubStr = String.join(appErrorMessage, '\n');
                appFailLog.Error_Message__c = (errorMessageSubStr.length() > 32768) ? errorMessageSubStr.substring(0, 32768) : errorMessageSubStr;
                appFailLog.OwnerId = UserInfo.getUserId();
                appLogList.add(appFailLog);

                ResponseWrapper response = new ResponseWrapper();
                response.messagetype = 'FAIL';
                response.messagetext = 'ESSMSS_REST_EmpExportUpdateStatus_Application Update Fail All';

                responseWrapperList.add(response);
            }

            /** ESS_Retirement__c : Update */
            Schema.SObjectField retirement_key = ESS_Retirement__c.Fields.Id;
            Database.SaveResult [] retirement_cr = Database.update(retirement_list, false);
            // Map<Id, ESS_Retirement__c> rtmMap = new Map<Id, ESS_Retirement__c>(retirement_list);
            List<String> successResultList = new List<String>();
            List<String> failResultList = new List<String>();  
            List<String> errorMessage = new List<String>();
            for(Database.SaveResult result : retirement_cr){
                if(result.isSuccess()){
                    // successResultList.add(rtmMap.get(result.getId())+ ' was updated (Retirement)');
                    successResultList.add('success');
                } else {
                    for (Database.Error err : result.getErrors()){
                        failResultList.add('ERROR > '+ err.getStatusCode() + ' - ID : '+ result.getId() + ' - FIELDS :'+err.getFields() + ' - ERRMESSAGE : ' + err.getMessage() );
                    }
                }
            }
            if( !successResultList.isEmpty() ){
                Application_Log__c appSuccesLog = new Application_Log__c();
                appSuccesLog.Method__c = 'Update';
                appSuccesLog.Integration_Name__c = 'ESSMSS_REST_EmpExportUpdateStatus_Retirement';
                appSuccesLog.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                appSuccesLog.Message_Type__c = 'Success';
                String requestBodySubStr = JSON.serialize(SAPUpdateStatusList);
                appSuccesLog.Request_Body__c = (requestBodySubStr.length() > 131072) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(retirement_list);
                appSuccesLog.Response_Body__c = (responseBodySubStr.length() > 131072) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                appSuccesLog.OwnerId = UserInfo.getUserId();
                appLogList.add(appSuccesLog);

                ResponseWrapper response = new ResponseWrapper();
                response.messagetype = 'SUCCESS';
                response.messagetext = 'ESSMSS_REST_EmpExportUpdateStatus_Retirement Update Success';
                responseWrapperList.add(response);
            }
            if( !failResultList.isEmpty() ){
                errorMessage.addAll(failResultList);
                Application_Log__c appFailLog = new Application_Log__c();
                appFailLog.Method__c = 'Update';
                appFailLog.Integration_Name__c = 'ESSMSS_REST_EmpExportUpdateStatus_Retirement';
                appFailLog.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                appFailLog.Message_Type__c = 'Fail';
                String requestBodySubStr = JSON.serialize(SAPUpdateStatusList);
                appFailLog.Request_Body__c = (requestBodySubStr.length() > 131072) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(retirement_list);
                appFailLog.Response_Body__c = (responseBodySubStr.length() > 131072) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                String errorMessageSubStr = String.join(errorMessage, '\n');
                appFailLog.Error_Message__c = (errorMessageSubStr.length() > 32768) ? errorMessageSubStr.substring(0, 32768) : errorMessageSubStr;
                appFailLog.OwnerId = UserInfo.getUserId();
                appLogList.add(appFailLog);

                ResponseWrapper response = new ResponseWrapper();
                response.messagetype = 'FAIL';
                response.messagetext = 'ESSMSS_REST_EmpExportUpdateStatus_Retirement Update Fail All';
                responseWrapperList.add(response);
            }

            insert appLogList;
            //responseWrapperList.add(success);
            return responseWrapperList ;

        }catch (Exception e) {
            List<ResponseWrapper> errorList = new List<ResponseWrapper>();
            ResponseWrapper error = new ResponseWrapper();
            error.messagetype = 'ERROR';
            error.messagetext = e.getMessage() + ' line :'+e.getLineNumber();
            errorList.add(error);
                       
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Return';
            log.Integration_Name__c = 'ESSMSS_REST_EmpExportUpdateStatus';
            log.Log_Type__c = 'Inbound from SAP - Salesforce generate.';
            log.Request_Body__c =  JSON.serialize(SAPUpdateStatusList);
            log.Response_Body__c = JSON.serialize(error);
            log.Message_Type__c = 'Fail';
            log.OwnerId = UserInfo.getUserId();
            insert log;
            
            return errorList;
        }
    }
}