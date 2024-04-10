public without sharing class CTRBlockCustomerBatch implements Database.Batchable<sObject>, Database.stateful, Database.AllowsCallouts {

    private String query;
    private CTRIntegraionList__mdt mIntegration;
    private C360Integration__c mSetting;

    public Database.QueryLocator start(Database.BatchableContext bc) {

        List<CTRIntegraionList__mdt> mIntegrationList = [SELECT Id,MasterLabel, DeveloperName, Endpoint__c, Token__c, Path__c FROM CTRIntegraionList__mdt WHERE DeveloperName = 'CTRCustomer' LIMIT 1];
        if(mIntegrationList.size() > 0) {
            this.mIntegration = mIntegrationList[0];
        }

        this.mSetting = C360Integration__c.getInstance();

        this.query = 'SELECT Id, Name, BillingDate__c, PODate__c, AccountNumber__c,AccountNumber__r.AccountNumber__c, CompanyNumber__c, SalesOrganization__c,DistributionChannel__c, Division__c, BlockStatus__c, CreditControlArea__c FROM C360_SalesArea__c WHERE ((BillingDate__c < LAST_N_YEARS:2 AND BillingDate__c < LAST_N_DAYS:90) OR (PODate__c < LAST_N_YEARS:2 AND PODate__c < LAST_N_DAYS:90)) AND SalesOrganization__c IN (\'2000\',\'9100\') AND AccountNumber__c != null AND CreditControlArea__c != null LIMIT 1';
        return Database.getQueryLocator(this.query);
    }

    public void execute(Database.BatchableContext bc, List<C360_SalesArea__c> scope) {
        System.debug('Execute batch SendUpdateBlockCustomer size = '+scope.size());

        List<Map<String, String>> mSendDataList = new List<Map<String, String>>();
        Map<String, Object> mDataToSendMap = new Map<String, Object>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        if(this.mIntegration != null) 
        {
            for (C360_SalesArea__c mSalesArea : scope) 
            {
                Map<String, String> mDataMap = new Map<String, String>();
    
                if(String.isNotBlank(this.mSetting.iRPA_Customer_Endpoint__c) && String.isNotBlank(this.mSetting.iRPA_API_Key_Header__c) && String.isNotBlank(this.mSetting.iRPA_API_Key__c) && String.isNotBlank(this.mSetting.HerokuIntegrationDomain__c)) 
                {
                    String mBody = CTRBlockRequestFormItemModelData.SetupJsonForBlockDataModelV1(mSalesArea);
                    if(String.isNotBlank(mBody))
                    {
                        mDataMap.put('mBody',mBody);
                        mDataMap.put('mEndPoint',this.mSetting.HerokuIntegrationDomain__c+this.mIntegration.Path__c);
                        mDataMap.put('mGatewayId',Uuid.randomUUID());
                        mDataMap.put('mToken', this.mIntegration.Token__c);
                        mDataMap.put('mSalesAreaId', mSalesArea.Id);
                    }
                }
                if(mDataMap.size()>0) 
                {
                    mSendDataList.add(mDataMap);
                    mDataToSendMap.put(mSalesArea.Id, mDataMap);
                }
                mSalesArea.BlockStatus__c = 'T1'; // update block
            }
        }

        if(mDataToSendMap.size()>0) 
        {
            System.debug('List to call out '+mDataToSendMap.size());
            for( Map<String, String> mDataToSend : mSendDataList) 
            {
                sendBlockCustomer(mDataToSend.get('mBody'), mDataToSend.get('mToken'), mDataToSend.get('mEndPoint'),mDataToSend.get('mSalesAreaId'), mDataToSend.get('mGatewayId'));
            }
        }

        if(scope.size() > 0)
        {
            System.debug('::::::::: Finish SendUpdateBlockCustomer :::::::::');
            Database.SaveResult[] logUpsertResult = Database.update(scope);
            for (Database.SaveResult logUpsert : logUpsertResult) {
                List<Database.Error> errors = logUpsert.getErrors();
                for(Database.Error theError:Errors) {
                    System.debug(theError);
                }
            } 
        }
    }
    
    public void finish(Database.BatchableContext BC){}

    private static void sendBlockCustomer(String mJson, String mToken, String mEndPoint, Id mRecordId, String mGatewayId)
    {
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();


        System.debug('Send Block Customer '+mEndPoint+':'+mRecordId);
        System.debug('Send Block Customer-Body '+mJson);
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');  
        request.setHeader('Content-Type', 'application/json');
        request.setBody(mJson);
        request.setEndpoint(mEndPoint);
        request.setHeader('Authorization', 'Bearer ' + mToken);
            
        // Make the HTTP request
        Http http = new Http();
        HttpResponse response = http.send(request);

        // Parse and handle the response
        if(mRecordId!= null)
        {
            System.debug(response.getStatusCode());
            String sObjName = mRecordId.getSObjectType().getDescribe().getName();
            if (response.getStatusCode() == 200) 
            {
                System.debug('mRecordId:'+mRecordId);
                // Successful response
                System.debug('Success Response3: ' + response.getBody());
            }
            else
            {
                System.debug('HTTP no update error: ' + response.getStatusCode() + ' ' + response.getBody());
            }
        }
        else
        {
            if (response.getStatusCode() == 200) 
            {
                System.debug('Success Response no update: ' + response.getBody());
            }
            else
            {
                System.debug('HTTP no update error: ' + response.getStatusCode() + ' ' + response.getBody());
            }
        }

        // if(insertApplogList.size() > 0){
        //     insert insertApplogList;
        // }
    }
}

// Date startDate = Date.newInstance(2022, 1, 25);
// Date calculatedDate = startDate.addYears(2).addDays(90);

// System.debug(calculatedDate); // This will output the calculated date

// //

// Date earliestDate = Date.today().addDays(-7);
// Date latestDate = Date.today();

// Integer daysBetween = earliestDate.daysBetween(latestDate);
// Integer monthsBetween = earliestDate.monthsBetween(latestDate);
// System.debug(daysBetween); 
// System.debug(monthsBetween); 

// //

// SELECT Id, Name, BillingDate__c, PODate__c
//                                         FROM C360_SalesArea__c
//                                         WHERE (BillingDate__c < LAST_N_YEARS:2 AND BillingDate__c < LAST_N_DAYS:90)
//                                         OR (PODate__c < LAST_N_YEARS:2 AND PODate__c < LAST_N_DAYS:90)

// //
// Date startDate = ['select Id,Name, Account__c, Account__r.Name, Account__r.AccountNumber__c ,Account__r.SupplierNumber__c,BlockStatus__c, Incoterms__c, Incoterms2__c, Currency__c, TermofPayment__c, Account__r.SalesOrganization__c, PurchasingOrg__c, PurchasingDocDate__c from CTRPurchasingView__c WHERE (PurchasingDocDate__c < LAST_N_YEARS:1 AND PurchasingDocDate__c < LAST_N_DAYS:90) limit 10'];
// System.debug('LAST_N_YEARS:2'+ BillingDate__c < LAST_N_YEARS:2); // This will output the calculated date
// //
// Date twoYearsAgo = Date.today().addYears(-2).addDays(-90);
// System.debug('Two years ago: ' + twoYears90DayAgo);

// //Run Batch
// CTRBlockCustomerBatch batch = new CTRBlockCustomerBatch();
// Database.executeBatch(batch);