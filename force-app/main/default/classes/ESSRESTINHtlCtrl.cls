/**
 * Integration Controller 
 */
@RestResource(urlMapping='/ESSMSS_UpdateHotel/*')

global class ESSRESTINHtlCtrl {

    global class UpdateHotelWrapper{
        String employeeId; /** external id fields */
        String checkOutDate;
        String availableRoom;
         
    }

    global class ResponseWrapper{
        //List<UpdateHotelWrapper> updateHotelResponseWrapperList;
        String messagetype = '';
        String messagetext = '';
    }

    @HttpPost
    global static List<ResponseWrapper> updateHotelPost(List<UpdateHotelWrapper> UpdateHotelWrapperList)
    {
        try {

            /** check to (1)find lastest 'ckeckout date' */
            Map<String, UpdateHotelWrapper> updHtlWrpMap = new Map<String, UpdateHotelWrapper>(); 
            for(UpdateHotelWrapper updateHtl: UpdateHotelWrapperList)
            {
                if(updHtlWrpMap.containsKey(updateHtl.employeeId)){
                    Date codNew = Date.valueOf(updateHtl.checkOutDate);
                    Date codOld = Date.valueOf(updHtlWrpMap.get(updateHtl.employeeId).checkOutDate);

                    if( codNew > codOld ){
                    updHtlWrpMap.put(updateHtl.employeeId,updateHtl);
                    }
                }
                else{
                    updHtlWrpMap.put(updateHtl.employeeId,updateHtl);
                }
            }
            System.debug('updHtlWrpMap = >'+updHtlWrpMap.values());

            /** loop for Master Employee Obj. */
            Map<String, ESS_Master_Employee__c> masterEmpMap = new Map<String, ESS_Master_Employee__c>(); 
            for(UpdateHotelWrapper updateHtl : updHtlWrpMap.values()){
                ESS_Master_Employee__c masterEmp = new ESS_Master_Employee__c();
                masterEmp.ExternalId__c = updateHtl.employeeId;
                masterEmp.Available_Room__c = Decimal.valueOf(updateHtl.availableRoom);
                masterEmpMap.put(masterEmp.ExternalId__c,masterEmp);
            }

            List<Application_Log__c> appLogList = new List<Application_Log__c>();
            List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();
            List<String> dbSCCList = new List<String>();   
            List<String> dbERRList = new List<String>();  
            List<String> errMessage = new List<String>();
            List<String> masterEmpList = new List<String>();
            
            /** Upsert Master Employee Obj. to SF */
            Schema.SObjectField key = ESS_Master_Employee__c.Fields.ExternalId__c;
            Database.UpsertResult [] results = Database.upsert(masterEmpMap.values(), key, false);
            /** check upsert database's result*/
            //for(Database.upsertResult result : results){
            for(Integer index = 0, size = results.size(); index < size; index++) {
                if(results[index].isSuccess()){
                        masterEmpList.add(masterEmpMap.values()[index].ExternalId__c);
                        dbSCCList.add(masterEmpMap.values()[index]  + ' was updated ');
                }
                else {
                    for (Database.Error err : results[index].getErrors()){
                        dbERRList.add(err.getStatusCode() + ' => ID: '+ results[index].getId() + '/ FIELDS:'+err.getFields() + '/ MESSAGE: ' + err.getMessage() );
                        ResponseWrapper response = new ResponseWrapper();
                        response.messagetype = 'Fail';
                        response.messagetext = err.getStatusCode() + '=> '+masterEmpMap.values()[index].ExternalId__c+'/ ID: '+ results[index].getId() + '/ FIELDS:'+err.getFields() + '/ MESSAGE: ' + err.getMessage();
                        responseWrapperList.add(response);
                    }
                }
            }
            /** Application Log */
            if( !dbSCCList.isEmpty() && dbERRList.isEmpty() ){

                //Show Success แค่ก้อนเดียว (ถ้ามี)
                ResponseWrapper response = new ResponseWrapper();
                response.messagetype = 'Success';
                response.messagetext = masterEmpList + ' was updated ';
                responseWrapperList.add(response);
                
                Application_Log__c log = new Application_Log__c();
                log.Method__c = 'Upsert';
                log.Integration_Name__c = 'ESSMSS_UpdateHotel';
                log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                log.Message_Type__c = 'Success';
                String requestBodySubStr = JSON.serialize(UpdateHotelWrapperList);
                log.Request_Body__c = (requestBodySubStr.length() > 131072) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(masterEmpMap);  // String responseBodySubStr = JSON.serialize(dbSCCList);
                log.Response_Body__c = (responseBodySubStr.length() > 131072) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                log.OwnerId = UserInfo.getUserId();
                appLogList.add(log);

            }
            if( !dbERRList.isEmpty()){
                //Show Fail ทุกตัว (ถ้ามี)
                errMessage.addAll(dbERRList);

                Application_Log__c log = new Application_Log__c();
                log.Method__c = 'Upsert';
                log.Integration_Name__c = 'ESSMSS_UpdateHotel';
                log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                log.Message_Type__c = 'Fail';
                String requestBodySubStr = JSON.serialize(UpdateHotelWrapperList);
                log.Request_Body__c = (requestBodySubStr.length() > 131072) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(masterEmpMap); // String responseBodySubStr = JSON.serialize(dbERRList);
                log.Response_Body__c = (responseBodySubStr.length() > 131072) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                String errMessageSubStr = String.join(errMessage, '\n');
                log.Error_Message__c = (errMessageSubStr.length() > 32768) ? errMessageSubStr.substring(0, 32768) : errMessageSubStr;
                log.OwnerId = UserInfo.getUserId();
                appLogList.add(log);
            }

            insert appLogList;
            return responseWrapperList;           
        } catch (Exception e) {
            List<ResponseWrapper> errorList = new List<ResponseWrapper>();
            ResponseWrapper error = new ResponseWrapper();
            error.messagetype = 'ERROR';
            error.messagetext = e.getMessage() + ' line :'+e.getLineNumber();
            errorList.add(error);

            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Update';
            log.Integration_Name__c = 'ESSMSS_UpdateHotel';
            log.Log_Type__c = 'Inbound from SAP - Salesforce generate.';
            log.Response_Body__c = JSON.serialize(error).left(100000);
            log.Message_Type__c = 'Fail';
            log.OwnerId = UserInfo.getUserId();
            insert log;
            return errorList;
        }
    }
}