public class C360_ReplicatedSAP_Bankguarantees{
    public class ParseException extends Exception{}
    public class dto_response extends WebserviceExtend.dto_response{}
    public static dto_response parse(String json){
        return (dto_response) System.JSON.deserialize(json,dto_response.class);
    }
    public class BankGuaranteeFromSAP{
        public String KUNNR;//CompanyCode
        public String BANKS;
        public Decimal EUPRZ;//AllowedOverdraft__c
        public String BANKA;//BankName__c
        public String BANKL;//BankNumber__c
        public String BUKRS;//CompanyCode__c
        public String ERNAM;//CreatedBy__c
        public date ERDAT_TS;//CreatedDateTime__c
        public String WAERS;//PICKLIST
        public date AJDAT;//DateOfReceipt__c
        public String BAANR;//BankGuaranteeSAPNumber__c
        public String LCNUM;//Key__c
        public String AKKST;//DocumentStatus__c
        public Decimal WRTAK;//Value__c
        public String INCO1;//Incoterms1__c
        public String INCO2;//Incoterms2__c
        public date AYDAT;//LatestShippingDate__c
        public date AIDAT;//OpeningDate__c
        public String AENDGRUND;//Reason__c
        public String KOMME;//ReasonForChange__c
        public date AADAT;//RequestDate__c
        public String ZTERM;//TermsOfPayment__c
        public String EXDKB;//AdditionalInformation__c
        public String AKART;
        public date AXDAT;
        public String NAME;
        public String KOMMA;
    }
    public static dto_response execute(Map<String, Object> requestBody, RestRequest request){
        String gatewayId = requestBody.containsKey('gateway_id') ? String.valueOf(requestBody.get('gateway_id')) : '';
        String body = requestBody.containsKey('body') ? String.valueOf(requestBody.get('body')).replace('\\','\\\\') : '';
        Application_Log__c applog = new Application_Log__c(
            External_ID__c = gatewayId.length() == 36 ? gatewayId : Uuid.randomUUID(),
            Integration_Name__c = 'C360_ReplicatedSAP_Bankguarantees',
            Method__c = 'Upsert',
            Message_Type__c = 'Success',
            Request_Body__c = JSON.serialize(requestBody).abbreviate(131000));
        List<BankGuaranteeFromSAP> BgList;
        try{
            BgList = parseJSONInputs(body);
        }catch(Exception ex){
            applog.Error_Message__c = ex.getMessage().abbreviate(32760);
            applog.Message_Type__c = 'Fail';
            applog.Response_Body__c = JSON.serialize(
                new Map<String, Object>{
                    'description' => new Map<String, Object>{
                        'success' => false,
                        'message' => 'Unknown string format, cannot parse body data. Please try JSON format.',
                        'linkurl' => applog.External_ID__c
                    }
                }
            ).abbreviate(131000);
            ApplicationLogUtils.saveLogInbound(request.requestURI,applog);
            return dto_response.parse(applog.Response_Body__c);
        }
        List<C360_BankGuarantee__c> savedList = saveBankGuarantee(BgList);
        List<C360_BankGuarantee__c> savedListNotNull = new list <C360_BankGuarantee__c>();
        applog.Response_Body__c = JSON.serialize(
            new Map<String, Object>{
                'description' => new Map<String, Object>{
                    'success' => savedList.size() > 0,
                    'message' => savedList.size() > 0 ? '' : 'Not found Operation Information',
                    'linkurl' => applog.External_ID__c
                },
                'recordIds' => (new Map<Id,C360_BankGuarantee__c>(savedListNotNull)).keySet()
            }
        ).abbreviate(131000);
        return dto_response.parse(applog.Response_Body__c);
    }
    public static List<BankGuaranteeFromSAP> parseJSONInputs(String body){
        Map<String, Object> parsedBody = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> BgList = (List<Object>)parsedBody.get('DLIST');
        List<BankGuaranteeFromSAP> inputs = new List<BankGuaranteeFromSAP>();
        for(Object rawInput : BgList){
            Map<String, Object> input = (Map<String, Object>) rawInput;
            BankGuaranteeFromSAP BankGuarantee = new BankGuaranteeFromSAP();
            if(string.valueOf(input.get('CUSTOMERNUMBER'))==null || string.valueOf(input.get('CUSTOMERNUMBER')) == ''){
                BankGuarantee.KUNNR = null;
            }else{
                BankGuarantee.KUNNR = String.valueOf(integer.valueOf(input.get('CUSTOMERNUMBER')));
            }
            BankGuarantee.BANKS = String.valueOf(input.get('BANKCOUNTRY'));
            BankGuarantee.EUPRZ = Decimal.valueOf(String.valueOf(input.get('ALLOWEDOVERDRAFTPERCENTAGE')));
            BankGuarantee.BANKA = String.valueOf(input.get('BANKNAME'));
            BankGuarantee.BANKL = String.valueOf(input.get('BANKNUMBER'));
            BankGuarantee.BUKRS = String.valueOf(input.get('COMPANYCODE'));
            BankGuarantee.ERNAM = String.valueOf(input.get('CREATEBY'));
            BankGuarantee.ERDAT_TS = StringToDate(String.valueOf(input.get('CREATEDATE')));
            BankGuarantee.WAERS = String.valueOf(input.get('CURRENCY'));
            BankGuarantee.AJDAT = (String.valueOf(input.get('DATEOFRECEIPT'))!=null && String.valueOf(input.get('DATEOFRECEIPT'))!= '') ? StringToDate(String.valueOf(input.get('DATEOFRECEIPT'))): null;
            BankGuarantee.BAANR = String.valueOf(input.get('EXTERNALFINANCIALDOCNO'));
            BankGuarantee.LCNUM = String.valueOf(input.get('FINANCIALDOCUMENT'));
            BankGuarantee.AKKST = String.valueOf(input.get('FINANCIALDOCUMENTSTATUS'));
            BankGuarantee.WRTAK = (String.valueOf(input.get('FINANCIALDOCUMENTVALUE'))!=null&&String.valueOf(input.get('FINANCIALDOCUMENTVALUE'))!='') ? Decimal.ValueOf(String.valueOf(input.get('FINANCIALDOCUMENTVALUE'))):null;
            BankGuarantee.INCO1 = String.valueOf(input.get('INCOTERMS1'));
            BankGuarantee.INCO2 = String.valueOf(input.get('INCOTERMS2'));
            BankGuarantee.AYDAT = (String.valueOf(input.get('LATESTSHIPPINGDATE')) != null && String.valueOf(input.get('LATESTSHIPPINGDATE')) !='') ? StringToDate(String.valueOf(input.get('LATESTSHIPPINGDATE'))):null;
            BankGuarantee.AIDAT = (String.valueOf(input.get('OPENINGDATE')) != null && String.valueOf(input.get('OPENINGDATE')) != '') ? StringToDate(String.valueOf(input.get('OPENINGDATE'))):null;
            BankGuarantee.AENDGRUND = String.valueOf(input.get('REASONFORCHANGE'));
            BankGuarantee.KOMME = String.valueOf(input.get('REASONTEXT'));
            BankGuarantee.AADAT = (String.valueOf(input.get('REQUESTDATE')) != null && String.valueOf(input.get('REQUESTDATE')) !='') ? StringToDate(String.valueOf(input.get('REQUESTDATE'))):null;
            BankGuarantee.ZTERM = String.valueOf(input.get('TERMSOFPAYMENT'));
            BankGuarantee.EXDKB = String.valueOf(input.get('TEXT'));
            BankGuarantee.AKART = String.valueOf(input.get('TYPEOFFINANCIALDOCUMENT'));
            BankGuarantee.AXDAT = (String.valueOf(input.get('VALIDITYENDDATE'))!=null&&String.valueOf(input.get('VALIDITYENDDATE'))!='') ? StringToDate(String.valueOf(input.get('VALIDITYENDDATE'))):null;
            BankGuarantee.NAME = String.valueOf(input.get('NAME'));
            BankGuarantee.KOMMA = String.valueOf(input.get('KOMMA'));
            inputs.add(BankGuarantee);
        }
        return inputs;
    }
    public static List<C360_BankGuarantee__c> saveBankGuarantee(List<BankGuaranteeFromSAP> BgList){
        List<Database.upsertResult> BankGuarantee_resultList = new List<Database.upsertResult>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        String MissingCustomer = 'MissingCustomer = [';
        List<C360_BankGuarantee__c> BankGuaranteeList = new List<C360_BankGuarantee__c>();
        List<Account> AccountList = new List<Account>();
        List<User> UserList = new List<User>();
        List<Master_Map__c> MasterMapList = new List<Master_Map__c>();
        list<string> CustomerList = new List<string>();
        list<string> CreatedByList = new List<string>();
        list<string> TermOfPaymentList = new List<string>();
        list<string> CompanyCodeList = new List<string>();
        for(BankGuaranteeFromSAP BgSAP : BgList){
            if(BgSAP.KUNNR != null && BgSAP.KUNNR !=''){
                CustomerList.add(BgSAP.KUNNR);}
            CreatedByList.add(BgSAP.ERNAM);
            TermOfPaymentList.add(BgSAP.ZTERM);
        }
        AccountList = [SELECT Id, AccountNumber__c FROM Account where AccountNumber__c in :CustomerList];
        UserList = [SELECT Id, Name FROM User where Name in :CreatedByList ];
        MasterMapList = [SELECT Id,Code__c FROM Master_Map__c where Code__c in :TermOfPaymentList and Type__c ='Payment Term'];
        Map<String,String> AccNameId = new Map<String,String>();
        Map<String,String> CreatedById = new Map<String,String>();
        Map<String,String> TermOfPaymentMap = new Map<String,String>();
        for(Account thisAcc : AccountList){
            AccNameId.put( thisAcc.AccountNumber__c,thisAcc.Id);
        }
        for(User thisUser : UserList){
            CreatedById.put(thisUser.Name,thisUser.Id);
        }
        for(Master_Map__c thisMasterMap : MasterMapList){
            TermOfPaymentMap.put(thisMasterMap.Code__c,thisMasterMap.Id);
        }
        List<C360_BankGuarantee__c> upsertedBankGuarantee = new List<C360_BankGuarantee__c>();
        for(BankGuaranteeFromSAP BgSAP : BgList){
            if(AccNameId.containskey(BgSAP.KUNNR)){
                C360_BankGuarantee__c GrSF = new C360_BankGuarantee__c();
                GrSF.Customer__c = (AccNameId.get(BgSAP.KUNNR) != null) ? AccNameId.get(BgSAP.KUNNR) : null;
                GrSF.AllowedOverdraft__c = BgSAP.EUPRZ;
                GrSF.BankName__c = BgSAP.BANKA;
                GrSF.BankNumber__c = BgSAP.BANKL;
                GrSF.CompanyCode__c = BgSAP.BUKRS;
                GrSF.CreatedBy__c = (CreatedById.get(BgSAP.ERNAM) != null) ? CreatedById.get(BgSAP.ERNAM):null;
                GrSF.CreatedDateTime__c = BgSAP.ERDAT_TS;
                GrSF.Currency__c = BgSAP.WAERS;
                GrSF.DateOfReceipt__c = BgSAP.AJDAT;
                GrSF.BankGuaranteeSAPNumber__c = BgSAP.BAANR;
                GrSF.Key__c = BgSAP.LCNUM;
                GrSF.DocumentStatus__c = BgSAP.AKKST;
                GrSF.Incoterms1__c = BgSAP.INCO1;
                GrSF.Incoterms2__c = BgSAP.INCO2;
                GrSF.LatestShippingDate__c = BgSAP.AYDAT;
                GrSF.OpeningDate__c = BgSAP.AIDAT;
                GrSF.Reason__c = BgSAP.AENDGRUND;
                GrSF.ReasonForChange__c = BgSAP.KOMME;
                GrSF.RequestDate__c = BgSAP.AADAT;
                GrSF.TermsOfPayment__c = (TermOfPaymentMap.get(BgSAP.ZTERM) != null) ? TermOfPaymentMap.get(BgSAP.ZTERM) : null;
                GrSF.AdditionalInformation__c = BgSAP.EXDKB;
                GrSF.Type__c = BgSAP.AKART;
                GrSF.ExpiryDate__c = BgSAP.AXDAT;
                upsertedBankGuarantee.add(GrSF);
            }else{
                MissingCustomer = MissingCustomer + BgSAP.KUNNR +',';
            }
        }
        if(MissingCustomer.right(1)==','){
            MissingCustomer = MissingCustomer.Substring(0,MissingCustomer.length()-1) + ']';
        }else{
            MissingCustomer = MissingCustomer + ']';
        }
        if(upsertedBankGuarantee.size() > 0){
            Schema.SObjectField Key = C360_BankGuarantee__c.Fields.Key__c;
            BankGuarantee_resultList = Database.upsert(upsertedBankGuarantee,Key,false);
            if(BankGuarantee_resultList.size() > 0){
                List<String> BankGuaranteeIdList_suc = new List<String>();
                List<String> BankGuarantee_errorMsg_List = new List<String>();
                Map<String,List<String>> BankGuarantee_errorMap = new Map<String,List<String>>();
                for(Integer idx = 0; idx <BankGuarantee_resultList.size(); idx++){
                    if(BankGuarantee_resultList[idx].isSuccess()){
                        BankGuaranteeIdList_suc.add(BankGuarantee_resultList[idx].getId());
                    }else{
                        BankGuarantee_errorMsg_List = new List<String>();
                        for(Database.Error err : BankGuarantee_resultList[idx].getErrors()){
                            BankGuarantee_errorMsg_List.add('Field:' + err.getFields() + ': ' + err.getMessage());
                        }
                    }
                    BankGuarantee_errorMap.put(BankGuarantee_resultList[idx].getId(),BankGuarantee_errorMsg_List);
                }
                if(BankGuarantee_errorMsg_List.size() > 0) {
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Log_Type__c = 'Fail';
                    log.Integration_Name__c = 'C360 Replicated SAP BankGuarantees';
                    log.Message_Type__c = 'Fail';
                    log.Error_Message__c = ('BankGuarantee - '+BankGuarantee_errorMap.keyset()+' : '+BankGuarantee_errorMap.values()).abbreviate(131000);
                    log.Response_Body__c = JSON.serialize(BgList).abbreviate(121000);
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                } 
                else {
                    Application_Log__c log = new Application_Log__c();
                    log.Method__c = 'Upsert';
                    log.Log_Type__c = 'Success';
                    log.Integration_Name__c = 'C360 Replicated SAP BankGuarantees';
                    log.Message_Type__c = 'Success';
                    log.Response_Body__c = JSON.serialize(BgList).abbreviate(121000);
                    log.Error_Message__c = MissingCustomer;
                    log.OwnerId = UserInfo.getUserId();
                    insertApplogList.add(log);
                }
                if(insertApplogList.size() > 0){
                    insert insertApplogList;
                }
            }
        }
        Application_Log__c log = new Application_Log__c();
        log.Method__c = 'Upsert';
        log.Integration_Name__c = 'C360 Replicated SAP BankGuarantees';
        log.Log_Type__c = 'Success';
        log.Message_Type__c = 'Success';
        log.Error_Message__c = MissingCustomer;
        log.OwnerId = UserInfo.getUserId();
        return upsertedBankGuarantee;
    }
    private static Date StringToDate(String dateString){
        List<String> dates = new List<String>();
        if(Decimal.valueOf(dateString.left(4)) < 1700){
            dates.add('1700');
        }else if(Decimal.valueOf(dateString.left(4)) > 4000){
            dates.add('4000');
        }else{
            dates.add(dateString.left(4));
        }
        dates.add(dateString.mid(5, 2));
        dates.add(dateString.mid(8, 2));
        Date output;
        try{
            string test = String.join(dates,'-');
            output = Date.valueOf(String.join(dates,'-'));
        }catch(System.TypeException ex){
            output = null;
        }
        return output;
    }
}