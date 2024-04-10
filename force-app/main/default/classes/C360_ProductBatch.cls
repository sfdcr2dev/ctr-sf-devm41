public without sharing class C360_ProductBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
    public Iterable<Object> start(Database.BatchableContext BC){
        String respone = C360_CalloutBIService.calloutBI('Product');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope){
    List<C360_CalloutBIService.ProductMaster> ProductMasterList = (List<C360_CalloutBIService.ProductMaster>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.ProductMaster>.class);
        List<Database.upsertResult> Product_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_Product__c> upsertProductList = new List<C360_Product__c>();
        //=====Mapping Master Map=======================
        List<Master_Map__c> insertMasterMapList = [select id,Code__c from Master_Map__c where Type__c ='Material Group'];
        Map<String,String> masterMap = new Map<String,String>();
        for(Master_Map__c mastertItem : insertMasterMapList){
            masterMap.put(mastertItem.Code__c,mastertItem.id);
        }
        try{
            for(C360_CalloutBIService.ProductMaster Product : ProductMasterList){
                C360_Product__c upsertProduct = new C360_Product__c();
                upsertProduct.MaterialCode__c = (Product.A0MATERIAL != '' && Product.A0MATERIAL != null) ? Product.A0MATERIAL : null;
                upsertProduct.Name = Product.A0MATERIAL + '-' + Product.A0MATERIAL_T;
                upsertProduct.BusinessUnit__c = Product.ZBU_UNIT;
                upsertProduct.BaseUnit__c = Product.A0MATERIAL_0BASE_UOM;
                upsertProduct.BaseUnitText__c = Product.A0MATERIAL_0BASE_UOM;
                upsertProduct.Division__c = Product.A0MATERIAL_0DIVISION;
                if(Product.A0MATERIAL_0MATL_GROUP != '' && Product.A0MATERIAL_0MATL_GROUP != null){
                    upsertProduct.MaterialGroup__c = (masterMap.get(Product.A0MATERIAL_0MATL_GROUP)!= null) ? masterMap.get(Product.A0MATERIAL_0MATL_GROUP) : null;
                }else{
                    upsertProduct.MaterialGroup__c = masterMap.get('Null');
                }
                upsertProduct.SizeDimensions__c = Product.A0MATERIAL_0SIZE_DIM;
                if(Product.A0DEL_FLAG != '' && Product.A0DEL_FLAG != null){
                    upsertProduct.DeletionMark__c = true;
                }else{
                    upsertProduct.DeletionMark__c = False;
                }
                upsertProductList.add(upsertProduct);
            }
            if(upsertProductList.size()> 0){
                Schema.SObjectField ProductKey = C360_Product__c.Fields.MaterialCode__c;
                Product_resultList = Database.upsert(upsertProductList,ProductKey,false);
                if(Product_resultList.size() > 0){
                    List<String> ProductIdList_suc = new List<String>();
                    List<String> Product_errorMsg_List = new List<String>();
                    Map<String,List<String>> Product_errorMap = new Map<String,List<String>>();
                    for(Integer idx = 0; idx < Product_resultList.size(); idx++){
                        if (Product_resultList[idx].isSuccess()){
                            ProductIdList_suc.add(Product_resultList[idx].getId());
                        }else{
                            Product_errorMsg_List = new List<String>();
                            for(Database.Error err : Product_resultList[idx].getErrors()){
                                Product_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                        }
                        Product_errorMap.put(Product_resultList[idx].getId(),Product_errorMsg_List);
                    }
                    if(Product_errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated ProductMaster Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Error_Message__c = 'Product - '+Product_errorMap.keyset()+' : '+Product_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated ProductMaster Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Error_Message__c = 'Product - Success';
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }
        catch (Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated ProductMaster Webservice';
            log.Log_Type__c = 'Error';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;}
    }
    public void finish(Database.BatchableContext BC){}
}