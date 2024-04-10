public without sharing class C360_BuyingTargetMonthlyBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
    private String salesOrg;
    private String custCodeFrom;
    private String custCodeTo;
    private String custYear;
    private String custMonth;
    private String custDate;
    public static void getSalesOrgCustomer(){
        Date dat = System.today()-1;
        string dt = String.valueOf(dat);
        String yr = String.valueOf(dat.year());
        String mth = String.valueOf(dat.month());
        List<C360_BISalesOrg__mdt> salesOrgCust =[select Id ,SalesOrganization__c,CustomerCodeFrom__c,CustomerCodeTo__c from C360_BISalesOrg__mdt];
        for(C360_BISalesOrg__mdt i : salesOrgCust){
            Database.executeBatch(new C360_BuyingTargetMonthlyBatch(i.SalesOrganization__c,i.CustomerCodeFrom__c,i.CustomerCodeTo__c, yr, mth,dt),200);
        }
    }
    public C360_BuyingTargetMonthlyBatch(String salesOrg,String custCodeFrom,String custCodeTo, String custYear,String custMonth,String custDate){
        this.salesOrg = '';
        this.custCodeFrom = custCodeFrom;
        this.custCodeTo = custCodeTo;
        this.custYear = custYear;
        this.custMonth = custMonth;
        this.custDate = custDate;
    }
    public Iterable<Object> start(Database.BatchableContext BC) {
        String respone = C360_CalloutBIService.calloutBI('BuyingTarget',this.salesOrg, this.custCodeFrom,this.custCodeTo,this.custYear,this.custMonth,this.custDate);
        Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String,Object>) results.get('d')).get('results');
        //system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope){
        List<C360_CalloutBIService.BuyingTarget> BuyingActualList = (List<C360_CalloutBIService.BuyingTarget>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.BuyingTarget>.class);
        Map<String,String> MapSalesRep = C360_CalloutBIService.GetSalesRep();
        List<Database.upsertResult> BuyingActualResultList = new List<Database.upsertResult>();
        List<Application_Log__c>insertApplogList = new List<Application_Log__c>();
        List<C360_BuyingPerformanceMonthlyTOP__c> upBuyingActualList = new List<C360_BuyingPerformanceMonthlyTOP__c>();
        list<String> accList = new list<String>();
        try{
            Id RecordTypeId = [select id from RecordType where DeveloperName = 'TXTargetMonthlyPerformance'].Id;
            for(C360_CalloutBIService.BuyingTarget BuyingActual  : BuyingActualList){
                if(BuyingActual.ZCUSTMR != '' && BuyingActual.ZCUSTMR != null){
                    accList.add(BuyingActual.ZCUSTMR);
                }
            }
            //=====Mapping Customer========================================
            list<Account>insertCustomerList = [select id,AccountNumber__c from Account];
            map<String,String>masterMap = new map<String,String>();
            map<String,String>customerMap = new map<String,String>();
            for(Account custItem : insertCustomerList) {
                customerMap.put(custItem.AccountNumber__c, custItem.id);
            }
            //=====Mapping Product========================================
            list<C360_Product__c>insertProductList = [select id, MaterialCode__c from C360_Product__c];
            map<String,String>ProductMap = new map<String,String>();
            for(C360_Product__c prdItem : insertProductList){
                ProductMap.put(prdItem.MaterialCode__c,prdItem.id);
            }
            for(C360_CalloutBIService.BuyingTarget BuyingActual : BuyingActualList){
                C360_BuyingPerformanceMonthlyTOP__c upActual = new C360_BuyingPerformanceMonthlyTOP__c();
                String BuyingActualExtId = BuyingActual.A0CALYEAR+BuyingActual.A0CALMONTH2+BuyingActual.A0SALESORG+BuyingActual.A0DISTR_CHAN+BuyingActual.ZCUSTMR+BuyingActual.ZSTPRDN;
                //System.debug('==debug BuyingActualExtId===>'+BuyingActualExtId);
                upActual.RecordTypeId = RecordTypeId;
                upActual.Key__c = BuyingActualExtId;
                upActual.KeyTarget__c = BuyingActualExtId;
                upActual.Year__c = BuyingActual.A0CALYEAR;
                upActual.Month__c = BuyingActual.A0CALMONTH2;
                upActual.Date__c = Date.valueOf(String.valueOf(BuyingActual.A0CALYEAR+'-'+BuyingActual.A0CALMONTH2+'-01'));
                upActual.Customer__c = customerMap.get(BuyingActual.ZCUSTMR);
                upActual.CPtargetVolume__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2401GW2RH6KKP6F));
                upActual.CumCPTargetVolume__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2401GW65AITMKXV));
                upActual.CPtargetPocketMarginLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2401GWBUDGR3ETD));
                upActual.CPtargetPocketMarginUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2401GWBUDGR3RGH));
                upActual.CumCPtargetPocketMarginLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2401GWBUDGR3L4X));
                upActual.CumCPtargetPocketMarginUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2401GWBUDGR3XS1));
                upActual.DistributionChannel__c = BuyingActual.A0DISTR_CHAN;
                upActual.InterGroup__c = BuyingActual.ZCUSTMR_ZTSGRP;
                upActual.Industry__c = BuyingActual.ZCUSTMR_ZTSINDUST;
                upActual.Subindustry__c =BuyingActual.ZCUSTMR_ZTSSINDUS;
                upActual.CPtargetNetProfitLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2401GWBUDGR443L));
                upActual.CPtargetNetProfitUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2401GWBUDGR4AF5));
                upActual.CumCPtargetNetProfitLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2401GWBUDGR4GQP));
                upActual.CumCPtargetNetProfitUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2401GWBUDGR4N29));
                upActual.ProductNameText__c = BuyingActual.ZSTPRDN;
                upActual.SalesGroup__c = BuyingActual.ZCUSTMR_ZTSSGRP;
                upActual.SalesOrganization__c = BuyingActual.A0SALESORG;
                upActual.VolumeUnit__c = BuyingActual.A0UNIT_OF_WT;
                upActual.CurrencyLocal__c= BuyingActual.TCURR;
                if(BuyingActual.ZCUSTMR_ZTSSGRP != null && BuyingActual.ZCUSTMR_ZTSSGRP != ''){
                    upActual.OwnerId = MapSalesRep.get(BuyingActual.ZCUSTMR_ZTSSGRP);
                }
                upBuyingActualList.add(upActual);
            }
            if(upBuyingActualList.size()> 0){
                Schema.SObjectField BuyingActualKey = C360_BuyingPerformanceMonthlyTOP__c.Fields.Key__c;
                BuyingActualResultList = Database.upsert(upBuyingActualList, BuyingActualKey, false);
                if(BuyingActualResultList.size() > 0){
                    List<String>BuyingActIdList_suc = new List<String>();
                    List<String>BuyingAct_errorMsg_List = new List<String>();
                    map<String,List<String>>BuyingAct_errorMap = new map<String,List<String>>();
                    for (Integer idx = 0; idx < BuyingActualResultList.size(); idx++){
                        if(BuyingActualResultList[idx].isSuccess()){
                            BuyingActIdList_suc.add(BuyingActualResultList[idx].getId());
                        }else{
                            BuyingAct_errorMsg_List = new List<String>();
                            for(Database.Error err : BuyingActualResultList[idx].getErrors()){
                                BuyingAct_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                            BuyingAct_errorMap.put(BuyingActualResultList[idx].getId(),BuyingAct_errorMsg_List);
                        }
                    }
                    if(BuyingAct_errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated BI-Buying Target Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(130000);
                        log.Error_Message__c = 'BI-Buying Target - '+BuyingAct_errorMap.keyset()+' : '+BuyingAct_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated BI-Buying Target Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(130000);
                        log.Error_Message__c = 'BI-Buying Target - Success';
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
            
        }catch (Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated BI-Buying Target Webservice';
            log.Log_Type__c = 'Fail';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c = JSON.serialize(scope).abbreviate(130000);
            log.Error_Message__c = e.getMessage()+ ' Line:'+e.getLineNumber();
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
        }
    }
    public void finish(Database.BatchableContext BC) {}
}