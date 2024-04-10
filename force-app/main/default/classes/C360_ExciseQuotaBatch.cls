public without sharing class C360_ExciseQuotaBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
    public Iterable<Object> start(Database.BatchableContext BC){
        String respone = C360_CalloutBIService.calloutBI('Excise');
        Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String,Object>) results.get('d')).get('results');
        //system.debug('Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope) {
        List<C360_CalloutBIService.ExciseQuota> excises = (List<C360_CalloutBIService.ExciseQuota>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.ExciseQuota>.class);
        List<Database.upsertResult> resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_ExciseQuota__c> upsertExcList = new List<C360_ExciseQuota__c>();
        List<String> keyList = new List<String>();
        String MissingSoldTo = 'MissingSoldTo = [';
        String MissingShipTo = 'MissingShipTo = [';
        integer i = 0;
        integer j = 0;
        try{
            List<String> masterCodeList = new List<String>();
            Set<String> accSet = new Set<String>();
            for(C360_CalloutBIService.ExciseQuota excQuo : excises){
                if(excQuo.A0CUSTOMER != '' && excQuo.A0CUSTOMER != null){
                    accSet.add(excQuo.A0CUSTOMER);
                }
                if(excQuo.A0SHIP_TO != '' && excQuo.A0SHIP_TO != null){
                    accSet.add(excQuo.A0SHIP_TO);
                }
                if(excQuo.A0MATL_GROUP != '' && excQuo.A0MATL_GROUP != null){
                    masterCodeList.add(excQuo.A0MATL_GROUP);
                }
            }
            List<Account> sf_accList = [select AccountNumber__c,id from Account where AccountNumber__c IN:accSet];
            Map<String,String> sf_accMap = new map<String,String>();
            for(Account item : sf_accList){
                sf_accMap.put(item.AccountNumber__c, item.id);
            }
            List<Master_Map__c> sf_matGroupList = [select id, Code__c from Master_Map__c where Type__c = 'Material Group' and Code__c IN:masterCodeList];
            Map<String,String> sf_matGroupMap = new map<String,String>();
            for(Master_Map__c item : sf_matGroupList){
                sf_matGroupMap.put(item.Code__c, item.id);
            }
            for(C360_CalloutBIService.ExciseQuota excQuo : excises){
                C360_ExciseQuota__c upsertExc = new C360_ExciseQuota__c();
                if(sf_accMap.containskey(excQuo.A0CUSTOMER)){
                    upsertExc.Key__c = excQuo.A0CUSTOMER + excQuo.A0SALESORG + excQuo.A0DISTR_CHAN + excQuo.A0SHIP_TO + excQuo.A0MATL_GROUP + excQuo.ZEXCISTYP + excQuo.ZEXCIS_NO + excQuo.A0DATEFROM + excQuo.A0DATETO;
                    if(excQuo.A0CUSTOMER != null && excQuo.A0CUSTOMER != ''){
                        upsertExc.CompanyName__c = (sf_accMap.containskey(excQuo.A0CUSTOMER)) ? sf_accMap.get(excQuo.A0CUSTOMER) : null;
                    }else{
                        upsertExc.CompanyName__c = null;
                    }
                    upsertExc.SalesOrganization__c = (excQuo.A0SALESORG != '' && excQuo.A0SALESORG != null) ? excQuo.A0SALESORG : '';
                    upsertExc.DistributionChannel__c = (excQuo.A0DISTR_CHAN != '' && excQuo.A0DISTR_CHAN != null) ? excQuo.A0DISTR_CHAN : '';
                    if(excQuo.A0SHIP_TO != null && excQuo.A0SHIP_TO != ''){
                        upsertExc.Shiptoparty__c = (sf_accMap.containskey(excQuo.A0SHIP_TO))? sf_accMap.get(excQuo.A0SHIP_TO) : null;
                    }else{
                        upsertExc.Shiptoparty__c = null;
                        MissingShipTo = MissingShipTo + excQuo.A0SHIP_TO +',';
                        j = j + 1;
                    }
                    upsertExc.MaterialGroupText__c = (excQuo.A0MATL_GROUP != '' && excQuo.A0MATL_GROUP != null) ? excQuo.A0MATL_GROUP : '';
                    if(excQuo.A0MATL_GROUP != null && excQuo.A0MATL_GROUP != ''){
                        upsertExc.MaterialGroup__c = (sf_matGroupMap.containskey(excQuo.A0MATL_GROUP)) ? sf_matGroupMap.get(excQuo.A0MATL_GROUP) : null;
                    }else{
                        upsertExc.MaterialGroup__c = null;
                    }
                    upsertExc.UsageIndicator__c = (excQuo.ZEXCISTYP != '' && excQuo.ZEXCISTYP != null) ? excQuo.ZEXCISTYP : '';
                    upsertExc.Name = (excQuo.ZEXCIS_NO != '' && excQuo.ZEXCIS_NO != null) ? excQuo.ZEXCIS_NO : '';
                    upsertExc.PeriodFrom__c = (excQuo.A0DATEFROM != '' && excQuo.A0DATEFROM != null) ? StringToDate(excQuo.A0DATEFROM) : null;
                    upsertExc.ExpiryDate__c = (excQuo.A0DATETO != '' && excQuo.A0DATETO != null) ? StringToDate(excQuo.A0DATETO) : null;
                    upsertExc.ApprovedDate__c = (excQuo.ZEXCAPPV != '' && excQuo.ZEXCAPPV != null) ? StringToDate(excQuo.ZEXCAPPV) : null;
                    upsertExc.VolumeinExciseDocument__c = (excQuo.AECUVA7JRJ25Q71LLC8O6XSFG != '' && excQuo.AECUVA7JRJ25Q71LLC8O6XSFG != null) ? Decimal.valueOf(String.valueOf(excQuo.AECUVA7JRJ25Q71LLC8O6XSFG.replace(',',''))) : null;
                    upsertExc.VolumeinExciseDocumentUnit__c = (excQuo.A0BASE_UOM != '' && excQuo.A0BASE_UOM != null) ? excQuo.A0BASE_UOM : '';
                    upsertExc.Status__c = (excQuo.ZEXCST == 'X')? 'Inactive' : 'Active';
                    upsertExc.Date__c = (excQuo.A0ERDAT != '' && excQuo.A0ERDAT != null) ? StringToDate(excQuo.A0ERDAT) : null;
                    upsertExcList.add(upsertExc);
                }else{
                    MissingSoldTo = MissingSoldTo + excQuo.A0CUSTOMER +',';
                    i = i + 1;
                }
            }
            if(MissingSoldTo.right(1)==','){
                MissingSoldTo = 'Error ' +i+ ' Item : ' + MissingSoldTo.Substring(0,MissingSoldTo.length()-1)+']';
            }else{
                MissingSoldTo = MissingSoldTo + ']';
            }
            if(MissingShipTo.right(1)==','){
                MissingShipTo = 'Error ' +j+ ' Item : ' + MissingShipTo.Substring(0,MissingShipTo.length()-1)+']';
            }else{
                MissingShipTo = MissingShipTo + ']';
            }
            if(upsertExcList.size()> 0){
                Schema.SObjectField Key = C360_ExciseQuota__c.Fields.Key__c;
                resultList = Database.upsert(upsertExcList, Key, false);
                if(resultList.size() > 0){
                    List<String> accIdList_suc = new List<String>();
                    List<String> acc_errorMsg_List = new List<String>();
                    Map<String,List<String>> acc_errorMap = new Map<String,List<String>>();
                    for(Integer idx = 0; idx < resultList.size(); idx++){
                        if(resultList[idx].isSuccess()){
                            accIdList_suc.add(resultList[idx].getId());
                        }else{
                            acc_errorMsg_List = new List<String>();
                            for(Database.Error err : resultList[idx].getErrors()){
                                acc_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                            acc_errorMap.put(resultList[idx].getId(),acc_errorMsg_List);
                        }
                    }
                    if(acc_errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated ExciseQuota Webservice';
                        log.Log_Type__c = 'Fail';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(excises).abbreviate(131000);
                        log.Error_Message__c = 'ExciseQuota - '+acc_errorMap.keyset()+' : '+acc_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated ExciseQuota Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(excises).abbreviate(131000);
                        log.Error_Message__c = (MissingSoldTo + ' | ' + MissingShipTo).abbreviate(131000);
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }
        catch (Exception e) {
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated ExciseQuota Webservice';
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
        }catch(System.TypeException ex){output = null;}
        return output;
    }
}