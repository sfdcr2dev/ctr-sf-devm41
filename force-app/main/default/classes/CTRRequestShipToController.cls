public with sharing class CTRRequestShipToController {
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
    public static List<RequestWrapper> onloadCreatePage(Id mAccountId, Id RecordType)
    {
        try 
        {
            List<Account> currAccount = [SELECT Id, SalesOrganization__c FROM Account WHERE Id =: mAccountId];
            List<RequestWrapper> mRequestWrapperList = new List<RequestWrapper>();
            Set<String> setSalesOrg = new Set<String>{'2000','9100','9200','9300','9400'};
            List<RecordType> RecordTypeList = [SELECT Id, Name, DeveloperName FROM RecordType WHERE Id = :RecordType LIMIT 1];

            if(RecordTypeList[0].DeveloperName.contains('Edit')) {

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
            } else {

                List<C360_SalesArea__c> mSalesAreaList = new List<C360_SalesArea__c>([SELECT SalesOrganization__c, Division__c, DistributionChannel__c, toLabel(SalesOrganization__c) salesOrgLabel, toLabel(Division__c) divisionLabel, toLabel(DistributionChannel__c) distChLabel FROM C360_SalesArea__c WHERE AccountNumber__c = :mAccountId AND SalesOrganization__c IN :setSalesOrg]);
                Integer mIndex = 1;
                for(C360_SalesArea__c mSalesArea: mSalesAreaList)
                {
                    RequestWrapper mRequestWrapper = new RequestWrapper();
                    mRequestWrapper.mRecordId = mSalesArea.Id;
                    mRequestWrapper.mIndex = mIndex;
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
            }

            return mRequestWrapperList;
        } 
        catch (Exception e) 
        {
            System.debug('Error From CTRRequestShipToController.onloadCreatePage Line: '+e.getLineNumber()+' || Message:'+e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static ResponseWrapper saveRequestShipTo(Id mItemId, String formData, String customerId, String itemRecordTypeId, RequestWrapper requestWrapper ){
        ResponseWrapper responseResult = new ResponseWrapper();
        responseResult.result = false;
        try
        {
            List<RecordType> RecordTypeList = [SELECT Id, Name, DeveloperName FROM RecordType WHERE Id = :itemRecordTypeId LIMIT 1];

            if(requestWrapper == null) {
                responseResult.message = 'Not found selected item';
                return responseResult;
            }
            
            System.debug(' Accomplished: '+formData);
            Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(formData);
            System.debug(' cObjMap: '+cObjMap);
            String cObjJson = JSON.serialize(cObjMap);
            System.debug(' cObjJson: '+cObjJson);
            Map<String, Object> cObjMapFurious = (Map<String, Object>) JSON.deserializeUntyped(cObjJson);
            String cObjJsonDrunk = JSON.serialize(cObjMapFurious);
            
            // Account accobj = (Account)JSON.deserialize(cObjJsonDrunk, Account.class);
            // System.debug(' Accomplished: '+accobj);

            Object obj = JSON.deserializeUntyped(cObjJsonDrunk);
            System.debug(' Accomplished: '+obj);

            Map<String, Object> objMap = new Map<String, Object>();
            if (obj instanceof Map<String, Object>) {
                objMap = (Map<String, Object>) obj;
            } else {
                System.debug('Deserialized object is not a Map.');
            }
            
            System.debug('Country__c : ' + objMap.get('Country__c'));

            if(mItemId == null) { // create from New Request button
                if(RecordTypeList[0].DeveloperName.contains('Edit')) {
                    customerId = requestWrapper.mAccountId;
                }
                List<String> mSalesAreaFields = new List<String>(Schema.getGlobalDescribe().get('C360_SalesArea__c').getDescribe().fields.getMap().keySet());            
                String soqlText = '';
                soqlText+= ' SELECT ' + String.join(mSalesAreaFields, ',');
                soqlText+= ' FROM C360_SalesArea__c';
                soqlText+= ' WHERE Id = \''+requestWrapper.mRecordId+'\'';
                List<C360_SalesArea__c> mSalesAreaList = new List<C360_SalesArea__c>();
                mSalesAreaList = Database.query(soqlText);
                
                // CTRAccountCtrl.duplicateCheckResult isdup = CTRAccountCtrl.checkDuplicateAccount(accobj,shippingList,shareholderList, null);
                // System.debug(' isdup: '+isdup);
                Id headerRecordTypeId = Schema.SObjectType.CTRRequestFormHeader__c.getRecordTypeInfosByDeveloperName().get(RecordTypeList[0].DeveloperName).getRecordTypeId();
    
                if(mSalesAreaList.size() > 0) {
                    C360_SalesArea__c salesArea = mSalesAreaList[0];
                    CTRRequestFormHeader__c mRequestFormHeader = new CTRRequestFormHeader__c();
                    mRequestFormHeader.RecordTypeId = headerRecordTypeId;
                    mRequestFormHeader.Customer__c = customerId;
                    mRequestFormHeader.CompanyNameENF__c = String.valueOf(objMap.get('CompanyNameENF__c'));
                    mRequestFormHeader.CustomerNameLocal1__c = String.valueOf(objMap.get('CompanyNameLocal__c'));
                    mRequestFormHeader.Country__c = String.valueOf(objMap.get('Country__c'));
                    mRequestFormHeader.TaxCode1__c = String.valueOf(objMap.get('TaxCode1__c'));
                    mRequestFormHeader.CustomerSearchTermEN__c = String.valueOf(objMap.get('CustomerSearchTermEN__c'));
                    mRequestFormHeader.CustomerSearchTermLocal__c = String.valueOf(objMap.get('CustomerSearchTermLocal__c'));
                    mRequestFormHeader.HousenoLocal__c = String.valueOf(objMap.get('HousenoLocal__c'));
                    mRequestFormHeader.BuildingCodeLocal__c = String.valueOf(objMap.get('BuildingCodeLocal__c'));
                    mRequestFormHeader.RoomLocal__c = String.valueOf(objMap.get('RoomLocal__c'));
                    mRequestFormHeader.FloorLocal__c = String.valueOf(objMap.get('FloorLocal__c'));
                    mRequestFormHeader.CoName__c = String.valueOf(objMap.get('CoName__c'));
                    mRequestFormHeader.StreetLocal__c = String.valueOf(objMap.get('StreetLocal__c'));
                    mRequestFormHeader.SubDistrictLocalText__c = String.valueOf(objMap.get('SubDistrictLocalText__c'));
                    mRequestFormHeader.DistrictLocalText__c = String.valueOf(objMap.get('DistrictLocalText__c'));
                    mRequestFormHeader.CityStateLocal__c = String.valueOf(objMap.get('CityStateLocal__c'));
                    mRequestFormHeader.PostalCodeLocalText__c = String.valueOf(objMap.get('PostalCodeLocalText__c'));
                    mRequestFormHeader.LocationInGoogleMapsLinks__c = String.valueOf(objMap.get('LocationInGoogleMapsLinks__c'));
                    mRequestFormHeader.LocationInGoogleMapsGeolocation__Latitude__s = Decimal.valueOf((String)objMap.get('Location__Latitude__s'));
                    mRequestFormHeader.LocationInGoogleMapsGeolocation__Longitude__s = Decimal.valueOf((String)objMap.get('Location__Longitude__s'));
                    mRequestFormHeader.ContactSalutation__c = String.valueOf(objMap.get('ContactSalutation__c'));
                    mRequestFormHeader.Nickname__c = String.valueOf(objMap.get('Nickname__c'));
                    mRequestFormHeader.FirstName__c = String.valueOf(objMap.get('FirstName__c'));
                    mRequestFormHeader.LastName__c = String.valueOf(objMap.get('LastName__c'));
                    mRequestFormHeader.Position__c = String.valueOf(objMap.get('Position__c'));
                    mRequestFormHeader.Email__c = String.valueOf(objMap.get('Email__c'));
                    mRequestFormHeader.MobileCountryCode__c = String.valueOf(objMap.get('MobileCountryCode__c'));
                    mRequestFormHeader.CountryCode__c = String.valueOf(objMap.get('CountryCode__c'));
                    mRequestFormHeader.MobilePhone__c = String.valueOf(objMap.get('MobilePhone__c'));
                    mRequestFormHeader.PhoneCountryCode__c = String.valueOf(objMap.get('PhoneCountryCode__c'));
                    mRequestFormHeader.Phone__c = String.valueOf(objMap.get('Phone'));
                    // mRequestFormHeader.PhoneExtension__c = accobj.PhoneExtension__c;
                    mRequestFormHeader.FaxCountryCode__c = String.valueOf(objMap.get('FaxCountryCode__c'));
                    mRequestFormHeader.Fax__c = String.valueOf(objMap.get('Fax'));
                    // mRequestFormHeader.FaxExtension__c = accobj.FaxExtension__c;
                    // mRequestFormHeader.SalesDistrict__c = salesArea.SalesDistrict__c;
                    // mRequestFormHeader.DeliveryPriority__c = salesArea.DeliveryPriority__c;
                    // mRequestFormHeader.ShippingCondition__c = salesArea.ShippingConditions__c;
                    // mRequestFormHeader.DeliveryPlant__c = salesArea.DeliveryPlant__c;
                    // mRequestFormHeader.MaxPartialDeliveries__c = salesArea.MaxPartialDeliveries__c != null ? String.valueOf(salesArea.MaxPartialDeliveries__c) : null;
                    mRequestFormHeader.TransportationZone__c = String.valueOf(objMap.get('TransportationZone__c'));
                    // mRequestFormHeader.PartialDeliveriesperitem__c = salesArea.PartialDeliveriesperitem__c;
                    // mRequestFormHeader.UnderdeliveryTolerance__c = salesArea.UnderdeliveryTolerance__c;
                    // mRequestFormHeader.OverdeliveryTolerance__c = salesArea.OverdeliveryTolerance__c;
                    // mRequestFormHeader.AccountAssignmentGroup__c = salesArea.AccountAssignmentGroup__c;
                    mRequestFormHeader.TAXClassification__c = String.valueOf(objMap.get('TaxClassification__c'));
    
                    // mRequestFormHeader.DistributionChannel__c = requestWrapper.mDistributionChannel;
                    // mRequestFormHeader.Division__c = requestWrapper.mDivision;
                    // mRequestFormHeader.SalesOrganization__c = requestWrapper.mSalesOrg;
                    insert mRequestFormHeader;
    
                
                    CTRRequestFormItem__c mRequestFormItem = new CTRRequestFormItem__c();
                    mRequestFormItem.CTRRequestFormHeader__c = mRequestFormHeader.Id;
                    mRequestFormItem.Customer__c = customerId;
                    // mRequestFormItem.Objective__c = ;
                    // mRequestFormItem.EffectiveType__c = ;
                    // mRequestFormItem.EffectiveDate__c = ;
                    mRequestFormItem.RecordTypeId = itemRecordTypeId;
                    mRequestFormItem.Status__c = 'New';
                    mRequestFormItem.Approval_Step__c = 'Open';
                    mRequestFormItem.Sensitive__c = true;
                    mRequestFormItem.SalesDistrict__c = String.valueOf(objMap.get('SalesDistrict__c'));
                    mRequestFormItem.DeliveryPriority__c = String.valueOf(objMap.get('DeliveryPriority__c'));
                    mRequestFormItem.ShippingConditions__c = String.valueOf(objMap.get('ShippingConditions__c'));
                    mRequestFormItem.DeliveryPlant__c = String.valueOf(objMap.get('DeliveryPlant__c'));
                    mRequestFormItem.MaxPartialDeliveries__c = Decimal.valueOf((String)objMap.get('MaxPartialDeliveries__c')) != null ? Decimal.valueOf((String)objMap.get('MaxPartialDeliveries__c')) : null;
                    // mRequestFormItem.TransportationZone__c = salesArea.TransportationZone__c;
                    mRequestFormItem.PartialDeliveriesperitem__c = String.valueOf(objMap.get('PartialDeliveriesperitem__c'));
                    mRequestFormItem.UnderdeliveryTolerance__c = Decimal.valueOf((String)objMap.get('UnderdeliveryTolerance__c'));
                    mRequestFormItem.OverdeliveryTolerance__c = Decimal.valueOf((String)objMap.get('OverdeliveryTolerance__c'));
                    mRequestFormItem.AccountAssignmentGroup__c = String.valueOf(objMap.get('AccountAssignmentGroup__c'));
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
            } else { // edit from item detail screen
                    System.debug('Debug existing item id '+mItemId);
                    CTRRequestFormItem__c mRequestFormItem = [SELECT Id,CTRRequestFormHeader__c,SalesDistrict__c,DeliveryPriority__c,ShippingConditions__c,DeliveryPlant__c,MaxPartialDeliveries__c,PartialDeliveriesperitem__c,UnderdeliveryTolerance__c,OverdeliveryTolerance__c,AccountAssignmentGroup__c FROM CTRRequestFormItem__c WHERE Id =: mItemId];

                    // CTRRequestFormHeader__c mRequestFormHeader = [SELECT Id FROM CTRRequestFormHeader__c WHERE Id =: mRequestFormItem.CTRRequestFormHeader__c];
                    CTRRequestFormHeader__c mRequestFormHeader = new CTRRequestFormHeader__c();


                    mRequestFormHeader.Id = mRequestFormItem.CTRRequestFormHeader__c;
                    mRequestFormHeader.CompanyNameENF__c = String.valueOf(objMap.get('CompanyNameENF__c'));
                    mRequestFormHeader.CustomerNameLocal1__c = String.valueOf(objMap.get('CustomerNameLocal1__c'));
                    mRequestFormHeader.Country__c = String.valueOf(objMap.get('Country__c'));
                    mRequestFormHeader.TaxCode1__c = String.valueOf(objMap.get('TaxCode1__c'));
                    mRequestFormHeader.CustomerSearchTermEN__c = String.valueOf(objMap.get('CustomerSearchTermEN__c'));
                    mRequestFormHeader.CustomerSearchTermLocal__c = String.valueOf(objMap.get('CustomerSearchTermLocal__c'));
                    mRequestFormHeader.HousenoLocal__c = String.valueOf(objMap.get('HousenoLocal__c'));
                    mRequestFormHeader.BuildingCodeLocal__c = String.valueOf(objMap.get('BuildingCodeLocal__c'));
                    mRequestFormHeader.RoomLocal__c = String.valueOf(objMap.get('RoomLocal__c'));
                    mRequestFormHeader.FloorLocal__c = String.valueOf(objMap.get('FloorLocal__c'));
                    mRequestFormHeader.CoName__c = String.valueOf(objMap.get('CoName__c'));
                    mRequestFormHeader.StreetLocal__c = String.valueOf(objMap.get('StreetLocal__c'));
                    mRequestFormHeader.SubDistrictLocalText__c = String.valueOf(objMap.get('SubDistrictLocalText__c'));
                    mRequestFormHeader.DistrictLocalText__c = String.valueOf(objMap.get('DistrictLocalText__c'));
                    mRequestFormHeader.CityStateLocal__c = String.valueOf(objMap.get('CityStateLocal__c'));
                    mRequestFormHeader.PostalCodeLocalText__c = String.valueOf(objMap.get('PostalCodeLocalText__c'));
                    mRequestFormHeader.LocationInGoogleMapsLinks__c = String.valueOf(objMap.get('LocationInGoogleMapsLinks__c'));
                    mRequestFormHeader.LocationInGoogleMapsGeolocation__Latitude__s = Decimal.valueOf(String.valueOf(objMap.get('LocationInGoogleMapsGeolocation__Latitude__s')));
                    mRequestFormHeader.LocationInGoogleMapsGeolocation__Longitude__s = Decimal.valueOf(String.valueOf(objMap.get('LocationInGoogleMapsGeolocation__Longitude__s')));
                    mRequestFormHeader.ContactSalutation__c = String.valueOf(objMap.get('ContactSalutation__c'));
                    mRequestFormHeader.Nickname__c = String.valueOf(objMap.get('Nickname__c'));
                    mRequestFormHeader.FirstName__c = String.valueOf(objMap.get('FirstName__c'));
                    mRequestFormHeader.LastName__c = String.valueOf(objMap.get('LastName__c'));
                    mRequestFormHeader.Position__c = String.valueOf(objMap.get('Position__c'));
                    mRequestFormHeader.Email__c = String.valueOf(objMap.get('Email__c'));
                    mRequestFormHeader.MobileCountryCode__c = String.valueOf(objMap.get('MobileCountryCode__c'));
                    mRequestFormHeader.CountryCode__c = String.valueOf(objMap.get('CountryCode__c'));
                    mRequestFormHeader.MobilePhone__c = String.valueOf(objMap.get('MobilePhone__c'));
                    mRequestFormHeader.PhoneCountryCode__c = String.valueOf(objMap.get('PhoneCountryCode__c'));
                    mRequestFormHeader.Phone__c = String.valueOf(objMap.get('Phone__c'));
                    mRequestFormHeader.FaxCountryCode__c = String.valueOf(objMap.get('FaxCountryCode__c'));
                    mRequestFormHeader.Fax__c = String.valueOf(objMap.get('Fax__c'));
                    mRequestFormHeader.TransportationZone__c = String.valueOf(objMap.get('TransportationZone__c')); 
                    mRequestFormHeader.InternalEditField__c = objMap.get('HeaderInternalEditField') != null ? String.valueOf(objMap.get('HeaderInternalEditField')) : null; 
                    mRequestFormHeader.TAXClassification__c = String.valueOf(objMap.get('TAXClassification__c'));
                
                    // CTRRequestFormItem__c mRequestFormItem = new CTRRequestFormItem__c();
                    // mRequestFormItem.CTRRequestFormHeader__c = mRequestFormHeader.Id;
                    // mRequestFormItem.Customer__c = customerId;
                    // mRequestFormItem.RecordTypeId = itemRecordTypeId;
                    // mRequestFormItem.Status__c = 'New';
                    // mRequestFormItem.Approval_Step__c = 'Open';
                    // mRequestFormItem.Sensitive__c = true;
                    mRequestFormItem.SalesDistrict__c = String.valueOf(objMap.get('SalesDistrict__c'));
                    mRequestFormItem.DeliveryPriority__c = String.valueOf(objMap.get('DeliveryPriority__c'));
                    mRequestFormItem.ShippingConditions__c = String.valueOf(objMap.get('ShippingConditions__c'));
                    mRequestFormItem.DeliveryPlant__c = String.valueOf(objMap.get('DeliveryPlant__c'));
                    mRequestFormItem.MaxPartialDeliveries__c = Decimal.valueOf((String)objMap.get('MaxPartialDeliveries__c')) != null ? Decimal.valueOf((String)objMap.get('MaxPartialDeliveries__c')) : null;
                    mRequestFormItem.PartialDeliveriesperitem__c = String.valueOf(objMap.get('PartialDeliveriesperitem__c'));
                    mRequestFormItem.UnderdeliveryTolerance__c = Decimal.valueOf((String)objMap.get('UnderdeliveryTolerance__c'));
                    mRequestFormItem.OverdeliveryTolerance__c = Decimal.valueOf((String)objMap.get('OverdeliveryTolerance__c'));
                    mRequestFormItem.AccountAssignmentGroup__c = String.valueOf(objMap.get('AccountAssignmentGroup__c'));
                    mRequestFormItem.InternalEditField__c = objMap.get('ItemInternalEditField') != null ? String.valueOf(objMap.get('ItemInternalEditField')) : null; 

                    update mRequestFormHeader;
                    update mRequestFormItem;

                    responseResult.result = true;
                    responseResult.message = 'Success';
                    responseResult.resRecordId = mRequestFormItem.Id;
            }
            
            return responseResult;
        }
        catch(Exception e)
        {
            String mError = 'CTRRequestShipToController.saveRequesShipTo Line:'+e.getmessage()+' line:'+e.getLineNumber();
            System.debug('CTRRequestShipToController.saveRequesShipTo'+e.getmessage()+' line:'+e.getLineNumber());      
            responseResult.message = e.getmessage();      
            return responseResult;
        }
    }
    
    public class DefaultDataWrapper {
        @AuraEnabled public CTRRequestFormHeader__c mRequestHeader {get; set;}
        @AuraEnabled public CTRRequestFormItem__c mRequestItem {get; set;} 
    }
    
    @AuraEnabled
    public static DefaultDataWrapper getDefaultItem(Id mItemId)
    {
        try 
        {
            CTRRequestFormItem__c responseItem = [SELECT Id, CTRRequestFormHeader__c, Name, Customer__c, Customer__r.Country__c, Customer__r.Country__r.Description__c, SalesOrganizationTX__c, Division__c, DistributionChannel__c, toLabel(SalesOrganizationTX__c) salesOrgLabel, toLabel(Division__c) divisionLabel, toLabel(DistributionChannel__c) distChLabel, InternalEditField__c FROM CTRRequestFormItem__c WHERE Id =: mItemId LIMIT 1];

            CTRRequestFormHeader__c responseHeader = [SELECT Id,InternalEditField__c  FROM CTRRequestFormHeader__c WHERE Id =: responseItem.CTRRequestFormHeader__c LIMIT 1];

            DefaultDataWrapper response = new DefaultDataWrapper();
            response.mRequestHeader = responseHeader;
            response.mRequestItem = responseItem;

            return response;
        } 
        catch (Exception e) 
        {
            System.debug('Error From CTRRequestShipToController.getDefaultItem Line: '+e.getLineNumber()+' || Message:'+e.getMessage());
            return null;
        }
    }
}