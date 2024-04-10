public without sharing class C360_NonSAPSalesAreaTSBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
    public Iterable<Object> start(Database.BatchableContext BC){
        String respone = C360_CalloutNonSAPService.callout('SalesAreaTS');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope){
        List<C360_CalloutNonSAPService.SalesArea> salesareaTSList = (List<C360_CalloutNonSAPService.SalesArea>) JSON.deserialize(JSON.serialize(scope),List<C360_CalloutNonSAPService.SalesArea>.class);
        List<Database.upsertResult> area_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_SalesArea__c> upsertSalesareaList = new List<C360_SalesArea__c>();
        List<String> masterCodeList = new List<String>();
        List<String> accList = new List<String>();
        List<Account> upAccountList9200 = new List<Account>();
        List<Account> upAccountList9300 = new List<Account>();
        List<Account> upAccountList9400 = new List<Account>();
        Map<String,Object> areaAccountMap9200 = new Map<String,Object>();
        Map<String,Object> areaAccountMap9300 = new Map<String,Object>();
        Map<String,Object> areaAccountMap9400 = new Map<String,Object>();
        try{
            for(C360_CalloutNonSAPService.SalesArea tsSalesArea : salesareaTSList){
                if(tsSalesArea.A0PMNTTRMS != '' && tsSalesArea.A0PMNTTRMS != null){
                    masterCodeList.add(tsSalesArea.A0PMNTTRMS);
                }
                if(tsSalesArea.ZCUSTMR != '' && tsSalesArea.ZCUSTMR != null){
                    accList.add(tsSalesArea.ZCUSTMR);
                }
            }
            List<Master_Map__c> sf_mapList = [select id, Code__c from Master_Map__c where Type__c in ('Payment Term') and Code__c IN:masterCodeList];
            Map<String,String> masterMap = new Map<String,String>();
            for(Master_Map__c item : sf_mapList){
                masterMap.put(item.Code__c,item.id);
            }
            list<Account> customerList = [select id,AccountNumber__c from Account where RecordType.DeveloperName in ('SoldTo') and AccountNumber__c IN:accList];
            Map<String,String> customerMap = new Map<String,String>();
            for(Account custItem : customerList){
                customerMap.put(custItem.AccountNumber__c,custItem.id);
            }
            string MissingCustomer = 'MissingCustomer = [';
            for(C360_CalloutNonSAPService.SalesArea tsSalesArea : salesareaTSList){
                Account upAccount = new Account();
                C360_SalesArea__c upsertAreaTs = new C360_SalesArea__c();
                Account upAccount9200 = new Account();
                Account upAccount9300 = new Account();
                Account upAccount9400 = new Account();
                if(customerMap.get(tsSalesArea.ZCUSTMR) != '' && customerMap.get(tsSalesArea.ZCUSTMR) != null){
                    if(!areaAccountMap9200.containsKey(customerMap.get(tsSalesArea.ZCUSTMR)) && tsSalesArea.A0SALESORG =='9200'){
                        upAccount9200.TOPSOLVENTTSR__c = True ; 
                        upAccount9200.id = customerMap.get(tsSalesArea.ZCUSTMR);
                        upAccount9200.AccountNumber__c = tsSalesArea.ZCUSTMR;
                        upAccountList9200.add(upAccount9200);
                        areaAccountMap9200.put(customerMap.get(tsSalesArea.ZCUSTMR),upAccount9200);
                    }
                    if(!areaAccountMap9300.containsKey(customerMap.get(tsSalesArea.ZCUSTMR)) && tsSalesArea.A0SALESORG =='9300'){
                        upAccount9300.TOPSOLVENTJSKem__c = True ;
                        upAccount9300.id = customerMap.get(tsSalesArea.ZCUSTMR);
                        upAccountList9300.add(upAccount9300);
                        areaAccountMap9300.put(customerMap.get(tsSalesArea.ZCUSTMR),upAccount9300);
                    }
                    if(!areaAccountMap9400.containsKey(customerMap.get(tsSalesArea.ZCUSTMR)) && tsSalesArea.A0SALESORG =='9400'){
                        upAccount9400.TOPSOLVENTTSChem__c = True ;
                        upAccount9400.id = customerMap.get(tsSalesArea.ZCUSTMR);
                        upAccountList9400.add(upAccount9400);
                        areaAccountMap9400.put(customerMap.get(tsSalesArea.ZCUSTMR),upAccount9400);
                    }
                    String tsSalesareaExtId = tsSalesArea.ZCUSTMR +tsSalesArea.A0SALESORG + tsSalesArea.A0DISTR_CHAN + '00';
                    upsertAreaTs.Key__c =tsSalesareaExtId;
                    upsertAreaTs.AccountNumber__c = customerMap.get(tsSalesArea.ZCUSTMR);
                    upsertAreaTs.SalesOrganization__c = (tsSalesArea.A0SALESORG != '' && tsSalesArea.A0SALESORG != null) ? tsSalesArea.A0SALESORG : '';
                    upsertAreaTs.DistributionChannel__c = (tsSalesArea.A0DISTR_CHAN != '' && tsSalesArea.A0DISTR_CHAN != null) ? tsSalesArea.A0DISTR_CHAN : '';
                    upsertAreaTs.Division__c = '00'; 
                    upsertAreaTs.CustomerTypeCode__c = (tsSalesArea.ZTSCUSTT != '' && tsSalesArea.ZTSCUSTT != null) ? tsSalesArea.ZTSCUSTT : '';
                    upsertAreaTs.CustomerTypeDesc__c = (tsSalesArea.ZTSCUST_T != '' && tsSalesArea.ZTSCUST_T != null) ? tsSalesArea.ZTSCUST_T : '';
                    upsertAreaTs.ApplicationCode__c = (tsSalesArea.ZTSAPP != '' && tsSalesArea.ZTSAPP != null) ? tsSalesArea.ZTSAPP : '';
                    upsertAreaTs.ApplicationDesc__c = (tsSalesArea.ZTSAPP_T != '' && tsSalesArea.ZTSAPP_T != null) ? tsSalesArea.ZTSAPP_T : '';
                    upsertAreaTs.IndustryCode__c = (tsSalesArea.ZTSINDUST != '' && tsSalesArea.ZTSINDUST != null) ? tsSalesArea.ZTSINDUST : '';
                    upsertAreaTs.IndustryDesc__c = (tsSalesArea.ZTSINDUST_T != '' && tsSalesArea.ZTSINDUST_T != null) ? tsSalesArea.ZTSINDUST_T : '';
                    upsertAreaTs.SubIndustryCode__c = (tsSalesArea.ZTSSINDUS != '' && tsSalesArea.ZTSSINDUS != null) ? tsSalesArea.ZTSSINDUS : '';
                    upsertAreaTs.SubIndustryDesc__c = (tsSalesArea.ZTSSINDUS_T != '' && tsSalesArea.ZTSSINDUS_T != null) ? tsSalesArea.ZTSSINDUS_T : '';
                    upsertAreaTs.SalesDistrict__c = (tsSalesArea.ZSLDSTRCT != '' && tsSalesArea.ZSLDSTRCT != null) ? tsSalesArea.ZSLDSTRCT : '';
                    upsertAreaTs.SalesGroup__c = (tsSalesArea.ZTSSGRP != '' && tsSalesArea.ZTSSGRP != null) ? tsSalesArea.ZTSSGRP : '';
                    upsertAreaTs.Currency__c = (tsSalesArea.A0CURRENCY != '' && tsSalesArea.A0CURRENCY != null) ? tsSalesArea.A0CURRENCY : '';
                    upsertAreaTs.TermofPayment__c = (masterMap.containskey(tsSalesArea.A0PMNTTRMS))? masterMap.get(tsSalesArea.A0PMNTTRMS) : null;
                    upsertAreaTs.CustomerPayment__c = (tsSalesArea.A4ZCCP_V05CUSTOMERGUAR != '' && tsSalesArea.A4ZCCP_V05CUSTOMERGUAR != null) ? tsSalesArea.A4ZCCP_V05CUSTOMERGUAR : '';
                    upsertAreaTs.CreditControlArea__c = (tsSalesArea.A0C_CTR_AREA != '' && tsSalesArea.A0C_CTR_AREA != null) ? tsSalesArea.A0C_CTR_AREA : '';
                    upsertAreaTs.Incoterms__c = (tsSalesArea.A0INCOTERMS != '' && tsSalesArea.A0INCOTERMS != null) ? tsSalesArea.A0INCOTERMS : '';
                    upsertAreaTs.AccountAssignmentGroup__c = (tsSalesArea.ZKTGRM != '' && tsSalesArea.ZKTGRM != null) ? tsSalesArea.ZKTGRM : '';
                    upsertAreaTs.Status__c = (tsSalesArea.ZDELFLAG == 'X') ? 'Inactive' : 'Active';
                    upsertAreaTs.TOPCustomerGroup__c = (tsSalesArea.ZTSCUSGRP != '' && tsSalesArea.ZTSCUSGRP != null) ? tsSalesArea.ZTSCUSGRP : '';
                    upsertSalesareaList.add(upsertAreaTs);
                }else{
                    MissingCustomer = MissingCustomer + tsSalesArea.ZCUSTMR +',';
                }
            }
            if(MissingCustomer.right(1)==','){
                MissingCustomer = MissingCustomer.Substring(0,MissingCustomer.length()-1) + ']';
            }else{
                MissingCustomer = MissingCustomer + ']';
            }
            if(upsertSalesareaList.size()> 0){
                Schema.SObjectField areaKey = C360_SalesArea__c.Fields.Key__c;
                area_resultList = Database.upsert(upsertSalesareaList,areaKey,false);
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
                        log.Integration_Name__c = 'C360 Replicated Non-SAP SalesArea TS Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
                        log.Error_Message__c = 'SalesArea - '+area_errorMap.keyset()+' : '+area_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Non-SAP SalesArea TS Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
                        log.Error_Message__c = 'SalesArea - Success '+MissingCustomer;
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }
        catch (Exception e) {
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated Non-SAP SalesArea TS Webservice';
            log.Log_Type__c = 'Error';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
            if(upAccountList9200.size()> 0){
                List<Database.SaveResult> AccResults9200 = Database.update(upAccountList9200, false);
            }
            if(upAccountList9300.size()> 0){
                List<Database.SaveResult> AccResults9300 = Database.update(upAccountList9300, false);
            }  
            if(upAccountList9400.size()> 0){
                List<Database.SaveResult> AccResults9400 = Database.update(upAccountList9400, false);
            }  
        }
    }
    public void finish(Database.BatchableContext BC){}
}