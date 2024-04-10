public class C360_ReplicatedSAP_Overdue {
    public class ParseException extends Exception {}
    public class dto_response extends WebserviceExtend.dto_response {}
    public static dto_response parse(String json) {
        return (dto_response) System.JSON.deserialize(json, dto_response.class);
    }
    //Overdue 
	public class OverdueFromSAP {
        public String CompanyNameFromSap;  //CompanyName__c
        public String CompanyCodeFromSap;  //CompanyCode__c
        public decimal OverdueAmountinDocCurrency;  //OverdueAmountinDocCurrency__c
        public String DocCurrency;  //DocCurrency__c
        public decimal AmountinLocalCurrency;  //AmountinLocalCurrency__c
        public decimal Overdueday;  //Overdueday__c
        public String FiscalYear; //ยังไม่มี Field FiscalYear__c
        public String DocumentNumber; //ยังไม่มี Field DocumentNumber__c
    }

    public static dto_response execute(Map<String, Object> requestBody, RestRequest request) {
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\', '\\\\') : '';
        Application_Log__c applog = new Application_Log__c(
            External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
            Integration_Name__c = 'C360_ReplicatedSAP_Overdue',
            Method__c = 'Insert',
            Message_Type__c = 'Success',
            Request_Body__c = JSON.serialize(requestBody).abbreviate(131000)
        );
        List<OverdueFromSAP> OdList;
        try {
            OdList = parseJSONInputs(body);
        } catch (Exception ex) {
            applog.Error_Message__c = ex.getMessage();
            applog.Message_Type__c = 'Fail';
            applog.Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'description' => new Map<String, Object>{
                        'success' => false,
                        'message' => 'Unknown string format, cannot parse body data. Please try JSON format.',
                        'linkurl' => applog.External_ID__c
                    }
                }
            );
        	
            ApplicationLogUtils.saveLogInbound(request.requestURI, applog);
            return dto_response.parse(applog.Response_Body__c);
        }
        List<C360_OverduePayment__c> savedList = saveOverdue(OdList);
        List<C360_OverduePayment__c> savedListNotNull = new list <C360_OverduePayment__c>();
        for(C360_OverduePayment__c i : savedList){
            if(i.id != null){
                savedListNotNull.add(i);
            }
        }
        applog.Response_Body__c = JSON.serialize(
            new Map<String, Object>{
                'description' => new Map<String, Object>{
                    'success' => savedList.size() > 0,
                    'message' => savedList.size() > 0 ? '' : 'Not found Operation Information',
                    'linkurl' => applog.External_ID__c
                },
                'recordIds' => (new Map<Id, C360_OverduePayment__c>(savedListNotNull)).keySet()
            }
        );
        return dto_response.parse(applog.Response_Body__c);
    }
    public static List<OverdueFromSAP> parseJSONInputs(String body) {
        try {    
            Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
            List<Object> OdList = (List<Object>)parsedBody.get('ODLIST');
            List<OverdueFromSAP> inputs = new List<OverdueFromSAP>();
            for (Object rawInput : OdList) { 
                Map<String, Object> input = (Map<String, Object>) rawInput;
                OverdueFromSAP Overdue = new OverdueFromSAP();
                Overdue.CompanyNameFromSap = String.valueOf(input.get('CUSTOMERCODE'));
                Overdue.CompanyCodeFromSap = String.valueOf(input.get('COMPANYCODE'));
                Overdue.Overdueday = String.valueOf(input.get('OVERDUEDAY')).right(1)=='-'? Overdue.Overdueday = decimal.valueOf(String.valueOf(input.get('OVERDUEDAY')).Substring(0,String.valueOf(input.get('OVERDUEDAY')).length()-1)) : decimal.valueOf(String.valueOf(input.get('OVERDUEDAY')));
                Overdue.DocCurrency = String.valueOf(input.get('DOCCURRENCY'));
                Overdue.OverdueAmountinDocCurrency = decimal.valueOf(String.valueOf(input.get('AMOUNTINDOCCURRENCY')));
                Overdue.AmountinLocalCurrency = decimal.valueOf(String.valueOf(input.get('AMOUNTINLOCALCURRENCY'))); 
                inputs.add(Overdue);
            }
        return inputs;
        }catch(Exception e) {
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'parseJSONInputs';
            log.Integration_Name__c = 'C360_ReplicatedSAP_Overdue';
            log.Log_Type__c = 'Fail';
            log.Message_Type__c = 'Fail';
            log.Error_Message__c = e.getMessage()+ ' Line:'+e.getLineNumber();
            log.OwnerId = UserInfo.getUserId();
            insert log;
            return null;
        }
    }
	public static List<C360_OverduePayment__c> saveOverdue(List<OverdueFromSAP> OdList) {
        try {
            List<Database.SaveResult> Overdue_resultList;
            List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
            List<C360_OverduePayment__c> OverdueList = new List<C360_OverduePayment__c>();
            List<Account>AccountList = new List<Account>();
            list<string>CustomerList = new List<string>();
            list<string>CompanyCodeList = new List<string>();
            for (OverdueFromSAP OdSAP : OdList) {
                CustomerList.add(OdSAP.CompanyNameFromSap);
            }
            AccountList = [SELECT Id, AccountNumber__c FROM Account where AccountNumber__c in :CustomerList ];     
            String MissingCustomer = 'MissingCustomer = [';     
            Map<String, String> AccNameId = new Map<String, String>();  
            for(Account thisAcc : AccountList){
                AccNameId.put(thisAcc.AccountNumber__c, thisAcc.Id);
            }
		List<C360_OverduePayment__c> upsertedOverdue = new List<C360_OverduePayment__c>();
		for (OverdueFromSAP OdSAP : OdList) {
            if(AccNameId.containskey(OdSAP.CompanyNameFromSap)){
			C360_OverduePayment__c OdSF = new C360_OverduePayment__c();
            OdSF.CompanyName__c = AccNameId.get(OdSAP.CompanyNameFromSap);
			OdSF.CompanyCode__c = OdSAP.CompanyCodeFromSap; 
			OdSF.Overdueday__c = OdSAP.Overdueday;
			OdSF.DocCurrency__c = OdSAP.DocCurrency;
			OdSF.OverdueAmountinDocCurrency__c = OdSAP.OverdueAmountinDocCurrency;
			OdSF.AmountinLocalCurrency__c = OdSAP.AmountinLocalCurrency;
                upsertedOverdue.add(OdSF);
            }else{
				MissingCustomer = MissingCustomer + OdSAP.CompanyNameFromSap +',';
            }
               
		}
            if(MissingCustomer.right(1)==','){
                MissingCustomer = MissingCustomer.Substring(0,MissingCustomer.length()-1) + ']';
            }else{
                MissingCustomer = MissingCustomer + ']';
            }  
		if (upsertedOverdue.size() > 0) {
            List<C360_OverduePayment__c> DelOverdueList = [select id from C360_OverduePayment__c];
			delete DelOverdueList;
            Overdue_resultList = Database.insert(upsertedOverdue, false);
            if (Overdue_resultList.size() > 0) {
                List<String> OverdueIdList_suc = new List<String>();
                List<String> Overdue_errorMsg_List = new List<String>();
                Map<String,List<String>> Overdue_errorMap = new Map<String,List<String>>();
                for (Integer idx = 0; idx < Overdue_resultList.size(); idx++) {
                    if (Overdue_resultList[idx].isSuccess()) {
                        OverdueIdList_suc.add(Overdue_resultList[idx].getId());
                    } else {
                        Overdue_errorMsg_List = new List<String>();
                        for(Database.Error err : Overdue_resultList[idx].getErrors()) {
                            Overdue_errorMsg_List.add('Field:' + err.getFields() + ': ' + err.getMessage());
                        }
                    }
                    Overdue_errorMap.put(Overdue_resultList[idx].getId(),Overdue_errorMsg_List);
                }
                if(Overdue_errorMsg_List.size() > 0) {
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Insert';
                    log.Log_Type__c = 'Fail';
                    log.Integration_Name__c = 'C360_ReplicatedSAP_Overdue';
                    log.Message_Type__c = 'Fail';
                    log.Error_Message__c = 'Overdue - '+Overdue_errorMap.keyset()+' : '+Overdue_errorMap.values();
                    log.Response_Body__c = JSON.serialize(OdList).left(131072);
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                }else{
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Insert';
                    log.Log_Type__c = 'Success';
                    log.Integration_Name__c = 'C360_ReplicatedSAP_Overdue';
                    log.Message_Type__c = 'Success';
                    log.Error_Message__c = MissingCustomer;
                    log.Response_Body__c = JSON.serialize(OdList).left(131072);
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);//;
                }
                if(insertApplogList.size() > 0){
                    insert insertApplogList;
                }
                return upsertedOverdue;
            }
        }     
        Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360_ReplicatedSAP_Overdue';
            log.Log_Type__c = 'Success';
            log.Message_Type__c = 'Success';
            log.Response_Body__c = JSON.serialize(OdList).left(131072);
            log.Error_Message__c =  MissingCustomer;
            log.OwnerId = UserInfo.getUserId();
            insert log;
            return upsertedOverdue;
		}catch(Exception e) {
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'saveOverdue';
            log.Integration_Name__c = 'C360_ReplicatedSAP_Overdue';
            log.Log_Type__c = 'Fail';
            log.Message_Type__c = 'Fail';
            log.OwnerId = UserInfo.getUserId();
            insert log;
            return null;
        }
	}
    public static Date StringToDate(String dateString) {
        if (dateString.length() != 8) {
            return null;
        }
        List<String> dates = new List<String>();
        dates.add(dateString.left(4));
        dates.add(dateString.mid(3, 2));
        dates.add(dateString.right(2));
        Date output;
        try {
            output = Date.valueOf(String.join(dates, '-'));
        } catch(System.TypeException ex) {
            output = null;
        }
        return output;
    }
}