public class CTRApprovalDetailController 
{
    
    @AuraEnabled(cacheable=true)
    public static List<CTRRequestFormItem__c> getRequestFormItem(String recID)
    {
     try
     {
         if(recID != '' || recID != null)
        {
            List<CTRRequestFormItem__c>itemList =  [SELECT id,InternalCreditRatingTOP__c,ApprovalTrader_CreditCondition__c,CreditOwner__c,OwnersSectionHead__c,OwnersCMVP__c
                                                    ,ImportExcelSummary__c,HavingCreditTermorLetter__c,PerformanceBond__c,RecordTypeName__c,Trade_Credit_Insurance__c
                                                    ,TradeCreditInsuranceCurrency__c,OwnerId,IsTraderSaved__c,TermOfPayment__r.Code__c,PaymentCondition__c,CreditLimit__c
                                                    ,CreditLimitCurrency__c,Approval_SHAgree__c,Approval_VPAgree__c,TraderWaive__c,PaymentTerm__c,ApprovalTrader_CreditRating__c
                                                    ,ApproverStep__c,WaiveRequest__c,TraderRemark__c, Name,Credit_Condition__c,ReputationInTheMarket__c,ResultFromNewsScreening__c
                                                    ,LinkToNEWS__c,TypeOfBusiness__c,CashOnDelivery__c,HavingCollateral__c,BuyTradeEndorsement__c,BuyTradeDCLCondition__c
                                                    ,HavingOpenedCredit__c, InternalCreditRating__c,    TotalSecuredAmount__c ,isTRCR__c,BusinessUnit__c,Customer__c,
                                                    SubBU__c,CTRRequestFormHeader__r.Country__r.Code__c,RecordType.DeveloperName,Approval_Step__c,FinancialKey__c
                                                    ,InterestedProductTypeAsCustomerTOP__c,InterestedProductTypeAsCustomerTX__c,InterestedProductTypeAsSupplierTOP__c,InterestedProductTypeAsSupplierTX__c,
                                                    CTRRequestFormHeader__r.Email__c,CTRRequestFormHeader__r.FirstName__c,CTRRequestFormHeader__r.LastName__c,CTRRequestFormHeader__r.MobilePhone__c,InterestedProductTypeAsSupplier__c,
                                                    ChangeCreditInternalCreditRating__c, ChangeCreditCreditCondition__c, ChangeCreditCreditLimit__c, ChangeCreditCreditLimitCurrency__c, ChangeCreditTradeCreditInsurance__c, ChangeCreditTradeCreditInsuranceCurrency__c
                                                    ,RequestToChangeCredit__c, SubTypeCondition__c, ChangeCreditAmount__c,SubTypeCondition2__c, EffectiveDateForm__c, EffectiveDateTo__c
                                                    FROM CTRRequestFormItem__c WHERE id =: recID];
            
            String Process = 'ApprovalDetail';
            String BusinessUnit = itemList[0].BusinessUnit__c;
            String SalesOrg = itemList[0].SubBU__c;
            String isDom = itemList[0].CTRRequestFormHeader__r.Country__r.Code__c == 'TH' ? 'Domestic':'International';
            String RecordType = itemList[0].RecordType.DeveloperName.contains('Customer') ? 'Customer':'Supplier';
            String Product = '';
            String CrudeProd = itemList[0].InterestedProductTypeAsSupplierTOP__c;
            String TRCR = 'Credit';
            system.debug('-----CrudeProd------'+CrudeProd);
            system.debug('-----SalesOrg------'+SalesOrg);
            system.debug('------RecordType-----'+RecordType);
            if(CrudeProd != '' && CrudeProd != null)
            {
                if(SalesOrg == 'TOP' && RecordType == 'Supplier' && CrudeProd.contains('Crude'))
                {
                    Product = 'Crude';
                }
            }
            String isByTX = 'No';
            String VP = 'VP';
            Map<String,List<String>>actorMap = CTRRequestFormItemController.getActor(Process,SalesOrg,isDom,RecordType,Product,isByTX,'');           
            if(actorMap != null)
            {
                if(actorMap.get(TRCR) != null )
                {
                    itemList[0].isTRCR__c = '(';
                    Integer count = 0;
                    for(String temp : actorMap.get(TRCR))
                    {
                        itemList[0].isTRCR__c +='\''+temp+'\'';
                        if(count != actorMap.get(TRCR).size()- 1)
                        {
                            itemList[0].isTRCR__c +=',';
                        }
                        count += 1;
                    }
                    itemList[0].isTRCR__c += ')';
                    
                    
                }
                if(actorMap.get('TraderHead') != null)
                {
                    if(actorMap.get('TraderHead').size() > 0)
                    {
                        itemList[0].OwnersSectionHead__c = actorMap.get('TraderHead')[0];
                    }
                    
                }
                if(actorMap.get(VP) != null)
                {
                    if(actorMap.get(VP).size() > 0)
                    {
                        itemList[0].OwnersCMVP__c = actorMap.get(VP)[0];
                    }
                    
                }
                
            }
            
            if(itemList[0].ApproverStep__c == null || itemList[0].ApproverStep__c == '')
            {
                itemList[0].ApproverStep__c = 'TRCR';
            }
            List<String>sharepointLinkList = CTRSharePointLinkController.getSharepointPath(recID,'03');
            
           	itemList[0].ImportExcelSummary__c = sharepointLinkList.size() > 0 ? sharepointLinkList[0] : '';
            
            return itemList;
        } 
        else
        {
            return null; 
        }
     }
      catch(Exception e)
      {
          system.debug('ApprovalDetail Error : '+e.getMessage()+' line:'+e.getLineNumber());
          return null; 
      }
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<C360_FinancialInfo__c> getExtingFinancialInfo(String key, String accountId)
    {
        try
        {
            List<C360_FinancialInfo__c>itemList =  [SELECT id,Credit_Condition__c,CreditLimit__c,InternalCreditRating__c,PaymentCondition__c
                                                    FROM C360_FinancialInfo__c WHERE Key__c =: key AND CompanyName__c =: accountId];
            return itemList;
        }
        catch(Exception e)
        {
            system.debug('ApprovalDetail Error : '+e.getMessage()+' line:'+e.getLineNumber());
            return null; 
        }
        
    }
    
    @AuraEnabled
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        for(sObject so : Database.Query('Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\'')) {
            String fieldvalue = (String)so.get(fieldName);
            sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
        }
        
        return sObjectResultList;
    }
    
