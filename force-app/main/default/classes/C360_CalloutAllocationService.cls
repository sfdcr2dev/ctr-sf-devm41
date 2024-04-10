public without sharing class C360_CalloutAllocationService{
    private static Http http = null;
    private static String authorizeUsername = '';
    private static String authorizePassword = '';
    private static String monthlyLiftingEndpoint = '';
    private static String monthlyAllocationEndpoint = '';
    private static String monthlyAllocationTLBEndpoint = '';
    private static Blob headerValue;
    private static String authorizationHeader = '';
    private static DateTime yesterday;
    public static void initialize(){
        C360Integration__c c360Integration = C360Integration__c.getInstance();
        authorizeUsername = c360Integration.Allocation_AuthorizeUsername__c;
        authorizePassword = c360Integration.Allocation_AuthorizePassword__c;
        yesterday = (c360Integration.Yesterday__c != null) ? c360Integration.Yesterday__c : System.Today().addDays(-1);
        monthlyLiftingEndpoint = c360Integration.Allocation_EndpointLiftingMonthly__c+'year=' + yesterday.year()+'&Month=' + yesterday.month() +'&Username='+authorizeUsername+'&Password='+authorizePassword;
        monthlyAllocationEndpoint = c360Integration.Allocation_EndpointAllocationMonthly__c+'year=' + yesterday.year() +'&Month=' + yesterday.month() +'&Username='+authorizeUsername+'&Password='+authorizePassword;
        monthlyAllocationTLBEndpoint = c360Integration.AllocationEndpointAllocation_MonthlyTLB__c+'year=' + yesterday.year() +'&Month='+ yesterday.month() +'&Username='+authorizeUsername+'&Password='+authorizePassword;
        http = new Http();
    }
    public static String calloutLifting(String SalesOrganization){
        initialize();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(monthlyLiftingEndpoint+'&SalesOrganization='+SalesOrganization);
        request.setHeader('Accept', '*/*');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', authorizationHeader);
        request.setMethod('GET');
        request.setTimeout(120000);
        HttpResponse response = http.send(request);
        try{
        	response = http.send(request);//System.debug(response.getBody());
            return response.getBody();
        }catch(Exception e){//System.debug(System.LoggingLevel.ERROR,e.getmessage());
            return null;
        }
    }
    public static String calloutAllocation(String endpoint){
        initialize();
        String url;
        if(endpoint == 'TOP'){
            url = monthlyAllocationEndpoint;
        }else if(endpoint == 'TLB'){
            url = monthlyAllocationTLBEndpoint;}
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setHeader('Accept', '*/*');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', authorizationHeader);
        request.setMethod('GET');
        request.setTimeout(120000);
        HttpResponse response = http.send(request);
        try{
            response = http.send(request);//System.debug(response.getBody());
            return response.getBody();
        }catch(Exception e){//System.debug(System.LoggingLevel.ERROR,e.getmessage());
            return null;
        }
    }
    public static void callSyncBuying(){
        List<C360_AllocationSalesOrg__mdt> salesOrg =[select Id ,SalesOrganization__c from C360_AllocationSalesOrg__mdt];
        for(C360_AllocationSalesOrg__mdt i : salesOrg){
            syncLifting(i.SalesOrganization__c);
        }
    }
    @future(callout = true)
    public static void syncLifting(String SalesOrganization){
        Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(calloutLifting(SalesOrganization));
        List<Object> buyings = (List<Object>) results.get('saleDataLists');
        List<C360_BuyingPerformanceMonthlyTOP__c> inputs = new List<C360_BuyingPerformanceMonthlyTOP__c>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<Database.upsertResult> resultList = new List<Database.upsertResult>();
        List<C360_BuyingPerformanceMonthlyTOP__c> upsertList = new List<C360_BuyingPerformanceMonthlyTOP__c>();
        try{
            Id RecordTypeId = [select id from RecordType where DeveloperName = 'Lifting'].Id;
            Set<String> masterCusList = new Set<String>();
            Set<String> masterProdList = new Set<String>();
            Set<String> masterCodeList = new Set<String>();
            for(Object buying : buyings){
                Map<String, Object> input = (Map<String, Object>) buying;
                C360_BuyingPerformanceMonthlyTOP__c BPM = new C360_BuyingPerformanceMonthlyTOP__c();
                if(String.valueOf(input.get('AccountNumber'))!= null){
                    masterCusList.add(String.valueOf(input.get('AccountNumber')));
                }
                if(String.valueOf(input.get('ShipTo'))!= null){
                    masterCusList.add(String.valueOf(input.get('ShipTo')));
                }
                if(String.valueOf(input.get('ProductCode'))!= null){
                    masterProdList.add(String.valueOf(input.get('ProductCode')));
                }
                if(String.valueOf(input.get('ShipTo_Country'))!= null){
                    masterCodeList.add(String.valueOf(input.get('ShipTo_Country')));
                }
            }
            List<Account> sf_accList = [select AccountNumber__c,id from Account where AccountNumber__c IN:masterCusList];
            Map<String,String> sf_accMap = new map<String,String>();
            for(Account item : sf_accList){
                sf_accMap.put(item.AccountNumber__c, item.id);
            }
            List<C360_Product__c> sf_prodList = [select id, MaterialCode__c from C360_Product__c where MaterialCode__c IN:masterProdList];
            Map<String,String> sf_prodMap = new map<String,String>();
            for(C360_Product__c item : sf_prodList){
                sf_prodMap.put(item.MaterialCode__c, item.id);
            }
            List<Master_Map__c> sf_traZoneList = [select id, Code__c from Master_Map__c where Type__c in ('Country') and Code__c IN:masterCodeList];
            Map<String,String> masterMap = new map<String,String>();
            for(Master_Map__c item : sf_traZoneList){
                masterMap.put(item.Code__c, item.id);
            }
            string MissingShipTo = 'MissingShipTo = [';
            string MissingSoldTo = 'MissingSoldTo = [';
            for(Object buying : buyings){
                Map<String, Object> input = (Map<String, Object>) buying;
                C360_BuyingPerformanceMonthlyTOP__c BPM = new C360_BuyingPerformanceMonthlyTOP__c();
                BPM.Key__c = String.valueOf(input.get('Key'));
                BPM.Year__c = String.valueOf(input.get('Year'));
                BPM.Month__c = String.valueOf(input.get('Month'));
                BPM.Date__c = Date.newInstance(integer.valueOf(BPM.Year__c),integer.valueOf(BPM.Month__c), 1);
                BPM.SalesOrganization__c = String.valueOf(input.get('SalesOrganization'));
                BPM.DistributionChannel__c = String.valueOf(input.get('DistributionChannel'));
                BPM.Division__c = String.valueOf(input.get('division'));
                if((sf_accMap.containskey(String.valueOf(input.get('AccountNumber'))))==true){
                    BPM.Customer__c = sf_accMap.get(String.valueOf(input.get('AccountNumber')));
                }else{
                    BPM.Customer__c = null;
                    MissingSoldTo = MissingShipTo + String.valueOf(input.get('AccountNumber')) +',';
                }
                BPM.Division__c = String.valueOf(input.get('Division'));
                if((sf_accMap.containskey(String.valueOf(input.get('ShipTo'))))==true){
                    BPM.Shipto__c = sf_accMap.get(String.valueOf(input.get('ShipTo')));
                }else{
                    BPM.Shipto__c = null;
                    MissingShipTo = MissingShipTo + String.valueOf(input.get('ShipTo')) +',';
                }
                BPM.CustomerGroup__c = String.valueOf(input.get('customerGroup'));
                BPM.Product__c = (sf_prodMap.containskey(String.valueOf(input.get('ProductCode')))) ? sf_prodMap.get(String.valueOf(input.get('ProductCode'))) : null;
                BPM.ProductGroup__c = String.valueOf(input.get('ProductGroup'));
                BPM.ExRefineryPrice__c = (String.valueOf(input.get('ExRefineryPrice')) != '') ? Decimal.valueOf(String.valueOf(input.get('ExRefineryPrice'))) :null;
                BPM.WholesalePrice__c = (String.valueOf(input.get('WholesalePrice')) != '') ? Decimal.valueOf(String.valueOf(input.get('WholesalePrice'))) :null;
                BPM.NetValueIncLocal__c = (String.valueOf(input.get('NetValue_Local_Inc_Vat')) != '') ? Decimal.valueOf(String.valueOf(input.get('NetValue_Local_Inc_Vat'))) :null;
                BPM.VolumeLTS__c = (String.valueOf(input.get('QuantityLTS')) != '') ? Decimal.valueOf(String.valueOf(input.get('QuantityLTS'))) :null;
                BPM.VolumeKGS__c = (String.valueOf(input.get('ACTUAL_LOADING_KG')) != '') ? Decimal.valueOf(String.valueOf(input.get('ACTUAL_LOADING_KG'))) :null;
                BPM.VolumeLTS30__c = (String.valueOf(input.get('ACTUAL_LOADING_L30')) != '') ? Decimal.valueOf(String.valueOf(input.get('ACTUAL_LOADING_L30'))) :null;
                BPM.VolumeMTON__c = (String.valueOf(input.get('ACTUAL_LOADING_MTON')) != '') ? Decimal.valueOf(String.valueOf(input.get('ACTUAL_LOADING_MTON'))) :null;
                BPM.NetValueLocal__c = (String.valueOf(input.get('NetValueLocal')) != '') ? Decimal.valueOf(String.valueOf(input.get('NetValueLocal'))) :null;
                BPM.CurrencyLocal__c = String.valueOf(input.get('CurrencyLocal'));
                BPM.NetValueUSD__c = (String.valueOf(input.get('NetValueUSD')) != '') ? Decimal.valueOf(String.valueOf(input.get('NetValueUSD'))) :null;
                BPM.Volume__c = (String.valueOf(input.get('VolumeLifting')) != '') ? Decimal.valueOf(String.valueOf(input.get('VolumeLifting'))) :null;
                BPM.VolumeLifting__c = (String.valueOf(input.get('VolumeLifting')) != '') ? Decimal.valueOf(String.valueOf(input.get('VolumeLifting'))) :null;
                BPM.VolumeLiftingUnit__c = String.valueOf(input.get('VolumeLiftingUnitADD'));
                BPM.ShippingPoint__c = String.valueOf(input.get('DeliveryModeShippingpoint'));
                BPM.Plant__c = String.valueOf(input.get('Plant'));
                BPM.ShiptoCountry__c = (masterMap.containskey(String.valueOf(input.get('ShipTo_Country')))) ? masterMap.get(String.valueOf(input.get('ShipTo_Country'))) : null;
                BPM.ProductGroup2__c = String.valueOf(input.get('Allocation_Product_Group'));
                BPM.CustomerGroup2__c = String.valueOf(input.get('Allocation_Customer_Group'));
                BPM.VolumeAllocation__c = (String.valueOf(input.get('Allocation_Monthly_Volume')) != '') ? Decimal.valueOf(String.valueOf(input.get('Allocation_Monthly_Volume'))) :null;
                BPM.RecordTypeId = (RecordTypeId != null) ? RecordTypeId : '';
                upsertList.add(BPM);
            }
            if(MissingShipTo.right(1)==','){
                MissingShipTo = MissingShipTo.Substring(0,MissingShipTo.length()-1) + ']';}
            else{MissingShipTo = MissingShipTo + ']';}
            if(MissingSoldTo.right(1)==','){
                MissingSoldTo = MissingSoldTo.Substring(0,MissingSoldTo.length()-1) + ']';}
            else{MissingSoldTo = MissingSoldTo + ']';}
            if(upsertList.size()> 0){
                Schema.SObjectField Key = C360_BuyingPerformanceMonthlyTOP__c.Fields.Key__c;
                resultList = Database.upsert(upsertList, Key, false);
                if(resultList.size() > 0){
                    List<String> IdList_suc = new List<String>();
                    List<String> errorMsg_List = new List<String>();
                    Map<String,List<String>> errorMap = new Map<String,List<String>>();
                    for(Integer idx = 0; idx < resultList.size(); idx++) {
                        if(resultList[idx].isSuccess()) {
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
                        log.Integration_Name__c = 'C360 Replicated Lifting Buying Webservice';
                        log.Log_Type__c = 'Fail';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(buyings).abbreviate(131000);
                        log.Error_Message__c = ('Allocation Buying - '+ errorMap.keyset() +' : '+ errorMap.values()).abbreviate(32760);
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Lifting Buying Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(buyings).abbreviate(131000);
                        log.Error_Message__c = (MissingShipTo + ' && ' + MissingSoldTo).abbreviate(32200);
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }  
        }catch(Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Log_Type__c = 'Fail';
            log.Integration_Name__c = 'C360 Replicated Lifting Buying Webservice catch';
            log.Message_Type__c = 'Fail';
            log.Error_Message__c = JSON.serialize(results.get('message'));
            log.Response_Body__c = JSON.serialize(results).abbreviate(131000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
        }
    }
    @future(callout = true)
    public static void syncAllocation(String org){
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(calloutAllocation(org));
        String GetList = (org == 'TLB') ? 'AllocationVsLiftingTBL' : 'AllocationVsLiftings';
        List<Object> buyings = (List<Object>) results.get(GetList);
        List<C360_BuyingPerformanceMonthlyTOP__c> inputs = new List<C360_BuyingPerformanceMonthlyTOP__c>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<Database.upsertResult> resultList = new List<Database.upsertResult>();
        List<C360_BuyingPerformanceMonthlyTOP__c> upsertList = new List<C360_BuyingPerformanceMonthlyTOP__c>();
        //=====Mapping Product========================================
        list<C360_Product__c>insertProductList = [select id, MaterialCode__c from C360_Product__c];
        map<String,String>ProductMap = new map<String,String>();
        for(C360_Product__c prdItem : insertProductList){
            ProductMap.put(prdItem.MaterialCode__c, prdItem.id);
        }
        try{
            Id RecordTypeId = [select id from RecordType where DeveloperName = 'LiftingAllocation'].Id;
            Set<String> masterCusList = new Set<String>();
            Set<String> masterProdList = new Set<String>();
            Set<String> masterCodeList = new Set<String>();
            for(Object buying : buyings){
                Map<String, Object> input = (Map<String, Object>) buying;
                C360_BuyingPerformanceMonthlyTOP__c BPM = new C360_BuyingPerformanceMonthlyTOP__c();
            }
            for(Object buying : buyings){
                Map<String, Object> input = (Map<String, Object>) buying;
                C360_BuyingPerformanceMonthlyTOP__c BPM = new C360_BuyingPerformanceMonthlyTOP__c();
                BPM.Key__c = String.valueOf(input.get('Year')) + String.valueOf(input.get('Month')) + String.valueOf(input.get('SalesOrganization')) + String.valueOf(input.get('DC')) + String.valueOf(input.get('ProductCode')) + String.valueOf(input.get('CustomerGroup') + String.valueOf(input.get('SaleType')));
                BPM.Year__c = String.valueOf(input.get('Year'));
                BPM.Month__c = String.valueOf(input.get('Month'));
                BPM.Date__c = Date.newInstance(integer.valueOf(BPM.Year__c),integer.valueOf(BPM.Month__c), 1);
                BPM.SalesOrganization__c = String.valueOf(input.get('SalesOrganization'));
                BPM.TLBDistributionChannel__c = String.valueOf(input.get('DC'));
                if(org =='TOP'){
                    BPM.CustomerGroup2__c = String.valueOf(input.get('CustomerGroup'));
                    BPM.ProductGroup2__c = String.valueOf(input.get('ProductCode'));
                }else if(org =='TLB'){
                    BPM.CustomerTLBGroup__c = String.valueOf(input.get('CustomerGroup'));
                    BPM.Product__c = productMap.get(String.valueOf(input.get('ProductCode')));
                }
                BPM.TierType__c =String.valueOf(input.get('SaleType'));
                BPM.VolumeAllocation__c = (String.valueOf(input.get('VolumeMonthlyAllocation')) != '' && Decimal.valueOf(String.valueOf(input.get('VolumeMonthlyAllocation'))) != null) ? Decimal.valueOf(String.valueOf(input.get('VolumeMonthlyAllocation'))) : null;
                BPM.VolumeMTDAllocation__c = (String.valueOf(input.get('VolumeMTDAllocation')) != '' && Decimal.valueOf(String.valueOf(input.get('VolumeMTDAllocation'))) != null) ? Decimal.valueOf(String.valueOf(input.get('VolumeMTDAllocation'))) : null;
                BPM.VolumeMTDLifting__c = (String.valueOf(input.get('VolumeMTDLifting')) != '' && Decimal.valueOf(String.valueOf(input.get('VolumeMTDLifting'))) != null) ? Decimal.valueOf(String.valueOf(input.get('VolumeMTDLifting'))) : null;
                BPM.VolumeLiftingUnit__c = String.valueOf(input.get('VolumeUnit'));
                BPM.RecordTypeId = (RecordTypeId != null) ? RecordTypeId : '';
                upsertList.add(BPM);
            }
            if(upsertList.size()> 0){
                Schema.SObjectField Key = C360_BuyingPerformanceMonthlyTOP__c.Fields.Key__c;
                resultList = Database.upsert(upsertList, Key, false);
                if(resultList.size() > 0){
                    List<String> IdList_suc = new List<String>();
                    List<String> errorMsg_List = new List<String>();
                    Map<String,List<String>> errorMap = new Map<String,List<String>>();
                    for(Integer idx = 0; idx < resultList.size(); idx++){
                        if(resultList[idx].isSuccess()){
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
                        log.Integration_Name__c = 'C360 Replicated Allocation Buying '+org+' Webservice';
                        log.Log_Type__c = 'Fail';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(buyings).abbreviate(131000);
                        log.Error_Message__c = ('Allocation Buying - '+ errorMap.keyset() +' : '+ errorMap.values()).abbreviate(32760);
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Allocation Buying '+org+' Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(buyings).abbreviate(131000);
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }catch (Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Log_Type__c = 'Fail';
            log.Integration_Name__c = 'C360 Replicated Allocation Buying '+org+' Webservice catch';
            log.Message_Type__c = 'Fail';
            log.Error_Message__c = JSON.serialize(results.get('message'));
            log.Response_Body__c = JSON.serialize(results).abbreviate(131000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
        }
    }
}