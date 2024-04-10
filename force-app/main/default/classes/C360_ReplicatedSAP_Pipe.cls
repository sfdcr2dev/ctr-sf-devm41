public class C360_ReplicatedSAP_Pipe  
{
    public class ParseException extends Exception {}
    public class dto_response extends WebserviceExtend.dto_response {}
    public static dto_response parse(String json) 
    {
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }
    public static dto_response execute(Map<String, Object> requestBody, RestRequest request) 
    {
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\', '\\\\') : '';
        Application_Log__c applog = new Application_Log__c
        (
            External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
            Integration_Name__c = 'C360 ReplicatedSAP Pipe',
            Method__c = 'Upsert',
            Message_Type__c = 'Success',
            Request_Body__c = JSON.serialize(requestBody).abbreviate(131000)
        );
        try {
            parseJSONInputs(body);
            applog.Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'description' => new Map<String, Object>{
                        'success' => true,
                            'message' => 'Integration Success, please review application log for the detail',
                            'linkurl' => applog.External_ID__c
                            },
                                'recordIds' => ''
                                }
                );
        }catch (Exception ex){
            applog.Error_Message__c = ex.getMessage()+ex.getLineNumber();
            applog.Message_Type__c = 'Fail';
            applog.Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'description' => new Map<String, Object>{
                        'success' => false,
                            'message' => ex.getMessage()+ex.getLineNumber(),
                            'linkurl' => applog.External_ID__c
                            }
                }
            );
            ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
        }
        return dto_response.parse(applog.Response_Body__c);
    }
    
    @future
    public static void parseJSONInputs(String body) 
    {
        Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> buyingDailyList = (List<Object>)parsedBody.get('PLIST');
        List<C360_BuyingPerformanceDailyTOP__c> OverdueList = new List<C360_BuyingPerformanceDailyTOP__c>();
        List<Account>accountList = new List<Account>();
        list<string>customerList = new List<string>();
        list<string>productList = new List<string>();
        List<C360_Product__c>sf_productList = new List<C360_Product__c>();
        List<Application_Log__c>insertApplogList = new List<Application_Log__c>();
        List<C360_BuyingPerformanceDailyTOP__c> upsertedBuyingDaily = new List<C360_BuyingPerformanceDailyTOP__c>();
		Id RecordTypeId = [select id from RecordType where DeveloperName = 'TransferPipe'].Id;
        for (Object rawInput : buyingDailyList) 
        { 
            Map<String, Object> input = (Map<String, Object>) rawInput;
            C360_BuyingPerformanceDailyTOP__c buyingDailySF = new C360_BuyingPerformanceDailyTOP__c();
            buyingDailySF.RecordTypeId = RecordTypeId;
            buyingDailySF.CustomerText__c = String.valueOf(input.get('NAME1'));
            buyingDailySF.ProductNameText__c = String.valueOf(input.get('MATERIAL_DESCRIPTION'));
            buyingDailySF.SalesOrganization__c = input.get('SALES_ORG')!= null && String.valueOf(input.get('SALES_ORG')) != ''? String.valueOf(input.get('SALES_ORG')) : null;
            buyingDailySF.PayL15__c = input.get('PAY_L15')!= null && String.valueOf(input.get('PAY_L15')) != ''? Decimal.valueof(String.valueOf(input.get('PAY_L15'))): null;
            buyingDailySF.PayL30__c =  input.get('PAY_L30')!= null && String.valueOf(input.get('PAY_L30')) != ''? Decimal.valueof(String.valueOf(input.get('PAY_L30'))) :null;
            buyingDailySF.PayBBL__c = input.get('PAY_BBL')!= null && String.valueOf(input.get('PAY_BBL')) != '' ? Decimal.valueof(String.valueOf(input.get('PAY_BBL'))) : null;
            buyingDailySF.PayMT__c = input.get('PAY_MT')!= null && String.valueOf(input.get('PAY_MT')) != ''? Decimal.valueof(String.valueOf(input.get('PAY_MT'))) : null;
            buyingDailySF.CheckL15__c = input.get('CHECK_L15')!= null && String.valueOf(input.get('CHECK_L15')) != ''? Decimal.valueof(String.valueOf(input.get('CHECK_L15'))): null;
            buyingDailySF.CheckL30__c = input.get('CHECK_L30')!= null && String.valueOf(input.get('CHECK_L30')) != ''? Decimal.valueof(String.valueOf(input.get('CHECK_L30'))):null;
            buyingDailySF.CheckBBL__c = input.get('CHECK_BBL')!= null && String.valueOf(input.get('CHECK_BBL')) != ''? Decimal.valueof(String.valueOf(input.get('CHECK_BBL'))):null;
            buyingDailySF.CheckMT__c = input.get('CHECK_MT')!= null && String.valueOf(input.get('CHECK_MT')) != ''? Decimal.valueof(String.valueOf(input.get('CHECK_MT'))): null;
            buyingDailySF.QuantityLGL15__c = input.get('QTY_L_G_L15')!= null && String.valueOf(input.get('QTY_L_G_L15')) != ''? Decimal.valueof(String.valueOf(input.get('QTY_L_G_L15'))): null;
            buyingDailySF.QuantityLGL30__c = input.get('QTY_L_G_L30')!= null && String.valueOf(input.get('QTY_L_G_L30')) != ''? Decimal.valueof(String.valueOf(input.get('QTY_L_G_L30'))): null;
            buyingDailySF.LGL15__c = input.get('PERCENT_L_G_L15')!= null && String.valueOf(input.get('PERCENT_L_G_L15')) != ''? Decimal.valueof(String.valueOf(input.get('PERCENT_L_G_L15'))): null;
            buyingDailySF.LGL30__c =input.get('PERCENT_L_G_L30')!= null && String.valueOf(input.get('PERCENT_L_G_L30')) != ''? Decimal.valueof(String.valueOf(input.get('PERCENT_L_G_L30'))): null;
            buyingDailySF.TripNo__c	= String.valueOf(input.get('TRIP_NO'));
            buyingDailySF.DeliveryDate__c= StringToDate(String.valueOf(input.get('DELIVERY_DATE')));
            buyingDailySF.From__c = String.valueOf(input.get('FROM'));
            buyingDailySF.To__c	= String.valueOf(input.get('TO'));
            buyingDailySF.Key__c = String.valueOf(input.get('SALES_ORG')) + String.valueOf(input.get('DISTRIBUTION_CHANNEL')) + String.valueOf(input.get('NAME1')) + String.valueOf(input.get('TRIP_NO')) + StringToDate(String.valueOf(input.get('DELIVERY_DATE'))) + String.valueOf(input.get('MATERIAL_DESCRIPTION'));
            upsertedBuyingDaily.add(buyingDailySF);
        }
        if (upsertedBuyingDaily.size() > 0) { 	
            Schema.SObjectField buyingDailyKey = C360_BuyingPerformanceDailyTOP__c.Fields.Key__c;
            List<Database.upsertResult> BuyingDailytList = Database.upsert(upsertedBuyingDaily,  buyingDailyKey, false);  
            if(BuyingDailytList.size() > 0){
                List<String>BuyingAct_errorMsg_List = new List<String>();
                map<String,List<String>>BuyingAct_errorMap = new map<String,List<String>>();
                for (Integer idx = 0; idx < BuyingDailytList.size(); idx++){
                    if (!BuyingDailytList[idx].isSuccess()){
                        BuyingAct_errorMsg_List = new List<String>();
                        for(Database.Error err : BuyingDailytList[idx].getErrors()){
                            BuyingAct_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                        }
                        BuyingAct_errorMap.put(BuyingDailytList[idx].getId(),BuyingAct_errorMsg_List);
                    }
                }
                if(BuyingAct_errorMsg_List.size() > 0){
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = 'C360 ReplicatedSAP Pipe';
                    log.Log_Type__c = 'Error';
                    log.Message_Type__c = 'Fail';
                    log.Response_Body__c = JSON.serialize(buyingDailyList).abbreviate(131000);
                    log.Error_Message__c = ' C360 BuyingDaily - '+BuyingAct_errorMap.keyset()+' : '+BuyingAct_errorMap.values();
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                    if(insertApplogList.size() > 0){
                        insert insertApplogList;
                    }
                }else{
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = 'C360 ReplicatedSAP Pipe';
                    log.Log_Type__c = 'Success';
                    log.Message_Type__c = 'Success';
                    log.Response_Body__c = JSON.serialize(buyingDailyList).abbreviate(131000);
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                    if(insertApplogList.size() > 0){
                        insert insertApplogList;
                    }
                }
            }
        }
    }
    
    private static Date StringToDate(String dateString) 
    {
        Date output;
        output = Date.valueOf(dateString);
        return output;
    }
}