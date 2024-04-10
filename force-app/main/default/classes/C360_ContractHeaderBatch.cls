public without sharing class C360_ContractHeaderBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
    public Iterable<Object> start(Database.BatchableContext BC){
        String respone = C360_CalloutBIService.calloutBI('Contract');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug('Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope){
        List<C360_CalloutBIService.Contract> contracts = (List<C360_CalloutBIService.Contract>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.Contract>.class);
        List<Database.upsertResult> resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_Contract__c> upsertContractList = new List<C360_Contract__c>();
        List<String> contractKeyList = new List<String>();
        try{
            Set<String> masterCodeList = new Set<String>();
            Set<String> masterDocTypeCodeList = new Set<String>();
            Set<String> accSet = new Set<String>();
            for(C360_CalloutBIService.Contract contract : contracts){
                if(contract.A0SOLD_TO != '' && contract.A0SOLD_TO != null){
                    accSet.add(contract.A0SOLD_TO);
                }
                if(contract.A0SHIP_TO != '' && contract.A0SHIP_TO != null){
                    accSet.add(contract.A0SHIP_TO);
                }
                if(contract.ZTPMNTTRM != '' && contract.ZTPMNTTRM != null){
                    masterCodeList.add(contract.ZTPMNTTRM);
                }
                if(contract.ZSALDTYPE != '' && contract.ZSALDTYPE != null){
                    masterDocTypeCodeList.add(contract.ZSALDTYPE);
                }
            }
            List<Account> sf_accList = [select AccountNumber__c,id from Account where AccountNumber__c IN:accSet];
            Map<String,String> sf_accMap = new map<String,String>();
            for(Account item : sf_accList){
                sf_accMap.put(item.AccountNumber__c, item.id);
            }
            List<Master_Map__c> sf_matGroupList = [select id, Code__c from Master_Map__c where Type__c = 'Payment Term' and Code__c IN:masterCodeList];
            Map<String,String> sf_matGroupMap = new map<String,String>();
            for(Master_Map__c item : sf_matGroupList){
                sf_matGroupMap.put(item.Code__c, item.id);
            }
            List<Master_Map__c> sf_docTypeList = [SELECT id, Code__c from Master_Map__c where Type__c = 'Sales Document Type' and Code__c IN:masterDocTypeCodeList];
            Map<String,String> sf_docTypeMap = new map<String,String>();
            for(Master_Map__c item : sf_docTypeList){
                sf_docTypeMap.put(item.Code__c, item.id);
            }
            for(C360_CalloutBIService.Contract contract : contracts){
                C360_Contract__c upsertCont = new C360_Contract__c();
                if(contract.A0DOC_NUMBER != '' && contract.A0DOC_NUMBER != null){
                    upsertCont.DocumentNumber__c = contract.A0DOC_NUMBER;
                    contractKeyList.add(contract.A0DOC_NUMBER);
                }else{upsertCont.DocumentNumber__c = '';}
                upsertCont.SalesOrganization__c = (contract.A0SALESORG != '' && contract.A0SALESORG != null) ? contract.A0SALESORG : '';
                upsertCont.DistributionChannel__c = (contract.A0DISTR_CHAN != '' && contract.A0DISTR_CHAN != null) ? contract.A0DISTR_CHAN : '';
                upsertCont.Division__c = (contract.A0DIVISION != '' && contract.A0DIVISION != null) ? contract.A0DIVISION : '';
                if(contract.A0SOLD_TO != null && contract.A0SOLD_TO != ''){
                    upsertCont.SoldTo__c = (sf_accMap.containskey(contract.A0SOLD_TO))? sf_accMap.get(contract.A0SOLD_TO) : null;
                }else{upsertCont.SoldTo__c = null;}
                if(contract.A0SHIP_TO != null && contract.A0SHIP_TO != ''){
                    upsertCont.ShipTo__c = (sf_accMap.containskey(contract.A0SHIP_TO))? sf_accMap.get(contract.A0SHIP_TO) : null;
                }else{upsertCont.ShipTo__c = null;}
                upsertCont.PONumber__c = (contract.ZPO_NUM != '' && contract.ZPO_NUM != null) ? contract.ZPO_NUM : '';
                upsertCont.PODate__c = (contract.ZPODATE != '' && contract.ZPODATE != null) ? StringToDate(contract.ZPODATE) : null;
                if(contract.ZSALDTYPE != null && contract.ZSALDTYPE != ''){
                    upsertCont.SalesDocumentType__c = (sf_docTypeMap.containskey(contract.ZSALDTYPE)) ? sf_docTypeMap.get(contract.ZSALDTYPE) : null;
                }else{upsertCont.SalesDocumentType__c = null;}
                upsertCont.ContractStartDate__c = (contract.A0DATEFROM != '' && contract.A0DATEFROM != null) ? StringToDate(contract.A0DATEFROM) : null;
                upsertCont.ContractEndDate__c = (contract.A0DATETO != '' && contract.A0DATETO != null) ? StringToDate(contract.A0DATETO) : null;
                upsertCont.PricingDate__c = (contract.A0PRICE_DATE != '' && contract.A0PRICE_DATE != null) ? StringToDate(contract.A0PRICE_DATE) : null;
                upsertCont.ShippingCondition__c = (contract.A0SHIP_COND != '' && contract.A0SHIP_COND != null) ? contract.A0SHIP_COND : '';
                upsertCont.ContractType__c = (contract.A0SALES_GRP != '' && contract.A0SALES_GRP != null) ? contract.A0SALES_GRP : '';
                upsertCont.Description__c = (contract.ZFORMDT != '' && contract.ZFORMDT != null) ? contract.ZFORMDT : '';
                if(contract.ZTPMNTTRM != null && contract.ZTPMNTTRM != ''){
                    upsertCont.PaymentTerm__c = (sf_matGroupMap.containskey(contract.ZTPMNTTRM)) ? sf_matGroupMap.get(contract.ZTPMNTTRM) : null;
                }else{upsertCont.PaymentTerm__c = null;}
                upsertCont.ComXID__c = (contract.ZCXROWID != '' && contract.ZCXROWID != null) ? contract.ZCXROWID : '';
                upsertCont.Status__c = (contract.A0HEADER_DEL == 'X') ? 'Inactive' : 'Active';
                upsertContractList.add(upsertCont);
            }
            if(upsertContractList.size()> 0){
                Schema.SObjectField contKey = C360_Contract__c.Fields.DocumentNumber__c;
                resultList = Database.upsert(upsertContractList, contKey, false);
                if(resultList.size() > 0){
                    List<String> IdList_suc = new List<String>();
                    List<String> errorMsg_List = new List<String>();
                    map<String,List<String>> errorMap = new map<String,List<String>>();
                    for (Integer idx = 0; idx < resultList.size(); idx++){
                        if (resultList[idx].isSuccess()){
                            IdList_suc.add(resultList[idx].getId());
                        }else{
                            errorMsg_List = new List<String>();
                            for(Database.Error err : resultList[idx].getErrors()){
                                errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                            errorMap.put(resultList[idx].getId(),errorMsg_List);
                        }
                    }
                    if(errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Contract Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(Contracts).abbreviate(131000);
                        log.Error_Message__c = 'Contract - '+ errorMap.keyset() +' : '+ errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Contract Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(Contracts).abbreviate(131000);
                        log.Error_Message__c = 'Contract - Success';
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }
        catch (Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated Contract Webservice';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
        }
    }
    public void finish(Database.BatchableContext BC){
        C360_ContractItemBatch c = new C360_ContractItemBatch();
        Id batchId = Database.executeBatch(c,200);
    }
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
            output = Date.valueOf(String.join(dates, '-'));
        }catch(System.TypeException ex) {output = null;}
        return output;
    }
}