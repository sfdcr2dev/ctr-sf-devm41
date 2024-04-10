public without sharing class C360_SalesareaTsBatch  implements Database.Batchable<Object>, Database.AllowsCallouts, Database.Stateful { 
    public Iterable<Object> start(Database.BatchableContext BC){        
        String respone = C360_CalloutBIService.calloutBI('SalesAreaTS');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        return rs;
    }
    
    public void execute(Database.BatchableContext BC, List<Object> scope){   
  		List<C360_CalloutBIService.tsSalesarea> salesareaTSList = (List<C360_CalloutBIService.tsSalesarea>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.tsSalesarea>.class);
        List<Database.upsertResult> area_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_SalesArea__c>upsertSalesareaList = new List<C360_SalesArea__c>();
        //=====Mapping Master Map===========================================================================
        list<Master_Map__c>insertMasterMapList = [select id,Code__c from Master_Map__c  where Type__c ='Payment Term' or Type__c ='None' ];                                     
        map<String,String>masterMap = new map<String,String>();
        for(Master_Map__c mastertItem : insertMasterMapList )
        {
            masterMap.put(mastertItem.Code__c, mastertItem.id);
        }
        list<String> accList = new list<String>();
        	 string MissingCustomer = 'MissingCustomer = [';
     try {
            for(C360_CalloutBIService.tsSalesarea tsSalesArea  : salesareaTSList) {
                if(tsSalesArea.ZCUSTMR != '' && tsSalesArea.ZCUSTMR != null)
                {
                    accList.add(tsSalesArea.ZCUSTMR);
                }   
            }
       //=====Mapping Customer= and Master==========================================================================
         list<Account>insertCustomerList = [select id,AccountNumber__c from Account where AccountNumber__c IN:accList ];
         map<String,String>customerMap = new map<String,String>();
         for(Account custItem : insertCustomerList )
         {
             customerMap.put(custItem .AccountNumber__c, custItem.id);
         }
         for(C360_CalloutBIService.tsSalesarea tsSalesArea : salesareaTSList){    
             Account upAccount = new Account();
             C360_SalesArea__c upsertAreaTs = new C360_SalesArea__c();
             if(customerMap.get(tsSalesArea.ZCUSTMR) != '' && customerMap.get(tsSalesArea.ZCUSTMR) != null)
             {
                 upsertAreaTs.AccountNumber__c = customerMap.get(tsSalesArea.ZCUSTMR);
                 String tsSalesareaExtId = tsSalesArea.ZCUSTMR +tsSalesArea.A0SALESORG + tsSalesArea.A0DISTR_CHAN + '00'; //tsSalesArea.A0DIVISION;
                 upsertAreaTs.Key__c =tsSalesareaExtId;
                 upAccount.id = customerMap.get(tsSalesArea.ZCUSTMR);
                 upsertAreaTs.SalesOrganization__c = tsSalesArea.A0SALESORG; 
                 upsertAreaTs.DistributionChannel__c = tsSalesArea.A0DISTR_CHAN;
                 upsertAreaTs.Division__c = '00'; 
                 upsertAreaTs.ApplicationCode__c = tsSalesArea.ZCUSTMR_ZTSAPP;
                 upsertAreaTs.ApplicationDesc__c = tsSalesArea.ZCUSTMR_ZTSAPP_T;	
                 upsertAreaTs.CustomerTypeCode__c = tsSalesArea.ZCUSTMR_ZTSCUSTT;
                 upsertAreaTs.CustomerTypeDesc__c = tsSalesArea.ZCUSTMR_ZTSCUSTT_T;
                 upsertAreaTs.IndustryCode__c = tsSalesArea.ZCUSTMR_ZTSINDUST;
                 upsertAreaTs.IndustryDesc__c = tsSalesArea.ZCUSTMR_ZTSINDUST_T; 
                 upsertAreaTs.SubIndustryCode__c = tsSalesArea.ZCUSTMR_ZTSSINDUS;
                 upsertAreaTs.SubIndustryDesc__c = tsSalesArea.ZCUSTMR_ZTSSINDUS_T; 
                 //2==add data to upsertSalesareaList
                 upsertSalesareaList.add(upsertAreaTs);
             }else{
                 MissingCustomer = MissingCustomer + tsSalesArea.ZCUSTMR +',';
             }
         }
         MissingCustomer = MissingCustomer.right(1)==','? MissingCustomer.Substring(0,MissingCustomer.length()-1) + ']': MissingCustomer + ']';
         if(upsertSalesareaList.size()> 0){
             Schema.SObjectField areaKey = C360_SalesArea__c.Fields.Key__c;
             area_resultList = Database.upsert(upsertSalesareaList, areaKey, false);   
             if(area_resultList.size() > 0)
             {
                 List<String>areaIdList_suc = new List<String>();
                 List<String>area_errorMsg_List = new List<String>();
                 map<String,List<String>>area_errorMap = new map<String,List<String>>();
                 for (Integer idx = 0; idx < area_resultList.size(); idx++) 
                 {
                     if (area_resultList[idx].isSuccess()) 
                     {
                         areaIdList_suc.add(area_resultList[idx].getId()); 
                     }
                     else
                     {
                         area_errorMsg_List = new List<String>();
                         for(Database.Error err : area_resultList[idx].getErrors()) 
                         {
                             area_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                         }
                     }
                     area_errorMap.put(area_resultList[idx].getId(),area_errorMsg_List);
                 }
                 if(area_errorMsg_List.size() > 0)
                 {
                     Application_Log__c log = new Application_Log__c();
                     log.Method__c = 'Upsert';
                     log.Integration_Name__c = 'Replicated SalesAreaTS Webservice';
                     log.Log_Type__c = 'Error';
                     log.Message_Type__c = 'Fail';
                     log.Response_Body__c = JSON.serialize(salesareaTSList).abbreviate(131000);
                     log.Error_Message__c = 'SalesAreaTS - '+area_errorMap.keyset()+' : '+area_errorMap.values();
                     log.OwnerId = UserInfo.getUserId();
                     insertApplogList.add(log);
                 }
                 else
                 {
                     Application_Log__c log = new Application_Log__c();
                     log.Method__c = 'Upsert';
                     log.Integration_Name__c = 'Replicated SalesAreaTS Webservice';
                     log.Log_Type__c = 'Success';
                     log.Message_Type__c = 'Success';
                     log.Response_Body__c = JSON.serialize(salesareaTSList).abbreviate(131000);
                     log.Error_Message__c = 'SalesAreaTS - Success '+MissingCustomer;
                     log.OwnerId = UserInfo.getUserId();
                     insertApplogList.add(log);
                 }
             }
         } 
	 }
      catch (Exception e) {
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'Replicated Sales AreaTS Webservice';
            log.Log_Type__c = 'Error';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0)
        {
            insert insertApplogList;
        }
    }
    public void finish(Database.BatchableContext BC) {
    }
}