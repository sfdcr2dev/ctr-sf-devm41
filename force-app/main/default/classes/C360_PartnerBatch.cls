public without sharing class C360_PartnerBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
    public Iterable<Object> start(Database.BatchableContext BC){
        String respone = C360_CalloutBIService.calloutBI('PartnerFunction');
        Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String,Object>) results.get('d')).get('results');
        //system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope){
        List<C360_CalloutBIService.Partner> PartnerList = (List<C360_CalloutBIService.Partner>) JSON.deserialize(JSON.serialize(scope),List<C360_CalloutBIService.Partner>.class);
        List<Database.upsertResult> partner_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<Application_Log__c> errorApplogList = new List<Application_Log__c>();
        List<C360_Relationship__c> upsertPartnerList = new List<C360_Relationship__c>();
        List<String> partner_keyList = new List<String>();
        List<String> partnerRev_keyList = new List<String>();
        List<String> accList = new List<String>();
        List<String> delAccList = new List<String>();
        string MissingCustomer = 'MissingCustomer = [';
        try{
            for(C360_CalloutBIService.Partner partner : PartnerList){
                if(!String.isBlank(partner.A0CUSTOMER)){
                    accList.add(partner.A0CUSTOMER);
                }
                if(!String.isBlank(partner.ZCUSTBP)){
                    accList.add(partner.ZCUSTBP);
                }
            }
            //=====Mapping Customer=======================
            list<Account>insertCustomerList = [select id,AccountNumber__c,RecordType.DeveloperName from Account where AccountNumber__c in:accList];
            Map<String,String> masterMap = new Map<String,String>();
            Map<String,String> customerMap = new Map<String,String>();
            Map<String,String> customerRecordType = new Map<String,String>();
            for(Account custItem : insertCustomerList){
                customerMap.put(custItem.AccountNumber__c,custItem.id);
                customerRecordType.put(custItem.AccountNumber__c,custItem.RecordType.DeveloperName);
            }
            for(C360_CalloutBIService.Partner partner : PartnerList){
                C360_Relationship__c upsertPartner = new C360_Relationship__c();
                C360_Relationship__c upsertPartnerRever = new C360_Relationship__c();
                if(!String.isBlank(partner.A0CUSTOMER) && !String.isBlank(partner.ZPARTFN) && !String.isBlank(partner.ZCUSTBP)){
                    if(!String.isBlank(customerMap.get(partner.A0CUSTOMER)) && !String.isBlank(customerMap.get(partner.ZCUSTBP)) && customerRecordType.get(partner.A0CUSTOMER)!='ShipTo'){
                        delAccList.add(partner.A0CUSTOMER); //=====Add customerList to delete from old relationsip
                        upsertPartner.Account__c = customerMap.get(partner.A0CUSTOMER);
                        upsertPartner.ReverseAccount__c  = customerMap.get(partner.ZCUSTBP);
                        upsertPartner.RelationshipType__c = partner.ZPARTFN;
                        String partnerExtId = partner.A0CUSTOMER+partner.ZPARTFN+partner.ZCUSTBP;
                        upsertPartner.Key__c = partnerExtId;
                        upsertPartnerList.add(upsertPartner);
                        //=====Reverse RelationShip=======================
                        if(partner.A0CUSTOMER != partner.ZCUSTBP  && partner.ZPARTFN == 'WE'){
                            upsertPartnerRever.Account__c = customerMap.get(partner.ZCUSTBP);
                            upsertPartnerRever.ReverseAccount__c  = customerMap.get(partner.A0CUSTOMER);
                            upsertPartnerRever.RelationshipType__c = 'WE-RE';
                            String partnerExtIdReverse = partner.ZCUSTBP+'WE-RE'+partner.A0CUSTOMER;
                            upsertPartnerRever.Key__c = partnerExtIdReverse;
                            upsertPartnerList.add(upsertPartnerRever);
                        }
                    }else{
                        MissingCustomer = MissingCustomer + partner.A0CUSTOMER +'='+ partner.ZCUSTBP;
                    }
                }
            }
            if(upsertPartnerList.size()> 0){
                delete [select id from C360_Relationship__c where Account__r.AccountNumber__c in: delAccList];
                Schema.SObjectField PartnerKey = C360_Relationship__c.Fields.Key__c;
                Partner_resultList = Database.upsert(upsertPartnerList,PartnerKey,false);
                if(Partner_resultList.size() > 0){
                    List<String> PartnerIdList_suc = new List<String>();
                    List<String> Partner_errorMsg_List = new List<String>();
                    Map<String,List<String>> Partner_errorMap = new Map<String,List<String>>();
                    for(Integer idx = 0; idx < Partner_resultList.size(); idx++){
                        if(Partner_resultList[idx].isSuccess()){
                            PartnerIdList_suc.add(Partner_resultList[idx].getId());
                        }else{
                            Partner_errorMsg_List = new List<String>();
                            for(Database.Error err : Partner_resultList[idx].getErrors()){
                                Partner_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                            Partner_errorMap.put(Partner_resultList[idx].getId(),Partner_errorMsg_List);
                        }
                    }
                    if(Partner_errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Partner Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
                        log.Error_Message__c = 'Partner - '+Partner_errorMap.keyset()+' : '+Partner_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Partner Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(scope).abbreviate(131000);
                        log.Error_Message__c = 'Partner - Success';
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }catch (Exception e){
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 Replicated Partner Webservice';
            log.Log_Type__c = 'Error';
            log.Message_Type__c = 'Fail';
            log.Response_Body__c =  JSON.serialize(scope).abbreviate(131000);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;}
    }
    public void finish(Database.BatchableContext BC){}
}