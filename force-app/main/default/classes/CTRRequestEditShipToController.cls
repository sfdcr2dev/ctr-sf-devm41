public with sharing class CTRRequestEditShipToController {
    public class RequestWrapper
    {
        @auraEnabled public Id mRecordId {get; set;}
        @auraEnabled public Integer mIndex {get; set;}
        @auraEnabled public String mAccountId {get; set;}
        @auraEnabled public String mShipToName {get; set;}
        @auraEnabled public String mCountry {get; set;}
        @auraEnabled public String mSalesOrg {get; set;}
        @auraEnabled public String mDivision {get;set;}
        @auraEnabled public String mDistributionChannel {get;set;}
        @auraEnabled public String mLabelSalesOrg {get; set;}
        @auraEnabled public String mLabelDivision {get;set;}
        @auraEnabled public String mLabelDistributionChannel {get;set;}
        @auraEnabled public Boolean mSelected {get; set;}
    }

    public class ResponseWrapper {
        @AuraEnabled public Boolean result {get; set;}
        @AuraEnabled public String message {get; set;} 
        @AuraEnabled public Id resRecordId {get; set;}
    }

    @AuraEnabled
    public static List<RequestWrapper> onloadCreatePage(Id mAccountId)
    {
        try 
        {
            List<Account> currAccount = [SELECT Id, SalesOrganization__c FROM Account WHERE Id =: mAccountId];

            List<RequestWrapper> mRequestWrapperList = new List<RequestWrapper>();
            Set<String> setSalesOrg = new Set<String>{'2000','9100','9200','9300','9400'};
            List<C360_Relationship__c> mRelatedShipToList = new List<C360_Relationship__c>([SELECT Id, ReverseAccount__c, ReverseAccount__r.Name, ReverseAccount__r.Country__r.Description__c, RelationshipType__c FROM C360_Relationship__c WHERE Account__c =: mAccountId AND RelationshipType__c = 'WE']); // Has Ship to Party
            // Set<Id> mAccIdSet = new Set<Id>();
            Map<Id, C360_Relationship__c> mapAccIdRelatedShipTo = new Map<Id, C360_Relationship__c>();
            for(C360_Relationship__c relatedShipTo : mRelatedShipToList) {
                mapAccIdRelatedShipTo.put(relatedShipTo.ReverseAccount__c,relatedShipTo);
            }
            System.debug('Debug key '+mapAccIdRelatedShipTo.keySet());
            
            List<C360_SalesArea__c> mSalesAreaList = new List<C360_SalesArea__c>([SELECT AccountNumber__c, SalesOrganization__c, Division__c, DistributionChannel__c, toLabel(SalesOrganization__c) salesOrgLabel, toLabel(Division__c) divisionLabel, toLabel(DistributionChannel__c) distChLabel FROM C360_SalesArea__c WHERE AccountNumber__c IN :mapAccIdRelatedShipTo.keySet() AND SalesOrganization__c IN :setSalesOrg]);
            Integer mIndex = 1;
            for(C360_SalesArea__c mSalesArea: mSalesAreaList)
            {
                RequestWrapper mRequestWrapper = new RequestWrapper();
                mRequestWrapper.mRecordId = mSalesArea.Id;
                mRequestWrapper.mIndex = mIndex;
                mRequestWrapper.mAccountId = mSalesArea.AccountNumber__c;
                mRequestWrapper.mShipToName = mapAccIdRelatedShipTo.get(mSalesArea.AccountNumber__c)?.ReverseAccount__r.Name;
                mRequestWrapper.mCountry = mapAccIdRelatedShipTo.get(mSalesArea.AccountNumber__c)?.ReverseAccount__r.Country__r.Description__c;
                mRequestWrapper.mSalesOrg = mSalesArea.SalesOrganization__c;
                mRequestWrapper.mDivision = mSalesArea.Division__c;
                mRequestWrapper.mDistributionChannel = mSalesArea.DistributionChannel__c;
                mRequestWrapper.mLabelSalesOrg = String.valueOf(mSalesArea.get('salesOrgLabel'));
                mRequestWrapper.mLabelDivision = String.valueOf(mSalesArea.get('divisionLabel'));
                mRequestWrapper.mLabelDistributionChannel = String.valueOf(mSalesArea.get('distChLabel'));
                if(currAccount[0].SalesOrganization__c == mSalesArea.SalesOrganization__c) {
                    mRequestWrapper.mSelected = true; // default as selected customer
                }
                mRequestWrapperList.add(mRequestWrapper);
                mIndex++;
            }
            
            return mRequestWrapperList;
        } 
        catch (Exception e) 
        {
            System.debug('Error From CTRRequestEditShipToController.onloadCreatePage Line: '+e.getLineNumber()+' || Message:'+e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static ResponseWrapper createRequestEditShipTo(String formData, String itemRecordTypeId, RequestWrapper requestWrapper ){
        ResponseWrapper responseResult = new ResponseWrapper();
        responseResult.result = false;
        try
        {
            if(requestWrapper == null) {
                responseResult.message = 'Not found selected item';
                return responseResult;
            }
            String customerId = requestWrapper.mAccountId;

            System.debug(' Accomplished: '+formData);
            Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(formData);
            System.debug(' cObjMap: '+cObjMap);
            String cObjJson = JSON.serialize(cObjMap);
            System.debug(' cObjJson: '+cObjJson);
            Map<String, Object> cObjMapFurious = (Map<String, Object>) JSON.deserializeUntyped(cObjJson);
            String cObjJsonDrunk = JSON.serialize(cObjMapFurious);
            
            Account accobj = (Account)JSON.deserialize(cObjJsonDrunk, Account.class);
            System.debug(' Accomplished: '+accobj);

            List<String> mSalesAreaFields = new List<String>(Schema.getGlobalDescribe().get('C360_SalesArea__c').getDescribe().fields.getMap().keySet());            
            String soqlText = '';
            soqlText+= ' SELECT ' + String.join(mSalesAreaFields, ',');
            soqlText+= ' FROM C360_SalesArea__c';
            soqlText+= ' WHERE Id = \''+requestWrapper.mRecordId+'\'';
            List<C360_SalesArea__c> mSalesAreaList = new List<C360_SalesArea__c>();
            mSalesAreaList = Database.query(soqlText);
            
            // CTRAccountCtrl.duplicateCheckResult isdup = CTRAccountCtrl.checkDuplicateAccount(accobj,shippingList,shareholderList, null);
            // System.debug(' isdup: '+isdup);
            Id headerRecordTypeId = Schema.SObjectType.CTRRequestFormHeader__c.getRecordTypeInfosByDeveloperName().get('ShipToEdit').getRecordTypeId();

            if(mSalesAreaList.size() > 0) {
                C360_SalesArea__c salesArea = mSalesAreaList[0];
                CTRRequestFormHeader__c mRequestFormHeader = new CTRRequestFormHeader__c();
                mRequestFormHeader.RecordTypeId = headerRecordTypeId;
                mRequestFormHeader.Customer__c = CustomerId;
                mRequestFormHeader.CustomerNameLocal1__c = accobj.CompanyNameEN__c != null ? accobj.CompanyNameEN__c : accobj.CompanyNameLocal__c;
                mRequestFormHeader.Country__c = accobj.Country__c;
                mRequestFormHeader.TaxCode1__c = accobj.TaxCode1__c;
                mRequestFormHeader.CustomerSearchTermEN__c = accobj.CustomerSearchTermEN__c;
                mRequestFormHeader.CustomerSearchTermLocal__c = accobj.CustomerSearchTermLocal__c;
                mRequestFormHeader.HousenoLocal__c = accobj.HousenoLocal__c;
                mRequestFormHeader.BuildingCodeLocal__c = accobj.BuildingCodeLocal__c;
                mRequestFormHeader.RoomLocal__c = accobj.RoomLocal__c;
                mRequestFormHeader.FloorLocal__c = accobj.FloorLocal__c;
                mRequestFormHeader.CoName__c = accobj.CoName__c;
                mRequestFormHeader.StreetLocal__c = accobj.StreetLocal__c;
                mRequestFormHeader.SubDistrictLocalText__c = accobj.SubDistrictLocalText__c;
                mRequestFormHeader.DistrictLocalText__c = accobj.DistrictLocalText__c;
                mRequestFormHeader.CityStateLocal__c = accobj.CityStateLocal__c;
                mRequestFormHeader.PostalCodeLocalText__c = accobj.PostalCodeLocalText__c;
                mRequestFormHeader.LocationInGoogleMapsLinks__c = accobj.LocationInGoogleMapsLinks__c;
                mRequestFormHeader.LocationInGoogleMapsGeolocation__Latitude__s = accobj.Location__Latitude__s;
                mRequestFormHeader.LocationInGoogleMapsGeolocation__Longitude__s = accobj.Location__Longitude__s;
                mRequestFormHeader.ContactSalutation__c = accobj.ContactSalutation__c;
                mRequestFormHeader.Nickname__c = accobj.Nickname__c;
                mRequestFormHeader.FirstName__c = accobj.FirstName__c;
                mRequestFormHeader.LastName__c = accobj.LastName__c;
                mRequestFormHeader.Position__c = accobj.Position__c;
                mRequestFormHeader.Email__c = accobj.Email__c;
                mRequestFormHeader.MobileCountryCode__c = accobj.MobileCountryCode__c;
                mRequestFormHeader.CountryCode__c = accobj.CountryCode__c;
                mRequestFormHeader.MobilePhone__c = accobj.MobilePhone__c;
                mRequestFormHeader.PhoneCountryCode__c = accobj.PhoneCountryCode__c;
                mRequestFormHeader.Phone__c = accobj.Phone;
                // mRequestFormHeader.PhoneExtension__c = accobj.PhoneExtension__c;
                mRequestFormHeader.FaxCountryCode__c = accobj.FaxCountryCode__c;
                mRequestFormHeader.Fax__c = accobj.Fax;
                // mRequestFormHeader.FaxExtension__c = accobj.FaxExtension__c;
                // mRequestFormHeader.SalesDistrict__c = salesArea.SalesDistrict__c;
                // mRequestFormHeader.DeliveryPriority__c = salesArea.DeliveryPriority__c;
                // mRequestFormHeader.ShippingCondition__c = salesArea.ShippingConditions__c;
                // mRequestFormHeader.DeliveryPlant__c = salesArea.DeliveryPlant__c;
                // mRequestFormHeader.MaxPartialDeliveries__c = salesArea.MaxPartialDeliveries__c != null ? String.valueOf(salesArea.MaxPartialDeliveries__c) : null;
                mRequestFormHeader.TransportationZone__c = accobj.TransportationZone__c;
                // mRequestFormHeader.PartialDeliveriesperitem__c = salesArea.PartialDeliveriesperitem__c;
                // mRequestFormHeader.UnderdeliveryTolerance__c = salesArea.UnderdeliveryTolerance__c;
                // mRequestFormHeader.OverdeliveryTolerance__c = salesArea.OverdeliveryTolerance__c;
                // mRequestFormHeader.AccountAssignmentGroup__c = salesArea.AccountAssignmentGroup__c;
                mRequestFormHeader.TaxClassification__c = accobj.TaxClassification__c;

                // mRequestFormHeader.DistributionChannel__c = requestWrapper.mDistributionChannel;
                // mRequestFormHeader.Division__c = requestWrapper.mDivision;
                // mRequestFormHeader.SalesOrganization__c = requestWrapper.mSalesOrg;
                insert mRequestFormHeader;

            
                CTRRequestFormItem__c mRequestFormItem = new CTRRequestFormItem__c();
                mRequestFormItem.CTRRequestFormHeader__c = mRequestFormHeader.Id;
                mRequestFormItem.Customer__c = CustomerId;
                // mRequestFormItem.Objective__c = ;
                // mRequestFormItem.EffectiveType__c = ;
                // mRequestFormItem.EffectiveDate__c = ;
                mRequestFormItem.RecordTypeId = itemRecordTypeId;
                mRequestFormItem.Status__c = 'New';
                mRequestFormItem.Approval_Step__c = 'Open';
                mRequestFormItem.Sensitive__c = true;
                mRequestFormItem.SalesDistrict__c = accobj.SalesDistrict__c;
                mRequestFormItem.DeliveryPriority__c = accobj.DeliveryPriority__c;
                mRequestFormItem.ShippingConditions__c = accobj.ShippingConditions__c;
                mRequestFormItem.DeliveryPlant__c = accobj.DeliveryPlant__c;
                mRequestFormItem.MaxPartialDeliveries__c = accobj.MaxPartialDeliveries__c != null ? Decimal.valueOf(accobj.MaxPartialDeliveries__c) : null;
                // mRequestFormItem.TransportationZone__c = salesArea.TransportationZone__c;
                mRequestFormItem.PartialDeliveriesperitem__c = accobj.PartialDeliveriesperitem__c;
                mRequestFormItem.UnderdeliveryTolerance__c = accobj.UnderdeliveryTolerance__c;
                mRequestFormItem.OverdeliveryTolerance__c = accobj.OverdeliveryTolerance__c;
                mRequestFormItem.AccountAssignmentGroup__c = accobj.AccountAssignmentGroup__c;
                // mRequestFormItem.TaxClassification__c = accobj.TaxClassification__c;

                mRequestFormItem.DistributionChannel__c = salesArea.DistributionChannel__c;
                mRequestFormItem.Division__c = salesArea.Division__c;
                mRequestFormItem.SalesOrganization__c = salesArea.SalesOrganization__c;
                mRequestFormItem.SalesOrganizationTX__c = salesArea.SalesOrganization__c;
                insert mRequestFormItem;

                responseResult.result = true;
                responseResult.message = 'Success';
                responseResult.resRecordId = mRequestFormItem.Id;
            }


            
            return responseResult;
        }
        catch(Exception e)
        {
            String mError = 'CTRRequestEditShipToController---'+e.getmessage()+' line:'+e.getLineNumber();
            System.debug('CTRRequestEditShipToController---'+e.getmessage()+' line:'+e.getLineNumber());      
            responseResult.message = e.getmessage();      
            return responseResult;
        }
    }
}