public without sharing class C360_NonSAPProductUnitBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful {
    public Iterable<Object> start(Database.BatchableContext BC) {
        String respone = C360_CalloutNonSAPService.callout('ProductUnit');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug('Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope){
        List<C360_CalloutNonSAPService.productUnitConversion> ProductUnitList = (List<C360_CalloutNonSAPService.productUnitConversion>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutNonSAPService.productUnitConversion>.class);
        List<Database.upsertResult> productUnit_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_UnitConversion__c> upsertUnitConList = new List<C360_UnitConversion__c>();
        List<String> productUnit_keyList = new List<String>();
        list<C360_Product__c> insertProductList = [select id, MaterialCode__c from C360_Product__c];
        Map<String,String> ProductMap = new Map<String,String>();
        for(C360_Product__c prdItem : insertProductList ){
            ProductMap.put(prdItem.MaterialCode__c, prdItem.id);
        }
        Map<String,String> UomMap = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = C360_Product__c.BaseUnit__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        String result;
        for( Schema.PicklistEntry v : values){
            if (v.getValue() == 'public') {
                result = v.getLabel();
            }
            UomMap.put(v.getValue() ,v.getLabel());
        }
        string MissingProduct = 'MissingProduct = [';
        try{
            for(C360_CalloutNonSAPService.productUnitConversion productUnit : ProductUnitList){
                C360_UnitConversion__c upsertUnitConv = new C360_UnitConversion__c();
                if(productUnit.ZMATERIL != '' && productUnit.ZMATERIL != null){
                    if(productMap.get(productUnit.ZMATERIL) != '' && productMap.get(productUnit.ZMATERIL) != null){
                        upsertUnitConv.Product__c = productMap.get(productUnit.ZMATERIL);
                        if(productUnit.ZMATERIL_0BASE_UOM != '' && productUnit.ZMATERIL_0BASE_UOM != null && productUnit.A0UNIT != '' && productUnit.A0UNIT != null){
                            upsertUnitConv.BaseUOM__c  = productUnit.ZMATERIL_0BASE_UOM;
                            upsertUnitConv.Name = productUnit.ZMATERIL + '-' + UomMap.get(productUnit.A0UNIT);
                            String unitConvExtId = productUnit.ZMATERIL + productUnit.ZMATERIL_0BASE_UOM + productUnit.A0UNIT;
                            upsertUnitConv.Key__c = unitConvExtId;
                            ProductUnit_keyList.add(unitConvExtId);
                            upsertUnitConv.AlternativeUOM__c =productUnit.A0UNIT;
                            String xDenominator = String.valueOf(productUnit.AECUVA7JRJ25QMTRD4LP0QBEJ);
                            String stDenominator = xDenominator.replace(',','');
                            upsertUnitConv.DenominatorUOM__c= Decimal.valueOf(String.valueOf(stDenominator));
                            String x0NUMERATOR = String.valueOf(productUnit.AECUVA7JRJ25QMTRD4LP0Q52Z);
                            String st0NUMERATOR = x0NUMERATOR.replace(',','');
                            upsertUnitConv.NumeratorUOM__c = Decimal.valueOf(String.valueOf(st0NUMERATOR));
                            upsertUnitConList.add(upsertUnitConv);
                        }
                    }else{
                        MissingProduct = MissingProduct + productUnit.ZMATERIL +',';
                    }
                }
            }
            if(MissingProduct.right(1)==','){
                MissingProduct = MissingProduct.Substring(0,MissingProduct.length()-1) + ']';
            }else{
                MissingProduct = MissingProduct + ']';
            }
            if(upsertUnitConList.size()> 0){
                Schema.SObjectField ProductAreaKey = C360_UnitConversion__c.Fields.Key__c;
                ProductUnit_resultList = Database.upsert(upsertUnitConList,ProductAreaKey,false);
                if(ProductUnit_resultList.size() > 0){
                    List<String> ProductIdList_suc = new List<String>();
                    List<String> ProductArea_errorMsg_List = new List<String>();
                    Map<String,List<String>> ProductArea_errorMap = new Map<String,List<String>>();
                    for (Integer idx = 0; idx < ProductUnit_resultList.size(); idx++){
                        if (ProductUnit_resultList[idx].isSuccess()){
                            ProductIdList_suc.add(ProductUnit_resultList[idx].getId());
                        }else{
                            ProductArea_errorMsg_List = new List<String>();
                            for(Database.Error err : ProductUnit_resultList[idx].getErrors()){
                                ProductArea_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                            ProductArea_errorMap.put(ProductUnit_resultList[idx].getId(),ProductArea_errorMsg_List);
                        }
                    }
                    if(ProductArea_errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Non-SAP Product UnitConversion Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(ProductUnitList).abbreviate(131000);
                        log.Error_Message__c = 'Product UnitConversion- '+ProductArea_errorMap.keyset()+' : '+ProductArea_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Non-SAP Product UnitConversion Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(ProductUnitList).abbreviate(131000);
                        log.Error_Message__c = MissingProduct;
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }catch (Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated Non-SAP Product UnitConversion Webservice';
            log.Log_Type__c = 'Error';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c =  JSON.serialize(scope).abbreviate(131000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
        }
    }
    public void finish(Database.BatchableContext BC){}
}