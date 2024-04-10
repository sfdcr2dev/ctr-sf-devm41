public with sharing class CTRRequestEditLogFieldController 
{
    //Onload Table
    @AuraEnabled
    public static editLevelWrapper onloadv3(Id mRecordId, String mHistoryType)
    {
        try
        {
            List<editChangeFieldWrapper> mEditItemList = new List<editChangeFieldWrapper>();
            List<editChangeFieldWrapper> mEditHeaderList = new List<editChangeFieldWrapper>();
            List<RelatedTableChangeFieldWrapper> mResultRelatedList = new List<RelatedTableChangeFieldWrapper>();

            Set<Id> mItemSetId = new Set<ID>();
            mItemSetId.add(mRecordId);
            List<CTRRequestFormItem__c> mRequestItemList = [SELECT Id, OriginalRequestFormItem__c, CTRRequestFormHeader__c, Customer__c, Customer__r.AccountNumber__c, Customer__r.SupplierNumber__c,
                                                            CTRRequestFormHeader__r.OriginalShareholder__c, CTRRequestFormHeader__r.InternalEditField__c, CTRRequestFormHeader__r.InternalOriginalField__c,
                                                            InternalEditField__c, InternalOriginalField__c, OriginalDestinationCountry__c, RecordTypeId, RecordType.DeveloperName
                                                            FROM CTRRequestFormItem__c WHERE Id =:mRecordId LIMIT 1];//CTRCommitteeSendToSap.geRequestItemForSendToSAP(mItemSetId);

            Set<String> mObjectNameList = new Set<String>();
            Set<Id> mAllIdSet = new Set<Id>();
            
            if(mRequestItemList.size()>0)
            {
                
                CTRRequestFormItem__c mItem = mRequestItemList[0];
                if(mHistoryType == 'Edit' || mHistoryType == 'Initial' || mHistoryType == '')
                {
                    Boolean mEnabledNewFunction = false;
                    // if((mItem.RecordTypeName.contans('Customer') && mItem.Customer__r.AccountNumber__c != null) ||
                    // (mItem.RecordTypeName.contans('ShipTo') && mItem.Customer__r.AccountNumber__c != null)
                    // (mItem.RecordTypeName.contans('Supplier') && mItem.Customer__r.SupplierNumber__c != null)
                    // )
                    // {
                    //     mEnabledNewFunction = true;
                    // }
                    String mAccountOriginalValue = '[]';
                    if(mEnabledNewFunction)
                    {
                        List<CTRFieldEditLog__mdt> mCounterPartyFieldLogList = [SELECT Id, Source__c, FieldList__c, Object__c FROM CTRFieldEditLog__mdt WHERE Source__c = 'Counter party'];
                        Map<String, String> mFieldListMap = new Map<String, String>();

                        if(mCounterPartyFieldLogList.size()>0)
                        {
                            for(CTRFieldEditLog__mdt mEditLog: mCounterPartyFieldLogList)
                            {
                                mFieldListMap.put(mEditLog.Object__c, mEditLog.FieldList__c);
                            }
                            if(mFieldListMap.size()>0)
                            {
                                //Account To Json
                                String mAccountId = mItem.Customer__c;
                                String mAccountObjName = 'Account';
                                Map<Id, String> mAccountJsonMapResult = new Map<Id, String>();

                                List<String> mAccountFieldList = getFieldListFromJson(mFieldListMap.get(mAccountObjName), mAccountObjName);
                                if(mAccountFieldList.size()>0)
                                {
                                    List<SObject> mAccountList = new List<SObject>();
                                    String mAccountsoql = '';
                                    mAccountsoql+= ' SELECT ' + String.join(mAccountFieldList, ',');
                                    mAccountsoql+= ' FROM '+mAccountObjName;
                                    mAccountsoql+= ' WHERE Id = :mAccountId ';
                                    mAccountList = Database.query(mAccountsoql);
                                    if(mAccountList.size()>0)
                                    {
                                        mAccountJsonMapResult = SavePointValueRecordToJson(mAccountList, mAccountFieldList, mAccountObjName);
                                    }
                                }
                                if(mAccountJsonMapResult.size()>0)
                                {
                                    mAccountOriginalValue = mAccountJsonMapResult.values()[0];

                                    //Replace Account Different Api To Mapping
                                    mAccountOriginalValue = mAccountOriginalValue.replace('"Api": "Phone"','"Api": "Phone__c"');
                                    mAccountOriginalValue = mAccountOriginalValue.replace('"Api": "Fax"','"Api": "Fax__c"');
                                    mAccountOriginalValue = mAccountOriginalValue.replace('"Api": "Website"','"Api": "CompanyWebsite__c"');
                                    mAccountOriginalValue = mAccountOriginalValue.replace('"Api": "Location__Latitude__s"','"Api": "LocationInGoogleMapsGeolocation__Latitude__s"');
                                    mAccountOriginalValue = mAccountOriginalValue.replace('"Api": "Location__Latitude__s"','"Api": "LocationInGoogleMapsGeolocation__Longitude__s"');
                                }
                            }
                        }
                    }

                    //Header Json
                    String mHeaderOriginalValue = (String.isNotBlank(mItem.CTRRequestFormHeader__r.InternalOriginalField__c))?mItem.CTRRequestFormHeader__r.InternalOriginalField__c:'[]';
                    String mHeaderLatestValue = (String.isNotBlank(mItem.CTRRequestFormHeader__r.InternalEditField__c))?mItem.CTRRequestFormHeader__r.InternalEditField__c:'[]';

                    //Convert Header Json To Obj
                    //List<Object> mHeaderOriginalList = convertJsonToObject(mAccountOriginalValue);
                    List<Object> mHeaderOriginalList = convertJsonToObject((mEnabledNewFunction)?mAccountOriginalValue:mHeaderOriginalValue);
                    List<Object> mHeaderLatestList = convertJsonToObject(mHeaderLatestValue);

                    mEditHeaderList = manageRequestWrapperForTable(mHeaderOriginalList,mHeaderLatestList);

                    List<editChangeFieldWrapper> mAllDataList = new List<editChangeFieldWrapper>();
                    mAllDataList.addAll(mEditHeaderList);

                    if(mHistoryType == 'Edit' || mHistoryType == '')
                    {
                        //Item Json
                        String mItemOriginalValue = (String.isNotBlank(mItem.InternalOriginalField__c))?mItem.InternalOriginalField__c:'[]';
                        String mItemLatestValue = (String.isNotBlank(mItem.InternalEditField__c))?mItem.InternalEditField__c:'[]';

                        //Convert Item Json To Obj
                        List<Object> mItemOriginalList = convertJsonToObject(mItemOriginalValue);
                        List<Object> mItemLatestList = convertJsonToObject(mItemLatestValue);

                        mEditItemList = manageRequestWrapperForTable(mItemOriginalList,mItemLatestList);
                        mAllDataList.addAll(mEditItemList);
                    }
                    
                    String jsonStr = JSON.serialize(mAllDataList);
                    jsonStr = jsonStr.replace('null', '""');
                    //System.debug('jsonStr all'+jsonStr);
                }
                else if(mHistoryType == 'Shareholder')
                {
                    if(mItem.CTRRequestFormHeader__c != null)
                    {
                        Id mHeaderId = mItem.CTRRequestFormHeader__c;
                        // Map<String, RelatedTableChangeFieldWrapper> mOriginalShareHolderTableMap = new Map<String, RelatedTableChangeFieldWrapper>();
                        // Map<String, RelatedTableChangeFieldWrapper> mCurrentShareHolderTableMap = new Map<String, RelatedTableChangeFieldWrapper>();
                        List<String> mShareholderFieldList = new List<String>{'of_Shareholder__c', 'Name', 'CTRRequestFormHeader__c'};
                        List<SObject> mShareholderList = new List<SObject>();
                        String mShareholdersoql = '';
                                mShareholdersoql+= ' SELECT ' + String.join(mShareholderFieldList, ',');
                                mShareholdersoql+= ' FROM CTRShareholder__c';
                                mShareholdersoql+= ' WHERE CTRRequestFormHeader__c = :mHeaderId ';
                                mShareholderList = Database.query(mShareholdersoql);
                        if(mItem.CTRRequestFormHeader__r.OriginalShareholder__c != null && mItem.CTRRequestFormHeader__r.OriginalShareholder__c != '' && mItem.CTRRequestFormHeader__r.OriginalShareholder__c != '[]')
                        {
                            mResultRelatedList = compareResultRelatedTable(mShareholderList, mItem.CTRRequestFormHeader__r.OriginalShareholder__c, mShareholderFieldList,'CTRShareholder__c');
                        }

                        //Current Data
                        /*if(mShareholderList.size()>0)
                        {
                            mCurrentShareHolderTableMap = manageRelatedForTable(mShareholderList, 'CTRShareholder__c');
                        }
                        //Original Data
                        if(String.isNotBlank(mItem.CTRRequestFormHeader__r.OriginalShareholder__c))
                        {
                            List<SObject> mOriginalShareHolderList = (List<SObject>)convertJsonToObject(mItem.CTRRequestFormHeader__r.OriginalShareholder__c);
                            if(mOriginalShareHolderList.size()>0)
                            {
                                mOriginalShareHolderTableMap = manageRelatedForTable(mOriginalShareHolderList, 'CTRShareholder__c');
                            }
                        }
                        //Removed all
                        if(mOriginalShareHolderTableMap.size()>0 && mCurrentShareHolderTableMap.size() == 0)
                        {
                            List<RelatedTableChangeFieldWrapper> mCalShareholderList = mOriginalShareHolderTableMap.values();
                            for(RelatedTableChangeFieldWrapper mShareholderTable: mCalShareholderList)
                            {
                                mShareholderTable.mStatus ='Removed';
                                mResultShareholderList.add(mShareholderTable);
                            }
                            
                        }
                        //add all
                        else if(mOriginalShareHolderTableMap.size() == 0 && mCurrentShareHolderTableMap.size() > 0)
                        {
                            List<RelatedTableChangeFieldWrapper> mCalShareholderList = mCurrentShareHolderTableMap.values();
                            for(RelatedTableChangeFieldWrapper mShareholderTable: mCalShareholderList)
                            {
                                mShareholderTable.mStatus ='New';
                                mResultShareholderList.add(mShareholderTable);
                            }
                        }
                        //compared all
                        else if(mOriginalShareHolderTableMap.size() > 0 && mCurrentShareHolderTableMap.size() > 0)
                        {
                            Set<String> mSameDataSet = new Set<String>();
                            for(RelatedTableChangeFieldWrapper mOriShareholderTable: mOriginalShareHolderTableMap.values())
                            {
                                for(RelatedTableChangeFieldWrapper mCurrentShareholderTable: mCurrentShareHolderTableMap.values())
                                {
                                    if(mCurrentShareholderTable.mKey == mOriShareholderTable.mKey)
                                    {
                                        mSameDataSet.add(mOriShareholderTable.mKey);
                                    }
                                }
                            }
                            if(mSameDataSet.size()>0)
                            {
                                mOriginalShareHolderTableMap.keySet().removeAll(mSameDataSet);
                                mCurrentShareHolderTableMap.keySet().removeAll(mSameDataSet);
                            }
                            for(RelatedTableChangeFieldWrapper mShareholderTable: mCurrentShareHolderTableMap.values())
                            {
                                mShareholderTable.mStatus ='New';
                                mResultShareholderList.add(mShareholderTable);
                            }
                            for(RelatedTableChangeFieldWrapper mShareholderTable: mOriginalShareHolderTableMap.values())
                            {
                                mShareholderTable.mStatus ='Removed';
                                mResultShareholderList.add(mShareholderTable);
                            }
                        }*/

                    }
                }
                else if(mHistoryType == 'DestinationCountry')
                {
                    Map<String, RelatedTableChangeFieldWrapper> mOriginalDestinationCountryTableMap = new Map<String, RelatedTableChangeFieldWrapper>();
                    Map<String, RelatedTableChangeFieldWrapper> mCurrentDestinationCountryTableMap = new Map<String, RelatedTableChangeFieldWrapper>();
                    List<String> mCountryFieldList = new List<String>{'ShippingCountry__c', 'LocationType__c', 'CTRRequestFormItem__c'};
                    List<SObject> mDestinationCountryList = new List<SObject>();
                    String mDestinationCountrysoql = '';
                    mDestinationCountrysoql+= ' SELECT ' + String.join(mCountryFieldList, ',');
                    mDestinationCountrysoql+= ' FROM CTRShippingCountry__c';
                    mDestinationCountrysoql+= ' WHERE CTRRequestFormItem__c = :mRecordId ';
                    mDestinationCountryList = Database.query(mDestinationCountrysoql);
                    if(mItem.OriginalDestinationCountry__c != null && mItem.OriginalDestinationCountry__c != '' && mItem.OriginalDestinationCountry__c!= '[]')
                    {
                        mResultRelatedList = compareResultRelatedTable(mDestinationCountryList, mItem.OriginalDestinationCountry__c, mCountryFieldList,'CTRShippingCountry__c');
                    }
                    

                    // if(mDestinationCountryList.size()>0)
                    // {
                        
                    // }
                }

            }

            List<editChangeFieldWrapper> mAllEditList = new List<editChangeFieldWrapper>();
            mAllEditList.addAll(mEditHeaderList);
            mAllEditList.addAll(mEditItemList);
            editLevelWrapper mLevelWrapper = new editLevelWrapper();
            mLevelWrapper.mItemEditList =mEditItemList;
            mLevelWrapper.mHeaderEditList = mEditHeaderList;
            mLevelWrapper.mAllEditList = mAllEditList;
            mLevelWrapper.mRelatedEditList = mResultRelatedList;

            return mLevelWrapper;
        }
        catch(exception e)
        {
            System.debug('error from editlog line: '+e.getLineNumber()+' || message: '+e.getmessage());
            return new editLevelWrapper();
        }
    }
    //Compared Original-Current Shareholder-DesitnationCountry history to table
    public static List<RelatedTableChangeFieldWrapper> compareResultRelatedTable(List<SObject> mObjList, String mOriginalJson, List<String> mFieldList, String mObjName)
    {
        try
        {
            List<RelatedTableChangeFieldWrapper> mResultObjList = new List<RelatedTableChangeFieldWrapper>();
            Map<String, RelatedTableChangeFieldWrapper> mOriginalObjTableMap = new Map<String, RelatedTableChangeFieldWrapper>();
            Map<String, RelatedTableChangeFieldWrapper> mCurrentObjTableMap = new Map<String, RelatedTableChangeFieldWrapper>();
            //System.debug('mObjList'+mObjList);
            //System.debug('mOriginalJson'+mOriginalJson);
            //System.debug('mObjName'+mObjName);

            //Current Data
            if(mObjList.size()>0)
            {
                List<Object> mCurrentObjList = new List<Object>();

                    for(SObject mObj: mObjList)
                    {
                        // get the SObjectType
                        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(mObjName);
                        // get the fields on the object
                        Map<String, SObjectField> fieldMap = objectType.getDescribe().fields.getMap();
                        String mKey = '';
                        String mCol1 = '';
                        String mCol2 = '';
                        if(mObjName == 'CTRShareholder__c')
                        {
                            mCol1 = (String) mObj.get(fieldMap.get('Name'));
                            mCol2 = String.ValueOf( mObj.get(fieldMap.get('of_Shareholder__c')));
                            mKey = (String) mObj.get(fieldMap.get('Name'))+' '+String.ValueOf( mObj.get(fieldMap.get('of_Shareholder__c')));
                        }
                        else if(mObjName == 'CTRShippingCountry__c')
                        {
                            mCol1 = (String) mObj.get(fieldMap.get('ShippingCountry__c'));
                            mCol2 = (String) mObj.get(fieldMap.get('LocationType__c')); 
                            mKey = (String) mObj.get(fieldMap.get('ShippingCountry__c'))+' '+(String) mObj.get(fieldMap.get('LocationType__c'));
                        }

                        RelatedTableChangeFieldWrapper mRelated = new RelatedTableChangeFieldWrapper();
                        mRelated.mKey = mKey;
                        mRelated.mCol1 = mCol1;
                        mRelated.mCol2 = mCol2;
                        mRelated.mStatus ='';
                        mCurrentObjTableMap.put(mKey, mRelated);
                    }
            }
            //Original Data
            if(String.isNotBlank(mOriginalJson))
            {
                //List<SObject> mOriginalObjList = new List<SObject>();
                List<Object> mOriginalObjList = convertJsonToObject(mOriginalJson);

                if(mOriginalObjList.size()>0)
                {
                    for(Object mObj: mOriginalObjList)
                    {
                        String mKey = '';
                        String mCol1 = '';
                        String mCol2 = '';
                        Map<String,Object> mData = (Map<String,Object>)mObj;
                        if(mObjName == 'CTRShareholder__c')
                        {
                            mCol1 = (String) mData.get('Name');
                            mCol2 = String.ValueOf( mData.get('of_Shareholder__c'));
                            mKey = (String) mData.get('Name')+' '+String.ValueOf( mData.get('of_Shareholder__c'));
                        }
                        else if(mObjName == 'CTRShippingCountry__c')
                        {
                            mCol1 = (String) mData.get('ShippingCountry__c');
                            mCol2 = (String) mData.get('LocationType__c'); 
                            mKey = (String) mData.get('ShippingCountry__c')+' '+(String) mData.get('LocationType__c');
                        }

                        RelatedTableChangeFieldWrapper mRelated = new RelatedTableChangeFieldWrapper();
                        mRelated.mKey = mKey;
                        mRelated.mCol1 = mCol1;
                        mRelated.mCol2 = mCol2;
                        mRelated.mStatus =''; 
                        mOriginalObjTableMap.put(mKey, mRelated);
                    }
                }
            }

            //Removed all
            if(mOriginalObjTableMap.size()>0 && mCurrentObjTableMap.size() == 0)
            {
                //System.debug('RemovedAll');
                List<RelatedTableChangeFieldWrapper> mCalObjList = mOriginalObjTableMap.values();
                for(RelatedTableChangeFieldWrapper mObjTable: mCalObjList)
                {
                    mObjTable.mStatus ='Removed';
                    mResultObjList.add(mObjTable);
                }
            }
            //add all
            else if(mOriginalObjTableMap.size() == 0 && mCurrentObjTableMap.size() > 0)
            {
                //System.debug('adddAll');

                List<RelatedTableChangeFieldWrapper> mCalObjList = mCurrentObjTableMap.values();
                for(RelatedTableChangeFieldWrapper mObjTable: mCalObjList)
                {
                    mObjTable.mStatus ='New';
                    mResultObjList.add(mObjTable);
                }
            }
            //compared all
            else if(mOriginalObjTableMap.size() > 0 && mCurrentObjTableMap.size() > 0)
            {
                //System.debug('compareAll');

                Set<String> mSameDataSet = new Set<String>();
                for(RelatedTableChangeFieldWrapper mOriObjTable: mOriginalObjTableMap.values())
                {
                    for(RelatedTableChangeFieldWrapper mCurrentObjTable: mCurrentObjTableMap.values())
                    {
                        if(mCurrentObjTable.mKey == mOriObjTable.mKey)
                        {
                            mSameDataSet.add(mOriObjTable.mKey);
                        }
                    }
                }
                if(mSameDataSet.size()>0)
                {
                    mOriginalObjTableMap.keySet().removeAll(mSameDataSet);
                    mCurrentObjTableMap.keySet().removeAll(mSameDataSet);
                }
                for(RelatedTableChangeFieldWrapper mObjTable: mCurrentObjTableMap.values())
                {
                    mObjTable.mStatus ='New';
                    mResultObjList.add(mObjTable);
                }
                for(RelatedTableChangeFieldWrapper mObjTable: mOriginalObjTableMap.values())
                {
                    mObjTable.mStatus ='Removed';
                    mResultObjList.add(mObjTable);
                }
            }
            return mResultObjList;
        }
        catch(exception e)
        {
            System.debug('error from editlog.compareResultRelatedTable line: '+e.getLineNumber()+' || message: '+e.getmessage());
            return new List<RelatedTableChangeFieldWrapper>();
        }
    }

    //manage Shareholder-DesitnationCountry history to table DonotUsed
    @AuraEnabled
    public static Map<String, RelatedTableChangeFieldWrapper> manageRelatedForTable(List<Object> mObjList, String sObjectName)
    {
        try
        {
            Map<String, RelatedTableChangeFieldWrapper> mLogMap= new Map<String, RelatedTableChangeFieldWrapper>();
            List<RelatedTableChangeFieldWrapper> mLogList = new List<RelatedTableChangeFieldWrapper>();
            Set<String>mKeySet = new Set<String>();
            for(Object mObj: mObjList)
            {
                String mKey = '';
                String mCol1 = '';
                String mCol2 = '';
                Map<String,Object> mData = (Map<String,Object>)mObj;
                if(sObjectName == 'CTRShareholder__c')
                {
                    mCol1 = (String) mData.get('Name');
                    mCol2 = (String) mData.get('of_Shareholder__c');
                    mKey = (String) mData.get('Name')+' '+(String) mData.get('of_Shareholder__c');
                }
                else if(sObjectName == 'CTRShippingCountry__c')
                {
                    mCol1 = (String) mData.get('ShippingCountry__c');
                    mCol2 = (String) mData.get('LocationType__c'); 
                    mKey = (String) mData.get('ShippingCountry__c')+' '+(String) mData.get('LocationType__c');
                }

                RelatedTableChangeFieldWrapper mRelated = new RelatedTableChangeFieldWrapper();
                mRelated.mKey = mKey;
                mRelated.mCol1 = mCol1;
                mRelated.mCol2 = mCol2;
                mRelated.mStatus ='';
                mLogList.add(mRelated);
                mLogMap.put(mKey, mRelated);
            }
            return mLogMap;
        }
        catch(exception e)
        {
            System.debug('Error RequestHeaderHandler.savepointRelatedObjectToJson line:'+e.getLineNumber()+' || Message:'+e.getmessage());
            return new Map<String, RelatedTableChangeFieldWrapper>();
        }
    }

    
    //manage item and header history to table
    public static List<editChangeFieldWrapper> manageRequestWrapperForTable(List<Object> mOriginalList, List<Object> mLatestList)
    {
        try
        {
            List<editChangeFieldWrapper> mResultList = new List<editChangeFieldWrapper>();
            for(Object mLatestObj: mLatestList)
            {

                Map<String,Object> mLatestData = (Map<String,Object>)mLatestObj;
                if(String.isNotBlank((String)mLatestData.get('Source')))
                {
                    String mLatestLabel = (String)mLatestData.get('Label');
                    String mLatestApi = (String)mLatestData.get('Api');
                    String mLatestValue = (String)mLatestData.get('Value');
                    String mTransformValue = (String)mLatestData.get('Transform');
                    String mUser = (String.isNotBlank((String)mLatestData.get('User')))?(String)mLatestData.get('User'):'';
                    String mOrigianlValue = '';
                    
                    for(Object mOriginalObj: mOriginalList)
                    {
                        Map<String,Object> mOriginalData = (Map<String,Object>)mOriginalObj;
                        String mOriginalLabel = (String)mOriginalData.get('Label');
                        String mOriginalApi = (String)mOriginalData.get('Api');
                        String mOriginalTransformValue = (String)mOriginalData.get('Transform');
                        String mActualOriginalValue = (String)mOriginalData.get('Value');
                        if(mOriginalApi == mLatestApi)
                        {
                            if(String.isNotBlank(mActualOriginalValue))
                            {
                                mOrigianlValue = (String.isNotBlank(mOriginalTransformValue))?mOriginalTransformValue:mActualOriginalValue;
                            }
                        }
                    }
                    editChangeFieldWrapper mChangeFieldWrapper = new editChangeFieldWrapper();
                    mChangeFieldWrapper.id = mLatestApi;
                    mChangeFieldWrapper.mSource = (String)mLatestData.get('Source');
                    mChangeFieldWrapper.mLabel = mLatestLabel;
                    mChangeFieldWrapper.mApi = mLatestApi;
                    mChangeFieldWrapper.mOldValue = mOrigianlValue;
                    mChangeFieldWrapper.mLatestValue = (String.isNotBlank(mTransformValue))?mTransformValue:mLatestValue;
                    mChangeFieldWrapper.mUser = mUser;
                    mResultList.add(mChangeFieldWrapper);
                }
            }
            return mResultList;
        }
        catch(exception e)
        {
            System.debug('error from editlog line: '+e.getLineNumber()+' || message: '+e.getmessage());
            return new List<editChangeFieldWrapper>();
        }
    }

    //Try catch deserialize json
    public static List<Object> convertJsonToObject(String mJson)
    {
        try
        {
            List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mJson);
            return mFieldList;
        }
        catch(Exception e)
        {
            System.debug('error from editlog.convertJsonToObject line: '+e.getLineNumber()+' || message: '+e.getmessage());
            return new List<Object>();
        }
    }

    //Get Field List String From JSON on Custom metadata
    public static List<String> getFieldListFromJson(String mFieldListJson, String mObjectName)
    {
        try
        {
            List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mFieldListJson);
            List<String> mFieldNameList = new List<String>();
            // get the SObjectType
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(mObjectName);
            // get the fields on the object
            Map<String, SObjectField> fieldMap = objectType.getDescribe().fields.getMap();
    
            for(Object mFieldData : mFieldList)
            {
                Map<String,Object> mFieldJson = (Map<String,Object>)mFieldData;
                if(mFieldJson.get('Api') != null)
                {
                    if(fieldMap.get((String)mFieldJson.get('Api')) != null)
                    {
                        mFieldNameList.add((String)mFieldJson.get('Api'));
                    }
                }
            }
            
            return mFieldNameList;
        }
        catch(exception e)
        {
            System.debug('Error RequestHeaderHandler.getFieldListFromJson line:'+e.getLineNumber()+' || Message:'+e.getmessage());
            return new List<String>();
        }
    }

    //SavePoint To Json For Original value ONLY RequestFormItem And Header
    public static Map<Id, String> SavePointValueRecordToJson(List<SObject> mObjList, List<String> mFieldList, String sObjectName)
    {
        try
        {
            Map<Id, String> mJsonResultMap =  new Map<Id, String> ();
            Set<String> mObjectNameList = new Set<String>();
            Set<Id> mAllIdSet = new Set<Id>();
            Map<Id,Map<String, OriginalFieldWrapper>> mChangeFieldMapWithId = new Map<Id,Map<String ,OriginalFieldWrapper>>();

            for(SObject mObj: mObjList)
            {
                Map<String, OriginalFieldWrapper> mChangeFieldMap = new Map<String ,OriginalFieldWrapper>();
                    // get the SObjectType
                    Schema.SObjectType objectType = Schema.getGlobalDescribe().get(sObjectName);
                    // get the fields on the object
                    Map<String, SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

                    for(String mFieldData : mFieldList)
                    {
                        // The key to the map is the api name of the field
                        Schema.SobjectField mField = fieldMap.get(mFieldData);

                        //SObject mObj = mHeader;
                        Object mDataV1 = mObj.get(mField);
                        //System.debug('mDataV1:' +String.valueOf(mDataV1));
                        //if(mDataV1 != null)
                        //{
                            OriginalFieldWrapper mLog = new OriginalFieldWrapper();
                            mLog.Value = (mDataV1 != null)?String.valueOf(mDataV1):'';
                            mLog.Api = mFieldData;
                            mLog.Transform = '';

                            String objectName = sObjectName;
                            String fieldName =  mFieldData;

                            Schema.DisplayType mFieldDataType;
                            String mDataType = 'REFERENCE';
                            if(!Test.isRunningTest())
                            {
                                mFieldDataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType(); 
                                mDataType = String.valueOf(mFieldDataType);
                            }
                            
                            //System.debug('mDataType: '+mDataType);
                            if(mDataType == 'PICKLIST' && mDataV1 != null)
                            {
                                mLog.Transform = convertedDropdownToLabel(objectName, fieldName, String.valueOf(mDataV1));
                            }
                            
                            if(mDataType == 'REFERENCE' && mDataV1 != null)
                            {
                                String mNewValue = String.valueOf(mDataV1);
                                //System.debug('mNewValue: '+mNewValue);
                                if (mNewValue instanceOf Id) 
                                {
                                    //System.debug('valid id');
                                    Id mId = (Id)mNewValue;
                                    mAllIdSet.add(mId);
                                    //System.debug('mId:'+mId);

                                    //System.debug('mNewValue:'+mNewValue);
                                    String mObjectName = mId.getSObjectType().getDescribe().getName();
                                    //System.debug('mObjectName'+mObjectName);
                                    mObjectNameList.add(mObjectName);
                                }
                            }
                            mChangeFieldMap.put(mFieldData,mLog);

                        //}
                    }
                    //System.debug('mChangeFieldMap:'+mChangeFieldMap);
                //}
                if(mChangeFieldMap.size()>0)
                {
                    Schema.SobjectField mFieldId = fieldMap.get('Id');
                    mChangeFieldMapWithId.put((Id)mObj.get(mFieldId), mChangeFieldMap);
                }
            }
            if(mChangeFieldMapWithId.size()>0)
            {
                //System.debug('mChangeFieldMapWithId:'+mChangeFieldMapWithId);
                Map<String, Map<Id, sObject>> mObjMap = new Map<String, Map<Id, sObject>>();
                if(mObjectNameList.size()>0 && mAllIdSet.size()>0)
                {
                    for(String mObjectName: mObjectNameList)
                    {
                        String mQuery = 'SELECT ID, Name';
                        if(mObjectName == 'Master_Map__c')
                        {
                            mQuery+= ', Code__c, Description__c';
                        }
                        mQuery+= ' FROM '+mObjectName;
                        mQuery+= ' WHERE Id IN: mAllIdSet';
                        Map<Id, sObject> sObjectMap = new Map<Id, sObject>((List<sObject>)Database.query(mQuery));
                        mObjMap.put(mObjectName, sObjectMap);
                    }
                }
                for(SObject mObj: mObjList)
                {
                    Map<String, OriginalFieldWrapper> mChangedFieldMap = mChangeFieldMapWithId.get(mObj.Id);
                    //System.debug('mChangedFieldMap:'+mChangedFieldMap);
                    if(mChangedFieldMap.size()>0 || mChangedFieldMap != null)
                    {
                        List<OriginalFieldWrapper> mChangeFieldList = mChangedFieldMap.values();

                        if(mObjMap.size()>0 && mChangeFieldList.size()>0)
                        {
                            for(OriginalFieldWrapper mLog: mChangeFieldList)
                            {
                                if(mLog.Value instanceOf Id)
                                {
                                    Id mId = (Id)mLog.Value;
                                    String mObjectName = mId.getSObjectType().getDescribe().getName();
                                    //System.debug('mId:'+mId);
                                    //System.debug('mObjectName:'+mObjectName);
                                    //System.debug('mHeaderLog.Value:'+mLog.Value);

                                    Map<Id, sObject> mObjMapHeader = mObjMap.get(mObjectName);
                                    if(mObjMapHeader.size()>0)
                                    {
                                        //System.debug('mApi:'+mLog.Api);
                                        sObject mChangeObj = mObjMapHeader.get(mLog.Value);
                                        //System.debug('Header mChangeObj:'+mChangeObj);
                                        if(mChangeObj != null)
                                        {
                                            if(mObjectName == 'Master_Map__c')
                                            {
                                                if(mLog.Api == 'CityStateLocal__c')
                                                {
                                                    mLog.Value = (mChangeObj.get('Description__c') != null)?(String)mChangeObj.get('Description__c'): '';
                                                    mLog.Transform = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                }
                                                else if(mLog.Api == 'CityStateEN__c')
                                                {
                                                    mLog.Value = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                    mLog.Transform = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                }
                                                else
                                                {
                                                    mLog.Value = (mChangeObj.get('Code__c') != null)?(String)mChangeObj.get('Code__c'): '';
                                                    mLog.Transform = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                }
                                            }
                                            else
                                            {
                                                mLog.Value = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                mLog.Transform = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                        String jsonStr = JSON.serialize(mChangeFieldList);
                                    jsonStr = jsonStr.replace('null', '""');
                                    //mHeader.InternalOriginalField__c = jsonStr;
                                    //System.debug('jsonSt2'+jsonStr);
                                    mJsonResultMap.put(mObj.Id, jsonStr);
                    }
                }
            }
            return mJsonResultMap;
        }
        catch (Exception e) 
        {
            System.debug('Error From CTRRequestFormEditTypeController.testLog Line: '+e.getLineNumber()+' || Message:'+e.getMessage());
            return null;
        }
    }

    //json change values modify id to name
    public static Map<String,String> modifyChangeDataJsonIdToLabel(Map<String,String> mMapJson,String objectName)
    {
        try
        {
            Map<Id,Map<String, ChangeFieldWrapper>> mChangeFieldMapWithId = new Map<Id,Map<String ,ChangeFieldWrapper>>();
            Map<String,String> mResultMapJson = new Map<String,String>();
            Set<String> mObjectNameList = new Set<String>();
            Set<Id> mAllIdSet = new Set<Id>();
            for(String mRecordId: mMapJson.keyset())
            {
                Map<String, ChangeFieldWrapper> mChangeFieldMap = new Map<String ,ChangeFieldWrapper>();
                List<Object> mDataList = convertJsonToObject(mMapJson.get(mRecordId));
                if(mDataList.size()>0)
                {
                    for(Object mFieldData : mDataList)
                    {    
                        Map<String,Object> mField = (Map<String,Object>)mFieldData;
                        String mSource = (String.isNotBlank((String)mField.get('Source')))?(String)mField.get('Source'):'';
                        String mLabel = (String)mField.get('Label');
                        String mValue = (String)mField.get('Value');
                        String mApi = (String)mField.get('Api');
                        String mTransform = (String)mField.get('Transform');
                        String mUser = (String)mField.get('User');
                        ChangeFieldWrapper mChangeFieldWrapper = new ChangeFieldWrapper();
                        mChangeFieldWrapper.Label = mLabel;
                        mChangeFieldWrapper.Api = mApi;
                        mChangeFieldWrapper.Value = mValue;
                        mChangeFieldWrapper.Source = mSource;
                        mChangeFieldWrapper.User =mUser;
                        if(String.isNotBlank(mValue)){mChangeFieldWrapper.Transform = mTransform;}
                        
                        String fieldName =  mApi;
                        //System.debug('Api'+mApi);
                        Schema.DisplayType mFieldDataType;
                        String mDataType = 'REFERENCE';
                        if(!Test.isRunningTest())
                        {
                            mFieldDataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType(); 
                            mDataType = String.valueOf(mFieldDataType);
                        }
                        //Schema.DisplayType mFieldDataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType(); 
                        //String mDataType = String.valueOf(mFieldDataType);
                        //System.debug('mDataType: '+mDataType);

                        if(mDataType == 'PICKLIST' && String.isNotBlank(mValue))
                        {
                            mChangeFieldWrapper.Transform = CTRRequestEditLogFieldController.convertedDropdownToLabel(objectName, fieldName, mValue);
                        }
                        
                        if(mDataType == 'REFERENCE' && String.isNotBlank(mValue))
                        {
                            String mNewValue = String.valueOf(mValue);
                            //System.debug('mValue: '+mValue);
                            if (mNewValue instanceOf Id) 
                            {
                                //System.debug('valid id');
                                Id mId = (Id)mNewValue;
                                mAllIdSet.add(mId);
                                //System.debug('mId:'+mId);

                                //System.debug('mNewValue:'+mNewValue);
                                String mObjectName = mId.getSObjectType().getDescribe().getName();
                                //System.debug('mObjectName'+mObjectName);
                                mObjectNameList.add(mObjectName);
                            }
                        }
                        mChangeFieldMap.put(mApi,mChangeFieldWrapper);
                    }
                }
                if(mChangeFieldMap.size()>0)
                {
                    mChangeFieldMapWithId.put(mRecordId, mChangeFieldMap);
                }

            }

            if(mChangeFieldMapWithId.size()>0)
            {
                Map<String, Map<Id, sObject>> mObjMap = new Map<String, Map<Id, sObject>>();
                if(mObjectNameList.size()>0 && mAllIdSet.size()>0)
                {
                    for(String mObjectName: mObjectNameList)
                    {
                        String mQuery = 'SELECT ID, Name';
                        if(mObjectName == 'Master_Map__c')
                        {
                            mQuery+= ', Code__c, Description__c';
                        }
                        mQuery+= ' FROM '+mObjectName;
                        mQuery+= ' WHERE Id IN: mAllIdSet';
                        Map<Id, sObject> sObjectMap = new Map<Id, sObject>((List<sObject>)Database.query(mQuery));
                        mObjMap.put(mObjectName, sObjectMap);
                    }
                }
                    
                
                for(String mRecordId: mMapJson.keyset())
                {
                    if(mMapJson.get(mRecordId) !=null)
                    {
                            Map<String, ChangeFieldWrapper> mChangedFieldMap = mChangeFieldMapWithId.get(mRecordId);
                            if(mChangedFieldMap.size()>0 || mChangedFieldMap != null)
                            {
                            
                                List<ChangeFieldWrapper> mChangeFieldList = mChangedFieldMap.values();

                                if(mObjMap.size()>0 && mChangeFieldList.size()>0)
                                {
                                    for(ChangeFieldWrapper mEditData: mChangeFieldList)
                                    {
                                        if(mEditData.Value instanceOf Id)
                                        {
                                            Id mId = (Id)mEditData.Value;
                                            String mObjectName = mId.getSObjectType().getDescribe().getName();
                                            //System.debug('mId:'+mId);
                                            //System.debug('mObjectName:'+mObjectName);
                                            //System.debug('mEditData.Value:'+mEditData.Value);

                                            Map<Id, sObject> mObjMapHeader = mObjMap.get(mObjectName);
                                            if(mObjMapHeader.size()>0)
                                            {
                                                //System.debug('mApi:'+mEditData.Api);
                                                sObject mChangeObj = mObjMapHeader.get(mEditData.Value);
                                                //System.debug('Header mChangeObj:'+mChangeObj);
                                                if(mChangeObj != null)
                                                {
                                                    if(mObjectName == 'Master_Map__c')
                                                    {
                                                        if(mEditData.Api == 'CityStateLocal__c')
                                                        {
                                                            mEditData.Value = (mChangeObj.get('Description__c') != null)?(String)mChangeObj.get('Description__c'): '';
                                                            mEditData.Transform = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                        }
                                                        else if(mEditData.Api == 'CityStateEN__c')
                                                        {
                                                            mEditData.Value = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                            mEditData.Transform = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                        }
                                                        else
                                                        {
                                                            mEditData.Value = (mChangeObj.get('Code__c') != null)?(String)mChangeObj.get('Code__c'): '';
                                                            mEditData.Transform = (mChangeObj.get('Code__c') != null)?(String)mChangeObj.get('Code__c'): '';
                                                        }
                                                        
                                                    }
                                                    else
                                                    {
                                                        mEditData.Value = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                        mEditData.Transform = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                String jsonStr = JSON.serialize(mChangeFieldList);
                                jsonStr = jsonStr.replace('null', '""');
                                mResultMapJson.put(mRecordId, jsonStr);
                                //mNewHeader.InternalEditField__c= jsonStr;
                                //System.debug('jsonStr'+jsonStr);
                            }
                            
                    }
                    

                }

            }
            return mResultMapJson;
        }
        catch(exception e)
        {
            System.debug('Error testedt v2 line:'+e.getLineNumber()+' || Message:'+e.getmessage());
            return mMapJson;
        }
    }

    public static String convertedDropdownToLabel(String mObj, String mField, String mValue)
    {
        String mLabel = '';
        Schema.DescribeFieldResult plistvalues = Schema.getGlobalDescribe().get(mObj).getDescribe().fields.getMap().get(mField).getDescribe();
        for(PicklistEntry mPicklist:plistvalues.getpicklistvalues()) 
        {
            if(mPicklist.getValue() == mValue)
            {
                mLabel = mPicklist.getLabel();
            }
        }
        return mLabel;
    }

    //For DestinationCountry and ShareHolder Manage Json
    public static Map<String, String> manageRelatedObjectToJson(List<SObject> mRelatedList, List<String> mFieldNameList, Set<Id> mSetId, String mObjectName)
    {
        try
        {
            Map<String, String> mRelatedJsonMap = new Map<String, String>();

            for(Id mId: mSetId)
            {
                List<Map<String, String>> mRelatedRecordConvertList = new List<Map<String, String>>();
                
                for(SObject mObj: mRelatedList)
                {
                    // get the SObjectType
                    Schema.SObjectType objectType = Schema.getGlobalDescribe().get(mObjectName);
                    // get the fields on the object
                    Map<String, SObjectField> fieldMap = objectType.getDescribe().fields.getMap();
                    
                    Map<String, String> mObjMap = new Map<String, String>();
                    for(String mFieldData : mFieldNameList)
                    {
                        // The key to the map is the api name of the field
                        Schema.SobjectField mField = fieldMap.get(mFieldData);

                        Object mData = mObj.get(mField);
                        String mValue = (mData != null)?String.valueOf(mData):'';

                        mObjMap.put(mFieldData, mValue);
                    }
                    mRelatedRecordConvertList.add(mObjMap);
                }
                if(mRelatedRecordConvertList.size()>0)
                {
                    String mJson = JSON.serialize(mRelatedRecordConvertList);
                    mJson = mJson.replace('null', '""');
                    //System.debug('mJson: '+mJson);
                    mRelatedJsonMap.put(mId, mJson);
                }
            }
            
            return mRelatedJsonMap;
        }
        catch(exception e)
        {
            System.debug('Error from manageShareholderToJson line:'+e.getLineNumber()+' || Message: '+e.getMessage());
            return new Map<String, String>();
        }
    }

    //Compare and filtered JSON Between Account AND Header
    public static Map<String, String> filteredCompareAccountAndHeaderJson(Id mItemId, String mAccountJson ,String mHeaderJson)
    {
        try
        {
            return new Map<String, String>();
        }
        catch(exception e)
        {
            System.debug('Error from filteredCompareAccountAndHeaderJson line:'+e.getLineNumber()+' || Message: '+e.getMessage());
            return new Map<String, String>();
        }
    }

    public class editLevelWrapper
    {
        @AuraEnabled public List<editChangeFieldWrapper> mHeaderEditList {get;set;}
        @AuraEnabled public List<editChangeFieldWrapper> mItemEditList {get;set;}
        @AuraEnabled public List<editChangeFieldWrapper> mAllEditList {get;set;}
        @AuraEnabled public List<RelatedTableChangeFieldWrapper> mRelatedEditList {get;set;}
    }

    public class editChangeFieldWrapper
    {
        @AuraEnabled public string id {get;set;}
        @AuraEnabled public string mSource {get;set;}
        @AuraEnabled public string mLabel {get;set;}
        @AuraEnabled public string mApi {get;set;}
        @AuraEnabled public string mOldValue {get;set;}
        @AuraEnabled public string mLatestValue {get;set;}
        @AuraEnabled public string mUser {get;set;}
    }

    public class RelatedTableChangeFieldWrapper
    {
        @AuraEnabled public string mKey {get;set;}
        @AuraEnabled public string mCol1 {get;set;}
        @AuraEnabled public string mCol2 {get;set;}
        @AuraEnabled public string mStatus {get;set;}
    }

    public class OriginalFieldWrapper
    {
        @AuraEnabled public String Api {get;set;}
        @AuraEnabled public String Value {get;set;}
        @AuraEnabled public String Transform {get;set;}
    }
    public class ChangeFieldWrapper
    {
        @AuraEnabled public String Label {get;set;}
        @AuraEnabled public String Api {get;set;}
        @AuraEnabled public String Value {get;set;}
        @AuraEnabled public String Source{get;set;}
        @AuraEnabled public String Transform{get;set;}
        @AuraEnabled public String User{get;set;}
    }

    public class options 
    {
        @AuraEnabled public String value {get;set;}
        @AuraEnabled public String label {get;set;}
    }

    //Backup jaaaa v2
    /*@AuraEnabled
    public static editLevelWrapper onloadv2(Id mRecordId)
    {
        try
        {
            CTRRequestFormItem__c mItem;
            CTRRequestFormItem__c mOriginalItem;
            CTRRequestFormHeader__c mHeader;
            CTRRequestFormHeader__c mOriginalHeader;
            List<CTRRequestFormItem__c> mOriginalRequestItemList = new List<CTRRequestFormItem__c>();
            List<CTRRequestFormHeader__c>mOriginalRequestHeaderList =  new List<CTRRequestFormHeader__c>();
            List<editChangeFieldWrapper> mEditItemList = new List<editChangeFieldWrapper>();
            List<editChangeFieldWrapper> mEditHeaderList = new List<editChangeFieldWrapper>();
            Set<Id> mItemSetId = new Set<ID>();
            mItemSetId.add(mRecordId);
            List<CTRRequestFormItem__c> mRequestItemList = [SELECT Id, OriginalRequestFormItem__c, CTRRequestFormHeader__c, 
                                                            CTRRequestFormHeader__r.OriginalRequestFormHeader__c, CTRRequestFormHeader__r.InternalEditField__c, 
                                                            InternalEditField__c, RecordTypeId, RecordType.DeveloperName  
                                                            FROM CTRRequestFormItem__c WHERE Id =:mRecordId LIMIT 1];//CTRCommitteeSendToSap.geRequestItemForSendToSAP(mItemSetId);

            Set<String> mObjectNameList = new Set<String>();
            Set<Id> mAllIdSet = new Set<Id>();

            if(mRequestItemList.size()>0)
            {
                mItem = mRequestItemList[0];

                if(mItem.OriginalRequestFormItem__c != null)
                {
                    Set<Id> mOriginalItemSetId = new Set<ID>();
                    mOriginalItemSetId.add(mItem.OriginalRequestFormItem__c);
                    mOriginalRequestItemList = CTRCommitteeSendToSap.geRequestItemForSendToSAP(mOriginalItemSetId);
                    if(mOriginalRequestItemList.size()>0)
                    {
                        mOriginalItem = mOriginalRequestItemList[0];
                    }
                }
                if(mItem.CTRRequestFormHeader__c != null && mItem.CTRRequestFormHeader__r.OriginalRequestFormHeader__c != null)
                {
                    Set<Id> mOriginalItemSetId = new Set<ID>();
                    mOriginalItemSetId.add(mItem.CTRRequestFormHeader__r.OriginalRequestFormHeader__c);
                    mOriginalRequestHeaderList = CTRCommitteeSendToSap.geRequestHeaderForSendToSAP(mOriginalItemSetId);
                    if(mOriginalRequestHeaderList.size()>0)
                    {
                        mOriginalHeader = mOriginalRequestHeaderList[0];
                    }
                }

            }
            if(mItem.InternalEditField__c != null)
            {
                if(mOriginalItem != null)
                {
                    Map<String, Schema.SObjectField> mRequestItemFieldMap = Schema.getGlobalDescribe().get('CTRRequestFormItem__c').getDescribe().fields.getMap();
                    List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mItem.InternalEditField__c);

                    //System.debug('=====mFieldList======'+mFieldList);
                    for(Object mFieldData : mFieldList)
                    {    
                        //System.debug('=====mFieldData======'+mFieldData);
                        Map<String,Object> mField = (Map<String,Object>)mFieldData;
                        String mLabel = (String)mField.get('Label');
                        String mApi = (String)mField.get('Api');
                        String mValue = (String)mField.get('Value');
                        if(String.isNotBlank((String)mField.get('Source')))
                        {
                            //System.debug('Source');
                        }
                        else
                        {
                            //System.debug('no Source');
                        }
                        CTRRequestFormItem__c mOldItem = mOriginalRequestItemList[0];
                        if(mOldItem != null && String.isNotBlank((String)mField.get('Source')))
                        {
                            
                                SObject mObj1 = mOldItem;
                                Object mDataV1 = mObj1.get(mRequestItemFieldMap.get(mApi));
                                //if(mDataV1 != null)
                                //{
                                    editChangeFieldWrapper mChangeFieldWrapper = new editChangeFieldWrapper();
                                    mChangeFieldWrapper.mSource = (String)mField.get('Source');
                                    mChangeFieldWrapper.mLabel = mLabel;
                                    mChangeFieldWrapper.mApi = mApi;
                                    mChangeFieldWrapper.mOldValue = (mDataV1 != null)?String.valueOf(mDataV1):'';
                                    mChangeFieldWrapper.mLatestValue = (mValue != null)?String.valueOf(mValue):'';
                                    //System.debug('Item.mChangeFieldWrapper = '+mChangeFieldWrapper);
                                    mEditItemList.add(mChangeFieldWrapper);

                                    String objectName = 'CTRRequestFormItem__c';
                                    String fieldName =  mApi;

                                    Schema.DisplayType mFieldDataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType(); 
                                    String mDataType = String.valueOf(mFieldDataType);
                                    //System.debug('mDataType: '+mDataType);
                                    if(mDataType == 'REFERENCE')
                                    {
                                        //System.debug('mDataType: '+mApi);
                                        if (mDataV1 instanceOf Id) 
                                        {
                                            //System.debug('valid id'+mApi);
                                            Id mId = (Id)mDataV1;
                                            mAllIdSet.add(mId);

                                            String mObjectName = mId.getSObjectType().getDescribe().getName();
                                            //System.debug('mObjectName'+mObjectName);
                                            mObjectNameList.add(mObjectName);
                                        }
                                        if (mValue instanceOf Id) 
                                        {
                                            //System.debug('valid id'+mApi);
                                            Id mId = (Id)mValue;
                                            mAllIdSet.add(mId);

                                            String mObjectName = mId.getSObjectType().getDescribe().getName();
                                            //System.debug('mObjectName'+mObjectName);
                                            mObjectNameList.add(mObjectName);
                                        }
                                    }
                                //}
                            
                        }
                    }
                }
            }

            if(mItem.CTRRequestFormHeader__r.InternalEditField__c != null)
            {
                if(mOriginalHeader !=null)
                {
                    Map<String, Schema.SObjectField> mRequestHeaderFieldMap = Schema.getGlobalDescribe().get('CTRRequestFormHeader__c').getDescribe().fields.getMap();
                    List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mItem.CTRRequestFormHeader__r.InternalEditField__c);

                    for(Object mFieldData : mFieldList)
                    {    
                        //System.debug('=====mFieldData======'+mFieldData);
                        Map<String,Object> mField = (Map<String,Object>)mFieldData;
                        String mLabel = (String)mField.get('Label');
                        String mApi = (String)mField.get('Api');
                        String mValue = (String)mField.get('Value');
                        
                        CTRRequestFormHeader__c mOldHeader = mOriginalRequestHeaderList[0];
                        if(mOldHeader != null && String.isNotBlank((String)mField.get('Source')))
                        {
                            SObject mObj1 = mOldHeader;
                            Object mDataV1 = mObj1.get(mRequestHeaderFieldMap.get(mApi));
                            //if(mDataV1 != null)
                            //{
                                //System.debug('mRequestHeaderFieldMap.get(mApi)+'+mRequestHeaderFieldMap.get(mApi));
                                editChangeFieldWrapper mChangeFieldWrapper = new editChangeFieldWrapper();
                                mChangeFieldWrapper.mSource = (String)mField.get('Source');
                                mChangeFieldWrapper.mLabel = mLabel;
                                mChangeFieldWrapper.mApi = mApi;
                                mChangeFieldWrapper.mOldValue = (mDataV1 != null)?String.valueOf(mDataV1):'';
                                mChangeFieldWrapper.mLatestValue = (mValue != null)?String.valueOf(mValue):'';
                                //System.debug('Header.mChangeFieldWrapper = '+mChangeFieldWrapper);

                                mEditHeaderList.add(mChangeFieldWrapper);


                                String objectName = 'CTRRequestFormHeader__c';
                                String fieldName =  mApi;

                                Schema.DisplayType mFieldDataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType(); 
                                String mDataType = String.valueOf(mFieldDataType);
                                //System.debug('mDataType: '+mDataType);
                                if(mDataType == 'REFERENCE')
                                {
                                    //System.debug('mDataType: '+mApi);
                                    if (mDataV1 instanceOf Id) 
                                    {
                                        //System.debug('valid id'+mApi);
                                        Id mId = (Id)mDataV1;
                                        mAllIdSet.add(mId);

                                        String mObjectName = mId.getSObjectType().getDescribe().getName();
                                        //System.debug('mObjectName'+mObjectName);
                                        mObjectNameList.add(mObjectName);
                                    }
                                    if (mValue instanceOf Id) 
                                        {
                                            //System.debug('valid id'+mApi);
                                            Id mId = (Id)mValue;
                                            mAllIdSet.add(mId);

                                            String mObjectName = mId.getSObjectType().getDescribe().getName();
                                            //System.debug('mObjectName'+mObjectName);
                                            mObjectNameList.add(mObjectName);
                                        }
                                }
                            //}
                        }
                    }
                }
            }

            if(mObjectNameList.size()>0 && mAllIdSet.size()>0)
            {
                Map<String, Map<Id, sObject>> mObjMap = new Map<String, Map<Id, sObject>>();
                for(String mObjectName: mObjectNameList)
                {
                    String mQuery = 'SELECT ID, Name';
                    if(mObjectName == 'Master_Map__c')
                    {
                        mQuery+= ', Code__c, Description__c';
                    }
                    mQuery+= ' FROM '+mObjectName;
                    mQuery+= ' WHERE Id IN: mAllIdSet';
                    Map<Id, sObject> sObjectMap = new Map<Id, sObject>((List<sObject>)Database.query(mQuery));
                    mObjMap.put(mObjectName, sObjectMap);
                }
				//System.debug('mObjMap: '+mObjMap);
                if(mObjMap.size()>0)
                {
                    for(editChangeFieldWrapper mHeaderEdit: mEditHeaderList)
                    {
                        if(mHeaderEdit.mOldValue instanceOf Id)
                        {
                            Id mId = (Id)mHeaderEdit.mOldValue;
                            String mObjectName = mId.getSObjectType().getDescribe().getName();
                            Map<Id, sObject> mObjMapHeader = mObjMap.get(mObjectName);
                            if(mObjMapHeader.size()>0)
                            {
                                sObject mChangeObj = mObjMapHeader.get(mHeaderEdit.mOldValue);
                                if(mChangeObj != null)
                                {
                                    if(mObjectName == 'Master_Map__c')
                                    {
                                        //System.debug('mHeaderEdit.mApi:'+mHeaderEdit.mApi);
                                        if(mHeaderEdit.mApi == 'CityStateLocal__c')
                                        {
                                            //System.debug('Description__c:'+mChangeObj.get('Description__c'));
                                            mHeaderEdit.mOldValue = (mChangeObj.get('Description__c') != null)?(String)mChangeObj.get('Description__c'): '';
                                            //System.debug('mHeaderEdit.mOldValue:'+mHeaderEdit.mOldValue);
                                        }
                                        else if(mHeaderEdit.mApi == 'CityStateEN__c')
                                        {
                                            //System.debug('Name:'+mChangeObj.get('Name'));
                                            mHeaderEdit.mOldValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                            //System.debug('mHeaderEdit.mOldValue:'+mHeaderEdit.mOldValue);
                                        }
                                        else
                                        {
                                            mHeaderEdit.mOldValue = (mChangeObj.get('Code__c')!= null)?(String)mChangeObj.get('Code__c'): '';
                                            
                                        }
                                    }
                                    else
                                    {
                                        mHeaderEdit.mOldValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                    }
                                }
                            }

                        }
                        if(mHeaderEdit.mLatestValue instanceOf Id)
                        {
                            Id mId = (Id)mHeaderEdit.mLatestValue;
                            String mObjectName = mId.getSObjectType().getDescribe().getName();
                            Map<Id, sObject> mObjMapHeader = mObjMap.get(mObjectName);
                            if(mObjMapHeader.size()>0)
                            {
                                sObject mChangeObj = mObjMapHeader.get(mHeaderEdit.mLatestValue);
                                if(mChangeObj != null)
                                {
                                    if(mObjectName == 'Master_Map__c')
                                    {
                                        //System.debug('mHeaderEdit.mApi:'+mHeaderEdit.mApi);
                                        if(mHeaderEdit.mApi == 'CityStateLocal__c')
                                        {
                                            //System.debug('Description__c:'+mChangeObj.get('Description__c'));
                                            mHeaderEdit.mLatestValue = (mChangeObj.get('Description__c') != null)?(String)mChangeObj.get('Description__c'): '';
                                            //System.debug('mHeaderEdit.mLatestValue:'+mHeaderEdit.mLatestValue);
                                        }
                                        else if(mHeaderEdit.mApi == 'CityStateEN__c')
                                        {
                                            //System.debug('Name:'+mChangeObj.get('Name'));
                                            mHeaderEdit.mLatestValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                            //System.debug('mHeaderEdit.mLatestValue:'+mHeaderEdit.mLatestValue);
                                        }
                                        else
                                        {
                                            mHeaderEdit.mLatestValue = (mChangeObj.get('Code__c')!= null)?(String)mChangeObj.get('Code__c'): '';
                                        }
                                    }
                                    else
                                    {
                                        mHeaderEdit.mLatestValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                    }
                                }
                            }

                        }
                        //System.debug('mHeaderEditChanged:'+mHeaderEdit);
                    }
                    for(editChangeFieldWrapper mItemEdit: mEditItemList)
                    {
                        //System.debug(mItemEdit.mApi);
                        if(mItemEdit.mOldValue instanceOf Id)
                        {
                            Id mId = (Id)mItemEdit.mOldValue;
                            String mObjectName = mId.getSObjectType().getDescribe().getName();
                            Map<Id, sObject> mObjMapItem = mObjMap.get(mObjectName);
                            if(mObjMapItem.size()>0)
                            {
                                //System.debug('mApi:'+mItemEdit.mApi);
                                sObject mChangeObj = mObjMapItem.get(mItemEdit.mOldValue);
                                //System.debug('Item mChangeObj:'+mChangeObj);
                                if(mChangeObj != null)
                                {
                                    if(mObjectName == 'Master_Map__c')
                                    {
                                        mItemEdit.mOldValue = (mChangeObj.get('Code__c') != null)?(String)mChangeObj.get('Code__c'): '';
                                    }
                                    else
                                    {
                                        mItemEdit.mOldValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                    }
                                }
                            }
                        }
                        if(mItemEdit.mLatestValue instanceOf Id)
                        {
                            Id mId = (Id)mItemEdit.mLatestValue;
                            String mObjectName = mId.getSObjectType().getDescribe().getName();
                            Map<Id, sObject> mObjMapItem = mObjMap.get(mObjectName);
                            if(mObjMapItem.size()>0)
                            {
                                sObject mChangeObj = mObjMapItem.get(mItemEdit.mLatestValue);
                                if(mChangeObj != null)
                                {
                                    if(mObjectName == 'Master_Map__c')
                                    {
                                        mItemEdit.mLatestValue = (mChangeObj.get('Code__c') != null)?(String)mChangeObj.get('Code__c'): '';
                                    }
                                    else
                                    {
                                        mItemEdit.mLatestValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                    }
                                    
                                }
                            }
                        }
                        //System.debug('mItemEditEditChanged:'+mItemEdit);
                    }
                }
            }
            List<editChangeFieldWrapper> mAllEditList = new List<editChangeFieldWrapper>();
            mAllEditList.addAll(mEditHeaderList);
            mAllEditList.addAll(mEditItemList);
            editLevelWrapper mLevelWrapper = new editLevelWrapper();
            mLevelWrapper.mItemEditList =mEditItemList;
            mLevelWrapper.mHeaderEditList = mEditHeaderList;
            mLevelWrapper.mAllEditList = mAllEditList;

            return mLevelWrapper;
        }
        catch(exception e)
        {
            //System.debug('error from editlog line: '+e.getLineNumber()+' || message: '+e.getmessage());
            return new editLevelWrapper();
        }
    }*/

    /*public static Map<String, String> manageDestinationCountryToJson(Set<Id> mItemSetId)
    {
        try
        {
            Map<String, String> mCountryJsonMap = new Map<String, String>();
            List<CTRShippingCountry__c> mCountryList = [SELECT Id, ShippingCountry__c, LocationType__c, CTRRequestFormItem__c FROM CTRShippingCountry__c WHERE CTRRequestFormItem__c IN: mItemSetId];
               
            if(mCountryList.size()>0)
            {
                for(Id mItemId: mItemSetId)
                {
                    List<Map<String, String>> mCountryConvertList = new List<Map<String, String>>();
                    
                    for(CTRShippingCountry__c mCountry: mCountryList)
                    {
                        if(mCountry.CTRRequestFormItem__c == mItemId)
                        {
                            Map<String, String> mCountryMap = new Map<String, String>();
                            mCountryMap.put('CTRRequestFormItem__c', mCountry.CTRRequestFormItem__c);
                            mCountryMap.put('LocationType__c', mCountry.LocationType__c);
                            mCountryMap.put('ShippingCountry__c', mCountry.ShippingCountry__c);
                            mCountryConvertList.add(mCountryMap);
                        }
                    }
                    if(mCountryConvertList.size()>0)
                    {
                        String mCountryJson = JSON.serialize(mCountryConvertList);
                        mCountryJson = mCountryJson.replace('null', '""');
                        //System.debug('mCountryJson: '+mCountryJson);
                        mCountryJsonMap.put(mItemId, mCountryJson);
                    }
                }
            }
            return mCountryJsonMap;
        }
        catch(exception e)
        {
            //System.debug('Error from manageDestinationCountryJson line:'+e.getLineNumber()+' || Message: '+e.getMessage());
            return new Map<String, String>();
        }
    }

    public static Map<String, String> manageShareholderToJson(Set<Id> mHeaderSetId)
    {
        try
        {
            Map<String, String> mShareholderJsonMap = new Map<String, String>();
            List<CTRShareholder__c> mShareHolderList = [SELECT Id, Name, of_Shareholder__c, CTRRequestFormHeader__c FROM CTRShareholder__c WHERE CTRRequestFormHeader__c IN: mHeaderSetId];
            if(mShareHolderList.size()>0)
            {
                for(Id mHeaderId: mHeaderSetId)
                {
                    List<Map<String, String>> mShareholderConvertList = new List<Map<String, String>>();
                    
                    for(CTRShareholder__c mShareholder: mShareHolderList)
                    {
                        if(mShareholder.CTRRequestFormHeader__c == mHeaderId)
                        {
                            Map<String, String> mShareholderMap = new Map<String, String>();
                            mShareholderMap.put('CTRRequestFormHeader__c', mShareholder.CTRRequestFormHeader__c);
                            mShareholderMap.put('Name', mShareholder.Name);
                            mShareholderMap.put('of_Shareholder__c', mShareholder.of_Shareholder__c+'%');
                            mShareholderConvertList.add(mShareholderMap);
                        }
                    }
                    if(mShareholderConvertList.size()>0)
                    {
                        String mShareholderJson = JSON.serialize(mShareholderConvertList);
                        mShareholderJson = mShareholderJson.replace('null', '""');
                        //System.debug('mCountryJson: '+mShareholderJson);
                        mShareholderJsonMap.put(mHeaderId, mShareholderJson);
                    }
                }
            }
            return mShareholderJsonMap;
        }
        catch(exception e)
        {
            //System.debug('Error from manageShareholderToJson line:'+e.getLineNumber()+' || Message: '+e.getMessage());
            return new Map<String, String>();
        }
    }*/

    /*@AuraEnabled
    public static editLevelWrapper onload(Id mRecordId)
    {
        try
        {
            CTRRequestFormItem__c mItem;
            CTRRequestFormItem__c mOriginalItem;
            CTRRequestFormHeader__c mHeader;
            CTRRequestFormHeader__c mOriginalHeader;
            List<CTRRequestFormItem__c> mOriginalRequestItemList = new List<CTRRequestFormItem__c>();
            List<CTRRequestFormHeader__c>mOriginalRequestHeaderList =  new List<CTRRequestFormHeader__c>();
            List<editChangeFieldWrapper> mEditItemList = new List<editChangeFieldWrapper>();
            List<editChangeFieldWrapper> mEditHeaderList = new List<editChangeFieldWrapper>();
            Set<Id> mItemSetId = new Set<ID>();
            mItemSetId.add(mRecordId);
            List<CTRRequestFormItem__c> mRequestItemList = [SELECT Id, OriginalRequestFormItem__c, CTRRequestFormHeader__c, 
                                                            CTRRequestFormHeader__r.OriginalRequestFormHeader__c, CTRRequestFormHeader__r.InternalEditField__c, 
                                                            InternalEditField__c, RecordTypeId, RecordType.DeveloperName  
                                                            FROM CTRRequestFormItem__c WHERE Id =:mRecordId LIMIT 1];//CTRCommitteeSendToSap.geRequestItemForSendToSAP(mItemSetId);

            Set<String> mObjectNameList = new Set<String>();
            Set<Id> mAllIdSet = new Set<Id>();

            if(mRequestItemList.size()>0)
            {
                mItem = mRequestItemList[0];

                if(mItem.OriginalRequestFormItem__c != null)
                {
                    Set<Id> mOriginalItemSetId = new Set<ID>();
                    mOriginalItemSetId.add(mItem.OriginalRequestFormItem__c);
                    mOriginalRequestItemList = CTRCommitteeSendToSap.geRequestItemForSendToSAP(mOriginalItemSetId);
                    if(mOriginalRequestItemList.size()>0)
                    {
                        mOriginalItem = mOriginalRequestItemList[0];
                    }
                }
                if(mItem.CTRRequestFormHeader__c != null && mItem.CTRRequestFormHeader__r.OriginalRequestFormHeader__c != null)
                {
                    Set<Id> mOriginalItemSetId = new Set<ID>();
                    mOriginalItemSetId.add(mItem.CTRRequestFormHeader__r.OriginalRequestFormHeader__c);
                    mOriginalRequestHeaderList = CTRCommitteeSendToSap.geRequestHeaderForSendToSAP(mOriginalItemSetId);
                    if(mOriginalRequestHeaderList.size()>0)
                    {
                        mOriginalHeader = mOriginalRequestHeaderList[0];
                    }
                }

            }
            if(mItem.InternalEditField__c != null)
            {
                if(mOriginalItem != null)
                {
                    Map<String, Schema.SObjectField> mRequestItemFieldMap = Schema.getGlobalDescribe().get('CTRRequestFormItem__c').getDescribe().fields.getMap();
                    List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mItem.InternalEditField__c);

                    //System.debug('=====mFieldList======'+mFieldList);
                    for(Object mFieldData : mFieldList)
                    {    
                        //System.debug('=====mFieldData======'+mFieldData);
                        Map<String,Object> mField = (Map<String,Object>)mFieldData;
                        String mLabel = (String)mField.get('Label');
                        String mApi = (String)mField.get('Api');
                        String mValue = (String)mField.get('Value');
                        if(String.isNotBlank((String)mField.get('Source')))
                        {
                            //System.debug('Source');
                        }
                        else
                        {
                            //System.debug('no Source');
                        }
                        CTRRequestFormItem__c mOldItem = mOriginalRequestItemList[0];
                        if(mOldItem != null && String.isNotBlank((String)mField.get('Source')))
                        {
                            
                                SObject mObj1 = mOldItem;
                                Object mDataV1 = mObj1.get(mRequestItemFieldMap.get(mApi));
                                //if(mDataV1 != null)
                                //{
                                    editChangeFieldWrapper mChangeFieldWrapper = new editChangeFieldWrapper();
                                    mChangeFieldWrapper.mSource = (String)mField.get('Source');
                                    mChangeFieldWrapper.mLabel = mLabel;
                                    mChangeFieldWrapper.mApi = mApi;
                                    mChangeFieldWrapper.mOldValue = (mDataV1 != null)?String.valueOf(mDataV1):'';
                                    mChangeFieldWrapper.mLatestValue = (mValue != null)?String.valueOf(mValue):'';
                                    //System.debug('Item.mChangeFieldWrapper = '+mChangeFieldWrapper);
                                    mEditItemList.add(mChangeFieldWrapper);

                                    // String objectName = 'CTRRequestFormItem__c';
                                    // String fieldName =  mApi;

                                    // Schema.DisplayType mFieldDataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType(); 
                                    // String mDataType = String.valueOf(mFieldDataType);
                                    // //System.debug('mDataType: '+mDataType);
                                    // if(mDataType == 'REFERENCE')
                                    // {
                                    //     //System.debug('mDataType: '+mApi);
                                    //     if (mDataV1 instanceOf Id) 
                                    //     {
                                    //         //System.debug('valid id'+mApi);
                                    //         Id mId = (Id)mDataV1;
                                    //         mAllIdSet.add(mId);

                                    //         String mObjectName = mId.getSObjectType().getDescribe().getName();
                                    //         //System.debug('mObjectName'+mObjectName);
                                    //         mObjectNameList.add(mObjectName);
                                    //     }
                                    //     if (mValue instanceOf Id) 
                                    //     {
                                    //         //System.debug('valid id'+mApi);
                                    //         Id mId = (Id)mValue;
                                    //         mAllIdSet.add(mId);

                                    //         String mObjectName = mId.getSObjectType().getDescribe().getName();
                                    //         //System.debug('mObjectName'+mObjectName);
                                    //         mObjectNameList.add(mObjectName);
                                    //     }
                                    // }

                                //}
                            
                        }
                    }
                }
            }

            if(mItem.CTRRequestFormHeader__r.InternalEditField__c != null)
            {
                if(mOriginalHeader !=null)
                {
                    Map<String, Schema.SObjectField> mRequestHeaderFieldMap = Schema.getGlobalDescribe().get('CTRRequestFormHeader__c').getDescribe().fields.getMap();
                    List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mItem.CTRRequestFormHeader__r.InternalEditField__c);

                    for(Object mFieldData : mFieldList)
                    {    
                        //System.debug('=====mFieldData======'+mFieldData);
                        Map<String,Object> mField = (Map<String,Object>)mFieldData;
                        String mLabel = (String)mField.get('Label');
                        String mApi = (String)mField.get('Api');
                        String mValue = (String)mField.get('Value');
                        
                        CTRRequestFormHeader__c mOldHeader = mOriginalRequestHeaderList[0];
                        if(mOldHeader != null && String.isNotBlank((String)mField.get('Source')))
                        {
                            SObject mObj1 = mOldHeader;
                            Object mDataV1 = mObj1.get(mRequestHeaderFieldMap.get(mApi));
                            //if(mDataV1 != null)
                            //{
                                //System.debug('mRequestHeaderFieldMap.get(mApi)+'+mRequestHeaderFieldMap.get(mApi));
                                editChangeFieldWrapper mChangeFieldWrapper = new editChangeFieldWrapper();
                                mChangeFieldWrapper.mSource = (String)mField.get('Source');
                                mChangeFieldWrapper.mLabel = mLabel;
                                mChangeFieldWrapper.mApi = mApi;
                                mChangeFieldWrapper.mOldValue = (mDataV1 != null)?String.valueOf(mDataV1):'';
                                mChangeFieldWrapper.mLatestValue = (mValue != null)?String.valueOf(mValue):'';
                                //System.debug('Header.mChangeFieldWrapper = '+mChangeFieldWrapper);

                                mEditHeaderList.add(mChangeFieldWrapper);


                                // String objectName = 'CTRRequestFormHeader__c';
                                // String fieldName =  mApi;

                                // Schema.DisplayType mFieldDataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType(); 
                                // String mDataType = String.valueOf(mFieldDataType);
                                // //System.debug('mDataType: '+mDataType);
                                // if(mDataType == 'REFERENCE')
                                // {
                                //     //System.debug('mDataType: '+mApi);
                                //     if (mDataV1 instanceOf Id) 
                                //     {
                                //         //System.debug('valid id'+mApi);
                                //         Id mId = (Id)mDataV1;
                                //         mAllIdSet.add(mId);

                                //         String mObjectName = mId.getSObjectType().getDescribe().getName();
                                //         //System.debug('mObjectName'+mObjectName);
                                //         mObjectNameList.add(mObjectName);
                                //     }
                                //     if (mValue instanceOf Id) 
                                //         {
                                //             //System.debug('valid id'+mApi);
                                //             Id mId = (Id)mValue;
                                //             mAllIdSet.add(mId);

                                //             String mObjectName = mId.getSObjectType().getDescribe().getName();
                                //             //System.debug('mObjectName'+mObjectName);
                                //             mObjectNameList.add(mObjectName);
                                //         }
                                // }

                            //}
                        }
                    }
                }
            }

            // if(mObjectNameList.size()>0 && mAllIdSet.size()>0)
            // {
            //     Map<String, Map<Id, sObject>> mObjMap = new Map<String, Map<Id, sObject>>();
            //     for(String mObjectName: mObjectNameList)
            //     {
            //         String mQuery = 'SELECT ID, Name';
            //         if(mObjectName == 'Master_Map__c')
            //         {
            //             mQuery+= ', Code__c, Description__c';
            //         }
            //         mQuery+= ' FROM '+mObjectName;
            //         mQuery+= ' WHERE Id IN: mAllIdSet';
            //         Map<Id, sObject> sObjectMap = new Map<Id, sObject>((List<sObject>)Database.query(mQuery));
            //         mObjMap.put(mObjectName, sObjectMap);
            //     }
			// 	//System.debug('mObjMap: '+mObjMap);
            //     if(mObjMap.size()>0)
            //     {
            //         for(editChangeFieldWrapper mHeaderEdit: mEditHeaderList)
            //         {
            //             if(mHeaderEdit.mOldValue instanceOf Id)
            //             {
            //                 Id mId = (Id)mHeaderEdit.mOldValue;
            //                 String mObjectName = mId.getSObjectType().getDescribe().getName();
            //                 Map<Id, sObject> mObjMapHeader = mObjMap.get(mObjectName);
            //                 if(mObjMapHeader.size()>0)
            //                 {
            //                     sObject mChangeObj = mObjMapHeader.get(mHeaderEdit.mOldValue);
            //                     if(mChangeObj != null)
            //                     {
            //                         if(mObjectName == 'Master_Map__c')
            //                         {
            //                             //System.debug('mHeaderEdit.mApi:'+mHeaderEdit.mApi);
            //                             if(mHeaderEdit.mApi == 'CityStateLocal__c')
            //                             {
            //                                 //System.debug('Description__c:'+mChangeObj.get('Description__c'));
            //                                 mHeaderEdit.mOldValue = (mChangeObj.get('Description__c') != null)?(String)mChangeObj.get('Description__c'): '';
            //                                 //System.debug('mHeaderEdit.mOldValue:'+mHeaderEdit.mOldValue);
            //                             }
            //                             else if(mHeaderEdit.mApi == 'CityStateEN__c')
            //                             {
            //                                 //System.debug('Name:'+mChangeObj.get('Name'));
            //                                 mHeaderEdit.mOldValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
            //                                 //System.debug('mHeaderEdit.mOldValue:'+mHeaderEdit.mOldValue);
            //                             }
            //                             else
            //                             {
            //                                 mHeaderEdit.mOldValue = (mChangeObj.get('Code__c')!= null)?(String)mChangeObj.get('Code__c'): '';
                                            
            //                             }
            //                         }
            //                         else
            //                         {
            //                             mHeaderEdit.mOldValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
            //                         }
            //                     }
            //                 }

            //             }
            //             if(mHeaderEdit.mLatestValue instanceOf Id)
            //             {
            //                 Id mId = (Id)mHeaderEdit.mLatestValue;
            //                 String mObjectName = mId.getSObjectType().getDescribe().getName();
            //                 Map<Id, sObject> mObjMapHeader = mObjMap.get(mObjectName);
            //                 if(mObjMapHeader.size()>0)
            //                 {
            //                     sObject mChangeObj = mObjMapHeader.get(mHeaderEdit.mLatestValue);
            //                     if(mChangeObj != null)
            //                     {
            //                         if(mObjectName == 'Master_Map__c')
            //                         {
            //                             //System.debug('mHeaderEdit.mApi:'+mHeaderEdit.mApi);
            //                             if(mHeaderEdit.mApi == 'CityStateLocal__c')
            //                             {
            //                                 //System.debug('Description__c:'+mChangeObj.get('Description__c'));
            //                                 mHeaderEdit.mLatestValue = (mChangeObj.get('Description__c') != null)?(String)mChangeObj.get('Description__c'): '';
            //                                 //System.debug('mHeaderEdit.mLatestValue:'+mHeaderEdit.mLatestValue);
            //                             }
            //                             else if(mHeaderEdit.mApi == 'CityStateEN__c')
            //                             {
            //                                 //System.debug('Name:'+mChangeObj.get('Name'));
            //                                 mHeaderEdit.mLatestValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
            //                                 //System.debug('mHeaderEdit.mLatestValue:'+mHeaderEdit.mLatestValue);
            //                             }
            //                             else
            //                             {
            //                                 mHeaderEdit.mLatestValue = (mChangeObj.get('Code__c')!= null)?(String)mChangeObj.get('Code__c'): '';
            //                             }
            //                         }
            //                         else
            //                         {
            //                             mHeaderEdit.mLatestValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
            //                         }
            //                     }
            //                 }

            //             }
            //             //System.debug('mHeaderEditChanged:'+mHeaderEdit);
            //         }
            //         for(editChangeFieldWrapper mItemEdit: mEditItemList)
            //         {
            //             //System.debug(mItemEdit.mApi);
            //             if(mItemEdit.mOldValue instanceOf Id)
            //             {
            //                 Id mId = (Id)mItemEdit.mOldValue;
            //                 String mObjectName = mId.getSObjectType().getDescribe().getName();
            //                 Map<Id, sObject> mObjMapItem = mObjMap.get(mObjectName);
            //                 if(mObjMapItem.size()>0)
            //                 {
            //                     //System.debug('mApi:'+mItemEdit.mApi);
            //                     sObject mChangeObj = mObjMapItem.get(mItemEdit.mOldValue);
            //                     //System.debug('Item mChangeObj:'+mChangeObj);
            //                     if(mChangeObj != null)
            //                     {
            //                         if(mObjectName == 'Master_Map__c')
            //                         {
            //                             mItemEdit.mOldValue = (mChangeObj.get('Code__c') != null)?(String)mChangeObj.get('Code__c'): '';
            //                         }
            //                         else
            //                         {
            //                             mItemEdit.mOldValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
            //                         }
            //                     }
            //                 }
            //             }
            //             if(mItemEdit.mLatestValue instanceOf Id)
            //             {
            //                 Id mId = (Id)mItemEdit.mLatestValue;
            //                 String mObjectName = mId.getSObjectType().getDescribe().getName();
            //                 Map<Id, sObject> mObjMapItem = mObjMap.get(mObjectName);
            //                 if(mObjMapItem.size()>0)
            //                 {
            //                     sObject mChangeObj = mObjMapItem.get(mItemEdit.mLatestValue);
            //                     if(mChangeObj != null)
            //                     {
            //                         if(mObjectName == 'Master_Map__c')
            //                         {
            //                             mItemEdit.mLatestValue = (mChangeObj.get('Code__c') != null)?(String)mChangeObj.get('Code__c'): '';
            //                         }
            //                         else
            //                         {
            //                             mItemEdit.mLatestValue = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
            //                         }
                                    
            //                     }
            //                 }
            //             }
            //             //System.debug('mItemEditEditChanged:'+mItemEdit);
            //         }
            //     }
            // }
            List<editChangeFieldWrapper> mAllEditList = new List<editChangeFieldWrapper>();
            mAllEditList.addAll(mEditHeaderList);
            mAllEditList.addAll(mEditItemList);
            editLevelWrapper mLevelWrapper = new editLevelWrapper();
            mLevelWrapper.mItemEditList =mEditItemList;
            mLevelWrapper.mHeaderEditList = mEditHeaderList;
            mLevelWrapper.mAllEditList = mAllEditList;

            return mLevelWrapper;
        }
        catch(exception e)
        {
            //System.debug('error from editlog line: '+e.getLineNumber()+' || message: '+e.getmessage());
            return new editLevelWrapper();
        }
    }*/
}