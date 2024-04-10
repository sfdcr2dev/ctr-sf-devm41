public without sharing class CTRCalloutComXCtrl {
    
    //-----ctrCode >> new fields but use mock data for now
    //-----sapCode >> 
    // if type contain customer >> Customer__r.AccountNumber__c
    // if type contain supplier >> Customer__r.SupplierNumber__c
    //-----type >> RecordType.Name >>
    // -New Customer
    // -New Supplier
    // -Extend Customer
    // -Extend Supplier
    //-----name >>  Customer__r.CustomerNameLocal1__c + Customer__r.CustomerNameLocal2__c	
    //ex.THE AROMATICS (THAILAND) PUBLIC + COMPANY LIMITED
    
    public class CustomerWrapper 
    {
        public Cust Cust { get; set; }
        public CustDetail CustDetail { get; set; }
    }
    
    public class Cust 
    {
        public string MCT_CUST_NUM {get; set;}
        public string MCT_STATUS{get; set;}
        public string MCT_CREATE_TYPE{get; set;}
        public string MCT_CREATED_DATE{get; set;}
        public string MCT_UPDATED_DATE{get; set;}
        public string MCT_UPDATED_BY{get; set;}
        public string MCT_CREATED_BY{get; set;}
    }
    
    public class CustDetail 
    {
        public string MCD_FK_CUS{get; set;}
        public string MCD_FK_COMPANY{get; set;}
        public string MCD_NATION{get; set;}
        public string MCD_NAME_1{get; set;}
        public string MCD_NAME_2{get; set;}
        public string MCD_CITY{get; set;}
        public string MCD_DISTRICT{get; set;}
        public string MCD_CITY_POS_CODE{get; set;}
        public string MCD_STREET{get; set;}
        public string MCD_HOUSE_NUM{get; set;}
        public string MCD_COUNT_KEY1{get; set;}
        public string MCD_PHONE_NO_DIALLING{get; set;}
        public string MCD_TAX_NUMBER_1{get; set;}
        public string MCD_NAME_PER_CREAT{get; set;}
        public string MCD_KTOKD{get; set;}
        public string MCD_STATUS{get; set;}
        public string MCD_CREATED_DATE{get;set;}
        public string MCD_CREATED_BY{get;set;}
        public string MCD_UPDATED_BY{get;set;}
        public string MCD_UPDATED_DATE{get;set;}
    }
    
    public class VendorWrapper 
    {
        public Vendor vendor { get; set; }
        public VendorData vendorData { get; set; }
    }
    
    public class Vendor 
    {
        public String vnD_ACC_NUM_VENDOR { get; set; }
        public String vnD_NAME1 { get; set; }
        public String vnD_NAME2 { get; set; }
        public String vnD_CITY { get; set; }
        public String vnD_DISTRICT { get; set; }
        public String vnD_POSTAL_CODE { get; set; }
        public String vnD_HOUSE_NUM_STREET { get; set; }
        public String vnD_STATUS { get; set; }
        public String vnD_CREATED_DATE { get; set; }
        public String vnD_CREATED_BY { get; set; }
        public string vnD_UPDATED_DATE { get; set; }
        public String vnD_UPDATED_BY { get; set; }
        public String vnD_CREATE_TYPE { get; set; }
    }
    
    public class VendorData 
    {
        public String mvD_FK_COMPANY { get; set; }
        public String mvD_FK_VENDOR { get; set; }
        public String mvD_STATUS { get; set; }
        public string mvD_CREATED_DATE { get; set; }
        public String mvD_CREATED_BY { get; set; }
        public String mvD_UPDATED_BY { get; set; }
        public String mvD_UPDATED_DATE { get; set; }
    }
    
    @future (callout=true)
    public static void callSoapApiUpdate(String sapCode, String ctrCode, String name, String type, String extId) {
        System.debug('--callSoapApiUpdate--');
        
        System.debug('--sapCode--'+sapCode);
        System.debug('--ctrCode--'+ctrCode);
        System.debug('--name--'+name);
        System.debug('--type--'+type);
        String soapRequestForCatch = '<?xml version="1.0" encoding="utf-8"?>' +
            '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
            'xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' +
            'xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">' +
            '<soap12:Body>' +
            '<CTRupdateMaster xmlns="http://tempuri.org/">' +
            '<sapCode>' + sapCode + '</sapCode>' +
            '<ctrCode>' + ctrCode + '</ctrCode>' +
            '<name>' + name + '</name>' +
            '<type>' + type + '</type>' +
            '</CTRupdateMaster>' +
            '</soap12:Body>' +
            '</soap12:Envelope>';
        
        // Define the SOAP request body
        List<Application_Log__c> applogList = new List<Application_Log__c>();
        try {
            String soapRequest = '<?xml version="1.0" encoding="utf-8"?>' +
                '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
                'xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' +
                'xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">' +
                '<soap12:Body>' +
                '<CTRupdateMaster xmlns="http://tempuri.org/">' +
                '<sapCode>' + sapCode + '</sapCode>' +
                '<ctrCode>' + ctrCode + '</ctrCode>' +
                '<name>' + name + '</name>' +
                '<type>' + type + '</type>' +
                '</CTRupdateMaster>' +
                '</soap12:Body>' +
                '</soap12:Envelope>';
            
            // Define the SOAP endpoint URL
            String soapEndpoint = 'https://d-comxapi.thaioilgroup.com/ServiceProvider/WsPublic.asmx';
            
            // Create the HTTP request
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint(soapEndpoint);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Content-Type', 'application/soap+xml; charset=utf-8');
            httpRequest.setHeader('Content-Length', String.valueOf(soapRequest.length()));
            httpRequest.setBody(soapRequest);
            
            // Create the HTTP connection
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            
            // Process the SOAP response
            if (httpResponse.getStatusCode() == 200) {
                // Parse and handle the SOAP response if needed
                String soapResponse = httpResponse.getBody();
                System.debug('The soapResponse: ' + soapResponse);
                System.debug('The soapResponse statuscode: ' + httpResponse.getStatusCode());
                
                if(soapResponse.contains('Success')){
                    Application_Log__c log = new Application_Log__c();
                    log.External_ID__c = 'ComX-'+extId;
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = type.toLowercase().contains('customer') ? 'CTR ComX Callout Update Customer' : 'CTR ComX Callout Update Supplier';
                    log.Log_Type__c = 'Success';
                    log.Message_Type__c = 'Success';
                    log.Request_Body__c = JSON.serialize(soapRequest).abbreviate(131000);
                    log.Response_Body__c = JSON.serialize(soapResponse).abbreviate(131000);
                    log.Error_Message__c = 'ComX Success';
                    log.OwnerId = UserInfo.getUserId();
                    applogList.add(log);
                }else{
                    Application_Log__c log = new Application_Log__c();
                    log.External_ID__c = 'ComX-'+extId;
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = type.toLowercase().contains('customer') ? 'CTR ComX Callout Update Customer' : 'CTR ComX Callout Update Supplier';
                    log.Log_Type__c = 'Error';
                    log.Message_Type__c = 'Fail';
                    log.Request_Body__c = JSON.serialize(soapRequest).abbreviate(131000);
                    log.Response_Body__c = JSON.serialize(soapResponse).abbreviate(131000);
                    log.Error_Message__c = 'ComX - '+JSON.serialize(soapResponse).abbreviate(131000);
                    log.OwnerId = UserInfo.getUserId();
                    applogList.add(log);
                }
            } else {
                // Handle the HTTP error
                String soapResponse = httpResponse.getBody();
                String httperr = 'HTTP Error: ' + httpResponse.getStatusCode() + ' ' + httpResponse.getStatus();
                System.debug('HTTP Error: ' + httpResponse.getStatusCode() + ' ' + httpResponse.getStatus());
                
                Application_Log__c log = new Application_Log__c();
                log.External_ID__c = 'ComX-'+extId;
                log.Method__c = 'Upsert';
                log.Integration_Name__c = type.toLowercase().contains('customer') ? 'CTR ComX Callout Update Customer' : 'CTR ComX Callout Update Supplier';
                log.Log_Type__c = 'Error';
                log.Message_Type__c = 'Fail';
                log.Request_Body__c = JSON.serialize(soapRequest).abbreviate(131000);
                log.Response_Body__c = JSON.serialize(soapResponse).abbreviate(131000);
                log.Error_Message__c = 'ComX - '+httperr;
                log.OwnerId = UserInfo.getUserId();
                applogList.add(log);
            }
        }
        catch (Exception e) {
            Application_Log__c log = new Application_Log__c();
            log.External_ID__c = 'ComX-'+extId;
            log.Method__c = 'Upsert';
            log.Integration_Name__c = type.toLowercase().contains('customer') ? 'CTR ComX Callout Update Customer' : 'CTR ComX Callout Update Supplier';
            log.Message_Type__c = 'Fail';
            log.Log_Type__c = 'Error';
            log.Request_Body__c = JSON.serialize(soapRequestForCatch).abbreviate(131000);
            log.Response_Body__c = '';
            log.Error_Message__c = 'ComX - Exception'; //+e.getMessage() + ' line :'+e.getLineNumber()
            log.OwnerId = UserInfo.getUserId();
            applogList.add(log);
        }
        if(applogList.size() > 0){
            upsert applogList External_ID__c;
            //insert applogList ; //External_ID__c;
        }
    }
    
    //After update
    public static void pickOutData(Map<Id,CTRRequestFormItem__c>  mRequestItemOldMap, Map<Id,CTRRequestFormItem__c> mRequestItemNewMap) {
        System.debug('--pickOutData--');
        
        try{
            // System.debug(mRequestItemOldMap);
            System.debug(mRequestItemNewMap);
            
            Set<Id> customerIds = new Set<Id>();
            Set<Id> recordtypeIds = new Set<Id>();
            
            for (CTRRequestFormItem__c mItem : mRequestItemNewMap.values()) 
            {   
                if(mItem.RecordTypeName__c.contains('CustomerInitial') || mItem.RecordTypeName__c.contains('CustomerExtend') ||
                   mItem.RecordTypeName__c.contains('SupplierInitial') || mItem.RecordTypeName__c.contains('SupplierExtend') )
                {
                    if(mItem.SAPStatus__c =='SAP Confirmed Sales/Purchasing View' && 
                       (mRequestItemOldMap.get(mItem.Id).SAPStatus__c != mItem.SAPStatus__c))
                    {
                        customerIds.add(mItem.Customer__c);
                        recordtypeIds.add(mItem.RecordTypeId);
                    }
                }
                
            }
            
            if(!customerIds.isEmpty() && !recordtypeIds.isEmpty())
            {
                List<Account> accountList = [SELECT Id, AccountNumber__c, SupplierNumber__c, CustomerNameLocal1__c, CustomerNameLocal2__c ,SFCode__c 
                                             FROM Account 
                                             WHERE Id IN :customerIds];
                
                List<RecordType> rtList = [SELECT Id,DeveloperName FROM RecordType WHERE SobjectType='CTRRequestFormItem__c' AND Id IN :recordtypeIds];
                
                Map<Id,String> mRecordtype =  new Map<Id,String>();
                for (RecordType rt : rtList) 
                {
                    mRecordtype.put(rt.Id,rt.DeveloperName);
                }
                
                System.debug('--accountList--'+accountList);
                System.debug('--rtList--'+rtList);
                System.debug('--mRecordtype--'+mRecordtype);
                
                for (CTRRequestFormItem__c mItem : mRequestItemNewMap.values()) {
                    System.debug('--pickOutData--' + mItem.Customer__c);
                    System.debug('--mItem--type' + mItem.RecordTypeId);
                    System.debug('--mItem--SAPStatus__c' + mItem.SAPStatus__c);
                    
                    if(mItem.SAPStatus__c != null && mItem.SAPStatus__c.contains('SAP Confirmed Sales/Purchasing View'))
                    {
                        for (Account lAcc : accountList) 
                        {
                            if (lAcc.Id == mItem.Customer__c && (lAcc.CustomerNameLocal1__c != null && lAcc.CustomerNameLocal2__c != null)) 
                            {
                                System.debug('--lAcc--cus--sapcode' + lAcc.AccountNumber__c);
                                System.debug('--lAcc--sup-sapcode' + lAcc.SupplierNumber__c);
                                System.debug('--lAcc--name ' + lAcc.CustomerNameLocal1__c + ' ' + lAcc.CustomerNameLocal2__c);
                                
                                String recId = mItem.Id;
                                String cusNameLocal1 = lAcc.CustomerNameLocal1__c;
                                String cusNameLocal2 = lAcc.CustomerNameLocal2__c;
                                String concatname = cusNameLocal1+' '+cusNameLocal2;
                                //CUSTOMER
                                if(mItem.RecordTypeId != null && (mRecordtype.get(mItem.RecordTypeId).contains('CustomerInitial') || mRecordtype.get(mItem.RecordTypeId).contains('CustomerExtend')))
                                {
                                    // CTRRequestFormItem__c mOldItem = mRequestItemOldMap.get(mItem.Id);
                                    
                                    //เติม 0 ให้ครบ 10 ตำแหน่ง
                                    // Customer
                                    // 1802
                                    // 0000001802
                                    Integer accNumber = Integer.valueOf(lAcc.AccountNumber__c);
                                    String formattedAccNumber = ('0000000000' + String.valueOf(accNumber)).right(10);
                                    
                                    String sapCode = formattedAccNumber;
                                    String ctrCode = 'CPAI-'+lAcc.SFCode__c;
                                    String type = 'CUSTOMER';//CUSTOMER
                                    callSoapApiUpdate(sapCode,ctrCode,concatname,type,recId);
                                }
                                //SUPPLIER
                                else if(mItem.RecordTypeId != null && (mRecordtype.get(mItem.RecordTypeId).contains('SupplierInitial') || mRecordtype.get(mItem.RecordTypeId).contains('SupplierExtend')))
                                {
                                    // CTRRequestFormItem__c mOldItem = mRequestItemOldMap.get(mItem.Id);
                                    
                                    String sapCode = lAcc.SupplierNumber__c;
                                    String ctrCode = 'VND-'+lAcc.SFCode__c;
                                    String type = 'VENDOR'; //VENDOR
                                    callSoapApiUpdate(sapCode,ctrCode,concatname,type,recId);
                                }
                            }
                        }
                    }
                }
            }
        }
        catch(exception e)
        {
            System.debug('Error from CTRCalloutComXCtrl.pickOutData Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }
    
    @future (callout=true)
    public static void callRestApiCreate(String type, String wrapperListRequest, String extid) {
        System.debug('--callRestApiCreate--');
        
        List<Application_Log__c> applogList = new List<Application_Log__c>();
        try {
            
            // Define the REST endpoint URL
            String restEndpoint = 'https://d-comxapi.thaioilgroup.com/Comx_API/'+type;
            System.debug(restEndpoint);
            
            // Create the HTTP request
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint(restEndpoint);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setBody(wrapperListRequest);
            
            // Create the HTTP connection
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            
            // Process the REST response
            if (httpResponse.getStatusCode() == 200) {
                // Parse and handle the REST response if needed
                String restResponse = httpResponse.getBody();
                System.debug('The REST response: ' + restResponse);
                System.debug('The REST response status code: ' + httpResponse.getStatusCode());
                
                if(restResponse.contains('Success') || restResponse.contains('true')){
                    Application_Log__c log = new Application_Log__c();
                    log.External_ID__c = 'ComX-'+extId;
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = type.toLowercase().contains('customer') ? 'CTR ComX Callout Register Customer' : 'CTR ComX Callout Register Supplier';
                    log.Log_Type__c = 'Success';
                    log.Message_Type__c = 'Success';
                    log.Request_Body__c = JSON.serialize(wrapperListRequest).abbreviate(131000);
                    log.Response_Body__c = JSON.serialize(restResponse).abbreviate(131000);
                    log.Error_Message__c = 'ComX Success';
                    log.OwnerId = UserInfo.getUserId();
                    applogList.add(log);
                }else{
                    Application_Log__c log = new Application_Log__c();
                    log.External_ID__c = 'ComX-'+extId;
                    log.Method__c = 'Upsert';
                    log.Integration_Name__c = type.toLowercase().contains('customer') ? 'CTR ComX Callout Register Customer' : 'CTR ComX Callout Register Supplier';
                    log.Log_Type__c = 'Error';
                    log.Message_Type__c = 'Fail';
                    log.Request_Body__c = JSON.serialize(wrapperListRequest).abbreviate(131000);
                    log.Response_Body__c = JSON.serialize(restResponse).abbreviate(131000);
                    log.Error_Message__c = 'ComX - '+JSON.serialize(restResponse).abbreviate(131000);
                    log.OwnerId = UserInfo.getUserId();
                    applogList.add(log);
                }
            } else {
                // Handle the HTTP error
                String restResponse = httpResponse.getBody();
                String httperr = 'HTTP Error: ' + httpResponse.getStatusCode() + ' ' + httpResponse.getStatus();
                System.debug('HTTP Error: ' + httpResponse.getStatusCode() + ' ' + httpResponse.getStatus());
                System.debug('HTTP Error: ' + httpResponse.getBody());
                
                Application_Log__c log = new Application_Log__c();
                log.External_ID__c = 'ComX-'+extId;
                log.Method__c = 'Upsert';
                log.Integration_Name__c = type.toLowercase().contains('customer') ? 'CTR ComX Callout Register Customer' : 'CTR ComX Callout Register Supplier';
                log.Log_Type__c = 'Error';
                log.Message_Type__c = 'Fail';
                log.Request_Body__c = JSON.serialize(wrapperListRequest).abbreviate(131000);
                log.Response_Body__c = JSON.serialize(restResponse).abbreviate(131000);
                log.Error_Message__c = 'ComX - '+httperr;
                log.OwnerId = UserInfo.getUserId();
                applogList.add(log);
            }
        }
        catch (Exception e) {
            System.debug('Error From: CTRCalloutComXCtrl.callRESTApiCreate line ' + e.getLineNumber() + ' || Message: ' + e.getMessage());
            
            Application_Log__c log = new Application_Log__c();
            log.External_ID__c = 'ComX-'+extId;
            log.Method__c = 'Upsert';
            log.Integration_Name__c = type.toLowercase().contains('customer') ? 'CTR ComX Callout Register Customer' : 'CTR ComX Callout Register Supplier';
            log.Message_Type__c = 'Fail';
            log.Log_Type__c = 'Error';
            log.Request_Body__c = JSON.serialize(wrapperListRequest).abbreviate(131000);
            log.Response_Body__c = '';
            log.Error_Message__c = 'Error From: CTRCalloutComXCtrl.callRESTApiCreate line ' + e.getLineNumber() + ' || Message: ' + e.getMessage();
            log.OwnerId = UserInfo.getUserId();
            applogList.add(log);
        }
        if(applogList.size() > 0){
            upsert applogList External_ID__c;
        }
    }
    
    //After Insert
    public static void organizeData(String mRequestItem /*Map<Id,CTRRequestFormItem__c> mRequestItemNewMap*/) {
        // public static void organizeData(String typeStr , String mRequestItem /*Map<Id,CTRRequestFormItem__c> mRequestItemNewMap*/) {
        // public static void organizeData(Map<Id,CTRRequestFormItem__c>  mRequestItemOldMap, Map<Id,CTRRequestFormItem__c> mRequestItemNewMap) {
        System.debug('--organizeData--');
        
        try{
            
            /*String mRequestItem ='a3c1m000000MAAlAAO';
            System.debug(mRequestItemNewMap);
            Set<Id> requestItemId = new Set<Id>();
            List<CTRRequestFormItem__c> lRequestItemfromMap = new List<CTRRequestFormItem__c>();
            for (CTRRequestFormItem__c mItem : mRequestItemNewMap.values()) 
            {   
                if( ( mItem.RecordTypeName__c.contains('CustomerInitial') || mItem.RecordTypeName__c.contains('CustomerExtend') || mItem.RecordTypeName__c.contains('SupplierInitial') || mItem.RecordTypeName__c.contains('SupplierExtend') )
                && mItem.Approval_TRCRSubmitDate__c != null
                && mItem.ApproveDueDiligenceBy__r.Name != null
                && mItem.Customer__r.SFCode__c != null
                && mItem.SalesOrganization__c != null
                && mItem.CTRRequestFormHeader__r.CompanyNameLocal__c != null
                && mItem.CTRRequestFormHeader__r.CompanyNameENF__c != null
                && mItem.CTRRequestFormHeader__r.Country__r.Description__c != null
                && mItem.CTRRequestFormHeader__r.DistrictLocalText__c != null
                && mItem.CTRRequestFormHeader__r.PostalCodeLocalText__c != null
                && mItem.CTRRequestFormHeader__r.StreetLocal__c != null
                && mItem.CTRRequestFormHeader__r.HousenoLocal__c != null
                && mItem.CTRRequestFormHeader__r.Country__r.Code__c != null
                && mItem.CTRRequestFormHeader__r.Phone__c != null
                && mItem.CTRRequestFormHeader__r.TaxCode1__c != null
                && mItem.CTRRequestFormHeader__r.AccountGroup__c != null
                && mItem.Approval_TraderSubmitDate__c != null
                && mItem.CreatedBy.Name != null
                )
                {
                    requestItemId.add(mItem.Id);
                    lRequestItemfromMap.add(mItem);
                }
                
            }
            System.debug(requestItemId);
            System.debug(lRequestItemfromMap);*/
            
            List<CTRRequestFormItem__c> lRequestItemfromMap =[SELECT RecordTypeId,RecordTypeName__c,Id, Approval_TRCRSubmitDate__c,ApproveDueDiligenceBy__r.Name, Customer__r.SFCode__c,SalesOrganization__c ,
                                                       CTRRequestFormHeader__r.CompanyNameLocal__c,CTRRequestFormHeader__r.CompanyNameENF__c, CTRRequestFormHeader__r.Country__r.Description__c, 
                                                       CTRRequestFormHeader__r.DistrictLocalText__c,CTRRequestFormHeader__r.PostalCodeLocalText__c, CTRRequestFormHeader__r.StreetLocal__c,
                                                       CTRRequestFormHeader__r.HousenoLocal__c,CTRRequestFormHeader__r.Country__r.Code__c,CTRRequestFormHeader__r.Phone__c,CTRRequestFormHeader__r.TaxCode1__c,
                                                       CTRRequestFormHeader__r.AccountGroup__c, Approval_TraderSubmitDate__c,CreatedBy.Name
                                                       FROM CTRRequestFormItem__c 
                                                       WHERE Id = :mRequestItem];
            
            
            List<CustomerWrapper> cusWrapperList = new List<CustomerWrapper>(); // Initialize the list
            List<VendorWrapper> venWrapperList = new List<VendorWrapper>(); // Initialize the list

            Integer startIndex = 0;
            Integer mcdNamePerCreateLength = 12;
            Integer updateCreateByLength = 14;
            
            if(lRequestItemfromMap.size() > 0) //if(lRequestItem.size() > 0)
            {
                
                // String recordtypeId = lRequestItem[0].RecordTypeId;
                // RecordType rtList = [SELECT Id,DeveloperName FROM RecordType WHERE SobjectType='CTRRequestFormItem__c' AND Id = :recordtypeId];
                
                // Map<Id,String> mRecordtype =  new Map<Id,String>();
                // for (RecordType rt : rtList) 
                // {
                //     mRecordtype.put(rt.Id,rt.Name);
                // }
                if(lRequestItemfromMap[0].SalesOrganization__c.contains('1100') || lRequestItemfromMap[0].SalesOrganization__c.contains('1300') || lRequestItemfromMap[0].SalesOrganization__c.contains('1400') || lRequestItemfromMap[0].SalesOrganization__c.contains('1700'))
                {
                    if(lRequestItemfromMap[0].RecordTypeName__c.contains('CustomerInitial') || lRequestItemfromMap[0].RecordTypeName__c.contains('CustomerExtend'))
                    {
                        System.debug(lRequestItemfromMap[0].Approval_TRCRSubmitDate__c);
                        System.debug(lRequestItemfromMap[0].Approval_TraderSubmitDate__c);
                        String Approval_TRCRSubmitDate = String.valueOf(lRequestItemfromMap[0].Approval_TRCRSubmitDate__c).replace('-', '/');
                        String Approval_TraderSubmitDate = String.valueOf(lRequestItemfromMap[0].Approval_TraderSubmitDate__c).replace('-', '/');
                        System.debug(Approval_TRCRSubmitDate);
                        System.debug(Approval_TraderSubmitDate);
    
                        CustomerWrapper wrapper  = new CustomerWrapper();
                        wrapper.Cust = new Cust(); // Initialize
                        wrapper.CustDetail = new CustDetail(); // Initialize
                        
                        wrapper.Cust.MCT_CUST_NUM = lRequestItemfromMap[0].Id != null ? 'CPAI-'+lRequestItemfromMap[0].Id : ''; //DummyCode Generate by system
                        wrapper.Cust.MCT_STATUS = 'ACTIVE'; //Status
                        wrapper.Cust.MCT_CREATE_TYPE = 'CPAI'; //CREATED BY 
                        wrapper.Cust.MCT_CREATED_DATE = lRequestItemfromMap[0].Approval_TRCRSubmitDate__c != null ?  String.valueOf(Approval_TRCRSubmitDate) : '' ;
                        // wrapper.Cust.MCT_CUST_NUM = lRequestItemfromMap[0].Customer__r.SFCode__c != null ? 'CPAI-'+lRequestItemfromMap[0].Customer__r.SFCode__c : '';
                        wrapper.Cust.MCT_UPDATED_DATE = lRequestItemfromMap[0].Approval_TRCRSubmitDate__c != null ? String.valueOf(Approval_TRCRSubmitDate) : ''  ;
                        
                        if (lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name.length() > updateCreateByLength) 
                        {
                            wrapper.Cust.MCT_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).substring(0, updateCreateByLength))+'_SFCTR' : '' ; 
                        }else
                        {
                            wrapper.Cust.MCT_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? (lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name)+'_SFCTR': '' ; 
                        }
                        
                        if (lRequestItemfromMap[0].CreatedBy.Name.length() > updateCreateByLength) 
                        {
                            wrapper.Cust.MCT_CREATED_BY = lRequestItemfromMap[0].CreatedBy.Name != null ? ((lRequestItemfromMap[0].CreatedBy.Name).substring(0, updateCreateByLength))+'_SFCTR' : '' ; 
                        }else
                        {
                            wrapper.Cust.MCT_CREATED_BY = lRequestItemfromMap[0].CreatedBy.Name != null ? (lRequestItemfromMap[0].CreatedBy.Name)+'_SFCTR' : '' ; 
                        }
                        // wrapper.Cust.MCT_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).abbreviate(updateCreateByLength))+'_SFCTR': '' ; 
                        // wrapper.Cust.MCT_CREATED_BY = lRequestItemfromMap[0].CreatedBy.Name != null ? ((lRequestItemfromMap[0].CreatedBy.Name).abbreviate(updateCreateByLength))+'_SFCTR' : '' ; 
                        
                        wrapper.CustDetail.MCD_FK_CUS = lRequestItemfromMap[0].Id != null ? 'CPAI-'+lRequestItemfromMap[0].Id : ''; //DummyCode Generate by system
                        wrapper.CustDetail.MCD_FK_COMPANY = lRequestItemfromMap[0].SalesOrganization__c != null ? lRequestItemfromMap[0].SalesOrganization__c : ''; 
                        wrapper.CustDetail.MCD_NATION = 'I' ; 
                        wrapper.CustDetail.MCD_NAME_1 = lRequestItemfromMap[0].CTRRequestFormHeader__r.CompanyNameLocal__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.CompanyNameLocal__c : '' ;
                        wrapper.CustDetail.MCD_NAME_2 = lRequestItemfromMap[0].CTRRequestFormHeader__r.CompanyNameENF__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.CompanyNameENF__c : '';
                        wrapper.CustDetail.MCD_CITY = lRequestItemfromMap[0].CTRRequestFormHeader__r.Country__r.Description__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.Country__r.Description__c : '';
                        wrapper.CustDetail.MCD_DISTRICT = lRequestItemfromMap[0].CTRRequestFormHeader__r.DistrictLocalText__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.DistrictLocalText__c : '';
                        wrapper.CustDetail.MCD_CITY_POS_CODE = lRequestItemfromMap[0].CTRRequestFormHeader__r.PostalCodeLocalText__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.PostalCodeLocalText__c : '';
                        wrapper.CustDetail.MCD_STREET = lRequestItemfromMap[0].CTRRequestFormHeader__r.StreetLocal__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.StreetLocal__c : '';
                        wrapper.CustDetail.MCD_HOUSE_NUM = lRequestItemfromMap[0].CTRRequestFormHeader__r.HousenoLocal__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.HousenoLocal__c : '';
                        wrapper.CustDetail.MCD_COUNT_KEY1 = lRequestItemfromMap[0].CTRRequestFormHeader__r.Country__r.Code__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.Country__r.Code__c : '';
                        wrapper.CustDetail.MCD_PHONE_NO_DIALLING = lRequestItemfromMap[0].CTRRequestFormHeader__r.Phone__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.Phone__c : '';
                        wrapper.CustDetail.MCD_TAX_NUMBER_1 = lRequestItemfromMap[0].CTRRequestFormHeader__r.TaxCode1__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.TaxCode1__c : '';
                        wrapper.CustDetail.MCD_KTOKD = lRequestItemfromMap[0].CTRRequestFormHeader__r.AccountGroup__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.AccountGroup__c : '';
                        wrapper.CustDetail.MCD_STATUS = 'ACTIVE' ;
                        wrapper.CustDetail.MCD_CREATED_DATE = lRequestItemfromMap[0].Approval_TraderSubmitDate__c != null ? String.valueOf(Approval_TraderSubmitDate) : '';

                        if (lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name.length() > updateCreateByLength) 
                        {
                            wrapper.CustDetail.MCD_NAME_PER_CREAT = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).substring(0, mcdNamePerCreateLength))  : '';
                            wrapper.CustDetail.MCD_CREATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).substring(0, updateCreateByLength))+'_SFCTR' : '';
                            wrapper.CustDetail.MCD_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).substring(0, updateCreateByLength))+'_SFCTR'  : '';

                        }else
                        {
                            wrapper.CustDetail.MCD_NAME_PER_CREAT = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name : '';
                            wrapper.CustDetail.MCD_CREATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name+'_SFCTR' : '';
                            wrapper.CustDetail.MCD_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name+'_SFCTR' : '';

                        }
                        
                        // wrapper.CustDetail.MCD_NAME_PER_CREAT = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? (lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).abbreviate(mcdNamePerCreateLength) : '';
                        // wrapper.CustDetail.MCD_CREATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).abbreviate(updateCreateByLength))+'_SFCTR' : '';
                        // wrapper.CustDetail.MCD_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).abbreviate(updateCreateByLength))+'_SFCTR' : '';
                        wrapper.CustDetail.MCD_UPDATED_DATE = lRequestItemfromMap[0].Approval_TraderSubmitDate__c != null ? String.valueOf(Approval_TraderSubmitDate) : '';
                        cusWrapperList.add(wrapper);
                    }
                    else if(lRequestItemfromMap[0].RecordTypeName__c.contains('SupplierInitial') || lRequestItemfromMap[0].RecordTypeName__c.contains('SupplierExtend'))
                    {   
                        System.debug(lRequestItemfromMap[0].Approval_TraderSubmitDate__c); //SF >> 2023-12-27 12:36:26
                        String Approval_TRCRSubmitDate = String.valueOf(lRequestItemfromMap[0].Approval_TraderSubmitDate__c).replace('-', '/');
                        System.debug(Approval_TRCRSubmitDate);
    
                        VendorWrapper wrapper  = new VendorWrapper();
                        wrapper.vendor = new Vendor(); // Initialize the vendor object
                        wrapper.vendorData = new VendorData(); // Initialize the vendor object
                        
                        wrapper.vendor.vnD_ACC_NUM_VENDOR = lRequestItemfromMap[0].Id != null ? 'VND-'+lRequestItemfromMap[0].Id : ''; //DummyCode Generate by system
                        wrapper.vendor.vnD_NAME1 = lRequestItemfromMap[0].CTRRequestFormHeader__r.CompanyNameLocal__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.CompanyNameLocal__c : ''; 
                        wrapper.vendor.vnD_NAME2 = lRequestItemfromMap[0].CTRRequestFormHeader__r.CompanyNameENF__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.CompanyNameENF__c : ''; //CREATED BY 
                        wrapper.vendor.vnD_CITY = lRequestItemfromMap[0].CTRRequestFormHeader__r.Country__r.Description__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.Country__r.Description__c : '';
                        wrapper.vendor.vnD_DISTRICT = lRequestItemfromMap[0].CTRRequestFormHeader__r.DistrictLocalText__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.DistrictLocalText__c : '';
                        wrapper.vendor.vnD_POSTAL_CODE = lRequestItemfromMap[0].CTRRequestFormHeader__r.PostalCodeLocalText__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.PostalCodeLocalText__c : ''; 
                        wrapper.vendor.vnD_HOUSE_NUM_STREET = lRequestItemfromMap[0].CTRRequestFormHeader__r.HousenoLocal__c != null ? lRequestItemfromMap[0].CTRRequestFormHeader__r.HousenoLocal__c : ''; 
                        
                        wrapper.vendor.vnD_STATUS = 'ACTIVE'; //DummyCode Generate by system
                        wrapper.vendor.vnD_CREATED_DATE = lRequestItemfromMap[0].Approval_TraderSubmitDate__c != null ? String.valueOf(Approval_TRCRSubmitDate) : ''; 
                        // wrapper.vendor.vnD_CREATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).abbreviate(updateCreateByLength))+'_SFCTR' : ''; 
                        wrapper.vendor.vnD_UPDATED_DATE = lRequestItemfromMap[0].Approval_TraderSubmitDate__c != null ? String.valueOf(Approval_TRCRSubmitDate) : '';
                        // wrapper.vendor.vnD_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).abbreviate(updateCreateByLength))+'_SFCTR' : '';
                        wrapper.vendor.vnD_CREATE_TYPE = 'VND';
                        
                        wrapper.vendorData.mvD_FK_COMPANY = lRequestItemfromMap[0].SalesOrganization__c != null ? lRequestItemfromMap[0].SalesOrganization__c : '';
                        wrapper.vendorData.mvD_FK_VENDOR = lRequestItemfromMap[0].Id != null ? 'VND-'+lRequestItemfromMap[0].Id : '';
                        wrapper.vendorData.mvD_STATUS = 'ACTIVE' ;
                        wrapper.vendorData.mvD_CREATED_DATE = lRequestItemfromMap[0].Approval_TraderSubmitDate__c != null ? String.valueOf(Approval_TRCRSubmitDate) : '';
                        // wrapper.vendorData.mvD_CREATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).abbreviate(updateCreateByLength))+'_SFCTR' : '';
                        wrapper.vendorData.mvD_UPDATED_DATE = lRequestItemfromMap[0].Approval_TraderSubmitDate__c != null ? String.valueOf(Approval_TRCRSubmitDate) : '';
                        // wrapper.vendorData.mvD_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).abbreviate(updateCreateByLength))+'_SFCTR' : '';
                        
                        
                        if (lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name.length() > updateCreateByLength) 
                        {
                            wrapper.vendor.vnD_CREATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).substring(0, updateCreateByLength))  : '';
                            wrapper.vendor.vnD_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).substring(0, updateCreateByLength))+'_SFCTR' : '';
                            wrapper.vendorData.mvD_CREATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).substring(0, updateCreateByLength))+'_SFCTR'  : '';
                            wrapper.vendorData.mvD_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? ((lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name).substring(0, updateCreateByLength))+'_SFCTR'  : '';

                        }else
                        {
                            wrapper.vendor.vnD_CREATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name : '';
                            wrapper.vendor.vnD_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name : '';
                            wrapper.vendorData.mvD_CREATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name : '';
                            wrapper.vendorData.mvD_UPDATED_BY = lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name != null ? lRequestItemfromMap[0].ApproveDueDiligenceBy__r.Name : '';

                        }
                        
                        venWrapperList.add(wrapper);
                    }
                    else
                    {
                        System.debug('Recordtype is not contain Customer or Supplier');
                    }
                }
                else
                {
                    System.debug('Sale Organixzation is unexpected');
                }
            }
            else{
                System.debug('No data to map to ComX');
            }
            
            if(cusWrapperList.size() > 0)
            {
                // Serialize the wrapperList into JSON format
                String jsonString = JSON.serialize(cusWrapperList);
                List<Object> jsonStringDE = (List<Object>)JSON.deserializeUntyped(jsonString);
                
                // Output the JSON string
                System.debug(JSON.serialize(jsonStringDE[0]));
                callRestApiCreate('Customer',JSON.serialize(jsonStringDE[0]),lRequestItemfromMap[0].Id);
            }
            else if(venWrapperList.size() > 0)
            {
                // Serialize the wrapperList into JSON format
                String jsonString = JSON.serialize(venWrapperList);
                List<Object> jsonStringDE = (List<Object>)JSON.deserializeUntyped(jsonString);
                
                // Output the JSON string
                System.debug(JSON.serialize(jsonStringDE[0]));
                callRestApiCreate('Vendor',JSON.serialize(jsonStringDE[0]),lRequestItemfromMap[0].Id);
            }
            else{
                System.debug('No data to send to ComX');
            }
            
        }
        catch(exception e)
        {
            System.debug('Error from CTRCalloutComXCtrl.organizeData Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }
    
}

//Execute Anonymous
// CTRCalloutComXCtrl ctrInstance = new CTRCalloutComXCtrl();
// // ctrInstance.getCTRUpdateMaster();
// // ctrInstance.getAccount();
// // ctrInstance.createDummyRecord();
// // ctrInstance.callSoapApi('0000001712','CPAI912345','r2','VENDOR');
// // ctrInstance.callSoapApi('0000000678','CPAI912345','THE AROMATICS (THAILAND) PUBLIC COMPANY LIMITED','VENDOR');
// CTRCalloutComXCtrl.callSoapApi('0000000678','CPAI912345','THE AROMATICS (THAILAND) PUBLIC COMPANY LIMITED','VENDOR');

// //ComX Create
// //supplier
// CTRCalloutComXCtrl.organizeData('a3c1m000000M5VCAA0');
// //customer
// CTRCalloutComXCtrl.organizeData('a3c1m000000MAAlAAO');