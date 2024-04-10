public without sharing class C360_productSalesareaBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
    public Iterable<Object> start(Database.BatchableContext BC) {
        String respone = C360_CalloutBIService.calloutBI('ProductArea');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope){
        List<C360_CalloutBIService.prdSalesarea> ProductAreaList = (List<C360_CalloutBIService.prdSalesarea>) JSON.deserialize(JSON.serialize(scope),List<C360_CalloutBIService.prdSalesarea>.class);
        List<Database.upsertResult> productArea_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_ProductSalesArea__c> upsertProductAreaList = new List<C360_ProductSalesArea__c>();
        List<String> productList = new List<String>();
        try{
            for(C360_CalloutBIService.prdSalesarea prdSalesarea : ProductAreaList){
                productList.add(prdSalesarea.A0MAT_SALES);
            }
            //=====Mapping Product=============================
            List<C360_Product__c> insertProductList = [select id, MaterialCode__c from C360_Product__c Where MaterialCode__c in:(productList)];
            Map<String,String> ProductMap = new Map<String,String>();
            for(C360_Product__c prdItem : insertProductList ){
                ProductMap.put(prdItem.MaterialCode__c, prdItem.id);
            }
            //===End====Mapping Product Master=============================
            for(C360_CalloutBIService.prdSalesarea prdSalesarea : ProductAreaList){
                C360_ProductSalesArea__c upsertProductArea = new C360_ProductSalesArea__c();
                if(prdSalesarea.A0MAT_SALES != '' && prdSalesarea.A0MAT_SALES != null){
                    if(productMap.get(prdSalesarea.A0MAT_SALES) != '' && productMap.get(prdSalesarea.A0MAT_SALES) != null){
                        upsertProductArea.Product__c = productMap.get(prdSalesarea.A0MAT_SALES);
                        if(prdSalesarea.A0SALESORG != '' && prdSalesarea.A0SALESORG != null && prdSalesarea.A0DISTR_CHAN != '' && prdSalesarea.A0DISTR_CHAN != null){
                            upsertProductArea.Name = prdSalesarea.A0MAT_SALES +' '+ prdSalesarea.A0SALESORG +' '+ prdSalesarea.A0DISTR_CHAN;
                            String prdSalesareaExtId = prdSalesarea.A0MAT_SALES + prdSalesarea.A0SALESORG + prdSalesarea.A0DISTR_CHAN;
                            upsertProductArea.Key__c =prdSalesareaExtId;
                        }
                        upsertProductArea.SalesOrganization__c = prdSalesarea.A0SALESORG;
                        upsertProductArea.DistributionChannel__c = prdSalesarea.A0DISTR_CHAN;
                        upsertProductArea.Plant__c = prdSalesarea.A0MAT_SALES_ZDWERK;
                        if(prdSalesarea.A0DEL_FLAG != '' && prdSalesarea.A0DEL_FLAG != null){
                            upsertProductArea.MarkForDelete__c = true;
                        }else{
                            upsertProductArea.MarkForDelete__c = False;
                        }
                        upsertProductAreaList.add(upsertProductArea);
                    }
                }
            }
            if(upsertProductAreaList.size()> 0){
                Schema.SObjectField ProductAreaKey = C360_ProductSalesArea__c.Fields.Key__c;
                ProductArea_resultList = Database.upsert(upsertProductAreaList, ProductAreaKey, false);
                if(ProductArea_resultList.size() > 0){
                    List<String> ProductIdList_suc = new List<String>();
                    List<String> ProductArea_errorMsg_List = new List<String>();
                    Map<String,List<String>> ProductArea_errorMap = new Map<String,List<String>>();
                    for(Integer idx = 0; idx < ProductArea_resultList.size(); idx++){
                        if(ProductArea_resultList[idx].isSuccess()){
                            ProductIdList_suc.add(ProductArea_resultList[idx].getId());
                        }else{
                            ProductArea_errorMsg_List = new List<String>();
                            for(Database.Error err : ProductArea_resultList[idx].getErrors()){
                                ProductArea_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                        }
                        ProductArea_errorMap.put(ProductArea_resultList[idx].getId(),ProductArea_errorMsg_List);
                    }
                    if(ProductArea_errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated ProductSalesArea Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
                        log.Error_Message__c = 'ProductSalesArea - '+ProductArea_errorMap.keyset()+' : '+ProductArea_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated ProductSalesArea Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
                        log.Error_Message__c = 'ProductSalesArea - Success';
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
            Map<String,Set<String>> MapSalesOrgIdList = getProductSalesareaMap();
            list<C360_Product__c> mtProductList = [select id,MaterialCode__c from C360_Product__c Where MaterialCode__c in:(productList)];
            List<C360_Product__c> upsertProductList = new List<C360_Product__c>();
            for(C360_Product__c prdItem : mtProductList ){
                C360_Product__c upsertProduct = new C360_Product__c();upsertProduct.id = prdItem.id;
                upsertProductList.add(upsertProduct);
            }
            if(upsertProductList.size()>0){
                update upsertProductList;
            }
        }catch (Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated ProductSalesAre Webservice';
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
    public static string getProductSalesarea(string productId){
        List<string> prodId= new List<string>();
        prodId.add(productId);
        List<string> prodList= new List<string>();
        List<C360_ProductSalesArea__c> prdAreatList = [SELECT Product__c,SalesOrganization__c FROM C360_ProductSalesArea__c WHERE Product__c in:prodId and SalesOrganization__c <> null order by SalesOrganization__c asc];
        for(C360_ProductSalesArea__c areaitem : prdAreatList){
            if(!prodList.contains(areaitem.SalesOrganization__c)){
                prodList.add(areaitem.SalesOrganization__c);
            }
        }
        string proSalesOrg = string.join(prodList, ',' );
        return proSalesOrg;
    }
    public static map<string,Set<String>> getProductSalesareaMap(){
        Map<String,Set<String>> salesOrgMap = new Map<String,Set<String>>();
        List<C360_ProductSalesArea__c> prdAreatList = [SELECT Product__c,SalesOrganization__c FROM C360_ProductSalesArea__c WHERE SalesOrganization__c <> null order by SalesOrganization__c asc];
        for(C360_ProductSalesArea__c i: prdAreatList){
            if(salesOrgMap.containskey(i.Product__c)){
                Set<string> salesOrgList = salesOrgMap.get(i.Product__c);
                salesOrgList.add(i.SalesOrganization__c);
            }else{
                Set<string> salesOrgList = new Set<String>();
                salesOrgList.add(i.SalesOrganization__c);
                salesOrgMap.put(i.Product__c,salesOrgList);
            }
        }
        return salesOrgMap;
     }
}