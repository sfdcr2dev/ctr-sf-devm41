public with sharing class CTRRequestItemIntegrationBatchController implements Database.Batchable<sObject>, Database.AllowsCallouts
{
    public static final Id mRecordTypeEditCustomer = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerEditInfo').getRecordTypeId();
    public static final Id mRecordTypeEditSupplier = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('SupplierEditInfo').getRecordTypeId();
    public Database.QueryLocator start(Database.BatchableContext BC) 
    {
        Date mToday = System.today();
        
        List<String> mRequestItemFields = new List<String>(CTRRequestFormItem__c.SObjectType.getDescribe().fields.getMap().keySet());
        String query =  ' SELECT ' + String.join(mRequestItemFields, ',');
        query += ' ,CTRRequestFormHeader__r.Country__r.Code__c';
        query += ' ,Customer__r.AccountNumber__c, RecordType.Name';
        query += ' ,Customer__r.SupplierNumber__c';
        query += ' ,Partner__r.SupplierNumber__c, Partner__r.AccountNumber__c';
        query += ' ,Owner.ProfileId, Owner.Profile.Name, Owner.Email, Owner.Name';
        query += ' ,RecordType.DeveloperName ,TermofPayment__r.Code__c';
        query += ' ,CustomerType__r.Code__c ,CustomerGroup__r.Code__c';
        query += ' ,Industry__r.Code__c ,SubIndustry__r.Code__c';
        query += ' ,Application__r.Code__c ,InterGroup__r.Code__c';
        query += ' FROM CTRRequestFormItem__c';
        query += ' WHERE EffectiveDate__c != null AND EffectiveDate = :mToday AND Status__c = \'Approved\'' ;
        query += ' AND ((RecordTypeId = :mRecordTypeEditCustomer AND Customer__r.AccountNumber__c ! = null) OR (RecordTypeId =:mRecordTypeEditSupplier AND Customer__r.SupplierNumber__c != null))';
        query += ' AND SAPNumber__c = null AND EffectiveType__c = \'Schedule\' AND CTRRequestFormHeader__c != null';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> sObj) 
    {
        //Batch size 1 to callout
        C360Integration__c mSetting = C360Integration__c.getInstance();
        List<CTRRequestFormItem__c> mItemList = (List<CTRRequestFormItem__c>)sObj;
        Set<Id> mItemSetId = new Set<Id>();
        Set<Id> mHeaderSetId = new Set<Id>();
        for(CTRRequestFormItem__c mItem: mItemList)
        {
            if(mItem.CTRRequestFormHeader__c != null)
            {
                mHeaderSetId.add(mItem.CTRRequestFormHeader__c);
            }
        }
        if(mHeaderSetId.size()>0)
        {
            List<String> mRequestHeaderFields = new List<String>(CTRRequestFormHeader__c.SObjectType.getDescribe().fields.getMap().keySet());            
                String soqlHeader = ''
                    + ' SELECT ' + String.join(mRequestHeaderFields, ',')
                    + ' ,Country__r.Code__c'
                    + ' ,TradingPartner__r.Code__c'
                    + ' ,CityStateLocal__r.Description__c'
                    + ' ,Customer__r.AccountNumber__c'
                    + ' ,Customer__r.SupplierNumber__c'
                    + ' ,RecordType.DeveloperName'
                    + ' FROM CTRRequestFormHeader__c'
                    + ' WHERE ID IN :mSetId';
                List<CTRRequestFormHeader__c> mHeaderList = Database.query(soqlHeader);
                String mIntegrationName = '';
                String mPath = mSetting.HerokuIntegrationDomain__c;
                String mEndPoint = '';
                String jsonInput = '';
                String mToken = '';
            if(mHeaderList.size()>0)
            {
                CTRIntegraionList__mdt mIntegrationInitialCustomer = CTRIntegraionList__mdt.getInstance('CTRCustomer');
                CTRIntegraionList__mdt mIntegrationInintialSupplier = CTRIntegraionList__mdt.getInstance('CTRSupplier');
                CTRRequestFormItem__c mRequestItem = mItemList[0];
                CTRRequestFormHeader__c mRequestHeader =mHeaderList[0];
                String mGatewayId = (mRequestItem.GatewayId__c != null)?mRequestItem.GatewayId__c: Uuid.randomUUID();
                List<CTRIntegrationMapping__mdt> mAllMappingList = [SELECT Id, BusinessUnit__c, IntegrationType__c, JsonMapping__c, RecordType__c, ViewName__c, SupportIntegrationType__c FROM CTRIntegrationMapping__mdt];

                if(mRequestItem.RecordType.DeveloperName.contains('Customer') && mIntegrationInitialCustomer != null)
                {
                    if(mRequestItem.Customer__r.AccountNumber__c != null)
                    {
                        mToken = mIntegrationInitialCustomer.Token__c;
                        mIntegrationName= 'Edit Customer General+Sales View';
                        CTRRequestItemIntegrationEditController.mapLv1 mEditData = new CTRRequestItemIntegrationEditController.mapLv1();
                        mEditData = CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModel(mAllMappingList, mRequestHeader,mRequestItem, 'Customer', mRequestItem.BusinessUnit__c, mGatewayId);
                        mPath = mIntegrationInitialCustomer.Path__c;
                        if(mPath != null)
                        {
                            mEndPoint += mPath;
                        }
                        jsonInput = JSON.serialize(mEditData);
                    }
                }
                else if(mRequestItem.RecordType.DeveloperName.contains('Supplier') && mIntegrationInintialSupplier != null)
                {
                    if(mRequestItem.Customer__r.SupplierNumber__c != null)
                    {
                        mToken = mIntegrationInintialSupplier.Token__c;
                        mIntegrationName= 'Edit Supplier General+Purchasing View';
                        CTRRequestItemIntegrationEditController.mapLv1 mEditData = new CTRRequestItemIntegrationEditController.mapLv1();
                        mEditData = CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModel(mAllMappingList,mRequestHeader,mRequestItem, 'Supplier', mRequestItem.BusinessUnit__c, mGatewayId);
                        mPath = mIntegrationInintialSupplier.Path__c;
                        System.debug('Endpoint:'+mEndPoint);
                        if(mPath != null)
                            {
                                mEndPoint += mPath;
                            }
                        jsonInput = JSON.serialize(mEditData);
                        //mGatewayId = mEditData.input.input.get('GatewayId');
                    }
                }
                if(String.isNotBlank(jsonInput) && String.isNotBlank(mEndpoint)&& String.isNotBlank(mPath))
                {
                    HttpRequest request = new HttpRequest();
                    request.setMethod('POST');  
                    request.setHeader('Content-Type', 'application/json');
                    request.setBody(jsonInput);
                    request.setHeader('Authorization', 'Bearer ' + mToken);
                    request.setEndpoint(mEndPoint);

                    Http http = new Http();
                    HttpResponse response = http.send(request);

                    // Parse and handle the response
                    if (response.getStatusCode() == 200) 
                    {
                        CTRRequestFormItem__c mRequestItemUpdate = new CTRRequestFormItem__c(Id = mRequestItem.Id);
                        mRequestItemUpdate.IntegrationStatus__c = 'In Progress';

                        // Successful response
                        String SAPStatus = mRequestItem.SAPStatus__c;

                        if (mIntegrationName == 'Edit Supplier General+Purchasing View' ||
                            mIntegrationName == 'Edit Customer General+Purchasing View')
                        {
                            SAPStatus = 'Send Sales/Purchasing View To SAP';
                        }
                        

                        System.debug('Success Response: ' + response.getBody());                        
                        mRequestItemUpdate.SAPStatus__c = SAPStatus;
                        mRequestItemUpdate.GatewayId__c = mGatewayId;
                        //mRequestItemUpdate.SAPSubmitTime__c = DateTime.Now();
                        mRequestItemUpdate.LatestIntegrationName__c = mIntegrationName;
                        
                        update mRequestItemUpdate;
                        System.debug('SAPStatus : ' + SAPStatus);
                        System.debug('mGatewayId : ' + mGatewayId);
                        System.debug('mIntegrationName : ' + mIntegrationName);
    
                    } 
                    else 
                    {
                        // Error handling
                        String SAPStatus = mRequestItem.SAPStatus__c;
                        if(mIntegrationName == 'Edit Supplier General+Purchasing View' ||
                            mIntegrationName == 'Edit Customer General+Purchasing View')
                        {
                            SAPStatus= 'Unsuccessful Send Sales/Purchasing view to SAP';
                        }
                        CTRRequestFormItem__c mRequestItemUpdate = new CTRRequestFormItem__c(Id = mRequestItem.Id);
                        mRequestItemUpdate.SAPStatus__c = SAPStatus;
                        mRequestItemUpdate.GatewayId__c = mGatewayId;
                        mRequestItemUpdate.LatestIntegrationName__c = mIntegrationName;
                        //mRequestItemUpdate.SAPSubmitTime__c = DateTime.Now();
                        mRequestItemUpdate.IntegrationStatus__c = 'Fail';
    
                        update mRequestItemUpdate;
                        System.debug('HTTP error: ' + response.getStatusCode() + ' ' + response.getBody());
                        
                    }
                }
            }
        }
        
    }
    
    public void finish(Database.BatchableContext BC) 
    {

    }
}