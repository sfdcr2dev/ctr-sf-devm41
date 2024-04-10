public with sharing class CTRRequestItemIntegrationEditController 
{
    public class mapLv1
    {
        mapLv2 input{get; set;}
    }

    public class mapLv2
    {
        Map<String,Object> input{get; set;}
    }

    public static mapLv1 SetupJsonForCTRDataModel (List<CTRIntegrationMapping__mdt> mAllMappingList, CTRRequestFormHeader__c mRequestHeader, CTRRequestFormItem__c mRequestItem, String mSendType, String mBusinessUnit, String mGatewayId)
    {
        mapLv1 ctrData = new mapLv1();
        //mSendType = 'Customer'; //Mock
        String mChangeFieldHeader = mRequestHeader.InternalEditField__c;
        String mChangeFieldItem = mRequestItem.InternalEditField__c;
        //List<CTRIntegrationMapping__mdt> mAllMappingList = [SELECT Id, BusinessUnit__c, IntegrationType__c, JsonMapping__c, RecordType__c, ViewName__c FROM CTRIntegrationMapping__mdt];
        Map<String,List<changedFieldWrapper>> mMapingChangeFieldMap = new Map<String, List<changedFieldWrapper>>(); 
        for(CTRIntegrationMapping__mdt mMap :mAllMappingList)
        {
            if(mMap.BusinessUnit__c == mBusinessUnit && mMap.RecordType__c == mSendType && mMap.IntegrationType__c == 'Edit')
            {
                //List<changedFieldWrapper> mIntegrationFieldList = convertJsonToObj(mMap.JsonMapping__c,'IntegrationField');
                List<changedFieldWrapper> mChangeFieldList = new List<changedFieldWrapper>();
                    List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mMap.JsonMapping__c);

                    for(Object mFieldData : mFieldList)
                    {    
                        Map<String,Object> mField = (Map<String,Object>)mFieldData;
                        changedFieldWrapper mChangeField = new changedFieldWrapper();
                        mChangeField.mLevel = (String)mField.get('Level');
                        mChangeField.mLabel = (String)mField.get('Label');
                        mChangeField.mApi = (String)mField.get('Api');
                        mChangeFieldList.add(mChangeField);
                    }
                mMapingChangeFieldMap.put(mMap.ViewName__c, mChangeFieldList);
            }
        }


        List<changedFieldWrapper> mHeaderChangeFieldList = new List<changedFieldWrapper>();
        if(String.isNotBlank(mChangeFieldHeader))
        {
            List<Object> mHeaderFieldList = (List<Object>)JSON.deserializeUntyped(mChangeFieldHeader);
            for(Object mFieldData : mHeaderFieldList)
            {    
                Map<String,Object> mField = (Map<String,Object>)mFieldData;
                changedFieldWrapper mChangeField = new changedFieldWrapper();
                mChangeField.mValue = (String)mField.get('Value');
                mChangeField.mLabel = (String)mField.get('Label');
                mChangeField.mApi = (String)mField.get('Api');
                mHeaderChangeFieldList.add(mChangeField);
            }
            System.debug('mHeaderChangeFieldList:'+mHeaderChangeFieldList);
        }

        //(List<changedFieldWrapper>)convertJsonToObj(mChangeFieldHeader,'ChangedFieldSF');
        List<changedFieldWrapper> mItemChangeFieldList = new List<changedFieldWrapper>();
        //(List<changedFieldWrapper>)convertJsonToObj(mChangeFieldItem,'ChangedFieldSF');
        if(String.isNotBlank(mChangeFieldItem))
        {
            List<Object> mItemFieldList = (List<Object>)JSON.deserializeUntyped(mChangeFieldItem);
            for(Object mFieldData : mItemFieldList)
            {    
                Map<String,Object> mField = (Map<String,Object>)mFieldData;
                changedFieldWrapper mChangeField = new changedFieldWrapper();
                mChangeField.mValue = (String)mField.get('Value');
                mChangeField.mLabel = (String)mField.get('Label');
                mChangeField.mApi = (String)mField.get('Api');
                mItemChangeFieldList.add(mChangeField);
            }
            System.debug('mItemChangeFieldList:'+mItemChangeFieldList);
        }

        if(mHeaderChangeFieldList.size()>0 || mItemChangeFieldList.size()>0)
        {
            String mRecordTypeName = mRequestItem.RecordType.DeveloperName;
            String uuid = mGatewayId;//(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
            String mMainFlag = 'U';
            String SalesOrganization = mRequestItem.SalesOrganization__c !=null ? mRequestItem.SalesOrganization__c: '';
            String DistributionChannel = mRequestItem.DistributionChannel__c !=null ? mRequestItem.DistributionChannel__c: '';
            String Division = mRequestItem.Division__c !=null ? mRequestItem.Division__c: '';
    
    
            mapLv2 inputModel = new mapLv2();
            Map<String,Object> subInputModel = new Map<String,Object>();
    
            List<Map<String,String>> centralDataModelList = new List<Map<String,String>>();
            List<Map<String,String>> addressGenModelList = new List<Map<String,String>>();
            List<Map<String,String>> addressIntModelList = new List<Map<String,String>>();
            List<Map<String,String>> salesDataModelList = new List<Map<String,String>>();
            List<Map<String,String>> taxClassificationModelList = new List<Map<String,String>>();
            List<Map<String,String>> companyCodeViewModelList = new List<Map<String,String>>();
            List<Map<String,String>> withHoldingTaxViewModelList = new List<Map<String,String>>();
    
            Map<String,String> centralDataModel = new Map<String,String>();
            Map<String,String> addressGenModel = new Map<String,String>();
           
            Map<String,String> salesDataModel = new Map<String,String>();
            Map<String,String> taxClassificationModel = new Map<String,String>();
            Map<String,String> companyCodeViewModel = new Map<String,String>();
    
    
    
            //Central Data
            for(changedFieldWrapper mHeaderChange: mHeaderChangeFieldList)
            {
                List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('CentralData');
                if(mIntegrationFieldMappingList.size()>0)
                {
                    for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                    {
                        if(mIntegrationChange.mApi == mHeaderChange.mApi)
                        {
                            mHeaderChange.mValue = (mHeaderChange.mValue =='true')?'X':mHeaderChange.mValue;
                            mHeaderChange.mValue = (mHeaderChange.mValue =='false')?'':mHeaderChange.mValue;
                            centralDataModel.put(mIntegrationChange.mLabel, mHeaderChange.mValue);
                        }
                    }
                }
            }
            if(centralDataModel.size()>0)
            {
                centralDataModelList.add(centralDataModel);
                System.debug('centralDataModelList: '+centralDataModelList);
            }
            
            //Address Gen
            for(changedFieldWrapper mHeaderChange: mHeaderChangeFieldList)
            {
                List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('AddressGen');
                if(mIntegrationFieldMappingList.size()>0)
                {
                    for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                    {
                        if(mIntegrationChange.mApi == mHeaderChange.mApi)
                        {
                            mHeaderChange.mValue = (mHeaderChange.mValue =='true')?'X':mHeaderChange.mValue;
                            mHeaderChange.mValue = (mHeaderChange.mValue =='false')?'':mHeaderChange.mValue;
                            addressGenModel.put(mIntegrationChange.mLabel, mHeaderChange.mValue);
                        }
                    }
                }
            }
            if(addressGenModel.size()>0)
            {
                addressGenModel.put('Type','I');
                addressGenModel.put('Flag','U');
                addressGenModelList.add(addressGenModel);
                System.debug('addressGenModelList: '+addressGenModelList);
            }

    
            //Address Int
            List<String> typeListAddressInt = new List<String>{'I','T'};
            for(String typeAddressInt: typeListAddressInt)
            {
                Map<String,String> addressIntModel = new Map<String,String>();
                for(changedFieldWrapper mHeaderChange: mHeaderChangeFieldList)
                {
                    List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('AddressInt '+typeAddressInt);
                    if(mIntegrationFieldMappingList.size()>0)
                    {
                        for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                        {
                            if(mIntegrationChange.mApi == mHeaderChange.mApi)
                            {
                                mHeaderChange.mValue = (mHeaderChange.mValue =='true')?'X':mHeaderChange.mValue;
                                mHeaderChange.mValue = (mHeaderChange.mValue =='false')?'':mHeaderChange.mValue;
                                addressIntModel.put(mIntegrationChange.mLabel, mHeaderChange.mValue);
                            }
                        }
                    }
                }
                if(addressIntModel.size()>0)
                {
                    addressIntModel.put('Type',typeAddressInt);
                    addressIntModel.put('Flag','U');
                    addressIntModelList.add(addressIntModel);
                }
            }
    
    
            if(mSendType == 'Customer' || mSendType == 'ShipTo')
            {
                // TaxClassificationModel
                for(changedFieldWrapper mHeaderChange: mHeaderChangeFieldList)
                {
                    List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('TaxClassification');
                    if(mIntegrationFieldMappingList.size()>0)
                    {
                        for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                        {
                            if(mIntegrationChange.mApi == mHeaderChange.mApi)
                            {
                                mHeaderChange.mValue = (mHeaderChange.mValue =='true')?'X':mHeaderChange.mValue;
                                mHeaderChange.mValue = (mHeaderChange.mValue =='false')?'':mHeaderChange.mValue;
                                taxClassificationModel.put(mIntegrationChange.mLabel, mHeaderChange.mValue);
                            }
                        }
                    }
                }
                if(taxClassificationModel.size()>0)
                {
                    taxClassificationModel.put('Task', 'U');
                    taxClassificationModel.put('Flag','U');
                    taxClassificationModelList.add(taxClassificationModel);
                }
    
                 // SalesDataModel
                 for(changedFieldWrapper mItemChange: mItemChangeFieldList)
                {
                    List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('SalesData');
                    if(mIntegrationFieldMappingList.size()>0)
                    {
                        for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                        {
                            if(mIntegrationChange.mApi == mItemChange.mApi)
                            {
                                mItemChange.mValue = (mItemChange.mValue =='true')?'X':mItemChange.mValue;
                                mItemChange.mValue = (mItemChange.mValue =='false')?'':mItemChange.mValue;
                                salesDataModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
                            }
                        }
                    }
                }
                if(salesDataModel.size()>0)
                {
                    salesDataModel.put('CreditControlArea', mRequestItem.CreditControlArea__c);
                    salesDataModel.put('Task', 'U');
                    salesDataModel.put('Flag','U');
                    salesDataModelList.add(salesDataModel);
                }
    
                if(mBusinessUnit == 'TX')
                {
                    // CompanyCodeViewModel
                    for(changedFieldWrapper mItemChange: mItemChangeFieldList)
                    {
                        List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('CompanyCodeView');
                        if(mIntegrationFieldMappingList.size()>0)
                        {
                            for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                            {
                                if(mIntegrationChange.mApi == mItemChange.mApi)
                                {
                                    mItemChange.mValue = (mItemChange.mValue =='true')?'X':mItemChange.mValue;
                                    mItemChange.mValue = (mItemChange.mValue =='false')?'':mItemChange.mValue;
                                    companyCodeViewModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
                                }
                            }
                        }
                    }
                    if(companyCodeViewModel.size()>0)
                    {
                        companyCodeViewModel.put('CompanyCode', SalesOrganization);
                        companyCodeViewModel.put('Task', 'U');
                        companyCodeViewModel.put('Flag','U');
                        companyCodeViewModelList.add(companyCodeViewModel);
                    }
                }
            }

            if(mSendType == 'Supplier')
            {
               //Purchasing view
               for(changedFieldWrapper mItemChange: mItemChangeFieldList)
               {
                    if(mMapingChangeFieldMap.containsKey('SalesData')) 
                    {
                        List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('SalesData');
                        if(mIntegrationFieldMappingList.size()>0)
                        {
                            for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                            {
                                if(mIntegrationChange.mApi == mItemChange.mApi)
                                {
                                        mItemChange.mValue = (mItemChange.mValue =='true')?'X':mItemChange.mValue;
                                        mItemChange.mValue = (mItemChange.mValue =='false')?'':mItemChange.mValue;
                                        salesDataModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
                                }
                            }
                        }
                    }
               }
               if(salesDataModel.size()>0)
               {
                    salesDataModel.put('PurchasingOrg', mRequestItem.PurchasingOrganization__c);
                   salesDataModel.put('Task', 'U');
                   salesDataModel.put('Flag','U');
                   salesDataModelList.add(salesDataModel);
               }
    
                // CompanyCodeViewModel
                for(changedFieldWrapper mItemChange: mItemChangeFieldList)
                {
                    List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('CompanyCodeView');
                    if(mIntegrationFieldMappingList.size()>0)
                    {
                        for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                        {
                            if(mIntegrationChange.mApi == mItemChange.mApi)
                            {
                                mItemChange.mValue = (mItemChange.mValue =='true')?'X':mItemChange.mValue;
                                mItemChange.mValue = (mItemChange.mValue =='false')?'':mItemChange.mValue;
                                companyCodeViewModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
                            }
                        }
                    }
                }
                if(companyCodeViewModel.size()>0)
                {
                    companyCodeViewModel.put('CompanyCode', SalesOrganization);
                    companyCodeViewModel.put('Task', 'U');
                    companyCodeViewModel.put('Flag','U');
                    companyCodeViewModelList.add(companyCodeViewModel);
                }
    
                if(mBusinessUnit == 'TX')
                {
                    Map<String,String> withHoldingTax1ViewModel = new Map<String,String>();
                    Map<String,String> withHoldingTax2ViewModel = new Map<String,String>();
                    for(changedFieldWrapper mItemChange: mItemChangeFieldList)
                    {
                        List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('WithHoldingTax');
                        if(mIntegrationFieldMappingList.size()>0)
                        {
                            for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                            {
                                if(mIntegrationChange.mApi == mItemChange.mApi)
                                {
                                    mItemChange.mValue = (mItemChange.mValue =='true')?'X':mItemChange.mValue;
                                    mItemChange.mValue = (mItemChange.mValue =='false')?'':mItemChange.mValue;
                                    if(mItemChange.mApi.contains('1'))
                                    {
                                        withHoldingTax1ViewModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
                                    }
                                    if(mItemChange.mApi.contains('2'))
                                    {
                                        withHoldingTax2ViewModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
                                    }
                                }
                            }
                        }
                    }
                    if(withHoldingTax1ViewModel.size()>0)
                    {
                        withHoldingTax1ViewModel.put('TaxType','J1');
                        withHoldingTax1ViewModel.put('Subject','X');
                        withHoldingTax1ViewModel.put('Task','U');
                        withHoldingTaxViewModelList.add(withHoldingTax1ViewModel);
                    }
                    if(withHoldingTax2ViewModel.size()>0)
                    {
                        withHoldingTax2ViewModel.put('TaxType','J2');
                        withHoldingTax2ViewModel.put('Subject','X');
                        withHoldingTax2ViewModel.put('Task','U');
                        withHoldingTaxViewModelList.add(withHoldingTax2ViewModel);
                    }
                    
                }
            }
            String mRecordType = (mRequestItem.RecordType.DeveloperName.contains('ShipTo'))?'ShipTo':'SoldTo';
            String mSAPCode = mRequestItem.Customer__r.AccountNumber__c !=null ? mRequestItem.Customer__r.AccountNumber__c: '';
            if(mSendType == 'Supplier')
            {
                mSAPCode = mRequestItem.Customer__r.SupplierNumber__c !=null ? mRequestItem.Customer__r.SupplierNumber__c: '';
            }

            
    
            //Requeired Important
            subInputModel.put('SalesOrganization',  SalesOrganization); 
            subInputModel.put('CompanyCode',  SalesOrganization); 
            subInputModel.put('DistributionChannel', DistributionChannel); 
            subInputModel.put('Division',  Division); 
            subInputModel.put('RecordType', mRecordType);
            subInputModel.put('Id',  mRequestItem.Customer__c !=null ? mRequestItem.Customer__c: '');   
            subInputModel.put('ReferenceId', mRequestItem.Id);
            subInputModel.put('AccountNumber',  mSAPCode); 
            subInputModel.put('GatewayId', mGatewayId);
            subInputModel.put('Flag', mMainFlag);
            
    
            //input ListData
            subInputModel.put('CentralData', centralDataModelList);
            subInputModel.put('AddressGen', addressGenModelList);
            subInputModel.put('AddressInt', addressIntModelList);
            subInputModel.put('TaxClassification', taxClassificationModelList);
            subInputModel.put('CompanyCodeView', companyCodeViewModelList);

            if(mSendType == 'Customer' || mSendType == 'ShipTo')
            {
                subInputModel.put('SalesData', salesDataModelList);
            }
            else if(mSendType == 'Supplier')
            {
                subInputModel.put('PurchasingView', salesDataModelList);
                subInputModel.put('WithHoldingTax', withHoldingTaxViewModelList);
                
            }

    
            inputModel.input = subInputModel;
            ctrData.input = inputModel;
        }
        return ctrData;
    }

    public class changedFieldWrapper
    {
        public String mLevel {get;set;}
        public String mLabel {get;set;}
        public String mApi {get;set;}
        public String mValue {get;set;}
    }




    //to support Extend and Edit include update 2 saperate customer/ supplier
    public static mapLv1 SetupJsonForCTRDataModelv2 (List<CTRIntegrationMapping__mdt> mAllMappingList, CTRRequestFormHeader__c mRequestHeader, CTRRequestFormItem__c mRequestItem, 
                                                    String RecordTypeShort, String mBusinessUnit, String mGatewayId, String IntegrationType, Boolean isMain)
    {
        mapLv1 ctrData = new mapLv1();
        //mSendType = 'Customer'; //Mock
        String mChangeFieldHeader = (String.isNotBlank(mRequestHeader.InternalEditField__c))?mRequestHeader.InternalEditField__c:'[]';
        String mChangeFieldItem = (String.isNotBlank(mRequestItem.InternalEditField__c))?mRequestItem.InternalEditField__c:'[]';
        //List<CTRIntegrationMapping__mdt> mAllMappingList = [SELECT Id, BusinessUnit__c, IntegrationType__c, JsonMapping__c, RecordType__c, ViewName__c, SupportIntegrationType__c FROM CTRIntegrationMapping__mdt];
        
        Map<String,List<changedFieldWrapper>> mMapingChangeFieldMap = new Map<String, List<changedFieldWrapper>>(); 
        for(CTRIntegrationMapping__mdt mMap :mAllMappingList)
        {
            if(mMap.BusinessUnit__c == mBusinessUnit && mMap.RecordType__c == RecordTypeShort && mMap.SupportIntegrationType__c.contains(IntegrationType))
            {
                //List<changedFieldWrapper> mIntegrationFieldList = convertJsonToObj(mMap.JsonMapping__c,'IntegrationField');
                List<changedFieldWrapper> mChangeFieldList = new List<changedFieldWrapper>();
                    List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mMap.JsonMapping__c);

                    for(Object mFieldData : mFieldList)
                    {    
                        Map<String,Object> mField = (Map<String,Object>)mFieldData;
                        changedFieldWrapper mChangeField = new changedFieldWrapper();
                        mChangeField.mLevel = (String)mField.get('Level');
                        mChangeField.mLabel = (String)mField.get('Label');
                        mChangeField.mApi = (String)mField.get('Api');
                        mChangeFieldList.add(mChangeField);
                    }
                mMapingChangeFieldMap.put(mMap.ViewName__c, mChangeFieldList);
            }
        }
        String mMainFlag = 'U';
        //Header Json converted to Obj
        List<changedFieldWrapper> mHeaderChangeFieldList = new List<changedFieldWrapper>();
        if(IntegrationType == 'Extend' && ((RecordTypeShort == 'Customer' && mRequestItem.Customer__r.AccountNumber__c == null) || 
            (RecordTypeShort == 'Supplier') && mRequestItem.Customer__r.SupplierNumber__c == null))
        {
            mMainFlag = 'I';
        }

        if(String.isNotBlank(mChangeFieldHeader))
        {
            List<Object> mHeaderFieldList = (List<Object>)JSON.deserializeUntyped(mChangeFieldHeader);
            for(Object mFieldData : mHeaderFieldList)
            {    
                Map<String,Object> mField = (Map<String,Object>)mFieldData;
                changedFieldWrapper mChangeField = new changedFieldWrapper();
                mChangeField.mValue = (String)mField.get('Value');
                mChangeField.mLabel = (String)mField.get('Label');
                mChangeField.mApi = (String)mField.get('Api');
                mHeaderChangeFieldList.add(mChangeField);
            }
            System.debug('mHeaderChangeFieldList:'+mHeaderChangeFieldList);
        }

        //Item Json converted to Obj
        List<changedFieldWrapper> mItemChangeFieldList = new List<changedFieldWrapper>();
        if(String.isNotBlank(mChangeFieldItem))
        {
            List<Object> mItemFieldList = (List<Object>)JSON.deserializeUntyped(mChangeFieldItem);
            for(Object mFieldData : mItemFieldList)
            {    
                Map<String,Object> mField = (Map<String,Object>)mFieldData;
                changedFieldWrapper mChangeField = new changedFieldWrapper();
                mChangeField.mValue = (String)mField.get('Value');
                mChangeField.mLabel = (String)mField.get('Label');
                mChangeField.mApi = (String)mField.get('Api');
                mItemChangeFieldList.add(mChangeField);
            }
            System.debug('mItemChangeFieldList:'+mItemChangeFieldList);
        }

        if(mHeaderChangeFieldList.size()>0 || mItemChangeFieldList.size()>0)
        {
            String mRecordTypeName = mRequestItem.RecordType.DeveloperName;
            String uuid = mGatewayId;//(mRequestItem.GatewayId__c!= null)?mRequestItem.GatewayId__c:Uuid.randomUUID();
           
            String SalesOrganization = '';
            String DistributionChannel = mRequestItem.DistributionChannel__c !=null ? mRequestItem.DistributionChannel__c: '';
            String Division = mRequestItem.Division__c !=null ? mRequestItem.Division__c: '';
            String mCountry = mRequestHeader.Country__r.Code__c!=null? mRequestHeader.Country__r.Code__c:'';

            if(RecordTypeShort == 'Supplier')
            {
                SalesOrganization = (mBusinessUnit == 'TX')? mRequestItem.CompanyCodeTX__c: mRequestItem.CompanyCodeTOP__c;
                if(!isMain)
                {
                    SalesOrganization = mRequestItem.SalesOrganization__c !=null ? mRequestItem.SalesOrganization__c: '';
                }
            }
            else
            {
                SalesOrganization = mRequestItem.SalesOrganization__c !=null ? mRequestItem.SalesOrganization__c: '';
                if(!isMain)
                {
                    SalesOrganization = (mBusinessUnit == 'TX')? mRequestItem.CompanyCodeTX__c: mRequestItem.CompanyCodeTOP__c;
                }
            }
    
            mapLv2 inputModel = new mapLv2();
            Map<String,Object> subInputModel = new Map<String,Object>();
    
            List<Map<String,String>> centralDataModelList = new List<Map<String,String>>();
            List<Map<String,String>> addressGenModelList = new List<Map<String,String>>();
            List<Map<String,String>> addressIntModelList = new List<Map<String,String>>();
            List<Map<String,String>> salesDataModelList = new List<Map<String,String>>();
            List<Map<String,String>> taxClassificationModelList = new List<Map<String,String>>();
            List<Map<String,String>> companyCodeViewModelList = new List<Map<String,String>>();
            List<Map<String,String>> withHoldingTaxViewModelList = new List<Map<String,String>>();
    
            Map<String,String> centralDataModel = new Map<String,String>();
            Map<String,String> addressGenModel = new Map<String,String>();
           
            Map<String,String> salesDataModel = new Map<String,String>();
            Map<String,String> taxClassificationModel = new Map<String,String>();
            Map<String,String> companyCodeViewModel = new Map<String,String>();
    
    
    
            //Central Data
            centralDataModel = manageEditJsonMappingForIntegration(mHeaderChangeFieldList, mMapingChangeFieldMap, 'CentralData');
            if(centralDataModel.size()>0)
            {
                centralDataModelList.add(centralDataModel);
            }
            
            //Address Gen
            addressGenModel = manageEditJsonMappingForIntegration(mHeaderChangeFieldList, mMapingChangeFieldMap, 'AddressGen');
            if(addressGenModel.size()>0)
            {
                addressGenModel.put('Type','I');
                addressGenModel.put('Flag','U');
                addressGenModelList.add(addressGenModel);
            }

    
            //Address Int
            List<String> typeListAddressInt = new List<String>{'I','T'};
            for(String typeAddressInt: typeListAddressInt)
            {
                Map<String,String> addressIntModel = new Map<String,String>();
                addressIntModel = manageEditJsonMappingForIntegration(mHeaderChangeFieldList, mMapingChangeFieldMap, 'AddressInt '+typeAddressInt);
                if(addressIntModel.size()>0)
                {
                    addressIntModel.put('Type',typeAddressInt);
                    addressIntModel.put('Flag','U');
                    addressIntModelList.add(addressIntModel);
                }
            }
    
            if(isMain)
            {
                if(RecordTypeShort == 'Customer' || RecordTypeShort == 'ShipTo')
                {
                    if(IntegrationType == 'Edit')
                    {
                        // TaxClassificationModel
                        taxClassificationModel = manageEditJsonMappingForIntegration(mHeaderChangeFieldList, mMapingChangeFieldMap, 'TaxClassification');
                        if(taxClassificationModel.size()>0)
                        {
                            taxClassificationModel.put('Task', 'U');
                            taxClassificationModel.put('Flag','U');
                            taxClassificationModelList.add(taxClassificationModel);
                        }
            
                        // SalesDataModel
                        salesDataModel = manageEditJsonMappingForIntegration(mItemChangeFieldList, mMapingChangeFieldMap, 'SalesData');
                        if(salesDataModel.size()>0)
                        {
                            salesDataModel.put('CreditControlArea', mRequestItem.CreditControlArea__c);
                            salesDataModel.put('Task', 'U');
                            salesDataModel.put('Flag','U');
                            salesDataModelList.add(salesDataModel);
                        }
            
                        if(mBusinessUnit == 'TX')
                        {
                            // CompanyCodeViewModel
                            companyCodeViewModel = manageEditJsonMappingForIntegration(mItemChangeFieldList, mMapingChangeFieldMap, 'CompanyCodeView');
                            if(companyCodeViewModel.size()>0)
                            {
                                
                                companyCodeViewModel.put('CompanyCode', SalesOrganization);
                                companyCodeViewModel.put('Task', 'U');
                                companyCodeViewModel.put('Flag','U');
                                companyCodeViewModelList.add(companyCodeViewModel);
                            }
                        }
                    }
                    else if(IntegrationType == 'Extend')
                    {
                        // SalesDataModel
                        salesDataModel.put('Task', 'I');
                        salesDataModel.put('Currencies', mRequestItem.Currency__c !=null ? mRequestItem.Currency__c: '');
                        salesDataModel.put('Incoterms',mRequestItem.Incoterms__c !=null ? mRequestItem.Incoterms__c: '');
                        salesDataModel.put('Incoterms2', mRequestItem.Incoterms2__c !=null ? mRequestItem.Incoterms2__c: '-');
                        salesDataModel.put('AccountAssignmentGroup', mRequestItem.AccountAssignmentGroup__c !=null ? mRequestItem.AccountAssignmentGroup__c: '');
                        salesDataModel.put('CustomerPayment', mRequestItem.PaymentGuaranteeProcedure__c !=null ? mRequestItem.PaymentGuaranteeProcedure__c: '');
                        salesDataModel.put('MaxPartialDeliveries', mRequestItem.MaxPartialDeliveries__c !=null ? String.valueOf(mRequestItem.MaxPartialDeliveries__c):'0');
                        salesDataModel.put('UnderDeliveryTole', mRequestItem.UnderdeliveryTolerance__c !=null ? String.valueOf(mRequestItem.UnderdeliveryTolerance__c):'0');
                        salesDataModel.put('OverDeliveryTole', mRequestItem.OverdeliveryTolerance__c !=null ? String.valueOf(mRequestItem.OverdeliveryTolerance__c):'0');
                        salesDataModel.put('PriceGroup', mRequestItem.PriceGroup__c !=null ? mRequestItem.PriceGroup__c:'');
                        salesDataModel.put('CreditControlArea', mRequestItem.CreditControlArea__c !=null ? mRequestItem.CreditControlArea__c: '');

                        if(mBusinessUnit == 'TX')
                        {
                            salesDataModel.put('SalesDistrict', mRequestItem.SalesDistrict__c !=null ? mRequestItem.SalesDistrict__c:'');
                            salesDataModel.put('SalesOffice', mRequestItem.SalesOffice__c !=null ? mRequestItem.SalesOffice__c:'');
                            salesDataModel.put('SalesGroup', mRequestItem.SalesGroup__c !=null ? mRequestItem.SalesGroup__c:'');
                            salesDataModel.put('OrderProbability', String.valueOf(mRequestItem.OrderProbability__c));
                            salesDataModel.put('ExchRateType', mRequestItem.ExchangeRateType__c !=null ? mRequestItem.ExchangeRateType__c:'');
                            salesDataModel.put('CustPricingProcedure', String.valueOf(mRequestItem.CustPriceProc__c) !=null ? String.valueOf(mRequestItem.CustPriceProc__c):'');
                            salesDataModel.put('CustStatisticsGroup', String.valueOf(mRequestItem.CustStatGroup__c));
                            salesDataModel.put('DeliveryPriority', mRequestItem.DeliveryPriority__c !=null ? mRequestItem.DeliveryPriority__c:'');
                            salesDataModel.put('DeliveryPlant', mRequestItem.DeliveryPlant__c !=null ? mRequestItem.DeliveryPlant__c:'');
                            salesDataModel.put('OrderCombination', mRequestItem.OrderCombination__c == true ? 'X':''); //String.valueOf(mRequestItem.OrderCombination__c);
                            salesDataModel.put('PartialDelivery', mRequestItem.PartialDeliveriesperitem__c !=null ? mRequestItem.PartialDeliveriesperitem__c:'');
                            salesDataModel.put('Rebate', mRequestItem.Rebate__c == true ? 'X':'');
                            salesDataModel.put('PriceDetermin', mRequestItem.IsPriceDetermin__c == true ? 'X':'');
                            salesDataModel.put('ShippingConditions', mRequestItem.ShippingConditions__c !=null ? mRequestItem.ShippingConditions__c:'');

                        }
                        //salesDataModel.put('RiskCategory', 'I');
                        //salesDataModel.put('CreditLimitAccount', 'I'); //ต้องแยก BAPI
                        salesDataModel.put('Block', ''); // คุยทีหลังเนื่องจากมีหลาย Value
                        salesDataModel.put('Flag', 'I');
                        salesDataModelList.add(salesDataModel);

                        if(mBusinessUnit == 'TX')
                        {
                            // CompanyCodeViewModel
                            companyCodeViewModel.put('Task', 'I');
                            companyCodeViewModel.put('SortKey', mRequestHeader.SortKey__c !=null ? mRequestHeader.SortKey__c: '');
                            companyCodeViewModel.put('ReconciliationAccount', mRequestHeader.ReconAccount__c !=null ? mRequestHeader.ReconAccount__c: '');
                            //companyCodeViewModel.put('PaymentMethods', 'I'); //TODO ในชีส ไม่มี field map
                            companyCodeViewModel.put('TermofPayment', mRequestItem.TermofPayment__r.Code__c !=null ? mRequestItem.TermofPayment__r.Code__c: '');
                            companyCodeViewModel.put('PlanningGroup', mRequestHeader.CashManagementGroup__c !=null ? mRequestHeader.CashManagementGroup__c: '');
                            companyCodeViewModel.put('PaymentHistoryRecord', mRequestItem.PaymentHistoryRecord__c == true ? 'X':'');
                            //companyCodeViewModel.put('AuthorizationGroup', mRequestHeader.Authorization__c !=null ? mRequestHeader.Authorization__c: '');
                            companyCodeViewModelList.add(companyCodeViewModel);
                        }
                    }
                    
                }
    
                if(RecordTypeShort == 'Supplier')
                {
                   //Purchasing view
                   
                    /*for(changedFieldWrapper mItemChange: mItemChangeFieldList)
                    {
                        if(mMapingChangeFieldMap.containsKey('SalesData')) 
                        {
                            List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('SalesData');
                            if(mIntegrationFieldMappingList.size()>0)
                            {
                                for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                                {
                                    if(mIntegrationChange.mApi == mItemChange.mApi)
                                    {
                                            mItemChange.mValue = (mItemChange.mValue =='true')?'X':mItemChange.mValue;
                                            mItemChange.mValue = (mItemChange.mValue =='false')?'':mItemChange.mValue;
                                            salesDataModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
                                    }
                                }
                            }
                        }
                    }*/
                    if(IntegrationType == 'Edit')
                    {
                        //Purchasing view
                        salesDataModel = manageEditJsonMappingForIntegration(mItemChangeFieldList, mMapingChangeFieldMap, 'PurchasingView');
                        if(salesDataModel.size()>0)
                        {
                            salesDataModel.put('PurchasingOrg', mRequestItem.PurchasingOrganization__c);
                            salesDataModel.put('Task', 'U');
                            salesDataModel.put('Flag','U');
                            salesDataModelList.add(salesDataModel);
                        }
                
                        if(mBusinessUnit == 'TX')
                        {
                            // CompanyCodeViewModel
                            companyCodeViewModel = manageEditJsonMappingForIntegration(mItemChangeFieldList, mMapingChangeFieldMap, 'CompanyCodeView');
                            if(companyCodeViewModel.size()>0)
                            {
                                companyCodeViewModel.put('CompanyCode', SalesOrganization);
                                if(mCountry == 'TH')
                                {
                                    companyCodeViewModel.put('WithHoldingCountry', mCountry);
                                }
                                companyCodeViewModel.put('Task', 'U');
                                companyCodeViewModel.put('Flag','U');
                                companyCodeViewModelList.add(companyCodeViewModel);
                            }
        
                            
        
                            if(mCountry == 'TH')
                            {
                                Map<String,String> withHoldingTax1ViewModel = new Map<String,String>();
                                Map<String,String> withHoldingTax2ViewModel = new Map<String,String>();
                                for(changedFieldWrapper mItemChange: mItemChangeFieldList)
                                {
                                    List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('WithHoldingTax');
                                    if(mIntegrationFieldMappingList.size()>0)
                                    {
                                        for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                                        {
                                            if(mIntegrationChange.mApi == mItemChange.mApi)
                                            {
                                                mItemChange.mValue = (mItemChange.mValue =='true')?'X':mItemChange.mValue;
                                                mItemChange.mValue = (mItemChange.mValue =='false')?'':mItemChange.mValue;
                                                if(mItemChange.mApi.contains('1'))
                                                {
                                                    withHoldingTax1ViewModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
                                                }
                                                if(mItemChange.mApi.contains('2'))
                                                {
                                                    withHoldingTax2ViewModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
                                                }
                                            }
                                        }
                                    }
                                }
                                if(withHoldingTax1ViewModel.size()>0)
                                {
                                    withHoldingTax1ViewModel.put('TaxType','J1');
                                    withHoldingTax1ViewModel.put('Subject','X');
                                    withHoldingTax1ViewModel.put('Task','U');
                                    withHoldingTaxViewModelList.add(withHoldingTax1ViewModel);
                                }
                                if(withHoldingTax2ViewModel.size()>0)
                                {
                                    withHoldingTax2ViewModel.put('TaxType','J2');
                                    withHoldingTax2ViewModel.put('Subject','X');
                                    withHoldingTax2ViewModel.put('Task','U');
                                    withHoldingTaxViewModelList.add(withHoldingTax2ViewModel);
                                }
                                
                            }
                        }
                    }
                    else if(IntegrationType == 'Extend')
                    {
                        //Purchasing data
                        salesDataModel.put('Task', 'I');
                        salesDataModel.put('Currencies', mRequestItem.Currency__c !=null ? mRequestItem.Currency__c: '');
                        salesDataModel.put('Incoterms',mRequestItem.Incoterms__c !=null ? mRequestItem.Incoterms__c: '');
                        salesDataModel.put('Incoterms2', mRequestItem.Incoterms2__c !=null ? mRequestItem.Incoterms2__c: '-');
                        salesDataModel.put('PurchasingOrg',mRequestItem.PurchasingOrganization__c !=null ? mRequestItem.PurchasingOrganization__c: '');
                        salesDataModel.put('InvoiceVerify',mRequestItem.GRBasedInvVerif__c == true ? 'X':'');
                        salesDataModel.put('VendorContact',mRequestItem.VendorName__c !=null ? mRequestItem.VendorName__c: '');
                        salesDataModel.put('VendorPhone',mRequestItem.VendorPhone__c !=null ? mRequestItem.VendorPhone__c: '');
                        salesDataModel.put('InvoiceVerify',mRequestItem.GRBasedInvVerif__c == true ? 'X':'');
                        salesDataModel.put('TermofPayment', mRequestItem.TermOfPayment__r.Code__c !=null ? mRequestItem.TermOfPayment__r.Code__c: '');
                        salesDataModel.put('ShippingConditions',  mRequestItem.ShippingConditions__c !=null ? mRequestItem.ShippingConditions__c: '');
                        salesDataModel.put('AutomaticPurchaseOrder', 'X');

                        salesDataModelList.add(salesDataModel);
                        
                        if(mBusinessUnit == 'TX')
                        {
                            // CompanyCodeViewModel
                            companyCodeViewModel.put('Task', 'I');
                            companyCodeViewModel.put('CompanyCode', mRequestHeader.SortKey__c !=null ? mRequestHeader.SortKey__c: '');
                            companyCodeViewModel.put('ReconciliationAccount', mRequestHeader.ReconAccount__c !=null ? mRequestHeader.ReconAccount__c: '');
                            companyCodeViewModel.put('PaymentMethods', mRequestItem.PaymentMethod__c !=null ? mRequestItem.PaymentMethod__c: ''); //TODO ในชีส ไม่มี field map
                            companyCodeViewModel.put('TermofPayment', mRequestItem.TermOfPayment__r.Code__c !=null ? mRequestItem.TermOfPayment__r.Code__c: ''); //อยู่บน Sales
                            companyCodeViewModel.put('AccountClerk', mRequestItem.AccigClerk__c !=null ? mRequestItem.AccigClerk__c: '');
                            companyCodeViewModel.put('CashManagementGroup', mRequestItem.CashManagementGroup__c !=null ? mRequestItem.CashManagementGroup__c: '');
                            companyCodeViewModel.put('SortKey', mRequestHeader.SortKey__c !=null ? mRequestHeader.SortKey__c: '');
                            companyCodeViewModel.put('WithHoldingCountry', mRequestItem.WHTaxCountry__c !=null ? mRequestItem.WHTaxCountry__c: '');
                            companyCodeViewModel.put('CheckDoubleInv', mRequestItem.Chkdoubleinv__c == true ? 'X':'');
                            companyCodeViewModelList.add(companyCodeViewModel);
                            
                            if(mCountry == 'TH')
                            {
                                //WithHolding Tax
                                Map<String,String> withHoldingTax1ViewModel = new Map<String,String>();
                                Map<String,String> withHoldingTax2ViewModel = new Map<String,String>();
                                withHoldingTax1ViewModel.put('TaxType','J1');
                                withHoldingTax1ViewModel.put('Subject','X');
                                withHoldingTax1ViewModel.put('TypeOfRecipient','53');
                                withHoldingTax1ViewModel.put('Task','U');
                                withHoldingTaxViewModelList.add(withHoldingTax1ViewModel);

                                withHoldingTax2ViewModel.put('TaxType','J2');
                                withHoldingTax2ViewModel.put('Subject','X');
                                withHoldingTax2ViewModel.put('TypeOfRecipient','53');
                                withHoldingTax2ViewModel.put('Task','U');
                                withHoldingTaxViewModelList.add(withHoldingTax2ViewModel);
                            }
                        }
                    }
                }
            }


            String mRecordType = (mRequestItem.RecordType.DeveloperName.contains('ShipTo'))?'ShipTo':'SoldTo';
            String mSAPCode = mRequestItem.Customer__r.AccountNumber__c !=null ? mRequestItem.Customer__r.AccountNumber__c: '';
            if(RecordTypeShort == 'Supplier')
            {
                mSAPCode = mRequestItem.Customer__r.SupplierNumber__c !=null ? mRequestItem.Customer__r.SupplierNumber__c: '';
            }
    
            //Requeired Important
            subInputModel.put('SalesOrganization',  SalesOrganization); 
            subInputModel.put('CompanyCode',  SalesOrganization); 
            subInputModel.put('DistributionChannel', DistributionChannel); 
            subInputModel.put('Division',  Division); 
            subInputModel.put('RecordType', mRecordType);
            subInputModel.put('Id',  mRequestItem.Customer__c !=null ? mRequestItem.Customer__c: '');   
            subInputModel.put('ReferenceId', mRequestItem.Id);
            subInputModel.put('AccountNumber',  mSAPCode); 
            subInputModel.put('GatewayId', mGatewayId);
            subInputModel.put('Flag', mMainFlag);
            
    
            //input ListData
            subInputModel.put('CentralData', centralDataModelList);
            subInputModel.put('AddressGen', addressGenModelList);
            subInputModel.put('AddressInt', addressIntModelList);
            subInputModel.put('TaxClassification', taxClassificationModelList);
            subInputModel.put('CompanyCodeView', companyCodeViewModelList);

            if(RecordTypeShort == 'Customer' || RecordTypeShort == 'ShipTo')
            {
                subInputModel.put('SalesData', salesDataModelList);
            }
            else if(RecordTypeShort == 'Supplier')
            {
                subInputModel.put('PurchasingView', salesDataModelList);
                subInputModel.put('WithHoldingTax', withHoldingTaxViewModelList);
                
            }

    
            inputModel.input = subInputModel;
            ctrData.input = inputModel;
        }
        return ctrData;
    }

    public static Map<String,String> manageEditJsonMappingForIntegration(List<changedFieldWrapper> mChangedFieldList, Map<String,List<changedFieldWrapper>> mMapingChangeFieldMap, String mIntegrationView)
    {
        try
        {
            Map<String,String> MappingDataModel = new Map<String,String>();
            for(changedFieldWrapper mChangeField: mChangedFieldList)
            {
                List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get(mIntegrationView);
                if(mIntegrationFieldMappingList.size()>0)
                {
                    for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
                    {
                        if(mIntegrationChange.mApi == mChangeField.mApi)
                        {
                            mChangeField.mValue = (mChangeField.mValue =='true')?'X':mChangeField.mValue;
                            mChangeField.mValue = (mChangeField.mValue =='false')?'':mChangeField.mValue;
                            MappingDataModel.put(mIntegrationChange.mLabel, mChangeField.mValue);
                        }
                    }
                }
            }
            return MappingDataModel;
        }
        catch (exception e)
        {
            System.debug('Error View Name: '+mIntegrationView+' LoopMapping Line '+e.getLineNumber()+' Message:'+ e.getMessage());
            return new Map<String,String>();
        }
        
    }
    
    // public static MapLv1 SetupJsonForCTRDataModelTest (String mChangeFieldHeader, String mChangeFieldItem ,String mSendProcess, String mBusinessUnit, String mSendType)
    // {
    //     try
    //     {
    //         mapLv1 ctrData = new mapLv1();
    //     //mSendType = 'Customer'; //Mock
    //     List<CTRIntegrationMapping__mdt> mAllMappingList = [SELECT Id, BusinessUnit__c, IntegrationType__c, JsonMapping__c, RecordType__c, ViewName__c FROM CTRIntegrationMapping__mdt];
    //     List<CTRIntegrationMapping__mdt> mMappingList = new List<CTRIntegrationMapping__mdt>();
    //     Map<String,List<changedFieldWrapper>> mMapingChangeFieldMap = new Map<String, List<changedFieldWrapper>>(); 
    //     for(CTRIntegrationMapping__mdt mMap :mAllMappingList)
    //     {
    //         if(mMap.BusinessUnit__c == mBusinessUnit && mMap.RecordType__c == mSendType && mMap.IntegrationType__c == 'Edit')
    //         {
    //             //List<changedFieldWrapper> mIntegrationFieldList = convertJsonToObj(mMap.JsonMapping__c,'IntegrationField');
    //             List<changedFieldWrapper> mChangeFieldList = new List<changedFieldWrapper>();
    //                 List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mMap.JsonMapping__c);

    //                 for(Object mFieldData : mFieldList)
    //                 {    
    //                     Map<String,Object> mField = (Map<String,Object>)mFieldData;
    //                     changedFieldWrapper mChangeField = new changedFieldWrapper();
    //                     mChangeField.mLevel = (String)mField.get('Level');
    //                     mChangeField.mLabel = (String)mField.get('Label');
    //                     mChangeField.mApi = (String)mField.get('Api');
    //                     mChangeFieldList.add(mChangeField);
    //                 }
    //             mMapingChangeFieldMap.put(mMap.ViewName__c, mChangeFieldList);
    //             mMappingList.add(mMap);
    //         }
    //     }
    //     System.debug('mMapingChangeFieldMap:'+mMapingChangeFieldMap);


    //     List<changedFieldWrapper> mHeaderChangeFieldList = new List<changedFieldWrapper>();
    //     if(String.isNotBlank(mChangeFieldHeader))
    //     {
    //         List<Object> mHeaderFieldList = (List<Object>)JSON.deserializeUntyped(mChangeFieldHeader);
    //         for(Object mFieldData : mHeaderFieldList)
    //         {    
    //             Map<String,Object> mField = (Map<String,Object>)mFieldData;
    //             changedFieldWrapper mChangeField = new changedFieldWrapper();
    //             mChangeField.mValue = (String)mField.get('Value');
    //             mChangeField.mLabel = (String)mField.get('Label');
    //             mChangeField.mApi = (String)mField.get('Api');
    //             mHeaderChangeFieldList.add(mChangeField);
    //         }
    //         System.debug('mHeaderChangeFieldList:'+mHeaderChangeFieldList);
    //     }

    //     //(List<changedFieldWrapper>)convertJsonToObj(mChangeFieldHeader,'ChangedFieldSF');
    //     List<changedFieldWrapper> mItemChangeFieldList = new List<changedFieldWrapper>();
    //     //(List<changedFieldWrapper>)convertJsonToObj(mChangeFieldItem,'ChangedFieldSF');
    //     if(String.isNotBlank(mChangeFieldItem))
    //     {
    //         List<Object> mItemFieldList = (List<Object>)JSON.deserializeUntyped(mChangeFieldItem);
    //         for(Object mFieldData : mItemFieldList)
    //         {    
    //             Map<String,Object> mField = (Map<String,Object>)mFieldData;
    //             changedFieldWrapper mChangeField = new changedFieldWrapper();
    //             mChangeField.mValue = (String)mField.get('Value');
    //             mChangeField.mLabel = (String)mField.get('Label');
    //             mChangeField.mApi = (String)mField.get('Api');
    //             mItemChangeFieldList.add(mChangeField);
    //         }
    //         System.debug('mItemChangeFieldList:'+mItemChangeFieldList);
    //     }


    //     String mRecordTypeName = 'SoldTo';
    //     String uuid =   'test1';
    //     String mMainFlag = 'U';
    //     String SalesOrganization = '1100';
    //     String DistributionChannel = '11';
    //     String Division = '00';



    //     mapLv2 inputModel = new mapLv2();
    //     Map<String,Object> subInputModel = new Map<String,Object>();

    //     List<Map<String,String>> centralDataModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> addressGenModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> addressIntModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> salesDataModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> taxClassificationModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> companyCodeViewModelList = new List<Map<String,String>>();
    //     List<Map<String,String>> withHoldingTaxViewModelList = new List<Map<String,String>>();

    //     Map<String,String> centralDataModel = new Map<String,String>();
    //     Map<String,String> addressGenModel = new Map<String,String>();
       
    //     Map<String,String> salesDataModel = new Map<String,String>();
    //     Map<String,String> taxClassificationModel = new Map<String,String>();
    //     Map<String,String> companyCodeViewModel = new Map<String,String>();



    //         //Central Data
    //         for(changedFieldWrapper mHeaderChange: mHeaderChangeFieldList)
    //         {
    //             List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('CentralData');
    //             if(mIntegrationFieldMappingList.size()>0)
    //             {
    //                 for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
    //                 {
    //                     if(mIntegrationChange.mApi == mHeaderChange.mApi)
    //                     {
    //                         centralDataModel.put(mIntegrationChange.mLabel, mHeaderChange.mValue);
    //                     }
    //                 }
    //             }
    //         }
    //         if(centralDataModel.size()>0)
    //         {
    //             centralDataModelList.add(centralDataModel);
    //             System.debug('centralDataModelList: '+centralDataModelList);
    //         }
        
    //         //Address Gen
    //         for(changedFieldWrapper mHeaderChange: mHeaderChangeFieldList)
    //         {
    //             List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('AddressGen');
    //             if(mIntegrationFieldMappingList.size()>0)
    //             {
    //                 for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
    //                 {
    //                     if(mIntegrationChange.mApi == mHeaderChange.mApi)
    //                     {
    //                         addressGenModel.put(mIntegrationChange.mLabel, mHeaderChange.mValue);
    //                     }
    //                 }
    //             }
    //         }
    //         if(centralDataModel.size()>0)
    //         {
    //             addressGenModel.put('Type','I');
    //             addressGenModel.put('Flag','U');
    //             addressGenModelList.add(addressGenModel);
    //             System.debug('addressGenModelList: '+addressGenModelList);
    //         }


    //         //Address Int
    //         List<String> typeListAddressInt = new List<String>{'I','T'};
    //         for(String typeAddressInt: typeListAddressInt)
    //         {
    //             Map<String,String> addressIntModel = new Map<String,String>();
    //             for(changedFieldWrapper mHeaderChange: mHeaderChangeFieldList)
    //             {
    //                 List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('AddressInt '+typeAddressInt);
    //                 if(mIntegrationFieldMappingList.size()>0)
    //                 {
    //                     for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
    //                     {
    //                         if(mIntegrationChange.mApi == mHeaderChange.mApi)
    //                         {
    //                             addressIntModel.put(mIntegrationChange.mLabel, mHeaderChange.mValue);
    //                         }
    //                     }
    //                 }
    //             }
    //             if(addressIntModel.size()>0)
    //             {
    //                 addressIntModel.put('Type',typeAddressInt);
    //                 addressIntModel.put('Flag','U');
    //                 addressIntModelList.add(addressIntModel);
    //             }
    //         }



    //         if(mSendType == 'Customer')
    //         {
    //             // TaxClassificationModel
    //             for(changedFieldWrapper mHeaderChange: mHeaderChangeFieldList)
    //             {
    //                 List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('TaxClassification');
    //                 if(mIntegrationFieldMappingList.size()>0)
    //                 {
    //                     for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
    //                     {
    //                         if(mIntegrationChange.mApi == mHeaderChange.mApi)
    //                         {
    //                             taxClassificationModel.put(mIntegrationChange.mLabel, mHeaderChange.mValue);
    //                         }
    //                     }
    //                 }
    //             }
    //             if(taxClassificationModel.size()>0)
    //             {
    //                 taxClassificationModel.put('Task', 'U');
    //                 taxClassificationModel.put('Flag','U');
    //                 taxClassificationModelList.add(taxClassificationModel);
    //             }

    //             // SalesDataModel
    //             for(changedFieldWrapper mItemChange: mItemChangeFieldList)
    //             {
    //                 List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('SalesData');
    //                 if(mIntegrationFieldMappingList.size()>0)
    //                 {
    //                     for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
    //                     {
    //                         if(mIntegrationChange.mApi == mItemChange.mApi)
    //                         {
    //                             salesDataModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
    //                         }
    //                     }
    //                 }
    //             }
    //             if(salesDataModel.size()>0)
    //             {
    //                 salesDataModel.put('Task', 'U');
    //                 salesDataModel.put('Flag','U');
    //                 salesDataModelList.add(salesDataModel);
    //             }

    //             if(mBusinessUnit == 'TX')
    //             {
    //                 // CompanyCodeViewModel
    //                 for(changedFieldWrapper mItemChange: mItemChangeFieldList)
    //                 {
    //                     List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('CompanyCodeView');
    //                     if(mIntegrationFieldMappingList.size()>0)
    //                     {
    //                         for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
    //                         {
    //                             if(mIntegrationChange.mApi == mItemChange.mApi)
    //                             {
    //                                 companyCodeViewModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
    //                             }
    //                         }
    //                     }
    //                 }
    //                 if(companyCodeViewModel.size()>0)
    //                 {
    //                     companyCodeViewModel.put('Task', 'U');
    //                     companyCodeViewModel.put('Flag','U');
    //                     companyCodeViewModelList.add(companyCodeViewModel);
    //                 }
    //             }
    //         }

    //         if(mSendType == 'Supplier')
    //         {
    //         //Purchasing view
    //         for(changedFieldWrapper mItemChange: mItemChangeFieldList)
    //         {
    //             List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('PurchasingView');
    //             if(mIntegrationFieldMappingList.size()>0)
    //             {
    //                 for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
    //                 {
    //                     if(mIntegrationChange.mApi == mItemChange.mApi)
    //                     {
    //                         salesDataModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
    //                     }
    //                 }
    //             }
    //         }
    //         if(salesDataModel.size()>0)
    //         {
    //             salesDataModel.put('Task', 'U');
    //             salesDataModel.put('Flag','U');
    //             salesDataModelList.add(salesDataModel);
    //         }

    //             // CompanyCodeViewModel
    //             for(changedFieldWrapper mItemChange: mItemChangeFieldList)
    //             {
    //                 List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('CompanyCodeView');
    //                 if(mIntegrationFieldMappingList.size()>0)
    //                 {
    //                     for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
    //                     {
    //                         if(mIntegrationChange.mApi == mItemChange.mApi)
    //                         {
    //                             companyCodeViewModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
    //                         }
    //                     }
    //                 }
    //             }
    //             if(companyCodeViewModel.size()>0)
    //             {
    //                 companyCodeViewModel.put('Task', 'U');
    //                 companyCodeViewModel.put('Flag','U');
    //                 companyCodeViewModelList.add(companyCodeViewModel);
    //             }

    //             if(mBusinessUnit == 'TX')
    //             {
    //                 Map<String,String> withHoldingTax1ViewModel = new Map<String,String>();
    //                 Map<String,String> withHoldingTax2ViewModel = new Map<String,String>();
    //                 for(changedFieldWrapper mItemChange: mItemChangeFieldList)
    //                 {
    //                     List<changedFieldWrapper> mIntegrationFieldMappingList = mMapingChangeFieldMap.get('WithHoldingTax');
    //                     if(mIntegrationFieldMappingList.size()>0)
    //                     {
    //                         for(changedFieldWrapper mIntegrationChange: mIntegrationFieldMappingList)
    //                         {
    //                             if(mIntegrationChange.mApi == mItemChange.mApi)
    //                             {
    //                                 if(mItemChange.mApi.contains('1'))
    //                                 {
    //                                     withHoldingTax1ViewModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
    //                                 }
    //                                 if(mItemChange.mApi.contains('2'))
    //                                 {
    //                                     withHoldingTax2ViewModel.put(mIntegrationChange.mLabel, mItemChange.mValue);
    //                                 }
    //                             }
    //                         }
    //                     }
    //                 }
    //                 if(withHoldingTax1ViewModel.size()>0)
    //                 {
    //                     withHoldingTax1ViewModel.put('Task','U');
    //                     withHoldingTaxViewModelList.add(withHoldingTax1ViewModel);
    //                 }
    //                 if(withHoldingTax2ViewModel.size()>0)
    //                 {
    //                     withHoldingTax2ViewModel.put('Task','U');
    //                     withHoldingTaxViewModelList.add(withHoldingTax2ViewModel);
    //                 }
                    
    //             }
    //         }
          

    //         //Requeired Important
    //         subInputModel.put('SalesOrganization',  SalesOrganization); 
    //         subInputModel.put('DistributionChannel', DistributionChannel); 
    //         subInputModel.put('Division',  Division); 
    //         subInputModel.put('Id', 'testId');   
    //         subInputModel.put('ReferenceId', 'mRequestItem.Id');
    //         subInputModel.put('AccountNumber',  'mRequestItem.Customer__r.AccountNumber__c' ); 
    //         subInputModel.put('GatewayId', uuid);
    //         subInputModel.put('Flag', mMainFlag);

    //         //input ListData
    //         subInputModel.put('CentralData', centralDataModelList);
    //         subInputModel.put('AddressGen', addressGenModelList);
    //         subInputModel.put('AddressInt', addressIntModelList);
    //         subInputModel.put('TaxClassification', taxClassificationModelList);
    //         subInputModel.put('CompanyCodeView', companyCodeViewModelList);

    //         if(mSendType == 'Customer')
    //         {
    //             subInputModel.put('SalesData', salesDataModelList);
    //         }
    //         else if(mSendType == 'Supplier')
    //         {
    //             subInputModel.put('PurchasingView', salesDataModelList);
    //             subInputModel.put('WithHoldingTax', withHoldingTaxViewModelList);
    //         }

    //         inputModel.input = subInputModel;
    //         ctrData.input = inputModel;
    //         String str = JSON.serialize(ctrData);
    //         system.debug('json:'+str);
    //         return ctrData;
    //     }
    //     catch(exception e)
    //     {
    //         mapLv1 ctrData = new mapLv1();
    //         system.debug('Error from Line:'+e.getLineNumber()+'|| message:'+e.getmessage());
    //         return ctrData;
    //     }
    //  }

     
}