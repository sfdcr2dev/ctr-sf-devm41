public without sharing class C360_BuyingActualMonthlyBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful {
    private String salesOrg;
    private String custCodeFrom;
    private String custCodeTo;
    private String custYear;
    private String custMonth;
    private String custDate;
    public static void getSalesOrg(){
        Date dat = System.today();
        String dt = String.valueOf(dat);
        String yr = String.valueOf(dat.year());
        String mth = String.valueOf(dat.month());
        List<C360_BISalesOrg__mdt> salesOrg =[select Id ,SalesOrganization__c,CustomerCodeFrom__c,CustomerCodeTo__c from C360_BISalesOrg__mdt];
        for(C360_BISalesOrg__mdt i : salesOrg){
            Database.executeBatch(new C360_BuyingActualMonthlyBatch(i.SalesOrganization__c,i.CustomerCodeFrom__c,i.CustomerCodeTo__c, yr, mth,dt),200);
        }
    }
    public C360_BuyingActualMonthlyBatch(String salesOrg,String custCodeFrom,String custCodeTo, String custYear,String custMonth,String custDate){
        this.salesOrg = salesOrg;
        this.custCodeFrom = custCodeFrom;
        this.custCodeTo =custCodeTo;
        this.custYear =custYear;
        this.custMonth =custMonth;
        this.custDate =custDate;
    }
    public Iterable<Object> start(Database.BatchableContext BC){
        String respone = C360_CalloutBIService.calloutBI('BuyingActual',this.salesOrg, this.custCodeFrom,this.custCodeTo, this.custYear,this.custMonth,this.custDate);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope) {
        List<C360_CalloutBIService.BuyingActual> BuyingActualList = (List<C360_CalloutBIService.BuyingActual>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.BuyingActual>.class);
        Map<String,String> MapSalesRep = C360_CalloutBIService.GetSalesRep();
        List<Database.upsertResult> BuyingActualResultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_BuyingPerformanceMonthlyTOP__c> upBuyingActualList = new List<C360_BuyingPerformanceMonthlyTOP__c>();
        list<String> accList = new list<String>();
        list<String> productList = new list<String>();
        list<String> targetKeyList = new list<String>();
        string MissingSoldTo = 'MissingSoldTo = [';
        try {
            Id RecordTypeId = [select id from RecordType where DeveloperName = 'TXMonthlyPerformance'].Id;
            for(C360_CalloutBIService.BuyingActual BuyingActual : BuyingActualList){
                if(BuyingActual.ZCUSTMR != '' && BuyingActual.ZCUSTMR != null){
                    accList.add(BuyingActual.ZCUSTMR);
                }
                if(BuyingActual.ZMATERIL != '' && BuyingActual.ZMATERIL!= null){
                    productList.add(BuyingActual.ZMATERIL);
                }
                String targetExtIdKey =BuyingActual.A0CALYEAR+BuyingActual.A0CALMONTH2+BuyingActual.A0SALESORG+BuyingActual.A0DISTR_CHAN+BuyingActual.ZCUSTMR+BuyingActual.ZMATERIL_ZSTPRDN;
                targetKeyList.add(targetExtIdKey);
            }
            //=====Mapping Customer========================================
            list<Account>insertCustomerList = [select id,AccountNumber__c from Account where AccountNumber__c in:accList];
            map<String,String>masterMap = new map<String,String>();
            map<String,String>customerMap = new map<String,String>();
            for(Account custItem : insertCustomerList ){
                customerMap.put(custItem.AccountNumber__c, custItem.id);
            }
            //=====Mapping Product========================================
            list<C360_Product__c>insertProductList = [select id, MaterialCode__c from C360_Product__c where MaterialCode__c in:productList];
            Map<String,String> ProductMap = new Map<String,String>();
            for(C360_Product__c prdItem : insertProductList ){
                ProductMap.put(prdItem.MaterialCode__c, prdItem.id);
            }
            //=====Mapping Actual Target========================================
            list<C360_BuyingPerformanceMonthlyTOP__c>actualTargetList = [select id,KeyTarget__c,CPtargetVolume__c,CumCPTargetVolume__c,CPtargetPocketMarginLocal__c,CPtargetPocketMarginUSD__c,CumCPtargetPocketMarginLocal__c,CumCPtargetPocketMarginUSD__c,CPtargetNetProfitLocal__c,CPtargetNetProfitUSD__c,CumCPtargetNetProfitLocal__c,CumCPtargetNetProfitUSD__c from C360_BuyingPerformanceMonthlyTOP__c where Customer__r.AccountNumber__c in:accList and RecordType.DeveloperName='TXTargetMonthlyPerformance'];
            Map<String,String> CPtargetVolumeMap = new Map<String,String>();
            Map<String,String> CumCPTargetVolumeMap = new Map<String,String>();
            Map<String,String> CPtargetPocketMarginLocalMap = new Map<String,String>();
            Map<String,String> CPtargetPocketMarginUSDMap = new Map<String,String>();
            Map<String,String> CumCPtargetPocketMarginLocalMap = new Map<String,String>();
            Map<String,String> CumCPtargetPocketMarginUSDMap = new Map<String,String>();
            Map<String,String> CPtargetNetProfitLocalMap = new Map<String,String>();
            Map<String,String> CPtargetNetProfitUSDMap = new Map<String,String>();
            Map<String,String> CumCPtargetNetProfitLocalMap = new Map<String,String>();
            Map<String,String> CumCPtargetNetProfitUSDMap = new Map<String,String>();
            for(C360_BuyingPerformanceMonthlyTOP__c targetItem : actualTargetList){
                CPtargetVolumeMap.put(targetItem.KeyTarget__c,String.valueOf(targetItem.CPtargetVolume__c));
                CumCPTargetVolumeMap.put(targetItem.KeyTarget__c,String.valueOf(targetItem.CumCPTargetVolume__c));
                CPtargetPocketMarginLocalMap.put(targetItem.KeyTarget__c,String.valueOf(targetItem.CPtargetPocketMarginLocal__c));
                CPtargetPocketMarginUSDMap.put(targetItem.KeyTarget__c,String.valueOf(targetItem.CPtargetPocketMarginUSD__c));
                CumCPtargetPocketMarginLocalMap.put(targetItem.KeyTarget__c,String.valueOf(targetItem.CumCPtargetPocketMarginLocal__c));
                CumCPtargetPocketMarginUSDMap.put(targetItem.KeyTarget__c,String.valueOf(targetItem.CumCPtargetPocketMarginUSD__c));
                CPtargetNetProfitLocalMap.put(targetItem.KeyTarget__c,String.valueOf(targetItem.CPtargetNetProfitLocal__c));
                CPtargetNetProfitUSDMap.put(targetItem.KeyTarget__c,String.valueOf(targetItem.CPtargetNetProfitUSD__c));
                CumCPtargetNetProfitLocalMap.put(targetItem.KeyTarget__c,String.valueOf(targetItem.CumCPtargetNetProfitLocal__c));
                CumCPtargetNetProfitUSDMap.put(targetItem.KeyTarget__c,String.valueOf(targetItem.CumCPtargetNetProfitUSD__c));
            }
            for(C360_CalloutBIService.BuyingActual BuyingActual : BuyingActualList){
                C360_BuyingPerformanceMonthlyTOP__c upActual = new C360_BuyingPerformanceMonthlyTOP__c();
                if((customerMap.containskey(BuyingActual.ZCUSTMR))==true){
                    upActual.Customer__c = customerMap.get(BuyingActual.ZCUSTMR);
                }else{
                    upActual.SoldToText__c = BuyingActual.ZCUSTMR;
                    MissingSoldTo = MissingSoldTo + BuyingActual.ZCUSTMR +',';
                }
                String BuyingActualExtId = BuyingActual.A0CALYEAR+BuyingActual.A0CALMONTH2+BuyingActual.A0SALESORG+BuyingActual.A0DISTR_CHAN+BuyingActual.A0DIVISION+BuyingActual.ZCUSTMR+BuyingActual.ZMATERIL+BuyingActual.A0SHIP_POINT+BuyingActual.A0INCOTERMS;
                String targetExtId =BuyingActual.A0CALYEAR+BuyingActual.A0CALMONTH2+BuyingActual.A0SALESORG+BuyingActual.A0DISTR_CHAN+BuyingActual.ZCUSTMR+BuyingActual.ZMATERIL_ZSTPRDN;
                //System.debug('==debug BuyingActualExtId===>'+BuyingActualExtId);
                upActual.RecordTypeId = RecordTypeId;
                upActual.Key__c = BuyingActualExtId;
                upActual.KeyTarget__c = targetExtId;
                upActual.Year__c = BuyingActual.A0CALYEAR;
                upActual.Month__c = BuyingActual.A0CALMONTH2;
                upActual.Date__c = Date.valueOf(String.valueOf(BuyingActual.A0CALYEAR+'-'+BuyingActual.A0CALMONTH2+'-01'));
                upActual.BusinessUnit__c = BuyingActual.ZMATERIL_ZBU_UNIT;
                upActual.COGS__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z58DJX1II5N));
                upActual.CumLastYearVolume__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z40JJI9GUNU));
                upActual.CumLYPocketmarginLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5B6DUIN1IP));
                upActual.CumLYPocketmarginUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5B6DUINQSX));
                upActual.CumPocketmarginLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5B6DUIMOVL));
                upActual.CumPocketmarginUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5B6DUINE5T));
                upActual.CumRevenueLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z6U7GKSHONA));
                upActual.CumRevenueUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z6U7GKSIDXI));
                upActual.CumVolume__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z4BWXV06LX9));
                upActual.CurrencyLocal__c = BuyingActual.TCURR;
                upActual.DistributionChannel__c = BuyingActual.A0DISTR_CHAN;
                upActual.Division__c = BuyingActual.A0DIVISION;
                upActual.FreightcostLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z58ZRQ9QV72));
                upActual.FreightcostUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z58ZRQ9R1IM));
                upActual.Incoterm__c = BuyingActual.A0INCOTERMS;
                upActual.Industry__c = BuyingActual.ZCUSTMR_ZTSINDUST;
                upActual.InterGroup__c = BuyingActual.ZCUSTMR_ZTSGRP;
                upActual.LastYearPocketmarginLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5B6DUIMV75));
                upActual.LastYearPocketmarginUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5B6DUINKHD));
                upActual.LastYearQuantity__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ25QBDBJ10AWMFD4));
                upActual.LastYearRevenueLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z6U7GKSI1AE));
                upActual.LastYearRevenueUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z6U7GKSIQKM));
                upActual.LossGainfxLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5I4R37YKYV));
                upActual.LossGainfxUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5I4R37YRAF));
                upActual.NetProfitLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5BUN4TSZU9));
                upActual.NetProfitUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5BUN4TT65T));
                upActual.NetValueLastYearLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z53KR09QQEY));
                upActual.NetValueLastYearUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z53KR09QWQI));
                upActual.NetValueLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z50JCYBQRLE));
                upActual.NetValueUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z51Q2SADDTJ));
                upActual.PackType__c = BuyingActual.ZMATERIL_ZSTPACKT;
                upActual.PocketmarginLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5B6DUIMIK1));
                upActual.PocketmarginUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z5B6DUIN7U9));
                upActual.VolumeUnit__c = BuyingActual.A0UNIT_OF_WT;
                upActual.Product__c = ProductMap.get(BuyingActual.ZMATERIL);
                upActual.ProductNameText__c = BuyingActual.ZMATERIL_ZSTPRDN;
                upActual.ProductGroup__c = BuyingActual.ZMATERIL_ZSTPRDG;
                upActual.RevenueLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z6U7GKSHIBQ));
                upActual.RevenueUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z6U7GKSI7LY));
                upActual.Salesmode__c = BuyingActual.ZMATERIL_ZSTSALEMO;
                upActual.SalesGroup__c = BuyingActual.ZCUSTMR_ZTSSGRP;
                upActual.SalesOrganization__c = BuyingActual.A0SALESORG;
                upActual.ShippingPoint__c = BuyingActual.A0SHIP_POINT;
                upActual.Subindustry__c = BuyingActual.ZCUSTMR_ZTSSINDUS;
                upActual.Subproductname__c = BuyingActual.ZMATERIL_ZTSSUPPRO;
                upActual.SupplyGroup__c = BuyingActual.ZMATERIL_ZSTSUPG;
                upActual.Volume__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ25QBDAHYYVW89JR));
                upActual.VolumeMTON__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ25QBDAHYYVW89JR));
                upActual.YTDRevenueLastYearLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z6U7GKSHUYU));
                upActual.YTDRevenueLastYearUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2400Z6U7GKSIK92));
                upActual.LastYearNetProfitUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ25QCDAL61W5LGRI));
                upActual.CumLYNetProfitUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ25QCDAL61W5LN32));
                upActual.CumNetProfitUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ25QCDAL61W5LAFY));
                upActual.LastYearMonthlyPocketmarginLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2406UQGA7YX6MXE));
                upActual.LastYearMonthlyPocketmarginUSD__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ2406UQGA7YX6T8Y));
                upActual.CumNetProfitLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ25QCDAL61W5KRHA));
                upActual.CumLYNetProfitLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ25QCDAL61W5L44E));
                upActual.LastYearNetProfitLocal__c = Decimal.valueOf(String.valueOf(BuyingActual.AECUVA7JRJ25QCDAL61W5KXSU));
                if(BuyingActual.ZCUSTMR_ZTSSGRP != null && BuyingActual.ZCUSTMR_ZTSSGRP != ''){
                    upActual.OwnerId = MapSalesRep.get(BuyingActual.ZCUSTMR_ZTSSGRP);
                }
                if(!String.isBlank(String.valueOf(CPtargetVolumeMap.get(targetExtId)))){
                    upActual.CPtargetVolume__c =  Decimal.valueOf(String.valueOf(CPtargetVolumeMap.get(targetExtId)));
                }else{upActual.CPtargetVolume__c = 0; } 
                if(!String.isBlank(String.valueOf(CumCPTargetVolumeMap.get(targetExtId)))){
                    upActual.CumCPTargetVolume__c = Decimal.valueOf(String.valueOf(CumCPTargetVolumeMap.get(targetExtId)));
                }else{upActual.CumCPTargetVolume__c =0;}		
                if(!String.isBlank(String.valueOf(CPtargetPocketMarginLocalMap.get(targetExtId)))){
                    upActual.CPtargetPocketMarginLocal__c = Decimal.valueOf(String.valueOf(CPtargetPocketMarginLocalMap.get(targetExtId)));
                }else{upActual.CPtargetPocketMarginLocal__c = 0;}
                if(!String.isBlank(String.valueOf(CPtargetPocketMarginUSDMap.get(targetExtId)))){
                    upActual.CPtargetPocketMarginUSD__c = Decimal.valueOf(String.valueOf(CPtargetPocketMarginUSDMap.get(targetExtId)));
                }else{upActual.CPtargetPocketMarginUSD__c =0;}
                if(!String.isBlank(String.valueOf(CumCPtargetPocketMarginLocalMap.get(targetExtId)))){
                    upActual.CumCPtargetPocketMarginLocal__c = Decimal.valueOf(String.valueOf(CumCPtargetPocketMarginLocalMap.get(targetExtId)));
                }else{upActual.CumCPtargetPocketMarginLocal__c = 0;}
                if(!String.isBlank(String.valueOf(CumCPtargetPocketMarginUSDMap.get(targetExtId)))){
                    upActual.CumCPtargetPocketMarginUSD__c = Decimal.valueOf(String.valueOf(CumCPtargetPocketMarginUSDMap.get(targetExtId)));
                }else{upActual.CumCPtargetPocketMarginUSD__c = 0;}
                if(!String.isBlank(String.valueOf(CPtargetNetProfitLocalMap.get(targetExtId)))){
                    upActual.CPtargetNetProfitLocal__c = Decimal.valueOf(String.valueOf(CPtargetNetProfitLocalMap.get(targetExtId)));
                }else{upActual.CPtargetNetProfitLocal__c = 0;}
                if(!String.isBlank(String.valueOf(CPtargetNetProfitUSDMap.get(targetExtId)))){
                    upActual.CPtargetNetProfitUSD__c = Decimal.valueOf(String.valueOf(CPtargetNetProfitUSDMap.get(targetExtId)));
                }else{upActual.CPtargetNetProfitUSD__c= 0;}
                if(!String.isBlank(String.valueOf(CumCPtargetNetProfitLocalMap.get(targetExtId)))){
                    upActual.CumCPtargetNetProfitLocal__c = Decimal.valueOf(String.valueOf(CumCPtargetNetProfitLocalMap.get(targetExtId)));
                }else{upActual.CumCPtargetNetProfitLocal__c = 0;}
                if(!String.isBlank(String.valueOf(CumCPtargetNetProfitUSDMap.get(targetExtId)))){
                    upActual.CumCPtargetNetProfitUSD__c = Decimal.valueOf(String.valueOf(CumCPtargetNetProfitUSDMap.get(targetExtId)));
                }else{upActual.CumCPtargetNetProfitUSD__c = 0;}
                upBuyingActualList.add(upActual);
            }
            if(MissingSoldTo.right(1)==','){
                MissingSoldTo = MissingSoldTo.Substring(0,MissingSoldTo.length()-1) + ']';
            }else{
                MissingSoldTo = MissingSoldTo + ']';
            }
            if(upBuyingActualList.size()> 0){
                Schema.SObjectField BuyingActualKey = C360_BuyingPerformanceMonthlyTOP__c.Fields.Key__c;
                BuyingActualResultList = Database.upsert(upBuyingActualList,BuyingActualKey,false);
                if(BuyingActualResultList.size() > 0){
                    List<String> BuyingActIdList_suc = new List<String>();
                    List<String> BuyingAct_errorMsg_List = new List<String>();
                    Map<String,List<String>> BuyingAct_errorMap = new Map<String,List<String>>();
                    for (Integer idx = 0; idx < BuyingActualResultList.size();idx++){
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
                        log.Integration_Name__c = 'C360 Replicated BI-BuyingMonthly Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
                        log.Error_Message__c = 'BI-BuyingMonthly - '+BuyingAct_errorMap.keyset()+' : '+BuyingAct_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated BI-BuyingMonthly Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
                        log.Error_Message__c = MissingSoldTo;
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }
        catch (Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated BI-BuyingMonthly Webservice';
            log.Log_Type__c = 'Error';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
            log.Error_Message__c = e.getMessage()+ ' Line:'+e.getLineNumber();
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
        }
    }
    public void finish(Database.BatchableContext BC){}
}