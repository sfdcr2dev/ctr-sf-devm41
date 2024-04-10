public with sharing class CTRSapInformationController 
{

    //Doinit
    @AuraEnabled
    public static SAPInfoData getSAPInfoData(Id recordId)
    {
        //get BU
        Id mUserId = UserInfo.getUserId();
        CTRBuProfile__mdt mBU = CTRBuProfileController.checkBusinessUnitFromProfile(mUserId, recordId);

        //get Item
        List<String> mRequestItemFields = new List<String>(CTRRequestFormItem__c.SObjectType.getDescribe().fields.getMap().keySet());            
        String soqlItem = ''
            + ' SELECT ' + String.join(mRequestItemFields, ',')
            + ' ,Customer__r.AccountNumber__c, RecordType.DeveloperName, RecordType.Name, Customer__r.SupplierNumber__c'
            + ' FROM CTRRequestFormItem__c'
            + ' WHERE ID = :recordId LIMIT 1';
        CTRRequestFormItem__c mItem = Database.query(soqlItem);
        Id mHeaderId =  mItem.CTRRequestFormHeader__c;
        System.debug('mItem:'+mItem.CTRRequestFormHeader__c);
        //get header 
        List<String> mRequestHeaderFields = new List<String>(CTRRequestFormHeader__c.SObjectType.getDescribe().fields.getMap().keySet());            
        String soqlHeader = ''
            + ' SELECT ' + String.join(mRequestHeaderFields, ',')
            + ' ,Customer__r.AccountNumber__c, RecordType.DeveloperName, RecordType.Name, Customer__r.SupplierNumber__c'
            + ' FROM CTRRequestFormHeader__c'
            + ' WHERE ID = :mHeaderId LIMIT 1';
        CTRRequestFormHeader__c mHeader = Database.query(soqlHeader);

        SAPInfoData mInfo = new SAPInfoData();
        mInfo.mHeaderId = mHeaderId;
        mInfo.mBusinessUnit = mBU.BusinessUnit__c;
        mInfo.mRecordTypeName = mItem.RecordType.DeveloperName;
        mInfo.mRequestItem = mItem;
        mInfo.mRequestHeader = mHeader;
        mInfo.mDefaultPickList = getRequestItemPickList();

        return mInfo;
    }

    @AuraEnabled
    public static PicklistWrapper getRequestItemPickList()
    {
        PicklistWrapper mPicklist = new PicklistWrapper();
        mPicklist.mTypeOfBusinessBranch = convertedDropdownToOptions('CTRRequestFormHeader__c','TypeOfBusinessBranch__c');
        mPicklist.mCountryCodePhone = convertedDropdownToOptions('CTRRequestFormHeader__c','PhoneCountryCode__c');
        mPicklist.mLanguage = convertedDropdownToOptions('CTRRequestFormHeader__c','Language__c');
        mPicklist.mAccountGroup =  convertedDropdownToOptions('CTRRequestFormHeader__c','AccountGroup__c');
        mPicklist.mTradingPartner =  convertedDropdownToOptions('CTRRequestFormHeader__c','TradingPartner__c');
        mPicklist.mRegion =  convertedDropdownToOptions('CTRRequestFormHeader__c','RegionSAP__c');
        mPicklist.mTaxClassification=  convertedDropdownToOptions('CTRRequestFormHeader__c','TAXClassification__c');

        
        mPicklist.mSalesOrgTOP = convertedDropdownToOptions('CTRRequestFormItem__c','SalesOrganizationTOP__c');
        mPicklist.mSalesOrgTX = convertedDropdownToOptions('CTRRequestFormItem__c','SalesOrganizationTX__c');
        mPicklist.mDistributionChannel = convertedDropdownToOptions('CTRRequestFormItem__c','DistributionChannel__c');
        mPicklist.mDivision = convertedDropdownToOptions('CTRRequestFormItem__c','Division__c');
        mPicklist.mPurchasingOrgTOP = convertedDropdownToOptions('CTRRequestFormItem__c','PurchasingOrganizationTOP__c');
        mPicklist.mPurchasingOrgTX = convertedDropdownToOptions('CTRRequestFormItem__c','PurchasingOrganizationTX__c');
        mPicklist.mCompanyCodeTOP = convertedDropdownToOptions('CTRRequestFormItem__c','CompanyCodeTOP__c');
        mPicklist.mCompanyCodeTX= convertedDropdownToOptions('CTRRequestFormItem__c','CompanyCodeTX__c');
        mPicklist.mCashManagementGroup = convertedDropdownToOptions('CTRRequestFormItem__c','CashManagementGroup__c');
        //mPaymentMethod
        //mAccountCleck
        //mWithHoldingTaxCountry
        mPicklist.mPriceGroup =  convertedDropdownToOptions('CTRRequestFormItem__c','PriceGroup__c');
        mPicklist.mPaymentGuaranteeProcedure=  convertedDropdownToOptions('CTRRequestFormItem__c','PaymentGuaranteeProcedure__c');
        mPicklist.mPaymentTerm=  convertedDropdownToOptions('CTRRequestFormItem__c','PaymentTerm__c');
        mPicklist.mIncoterms=  convertedDropdownToOptions('CTRRequestFormItem__c','Incoterms__c');
        mPicklist.mAccountAssignmentGroup=  convertedDropdownToOptions('CTRRequestFormItem__c','AccountAssignmentGroup__c');
        mPicklist.mCurrency =  convertedDropdownToOptions('CTRRequestFormItem__c','Currency__c');

        mPicklist.mCreditControlArea =  convertedDropdownToOptions('CTRRequestFormItem__c','CreditControlArea__c');
        mPicklist.mPartialDeliveriesperitem=  convertedDropdownToOptions('CTRRequestFormItem__c','PartialDeliveriesperitem__c');
        mPicklist.mSalesGroup=  convertedDropdownToOptions('CTRRequestFormItem__c','SalesGroup__c');
        mPicklist.mRiskCategory=  convertedDropdownToOptions('CTRRequestFormItem__c','RiskCategory__c');
        mPicklist.mIncoterms2=  convertedDropdownToOptions('CTRRequestFormItem__c','Incoterms2__c');
        mPicklist.mDeliveryPlant=  convertedDropdownToOptions('CTRRequestFormItem__c','DeliveryPlant__c');
        mPicklist.mShippingConditions=  convertedDropdownToOptions('CTRRequestFormItem__c','ShippingConditions__c');
        mPicklist.mDeliveryPriority =  convertedDropdownToOptions('CTRRequestFormItem__c','DeliveryPriority__c');
        mPicklist.mSalesOffice =  convertedDropdownToOptions('CTRRequestFormItem__c','SalesOffice__c');
        mPicklist.mSalesDistrict =  convertedDropdownToOptions('CTRRequestFormItem__c','SalesDistrict__c');
        return mPicklist;
    }
    public static List<options> convertedDropdownToOptions(String mObj, String mField)
    {
        List<options> mOptionList = new List<options>();
        Schema.DescribeFieldResult plistvalues = Schema.getGlobalDescribe().get(mObj).getDescribe().fields.getMap().get(mField).getDescribe();
        for(PicklistEntry mPicklist:plistvalues.getpicklistvalues()) 
        {
            options mOption = new options();
            mOption.label = mPicklist.getLabel();
            mOption.value =mPicklist.getValue();
            mOptionList.add(mOption);
        }        
        return mOptionList;
    }


    /*
    @AuraEnabled
    public static Map<String, List<String>> getDependentPicklistValues(String objectName, String controllingField, String dependentField){
        Map<String, List<String>> controllingInfo = new Map<String, List<String>>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();
        
        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
        
        for(Schema.PicklistEntry currdependentValue : dependentValues)
        {
            controllingInfo.put(currdependentValue.getValue(), new List<String>());
        }
        for(Schema.PicklistEntry currDependentValue : dependentValues)
        {
            String jsonString = JSON.serialize(currDependentValue);
            
            MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
            
            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
                        
            Integer baseCount = 0;
            
            for(Integer curr : hexString.getChars())
            {
                Integer val = 0;
                
                if(curr >= 65)
                {
                    val = curr - 65 + 10;
                }
                else
                {
                    val = curr - 48;
                }
                
                if((val & 8) == 8)
                {
                    controllingInfo.get(currDependentValue.getValue()).add(controllingValues[baseCount + 0].getValue());
                }
                if((val & 4) == 4)
                {
                    controllingInfo.get(currDependentValue.getValue()).add(controllingValues[baseCount + 1].getValue());               
                }
                if((val & 2) == 2)
                {
                    controllingInfo.get(currDependentValue.getValue()).add(controllingValues[baseCount + 2].getValue());                  
                }
                if((val & 1) == 1)
                {
                    controllingInfo.get(currDependentValue.getValue()).add(controllingValues[baseCount + 3].getValue());                  
                }
                
                baseCount += 4;
            }            
        } 
        
        return controllingInfo;
    }
    */
    
    @AuraEnabled
    public static void saveReqFormItemAndReqFormHeader(String recordIdFormItem, CTRRequestFormHeader__c reqFormHeaderObj, CTRRequestFormItem__c reqFormItemObj) {
        try{
            if(String.isNotBlank(recordIdFormItem))
            {
                reqFormItemObj.Id = recordIdFormItem;
                CTRRequestFormItem__c formItem = [SELECT CTRRequestFormHeader__c FROM CTRRequestFormItem__c WHERE id =:recordIdFormItem];
                reqFormHeaderObj.Id = formItem.CTRRequestFormHeader__c;
            }
            reqFormItemObj.ChangedSAPInformation__c = true;
            upsert reqFormItemObj;
            upsert reqFormHeaderObj;
        }
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage() + e.getLineNumber());
        }
    }

    //Wrapper
    public class SAPInfoData
    {
        @AuraEnabled public Id mHeaderId {get;set;}
        @AuraEnabled public String mBusinessUnit {get;set;}
        @AuraEnabled public String mRecordTypeName {get;set;}
        @AuraEnabled public String mCurrentUserName {get;set;}
        @AuraEnabled public CTRRequestFormItem__c mRequestItem {get;set;}
        @AuraEnabled public CTRRequestFormHeader__c mRequestHeader {get;set;}
        @AuraEnabled public PicklistWrapper mDefaultPickList {get;set;}
        @AuraEnabled public Map<String, dependencyAccountGroup> mProductMapDependencyTOP{get;set;}
        @AuraEnabled public Boolean hasPermission {get;set;}
    }
    

    public class dependencyAccountGroup
    {
        @AuraEnabled public List<options> mDistributionChannel {get;set;}
        @AuraEnabled public String mCurrency {get;set;}
        @AuraEnabled public String mTaxClassification {get;set;}
        @AuraEnabled public String mAccountAssignmentGroup {get;set;}
        @AuraEnabled public String mLanguageValue {get;set;}
        // @AuraEnabled public String mPaymentGuaranteeProcedureValue {get;set;}

        // @AuraEnabled public Map<String ,String> mCurrencyMap {get;set;}
        // @AuraEnabled public Map<String ,String> mTaxClassificationMap {get;set;}
        // @AuraEnabled public Map<String ,String> mAccountAssignmentGroupMap {get;set;}
        // @AuraEnabled public Map<String ,String> mLanguageValueMap {get;set;}
        @AuraEnabled public Map<String, String> mPaymentGuaranteeProcedureValueMap {get;set;}
        //dependencyMappingDefaultValue mDefaultValue {get; set;}
        

        

    }
    public class dependencyMappingDefaultValue
    {
        @AuraEnabled public Map<String ,String> mCurrencyMap {get;set;}
        @AuraEnabled public Map<String ,String> mTaxClassificationMap {get;set;}
        @AuraEnabled public Map<String ,String> mAccountAssignmentGroupMap {get;set;}
        @AuraEnabled public Map<String ,String> mLanguageValueMap {get;set;}
        @AuraEnabled public Map<String, String> mPaymentGuaranteeProcedureValueMap {get;set;}
    }

    public class options {
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String label {get;set;}
    }
    
    public class MyPickListInfo
    {
        @AuraEnabled public String validFor;
    }

    public class PicklistWrapper
    {
        
        @AuraEnabled public List<options> mCountryCodePhone {get;set;}
        @AuraEnabled public List<options> mLanguage {get;set;}
        @AuraEnabled public List<options> mTypeOfBusinessBranch {get;set;}
        @AuraEnabled public List<options> mAccountGroup {get;set;}
        @AuraEnabled public List<options> mTradingPartner {get;set;}
        @AuraEnabled public List<options> mRegion {get;set;}

        @AuraEnabled public List<options> mSalesOrgTOP {get;set;}
        @AuraEnabled public List<options> mSalesOrgTX {get;set;}
        @AuraEnabled public List<options> mDistributionChannel {get;set;}
        @AuraEnabled public List<options> mDivision {get;set;}
        @AuraEnabled public List<options> mPurchasingOrgTOP {get;set;}
        @AuraEnabled public List<options> mPurchasingOrgTX {get;set;}
        @AuraEnabled public List<options> mCompanyCodeTOP {get;set;}
        @AuraEnabled public List<options> mCompanyCodeTX {get;set;}
        @AuraEnabled public List<options> mCashManagementGroup {get;set;}
        @AuraEnabled public List<options> mPaymentMethod {get;set;}
        @AuraEnabled public List<options> mAccountCleck {get;set;}
        @AuraEnabled public List<options> mWithHoldingTaxCountry {get;set;}


        

        @AuraEnabled public List<options> mPriceGroup {get;set;}
        @AuraEnabled public List<options> mPaymentGuaranteeProcedure {get;set;}
        @AuraEnabled public List<options> mPaymentTerm {get;set;}
        @AuraEnabled public List<options> mIncoterms {get;set;}
        @AuraEnabled public List<options> mAccountAssignmentGroup {get;set;}
        @AuraEnabled public List<options> mTaxClassification {get;set;}
        @AuraEnabled public List<options> mCurrency {get;set;}

        @AuraEnabled public List<options> mCreditControlArea {get;set;}
        @AuraEnabled public List<options> mPartialDeliveriesperitem {get;set;}
        @AuraEnabled public List<options> mSalesGroup {get;set;}
        @AuraEnabled public List<options> mRiskCategory {get;set;}
        @AuraEnabled public List<options> mIncoterms2 {get;set;}
        @AuraEnabled public List<options> mDeliveryPlant {get;set;}
        @AuraEnabled public List<options> mShippingConditions {get;set;}
        @AuraEnabled public List<options> mDeliveryPriority {get;set;}
        @AuraEnabled public List<options> mSalesOffice {get;set;}
        @AuraEnabled public List<options> mSalesDistrict {get;set;}
    }

    //Doinit
    @AuraEnabled
    public static SAPInfoData getSAPInfoDatav2(Id recordId)
    {
        //get BU
        Id mUserId = UserInfo.getUserId();
        SAPInfoData mInfo = new SAPInfoData();
        CTRBuProfile__mdt mBU = CTRBuProfileController.checkBusinessUnitFromProfile(mUserId, recordId);
        List<User> mUser = [SELECT Id, Name,UserRole.name,Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
        
        //get Item
        List<String> mRequestItemFields = new List<String>(CTRRequestFormItem__c.SObjectType.getDescribe().fields.getMap().keySet());            
        String soqlItem = ''
            + ' SELECT ' + String.join(mRequestItemFields, ',')
            + ' ,Customer__r.AccountNumber__c, RecordType.DeveloperName, RecordType.Name, Customer__r.SupplierNumber__c, CTRRequestFormHeader__r.Country__r.Code__c'
            + ' FROM CTRRequestFormItem__c'
            + ' WHERE ID = :recordId LIMIT 1';
        CTRRequestFormItem__c mItem = Database.query(soqlItem);
        Boolean checkPermission = checkUserPermission(mItem);
        mInfo.hasPermission = checkPermission;
        if(checkPermission) {
            Id mHeaderId =  mItem.CTRRequestFormHeader__c;
            System.debug('mItem:'+mItem.CTRRequestFormHeader__c);
            //get header 
            List<String> mRequestHeaderFields = new List<String>(CTRRequestFormHeader__c.SObjectType.getDescribe().fields.getMap().keySet());            
            String soqlHeader = ''
                + ' SELECT ' + String.join(mRequestHeaderFields, ',')
                + ' ,Customer__r.AccountNumber__c, RecordType.DeveloperName, RecordType.Name, Customer__r.SupplierNumber__c'
                + ' FROM CTRRequestFormHeader__c'
                + ' WHERE ID = :mHeaderId LIMIT 1';
            CTRRequestFormHeader__c mHeader = Database.query(soqlHeader);

            Map<String,dependencyAccountGroup> mMapingAccountGroupData = new  Map<String,dependencyAccountGroup>();
            if(mItem.BusinessUnit__c == 'TOP')
            {
                if(mItem.RecordType.DeveloperName.contains('Customer'))
                {
                    String mSalesOrg = mItem.SalesOrganizationTOP__c;
                    String mProduct = mItem.InterestedProductTypeAsCustomerTOP__c;
                    if(String.isNotBlank(mProduct))
                    {
                        Map<String,CTRDependentPicklist__mdt> mDependencyData = CTRDependentPicklist__mdt.getAll();
                        List<options> mDistributionChannelFullList = convertedDropdownToOptions('CTRDependentPicklist__mdt','DistributionChannel__c');
                        List<options> mCreditConditionFullList =convertedDropdownToOptions('CTRDependentPicklist__mdt','CreditCondition__c');
                        List<options> mPaymentGuaranteeProcedureFullList = convertedDropdownToOptions('CTRDependentPicklist__mdt','PaymentGuaranteeProcedure__c');
                        Set<String> mAccountGroupSet = new Set<String>();
                        
                        //Grouping AccountGroup
                        for(CTRDependentPicklist__mdt mData: mDependencyData.values())
                        {
                            if(mData.Product__c == mProduct)
                            {
                                mAccountGroupSet.add(mData.AccountGroup__c);
                            }
                        }

                        List<Map<String,dependencyAccountGroup>> mDependencyList = new List<Map<String,dependencyAccountGroup>>();
                        

                        //Grouping DistributionChannel
                        for(String mAccountGroup: mAccountGroupSet)
                        {
                            Map<String, List<options>> mAccountGroupMap = new Map<String, List<options>>();
                            Set<options> mDistributionChannelSet = new Set<options>();
                            List<options> mDistributionChannelList = new List<options>();

                            Map<String, String> mPaymentGuaranteeProcedureValueMap = new Map<String ,String>();

                            String mCurrency = '';
                            String mTaxClassification = '';
                            String mAccountAssignmentGroup = '';
                            String mLanguage = '';
                            for(CTRDependentPicklist__mdt mData: mDependencyData.values())
                            {

                                if(mData.Product__c == mProduct)
                                {
                                    System.debug('mData.AccountGroup__c: '+mData.AccountGroup__c);
                                    System.debug('mData.SalesOrg: '+mData.SalesOrganization__c);
                                    System.debug('mData.DistributionChannel__c: '+mData.DistributionChannel__c);
                                    System.debug('mData.Language__c: '+mData.Language__c);
                                    if(mAccountGroup == mData.AccountGroup__c)
                                    {
                                        if(mData.DistributionChannel__c != null)
                                        {
                                            for(options mDistributionChanel: mDistributionChannelFullList)
                                            {
                                                if(mDistributionChanel.Value == mData.DistributionChannel__c)
                                                {
                                                    options mOp = new options();
                                                    mOp.Label = mDistributionChanel.Label;
                                                    mOp.Value = mDistributionChanel.Value;
                                                    mDistributionChannelSet.add(mOp);
                                                    System.debug('mData.Language__c: '+mData.Language__c);
                                                }
                                            }
                                        }
                                        if(mData.PaymentGuaranteeProcedure__c != null)
                                        {
                                            for(options mPaymentGuaranteeProcedure: mPaymentGuaranteeProcedureFullList)
                                            {
                                                if(mPaymentGuaranteeProcedure.Value == mData.PaymentGuaranteeProcedure__c)
                                                {
                                                    if(mData.CreditCondition__c != null)
                                                    {
                                                        mPaymentGuaranteeProcedureValueMap.put(mPaymentGuaranteeProcedure.Value, mData.CreditCondition__c);
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        if(mData.Currency__c != null)
                                        {
                                            mCurrency = mData.Currency__c;
                                        }
                                        if(mData.TaxClassification__c != null)
                                        {
                                            mTaxClassification =mData.TaxClassification__c;
                                        }
                                        if(mData.AccountAssignmentGroup__c != null)
                                        {
                                            mAccountAssignmentGroup =mData.AccountAssignmentGroup__c;
                                        }
                                        if(mData.Language__c != null)
                                        {
                                            mLanguage =mData.Language__c;
                                        }
                                    }
                                }
                            }
                            
                            mDistributionChannelList.addall(mDistributionChannelSet);
                            // dependencyMappingDefaultValue mDefaultMap = new dependencyMappingDefaultValue();
                            // mDefaultMap.mCurrency = mCurrency;
                            // mDefaultMap.mTaxClassification = mTaxClassification;
                            // mDefaultMap.mAccountAssignmentGroup = mAccountAssignmentGroup;
                            // mDefaultMap.mLanguageValue = mLanguage;
                            // mDefaultMap.mPaymentGuaranteeProcedureValueMap = mPaymentGuaranteeProcedureValueMap;

                            dependencyAccountGroup mDependencyMap = new dependencyAccountGroup();
                            mDependencyMap.mDistributionChannel = mDistributionChannelList;
                            mDependencyMap.mCurrency = mCurrency;
                            mDependencyMap.mTaxClassification = mTaxClassification;
                            mDependencyMap.mAccountAssignmentGroup = mAccountAssignmentGroup;
                            mDependencyMap.mLanguageValue = mLanguage;
                            mDependencyMap.mPaymentGuaranteeProcedureValueMap = mPaymentGuaranteeProcedureValueMap;
                            //mDependencyMap.mDefaultValue = mDefaultMap;

                            mMapingAccountGroupData.put(mAccountGroup, mDependencyMap);
                            mDependencyList.add(mMapingAccountGroupData);

                        }
                        System.debug('mMapingAccountGroupData:'+mMapingAccountGroupData);
                        System.debug('mMapingAccountGroupData:'+JSON.serialize(mMapingAccountGroupData));
                    }
                }
            }
        

            mInfo.mHeaderId = mHeaderId;
            mInfo.mBusinessUnit = mBU.BusinessUnit__c;
            mInfo.mRecordTypeName = mItem.RecordType.DeveloperName;
            mInfo.mCurrentUserName = mUser[0].Name;
            mInfo.mRequestItem = mItem;
            mInfo.mRequestHeader = mHeader;
            mInfo.mDefaultPickList = getRequestItemPickList();
            mInfo.mProductMapDependencyTOP = mMapingAccountGroupData;
        }
        return mInfo;
    }

    public static Boolean checkUserPermission(CTRRequestFormItem__c mItem) {
        User currentUser = [SELECT Id, Profile.Name, Employee_Id__c FROM User WHERE Id = :UserInfo.getUserId()];
        Boolean hasPermission = false;
        if(mItem.BusinessUnit__c == 'TX') {
            String mType = mItem.CTRRequestFormHeader__r.Country__r.Code__c == 'TH' ? 'Domestic' : 'International';
            String mRecordType = mItem.RecordType.DeveloperName.contains('Customer') ? 'Customer' : 'Supplier';
            System.debug('Debug permission '+currentUser.Employee_Id__c+' : '+mItem.SubBU__c+' : '+mType+' : '+mRecordType);
            List<CTRActorInProcess__mdt> actorMdt = [SELECT ActorPosition__c, ActorTeam__c, EmployeeID__c, InterByTx__c, Process__c, Step__c, Type__c, SalesOrg__c, RecordType__c FROM CTRActorInProcess__mdt 
            WHERE Step__c = 'TXMO' AND SalesOrg__c =: mItem.SubBU__c AND Type__c =: mType AND RecordType__c =: mRecordType AND InterByTx__c = 'No' AND EmployeeID__c =: currentUser.Employee_Id__c];

            if(actorMdt.size() > 0) {
                hasPermission = true;
            }
            if(currentUser.Profile.Name == 'System Administrator') {
                hasPermission = true;
            }
        } else if(mItem.BusinessUnit__c == 'TOP' || mItem.BusinessUnit__c == 'LABIX') {
            if(currentUser.Profile.Name == 'System Administrator' || currentUser.Id == mItem.OwnerId) {
                hasPermission = true;
            }
        }
        return hasPermission;
    }

    /*@AuraEnabled(cacheable=true)
    public static List<DropdownModel> pickListDropdownModel(String obj, String str) {
         List<DropdownModel> regList = new List<DropdownModel>(); 
            Schema.DescribeFieldResult plistvalues = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(str).getDescribe();
            for(PicklistEntry ent:plistvalues.getpicklistvalues()) {
                DropdownModel dd = new DropdownModel(ent.getValue(),ent.getLabel());
                regList.add(dd);
            }        
            return regList;
    }

    public class DropdownModel {
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String label;
        public DropdownModel(String value, String label) {
            this.value = value;
        this.label = label;
        }
    }*/

    /*@AuraEnabled
    public static String getRecordTypeName(String recordId){
        CTRRequestFormItem__c recordType =[SELECT RecordType.Name FROM CTRRequestFormItem__c WHERE Id=: recordId];
        return recordType.RecordType.Name;
    }

    @AuraEnabled
    public static String getIdFormHeader (String recordIdFormItem){
        CTRRequestFormItem__c formItem = [SELECT Id,CTRRequestFormHeader__c FROM CTRRequestFormItem__c WHERE id =:recordIdFormItem];
        return formItem.CTRRequestFormHeader__c;
    }

    @AuraEnabled
    public static CTRRequestFormItem__c getCustomerSalesTab(String recordIdFormItem){ 
        CTRRequestFormItem__c formItem = [SELECT SalesDistrict__c,SalesOffice__c,SalesGroup__c,Currency__c,TaxClassification__c,CurrencyDatanotcorrect__c,OrderProbability__c,ExchRateType__c,Custpiceproc__c,CustStatGroup__c,OrderCombination__c,DeliveryPriority__c,ShippingConditions__c,DeliveryPlant__c,TransportationZone__c,PartialDeliveriesperitem__c,UnderdeliveryTolerance__c,OverdeliveryTolerance__c,Rebate__c,IsPriceDetermin__c,Incoterms__c,Incoterms2__c,CreditControlArea__c,PaymentTerm__c,PaymentGuaranteeProcedure__c,AccountAssignmentGroup__c,RiskCategory__c,PriceGroup__c FROM CTRRequestFormItem__c WHERE id =:recordIdFormItem];
        return formItem;
    }

    @AuraEnabled
    public static CTRRequestFormHeader__c getRequiredHeaderTOP(String recordIdFormItem){
        CTRRequestFormItem__c formItem = [SELECT CTRRequestFormHeader__c FROM CTRRequestFormItem__c WHERE id =:recordIdFormItem];
        CTRRequestFormHeader__c formHeader =[SELECT AccountGroup__c,TypeOfBusinessBranch__c,TAXNumber__c,CustomerNameLocal1__c,SupplierSearchTermLocal__c,StreetLocal__c,DistrictLocal__c,PostalCodeLocalText__c,Country__c,Language__c,Ordercurrency__c,Incoterms2Port__c FROM CTRRequestFormHeader__c WHERE id=:formItem.CTRRequestFormHeader__c];
        return formHeader;
    }
    
    @AuraEnabled
    public static CTRRequestFormHeader__c getRequiredHeaderTX(String recordIdFormItem){
        CTRRequestFormItem__c formItem = [SELECT CTRRequestFormHeader__c FROM CTRRequestFormItem__c WHERE id =:recordIdFormItem];
        CTRRequestFormHeader__c formHeader =[SELECT CustomerNameLocal1__c,CustomerNameEN1__c,CustomerSearchTermLocal__c,SupplierSearchTermLocal__c,StreetLocal__c,PostalCodeLocalText__c,DistrictLocal__c,Country__c,Phone__c,SalesOrganization__c,AccountGroup__c,RegionSAP__c,DistributionChannel__c,Division__c,Industry__c,CustomerType__c,CustomerGroup__c,TypeOfBusinessBranch__c,TAXNumber__c,Application__c,InterGroup__c,ReconAccount__c,SortKey__c,CashManagementGroup__c,Authorization__c,PaymentHistoryRecord__c,GroupKeyAccountKeyofBank__c,VATRegno__c,PaymentTerm__c,PaymentMethod__c,AccigClerk__c,Ordercurrency__c,CashMgmntGroupDatanotcorrect__c,CityStateLocalDatanotcorrect__c,CountryDatanotCorrect__c,CustomerNameEN1Datanotcorrect__c,CustomerNameLocalDatanotcorrect__c,GroupKeyAccountKeyofBankDatanotcorrect__c,Liable1Datanotcorrect__c,Lible2Datanotcorrect__c,OrdercurrencyDatanotcorrect__c,ReconAccountDatanotcorrect__c,Recty1Datanotcorrect__c,Recty2Datanotcorrect__c,SortKeyDatanotcorrect__c,TAXNumberDatanotcorrect__c,WHTaxCountryDatanotcorrect__c,Wthttype1Datanotcorrect__c,Wthttype2Datanotcorrect__c FROM CTRRequestFormHeader__c WHERE id=:formItem.CTRRequestFormHeader__c];
        return formHeader;
    }*/

}