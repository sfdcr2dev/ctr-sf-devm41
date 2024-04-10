public without sharing class C360_AccountSoldtoBatch implements Database.Batchable<Object>, Database.AllowsCallouts, Database.Stateful {
    public Iterable<Object> start(Database.BatchableContext BC) {        
        String respone = C360_CalloutBIService.calloutBI('SoldTo');
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String, Object>) results.get('d')).get('results');
        //system.debug('Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope) {
        List<C360_CalloutBIService.Customer> customers = (List<C360_CalloutBIService.Customer>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.Customer>.class);
        List<Database.upsertResult> acc_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<Account> upsertAccList = new List<Account>();
        List<String> acc_keyList = new List<String>();
        try {
            Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoldTo').getRecordTypeId();
            Id RecordTypeBillToId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BillTo').getRecordTypeId();
            List<String> accList = new List<String>();
            List<String> masterCodeList = new List<String>();
            List<String> masterProvCodeList = new List<String>();
            for(C360_CalloutBIService.Customer customer : customers){
                if(customer.A0CUSTOMER_ZTRANZN != '' && customer.A0CUSTOMER_ZTRANZN != null){
                   masterCodeList.add(customer.A0CUSTOMER_0COUNTRY + '-' + customer.A0CUSTOMER_ZTRANZN);
                }
                if(customer.A0CUSTOMER_0COUNTRY != '' && customer.A0CUSTOMER_0COUNTRY != null){
                    masterCodeList.add(customer.A0CUSTOMER_0COUNTRY);
                }
                if(customer.ZCITY != '' && customer.ZCITY != null){
                    masterProvCodeList.add(customer.A0CUSTOMER_0COUNTRY.toUppercase() + '-' + customer.ZCITY.toUppercase());
                }
                if(customer.A0CUSTOMER != '' && customer.A0CUSTOMER != null){
                    accList.add(customer.A0CUSTOMER);
                }
            }
            List<Master_Map__c> sf_traZoneList = [select id, Code__c from Master_Map__c where Type__c in ('Transportation Zone','Country') and Code__c IN:masterCodeList];
            Map<String,String> masterMap = new map<String,String>();
            for(Master_Map__c item : sf_traZoneList){
                masterMap.put(item.Code__c, item.id);
            }
            List<Master_Map__c> sf_provList = [select id, Name from Master_Map__c where Type__c = 'Province' and Name IN:masterProvCodeList];
            Map<String,String> masterprovMap = new map<String,String>();
            for(Master_Map__c item : sf_provList){
                masterprovMap.put(item.Name.toUppercase(), item.id);
            }
            List<AccountTeamMember>deleteAccountTeamList = [select id from AccountTeamMember  where Account.AccountNumber__c IN :accList]; 
            if(deleteAccountTeamList.size()> 0){
                 Delete deleteAccountTeamList;
            }
            for(C360_CalloutBIService.Customer customer : customers){
                Account upsertAcc = new Account();
                if(customer.A0CUSTOMER != '' && customer.A0CUSTOMER != null){
                    upsertAcc.AccountNumber__c = customer.A0CUSTOMER;
                    acc_keyList.add(customer.A0CUSTOMER);
                }else{
                    upsertAcc.AccountNumber__c = '';
                }
                upsertAcc.RecordTypeId = (customer.A0CUSTOMER_0ACCNT_GRP == 'ZBIL') ? RecordTypeBillToId : RecordTypeId;
                upsertAcc.Name = (customer.A0CUSTOMER_0NAME != '' && customer.A0CUSTOMER_0NAME != null) ? customer.A0CUSTOMER_0NAME + ' ' + customer.A0CUSTOMER_0NAME2 + ' ' + customer.A0CUSTOMER_0NAME3 + ' ' + customer.A0CUSTOMER_ZNAME5 : '';
                upsertAcc.CustomerNameLocal1__c = (customer.A0CUSTOMER_0NAME != '' && customer.A0CUSTOMER_0NAME != null) ? customer.A0CUSTOMER_0NAME : '';
                upsertAcc.CustomerNameLocal2__c = (customer.A0CUSTOMER_0NAME2 != '' && customer.A0CUSTOMER_0NAME2 != null) ? customer.A0CUSTOMER_0NAME2 : '';
                upsertAcc.CustomerNameLocal3__c = (customer.A0CUSTOMER_0NAME3 != '' && customer.A0CUSTOMER_0NAME3 != null) ? customer.A0CUSTOMER_0NAME3 : '';
                upsertAcc.CustomerNameLocal4__c = (customer.A0CUSTOMER_ZNAME5 != '' && customer.A0CUSTOMER_ZNAME5 != null) ? customer.A0CUSTOMER_ZNAME5 : '';
                upsertAcc.CustomerNameEN1__c = (customer.ZNAME != '' && customer.ZNAME != null) ? customer.ZNAME : '';
                upsertAcc.CustomerNameEN2__c = (customer.ZNAME2 != '' && customer.ZNAME2 != null) ? customer.ZNAME2 : '';
                upsertAcc.CustomerNameEN3__c = (customer.ZNAME3 != '' && customer.ZNAME3 != null) ? customer.ZNAME3 : '';
                upsertAcc.CustomerNameEN4__c = (customer.ZNAME4 != '' && customer.ZNAME4 != null) ? customer.ZNAME4 : '';
                upsertAcc.AccountGroup__c = (customer.A0CUSTOMER_0ACCNT_GRP != '' && customer.A0CUSTOMER_0ACCNT_GRP != null) ? customer.A0CUSTOMER_0ACCNT_GRP : '';
                //if(customer.A0CUSTOMER_ZTRANZN != null && customer.A0CUSTOMER_ZTRANZN != ''){
                    upsertAcc.TransportationZone__c = (masterMap.containskey(customer.A0CUSTOMER_0COUNTRY + '-' + customer.A0CUSTOMER_ZTRANZN)) ? masterMap.get(customer.A0CUSTOMER_0COUNTRY + '-' + customer.A0CUSTOMER_ZTRANZN) : null;
                //}else{ upsertAcc.TransportationZone__c = null; }
                upsertAcc.Industry__c = (customer.A0CUSTOMER_0IND_CODE_1 != '' && customer.A0CUSTOMER_0IND_CODE_1 != null) ? customer.A0CUSTOMER_0IND_CODE_1 : '';
                upsertAcc.SLA__c = (customer.ZCUSSLA != '' && customer.ZCUSSLA != null) ? customer.ZCUSSLA : '';
                upsertAcc.StatusDeletionIndicator__c = (customer.A0CUSTOMER_ZDELFLAG == 'X') ? 'Inactive' : 'Active';
                upsertAcc.TaxCode1__c = (customer.A0CUSTOMER_0TAX_NUMB != '' && customer.A0CUSTOMER_0TAX_NUMB != null) ? customer.A0CUSTOMER_0TAX_NUMB : '';
                upsertAcc.TaxCode2__c = (customer.A0CUSTOMER_0TAX_NUMB2 != '' && customer.A0CUSTOMER_0TAX_NUMB2 != null) ? customer.A0CUSTOMER_0TAX_NUMB2 : '';
                upsertAcc.BuildingCodeEN__c = (customer.ZBUILDING != '' && customer.ZBUILDING != null) ? customer.ZBUILDING : '';
                upsertAcc.RoomEN__c = (customer.ZRMNUM != '' && customer.ZRMNUM != null)? customer.ZRMNUM : '';
                upsertAcc.FloorLocal__c = (customer.ZRMNUM != '' && customer.ZRMNUM != null) ? customer.ZRMNUM : '';
                upsertAcc.FloorEN__c = (customer.ZFLOOR != '' && customer.ZFLOOR != null)? customer.ZFLOOR : '';
                upsertAcc.HousenoEN__c = (customer.ZHONUM != '' && customer.ZHONUM != null)? customer.ZHONUM : '';
                upsertAcc.StreetEN__c = (customer.ZSTREET != '' && customer.ZSTREET != null) ? customer.ZSTREET : '';
                upsertAcc.SubDistrictENText__c = (customer.ZSTREET2 != '' && customer.ZSTREET2 != null)? customer.ZSTREET2 : '';
                upsertAcc.DistrictENText__c = (customer.ZCITY2 != '' && customer.ZCITY2 != null) ? customer.ZCITY2 : '';
                upsertAcc.ProvinceENText__c = (customer.ZCITY != '' && customer.ZCITY != null) ? customer.ZCITY : '';
                //if(customer.ZCITY != null && customer.ZCITY != ''){
                    upsertAcc.ProvinceEN__c = (masterprovMap.containskey(customer.A0CUSTOMER_0COUNTRY.toUppercase() + '-' + customer.ZCITY.toUppercase())) ? masterprovMap.get(customer.A0CUSTOMER_0COUNTRY.toUppercase() + '-' + customer.ZCITY.toUppercase()) : null;
                //}else{ upsertAcc.ProvinceEN__c = null; }
                upsertAcc.PostalCodeENText__c = (customer.ZPOST_CD != '' && customer.ZPOST_CD != null) ? customer.ZPOST_CD : '';
                upsertAcc.BuildingCodeLocal__c = (customer.ZBUILDIN2 != '' && customer.ZBUILDIN2 != null) ? customer.ZBUILDIN2 : '';
                upsertAcc.FloorLocal__c = (customer.ZFLOOR2 != '' && customer.ZFLOOR2 != null) ? customer.ZFLOOR2 : '';
                upsertAcc.HousenoLocal__c = (customer.ZHONUM2 != '' && customer.ZHONUM2 != null) ? customer.ZHONUM2 : '';
                upsertAcc.StreetLocal__c = (customer.ZSTREET4 != '' && customer.ZSTREET4 != null) ? customer.ZSTREET4 : '';
                upsertAcc.SubDistrictLocalText__c = (customer.ZSTREET3 != '' && customer.ZSTREET3 != null) ? customer.ZSTREET3 : '';
                upsertAcc.DistrictLocalText__c = (customer.A0CUSTOMER_0CITY_2 != '' && customer.A0CUSTOMER_0CITY_2 != null) ? customer.A0CUSTOMER_0CITY_2 : '';
                upsertAcc.CityStateLocalText__c = (customer.A0CUSTOMER_0CITY != '' && customer.A0CUSTOMER_0CITY != null) ? customer.A0CUSTOMER_0CITY : '';
                upsertAcc.PostalCodeLocalText__c = (customer.A0CUSTOMER_0POSTAL_CD != '' && customer.A0CUSTOMER_0POSTAL_CD != null) ? customer.A0CUSTOMER_0POSTAL_CD : '';
                //if(customer.A0CUSTOMER_0COUNTRY != null && customer.A0CUSTOMER_0COUNTRY != '') {
                    upsertAcc.Country__c = (masterMap.containskey(customer.A0CUSTOMER_0COUNTRY)) ? masterMap.get(customer.A0CUSTOMER_0COUNTRY) : null;
                //}else{ upsertAcc.Country__c = null; }
                upsertAcc.EmailText__c = (customer.ZVENEMAIL != '' && customer.ZVENEMAIL != null) ? customer.ZVENEMAIL : '';
                upsertAcc.Fax = (customer.ZFAXNUM != '' && customer.ZFAXNUM != null) ? customer.ZFAXNUM : '';
                upsertAcc.FaxExtension__c = (customer.ZFAXEXT != '' && customer.ZFAXEXT != null) ? customer.ZFAXEXT : '';
                upsertAcc.Phone = (customer.ZPHONE != '' && customer.ZPHONE != null) ? customer.ZPHONE : '';
                upsertAcc.PhoneExtension__c = (customer.ZPHEXT != '' && customer.ZPHEXT != null) ? customer.ZPHEXT : '';
                upsertAcc.MobilePhone__c = (customer.ZMPHONE != '' && customer.ZMPHONE != null) ? customer.ZMPHONE : '';
                upsertAcc.TimeZone__c = (customer.A0TIME_ZONE != '' && customer.A0TIME_ZONE != null) ? customer.A0TIME_ZONE : '';
                upsertAcc.CreateDateinSAP__c = (customer.A0CUSTOMER_0ERDAT != '' && customer.A0CUSTOMER_0ERDAT != null) ? StringToDate(customer.A0CUSTOMER_0ERDAT) : null;
                upsertAcc.CustomerBlockAll__c = (customer.ZAUFSD != '' && customer.ZAUFSD != null) ? customer.ZAUFSD : '';
                upsertAcc.TaxCode5__c = (customer.ZTAX5 != '' && customer.ZTAX5 != null) ? customer.ZTAX5 : '';
                
                upsertAcc.isMigrateData__c = True;
                upsertAccList.add(upsertAcc);
            }
            if(upsertAccList.size()> 0){
                Schema.SObjectField accKey = Account.Fields.AccountNumber__c;
                acc_resultList = Database.upsert(upsertAccList, accKey, false);
                if(acc_resultList.size() > 0){
                    List<String>accIdList_suc = new List<String>();
                    List<String>acc_errorMsg_List = new List<String>();
                    map<String,List<String>>acc_errorMap = new map<String,List<String>>();
                    for(Integer idx = 0; idx < acc_resultList.size(); idx++){
                        if(acc_resultList[idx].isSuccess()){
                            accIdList_suc.add(acc_resultList[idx].getId()); 
                        }else{
                            acc_errorMsg_List = new List<String>();
                            for(Database.Error err : acc_resultList[idx].getErrors()){
                                acc_errorMsg_List.add('Field:'+err.getFields()+': '+err.getMessage());
                            }
                            acc_errorMap.put(acc_resultList[idx].getId(),acc_errorMsg_List);
                        }
                    }
                    if(acc_errorMsg_List.size() > 0){
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Account Sold-To Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(customers).abbreviate(131000);
                        log.Error_Message__c = 'Account - '+acc_errorMap.keyset()+' : '+acc_errorMap.values();
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Account Sold-To Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(customers).abbreviate(131000);
                        log.Error_Message__c = 'Account Sold-To - Success';
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }
        catch (Exception e) {
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'Replicated Account Sold-To Webservice';
            log.Message_Type__c = 'Error';
            log.Response_Body__c = JSON.serialize(customers);
            log.OwnerId = UserInfo.getUserId();
            insertApplogList.add(log);
        }
        if(insertApplogList.size() > 0){
            insert insertApplogList;
        }
    }
    public void finish(Database.BatchableContext BC) {}
    private static Date StringToDate(String dateString){
        if (dateString.length() != 10) { return null;}
        List<String> dates = new List<String>();
        dates.add(dateString.right(4));
        dates.add(dateString.mid(3, 2));
        dates.add(dateString.left(2));
        Date output;
        try {output = Date.valueOf(String.join(dates, '-'));
        }catch(System.TypeException ex) {output = null;}
        return output;
    }
}