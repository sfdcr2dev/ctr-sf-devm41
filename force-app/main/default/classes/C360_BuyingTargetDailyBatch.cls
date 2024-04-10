public without sharing class C360_BuyingTargetDailyBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
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
            Database.executeBatch(new C360_BuyingTargetDailyBatch(i.SalesOrganization__c,i.CustomerCodeFrom__c,i.CustomerCodeTo__c, yr,mth,dt),200);
        }
    }
    public C360_BuyingTargetDailyBatch(String salesOrg,String custCodeFrom,String custCodeTo,String custYear,String custMonth,String custDate){
        this.salesOrg = '';
        this.custCodeFrom = custCodeFrom;
        this.custCodeTo = custCodeTo;
        this.custYear = custYear;
        this.custMonth = custMonth;
        this.custDate = custDate;
    }
    public Iterable<Object> start(Database.BatchableContext BC){
        String respone = C360_CalloutBIService.calloutBI('BuyingTargetDaily',this.salesOrg, this.custCodeFrom,this.custCodeTo,this.custYear,this.custMonth,this.custDate);
        Map<String,Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope) {
        List<C360_CalloutBIService.BuyingTargetDaily> BuyingTargetDailyList = (List<C360_CalloutBIService.BuyingTargetDaily>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.BuyingTargetDaily>.class);
        Map<String,String> MapSalesRep = C360_CalloutBIService.GetSalesRep();
        List<Database.upsertResult> BuyingTargetDailyResultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_BuyingPerformanceDailyTOP__c> upBuyingDailyList = new List<C360_BuyingPerformanceDailyTOP__c>();
        list<String> accList = new list<String>();
        list<String> productList = new list<String>();
        string MissingCustomer = 'MissingCustomer = [';
        integer i = 0;
        try{
            Id RecordTypeId = [select id from RecordType where DeveloperName = 'TXTargetDailyPerformance'].Id;
            for(C360_CalloutBIService.BuyingTargetDaily BuyingDaily : BuyingTargetDailyList){
                if(BuyingDaily.ZCUSTMR != '' && BuyingDaily.ZCUSTMR != null){
                    accList.add(BuyingDaily.ZCUSTMR);
                }
                if(BuyingDaily.ZSTPRDN != '' && BuyingDaily.ZSTPRDN!= null){
                    productList.add(BuyingDaily.ZSTPRDN);
                }
            }
            //=====Mapping Customer========================================
            list<Account>insertCustomerList = [select id,AccountNumber__c from Account where AccountNumber__c in:accList];
            map<String,String>masterMap = new map<String,String>();
            map<String,String>customerMap = new map<String,String>();
            for(Account custItem : insertCustomerList ){
                customerMap.put(custItem .AccountNumber__c, custItem.id);
            }
            //====Mapping Product========================================
            list<C360_Product__c>insertProductList = [select id, MaterialCode__c from C360_Product__c where MaterialCode__c in:productList];
            map<String,String>ProductMap = new map<String,String>();
            for(C360_Product__c prdItem : insertProductList ){
                ProductMap.put(prdItem.MaterialCode__c, prdItem.id);
            }
            for(C360_CalloutBIService.BuyingTargetDaily BuyingDaily : BuyingTargetDailyList){
                //system.debug('BuyingDaily>> '+ BuyingDaily);
                C360_BuyingPerformanceDailyTOP__c upTargetDaily = new C360_BuyingPerformanceDailyTOP__c();
                if(!String.isBlank(BuyingDaily.A0CALDAY) && !String.isBlank(BuyingDaily.A0SALESORG) && !String.isBlank(BuyingDaily.A0DISTR_CHAN) && !String.isBlank(BuyingDaily.ZCUSTMR+BuyingDaily.ZSTPRDN)){
                       if((customerMap.containskey(BuyingDaily.ZCUSTMR))==true){
                           upTargetDaily.Customer__c = customerMap.get(BuyingDaily.ZCUSTMR);
                       }else{
                           upTargetDaily.SoldToText__c = BuyingDaily.ZCUSTMR;
                           MissingCustomer = MissingCustomer + BuyingDaily.ZCUSTMR +',';
                           i = i+1;
                       }
                       String BuyingDailyExtId = BuyingDaily.A0CALDAY+BuyingDaily.A0SALESORG+BuyingDaily.A0DISTR_CHAN+BuyingDaily.ZCUSTMR+BuyingDaily.ZSTPRDN;
                       upTargetDaily.RecordTypeId = RecordTypeId ;
                       upTargetDaily.Key__c = BuyingDailyExtId;
                       upTargetDaily.BillingDate__c = StringToDate(BuyingDaily.A0CALDAY);
                       upTargetDaily.SalesOrganization__c = BuyingDaily.A0SALESORG;
                       upTargetDaily.DistributionChannel__c = BuyingDaily.A0DISTR_CHAN;
                       upTargetDaily.SalesGroup__c = BuyingDaily.ZCUSTMR_ZTSSGRP;
                       upTargetDaily.Product__c = ProductMap.get(BuyingDaily.ZSTPRDN);
                       upTargetDaily.ProductNameText__c = BuyingDaily.ZSTPRDN;
                       upTargetDaily.Industry__c = BuyingDaily.ZCUSTMR_ZTSINDUST;
                       upTargetDaily.Subindustry__c = BuyingDaily.ZCUSTMR_ZTSSINDUS;
                       upTargetDaily.InterGroup__c = BuyingDaily.ZCUSTMR_ZTSGRP;
                       upTargetDaily.CPtargetVolume__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ25QC0Z3Y1734IOG));
                       upTargetDaily.CPtargetPocketMarginLocal__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ25QC0YS9KH2TBNT));
                       upTargetDaily.CPtargetPocketMarginUSD__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ25QCGYZPK22J2NZ));
                       upTargetDaily.CPtargetNetProfitLocal__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ25QC0YS9KH2U0Y1));
                       upTargetDaily.CPtargetNetProfitUSD__c = Decimal.valueOf(String.valueOf(BuyingDaily.AECUVA7JRJ25QC0YS9KH2UDL5));
                       upTargetDaily.SU__c = BuyingDaily.AECUVA7JRJ25QC0Z6U7BLCL36_E;
                       upTargetDaily.CurrencyLocal__c = BuyingDaily.AECUVA7JRJ25QC0YS9KH2UQ89_E;
                       if(BuyingDaily.ZCUSTMR_ZTSSGRP != null && BuyingDaily.ZCUSTMR_ZTSSGRP != ''){
                           upTargetDaily.OwnerId = MapSalesRep.get(BuyingDaily.ZCUSTMR_ZTSSGRP);
                       }
                    upBuyingDailyList.add(upTargetDaily);
                }
            }
            if(MissingCustomer.right(1)==','){
                MissingCustomer = 'Error '+i+' Item : ' + MissingCustomer.Substring(0,MissingCustomer.length()-1)+']';
            }else{
                MissingCustomer = MissingCustomer + ']';
            }if(upBuyingDailyList.size()> 0){
                Schema.SObjectField BuyingDailyKey = C360_BuyingPerformanceDailyTOP__c.Fields.Key__c;
                BuyingTargetDailyResultList = Database.upsert(upBuyingDailyList,BuyingDailyKey, false);
                if(BuyingTargetDailyResultList.size() > 0){
                    List<String>BuyingActIdList_suc = new List<String>();
                    List<String>BuyingAct_errorMsg_List = new List<String>();
                    map<String,List<String>>BuyingAct_errorMap = new map<String,List<String>>();
                    for(Integer idx = 0; idx < BuyingTargetDailyResultList.size(); idx++){
                        if(BuyingTargetDailyResultList[idx].isSuccess()){
                            BuyingActIdList_suc.add(BuyingTargetDailyResultList[idx].getId());
                        }else{
                            BuyingAct_errorMsg_List = new List<String>();
                            for(Database.Error err : BuyingTargetDailyResultList[idx].getErrors()){
                                BuyingAct_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                            BuyingAct_errorMap.put(BuyingTargetDailyResultList[idx].getId(),BuyingAct_errorMsg_List);
                        }
                    }
                    if(BuyingAct_errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated BI-Buying Daily Target Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(130000);
                        log.Error_Message__c = 'BI-Buying Daily - '+BuyingAct_errorMap.keyset()+' : '+BuyingAct_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated BI-Buying Daily Target Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(130000);
                        log.Error_Message__c = MissingCustomer;
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }catch(Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated BI-Buying Daily Target Webservice';
            log.Log_Type__c = 'Error';
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
        try{output = Date.valueOf(String.join(dates,'-'));
        }catch(System.TypeException ex) {output = null;}
        return output;
    }
}