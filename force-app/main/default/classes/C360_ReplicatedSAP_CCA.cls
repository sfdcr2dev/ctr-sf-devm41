public class C360_ReplicatedSAP_CCA {
    public class ParseException extends Exception{}
    public class dto_response extends WebserviceExtend.dto_response{}
    public static dto_response parse(String json){
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }
    public static dto_response execute(Map<String,Object> requestBody, RestRequest request){
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\', '\\\\') : '';
        Application_Log__c applog = new Application_Log__c(
            External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
            Integration_Name__c = 'CTR Replicated SAP CCA',
            Method__c = 'Upsert',
            Message_Type__c = 'Success',
            Request_Body__c = JSON.serialize(requestBody).abbreviate(131000)
        );
        try{
            parseJSONInputs(body);
            applog.Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'description' => new Map<String, Object>{
                    'success' => true,
                    'message' => 'Integration Success, please review application log for the detail',
                    'linkurl' => applog.External_ID__c},
                    'recordIds' => ''
                }
            );
        }catch(Exception ex){
            applog.Error_Message__c = ex.getMessage()+ex.getLineNumber();
            applog.Message_Type__c = 'Fail';
            applog.Response_Body__c = JSON.serialize(
                new Map<String,Object>{
                    'description' => new Map<String,Object>{
                    'success' => false,
                    'message' => ex.getMessage()+ex.getLineNumber(),
                    'linkurl' => applog.External_ID__c}
                }
            );
            ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
        }
        return dto_response.parse(applog.Response_Body__c);
    }
    public static void parseJSONInputs(String body){
        Map<String,Object> parsedBody = (Map<String,Object>) JSON.deserializeUntyped(body);
        List<Object> dataList = (List<Object>)parsedBody.get('CCALIST');
        List<C360_BuyingPerformanceDailyTOP__c> OverdueList = new List<C360_BuyingPerformanceDailyTOP__c>();
        List<Account> upsertedAccountCCA = new List<Account>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        system.debug(dataList);

        String mSAPCode = '';
        String mCCA = '';

        for(Object rawInput : dataList){ 
            Map<String,Object> input = (Map<String,Object>) rawInput;
            //Account updateCCA = new Account();
            System.debug(String.valueOf(input.get('CCA')));
            //updateCCA.SAPCCA__c = String.valueOf(input.get('CCA'));
            //updateCCA.Currency__c = String.valueOf(input.get('CURRENCY'));
            //updateCCA.AccountNumber__c = String.valueOf(input.get('SAPCODE'));
            //upsertedAccountCCA.add(updateCCA);
            mCCA = String.valueOf(input.get('CCA'));
            mSAPCode = String.valueOf(input.get('SAPCODE'));

        }
        if(mCCA != '' && mSAPCode != '')
        {
            String mSalesOrg = mCCA.substring(0, 2)+'%';
            System.debug('mSalesOrg:'+mSalesOrg);
            System.debug('mSAPCode:'+mSAPCode);
            List<CTRRequestFormItem__c> mRequestItemList = [SELECT ID, Customer__c, RecordTypeId, RecordType.DeveloperName FROM CTRRequestFormItem__c 
                                                            WHERE Customer__r.AccountNumber__c = :mSAPCode AND SAPStatus__c = 'Pending CCA' 
                                                            AND SalesOrganization__c LIKE :mSalesOrg LIMIT 1];
                                                            System.debug('mRequestItemList:'+mRequestItemList);

            if(mRequestItemList.size()>0)
            {
                CTRRequestFormItem__c mRequest = new CTRRequestFormItem__c(Id = mRequestItemList[0].Id);
                mRequest.SAPStatus__c = 'Send Sales/Purchasing View To SAP';
                if(mRequestItemList[0].RecordType.DeveloperName.contains('Customer'))
                {
                    mRequest.CreditControlArea__c = mCCA;
                    mRequest.SAPCCAMapped__c = true;
                }
                update mRequest;

                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = 'CTR Replicated SAP CCA';
                    log.Log_Type__c = 'Success';
                    log.Message_Type__c = 'Success';
                    log.Response_Body__c = JSON.serialize(dataList).abbreviate(131000);
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                    if(insertApplogList.size() > 0){
                        insert insertApplogList;}
                

            }
            else
            {
                Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = 'CTR Replicated SAP CCA';
                    log.Log_Type__c = 'Error';
                    log.Message_Type__c = 'Fail';
                    log.Response_Body__c = JSON.serialize(dataList).abbreviate(131000);
                    log.Error_Message__c = ' CTR CCA - Could not find RequestFormItem';
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                    if(insertApplogList.size() > 0){
                        insert insertApplogList;}
                }
            

            

            
        }

        /*if(upsertedAccountCCA.size() > 0){
            Schema.SObjectField Key = Account.Fields.AccountNumber__c;
            List<Database.upsertResult> upsertList = Database.upsert(upsertedAccountCCA,Key,false);
            if(upsertList.size() > 0){
                List<String> errorMsg_List = new List<String>();
                Map<String,List<String>> errorMap = new Map<String,List<String>>();
                for(Integer idx = 0; idx < upsertList.size(); idx++){
                    if(!upsertList[idx].isSuccess()){
                        errorMsg_List = new List<String>();
                        for(Database.Error err : upsertList[idx].getErrors()){
                            errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                        }
                        errorMap.put(upsertList[idx].getId(),errorMsg_List);
                    }
                }
                if(errorMsg_List.size() > 0){
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = 'CTR Replicated SAP CCA';
                    log.Log_Type__c = 'Error';
                    log.Message_Type__c = 'Fail';
                    log.Response_Body__c = JSON.serialize(dataList).abbreviate(131000);
                    log.Error_Message__c = ' CTR CCA - '+ errorMap.keyset()+' : '+ errorMap.values();
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                    if(insertApplogList.size() > 0){
                        insert insertApplogList;}
                }else{
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = 'CTR Replicated SAP CCA';
                    log.Log_Type__c = 'Success';
                    log.Message_Type__c = 'Success';
                    log.Response_Body__c = JSON.serialize(dataList).abbreviate(131000);
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                    if(insertApplogList.size() > 0){
                        insert insertApplogList;}
                }
            }
        }*/

    }
    @TestVisible
    private static Date StringToDate(String dateString){
        Date output;
        output = Date.valueOf(dateString);
        return output;
    }
}