public without sharing class C360_NonSAPFinancialBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
     public Iterable<Object> start(Database.BatchableContext BC) {
        String respone = C360_CalloutNonSAPService.callout('Financial');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope){
        List<C360_CalloutNonSAPService.Financial> FinancialList = (List<C360_CalloutNonSAPService.Financial>) JSON.deserialize(JSON.serialize(scope),List<C360_CalloutNonSAPService.Financial>.class);
        List<Database.upsertResult> area_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_FinancialInfo__c> upsertFinancialList = new List<C360_FinancialInfo__c>();
        List<String> masterCodeList = new List<String>();
        List<String> accList = new List<String>();
        try{
            for(C360_CalloutNonSAPService.Financial Financial : FinancialList){
                if(Financial.A0SOLD_TO != '' && Financial.A0SOLD_TO != null){
                    accList.add(Financial.A0SOLD_TO);
                }
            }
            list<Account> customerList = [select id,AccountNumber__c from Account where RecordType.DeveloperName in ('SoldTo') and AccountNumber__c IN:accList];
            map<String,String> customerMap = new map<String,String>();
            for(Account custItem : customerList ){
                customerMap.put(custItem .AccountNumber__c, custItem.id);
            }
            string MissingCustomer = 'MissingCustomer = [';
            for(C360_CalloutNonSAPService.Financial Financial : FinancialList){
                C360_FinancialInfo__c upsertFinancial = new C360_FinancialInfo__c();
                if(customerMap.get(Financial.A0SOLD_TO) != '' && customerMap.get(Financial.A0SOLD_TO) != null){
                    upsertFinancial.Key__c =Financial.A0SOLD_TO + Financial.A0SALESORG + Financial.A0SALESORG;
                    upsertFinancial.CompanyName__c = customerMap.get(Financial.A0SOLD_TO);
                    upsertFinancial.CompanyCode__c = (Financial.A0SALESORG != '' && Financial.A0SALESORG != null) ? Financial.A0SALESORG : '';
                    upsertFinancial.PocketMargin__c = Financial.AECUVA7JRJ25QO2R3DU2LR2CY;
                    upsertFinancial.CurrencyLocal__c = (Financial.AECUVA7JRJ25QO2R3DU2LRF02_E != '' && Financial.AECUVA7JRJ25QO2R3DU2LRF02_E != null) ? Financial.AECUVA7JRJ25QO2R3DU2LRF02_E : '';
                    upsertFinancial.PocketMarginUSD__c = Financial.AECUVA7JRJ25QO2R3DU2LR8OI;
                    upsertFinancial.Revenue__c = Financial.AECUVA7JRJ25QO2R3DU2LQPPU;
                    upsertFinancial.RevenueUSD__c = Financial.AECUVA7JRJ25QO2R3DU2LQW1E;
                    upsertFinancialList.add(upsertFinancial);
                }else{
                    MissingCustomer = MissingCustomer + Financial.A0SOLD_TO +',';
                }
            }
            if(MissingCustomer.right(1)==','){
                MissingCustomer = MissingCustomer.Substring(0,MissingCustomer.length()-1) + ']';
            }else{
                MissingCustomer = MissingCustomer + ']';
            }
            if(upsertFinancialList.size()> 0){
                Schema.SObjectField areaKey = C360_FinancialInfo__c.Fields.Key__c;
                area_resultList = Database.upsert(upsertFinancialList,areaKey,false);
                if(area_resultList.size() > 0){
                    List<String> areaIdList_suc = new List<String>();
                    List<String> area_errorMsg_List = new List<String>();
                    Map<String,List<String>> area_errorMap = new Map<String,List<String>>();
                    for(Integer idx = 0; idx < area_resultList.size(); idx++){
                        if(area_resultList[idx].isSuccess()){
                            areaIdList_suc.add(area_resultList[idx].getId());
                        }else{
                            area_errorMsg_List = new List<String>();
                            for(Database.Error err : area_resultList[idx].getErrors()){
                                area_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                        }
                        area_errorMap.put(area_resultList[idx].getId(),area_errorMsg_List);
                    }
                    if(area_errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Non-SAP Financial Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
                        log.Error_Message__c = 'Financial - '+area_errorMap.keyset()+' : '+area_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Non-SAP Financial Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
                        log.Error_Message__c = 'Financial - Success '+MissingCustomer;
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            } 
            
        }
        catch(Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated Non-SAP Financial Webservice';
            log.Log_Type__c = 'Error';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
        }
    }
    public void finish(Database.BatchableContext BC){}
}