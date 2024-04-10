/**
 * ESS_Hotel_SAP__c Obj.
 * Conditon: SAP_Status__c = SendingToSap OR F
 */
@RestResource(urlMapping='/ESSMSS_UpdateStatusHotel/*')

global class ESSRESTINUpStHtlCtrl {

    global class UpdateStatusHotelWrapper{
        String status ;     // Status__c
        String sapMessage;  // SAP_Message__c
        String externalId;  // ID Salesforce Generated 
    }

    global class ResponseWrapper{
        String messagetype = '';
        String messagetext = '';
    }

    @HttpPost
    global static List<ResponseWrapper>  updateStatusHotelPost(List<UpdateStatusHotelWrapper> UpdateStatusHotelWrapperList) {

        try {
            /** assign to fields in ESS_Hotel_SAP__c Obj. */
            Map<String, ESS_Hotel_SAP__c> htlSapMap = new Map<String, ESS_Hotel_SAP__c>(); 
            for(UpdateStatusHotelWrapper upStsHtl : UpdateStatusHotelWrapperList){
                ESS_Hotel_SAP__c htlSap = new ESS_Hotel_SAP__c();
                htlSap.Id = upStsHtl.externalId;
                htlSap.Status__c = ( (upStsHtl.status != null) && (upStsHtl.status != '') ) ? upStsHtl.status : null;
                htlSap.SAP_Message__c = ( (upStsHtl.sapMessage != null) && (upStsHtl.sapMessage != '') ) ? upStsHtl.sapMessage : null;
                htlSapMap.put(htlSap.Id,htlSap);
            }

            List<Application_Log__c> appLogList = new List<Application_Log__c>();
            List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();
            List<String> dbSCCList = new List<String>();   
            List<String> dbERRList = new List<String>();  
            List<String> errMessage = new List<String>();
            
            /** Upsert ESS_Hotel_SAP__c Obj. to SF */
            // Schema.SObjectField key = ESS_Hotel_SAP__c.Fields.ExternalId__c;
            // Database.UpsertResult [] results = Database.upsert(htlSapMap.values(), key, false);
            Database.SaveResult [] results = Database.update(htlSapMap.values(),false);
            /** check upsert database's result*/
            for(Integer index = 0, size = results.size(); index < size; index++) {
                if(results[index].isSuccess()){
                        dbSCCList.add(results[index].getId());
                }
                else {
                    for (Database.Error err : results[index].getErrors()){
                        // htlSapMap.values()[index].Id (equal) results[index].getId()
                        dbERRList.add(htlSapMap.values()[index].Id);
                        ResponseWrapper response = new ResponseWrapper();
                        response.messagetype = 'Fail';
                        response.messagetext = err.getStatusCode() + '=> ID: '+ results[index].getId() + '/ FIELDS:'+err.getFields() + '/ MESSAGE: ' + err.getMessage();
                        responseWrapperList.add(response);
                    }
                }
            }
            /** Application Log */
            if( !dbSCCList.isEmpty() && dbERRList.isEmpty()){

                ResponseWrapper response = new ResponseWrapper();
                response.messagetype = 'Success';
                response.messagetext = dbSCCList + ' was updated ';
                responseWrapperList.add(response);

                Application_Log__c log = new Application_Log__c();
                log.Method__c = 'Upsert';
                log.Integration_Name__c = 'ESSMSS_UpdateStatusHotel';
                log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                log.Message_Type__c = 'Success';
                String requestBodySubStr = JSON.serialize(UpdateStatusHotelWrapperList);
                log.Request_Body__c = (requestBodySubStr.length() > 131072) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(htlSapMap);  // String responseBodySubStr = JSON.serialize(dbSCCList);
                log.Response_Body__c = (responseBodySubStr.length() > 131072) ? responseBodySubStr.substring(0, 100000) : responseBodySubStr;
                log.OwnerId = UserInfo.getUserId();
                appLogList.add(log);

            }
            if( !dbERRList.isEmpty()){

                errMessage.addAll(dbERRList);

                Application_Log__c log = new Application_Log__c();
                log.Method__c = 'Upsert';
                log.Integration_Name__c = 'ESSMSS_UpdateStatusHotel';
                log.Log_Type__c = 'Inbound from SAP & Return to SAP.';
                log.Message_Type__c = 'Fail';
                String requestBodySubStr = JSON.serialize(UpdateStatusHotelWrapperList);
                log.Request_Body__c = (requestBodySubStr.length() > 131072) ? requestBodySubStr.substring(0, 100000) : requestBodySubStr;
                String responseBodySubStr = JSON.serialize(htlSapMap); // String responseBodySubStr = JSON.serialize(dbERRList);
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
            log.Integration_Name__c = 'ESSMSS_UpdateStatusHotel';
            log.Log_Type__c = 'Inbound from SAP - Salesforce generate.';
            log.Response_Body__c = JSON.serialize(error).left(100000);
            log.Message_Type__c = 'Fail';
            log.OwnerId = UserInfo.getUserId();
            insert log;
            return errorList;
        }
    }
}