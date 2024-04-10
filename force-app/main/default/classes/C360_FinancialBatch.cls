public without sharing class C360_FinancialBatch implements Database.Batchable<Object>,Database.AllowsCallouts,Database.Stateful{
    private String salesOrg;
    private String custCodeFrom;
    private String custCodeTo;
    private String custYear;
    private String custMonth;
    public static void getSalesOrg(){
        List<C360_BISalesOrg__mdt> salesOrg =[select Id,SalesOrganization__c,CustomerCodeFrom__c,CustomerCodeTo__c from C360_BISalesOrg__mdt limit 1];
        Date dat = System.today();
        String yr = String.valueOf(dat.year());
        String mth = String.valueOf(dat.month());
        for(C360_BISalesOrg__mdt i : salesOrg){
            Database.executeBatch(new C360_FinancialBatch(i.SalesOrganization__c),200);
        }
    }
    public C360_FinancialBatch(String salesOrg){
        this.salesOrg = '';
    }
    public Iterable<Object> start(Database.BatchableContext BC) {
        String respone = C360_CalloutBIService.calloutBI('Financial',this.salesOrg,'','','','','');
        Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(respone);
        List<Object> rs = (List<Object>) ((Map<String,Object>) results.get('d')).get('results');
        //system.debug('Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        return rs;
    }
    public void execute(Database.BatchableContext BC, List<Object> scope) {
        List<C360_CalloutBIService.Financial> finances = (List<C360_CalloutBIService.Financial>) JSON.deserialize(JSON.serialize(scope), List<C360_CalloutBIService.Financial>.class);
        List<Database.upsertResult> resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        List<C360_FinancialInfo__c> upsertFiList = new List<C360_FinancialInfo__c>();
        List<String> keyList = new List<String>(); 
        String MissingCustomer = 'MissingCustomer = [';
        integer i = 0;
        try{
            Set<String> accSet = new Set<String>();
            for(C360_CalloutBIService.Financial finance : finances){
                if(finance.A0SOLD_TO != '' && finance.A0SOLD_TO != null){
                    accSet.add(finance.A0SOLD_TO);
                }
            }
            List<Account> sf_accList = [select AccountNumber__c,id from Account where AccountNumber__c IN:accSet];
            Map<String,String> sf_accMap = new Map<String,String>();
            for(Account item : sf_accList){
                sf_accMap.put(item.AccountNumber__c, item.id);
            }
            for(C360_CalloutBIService.Financial finance : finances){
                C360_FinancialInfo__c upsertFi = new C360_FinancialInfo__c();
                if(sf_accMap.containskey(finance.A0SOLD_TO)){
                    upsertFi.Key__c = finance.A0SOLD_TO + finance.A0SALESORG + finance.A0SALESORG;
                    if(finance.A0SOLD_TO != null && finance.A0SOLD_TO != ''){
                        upsertFi.CompanyName__c = (sf_accMap.containskey(finance.A0SOLD_TO)) ? sf_accMap.get(finance.A0SOLD_TO) : null;
                    }else{
                        upsertFi.CompanyName__c = null;
                    }
                    upsertFi.CompanyCode__c = (finance.A0SALESORG != '' && finance.A0SALESORG != null) ? finance.A0SALESORG : '';
                    upsertFi.CurrencyLocal__c = (finance.AECUVA7JRJ25QCD7YNTGAAPOA_E != '' && finance.AECUVA7JRJ25QCD7YNTGAAPOA_E != null) ? finance.AECUVA7JRJ25QCD7YNTGAAPOA_E : '';
                    upsertFi.PocketMargin__c = (finance.AECUVA7JRJ25QARVFK0I5YPJW != '' && finance.AECUVA7JRJ25QARVFK0I5YPJW != null) ? Decimal.valueOf(String.valueOf(finance.AECUVA7JRJ25QARVFK0I5YPJW.replace(',',''))) : null;
                    upsertFi.PocketMarginUSD__c = (finance.AECUVA7JRJ25QARVFK0I5YVVG != '' && finance.AECUVA7JRJ25QARVFK0I5YVVG != null) ? Decimal.valueOf(String.valueOf(finance.AECUVA7JRJ25QARVFK0I5YVVG.replace(',',''))) : null;
                    upsertFi.Revenue__c = (finance.AECUVA7JRJ25QARVFK0I5YCWS != '' && finance.AECUVA7JRJ25QARVFK0I5YCWS != null) ? Decimal.valueOf(String.valueOf(finance.AECUVA7JRJ25QARVFK0I5YCWS.replace(',',''))) : null;
                    upsertFi.RevenueUSD__c = (finance.AECUVA7JRJ25QARVFK0I5YJ8C != '' && finance.AECUVA7JRJ25QARVFK0I5YJ8C != null) ? Decimal.valueOf(String.valueOf(finance.AECUVA7JRJ25QARVFK0I5YJ8C.replace(',',''))) : null;
                    upsertFiList.add(upsertFi);
                }else{
                    MissingCustomer = MissingCustomer + finance.A0SOLD_TO +',';
                    i = i+1;
                }
            }
            if(MissingCustomer.right(1)==','){
                MissingCustomer = 'Error ' +i+ ' Item : ' + MissingCustomer.Substring(0,MissingCustomer.length()-1)+']';
            }else{
                MissingCustomer = MissingCustomer + ']';
            }
            if(upsertFiList.size()> 0){
                Schema.SObjectField Key = C360_FinancialInfo__c.Fields.Key__c;
                resultList = Database.upsert(upsertFiList,Key,false);
                if(resultList.size() > 0){
                    List<String> idList_suc = new List<String>();
                    List<String> errorMsg_List = new List<String>();
                    Map<String,List<String>> errorMap = new Map<String,List<String>>();
                    for(Integer idx = 0; idx < resultList.size(); idx++){
                        if(resultList[idx].isSuccess()){
                            idList_suc.add(resultList[idx].getId());
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
                        log.Integration_Name__c = 'C360 Replicated Financial Webservice';
                        log.Log_Type__c = 'Error';
                        log.Message_Type__c = 'Fail';
                        log.Response_Body__c = JSON.serialize(finances).abbreviate(131000);
                        log.Error_Message__c = ('Financial - '+errorMap.keyset()+' : '+errorMap.values()).abbreviate(37000);
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }else{
                        Application_Log__c log = new Application_Log__c();
                        log.Method__c = 'Upsert';
                        log.Integration_Name__c = 'C360 Replicated Financial Webservice';
                        log.Log_Type__c = 'Success';
                        log.Message_Type__c = 'Success';
                        log.Response_Body__c = JSON.serialize(finances).abbreviate(131000);
                        log.Error_Message__c = MissingCustomer;
                        log.OwnerId = UserInfo.getUserId();
                        insertApplogList.add(log);
                    }
                }
            }
        }catch (Exception e) {
            Application_Log__c log = new Application_Log__c();
            log.Method__c = 'Upsert';
            log.Integration_Name__c = 'C360 eplicated Financial Webservice';
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
}