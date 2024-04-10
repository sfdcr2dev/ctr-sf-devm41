public without sharing  class CTRBlockSupplierBatch implements Database.Batchable<sObject>, Database.stateful, Database.AllowsCallouts {

    private String query;
    private CTRIntegraionList__mdt mIntegration;
    private C360Integration__c mSetting;

    public Database.QueryLocator start(Database.BatchableContext bc) {

        List<CTRIntegraionList__mdt> mIntegrationList = [SELECT Id,MasterLabel, DeveloperName, Endpoint__c, Token__c, Path__c FROM CTRIntegraionList__mdt WHERE DeveloperName = 'CTRSupplier' LIMIT 1];
        if(mIntegrationList.size() > 0) {
            this.mIntegration = mIntegrationList[0];
        }

        this.mSetting = C360Integration__c.getInstance();

        this.query = 'SELECT Account__r.SupplierNumber__c,PurchasingOrg__c,Account__c,PurchasingDocDate__c FROM CTRPurchasingView__c WHERE PurchasingOrg__c != null AND Account__c != null AND PurchasingOrg__c IN (\'H100\',\'A000\')  AND PurchasingDocDate__c != null LIMIT 1';
        return Database.getQueryLocator(this.query);
    }

    public void execute(Database.BatchableContext bc, List<CTRPurchasingView__c> scope) {
        System.debug('Execute batch SendUpdateBlockCustomer size = '+scope.size());

        List<Map<String, String>> mSendDataList = new List<Map<String, String>>();
        Map<String, Object> mDataToSendMap = new Map<String, Object>();
        List<Application_Log__c> insertApplogList = new List<Application_Log__c>();
        if(this.mIntegration != null) 
        {
            for (CTRPurchasingView__c mPurchasing : scope) 
            {
                Map<String, String> mDataMap = new Map<String, String>();
    
                if(String.isNotBlank(this.mSetting.iRPA_Supplier_Endpoint__c) && String.isNotBlank(this.mSetting.iRPA_API_Key_Header__c) && String.isNotBlank(this.mSetting.iRPA_API_Key__c) && String.isNotBlank(this.mSetting.HerokuIntegrationDomain__c)) 
                {
                    String mBody = CTRBlockSupplierRequestFormItemModelData.SetupJsonForBlockDataModelSupplier(mPurchasing);
                    if(String.isNotBlank(mBody))
                    {
                        mDataMap.put('mBody',mBody);
                        mDataMap.put('mEndPoint',this.mSetting.HerokuIntegrationDomain__c+this.mIntegration.Path__c);
                        mDataMap.put('mGatewayId',Uuid.randomUUID());
                        mDataMap.put('mToken', this.mIntegration.Token__c);
                        mDataMap.put('mPurchasingId', mPurchasing.Id);
                    }
                }
                if(mDataMap.size()>0) 
                {
                    mSendDataList.add(mDataMap);
                    mDataToSendMap.put(mPurchasing.Id, mDataMap);
                }
                mPurchasing.BlockStatus__c = 'TRUE'; // update block
            }
        }

        if(mDataToSendMap.size()>0) 
        {
            System.debug('List to call out '+mDataToSendMap.size());
            for( Map<String, String> mDataToSend : mSendDataList) 
            {
                sendBlockCustomer(mDataToSend.get('mBody'), mDataToSend.get('mToken'), mDataToSend.get('mEndPoint'),mDataToSend.get('mPurchasingId'), mDataToSend.get('mGatewayId'));
            }
        }

        if(scope.size() > 0)
        {
            System.debug('::::::::: Finish SendUpdateBlockSupplier :::::::::');
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
    }
}