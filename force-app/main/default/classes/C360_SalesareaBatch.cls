public without sharing class C360_SalesareaBatch  implements Database.Batchable<Object>, Database.AllowsCallouts, Database.Stateful{
    
    public Iterable<Object> start(Database.BatchableContext BC) {        
        String respone = C360_CalloutBIService.calloutBI('SalesArea');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    
    public void execute(Database.BatchableContext BC, List<Object> scope) {
        List<C360_CalloutBIService.topSalesarea> salesareaList = (List<C360_CalloutBIService.topSalesarea>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.topSalesarea>.class);
        List<Database.upsertResult> area_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_SalesArea__c>upsertSalesareaList = new List<C360_SalesArea__c>();
        List<AccountTeamMember>insertAccountTeamList = new List<AccountTeamMember>();
        List<String>area_keyList = new List<String>();
        //==========List customer for update= by salesOrg====================================================================================================
        List<Account>upAccountList9100 = new List<Account>();
        List<Account>upAccountList9200 = new List<Account>();
        List<Account>upAccountList9300 = new List<Account>();
        List<Account>upAccountList9400 = new List<Account>();
        List<Account>upAccountList2000 = new List<Account>();  
        List<Account>upAccountList1100 = new List<Account>();
        List<Account>upAccountList1300 = new List<Account>();
        List<Account>upAccountList1400 = new List<Account>();
        List<Account>upAccountList1700 = new List<Account>();
        
        map<String,Object>areaAccountMap9100 = new map<String,Object>();
        map<String,Object>areaAccountMap9200 = new map<String,Object>();
        map<String,Object>areaAccountMap9300 = new map<String,Object>();
        map<String,Object>areaAccountMap9400 = new map<String,Object>();
        map<String,Object>areaAccountMap2000 = new map<String,Object>();
        map<String,Object>areaAccountMap1100 = new map<String,Object>();
        map<String,Object>areaAccountMap1300 = new map<String,Object>();
        map<String,Object>areaAccountMap1400 = new map<String,Object>();
        map<String,Object>areaAccountMap1700 = new map<String,Object>();
        //=====Mapping Master Map===========================================================================
        list<Master_Map__c>insertMasterMapList = [select id,Code__c from Master_Map__c  where Type__c ='Payment Term' or Type__c ='None' ];                                      
        map<String,String>masterMap = new map<String,String>();
        for(Master_Map__c mastertItem : insertMasterMapList )
        {
           masterMap.put(mastertItem.Code__c, mastertItem.id);
        }
//====End=Mapping Customer= and Master==========================================================================  
        list<String> accList = new list<String>();
        list<String> salegroupList = new list<String>();
        string MissingCustomer = 'MissingCustomer = [';
        try {
            for(C360_CalloutBIService.topSalesarea salesArea  : salesareaList) {
                if(salesArea.A0CUSTOMER != '' && salesArea.A0CUSTOMER != null)
                {
                   accList.add(salesArea.A0CUSTOMER);
                }   
                if(salesArea.A0SALES_GRP != '' && salesArea.A0SALES_GRP != null)
                {
                   salegroupList.add(salesArea.A0SALES_GRP);
                } 
            }
            //=====Mapping Customer= and Master=======
            list<Account>accObjList = [select id,AccountNumber__c from Account where AccountNumber__c IN:accList ];  
            map<String,String>customerMap = new map<String,String>();
            for(Account custItem : accObjList )
            {
                customerMap.put(custItem.AccountNumber__c, custItem.id);
            }
            //=====Mapping SaleGroup Master=======            
            list<Master_Map__c>sgObjList = [SELECT Id,Sales_Group__c,Sales_Rep__c from Master_Map__c where Type__c = 'SalesMapwithSalesGroup' and Sales_Group__c IN:salegroupList ]; 
            map<String,Id>salesGroupMap = new map<String,Id>();
            for(Master_Map__c item : sgObjList )
            {
                salesGroupMap.put(item.Sales_Group__c, item.Sales_Rep__c);
            }
            //=====List AccountTeamMember for Delete===========================================================================
            for(C360_CalloutBIService.topSalesarea salesArea  : salesareaList) {     
                C360_SalesArea__c upsertArea = new C360_SalesArea__c();
                AccountTeamMember insertAccTeam = new AccountTeamMember();
                Account upAccount9100 = new Account();
                Account upAccount9200 = new Account();
                Account upAccount9300 = new Account();
                Account upAccount9400 = new Account();
                Account upAccount2000 = new Account();
                Account upAccount1100 = new Account();
                Account upAccount1300 = new Account();
                Account upAccount1400 = new Account();
                Account upAccount1700 = new Account();
                
                if(customerMap.get(salesArea.A0CUSTOMER)!= '' && customerMap.get(salesArea.A0CUSTOMER) != null)
                {
                    upsertArea.AccountNumber__c = customerMap.get(salesArea.A0CUSTOMER);
                    String salesareaExtId = salesArea.A0CUSTOMER +salesArea.A0SALESORG + salesArea.A0DISTR_CHAN + salesArea.A0DIVISION;
                    upsertArea.Key__c =salesareaExtId;
                    area_keyList.add(salesareaExtId);
                    upsertArea.SalesOrganization__c = salesArea.A0SALESORG; 
                    upsertArea.DistributionChannel__c = salesArea.A0DISTR_CHAN;  
                    upsertArea.Division__c = salesArea.A0DIVISION;  
                    upsertArea.SalesDistrict__c = salesArea.A0SALES_DIST; 
                    upsertArea.PriceGroup__c = salesArea.ZPRCGP;
                    upsertArea.Pricelist__c = salesArea.ZPRCLT;
                    upsertArea.Incoterms__c = salesArea.A0INCOTERMS;
                    upsertArea.Incoterms2__c = salesArea.A0INCOTERMS2;
                    upsertArea.Currency__c = salesArea.A0CURRENCY;
                    upsertArea.AccountAssignmentGroup__c = salesArea.ZKTGRM;
                    upsertArea.ExchangeRateType__c = salesArea.A0RATE_TYPE;
                    upsertArea.CustomerGroup__c =salesArea.A0CUST_GROUP;  
                    upsertArea.CustomerGroup1__c = salesArea.A0CUST_GRP1;
                    upsertArea.CustomerGroup2__c = salesArea.A0CUST_GRP2;
                    upsertArea.CustomerGroup3__c = salesArea.A0CUST_GRP3;
                    upsertArea.CustomerGroup4__c = salesArea.A0CUST_GRP4;
                    upsertArea.CustomerGroup5__c = salesArea.A0CUST_GRP5;
                    upsertArea.PricingProcedure__c = salesArea.ZPRCP;
                    upsertArea.ShippingCondition__c = salesArea.A0SHIP_COND;	
                    upsertArea.SalesGroup__c = salesArea.A0SALES_GRP;
                    upsertArea.SalesOffice__c = salesArea.A0SALES_OFF;
                    upsertArea.CreditControlArea__c= salesArea.A0C_CTR_AREA;
                    upsertArea.CustomerPayment__c= salesArea.ZCUSPGP;
                    upsertArea.BlockStatus__c= salesArea.ZAUFSD;
                    if(salesArea.ZDELFLAG != '' && salesArea.ZDELFLAG != null)
                    {
                        upsertArea.Status__c = 'Inactive';
                    }else{
                        upsertArea.Status__c = 'Active';
                    }                   
                    upsertArea.RawDataBI__c = 'TermofPayment:'+salesArea.ZTPMNTTRM;
                    upsertArea.TermofPayment__c = masterMap.get(salesArea.ZTPMNTTRM);                 
    //==============Update Account======================================================================================================================================
                    if(!areaAccountMap9100.containsKey(customerMap.get(salesArea.A0CUSTOMER)) && salesArea.A0SALESORG =='9100'){ 
                        upAccount9100.TOPSOLVENTVN__c = True ; 
                        upAccount9100.id = customerMap.get(salesArea.A0CUSTOMER);
                        upAccount9100.AccountNumber__c = salesArea.A0CUSTOMER;
                        upAccountList9100.add(upAccount9100); 
                        areaAccountMap9100.put(customerMap.get(salesArea.A0CUSTOMER),upAccount9100);
                    }
                    if(!areaAccountMap9200.containsKey(customerMap.get(salesArea.A0CUSTOMER)) && salesArea.A0SALESORG =='9200'){ 
                        upAccount9200.TOPSOLVENTTSR__c = True ; 
                        upAccount9200.id = customerMap.get(salesArea.A0CUSTOMER);
                        upAccount9200.AccountNumber__c = salesArea.A0CUSTOMER;
                        upAccountList9200.add(upAccount9200);
                        areaAccountMap9200.put(customerMap.get(salesArea.A0CUSTOMER),upAccount9200);
                    } 
                    if(!areaAccountMap9300.containsKey(customerMap.get(salesArea.A0CUSTOMER)) && salesArea.A0SALESORG =='9300'){ 
                        upAccount9300.TOPSOLVENTJSKem__c = True ;
                        upAccount9300.id = customerMap.get(salesArea.A0CUSTOMER);
                        upAccountList9300.add(upAccount9300);
                        areaAccountMap9300.put(customerMap.get(salesArea.A0CUSTOMER),upAccount9300);
                    }  
                    if(!areaAccountMap9400.containsKey(customerMap.get(salesArea.A0CUSTOMER)) && salesArea.A0SALESORG =='9400'){ 
                        upAccount9400.TOPSOLVENTTSChem__c = True ; 
                        upAccount9400.id = customerMap.get(salesArea.A0CUSTOMER);
                        upAccountList9400.add(upAccount9400);
                        areaAccountMap9400.put(customerMap.get(salesArea.A0CUSTOMER),upAccount9400);
                    } 
                    if(!areaAccountMap2000.containsKey(customerMap.get(salesArea.A0CUSTOMER)) && salesArea.A0SALESORG =='2000'){
                        upAccount2000.TOPSOLVENTTH__c= True ; 
                        upAccount2000.id = customerMap.get(salesArea.A0CUSTOMER);
                        upAccountList2000.add(upAccount2000);
                        areaAccountMap2000.put(customerMap.get(salesArea.A0CUSTOMER),upAccount2000);
                    }  
                    if(!areaAccountMap1100.containsKey(customerMap.get(salesArea.A0CUSTOMER)) && salesArea.A0SALESORG =='1100'){ 
                        upAccount1100.ThaiOil__c = True ; 
                        upAccount1100.id = customerMap.get(salesArea.A0CUSTOMER);
                        upAccountList1100.add(upAccount1100);
                        areaAccountMap1100.put(customerMap.get(salesArea.A0CUSTOMER),upAccount1100);  
                    } 
                    if(!areaAccountMap1300.containsKey(customerMap.get(salesArea.A0CUSTOMER)) && salesArea.A0SALESORG =='1300'){ 
                        upAccount1300.ThaiParaxylene__c = True ; 
                        upAccount1300.id = customerMap.get(salesArea.A0CUSTOMER);
                        upAccountList1300.add(upAccount1300);
                        areaAccountMap1300.put(customerMap.get(salesArea.A0CUSTOMER),upAccount1300);
                    }
                    if(!areaAccountMap1400.containsKey(customerMap.get(salesArea.A0CUSTOMER)) && salesArea.A0SALESORG =='1400'){ 
                        upAccount1400.ThaiLubeBase__c = True ;
                        upAccount1400.id = customerMap.get(salesArea.A0CUSTOMER);
                        upAccountList1400.add(upAccount1400);
                        areaAccountMap1400.put(customerMap.get(salesArea.A0CUSTOMER),upAccount1400);  
                    }
                    if(!areaAccountMap1700.containsKey(customerMap.get(salesArea.A0CUSTOMER)) && salesArea.A0SALESORG =='1700'){ 
                        upAccount1700.LABIX__c = True ;
                        upAccount1700.id = customerMap.get(salesArea.A0CUSTOMER);
                        upAccountList1700.add(upAccount1700);
                        areaAccountMap1700.put(customerMap.get(salesArea.A0CUSTOMER),upAccount1700);
                    } 
                    //=====================================================================================================================================================
                    if(salesArea.A0SALES_GRP != '' && salesArea.A0SALES_GRP != null){
                        if(salesGroupMap.containskey(salesArea.A0SALES_GRP)){//
                            insertAccTeam.AccountId = customerMap.get(salesArea.A0CUSTOMER);
                            insertAccTeam.UserId = salesGroupMap.get(salesArea.A0SALES_GRP);
                            insertAccountTeamList.add(insertAccTeam);
                        }
                    }
                   //2==add data to upsertSalesareaList
                   upsertSalesareaList.add(upsertArea);
               }else{
                    MissingCustomer = MissingCustomer + salesArea.A0CUSTOMER +',';
               }
            } //==end for
            //  if(upAccountList.size()> 0){ update  upAccountList;}
            if(upsertSalesareaList.size()> 0){
                Schema.SObjectField areaKey = C360_SalesArea__c.Fields.Key__c;  
                area_resultList = Database.upsert(upsertSalesareaList, areaKey, false);    
                if(area_resultList.size() > 0)
                {
                    List<String>areaIdList_suc = new List<String>();
                    List<String>area_errorMsg_List = new List<String>();
                    map<String,List<String>>area_errorMap = new map<String,List<String>>();
                    for(Integer idx = 0; idx < area_resultList.size(); idx++) 
                    {
                        if(area_resultList[idx].isSuccess()) 
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
                        log.Integration_Name__c = 'Replicated SalesArea Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(salesareaList).abbreviate(121000);
                        log.Error_Message__c = 'SalesArea - '+area_errorMap.keyset()+' : '+area_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                    else
                    {
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'Replicated SalesArea Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(salesareaList).abbreviate(121000);
                        log.Error_Message__c = 'SalesArea - Success' + MissingCustomer;
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }  
            if(insertAccountTeamList.size()> 0){
                 Insert insertAccountTeamList;
            }
        }
        catch (Exception e) {
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'Replicated TOP Sales area Webservice';
            log.Log_Type__c = 'Error';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c = JSON.serialize(scope).abbreviate(121000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0)
        {
            insert insertApplogList;
            //3 Update Account============================================================================================
            if(upAccountList9100.size()> 0){
                //    system.debug('upAccountList9100 : ' + areaAccountMap1);
                List<Database.SaveResult> AccResults9100 = Database.update(upAccountList9100, false); 
            }  
            if(upAccountList9200.size()> 0){
                List<Database.SaveResult> AccResults9200 = Database.update(upAccountList9200, false); 
            }  
            if(upAccountList9300.size()> 0){
                List<Database.SaveResult> AccResults9300 = Database.update(upAccountList9300, false); 
            }  
            if(upAccountList9400.size()> 0){
                List<Database.SaveResult> AccResults9400 = Database.update(upAccountList9400, false); 
                system.debug('upAccountList9400 : ' + upAccountList9400);
            }  
            if(upAccountList2000.size()> 0){
                system.debug('upAccountList2000 : ' + upAccountList2000);
                List<Database.SaveResult> AccResults2200 = Database.update(upAccountList2000, false); 
            }  
            if(upAccountList1100.size()> 0){
                List<Database.SaveResult> AccResults1100 = Database.update(upAccountList1100, false); 
            } 
            if(upAccountList1300.size()> 0){
                List<Database.SaveResult> AccResults1300 = Database.update(upAccountList1300, false); 
            }
            if(upAccountList1400.size()> 0){
                List<Database.SaveResult> AccResults1400 = Database.update(upAccountList1400, false); 
            }
            if(upAccountList1700.size()> 0){
                List<Database.SaveResult> AccResults1700 = Database.update(upAccountList1700, false); 
            }
        }
    }
    public void finish(Database.BatchableContext BC) {
    }
}