public with sharing class CTRRequestFormItemEditController 
{
    public class options
    {
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String value {get; set;}
    }
    public class mResultWrapper
    {
        @AuraEnabled public Id mRecordId {get; set;}
        @AuraEnabled public CTRRequestFormItem__c mRequestItem {get; set;}
        @AuraEnabled public CTRRequestFormHeader__c mRequestHeader {get; set;}
        @AuraEnabled public List<options> mProductCustomerTopPicklist {get; set;}
        @AuraEnabled public List<options> mProductSupplierTopPicklist {get; set;}
        @AuraEnabled public String mBuProfile {get; set;}
        @AuraEnabled public String mCurrentUserName {get; set;}
        @AuraEnabled public String mRecordTypeName {get; set;}
        @AuraEnabled public String mResult {get; set;}
        @AuraEnabled public String mMessage {get; set;}

    }

    @AuraEnabled
    public static mResultWrapper onloadEditPage(Id mRecordId)
    {
        try 
        {
            List<String> mRequestItemFields = new List<String>(CTRRequestFormItem__c.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlItem = ''
            + ' SELECT ' + String.join(mRequestItemFields, ',')
            + ' ,CTRRequestFormHeader__r.Country__r.Code__c'
            + ' ,Customer__r.AccountNumber__c, RecordType.Name'
            + ' ,Customer__r.SupplierNumber__c'
            + ' ,Owner.ProfileId, Owner.Profile.Name'
            + ' ,RecordType.DeveloperName ,TermofPayment__r.Code__c'
            + ' FROM CTRRequestFormItem__c'
            + ' WHERE ID = :mRecordId LIMIT 1';
            CTRRequestFormItem__c mRequestItem = Database.query(soqlItem);

            Id mHeaderId = mRequestItem.CTRRequestFormHeader__c;
            List<String> mRequestHeaderFields = new List<String>(CTRRequestFormHeader__c.SObjectType.getDescribe().fields.getMap().keySet());            
            String soqlHeader = ''
                + ' SELECT ' + String.join(mRequestHeaderFields, ',')
                + ' ,Customer__r.AccountNumber__c, RecordType.DeveloperName, RecordType.Name, Customer__r.SupplierNumber__c'
                + ' FROM CTRRequestFormHeader__c'
                + ' WHERE ID = :mHeaderId LIMIT 1';
            CTRRequestFormHeader__c mHeader = Database.query(soqlHeader);

            String mSalesOrg = '';
            if(mRequestItem.RecordType.DeveloperName.contains('Customer'))
            {
                mSalesOrg = mRequestItem.SalesOrganization__c;
            }
            else if(mRequestItem.RecordType.DeveloperName.contains('Supplier'))
            {
                mSalesOrg = mRequestItem.PurchasingOrganization__c;
            }


            mResultWrapper mResult = new mResultWrapper();
            mResult.mRequestItem = mRequestItem;
            mResult.mRequestHeader = mHeader;
            mResult.mBuProfile = CTRBuProfileController.checkBusinessUnitFromProfile(UserInfo.getUserId(), mRecordId).BusinessUnit__c;
            mResult.mProductCustomerTopPicklist = convertedDropdownToOptions('CTRRequestFormItem__c', 'InterestedProductTypeAsCustomerTOP__c');
            mResult.mProductSupplierTopPicklist = convertedDropdownToOptions('CTRRequestFormItem__c', 'InterestedProductTypeAsSupplierTOP__c');
            mResult.mRecordTypeName = mRequestItem.RecordType.DeveloperName;
            mResult.mCurrentUserName = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId()].Name;
            mResult.mResult = 'Success';
            return mResult;
        }
        catch (Exception e) 
        {
            //throw new AuraHandledException(e.getMessage());
            mResultWrapper mResult = new mResultWrapper();
            mResult.mResult = 'Failed';
            mResult.mMessage = 'Apex Doinit Error Line '+e.getLineNumber()+' Message: '+e.getMessage();
            return mResult;
        }
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

    

}