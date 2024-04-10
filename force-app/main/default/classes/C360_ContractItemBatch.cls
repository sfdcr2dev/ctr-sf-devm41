public without sharing class C360_ContractItemBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful {
    public Iterable<Object> start(Database.BatchableContext BC) {
        String respone = C360_CalloutBIService.calloutBI('ContractItem');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug('Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope) {
        List<C360_CalloutBIService.ContractItem> contractItems = (List<C360_CalloutBIService.ContractItem>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.ContractItem>.class);
        List<Database.upsertResult> resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_ContractLineItem__c> upsertContractItemList = new List<C360_ContractLineItem__c>();
        List<String> contractItemKeyList = new List<String>();
        try {
            Set<String> accSet = new Set<String>();
            Set<String> prodSet = new Set<String>();
            Set<String> contSet = new Set<String>();
            for(C360_CalloutBIService.ContractItem contItem : contractItems) {
                if(contItem.A0SHIP_TO != '' && contItem.A0SHIP_TO != null){
                    accSet.add(contItem.A0SHIP_TO);
                }
                if(contItem.A0MATERIAL != '' && contItem.A0MATERIAL != null){
                    prodSet.add(contItem.A0MATERIAL);
                }
                if(contItem.A0DOC_NUMBER != '' && contItem.A0DOC_NUMBER != null){
                    contSet.add(contItem.A0DOC_NUMBER);
                }
            }
            List<Account> sf_accList = [select AccountNumber__c,id from Account where AccountNumber__c IN:accSet];
            Map<String,String> sf_accMap = new map<String,String>();
            for(Account item : sf_accList){
                sf_accMap.put(item.AccountNumber__c, item.id);
            }
            List<C360_Product__c> sf_prodList = [select id, MaterialCode__c from C360_Product__c where MaterialCode__c IN:prodSet];
            Map<String,String> sf_prodMap = new map<String,String>();
            for(C360_Product__c item : sf_prodList){
                sf_prodMap.put(item.MaterialCode__c, item.id);
            }
            List<C360_Contract__c> sf_contList = [select id, DocumentNumber__c from C360_Contract__c where DocumentNumber__c IN:contSet];
            Map<String,String> sf_contMap = new map<String,String>();
            for(C360_Contract__c item : sf_contList){
                sf_contMap.put(item.DocumentNumber__c, item.id);
            }
            for(C360_CalloutBIService.ContractItem contItem : contractItems){
                C360_ContractLineItem__c upsertContItem = new C360_ContractLineItem__c();
                if(sf_contMap.get(contItem.A0DOC_NUMBER) !='' && sf_contMap.get(contItem.A0DOC_NUMBER) != null){
                    upsertContItem.Key__c = contItem.A0DOC_NUMBER + contItem.A0S_ORD_ITEM;
                    if(contItem.A0MATERIAL != null && contItem.A0MATERIAL != ''){
                        upsertContItem.Product__c = (sf_prodMap.containskey(contItem.A0MATERIAL)) ? sf_prodMap.get(contItem.A0MATERIAL) : null;
                    }else{upsertContItem.Product__c = null;}
                    if(contItem.A0SHIP_TO != null && contItem.A0SHIP_TO != ''){
                        upsertContItem.ShipTo__c = (sf_accMap.containskey(contItem.A0SHIP_TO))? sf_accMap.get(contItem.A0SHIP_TO) : null;
                    }else{upsertContItem.ShipTo__c = null;}
                    if(contItem.A0DOC_NUMBER != null && contItem.A0DOC_NUMBER != ''){
                        upsertContItem.Contract__c = (sf_contMap.containskey(contItem.A0DOC_NUMBER))? sf_contMap.get(contItem.A0DOC_NUMBER) : null;
                    }else{upsertContItem.Contract__c = null;}
                    upsertContItem.Price__c = (contItem.AECUVA7JRJ23ZZS3ZSQTP2STU != '' && contItem.AECUVA7JRJ23ZZS3ZSQTP2STU != null) ? Decimal.valueOf(String.valueOf(contItem.AECUVA7JRJ23ZZS3ZSQTP2STU.replace(',',''))) : null;
                    upsertContItem.PricingUnit__c = (contItem.ZPRUNT2 != '' && contItem.ZPRUNT2 != null) ? contItem.ZPRUNT2 : '';
                    upsertContItem.MinimumVolume__c = (contItem.AECUVA7JRJ23ZZS3ZSQTP2Z5E != '' && contItem.AECUVA7JRJ23ZZS3ZSQTP2Z5E != null) ? Decimal.valueOf(String.valueOf(contItem.AECUVA7JRJ23ZZS3ZSQTP2Z5E.replace(',',''))) : null;
                    upsertContItem.MinimumVolumeUOM__c = (contItem.ZTARUNT != '' && contItem.ZTARUNT != null) ? contItem.ZTARUNT : '';
                    upsertContItem.MaximumVolume__c = (contItem.AECUVA7JRJ23ZZSM8YD1OXN0C != '' && contItem.AECUVA7JRJ23ZZSM8YD1OXN0C != null) ? Decimal.valueOf(String.valueOf(contItem.AECUVA7JRJ23ZZSM8YD1OXN0C.replace(',',''))) : null;
                    upsertContItem.ContractVolume__c = (contItem.AECUVA7JRJ23ZZ709XOJN5PYR != '' && contItem.AECUVA7JRJ23ZZ709XOJN5PYR != null) ? Decimal.valueOf(String.valueOf(contItem.AECUVA7JRJ23ZZ709XOJN5PYR.replace(',',''))) : null;
                    upsertContItem.ContractVolumeUOM__c = (contItem.A0TARGET_QU != '' && contItem.A0TARGET_QU != null) ? contItem.A0TARGET_QU : '';
                    upsertContItem.OrderQuantity__c = (contItem.AECUVA7JRJ23ZZS5WZ601YNPO != '' && contItem.AECUVA7JRJ23ZZS5WZ601YNPO != null) ? Decimal.valueOf(String.valueOf(contItem.AECUVA7JRJ23ZZS5WZ601YNPO.replace(',',''))) : null;
                    upsertContItem.SalesUnit__c = (contItem.A0SALES_UNIT != '' && contItem.A0SALES_UNIT != null) ? contItem.A0SALES_UNIT : '';
                    upsertContItem.Currency__c = (contItem.A0CURRENCY != '' && contItem.A0CURRENCY != null) ? contItem.A0CURRENCY : '';
                    upsertContItem.SalesDocumentItem__c = (contItem.A0S_ORD_ITEM != '' && contItem.A0S_ORD_ITEM != null) ? contItem.A0S_ORD_ITEM : '';
                    upsertContItem.LoadingStartDate__c = (contItem.ZLOADSTRD != '' && contItem.ZLOADSTRD != null) ? StringToDate(contItem.ZLOADSTRD) : null;
                    upsertContItem.LoadingEndDate__c = (contItem.ZLOADENDD != '' && contItem.ZLOADENDD != null) ? StringToDate(contItem.ZLOADENDD) : null;
                    upsertContItem.RejectStatus__c = (contItem.A0REJECTN_ST != '' && contItem.A0REJECTN_ST != null) ? contItem.A0REJECTN_ST : '';
                    upsertContItem.Status__c = (contItem.A0ITEM_DEL == 'X') ? 'Inactive' : 'Active';
                    upsertContItem.ContractFormNo__c = (contItem.ZFORM_NO != '' && contItem.ZFORM_NO != null) ? contItem.ZFORM_NO : '';
                    upsertContractItemList.add(upsertContItem);
                }
            }
            if(upsertContractItemList.size()> 0){
                Schema.SObjectField Key = C360_ContractLineItem__c.Fields.Key__c;
                resultList = Database.upsert(upsertContractItemList, Key, false);
                if(resultList.size() > 0){
                    List<String> IdList_suc = new List<String>();
                    List<String> errorMsg_List = new List<String>();
                    map<String,List<String>> errorMap = new map<String,List<String>>();
                    for (Integer idx = 0; idx < resultList.size(); idx++) {
                        if (resultList[idx].isSuccess()){
                            IdList_suc.add(resultList[idx].getId()); 
                        }else{
                            errorMsg_List = new List<String>();
                            for(Database.Error err : resultList[idx].getErrors()) {
                                errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                            errorMap.put(resultList[idx].getId(),errorMsg_List);
                        }
                    }
                    if(errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Contract Item Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(contractItems).abbreviate(131000);
                        log.Error_Message__c = 'Contract Item - '+ errorMap.keyset() +' : '+ errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Contract Item Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(contractItems).abbreviate(131000);
                        log.Error_Message__c = 'Contract Item - Success';
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }
        catch (Exception e) {
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated Contract Item Webservice';
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
    private static Date StringToDate(String dateString){
        if(dateString.length() != 8){
            return null;
        }
        List<String> dates = new List<String>();
        dates.add(dateString.left(4));
        dates.add(dateString.mid(4,2));
        dates.add(dateString.right(2));
        Date output;
        try{
            output = Date.valueOf(String.join(dates,'-'));
        }catch(System.TypeException ex) {output = null;}
        return output;
    }
}