    public class SObJectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
    }

    public class CompanyNameModel {
        public String companyName{ get; set; }
        //NO MAPPING FIELD 20/01/2024
        public String forCompany{ get; set; }
        public String requestedFor{ get; set; }
        //////////////////////////////
        public String companyLocalName{ get; set; }
        public String address{ get; set; }
        public String incorporationDate{ get; set; }
        public String country{ get; set; }
        public String ceo{ get; set; }
        public String shareholders{ get; set; }
        public String parentCompany{ get; set; }
        public String mainServicesAndProducts{ get; set; }
        public String creditRating{ get; set; }
        public String hasSanctionedTarget{ get; set; }
        public String hasSanctionedShareholder{ get; set; }
        public String hasSanctionedCEO{ get; set; }
        public String hasAntiMoneyViolation{ get; set; }
        public String hasCEORelatedToTOP{ get; set; }
        public String supplierDeliverOverTheLast3Years{ get; set; }
        public String customerPaymentOverTheLast3Years{ get; set; }
        public String paymentHistory{ get; set; }
        public String hasEnvironmentalPolicy{ get; set; }
        public String hasSocialResponsibilityPolicy{ get; set; }
        public String hasCorporateGovernancePolicy{ get; set; }
        public String internalCreditRating{ get; set; }
        public String creditCondition{ get; set; }
        public String estimatedStartDate{ get; set; }
        public String traderComment{ get; set; }
        // public String traderComment2{ get; set; }
        //NO MAPPING FIELD 20/01/2024
        public String trcrAnalysis{ get; set; }
        public String evpfApproval{ get; set; }
        public String evpfRemark{ get; set; }
        public String evpcApproval{ get; set; }
        public String evpcRemark{ get; set; }
        public String trvpApproval{ get; set; }
        public String trvpRemark{ get; set; }
        public String cmvpApproval{ get; set; }
        public String cmvpRemark{ get; set; }
        public String acvpApproval{ get; set; }
        public String acvpRemark{ get; set; }
        public String tlbmdApproval{ get; set; }
        public String tlbmdRemark{ get; set; }
        public String tpxmdApproval{ get; set; }
        public String tpxmdRemark{ get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static String CTRDownloadExcelTemplate(String recordId){
        CTRRequestFormItem__c companyName = [SELECT Id,Customer__r.Name,
                                             CTRRequestFormHeader__r.CompanyNameENF__c ,  
                                             CTRRequestFormHeader__r.CompanyNameLocal__c,
                                             CTRRequestFormHeader__r.MailingBuildingCode__c, 
                                             CTRRequestFormHeader__r.StreetLocal__c, 
                                             CTRRequestFormHeader__r.Street2Local__c, 
                                             CTRRequestFormHeader__r.Street3Local__c, 
                                             CTRRequestFormHeader__r.Street4Local__c, 
                                             //CTRRequestFormHeader__r.CityStateLocalText__c, 
                                             CTRRequestFormHeader__r.DistrictLocalText__c, 
                                             CTRRequestFormHeader__r.PostalCodeLocalText__c, //no this field
                                             CTRRequestFormHeader__r.Country__c, 
                                             CTRRequestFormHeader__r.Country__r.Name, 
                                             CTRRequestFormHeader__r.IncoperationDate__c, 
                                             CTRRequestFormHeader__r.ImmidiateParentCompany__c, 
                                             CTRRequestFormHeader__r.UltimateParentCompany__c, 
                                             CTRRequestFormHeader__r.MainProduct__c , 
                                             CTRRequestFormHeader__r.MainService__c , 
                                             CTRRequestFormHeader__r.HasSanctionedTarget__c , 
                                             CTRRequestFormHeader__r.PaymentOverTheAmountOfUSD__c , 
                                             CTRRequestFormHeader__r.PaymentHistoryRecord__c , 
                                             CTRRequestFormHeader__r.CEOFirstName__c ,
                                             CTRRequestFormHeader__r.CEOLastName__c,
                                             CTRRequestFormHeader__r.CityStateLocal__r.Description__c,
                                             CTRRequestFormHeader__r.CityStateLocal__c,
                                             CTRRequestFormHeader__c,
                                             InternalCreditRating__c,
                                             CompanyLatestCreditRating__c,
                                             Credit_Condition__c ,
                                             StartTradingDate__c ,
                                             TraderPreScreenComment__c ,
                                             SalesOrganization__c,
                                             RecordType.Name,AdditionalOpinions__c,
                                             CTRRequestFormHeader__r.CorporateGovernancePolicy__c,CTRRequestFormHeader__r.EnvironmentPolicy__c,CTRRequestFormHeader__r.SocialResponsibilityPolicy__c
                                             
                                             FROM CTRRequestFormItem__c WHERE Id=:recordId];
        
        List<CTRShareholder__c>shareholderList = [select name from CTRShareholder__c where CTRRequestFormHeader__c =: companyName.CTRRequestFormHeader__c];
        String shareholderName = '';
        Integer count = 0;
        for(CTRShareholder__c sh : shareholderList)
        {
            if(count != shareholderList.size()-1)
            {
                shareholderName += sh.name+',';
            }
            else
            {
                shareholderName += sh.name;
            }
            
        }
        
        List<CTRCDDSanction__c>sanctionList = [select Id from CTRCDDSanction__c WHERE Type__c = 'WorldCheckOne' AND RequestFormHeader__c =: companyName.CTRRequestFormHeader__c AND FindingWeb__c = 'Found'];
        
        
        
        System.debug(companyName.Customer__r.Name);
        CompanyNameModel companyNameModel = new CompanyNameModel();
        //companyNameModel.forCompany ='TOP,TLB,TPX';
        //companyNameModel.requestedFor ='requestedFor';

        if(sanctionList.size() > 0)
        {
            companyNameModel.hasSanctionedShareholder ='Yes';
            companyNameModel.hasSanctionedCEO ='Yes';
        }
        else
        {
            companyNameModel.hasSanctionedShareholder ='No';
            companyNameModel.hasSanctionedCEO ='No';
        }
        //companyNameModel.forCompany ='TOP,TLB,TPX';
        //companyNameModel.requestedFor ='requestedFor';
        
        companyNameModel.supplierDeliverOverTheLast3Years =''; //waiting comX
        companyNameModel.trcrAnalysis =''; //connot map
        companyNameModel.evpfApproval =''; //connot map
        companyNameModel.evpfRemark =''; //connot map
        companyNameModel.evpcApproval =''; //connot map
        companyNameModel.evpcRemark ='';//connot map
        companyNameModel.trvpApproval ='';//connot map
        companyNameModel.trvpRemark ='';//connot map
        companyNameModel.cmvpApproval ='';//connot map
        companyNameModel.cmvpRemark ='';//connot map
        companyNameModel.acvpApproval ='';//connot map
        companyNameModel.acvpRemark ='';//connot map
        companyNameModel.tlbmdApproval ='';//connot map
        companyNameModel.tlbmdRemark ='';//connot map
        companyNameModel.tpxmdApproval ='';//connot map
        companyNameModel.tpxmdRemark ='';//connot map
        // companyNameModel.hasSanctionedShareholder ='';//connot map
        // companyNameModel.hasSanctionedCEO ='';//connot map
        companyNameModel.hasAntiMoneyViolation ='';//connot map
        companyNameModel.hasCEORelatedToTOP ='';//connot map
        //companyNameModel.hasEnvironmentalPolicy ='Yes';
        //companyNameModel.hasSocialResponsibilityPolicy =''; //connot map
        //companyNameModel.hasCorporateGovernancePolicy ='Yes';
        
        companyNameModel.shareholders =shareholderName;
        companyNameModel.companyName =companyName.CTRRequestFormHeader__r.CompanyNameENF__c !=null ?  companyName.CTRRequestFormHeader__r.CompanyNameENF__c :'';
        companyNameModel.companyLocalName =companyName.CTRRequestFormHeader__r.CompanyNameLocal__c !=null ?  companyName.CTRRequestFormHeader__r.CompanyNameLocal__c :'';
        companyNameModel.address =companyName.CTRRequestFormHeader__r.MailingBuildingCode__c !=null ?  companyName.CTRRequestFormHeader__r.MailingBuildingCode__c +' ':'';
        companyNameModel.address +=companyName.CTRRequestFormHeader__r.StreetLocal__c !=null ?  companyName.CTRRequestFormHeader__r.StreetLocal__c +' ':'';
        companyNameModel.address +=companyName.CTRRequestFormHeader__r.Street2Local__c !=null ?  companyName.CTRRequestFormHeader__r.Street2Local__c +' ':'';
        companyNameModel.address +=companyName.CTRRequestFormHeader__r.Street3Local__c !=null ?  companyName.CTRRequestFormHeader__r.Street3Local__c +' ':'';
        companyNameModel.address +=companyName.CTRRequestFormHeader__r.Street4Local__c !=null ?  companyName.CTRRequestFormHeader__r.Street4Local__c +' ':'';
        companyNameModel.address +=companyName.CTRRequestFormHeader__r.DistrictLocalText__c !=null ?  companyName.CTRRequestFormHeader__r.DistrictLocalText__c +' ':'';
        //companyNameModel.address +=companyName.CTRRequestFormHeader__r.CityStateLocalText__c !=null ?  companyName.CTRRequestFormHeader__r.CityStateLocalText__c +' ':'';
        companyNameModel.address +=companyName.CTRRequestFormHeader__r.CityStateLocal__c !=null ?  companyName.CTRRequestFormHeader__r.CityStateLocal__r.Description__c +' ':'';
        companyNameModel.address +=companyName.CTRRequestFormHeader__r.PostalCodeLocalText__c !=null ?  companyName.CTRRequestFormHeader__r.PostalCodeLocalText__c +' ':'';
        //companyNameModel.companyName =//CTRRequestFormHeader__r.PostalCodeLocalEnText__c,//nothisfiel !=null ?  //CTRRequestFormHeader__r.PostalCodeLocalEnText__c,//nothisfiel :'';
        companyNameModel.address +=companyName.CTRRequestFormHeader__r.Country__c !=null ?  companyName.CTRRequestFormHeader__r.Country__r.Name +' ':''; 
         
        companyNameModel.incorporationDate =companyName.CTRRequestFormHeader__r.IncoperationDate__c !=null ?  String.valueof(companyName.CTRRequestFormHeader__r.IncoperationDate__c) :'';
        companyNameModel.country =companyName.CTRRequestFormHeader__r.Country__c !=null ?  companyName.CTRRequestFormHeader__r.Country__r.Name :'';
        companyNameModel.parentCompany =companyName.CTRRequestFormHeader__r.ImmidiateParentCompany__c !=null ?  companyName.CTRRequestFormHeader__r.ImmidiateParentCompany__c :'';
        companyNameModel.parentCompany +=companyName.CTRRequestFormHeader__r.UltimateParentCompany__c !=null ?  companyName.CTRRequestFormHeader__r.UltimateParentCompany__c :'';
        companyNameModel.mainServicesAndProducts =companyName.CTRRequestFormHeader__r.MainProduct__c !=null ?  companyName.CTRRequestFormHeader__r.MainProduct__c :'';
        companyNameModel.mainServicesAndProducts +=companyName.CTRRequestFormHeader__r.MainService__c !=null ?  companyName.CTRRequestFormHeader__r.MainService__c :'';
        companyNameModel.hasSanctionedTarget =companyName.CTRRequestFormHeader__r.HasSanctionedTarget__c !=null ?  companyName.CTRRequestFormHeader__r.HasSanctionedTarget__c :'';
        companyNameModel.customerPaymentOverTheLast3Years =companyName.CTRRequestFormHeader__r.PaymentOverTheAmountOfUSD__c !=null ?  companyName.CTRRequestFormHeader__r.PaymentOverTheAmountOfUSD__c :'';
        companyNameModel.paymentHistory =companyName.CTRRequestFormHeader__r.PaymentHistoryRecord__c !=null ?  String.valueof(companyName.CTRRequestFormHeader__r.PaymentHistoryRecord__c) :'';
        companyNameModel.internalCreditRating =companyName.InternalCreditRating__c !=null ?  companyName.InternalCreditRating__c :'';
        companyNameModel.creditCondition =companyName.Credit_Condition__c !=null ?  companyName.Credit_Condition__c :'';
        companyNameModel.estimatedStartDate =companyName.StartTradingDate__c !=null ?  String.valueof(companyName.StartTradingDate__c) :'';
        companyNameModel.traderComment =companyName.AdditionalOpinions__c !=null ?  companyName.AdditionalOpinions__c :'';
        // companyNameModel.traderComment2 =companyName.TraderPreScreenComment__c !=null ?  companyName.TraderPreScreenComment__c :'';
        companyNameModel.ceo =companyName.CTRRequestFormHeader__r.CEOFirstName__c !=null ?  companyName.CTRRequestFormHeader__r.CEOFirstName__c +' ':'';
        companyNameModel.ceo +=companyName.CTRRequestFormHeader__r.CEOLastName__c !=null ?  companyName.CTRRequestFormHeader__r.CEOLastName__c :'';
        companyNameModel.creditRating =companyName.CompanyLatestCreditRating__c !=null ?  companyName.CompanyLatestCreditRating__c :'';
        companyNameModel.forCompany = companyName.SalesOrganization__c !=null ?  companyName.SalesOrganization__c :'';
        companyNameModel.requestedFor =companyName.RecordType.Name.contains('Customer') ?  'Customer' :'Supplier';
        companyNameModel.hasCorporateGovernancePolicy = companyName.CTRRequestFormHeader__r.CorporateGovernancePolicy__c !=null ?  companyName.CTRRequestFormHeader__r.CorporateGovernancePolicy__c :'';
        companyNameModel.hasEnvironmentalPolicy = companyName.CTRRequestFormHeader__r.EnvironmentPolicy__c !=null ?  companyName.CTRRequestFormHeader__r.EnvironmentPolicy__c :'';
        companyNameModel.hasSocialResponsibilityPolicy = companyName.CTRRequestFormHeader__r.SocialResponsibilityPolicy__c !=null ?  companyName.CTRRequestFormHeader__r.SocialResponsibilityPolicy__c :'';
        String jsonInput = JSON.serialize(companyNameModel );
        System.debug('Test JSON:::'+jsonInput);
        
        //jsonInput = '{ "forCompany": "TOP,TLB,TPX", "requestedFor": "Customer,Supplier", "companyName": "R2 Solutions Co.,Ltd.", "companyLocalName": "ราวด์ ทู โซลูชั่นส์", "address": "111, My Home, 11511", "incorporationDate": "18/01/2024", "country": "Thailand", "ceo": "Moke Krisnangkura", "shareholders": "Moke K.", "parentCompany": "R1 Solutions Co.,Ltd.", "mainServicesAndProducts": "Petroleum Products", "creditRating": "5.0", "hasSanctionedTarget": "Yes", "hasSanctionedShareholder": "Yes", "hasSanctionedCEO": "Yes", "hasAntiMoneyViolation": "Yes", "hasCEORelatedToTOP": "Yes", "supplierDeliverOverTheLast3Years": "Yes", "customerPaymentOverTheLast3Years": "Yes", "paymentHistory": "Not Available", "hasEnvironmentalPolicy": "Yes", "hasSocialResponsibilityPolicy": "Yes", "hasCorporateGovernancePolicy": "Yes", "internalCreditRating": "5.0", "creditCondition": "Cash on Delivery", "estimatedStartDate": "31/12/2222", "traderComment": "Proceed", "trcrAnalysis": "Good Credit with No Condition", "evpfApproval": "Approved", "evpfRemark": "OK", "evpcApproval": "Approved", "evpcRemark": "Pass", "trvpApproval": "Approved", "trvpRemark": "Done", "cmvpApproval": "Approved", "cmvpRemark": "Great", "acvpApproval": "Approved", "acvpRemark": "Good", "tlbmdApproval": "Approved", "tlbmdRemark": "Very Good", "tpxmdApproval": "Approved", "tpxmdRemark": "Excellent" }';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');  
        request.setHeader('Content-Type', 'application/json');     
        request.setBody(jsonInput);
        request.settimeout(120000);
        // Get Custom Setting URL for enpoint.
        CTRConfig__c customSetting = CTRConfig__c.getInstance();
        String valueURL = customSetting.CreditRating__c;
        System.debug(valueURL);
        request.setEndpoint(valueURL);
        HttpResponse response = http.send(request);
        // value base64 to String in JSON
        Map<String, Object> parsedResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        String fileBase64 = (String)parsedResponse.get('base64');
        try {
            // Make the HTTP request
            response = http.send(request);
            // Parse and handle the response
            if (response.getStatusCode() == 200) {
                // Successful response
                fileBase64 = (String)parsedResponse.get('base64');
                System.debug('Response: ' + response.getBody());
            } else {
                // Error handling
                fileBase64 = 'Error:'+response.getStatusCode() + ' ' + response.getStatus();
                System.debug('HTTP error: ' + response.getStatusCode() + ' ' + response.getStatus());
                System.debug('Response: ' + response.getBody());
            }
            return fileBase64;
        } catch (Exception e) {
            // Exception handling
            System.debug('Exception: ' + e.getMessage());
            return e.getMessage();
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static CTRBuProfile__mdt getBUInfo(Id recordId)
    {
        try 
        {
            CTRBuProfile__mdt currentuserBU = CTRBuProfileController.checkBusinessUnitFromProfile(UserInfo.getUserId(),recordId);
            system.debug('=====currentuserBU======'+currentuserBU);
            return currentuserBU;
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null;
        }
    }
    
}