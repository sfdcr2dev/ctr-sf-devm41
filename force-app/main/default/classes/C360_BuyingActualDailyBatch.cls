public without sharing class C360_BuyingActualDailyBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
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
        List<C360_BISalesOrg__mdt> salesOrgCust = [select Id,SalesOrganization__c,CustomerCodeFrom__c,CustomerCodeTo__c from C360_BISalesOrg__mdt];
        for(C360_BISalesOrg__mdt i : salesOrgCust){
            Database.executeBatch(new C360_BuyingActualDailyBatch(i.SalesOrganization__c,i.CustomerCodeFrom__c,i.CustomerCodeTo__c,yr,mth,dt),200);
        }
    }
    public C360_BuyingActualDailyBatch(String salesOrg,String custCodeFrom,String custCodeTo,String custYear,String custMonth,String custDate){
        this.salesOrg = '';
        this.custCodeFrom = custCodeFrom;
        this.custCodeTo =custCodeTo;
        this.custYear =custYear;
        this.custMonth =custMonth;
        this.custMonth =custDate;
    }
    public Iterable<Object> start(Database.BatchableContext BC){
        String respone = C360_CalloutBIService.calloutBI('BuyingDaily',this.salesOrg, this.custCodeFrom,this.custCodeTo,this.custYear,this.custMonth,this.custDate);
        Map<String,Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope) {
        List<C360_CalloutBIService.BuyingDaily> BuyingDailyList = (List<C360_CalloutBIService.BuyingDaily>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.BuyingDaily>.class);
        Map<String,String> MapSalesRep = C360_CalloutBIService.GetSalesRep();
        List<Database.upsertResult> BuyingDailyResultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_BuyingPerformanceDailyTOP__c> upBuyingDailyList = new List<C360_BuyingPerformanceDailyTOP__c>();
        list<String> accList = new list<String>();
        list<String> productList = new list<String>();
        string MissingSoldTo = 'MissingSoldTo = [';
        try{
            Id RecordTypeId = [select id from RecordType where DeveloperName = 'TXDailyPerformance'].Id;
            for(C360_CalloutBIService.BuyingDaily BuyingDaily : BuyingDailyList){
                if(BuyingDaily.ZCUSTMR != '' && BuyingDaily.ZCUSTMR != null){
                    accList.add(BuyingDaily.ZCUSTMR);
                }
                if(BuyingDaily.ZMATERIL != '' && BuyingDaily.ZMATERIL!= null){
                    productList.add(BuyingDaily.ZMATERIL);
                }
            }
            //=====Mapping Customer========================================
            list<Account> insertCustomerList = [select id,AccountNumber__c from Account where AccountNumber__c in:accList];
            Map<String,String> masterMap = new Map<String,String>();
            Map<String,String> customerMap = new Map<String,String>();
            for(Account custItem : insertCustomerList){
                customerMap.put(custItem .AccountNumber__c,custItem.id);
            }
            //=====Mapping Product========================================
            list<C360_Product__c> insertProductList = [select id, MaterialCode__c from C360_Product__c where MaterialCode__c in:productList];
            Map<String,String> ProductMap = new Map<String,String>();
            for(C360_Product__c prdItem : insertProductList){
                ProductMap.put(prdItem.MaterialCode__c, prdItem.id);
            }
            for(C360_CalloutBIService.BuyingDaily BuyingDaily : BuyingDailyList){
                C360_BuyingPerformanceDailyTOP__c upDaily = new C360_BuyingPerformanceDailyTOP__c();
                if(!String.isBlank(BuyingDaily.A0CALDAY) && !String.isBlank(BuyingDaily.A0SALESORG) && !String.isBlank(BuyingDaily.A0DISTR_CHAN) && !String.isBlank(BuyingDaily.A0DIVISION) && !String.isBlank(BuyingDaily.ZCUSTMR+BuyingDaily.ZMATERIL)){
                       if((customerMap.containskey(BuyingDaily.ZCUSTMR))==true){
                           upDaily.Customer__c = customerMap.get(BuyingDaily.ZCUSTMR);
                       }else{
                           upDaily.SoldToText__c = BuyingDaily.ZCUSTMR;
                           MissingSoldTo = MissingSoldTo + BuyingDaily.ZCUSTMR +',';
                       }
                       String BuyingDailyExtId = BuyingDaily.A0CALDAY+BuyingDaily.A0SALESORG+BuyingDaily.A0DISTR_CHAN+BuyingDaily.A0DIVISION+BuyingDaily.ZCUSTMR+BuyingDaily.ZMATERIL+BuyingDaily.A0SHIP_POINT+BuyingDaily.A0INCOTERMS;
                       //System.debug('==debug BuyingDailyExtId===>'+BuyingDailyExtId);
                       upDaily.RecordTypeId = RecordTypeId;
                       upDaily.Key__c = BuyingDailyExtId;
                       upDaily.BillingDate__c = StringToDate(BuyingDaily.A0CALDAY);
                       upDaily.DistributionChannel__c = BuyingDaily.A0DISTR_CHAN;
                       upDaily.Division__c = BuyingDaily.A0DIVISION;
                       upDaily.SalesGroup__c = BuyingDaily.ZCUSTMR_ZTSSGRP;
                       upDaily.SalesOrganization__c = BuyingDaily.A0SALESORG;
                       upDaily.Product__c = ProductMap.get(BuyingDaily.ZMATERIL);
                       upDaily.ProductNameText__c = BuyingDaily.ZMATERIL_ZSTPRDN;
                       upDaily.ProductGroup__c = BuyingDaily.ZMATERIL_ZSTPRDG;
                       upDaily.Salesmode__c = BuyingDaily.ZMATERIL_ZSTSALEMO;
                       upDaily.ShippingPoint__c = BuyingDaily.A0SHIP_POINT;
                       upDaily.BusinessUnit__c = BuyingDaily.ZMATERIL_ZBU_UNIT;
                       upDaily.CurrencyLocal__c = BuyingDaily.AECUVA7JRJ2401ME7YPN325UE_E;
                       upDaily.Incoterm__c = String.valueOf(BuyingDaily.A0INCOTERMS);
                       upDaily.Industry__c = BuyingDaily.ZCUSTMR_ZTSINDUST;
                       upDaily.Subindustry__c = BuyingDaily.ZCUSTMR_ZTSSINDUS;
                       upDaily.InterGroup__c = BuyingDaily.ZCUSTMR_ZTSGRP;
                       upDaily.PackType__c = BuyingDaily.ZMATERIL_ZSTPACKT;
                       upDaily.SupplyGroup__c = BuyingDaily.ZMATERIL_ZSTSUPG;
                       upDaily.DeliveryQuantity__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ25QC0XE3G63PIHC));
                       upDaily.SU__c = String.valueOf(BuyingDaily.AECUVA7JRJ25QC0XRNKG65SG0_E);
                       upDaily.NetValueLocal__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN33KEU));
                       upDaily.CurrencyLocal__c = String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN325UE_E);
                       upDaily.NetValueUSD__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN33QQE));
                       upDaily.COGS__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN36DJQ));
                       upDaily.FreightcostLocal__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN36Q6U));
                       upDaily.FreightcostUSD__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN36WIE));
                       upDaily.PocketmarginLocal__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN372TY));
                       upDaily.PocketmarginUSD__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN37S46));
                       upDaily.NetProfitLocal__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN38HEE));
                       upDaily.NetProfitUSD__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN396OM));
                       upDaily.LossGainfxLocal__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN39VYU));
                       upDaily.LossGainfxUSD__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN3A2AE));
                       upDaily.RevenueLocal__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ2401ME7YPN34YZA));
                       upDaily.RevenueUSD__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ25QCGW6Y8F55EU5));
                       if(BuyingDaily.ZCUSTMR_ZTSSGRP != null && BuyingDaily.ZCUSTMR_ZTSSGRP != ''){
                           upDaily.OwnerId = MapSalesRep.get(BuyingDaily.ZCUSTMR_ZTSSGRP);
                       }
                       upBuyingDailyList.add(upDaily);
                   }
            }
            if(MissingSoldTo.right(1)==','){
                MissingSoldTo = MissingSoldTo.Substring(0,MissingSoldTo.length()-1) + ']';
            }else{
                MissingSoldTo = MissingSoldTo + ']';
            }
            if(upBuyingDailyList.size()> 0){
                Schema.SObjectField BuyingDailyKey = C360_BuyingPerformanceDailyTOP__c.Fields.Key__c;
                BuyingDailyResultList = Database.upsert(upBuyingDailyList,BuyingDailyKey,false);
                if(BuyingDailyResultList.size() > 0){
                    List<String> BuyingActIdList_suc = new List<String>();
                    List<String> BuyingAct_errorMsg_List = new List<String>();
                    Map<String,List<String>> BuyingAct_errorMap = new Map<String,List<String>>();
                    for(Integer idx = 0; idx < BuyingDailyResultList.size();idx++){
                        if (BuyingDailyResultList[idx].isSuccess()){
                            BuyingActIdList_suc.add(BuyingDailyResultList[idx].getId());
                        }else{
                            BuyingAct_errorMsg_List = new List<String>();
                            for(Database.Error err : BuyingDailyResultList[idx].getErrors()){
                                BuyingAct_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                            BuyingAct_errorMap.put(BuyingDailyResultList[idx].getId(),BuyingAct_errorMsg_List);
                        }
                    }
                    if(BuyingAct_errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated BI-Buying Daily Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(BuyingDailyList).abbreviate(131000);
                        log.Error_Message__c = 'BI-Buying Daily - '+BuyingAct_errorMap.keyset()+' : '+BuyingAct_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated BI-Buying Daily Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(BuyingDailyList).abbreviate(131000);
                        log.Error_Message__c = MissingSoldTo;
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }catch(Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated BI-Buying Daily Webservice';
            log.Log_Type__c = 'Error';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c = JSON.serialize(BuyingDailyList).abbreviate(131000);
            log.Error_Message__c = e.getMessage()+ ' Line:'+e.getLineNumber();
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
            //system.debug('SOAPIntegration : ' + e.getMessage() + ' at line : ' + e.getLineNumber());
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
        }
    }
    public void finish(Database.BatchableContext BC) {}
    private static Date StringToDate(String dateString) {
        if(dateString.length() != 8) {return null;}
        List<String> dates = new List<String>();
        dates.add(dateString.left(4));
        dates.add(dateString.mid(4,2));
        dates.add(dateString.right(2));
        Date output;
        try{
            output = Date.valueOf(String.join(dates,'-'));
        }catch(System.TypeException ex) {
            output = null;
        }
        return output;
    }
}