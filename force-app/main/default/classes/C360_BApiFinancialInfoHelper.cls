public with sharing class C360_BApiFinancialInfoHelper{
    class FinancialInfoToSAP {
        String KUNNR;//Account Number
        String BUKRS;//Company Code
        String KKBER;//Credit Control Area
        Decimal KLIMK;//Credit Limit
        Decimal ABSBT;//Credit Balance
        Decimal OBLIG;//Outstanding
        String CASHC;//Currency__c
        String CRBLB;//Indicator__c
    }
    public class dto_response extends WebServiceExtend.dto_response{
        public Result result {get;set;}
    }
    public static dto_response parse(String json){
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }
    public static dto_response execute(String endpoint, Map<String, Object> result){
        dto_response responseDTO = new dto_response();
        Application_Log__c applog = new Application_Log__c(
            External_ID__c = String.valueOf(result.get('gateway_id')),
            Integration_Name__c = 'BAPI_FINANCIAL_INFO',
            Method__c = 'Create',
            Message_Type__c = 'Success',
            SAP_Response_Body__c = JSON.serialize(result).abbreviate(90000)
        );
        try{
            String requestBody = String.valueOf(JSON.serialize(result.get('results')));
            List<object> FinancialInfoList = (List<Object>)JSON.deserializeUntyped(requestBody);
            List<FinancialInfoToSAP> ResultList = new List <FinancialInfoToSAP>();
            for(Object obj : FinancialInfoList){
                String jsonSTR = JSON.serialize(obj);
                Map<String,Object> temp = (Map<String,Object>)JSON.deserializeUntyped(jsonSTR);
                FinancialInfoToSAP TempResult = new FinancialInfoToSAP();
                TempResult.KUNNR = removeLeadingZeros((string)temp.get('KUNNR'));
                TempResult.BUKRS = (string)temp.get('BUKRS');
                TempResult.KKBER = (string)temp.get('KKBER');
                TempResult.KLIMK = Decimal.valueOf((string)temp.get('KLIMK'));
                TempResult.ABSBT = Decimal.valueOf((string)temp.get('ABSBT'));
                TempResult.OBLIG = Decimal.valueOf((string)temp.get('OBLIG'));
                TempResult.CASHC = (string)temp.get('CASHC');
                TempResult.CRBLB = (string)temp.get('CRBLB');
                ResultList.add(TempResult);
            }
            list<String> accSAP = new List <string>();
            for(FinancialInfoToSAP iFinancialinfo : ResultList){
                accSAP.add(iFinancialinfo.KUNNR);
            }
            list<Account>AccList = [select id,AccountNumber__c from Account where AccountNumber__c in :accSAP];
            Map<String, string> accSFId = new Map<String, string>();
            for(Account iAcc : AccList){
                accSFId.put(iAcc.AccountNumber__c, iAcc.id);
            }
            List<C360_FinancialInfo__c> FinanceInfoList = new List<C360_FinancialInfo__c>();
            for(FinancialInfoToSAP iFinancialInfoToSAP : ResultList){
                C360_FinancialInfo__c thisFinanceInfo = new C360_FinancialInfo__c();
                if(iFinancialInfoToSAP.BUKRS.substring(0, 2)==iFinancialInfoToSAP.KKBER.substring(0, 2)){
                    thisFinanceInfo.Key__c = iFinancialInfoToSAP.KUNNR + iFinancialInfoToSAP.BUKRS + iFinancialInfoToSAP.KKBER;
                    thisFinanceInfo.CompanyName__c = accSFId.get(iFinancialInfoToSAP.KUNNR);
                    thisFinanceInfo.CompanyCode__c = iFinancialInfoToSAP.BUKRS;
                    thisFinanceInfo.CreditControlArea__c = iFinancialInfoToSAP.KKBER;
                    thisFinanceInfo.CreditLimit__c = iFinancialInfoToSAP.KLIMK;
                    thisFinanceInfo.CreditBalance__c = iFinancialInfoToSAP.ABSBT;
                    thisFinanceInfo.Outstanding__c = iFinancialInfoToSAP.OBLIG;
                    thisFinanceInfo.Currency__c = iFinancialInfoToSAP.CASHC;
                    thisFinanceInfo.Indicator__c = (iFinancialInfoToSAP.CRBLB == 'X') ? True : False;
                    FinanceInfoList.add(thisFinanceInfo);
                }
            }
            upsert FinanceInfoList Key__c;
            ApplicationLogUtils.saveLogInbound(endpoint, applog);
            responseDTO = dto_response.parse(
                JSON.serialize(
                    new Map<String, Object>{
                        'description' => new Map<String, Object>{
						'success' => FinanceInfoList.size() > 0,
						'message' => FinanceInfoList.size() > 0 ? '' : 'Not found Financial Information'
						}
                    }
                )
            );
        }catch (Exception e){
            responseDTO = dto_response.parse(
                JSON.serialize(
                    new Map<String, Object>{
                        'description' => new Map<String, Object>{ 'success' => false, 'message' => e.getMessage() },
                        'result' => new Map<String, Object>{ 'data' => new List<Object>() }
                    }
                )
            );
            applog.Message_Type__c = 'Fail';
            applog.Error_Message__c = e.getMessage();
            applog.SAP_Response_Body__c = JSON.serialize(result).abbreviate(90000);
            ApplicationLogUtils.saveLogInbound(endpoint, applog);
        }
        return responseDTO;
    }
    static String removeLeadingZeros(String num){
        for(integer i=0;i<num.length();i++){
            if(num.charAt(i)!=48){
                String res = num.substring(i);
                return res;
            }
        }
        return '0';
    }
}