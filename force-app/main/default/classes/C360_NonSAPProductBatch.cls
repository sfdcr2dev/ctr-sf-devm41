public without sharing class C360_NonSAPProductBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
    public Iterable<Object> start(Database.BatchableContext BC) {
        String respone = C360_CalloutNonSAPService.callout('Product');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug('Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
 	public void execute(Database.BatchableContext BC, List<Object> scope){
        List<C360_CalloutNonSAPService.Products> ProductMasterList = (List<C360_CalloutNonSAPService.Products>) JSON.deserialize(JSON.serialize(scope),List<C360_CalloutNonSAPService.Products>.class);
        List<Database.upsertResult> Product_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_Product__c> upsertProductList = new List<C360_Product__c>();
        //=====Mapping Master Map========================================
        list<Master_Map__c> insertMasterMapList = [select id,Code__c from Master_Map__c where Type__c ='Material Group'];
        Map<String,String> masterMap = new Map<String,String>();
        for(Master_Map__c mastertItem : insertMasterMapList){
            masterMap.put(mastertItem.Code__c,mastertItem.id);
        }
        try{
            for(C360_CalloutNonSAPService.Products Product : ProductMasterList){
                C360_Product__c upsertProduct = new C360_Product__c();
                if(String.isNotBlank(Product.ZMATERIL)){
                    upsertProduct.MaterialCode__c = Product.ZMATERIL;
                }
                upsertProduct.Name= Product.ZMATERIL_T;
                upsertProduct.BaseUnit__c= Product.ZMATERIL_0BASE_UOM;
                upsertProduct.BusinessUnit__c= Product.ZBU_UNIT;
                upsertProduct.SizeDimensions__c= Product.A0SIZE_DIM;
                if(Product.A0DIVISION == '0'){ Product.A0DIVISION ='00';}
                upsertProduct.Division__c = Product.A0DIVISION;
                if(String.isNotBlank(Product.A0MATL_GROUP)){
                    if(masterMap.get(Product.A0MATL_GROUP)!= null){
                        upsertProduct.MaterialGroup__c = masterMap.get(Product.A0MATL_GROUP);
                    }else{
                        upsertProduct.MaterialGroup__c = masterMap.get('None');
                    }
                }else{
                    upsertProduct.MaterialGroup__c = masterMap.get('Null');
                }
                if(Product.ZDELFLAG != '' && Product.ZDELFLAG != null){
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
                    for (Integer idx = 0; idx < Product_resultList.size(); idx++){
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
                        log.Integration_Name__c = 'C360 Replicated Non-SAP ProductMaster Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(ProductMasterList).abbreviate(131000);
                        log.Error_Message__c = 'Product - '+Product_errorMap.keyset()+' : '+Product_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Non-SAP ProductMaster Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(ProductMasterList).abbreviate(131000);
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
            log.Integration_Name__c = 'C360 Replicated Non-SAP ProductMaster Webservice';
            log.Log_Type__c = 'Error';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c = JSON.serialize(ProductMasterList).abbreviate(131000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
        }
    }
    public void finish(Database.BatchableContext BC){}
}