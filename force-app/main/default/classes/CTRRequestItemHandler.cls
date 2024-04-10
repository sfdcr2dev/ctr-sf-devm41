public with sharing class CTRRequestItemHandler 
{
    public static Boolean firstRunRequestItemComplete = false;

    public static void populateDataBeforeInsert(List<CTRRequestFormItem__c> mRequestItemList)
    {
        try
        {
            for(CTRRequestFormItem__c mItem: mRequestItemList)
            {
                if(mItem.Customer__c != null)
                {
                    mItem.Status__c = 'New';
                    mItem.Approval_Step__c = 'Open';
                    mItem.OrderCombination__c = false;
                    mItem.Rebate__c = true;
                    mItem.Chkdoubleinv__c = true;
                    mItem.IsPriceDetermin__c = true;
                    mItem.automaticPurchaseOrder__c = true;
                    mItem.GRBasedInvVerif__c = true;
                }
            }
        }
        catch(exception e)
        {
            System.debug('Error from CTRRequestItemHandler.populateDataBeforeInsert Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }
    
    public static void SendSalesView_AfterUpdate(Map<Id, CTRRequestFormItem__c> mRequestItemOldMap, Map<Id, CTRRequestFormItem__c> mRequestItemNewMap)
    {
        try
        {
            Set<Id> mHeaderSetId = new Set<Id>();
            Set<Id> mItemSetId = new Set<Id>();
            List<CTRRequestFormItem__c> mRequestItemList = new List<CTRRequestFormItem__c>();
            for(CTRRequestFormItem__c mItem: mRequestItemNewMap.values())
            {
                System.debug(mItem.CTRRequestFormHeader__c);
                System.debug(mItem.Message__c);

                if(mItem.CTRRequestFormHeader__c != null)
                {
                    CTRRequestFormItem__c mOldItem = mRequestItemOldMap.get(mItem.Id);
                    if(mItem.SAPStatus__c != mOldItem.SAPStatus__c)
                    {
                        if(mItem.SAPStatus__c == 'Send Sales/Purchasing View To SAP' && mOldItem.SAPStatus__c == 'Pending CCA')
                        {
                            mRequestItemList.add(mItem);
                            mItemSetId.add(mItem.Id);
                            mHeaderSetId.add(mItem.CTRRequestFormHeader__c);
                        }
                    }
                }
            }
            if(mRequestItemList.size()>0)
            {
                CTRIntegraionList__mdt mIntegration = CTRIntegraionList__mdt.getInstance('CTRCustomer');
                if(mIntegration != null)
                {
                    List<CTRRequestFormItem__c> mGetRequestItemList = CTRCommitteeSendToSap.geRequestItemForSendToSAP(mItemSetId);
                    List<CTRRequestFormHeader__c> mGetHeaderList = CTRCommitteeSendToSap.geRequestHeaderForSendToSAP(mHeaderSetId);
                    List<CTRRequestFormItem__c> mRequestItemFilteredList = new List<CTRRequestFormItem__c> ();
                    Map<Id, CTRRequestFormHeader__c> mHeaderItemMap = new Map<Id, CTRRequestFormHeader__c>();
                    Set<String>mProfileNameSet = new Set<String>();
                    for(CTRRequestFormItem__c mItem: mGetRequestItemList)
                    {
                        if(mItem.RecordType.DeveloperName.contains('Customer'))
                        {
                            for(CTRRequestFormHeader__c mHeader: mGetHeaderList)
                            {
                                if(mHeader.Id == mItem.CTRRequestFormHeader__c)
                                {
                                    mHeaderItemMap.put(mItem.Id, mHeader);
                                    
                                }
                            }
                            mRequestItemFilteredList.add(mItem);
                            mProfileNameSet.add(mItem.Owner.Profile.Name);
                        }
                    }
                    C360Integration__c mSetting = C360Integration__c.getInstance();

                    List<CTRBuProfile__mdt> mBuProfileList = [SELECT Id, MasterLabel, DeveloperName, BusinessUnit__c ,ReassignTask_Section_Name__c, VPSectionName__c, Language__c,Edit_Button_Name__c, Section_Credit_Condition__c
                                                                FROM CTRBuProfile__mdt WHERE MasterLabel IN :mProfileNameSet];  

                    for(CTRRequestFormItem__c mItem: mRequestItemFilteredList)
                    {
                        CTRRequestFormHeader__c mHeader = mHeaderItemMap.get(mItem.Id);

                        if(mHeader != null)
                        {
                            String mBuProfile = 'TOP';
                            String IntegrationType = 'Sale';
                            for(CTRBuProfile__mdt mBu: mBuProfileList)
                            {
                                if(mItem.Owner.Profile.Name == mBu.MasterLabel)
                                {
                                    mBuProfile = mBu.BusinessUnit__c;
                                }
                            }
                            String mGatewayId = (mItem.GatewayId__c != null)?mItem.GatewayId__c: Uuid.randomUUID();
                            CTRCustomerRequestFormItemModelData mCustomerData = CTRCustomerRequestFormItemModelData.SetupJsonForCustomerDataModel(mHeader, mItem, IntegrationType, mItem.BusinessUnit__c, mGatewayId);

                            //String mGatewayId = mCustomerData.input.input.GatewayId;
                            if(mCustomerData != null)
                            {
                                String mJson = JSON.serialize(mCustomerData);
                                mJson = mJson.replace('null', '""');
                                System.debug('mJson: '+mJson);
                                
                                system.enqueuejob(new CTRTriggerWebServiceQueueable(mJson, mIntegration.Token__c, mSetting.HerokuIntegrationDomain__c+mIntegration.Path__c, IntegrationType, mItem.Id, mGatewayId));
                            }

                        }
                    }
                }
            }
        }
        catch(exception e)
        {
            System.debug('Error from CTRRequestItemHandler.SendSalesView_AfterUpdate Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void CalloutCDDAndNewsAfterUpdate(Map<Id, CTRRequestFormItem__c> mRequestItemOldMap, Map<Id, CTRRequestFormItem__c> mRequestItemNewMap)
    {
        try
        {
            List<CTRRequestFormItem__c>mItemList = new List<CTRRequestFormItem__c>();
            for(CTRRequestFormItem__c mItem: mRequestItemNewMap.values())
            {
                if(mItem.CTRRequestFormHeader__c != null)
                {
                    if((mItem.CallOutCDD__c == true && (mItem.CallOutCDD__c != mRequestItemOldMap.get(mItem.Id).CallOutCDD__c))||
                    (mItem.CallOutNews__c == true && (mItem.CallOutNews__c != mRequestItemOldMap.get(mItem.Id).CallOutNews__c)))
                    {
                        mItemList.add(mItem);
                    }
                }
                
            }
            if(mItemList.size()>0)
            {
                C360Integration__c mSetting = C360Integration__c.getInstance();
                List<CTRIntegraionList__mdt > mIntegrationList = [SELECT Id,MasterLabel, DeveloperName, Endpoint__c, Token__c, Path__c 
                                                                FROM CTRIntegraionList__mdt 
                                                                WHERE DeveloperName = 'CTRiRPARequestSanction' OR DeveloperName = 'CTRiRPARequestNews' OR DeveloperName = 'CTRiRPASendNaccInfo'];
                Map<String, CTRIntegraionList__mdt> mIntegrationMap = new Map<String, CTRIntegraionList__mdt>();
                for(CTRIntegraionList__mdt mIntegration: mIntegrationList)
                {
                    mIntegrationMap.put(mIntegration.DeveloperName, mIntegration);
                }
                
                if(mIntegrationMap.size()>0)
                {
                    String mToken = '';
                    String mEndPoint = '';
                    Map<String, List<Map<String, String>>>mIntegrationDataMapList = new Map<String, List<Map<String, String>>>();
                    List<Map<String, String>>mIntegrationDataList = new List<Map<String, String>>();
                    for(CTRRequestFormItem__c mItem: mItemList)
                    {
                        String mSendType = '';
                        
                        if(mItem.CallOutCDD__c == true && (mItem.CallOutCDD__c != mRequestItemOldMap.get(mItem.Id).CallOutCDD__c))
                        {
                            CTRIntegraionList__mdt mIntegrationCDD = mIntegrationMap.get('CTRiRPARequestSanction');
                            if(String.isNotBlank(mIntegrationCDD.Path__c) && String.isNotBlank(mIntegrationCDD.Token__c))
                            {
                                Map<String, String> mIntegrationDataMap = new Map<String, String>();
                                mIntegrationDataMap.put('mSendType', 'CDD');
                                mIntegrationDataMap.put('mToken',mIntegrationCDD.Token__c);
                                mIntegrationDataMap.put('mEndPoint',mSetting.HerokuIntegrationDomain__c+mIntegrationCDD.Path__c);
                                mIntegrationDataList.add(mIntegrationDataMap);
                                //mIntegrationDataMap.put('mToken',mIntegrationCDD.Token__c);
                            }
                            // mSendType = 'CDD';
                            // mEndPoint = (mIntegrationCDD.Path__c != null)?mSetting.HerokuIntegrationDomain__c+mIntegrationCDD.Path__c:'';
                            // mToken = mIntegrationCDD.Token__c;

                            CTRIntegraionList__mdt mIntegrationNACC = mIntegrationMap.get('CTRiRPASendNaccInfo');
                            if(String.isNotBlank(mIntegrationNACC.Path__c) && String.isNotBlank(mIntegrationNACC.Token__c))
                            {
                                Map<String, String> mIntegrationDataMap = new Map<String, String>();
                                mIntegrationDataMap.put('mSendType', 'NACC');
                                mIntegrationDataMap.put('mToken',mIntegrationNACC.Token__c);
                                mIntegrationDataMap.put('mEndPoint',mSetting.HerokuIntegrationDomain__c+mIntegrationNACC.Path__c);
                                mIntegrationDataList.add(mIntegrationDataMap);
                                //mIntegrationDataMap.put('mToken',mIntegramIntegrationNACCtion.Token__c);
                            }
                        }
                        if(mItem.CallOutNews__c == true && (mItem.CallOutNews__c != mRequestItemOldMap.get(mItem.Id).CallOutNews__c))
                        {
                            CTRIntegraionList__mdt mIntegrationNews = mIntegrationMap.get('CTRiRPARequestNews');
                            // mSendType = 'News';
                            // mEndPoint = (mIntegration.Path__c != null)?mSetting.HerokuIntegrationDomain__c+mIntegration.Path__c:'';
                            // mToken = mIntegration.Token__c;
                            if(String.isNotBlank(mIntegrationNews.Path__c) && String.isNotBlank(mIntegrationNews.Token__c))
                            {
                                Map<String, String> mIntegrationDataMap = new Map<String, String>();
                                mIntegrationDataMap.put('mSendType', 'News');
                                mIntegrationDataMap.put('mToken',mIntegrationNews.Token__c);
                                mIntegrationDataMap.put('mEndPoint',mSetting.HerokuIntegrationDomain__c+mIntegrationNews.Path__c);
                                mIntegrationDataList.add(mIntegrationDataMap);
                                //mIntegrationDataMap.put('mToken',mIntegrationNews.Token__c);
                            }
                        }
                        if(mIntegrationDataList.size()>0)
                        {
                            mIntegrationDataMapList.put(mItem.Id, mIntegrationDataList);
                        }
                        
                        /*if(String.isNotBlank(mToken) && String.isNotBlank(mEndPoint))
                        {
                            String mGatewayId = Uuid.randomUUID();
                            String mBody = '{"request_header" : "'+mItem.CTRRequestFormHeader__c+'", "GatewayId" : "'+mGatewayId+'"}';
                            system.enqueuejob(new CTRTriggerWebServiceQueueable(mBody, mToken, mEndPoint, mSendType, mItem.Id, mGatewayId));
                        }*/
                    }
                    if(mIntegrationDataMapList.size()>0)
                    {
                        for(CTRRequestFormItem__c mItem: mItemList)
                        {
                            List<Map<String, String>> mCallOutList = mIntegrationDataMapList.get(mItem.Id);
                            if(mCallOutList != null && mCallOutList.size()>0)
                            {
                                for(Map<String, String> mMap: mCallOutList)
                                {
                                    String mGatewayId = Uuid.randomUUID();
                                    String mBody = '{"request_header" : "'+mItem.CTRRequestFormHeader__c+'", "GatewayId" : "'+mGatewayId+'"}';
                                    system.enqueuejob(new CTRTriggerWebServiceQueueable(mBody, mMap.get('mToken'), mMap.get('mEndPoint'), mMap.get('mSendType'), mItem.Id, mGatewayId));
                                }
                                
                            }
                        }
                    }
                }
                
            }
        }
        catch(exception e)
        {
            System.debug('Error from CTRRequestHeaderHandler.CalloutCDDAndNewsAfterUpdate Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void setQueueToPendingCcaAfterUpdate(Map<Id, CTRRequestFormItem__c> mRequestItemOldMap, Map<Id, CTRRequestFormItem__c> mRequestItemNewMap)
    {
        try
        {
            Set<Id> mCustomerSetId = new Set<Id>();
            Set<Id> mItemSetId = new Set<Id>();
            Set<String> mSalesOrgSet = new Set<String>();
            List<CTRRequestFormItem__c> mRequestItemList = new List<CTRRequestFormItem__c>();
            for(CTRRequestFormItem__c mItem: mRequestItemNewMap.values())
            {
                System.debug(mItem.CTRRequestFormHeader__c);
                System.debug(mItem.Message__c);

                if(mItem.Customer__c != null && mItem.RecordTypeName__c.contains('Customer') && mItem.SalesOrganization__c != null)
                {
                    CTRRequestFormItem__c mOldItem = mRequestItemOldMap.get(mItem.Id);
                    if(mItem.SAPStatus__c != mOldItem.SAPStatus__c)
                    {
                        if(mItem.SAPStatus__c == 'SAP Confirmed Sales/Purchasing View')
                        {
                            mRequestItemList.add(mItem);
                            mSalesOrgSet.add(mItem.SalesOrganization__c);
                            mItemSetId.add(mItem.Id);
                            mCustomerSetId.add(mItem.Customer__c);
                        }
                    }
                }
            }
            if(mCustomerSetId.size()>0)
            {
                List<CTRRequestFormItem__c> mRelatedQueueCCAItemList = [SELECT Id, SAPStatus__c, SAPSubmitTime__c, Customer__c, Customer__r.Name, Customer__r.AccountNumber__c, 
                                                                        SalesOrganization__c, RecordTypeId, OwnerId, Owner.Name, Owner.Email
                                                                        FROM CTRRequestFormItem__c 
                                                                        WHERE Customer__c IN: mCustomerSetId AND SAPSubmitTime__c != null 
                                                                        AND SAPStatus__c = 'Queue CCA' AND SalesOrganization__c IN: mSalesOrgSet
                                                                        AND RecordType.DeveloperName LIKE 'Customer%'
                                                                        ORDER BY SAPSubmitTime__c ASC];
                if(mRelatedQueueCCAItemList.size() > 0)
                {
                    List<CTRRequestFormItem__c> mUpdateItemList = new List<CTRRequestFormItem__c>();
                    List<Messaging.SingleEmailMessage> mEmailMessageList = new List<Messaging.SingleEmailMessage>();
                    for(String mSalesOrg: mSalesOrgSet)
                    {
                        for(CTRRequestFormItem__c mItem: mRelatedQueueCCAItemList)
                        {
                            if(mItem.SalesOrganization__c == mSalesOrg)
                            {
                                CTRRequestFormItem__c mItemRelatedQueueCCA1 = new CTRRequestFormItem__c(Id = mItem.Id);
                                mItemRelatedQueueCCA1.SAPStatus__c = 'Pending CCA';
                                mUpdateItemList.add(mItemRelatedQueueCCA1);
                                //Messaging.SingleEmailMessage mail = CTRCommitteeSendToSap.setupCCAEmail(mItem);
                                //mEmailMessageList.add(mail);
                                break;
                            }
                        }
                    }
                    if(mUpdateItemList.size()>0)
                    {
                        update mUpdateItemList;
                    }
                    if(mEmailMessageList.size()>0)
                    {
                        Messaging.sendEmail(mEmailMessageList);
                    }

                    // CTRRequestFormItem__c mItemRelatedQueueCCA1 = mRelatedQueueCCAItemList[0];
                    // mItemRelatedQueueCCA1.SAPStatus__c = 'Pending CCA';
                    // update mRelatedItem;

                    // Set<Id> mUserSetId = new Set<Id>();
                    // mUserSetId.add(UserInfo.getUserId());
                    // CTRCommitteeSendToSap.EmailInformCCA(mUserSetId, mItemRelatedQueueCCA1);
                    

                }
            }
        }
        catch(exception e)
        {
            System.debug('Error from CTRRequestItemHandler.setQueueToPendingCcaAfterUpdate Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void validateProductAndAddSalesOrgBeforeUpdate(Map<Id, CTRRequestFormItem__c> mRequestItemOldMap, Map<Id, CTRRequestFormItem__c> mRequestItemNewMap)
    {
        try
        {
            List<CTRRequestFormItem__c> mItemList = new List<CTRRequestFormItem__c>();
            Set<Id> mCustomerSetID = new Set<Id>();
            for(CTRRequestFormItem__c mItem: mRequestItemNewMap.values())
            {
                if(mItem.Customer__c != null && mItem.RecordTypeName__c.contains('Initial'))
                {
                    if((mItem.InterestedProductTypeAsCustomerTOP__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsCustomerTOP__c != mItem.InterestedProductTypeAsCustomerTOP__c) || 
                    (mItem.InterestedProductTypeAsSupplierTOP__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsSupplierTOP__c != mItem.InterestedProductTypeAsSupplierTOP__c) || 
                    (mItem.InterestedProductTypeAsCustomerTX__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsCustomerTX__c != mItem.InterestedProductTypeAsCustomerTX__c) || 
                    (mItem.InterestedProductTypeAsSupplierTX__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsSupplierTX__c != mItem.InterestedProductTypeAsSupplierTX__c))
                    {
                        mItemList.add(mItem);
                        mCustomerSetID.add(mItem.Customer__c);
                    }
                }
            }
            if(mCustomerSetID.size()>0)
            {
                List<CTRRequestFormItem__c> mRelatedItemList = [SELECT Id, RecordTypeId, RecordType.DeveloperName, RecordType.Name, Customer__c,
                                                            InterestedProductTypeAsCustomerTOP__c, InterestedProductTypeAsSupplierTOP__c, InterestedProductTypeAsCustomerTX__c,InterestedProductTypeAsSupplierTX__c 
                                                            FROM CTRRequestFormItem__c WHERE Customer__c IN: mCustomerSetID];
                                                            
                for(CTRRequestFormItem__c mItem: mRequestItemNewMap.values())
                {
                    String mResult = '';
                    for(CTRRequestFormItem__c mRelatedItem: mRelatedItemList)
                    {
                        if(mItem.Customer__c == mRelatedItem.Customer__c && mRelatedItem.Id != mItem.Id)
                        {
                            if(mItem.InterestedProductTypeAsCustomerTOP__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsCustomerTOP__c != mItem.InterestedProductTypeAsCustomerTOP__c)
                            {
                                if(mRelatedItem.InterestedProductTypeAsCustomerTOP__c != null)
                                {
                                    List<String> mRelatedProduct = mRelatedItem.InterestedProductTypeAsCustomerTOP__c.Split(';');
                                    List<String> mTriggerProduct = mItem.InterestedProductTypeAsCustomerTOP__c.Split(';');
                                    String mDupProduct = checkDuplicateProduct(mRelatedProduct, mTriggerProduct);
                                    System.debug('mDupProduct TOP Customer'+mDupProduct);
                                    mResult += checkDuplicateProduct(mRelatedProduct, mTriggerProduct);
                                }
                            }
                            if(mItem.InterestedProductTypeAsSupplierTOP__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsSupplierTOP__c != mItem.InterestedProductTypeAsSupplierTOP__c)
                            {
                                if(mRelatedItem.InterestedProductTypeAsSupplierTOP__c != null)
                                {
                                    List<String> mRelatedProduct = mRelatedItem.InterestedProductTypeAsSupplierTOP__c.Split(';');
                                    List<String> mTriggerProduct = mItem.InterestedProductTypeAsSupplierTOP__c.Split(';');
                                    String mDupProduct = checkDuplicateProduct(mRelatedProduct, mTriggerProduct);
                                    mResult += (String.isNotBlank(mDupProduct))?'SupplierTOP':'';
                                }
                            }
                            /*if(mItem.InterestedProductTypeAsCustomerTX__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsCustomerTX__c != mItem.InterestedProductTypeAsCustomerTX__c)
                            {
                                if(mRelatedItem.InterestedProductTypeAsCustomerTX__c != null)
                                {
                                    List<String> mRelatedProduct = mRelatedItem.InterestedProductTypeAsCustomerTX__c.Split(';');
                                    List<String> mTriggerProduct = mItem.InterestedProductTypeAsCustomerTX__c.Split(';');
                                    String mDupProduct = checkDuplicateProduct(mRelatedProduct, mTriggerProduct);
                                    mResult += (String.isNotBlank(mDupProduct))?'CustomerTX':'';
                                }
                            }
                            if(mItem.InterestedProductTypeAsSupplierTX__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsSupplierTX__c != mItem.InterestedProductTypeAsSupplierTX__c)
                            {
                                if(mRelatedItem.InterestedProductTypeAsSupplierTX__c != null)
                                {
                                    List<String> mRelatedProduct = mRelatedItem.InterestedProductTypeAsSupplierTX__c.Split(';');
                                    List<String> mTriggerProduct = mItem.InterestedProductTypeAsSupplierTX__c.Split(';');
                                    String mDupProduct = checkDuplicateProduct(mRelatedProduct, mTriggerProduct);
                                    mResult += (String.isNotBlank(mDupProduct))?'SupplierTX':'';
                                }
                            }*/
                        }
                    }

                    if(mResult != '')
                    {
                        mItem.addError('Duplicate product for '+mResult);
                    }
                    else
                    {
                        if(mItem.InterestedProductTypeAsCustomerTOP__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsCustomerTOP__c != mItem.InterestedProductTypeAsCustomerTOP__c)
                        {
                            mItem.SalesOrganization__c = CTRAccountCtrl.mapSalesOrgWithProd().get(mItem.InterestedProductTypeAsCustomerTOP__c);
                            mItem.SalesOrganizationTOP__c = CTRAccountCtrl.mapSalesOrgWithProd().get(mItem.InterestedProductTypeAsCustomerTOP__c);
                        }
                        if(mItem.InterestedProductTypeAsSupplierTOP__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsSupplierTOP__c != mItem.InterestedProductTypeAsSupplierTOP__c)
                        {
                            mItem.PurchasingOrganization__c = CTRAccountCtrl.mapPurchasingOrgWithProd().get(mItem.InterestedProductTypeAsSupplierTOP__c);
                            mItem.PurchasingOrganizationTOP__c = CTRAccountCtrl.mapPurchasingOrgWithProd().get(mItem.InterestedProductTypeAsCustomerTOP__c);
                        }
                        /*if(mItem.InterestedProductTypeAsCustomerTX__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsCustomerTX__c != mItem.InterestedProductTypeAsCustomerTX__c)
                        {

                        }
                        if(mItem.InterestedProductTypeAsSupplierTX__c != null && mRequestItemOldMap.get(mItem.Id).InterestedProductTypeAsSupplierTX__c != mItem.InterestedProductTypeAsSupplierTX__c)
                        {

                        }*/
                    }

                }


            }

        }
        catch(exception e)
        {
            System.debug('Error from CTRRequestItemHandler.validateProductBeforeUpdate Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static String checkDuplicateProduct(List<String> mProductFiltered, List<String> mProductTrigger)
    {
        String mResult = '';
        for(String mRelated: mProductFiltered)
        {
            for(String mTrigger: mProductTrigger)
            {
                if(mRelated == mTrigger)
                {
                    if(String.isBlank(mResult))
                    {
                        mResult = mTrigger;
                    }
                    else
                    {
                        mResult += '; '+mTrigger;
                    }
                }
            }
        }
        System.debug(mResult);
        return mResult;
    }
    
    public static void SendAdditionalInfo_AfterUpdate(Map<Id, CTRRequestFormItem__c> mRequestItemOldMap, Map<Id, CTRRequestFormItem__c> mRequestItemNewMap)
    {
        try
        {
            Set<Id> mHeaderSetId = new Set<Id>();
            Set<Id> mItemSetId = new Set<Id>();
            List<CTRRequestFormItem__c> mRequestItemList = new List<CTRRequestFormItem__c>();
            for(CTRRequestFormItem__c mItem: mRequestItemNewMap.values())
            {
                System.debug(mItem.CTRRequestFormHeader__c);
                System.debug(mItem.Message__c);

                if(mItem.CTRRequestFormHeader__c != null)
                {
                    CTRRequestFormItem__c mOldItem = mRequestItemOldMap.get(mItem.Id);
                    if(mItem.SAPStatus__c != mOldItem.SAPStatus__c)
                    {
                        system.debug('---developername---'+mItem.RecordTypeName__c);
                        if(mItem.SAPStatus__c == 'SAP Confirmed Sales/Purchasing View' && 
                           (mItem.RecordTypeName__c == 'CustomerInitial' || mItem.RecordTypeName__c == 'CustomerEditInfo' || mItem.RecordTypeName__c == 'CustomerExtend') && mItem.BusinessUnit__c == 'TX')
                        {
                            mRequestItemList.add(mItem);
                            mItemSetId.add(mItem.Id);
                            mHeaderSetId.add(mItem.CTRRequestFormHeader__c);
                        }
                    }
                }
            }
            if(mRequestItemList.size()>0)
            {
                CTRIntegraionList__mdt mIntegration = CTRIntegraionList__mdt.getInstance('CTRCustomerAdditionalInfo');
                if(mIntegration != null)
                {
                    List<CTRRequestFormItem__c> mGetRequestItemList = CTRCommitteeSendToSap.geRequestItemForSendToSAP(mItemSetId);
                    List<CTRRequestFormHeader__c> mGetHeaderList = CTRCommitteeSendToSap.geRequestHeaderForSendToSAP(mHeaderSetId);
                    List<CTRRequestFormItem__c> mRequestItemFilteredList = new List<CTRRequestFormItem__c> ();
                    Map<Id, CTRRequestFormHeader__c> mHeaderItemMap = new Map<Id, CTRRequestFormHeader__c>();
                    Set<String>mProfileNameSet = new Set<String>();
                    for(CTRRequestFormItem__c mItem: mGetRequestItemList)
                    {
                        if(mItem.RecordType.DeveloperName.contains('Customer'))
                        {
                            for(CTRRequestFormHeader__c mHeader: mGetHeaderList)
                            {
                                if(mHeader.Id == mItem.CTRRequestFormHeader__c)
                                {
                                    mHeaderItemMap.put(mItem.Id, mHeader);
                                    
                                }
                            }
                            mRequestItemFilteredList.add(mItem);
                            mProfileNameSet.add(mItem.Owner.Profile.Name);
                        }
                        
                    }
                    C360Integration__c mSetting = C360Integration__c.getInstance();

                    List<CTRBuProfile__mdt> mBuProfileList = [SELECT Id, MasterLabel, DeveloperName, BusinessUnit__c ,ReassignTask_Section_Name__c, VPSectionName__c, Language__c,Edit_Button_Name__c, Section_Credit_Condition__c
                                                                FROM CTRBuProfile__mdt WHERE MasterLabel IN :mProfileNameSet];  

                    for(CTRRequestFormItem__c mItem: mRequestItemFilteredList)
                    {
                        CTRRequestFormHeader__c mHeader = mHeaderItemMap.get(mItem.Id);

                        if(mHeader != null)
                        {
                            String mBuProfile = 'TOP';
                            String IntegrationType = 'AdditionalInfo';
                            for(CTRBuProfile__mdt mBu: mBuProfileList)
                            {
                                if(mItem.Owner.Profile.Name == mBu.MasterLabel)
                                {
                                    mBuProfile = mBu.BusinessUnit__c;
                                }
                            }
                            String mGatewayId = (mItem.GatewayId__c != null)?mItem.GatewayId__c: Uuid.randomUUID();
                            String mAddionalInfo = 'addInfo-';
                            mGatewayId = (mGatewayId.contains(mAddionalInfo))?mGatewayId:mAddionalInfo+mGatewayId;
                            CTRAdditionalInfoModelData mCustomerData = CTRAdditionalInfoModelData.SetupJsonForAdditionalInfoDataModel(mHeader, mItem, IntegrationType, mItem.BusinessUnit__c, mGatewayId);

                            //String mGatewayId = mCustomerData.input.input.GatewayId;
                            if(mCustomerData != null)
                            {
                                String mJson = JSON.serialize(mCustomerData);
                                mJson = mJson.replace('null', '""');
                                System.debug('mJson: '+mJson);
                                
                                system.enqueuejob(new CTRTriggerWebServiceQueueable(mJson, mIntegration.Token__c, mSetting.HerokuIntegrationDomain__c+mIntegration.Path__c, IntegrationType, mItem.Id, mGatewayId));
                            }

                        }
                    }
                }
            }
        }
        catch(exception e)
        {
            System.debug('Error from CTRRequestItemHandler.SendAdditionalInfo_AfterUpdate Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }
    
    public static void createDestinationCountryAfterInsert(List<CTRRequestFormItem__c> mRequestItemList)
    {
        try
        {
            Set<Id> mCustomerSetId = new Set<Id>();
            List<CTRRequestFormItem__c> mItemFilteredList = new List<CTRRequestFormItem__c>();

            for(CTRRequestFormItem__c mItem: mRequestItemList)
            {
                if(mItem.RecordTypeName__c.contains('Edit') || (mItem.RecordTypeName__c.contains('Exten') && mItem.ExtendHeroku__c == false))
                {
                    if(mItem.Customer__c != null)
                    {
                        mCustomerSetId.add(mItem.Customer__c);
                        mItemFilteredList.add(mItem);
                    }
                }
            }
            if(mCustomerSetId.size()>0)
            {
                List<CTRShippingCountry__c> mDestinationCountryNewList = new List<CTRShippingCountry__c>();
                List<CTRShippingCountry__c> mDestinationCountryList = [SELECT Id, ShippingCountry__c, CTRRequestFormItem__c, LocationType__c, Customer__c 
                                                                        FROM CTRShippingCountry__c WHERE Customer__c IN: mCustomerSetId AND Status__c = 'Active'];
                if(mDestinationCountryList.size()>0)
                {
                    for(CTRRequestFormItem__c mItem: mItemFilteredList)
                    {
                        for(CTRShippingCountry__c mCountry: mDestinationCountryList)
                        {
                            if(mCountry.Customer__c == mItem.Customer__c)
                            {
                                CTRShippingCountry__c mCountryNew = new CTRShippingCountry__c();
                                mCountryNew.ShippingCountry__c = mCountry.ShippingCountry__c;
                                mCountryNew.Customer__c = mItem.Customer__c;
                                mCountryNew.CTRRequestFormItem__c = mItem.Id;
                                mCountryNew.LocationType__c = mCountry.LocationType__c;
                                mDestinationCountryNewList.add(mCountryNew);
                            }
                        }
                    }
                    if(mDestinationCountryNewList.size()>0)
                    {
                        insert mDestinationCountryNewList;
                    }
                }

            }
        }
        catch(exception e)
        {
            System.debug('Error RequestHeaderHandler.createDestinationCountryAfterInsert line:'+e.getLineNumber()+' || Message:'+e.getmessage());

        }
    }

    //  public static void onChangeJsonForEditAfterUpdate(Map<Id, CTRRequestFormItem__c> mRequestItemOldMap, Map<Id, CTRRequestFormItem__c> mRequestItemNewMap)
    //  {
    //     if(CTRRequestItemHandler.firstRunRequestItemComplete) return;  //prevent recursion
        
    //     system.debug('===ITEM==onChangeJsonForEditAfterUpdate======');
    //     CTRRequestItemHandler.firstRunRequestItemComplete = true;
    //     try
    //     {
    //         List<CTRRequestFormItem__c>mItemList = new List<CTRRequestFormItem__c>();
    //         Set<String> mRequestItemSetId = new Set<String>();
    //         Set<String> mCustomerSetId = new Set<String>();
    //         Set<String> mTermofPaymentSetId = new Set<String>();
    //         Set<String> mMasterDataSetId = new Set<String>();

    //         // for(CTRRequestFormItem__c mOldItem: mRequestItemOldMap.values())
    //         // {
    //         //     String oldInternalEditField = mOldItem.InternalEditField__c;
    //         //     system.debug('==OLD===oldInternalEditField======'+oldInternalEditField);
                
    //             for(CTRRequestFormItem__c mItem: mRequestItemNewMap.values())
    //             {
    //                 system.debug('=====mItem======'+mItem);
    //                 String newInternalEditField = mItem.InternalEditField__c;
    //                 system.debug('==NEW===newInternalEditField======'+newInternalEditField);
                    
    //                 Boolean Test = firstRunRequestItemComplete;
    //                 system.debug('=====Test======'+Test);
    //                 if(mItem.RecordTypeName__c.contains('Edit') && mItem.InternalEditField__c!=null && 
    //                 mRequestItemOldMap.get(mItem.Id).InternalEditField__c != mItem.InternalEditField__c)
    //                 {
    //                     mRequestItemSetId.add(mItem.Id);
    //                     mItemList.add(mItem);
    //                     List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mItem.InternalEditField__c);
    //                     system.debug('=====mFieldList======'+mFieldList);
    //                     for(Object mFieldData : mFieldList)
    //                     {    
    //                         system.debug('=====mFieldData======'+mFieldData);
    //                         Map<String,Object> mField = (Map<String,Object>)mFieldData;
    //                         String mLabel = (String)mField.get('Label');
    //                         String mApi = (String)mField.get('Api');
    //                         String mValue = (String)mField.get('Value');
    
    //                         if(mApi != null && mValue != null)
    //                         {
    //                             if(mApi == 'Customer__c')
    //                             {
    //                                 if(mValue.length() == 15 || mValue.length() == 18)
    //                                 {
    //                                    mCustomerSetId.add(mValue);
    //                                 }
                                   
    //                             }
    //                             if(mApi == 'TermofPayment__c')
    //                             {
    //                                 if(mValue.length() == 15 || mValue.length() == 18)
    //                                 {
    //                                     mTermofPaymentSetId.add(mValue);
    //                                 }
    //                             }
    //                             if(mApi == 'SubIndustry__c')
    //                             {
    //                                 if(mValue.length() == 15 || mValue.length() == 18)
    //                                 {
    //                                     mMasterDataSetId.add(mValue);
    //                                 }
    //                             }
    //                             if(mApi == 'Industry__c')
    //                             {
    //                                 if(mValue.length() == 15 || mValue.length() == 18)
    //                                 {
    //                                     mMasterDataSetId.add(mValue);
    //                                 }
    //                             }
    //                             if(mApi == 'CustomerType__c')
    //                             {
    //                                 if(mValue.length() == 15 || mValue.length() == 18)
    //                                 {
    //                                     mMasterDataSetId.add(mValue);
    //                                 }
    //                             }
    //                             if(mApi == 'InterGroup__c')
    //                             {
    //                                 if(mValue.length() == 15 || mValue.length() == 18)
    //                                 {
    //                                     mMasterDataSetId.add(mValue);
    //                                 }
    //                             }
    //                             if(mApi == 'Application__c')
    //                             {
    //                                 if(mValue.length() == 15 || mValue.length() == 18)
    //                                 {
    //                                     mMasterDataSetId.add(mValue);
    //                                 }
    //                             }
    //                         }
    //                          system.debug('=====mCustomerSetId======'+mCustomerSetId);
    //                          system.debug('=====mTermofPaymentSetId======'+mTermofPaymentSetId);
    //                     }
    //                 }
    //                 system.debug('=====end if======');
    //             }
    //         //}
    //         if(mRequestItemSetId.size()>0 && (mCustomerSetId.size()>0 || mTermofPaymentSetId.size()>0 || mMasterDataSetId.size()>0))
    //         {
    //             List<CTRRequestFormItem__c>mItemEditList = [SELECT Id,RecordType.DeveloperName, InternalEditField__c FROM CTRRequestFormItem__c WHERE Id IN:mRequestItemSetId];
    //             system.debug('=====mItemEditList======'+mItemEditList);
    //             if(mItemEditList.size()>0)
    //             {
    //                 //Get Account Number
    //                 Map<Id,Account> mCustomerDataMap = new Map<Id,Account>([SELECT Id, AccountNumber__c,SupplierNumber__c FROM Account WHERE ID IN: mCustomerSetId]);
                    
    //                 for(CTRRequestFormItem__c requestItemRec : mItemEditList)
    //                 {
    //                     String InternalEditField = requestItemRec.InternalEditField__c;
    //                     if(mCustomerDataMap.size()>0  && mCustomerSetId.size() >0)
    //                     {
    //                         Account mAccount = mCustomerDataMap.get(requestItemRec.Customer__c);
    //                         if(mAccount!= null)
    //                         {
    //                             String code = '';
    //                             system.debug('=====requestItemRec.RecordType.DeveloperName======'+requestItemRec.RecordType.DeveloperName);
    //                             if(requestItemRec.RecordType.DeveloperName.contains('Customer'))
    //                             {
    //                                code = (String)mAccount.AccountNumber__c;  
    //                             }
    //                             else if(requestItemRec.RecordType.DeveloperName.contains('Supplier'))
    //                             {
    //                                code = (String)mAccount.SupplierNumber__c; 
    //                             }
    //                             system.debug('------code-----'+code);
    //                             if(code != null)
    //                             	requestItemRec.InternalEditField__c = InternalEditField.replace((String)mAccount.Id,code);
    //                             system.debug('----2--InternalEditField-----'+InternalEditField);
    //                         }
    //                     }
    //                 }

    //                 Map<Id,Master_Map__c> mMasterMapDataMap = new Map<Id,Master_Map__c>([SELECT Id, Code__c FROM Master_Map__c WHERE ID IN: mTermofPaymentSetId ]);

    //                 system.debug('=====mMasterMapDataMap======'+mMasterMapDataMap);
    //                 if(mTermofPaymentSetId.size() >0)
    //                 {
    //                 	mItemEditList = ReplaceCode(mTermofPaymentSetId, mMasterMapDataMap, mItemEditList);
    //                 }

    //                 Map<Id,CTRMasterData__c> mMasterDataMap = new Map<Id,CTRMasterData__c>([SELECT Id, Code__c FROM CTRMasterData__c WHERE ID IN: mMasterDataSetId ]);
    //                 system.debug('=====mMasterDataMap======'+mMasterDataMap);
    //                 if(mMasterDataSetId.size() >0)
    //                 {
    //                 	mItemEditList = ReplaceCode(mMasterDataSetId, mMasterDataMap, mItemEditList);
    //                 }

    //                 system.debug('---END---mItemEditList-----'+mItemEditList);
    //                 update mItemEditList;
    //             }
    //         }
    //     }
    //     catch(exception e)
    //     {
    //         System.debug('Error from CTRRequestItemHandler.onChangeJsonForEditAfterUpdate Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
    //     }
    // }
    
    // private static List<CTRRequestFormItem__c> ReplaceCode(Set<String> mSetId, Map<Id,sObject> mMasterMapDataMap, List<CTRRequestFormItem__c> mItemEditList)
    // {
    //     for(CTRRequestFormItem__c mItem: mItemEditList)
    //     {
    //     	String InternalEditField = mItem.InternalEditField__c;
    //         system.debug('------InternalEditField-----'+InternalEditField);
    //         if(mSetId.size() >0)
    //         {
    //         	if(mMasterMapDataMap.size()>0)
    //             {
    //              	for(id CustomerId : mSetId)
    //                 {
    //                  	system.debug('------CustomerId-----'+CustomerId);
    //                     String Code = (String)mMasterMapDataMap.get(CustomerId).get('Code__c');
    //                     system.debug('------Code-----'+Code);
    //                     mItem.InternalEditField__c = InternalEditField.replace((String)CustomerId,Code);
    //                     system.debug('----2--InternalEditField-----'+InternalEditField);
    //                 }
    //          	}
    //          }
    //     }
    //     return mItemEditList;
    // }

    // public static void AddJsonEditInfoBeforeUpdateV0(Map<Id,CTRRequestFormItem__c> mItemOldMap, Map<Id,CTRRequestFormItem__c> mItemNewMap)
    // {
    //     try
    //     {
    //         Map<String, Schema.SObjectField> mRequestItemMap = Schema.getGlobalDescribe().get('CTRRequestFormItem__c').getDescribe().fields.getMap();
    //         for(CTRRequestFormItem__c mNewItem: mItemNewMap.values())
    //         {
    //             if(mNewItem.RecordTypeName__c.contains('Edit'))
    //             {
    //                 if(mNewItem.InternalEditField__c == mItemOldMap.get(mNewItem.Id).InternalEditField__c)
    //                 {
    //                     Map<String, ChangeFieldWrapper> mChangeFieldMap = new Map<String ,ChangeFieldWrapper>();
    //                     SObject mObj1 = mItemOldMap.get(mNewItem.Id);
    //                     SObject mObj2 = mItemNewMap.get(mNewItem.Id);
    //                     for (Schema.sObjectField mField : mRequestItemMap.values()) 
    //                     {
    //                         Object mDataV1 = mObj1.get(mField);
    //                         Object mDataV2 = mObj2.get(mField);
    //                         if (didFieldChange(mDataV1, mDataV2)) 
    //                         {
    //                             Schema.DescribeFieldResult mFieldResult = mField.getDescribe();
    //                             ChangeFieldWrapper mChangeFieldWrapper = new ChangeFieldWrapper();
    //                             mChangeFieldWrapper.Label = String.valueOf(mFieldResult.getLabel());
    //                             mChangeFieldWrapper.Api = String.valueOf(mField);
    //                             mChangeFieldWrapper.Value = (mDataV2 != null)?String.valueOf(mDataV2):'';
    //                             mChangeFieldMap.put(String.valueOf(mField),mChangeFieldWrapper);
    //                             // System.debug('mLabel'+mFieldResult.getLabel());
    //                             // System.debug('mField:'+mField);
    //                             // System.debug('mDataV1:'+mDataV1);
    //                             // System.debug('mDataV2:'+mDataV2);
                                
    //                         }
    //                     }
    //                     if(mChangeFieldMap.size()>0)
    //                     {
    //                         List<ChangeFieldWrapper> mChangeFieldList = new List<ChangeFieldWrapper>();
    //                         if(mNewItem.InternalEditField__c !=null)
    //                         {
    //                             List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mNewItem.InternalEditField__c);
                                
    //                             for(Object mFieldData : mFieldList)
    //                             {    
    //                                 Map<String,Object> mField = (Map<String,Object>)mFieldData;
    //                                 ChangeFieldWrapper mChangeFieldWrapper = new ChangeFieldWrapper();
    //                                 mChangeFieldWrapper.Label = (String)mField.get('Label');
    //                                 mChangeFieldWrapper.Api = (String)mField.get('Api');
    //                                 mChangeFieldWrapper.Value = (String)mField.get('Value');
    //                                 mChangeFieldWrapper.Source = (mField.get('Source') != null)?(String)mField.get('Source'):'';

    //                                 if(mChangeFieldWrapper.Api != null)
    //                                 {
    //                                     ChangeFieldWrapper mNewFieldChanged = mChangeFieldMap.get(mChangeFieldWrapper.Api);
    //                                     if(mNewFieldChanged != null)
    //                                     {
    //                                         mNewFieldChanged.Label = mChangeFieldWrapper.Label;
    //                                     }
    //                                     else
    //                                     {
    //                                         mChangeFieldMap.put(mChangeFieldWrapper.Label,mChangeFieldWrapper);
    //                                     }
    //                                 }
    //                             }
    //                         }
    //                             mChangeFieldList = mChangeFieldMap.values();
    //                             String jsonStr = JSON.serialize(mChangeFieldList);
    //                             jsonStr = jsonStr.replace('null', '""');
    //                             mNewItem.InternalEditField__c= jsonStr;
    //                             System.debug('jsonStr'+jsonStr);
                            
    //                     }
    //                 }
    //             }
    //         }
    //     }
    //     catch(exception e)
    //     {
    //         System.debug('Error testedt line:'+e.getLineNumber()+' || Message:'+e.getmessage());

    //     }
    // }

    public class ChangeFieldWrapper
    {
        public string Label {get;set;}
        public string Api {get;set;}
        public string Value{get;set;}
        public string Source{get;set;}
        public string User{get;set;}
    }

    private static Boolean didFieldChange(Object v1, Object v2) 
    {
        Boolean mChange = false;
        if (v1 == null && v2 == null) 
        {
            mChange= false;
        }
        if (v1 != v2) 
        {
            mChange = true;
        }
        return mChange;
    }

    public static void modifyJsonIdToNameBeforeUpdatev2(Map<Id,CTRRequestFormItem__c> mItemOldMap, Map<Id,CTRRequestFormItem__c> mItemNewMap)
    {
        try
        {
            Map<String, String> mChangeDataJsonMap = new Map<String, String>();
            for(CTRRequestFormItem__c mItem: mItemNewMap.values())
            {
                if(mItem.InternalEditField__c != null && mItem.InternalEditField__c != mItemOldMap.get(mItem.Id).InternalEditField__c)
                {
                    mChangeDataJsonMap.put(mItem.Id, mItem.InternalEditField__c);
                }
            }
            if(mChangeDataJsonMap.size()>0)
            {
                Map<String, String> mConvertedLabelJsonMap = CTRRequestEditLogFieldController.modifyChangeDataJsonIdToLabel(mChangeDataJsonMap, 'CTRRequestFormItem__c');
                for(CTRRequestFormItem__c mItem: mItemNewMap.values())
                {
                    String mResultDataChange = mConvertedLabelJsonMap.get(mItem.Id);
                    if(String.isNotBlank(mResultDataChange))
                    {
                        mItem.InternalEditField__c = mResultDataChange;
                    }
                }
            }
        }
        catch(exception e)
        {
            System.debug('Error modifyJsonIdToNameBeforeUpdatev2  line:'+e.getLineNumber()+' || Message:'+e.getmessage());
        }
    }

    //modify id to name for any change data
    public static void AddJsonEditInfoBeforeUpdate(Map<Id,CTRRequestFormItem__c> mItemOldMap, Map<Id,CTRRequestFormItem__c> mItemNewMap)
    {
        try
        {
            Map<String, Schema.SObjectField> mRequestItemMap = Schema.getGlobalDescribe().get('CTRRequestFormItem__c').getDescribe().fields.getMap();
            Map<Id,Map<String, ChangeFieldWrapper>> mChangeFieldMapWithId = new Map<Id,Map<String ,ChangeFieldWrapper>>();
            Set<String> mObjectNameList = new Set<String>();
            Set<Id> mAllIdSet = new Set<Id>();

            for(CTRRequestFormItem__c mNewItem: mItemNewMap.values())
            {
                if(mNewItem.RecordTypeName__c.contains('Edit'))
                {
                    Map<String, ChangeFieldWrapper> mChangeFieldMap = new Map<String ,ChangeFieldWrapper>();

                    if(mNewItem.InternalEditField__c == mItemOldMap.get(mNewItem.Id).InternalEditField__c)
                    {
                        SObject mObj1 = mItemOldMap.get(mNewItem.Id);
                        SObject mObj2 = mItemNewMap.get(mNewItem.Id);
                        for (Schema.sObjectField mField : mRequestItemMap.values()) 
                        {
                            Object mDataV1 = mObj1.get(mField);
                            Object mDataV2 = mObj2.get(mField);
                            if (didFieldChange(mDataV1, mDataV2)) 
                            {
                                Schema.DescribeFieldResult mFieldResult = mField.getDescribe();
                                ChangeFieldWrapper mChangeFieldWrapper = new ChangeFieldWrapper();
                                mChangeFieldWrapper.Label = String.valueOf(mFieldResult.getLabel());
                                mChangeFieldWrapper.Api = String.valueOf(mField);
                                mChangeFieldWrapper.Value = (mDataV2 != null)?String.valueOf(mDataV2):'';
                                mChangeFieldMap.put(String.valueOf(mField),mChangeFieldWrapper);

                                String objectName = 'CTRRequestFormItem__c';
                                String fieldName =  String.valueOf(mField);

                                Schema.DisplayType mFieldDataType;
                                String mDataType = 'STRING';
                                if(!Test.isRunningTest())
                                {
                                    mFieldDataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType(); 
                                    mDataType = String.valueOf(mFieldDataType);
                                }
                                System.debug('mDataType: '+mDataType);
                                
                                if(mDataType == 'REFERENCE' && mDataV2 != null)
                                {
                                    String mNewValue = String.valueOf(mDataV2);
                                    System.debug('mNewValue: '+mNewValue);
                                    if (mNewValue instanceOf Id) 
                                    {
                                        System.debug('valid id');
                                        Id mId = (Id)mNewValue;
                                        mAllIdSet.add(mId);
                                        System.debug('mId:'+mId);

                                        System.debug('mNewValue:'+mNewValue);
                                        String mObjectName = mId.getSObjectType().getDescribe().getName();
                                        System.debug('mObjectName'+mObjectName);
                                        mObjectNameList.add(mObjectName);
                                    }
                                }
                            }
                        }
                    }
                        if(mNewItem.InternalEditField__c !=null)
                        {
                            List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mNewItem.InternalEditField__c);
                            
                            for(Object mFieldData : mFieldList)
                            {    
                                Map<String,Object> mField = (Map<String,Object>)mFieldData;
                                String mSource = (String.isNotBlank((String)mField.get('Source')))?(String)mField.get('Source'):'';
                                String mLabel = (String)mField.get('Label');
                                String mValue = (String)mField.get('Value');
                                String mApi = (String)mField.get('Api');

                                ChangeFieldWrapper mChangeFieldWrapper = new ChangeFieldWrapper();
                                    mChangeFieldWrapper.Label = mLabel;
                                    mChangeFieldWrapper.Api = mApi;
                                    mChangeFieldWrapper.Value = mValue;
                                    mChangeFieldWrapper.Source = mSource;

                                    if(mChangeFieldWrapper.Api != null)
                                    {
                                        ChangeFieldWrapper mNewFieldChanged = mChangeFieldMap.get(mChangeFieldWrapper.Api);
                                        if(mNewFieldChanged != null)
                                        {
                                            mNewFieldChanged.Label = mChangeFieldWrapper.Label;
                                            mNewFieldChanged.Source = mChangeFieldWrapper.Source;
                                        }
                                        else
                                        {
                                            mChangeFieldMap.put(mChangeFieldWrapper.Label,mChangeFieldWrapper);
                                        }
                                    }

                                String objectName = 'CTRRequestFormItem__c';
                                String fieldName =  mApi;

                               Schema.DisplayType mFieldDataType;
                                String mDataType = 'REFERENCE';
                                if(!Test.isRunningTest())
                                {
                                    mFieldDataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType(); 
                                    mDataType = String.valueOf(mFieldDataType);
                                }
                                System.debug('mDataType: '+mDataType);
                                
                                if(mDataType == 'REFERENCE' && mValue != null)
                                {
                                    String mNewValue = String.valueOf(mValue);
                                    if (mNewValue instanceOf Id) 
                                    {
                                        Id mId = (Id)mNewValue;
                                        mAllIdSet.add(mId);

                                        String mObjectName = mId.getSObjectType().getDescribe().getName();
                                        mObjectNameList.add(mObjectName);
                                    }
                                }
                            }
                        }
                        if(mChangeFieldMap.size()>0)
                        {
                            mChangeFieldMapWithId.put(mNewItem.Id, mChangeFieldMap);
                        }
                    
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
                //Map<Id,Map<String, ChangeFieldWrapper>> mChangeFieldMapWithId = new Map<Id,Map<String ,ChangeFieldWrapper>>();
                for(CTRRequestFormItem__c mNewItem: mItemNewMap.values())
                {
                    Map<String, ChangeFieldWrapper> mChangedFieldMap = mChangeFieldMapWithId.get(mNewItem.Id);
                    if(mChangedFieldMap.size()>0 || mChangedFieldMap != null)
                    {
                            // if(mNewItem.InternalEditField__c !=null)
                            // {
                            //     List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mNewItem.InternalEditField__c);
                                
                            //     for(Object mFieldData : mFieldList)
                            //     {    
                            //         Map<String,Object> mField = (Map<String,Object>)mFieldData;
                            //         String mSource = (String)mField.get('Source');
                            //         String mLabel = (String)mField.get('Label');
                            //         String mValue = (String)mField.get('Value');
                            //         String mApi = (String)mField.get('Api');

                            //         ChangeFieldWrapper mChangeFieldWrapper = new ChangeFieldWrapper();
                            //         mChangeFieldWrapper.Label = mLabel;
                            //         mChangeFieldWrapper.Api = mApi;
                            //         mChangeFieldWrapper.Value = mValue;
                            //         mChangeFieldWrapper.Source = mSource;

                            //         if(mChangeFieldWrapper.Api != null)
                            //         {
                            //             ChangeFieldWrapper mNewFieldChanged = mChangedFieldMap.get(mChangeFieldWrapper.Api);
                            //             if(mNewFieldChanged != null)
                            //             {
                            //                 mNewFieldChanged.Label = mChangeFieldWrapper.Label;
                            //                 mNewFieldChanged.Source = mChangeFieldWrapper.Source;
                            //             }
                            //             else
                            //             {
                            //                 mChangedFieldMap.put(mChangeFieldWrapper.Label,mChangeFieldWrapper);
                            //             }
                            //         }
                            //     }
                            // }

                            List<ChangeFieldWrapper> mChangeFieldList = mChangedFieldMap.values();

                            if(mObjMap.size()>0 && mChangeFieldList.size()>0)
                            {
                                for(ChangeFieldWrapper mItemEdit: mChangeFieldList)
                                {
                                    if(mItemEdit.Value instanceOf Id)
                                    {
                                        Id mId = (Id)mItemEdit.Value;
                                        String mObjectName = mId.getSObjectType().getDescribe().getName();
                                        System.debug('mId:'+mId);
                                        System.debug('mObjectName:'+mObjectName);
                                        System.debug('mItemEdit.Value:'+mItemEdit.Value);

                                        Map<Id, sObject> mObjMapItem = mObjMap.get(mObjectName);
                                        if(mObjMapItem.size()>0)
                                        {
                                            System.debug('mApi:'+mItemEdit.Api);
                                            sObject mChangeObj = mObjMapItem.get(mItemEdit.Value);
                                            System.debug('Item mChangeObj:'+mChangeObj);
                                            if(mChangeObj != null)
                                            {
                                                if(mObjectName == 'Master_Map__c')
                                                {
                                                    mItemEdit.Value = (mChangeObj.get('Code__c') != null)?(String)mChangeObj.get('Code__c'): '';
                                                }
                                                else
                                                {
                                                    mItemEdit.Value = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                                
                                String jsonStr = JSON.serialize(mChangeFieldList);
                                jsonStr = jsonStr.replace('null', '""');
                                mNewItem.InternalEditField__c= jsonStr;
                                System.debug('jsonStr'+jsonStr);
                    }

                }

            }
        }
        catch(exception e)
        {
            System.debug('Error testedt v2 line:'+e.getLineNumber()+' || Message:'+e.getmessage());

        }
    }

    //json change modify id to name
    // public static void modifyJsonIdToNameBeforeUpdate(Map<Id,CTRRequestFormItem__c> mItemOldMap, Map<Id,CTRRequestFormItem__c> mItemNewMap)
    // {
    //     try
    //     {
    //         Map<String, Schema.SObjectField> mRequestItemMap = Schema.getGlobalDescribe().get('CTRRequestFormItem__c').getDescribe().fields.getMap();
    //         Map<Id,Map<String, ChangeFieldWrapper>> mChangeFieldMapWithId = new Map<Id,Map<String ,ChangeFieldWrapper>>();
            
    //         Set<String> mObjectNameList = new Set<String>();
    //         Set<Id> mAllIdSet = new Set<Id>();

    //         for(CTRRequestFormItem__c mNewItem: mItemNewMap.values())
    //         {
    //             if(mNewItem.RecordTypeName__c.contains('Edit'))
    //             {
    //                 if(mNewItem.InternalEditField__c != mItemOldMap.get(mNewItem.Id).InternalEditField__c)
    //                 {
    //                     Map<String, ChangeFieldWrapper> mChangeFieldMap = new Map<String ,ChangeFieldWrapper>();

    //                     if(mNewItem.InternalEditField__c !=null)
    //                     {

    //                         List<Object> mFieldList = (List<Object>)JSON.deserializeUntyped(mNewItem.InternalEditField__c);
                            
    //                         for(Object mFieldData : mFieldList)
    //                         {    
    //                             Map<String,Object> mField = (Map<String,Object>)mFieldData;
    //                             String mSource = (String.isNotBlank((String)mField.get('Source')))?(String)mField.get('Source'):'';
    //                             String mLabel = (String)mField.get('Label');
    //                             String mValue = (String)mField.get('Value');
    //                             String mApi = (String)mField.get('Api');

    //                             ChangeFieldWrapper mChangeFieldWrapper = new ChangeFieldWrapper();
    //                             mChangeFieldWrapper.Label = mLabel;
    //                             mChangeFieldWrapper.Api = mApi;
    //                             mChangeFieldWrapper.Value = mValue;
    //                             mChangeFieldWrapper.Source = mSource;
    //                             mChangeFieldMap.put(mApi,mChangeFieldWrapper);

    //                             String objectName = 'CTRRequestFormItem__c';
    //                             String fieldName =  mApi;

    //                             Schema.DisplayType mFieldDataType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType(); 
    //                             String mDataType = String.valueOf(mFieldDataType);
    //                             System.debug('mDataType: '+mDataType);
                                
    //                             if(mDataType == 'REFERENCE' && String.isNotBlank(mValue))
    //                             {
    //                                 String mNewValue = String.valueOf(mValue);
    //                                 System.debug('mValue: '+mValue);
    //                                 if (mNewValue instanceOf Id) 
    //                                 {
    //                                     System.debug('valid id');
    //                                     Id mId = (Id)mNewValue;
    //                                     mAllIdSet.add(mId);
    //                                     System.debug('mId:'+mId);

    //                                     System.debug('mNewValue:'+mNewValue);
    //                                     String mObjectName = mId.getSObjectType().getDescribe().getName();
    //                                     System.debug('mObjectName'+mObjectName);
    //                                     mObjectNameList.add(mObjectName);
    //                                 }
    //                             }
    //                         }
    //                     }
    //                     if(mChangeFieldMap.size()>0)
    //                     {
    //                         mChangeFieldMapWithId.put(mNewItem.Id, mChangeFieldMap);
    //                     }
    //                 }
    //             }
    //         }
    //         if(mChangeFieldMapWithId.size()>0 && mObjectNameList.size()>0 && mAllIdSet.size()>0)
    //         {
    //             Map<String, Map<Id, sObject>> mObjMap = new Map<String, Map<Id, sObject>>();
    //                 for(String mObjectName: mObjectNameList)
    //                 {
    //                     String mQuery = 'SELECT ID, Name';
    //                     if(mObjectName == 'Master_Map__c')
    //                     {
    //                         mQuery+= ', Code__c, Description__c';
    //                     }
    //                     mQuery+= ' FROM '+mObjectName;
    //                     mQuery+= ' WHERE Id IN: mAllIdSet';
    //                     Map<Id, sObject> sObjectMap = new Map<Id, sObject>((List<sObject>)Database.query(mQuery));
    //                     mObjMap.put(mObjectName, sObjectMap);
    //                 }
                
    //             for(CTRRequestFormItem__c mNewItem: mItemNewMap.values())
    //             {
    //                 Map<String, ChangeFieldWrapper> mChangedFieldMap = mChangeFieldMapWithId.get(mNewItem.Id);
    //                 if(mChangedFieldMap.size()>0 || mChangedFieldMap != null)
    //                 {
    //                         if(mNewItem.InternalEditField__c !=null)
    //                         {
    //                             List<ChangeFieldWrapper> mChangeFieldList = mChangedFieldMap.values();

    //                             if(mObjMap.size()>0 && mChangeFieldList.size()>0)
    //                             {
    //                                 for(ChangeFieldWrapper mItemEdit: mChangeFieldList)
    //                                 {
    //                                     if(mItemEdit.Value instanceOf Id)
    //                                     {
    //                                         Id mId = (Id)mItemEdit.Value;
    //                                         String mObjectName = mId.getSObjectType().getDescribe().getName();
    //                                         System.debug('mId:'+mId);
    //                                         System.debug('mObjectName:'+mObjectName);
    //                                         System.debug('mItemEdit.Value:'+mItemEdit.Value);

    //                                         Map<Id, sObject> mObjMapItem = mObjMap.get(mObjectName);
    //                                         if(mObjMapItem.size()>0)
    //                                         {
    //                                             System.debug('mApi:'+mItemEdit.Api);
    //                                             sObject mChangeObj = mObjMapItem.get(mItemEdit.Value);
    //                                             System.debug('Item mChangeObj:'+mChangeObj);
    //                                             if(mChangeObj != null)
    //                                             {
    //                                                 if(mObjectName == 'Master_Map__c')
    //                                                 {
    //                                                     mItemEdit.Value = (mChangeObj.get('Code__c') != null)?(String)mChangeObj.get('Code__c'): '';
    //                                                 }
    //                                                 else
    //                                                 {
    //                                                     mItemEdit.Value = (mChangeObj.get('Name') != null)?(String)mChangeObj.get('Name'): '';
    //                                                 }
    //                                             }
    //                                         }
    //                                     }
    //                                 }
    //                             }
    //                             String jsonStr = JSON.serialize(mChangeFieldList);
    //                             jsonStr = jsonStr.replace('null', '""');
    //                             mNewItem.InternalEditField__c= jsonStr;
    //                             System.debug('jsonStr'+jsonStr);
    //                         }
    //                 }

    //             }

    //         }
    //     }
    //     catch(exception e)
    //     {
    //         System.debug('Error testedt v2 line:'+e.getLineNumber()+' || Message:'+e.getmessage());

    //     }
    // }

    public static void CheckRunningNumber(List<CTRRequestFormItem__c> mRequestItemList)  
    {
        try
        {
            CTRConfig__c customSetting;

            if(!Test.isRunningTest()) {
                // Query the CTRConfig__c custom setting
                customSetting = [SELECT Id, RunningNumber__c FROM CTRConfig__c LIMIT 1];
            }
            else {
                customSetting = new CTRConfig__c();
                customSetting.RunningNumber__c = 0;
            }
            
            // Extracting the year from the current date
            Integer yearString = Date.today().year();
            System.debug('Year is ' + yearString);
            
            // Fetching the running number from Custom Setting
            Decimal runningNumber = (customSetting.RunningNumber__c != null)?customSetting.RunningNumber__c:0;
            
            // Map to store the Record Type to Code mapping
            Map<String, String> recordTypeMapping = new Map<String, String>{
                'CustomerInitial' => '101',
                    'CustomerExtend' => '102',
                    'CustomerEditInfo' => '103',
                    'CustomerChangeCrCond' => '104',
                    'CustomerBlock' => '109',
                    'SupplierInitial' => '201',
                    'SupplierExtend' => '202',
                    'SupplierEditInfo' => '203',
                    'SupplierChangeCrCond' => '204',
                    'SupplierBlock' => '209',
                    'HedgingInitial' => '301',
                    'HedgingEditInfo' => '303',
                    'HedgingChangeCrCond' => '304',
                    'ShipToCheckCountry' => '406',
                    'ShipToCreate' => '407',
                    'ShipToEdit' => '408',
                    'MasterChangeAnnualReview' => '510',
                    'MasterChangeMassUpdate' => '511'
                    };
                        
            Map<Id,RecordType> records = new Map<Id, RecordType>([SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c']);

            Boolean isUpdateCustomSetting = false;
            for(CTRRequestFormItem__c mItem: mRequestItemList)
            {
                RecordType mRecordType = records.get(mItem.RecordTypeId);
                if(mRecordType != null)
                {
                    isUpdateCustomSetting = true;
                    runningNumber++;
                    String mMapNumber = recordTypeMapping.get(mRecordType.DeveloperName);
                    mItem.Name = yearString+mMapNumber+String.valueOf(runningNumber).leftPad(4, '0');
                    mItem.UniqueRunningNumber__c = yearString+String.valueOf(runningNumber).leftPad(4, '0');
                }
            } 
            if(isUpdateCustomSetting)
            {
                customSetting.RunningNumber__c = runningNumber;
                if(!Test.isRunningTest()){
                    update customSetting;
                }
            }
            
        }
        catch(exception e)
        {
            system.debug('Error from running number line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
        
    }

    public static void updateProductToHeaderAfterUpdate(Map<Id,CTRRequestFormItem__c> mItemOldMap, Map<Id,CTRRequestFormItem__c> mItemNewMap)
    {
        try
        {
            Set<Id> mHeaderSetId = new Set<Id>();
            for(CTRRequestFormItem__c mItem: mItemNewMap.values())
            {
                if(mItem.CTRRequestFormHeader__c != null)
                {
                    if((mItem.InterestedProductTypeAsCustomerTOP__c != null && mItem.InterestedProductTypeAsCustomerTOP__c != mItemOldMap.get(mItem.Id).InterestedProductTypeAsCustomerTOP__c) ||
                    (mItem.InterestedProductTypeAsCustomerTX__c != null && mItem.InterestedProductTypeAsCustomerTX__c != mItemOldMap.get(mItem.Id).InterestedProductTypeAsCustomerTX__c) ||
                    (mItem.InterestedProductTypeAsSupplierTOP__c != null && mItem.InterestedProductTypeAsSupplierTOP__c != mItemOldMap.get(mItem.Id).InterestedProductTypeAsSupplierTOP__c)||
                    (mItem.InterestedProductTypeAsSupplierTX__c != null && mItem.InterestedProductTypeAsSupplierTX__c != mItemOldMap.get(mItem.Id).InterestedProductTypeAsSupplierTX__c))
                    {
                        mHeaderSetId.add(mItem.CTRRequestFormHeader__c);
                    }
                }
                
            }
            if(mHeaderSetId.size()>0)
            {
                List<CTRRequestFormHeader__c> mHeaderUpdateList = new List<CTRRequestFormHeader__c>();
                List<CTRRequestFormHeader__c> mHeaderList = [SELECT Id, InterestedProductTypeAsCustomerTOP__c, InterestedProductTypeAsCustomerTX__c, InterestedProductTypeAsSupplierTOP__c, InterestedProductTypeAsSupplierTX__c FROM CTRRequestFormHeader__c WHERE Id IN: mHeaderSetId];

                for(CTRRequestFormHeader__c mHeader: mHeaderList)
                {
                    String mCustomerTopProduct = '';
                    String mCustomerTxProduct = '';
                    String mSupplierTopProduct = '';
                    String mSupplierTxProduct = '';

                    for(CTRRequestFormItem__c mItem: mItemNewMap.values())
                    {
                        if(mItem.CTRRequestFormHeader__c == mHeader.Id)
                        {
                            if(mItem.InterestedProductTypeAsCustomerTOP__c != null && mItem.InterestedProductTypeAsCustomerTOP__c != mItemOldMap.get(mItem.Id).InterestedProductTypeAsCustomerTOP__c)
                            {
                                mCustomerTopProduct = (String.isBlank(mCustomerTopProduct))?mHeader.InterestedProductTypeAsCustomerTOP__c:mCustomerTopProduct;
                                mCustomerTopProduct = ProductManagement(mCustomerTopProduct, mItem.InterestedProductTypeAsCustomerTOP__c);
                            }
                            if(mItem.InterestedProductTypeAsCustomerTX__c != null && mItem.InterestedProductTypeAsCustomerTX__c != mItemOldMap.get(mItem.Id).InterestedProductTypeAsCustomerTX__c)
                            {
                                mCustomerTxProduct = (String.isBlank(mCustomerTxProduct))?mHeader.InterestedProductTypeAsCustomerTX__c:mCustomerTxProduct;
                                mCustomerTxProduct = ProductManagement(mCustomerTxProduct, mItem.InterestedProductTypeAsCustomerTX__c);
                            }
                            if(mItem.InterestedProductTypeAsSupplierTOP__c != null && mItem.InterestedProductTypeAsSupplierTOP__c != mItemOldMap.get(mItem.Id).InterestedProductTypeAsSupplierTOP__c)
                            {
                                mSupplierTopProduct = (String.isBlank(mSupplierTopProduct))?mHeader.InterestedProductTypeAsSupplierTOP__c:mSupplierTopProduct;
                                mSupplierTopProduct = ProductManagement(mSupplierTopProduct, mItem.InterestedProductTypeAsSupplierTOP__c);
                            }
                            if(mItem.InterestedProductTypeAsSupplierTX__c != null && mItem.InterestedProductTypeAsSupplierTX__c != mItemOldMap.get(mItem.Id).InterestedProductTypeAsSupplierTX__c)
                            {
                                mSupplierTxProduct = (String.isBlank(mSupplierTxProduct))?mHeader.InterestedProductTypeAsSupplierTX__c:mSupplierTxProduct;
                                mSupplierTxProduct = ProductManagement(mSupplierTxProduct, mItem.InterestedProductTypeAsSupplierTX__c);
                            }
                        }
                    }
                    if(String.isNotBlank(mCustomerTopProduct) || String.isNotBlank(mCustomerTxProduct) || String.isNotBlank(mSupplierTopProduct)|| String.isNotBlank(mSupplierTxProduct))
                    {
                        CTRRequestFormHeader__c mUpdateHeader = new CTRRequestFormHeader__c(Id = mHeader.Id);
                        if(String.isNotBlank(mCustomerTopProduct))
                        {
                            mUpdateHeader.InterestedProductTypeAsCustomerTOP__c = mCustomerTopProduct;
                        }
                        if(String.isNotBlank(mCustomerTxProduct))
                        {
                            mUpdateHeader.InterestedProductTypeAsCustomerTX__c = mCustomerTxProduct;
                        }
                        if(String.isNotBlank(mSupplierTopProduct))
                        {
                            mUpdateHeader.InterestedProductTypeAsSupplierTOP__c = mSupplierTopProduct;
                        }
                        if(String.isNotBlank(mSupplierTxProduct))
                        {
                            mUpdateHeader.InterestedProductTypeAsSupplierTX__c = mSupplierTxProduct;
                        }
                        mHeaderUpdateList.add(mUpdateHeader);
                    }
                }
                if(mHeaderUpdateList.size()>0)
                {
                    update mHeaderUpdateList;
                }
            }
        }
        catch(exception e)
        {
            system.debug('Error from updateProductToHeaderAfterUpdate line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static String ProductManagement(String mHeaderProduct, String mItemProduct)
    {
        String mProduct = '';
        List<string> mHeaderProductList = mHeaderProduct.split(';');
        List<string> mItemProductList = mItemProduct.split(';');
        Set<String> mProductSet = new Set<String>();
        if(mProductSet.size()>0)
        {
            for(String mProducts: mHeaderProductList)
            {
                mProductSet.add(mProducts);
            }
        }
        if(mItemProductList.size()>0)
        {
            for(String mProducts: mItemProductList)
            {
                mProductSet.add(mProducts);
            }
        }
        List<String> mProductList =  new List<String>();
        mProductList.addall(mProductSet);
        if(mProductList.size()>0)
        {
            for(Integer i = 0; i<= mProductList.size(); i++)
            {
                if(i == 0)
                {
                    mProduct += mProductList[i];
                }
                else
                {
                    mProduct += ';'+mProductList[i];
                }
            }
        }
        return mProduct;
    }
    public static void savepointOriginalValueForEditTypeAfterInsert(List<CTRRequestFormItem__c> mItemList)
    {
        try
        {
            Set<Id> mItemSetId = new Set<Id>();
            Set<Id> mHeaderSetId = new Set<Id>();
            for(CTRRequestFormItem__c mItem: mItemList)
            {
                System.debug('RecordType'+mItem.RecordTypeName__c);
                if(mItem.RecordTypeName__c.contains('Edit'))
                {
                    mItemSetId.add(mItem.Id);
                    if(mItem.CTRRequestFormHeader__c != null)
                    {
                        mHeaderSetId.add(mItem.CTRRequestFormHeader__c);
                    }
                }
            }
            if(mItemSetId.size()>0)
            {
                saveOriginalJsonCounterPartySet(mHeaderSetId,mItemSetId, 'Edit');
            }
        }
        catch(exception e)
        {
            system.debug('Error from savepointJsonInitialAfterUpdate line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }
    
    public static void savepointCounterPartyJsonInitialAfterUpdate(Map<Id,CTRRequestFormItem__c> mItemOldMap, Map<Id,CTRRequestFormItem__c> mItemNewMap)
    {
        try
        {
            Set<Id> mItemSetId = new Set<Id>();
            Set<Id> mHeaderSetId = new Set<Id>();
            for(CTRRequestFormItem__c mItem: mItemNewMap.values())
            {
                if(mItem.RecordTypeName__c.contains('Initial') && (mItem.BusinessUnit__c == 'TOP' || mItem.BusinessUnit__c == 'LABIX'))
                {
                    if(mItem.Status__c != mItemOldMap.get(mItem.Id).Status__c)
                    {
                        if(mItem.Status__c == 'In Review' && mItemOldMap.get(mItem.Id).Status__c == 'New')
                        {
                            mItemSetId.add(mItem.Id);
                            if(mItem.CTRRequestFormHeader__c != null)
                            {
                                mHeaderSetId.add(mItem.CTRRequestFormHeader__c);
                            }
                        }
                    }
                }
            }
            if(mItemSetId.size()>0)
            {
                saveOriginalJsonCounterPartySet(mHeaderSetId,mItemSetId, 'Initial');
            }
        }
        catch(exception e)
        {
            system.debug('Error from savepointJsonInitialAfterUpdate line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void saveOriginalJsonCounterPartySet (Set<Id> mHeaderSetId, Set<Id> mItemSetId, String mType)
    {
        try
        {
            System.debug('mHeaderSetId:'+mHeaderSetId);

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
                        Map<String, String> mCountryJsonMap = new Map<String, String>();
                        Map<String, String> mItemJsonMap = new Map<String, String>();

                        if(mType == 'Edit')
                        {
                            String mItemObjName = 'CTRRequestFormItem__c';
                            List<CTRFieldEditLog__mdt> mSAPInfoFieldLogList = [SELECT Id, Source__c, FieldList__c, Object__c FROM CTRFieldEditLog__mdt WHERE Source__c = 'SAP Information' AND Object__c = :mItemObjName];
                            if(mSAPInfoFieldLogList.size()>0)
                            {
                                List<String> mSAPInfoFieldList = CTRRequestEditLogFieldController.getFieldListFromJson(mSAPInfoFieldLogList[0].FieldList__c, mItemObjName);
                                if(mSAPInfoFieldList.size()>0)
                                {
                                    List<SObject> mItemList = new List<SObject>();
                                    String mItemsoql = '';
                                    mItemsoql+= ' SELECT ' + String.join(mSAPInfoFieldList, ',');
                                    mItemsoql+= ' FROM '+mItemObjName;
                                    mItemsoql+= ' WHERE Id IN :mItemSetId ';
                                    mItemList = Database.query(mItemsoql);
                                    if(mItemList.size()>0)
                                    {
                                        mItemJsonMap = CTRRequestEditLogFieldController.manageRelatedObjectToJson(mItemList,  mSAPInfoFieldList ,mItemSetId, mItemObjName);
                                    }
                                }
                            }
                        }
                        //DestinationCountry Json log
                        String mDestinationCountryObjName = 'CTRShippingCountry__c';
                        //List<String> mCountryFieldList = new List<String>{'ShippingCountry__c', 'LocationType__c', 'CTRRequestFormItem__c'};
                        List<String> mCountryFieldList = CTRRequestEditLogFieldController.getFieldListFromJson(mFieldListMap.get(mDestinationCountryObjName), mDestinationCountryObjName);
                        if(mCountryFieldList.size()>0)
                        {
                            List<SObject> mDestinationCountryList = new List<SObject>();
                            String mDestinationCountrysoql = '';
                            mDestinationCountrysoql+= ' SELECT ' + String.join(mCountryFieldList, ',');
                            mDestinationCountrysoql+= ' FROM '+mDestinationCountryObjName;
                            mDestinationCountrysoql+= ' WHERE CTRRequestFormItem__c IN :mItemSetId ';
                            mDestinationCountryList = Database.query(mDestinationCountrysoql);
                            if(mDestinationCountryList.size()>0)
                            {
                                mCountryJsonMap = CTRRequestEditLogFieldController.manageRelatedObjectToJson(mDestinationCountryList,  mCountryFieldList ,mItemSetId, mDestinationCountryObjName);
                                
                            }
                        }
                        if(mCountryJsonMap.size()>0 || mItemJsonMap.size()>0)
                        {
                            List<CTRRequestFormItem__c> mItemUpdateList = new List<CTRRequestFormItem__c>();
                            for(Id mItemId: mItemSetId)
                            {
                                    CTRRequestFormItem__c mItemUpdate = new CTRRequestFormItem__c(Id = mItemId);
                                    mItemUpdate.InternalOriginalField__c = (mItemJsonMap.get(mItemId)!= null && String.isNotBlank(mItemJsonMap.get(mItemId)))?mItemJsonMap.get(mItemId):'[]';
                                    mItemUpdate.OriginalDestinationCountry__c = (mCountryJsonMap.get(mItemId)!= null && String.isNotBlank(mCountryJsonMap.get(mItemId)))?mCountryJsonMap.get(mItemId):'[]';
                                    mItemUpdateList.add(mItemUpdate);
                                
                            }
                            if(mItemUpdateList.size()>0)
                            {
                                update mItemUpdateList;
                            }
                        }
                        System.debug('mHeaderSetId:'+mHeaderSetId);
                        //Header
                        if(mHeaderSetId.size()>0)
                        {
                            //Shareholder Json log
                            String mShareholderObjName = 'CTRShareholder__c';
                            Map<String, String> mShareholderJsonMap = new Map<String, String>();
                            //List<String> mShareholderFieldList = new List<String>{'of_Shareholder__c', 'Name', 'CTRRequestFormHeader__c'};
                            List<String> mShareholderFieldList = CTRRequestEditLogFieldController.getFieldListFromJson(mFieldListMap.get(mShareholderObjName), mShareholderObjName);
                            List<SObject> mShareholderList = new List<SObject>();
                            if(mShareholderFieldList.size()>0)
                            {
                                String mShareholdersoql = '';
                                mShareholdersoql+= ' SELECT ' + String.join(mShareholderFieldList, ',');
                                mShareholdersoql+= ' FROM '+mShareholderObjName;
                                mShareholdersoql+= ' WHERE CTRRequestFormHeader__c IN :mHeaderSetId ';
                                mShareholderList = Database.query(mShareholdersoql);
                                if(mShareholderList.size()>0)
                                {
                                    mShareholderJsonMap = CTRRequestEditLogFieldController.manageRelatedObjectToJson(mShareholderList,  mShareholderFieldList ,mHeaderSetId, mShareholderObjName);
                                }
                            }
                            

                            //Counterparty
                            String mHeaderObjectName = 'CTRRequestFormHeader__c';
                            Map<Id, String> mCounterPartyJsonMapResult = new Map<Id, String>();
                            List<SObject> mHeaderFilteredList = new List<SObject>();

                                List<String> mHeaderFieldNameList = CTRRequestEditLogFieldController.getFieldListFromJson(mFieldListMap.get(mHeaderObjectName), mHeaderObjectName);
                                if(mHeaderFieldNameList.size()>0)
                                {
                                    //List<String> mHeaderFields = new List<String>(Schema.getGlobalDescribe().get(mObjectName).getDescribe().fields.getMap().keySet());            
                                    String mHeadersoql = '';
                                    mHeadersoql+= ' SELECT ' + String.join(mHeaderFieldNameList, ',');
                                    mHeadersoql+= ' FROM '+mHeaderObjectName;
                                    mHeadersoql+= ' WHERE Id IN :mHeaderSetId ';
                                    mHeaderFilteredList = Database.query(mHeadersoql);

                                    if(mHeaderFilteredList.size()>0)
                                    {
                                        mCounterPartyJsonMapResult = CTRRequestEditLogFieldController.SavePointValueRecordToJson(mHeaderFilteredList, mHeaderFieldNameList, mHeaderObjectName);
                                    }
                                }
                                System.debug('mHeaderFilteredList:'+mHeaderFilteredList);

                                System.debug('mCounterPartyJsonMapResult:'+mCounterPartyJsonMapResult);

                            if(mCounterPartyJsonMapResult.size()>0 || mShareholderJsonMap.size()>0)
                            {
                                System.debug('mCounterPartyJsonMapResult:'+mCounterPartyJsonMapResult);
                                List<CTRRequestFormHeader__c> mHeaderUpdateList = new List<CTRRequestFormHeader__c> ();
                                for(Id mHeaderId: mHeaderSetId)
                                {
                                    CTRRequestFormHeader__c mHeaderUpdate = new CTRRequestFormHeader__c(Id = mHeaderId);
                                    mHeaderUpdate.InternalOriginalField__c = (String.isNotBlank(mCounterPartyJsonMapResult.get(mHeaderId)))?mCounterPartyJsonMapResult.get(mHeaderId):'[]';
                                    mHeaderUpdate.OriginalShareholder__c = (String.isNotBlank(mShareholderJsonMap.get(mHeaderId)))?mShareholderJsonMap.get(mHeaderId):'[]';
                                    mHeaderUpdateList.add(mHeaderUpdate);
                                }
                                if(mHeaderUpdateList.size()>0)
                                {
                                    update mHeaderUpdateList;
                                }
                            }
                        }
                    }
                    
                    
                }
        }
        catch(exception e)
        {
            system.debug('Error from saveOriginalJson line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void checkEditSensitiveFieldAfterUpdate(Map<Id,CTRRequestFormItem__c> mItemOldMap, Map<Id,CTRRequestFormItem__c> mItemNewMap)
    {
        try
        {
            Set<String> mTypeSet = new Set<String>();
            Set<Id> mHeaderSetId = new Set<Id>();
            List<CTRRequestFormItem__c> mItemFilteredList = new List<CTRRequestFormItem__c>();
            Map<String, String> mAllFieldChangedMap = new Map<String, String>();
            Map<String, String> mBuMap = new Map<String, String>();
            for(CTRRequestFormItem__c mItem: mItemNewMap.values())
            {
                if(mItem.RecordTypeName__c.contains('Edit') && mItem.Sensitive__c == false)
                {
                    if(mItem.CheckSensitiveField__c == true && mItem.CheckSensitiveField__c != mItemOldMap.get(mItem.Id).CheckSensitiveField__c)
                    {
                        mBuMap.put(mItem.Id, mItem.BusinessUnit__c);
                        mItemFilteredList.add(mItem);
                        if(mItem.InternalEditField__c != null)
                        {
                            mAllFieldChangedMap.put(mItem.Id, mItem.InternalEditField__c);
                        }
                        if(mItem.CTRRequestFormHeader__c != null)
                        {
                            mHeaderSetId.add(mItem.CTRRequestFormHeader__c);
                        }
                    }
                }
            }
            if(mItemFilteredList.size()>0)
            {
                List<CTRSensitiveFieldList__mdt> mSensitiveFieldList = [SELECT Id, SensitiveField__c, ObjectName__c, SupportType__c, Type__c, BusinessUnit__c FROM CTRSensitiveFieldList__mdt WHERE SupportType__c LIKE '%Edit%'];
                List<CTRRequestFormItem__c> mItemUpdateList = new List<CTRRequestFormItem__c>();
                List<CTRRequestFormHeader__c> mHeaderList = new List<CTRRequestFormHeader__c>();
                Map<String, String> mAllHeaderFieldChangedMap = new Map<String, String>();
                if(mHeaderSetId.size()>0)
                {
                    mHeaderList = [SELECT Id, InternalEditField__c FROM CTRRequestFormHeader__c WHERE ID IN: mHeaderSetId];
                    for(CTRRequestFormHeader__c mHeader: mHeaderList)
                    {
                        if(mHeader.InternalEditField__c != null)
                        {
                            mAllHeaderFieldChangedMap.put(mHeader.Id, mHeader.InternalEditField__c);
                        }
                    }
                }
                for(CTRRequestFormItem__c mItem: mItemFilteredList)
                {
                    Map<Id, CTRSensitiveFieldList__mdt> mSensitiveFiledMap = new Map<Id, CTRSensitiveFieldList__mdt>();
                    for(CTRSensitiveFieldList__mdt mSensitive: mSensitiveFieldList)
                    {
                        //finding sensitive field set
                        if(mItem.BusinessUnit__c == mSensitive.BusinessUnit__c && mItem.RecordTypeName__c.contains(mSensitive.Type__c))
                        {
                            if(mSensitive.ObjectName__c == 'CTRRequestFormHeader__c')
                            {
                                if(mItem.CTRRequestFormHeader__c != null)
                                {
                                    mSensitiveFiledMap.put(mItem.CTRRequestFormHeader__c, mSensitive);
                                }
                            }
                            else if(mSensitive.ObjectName__c == 'CTRRequestFormItem__c')
                            {
                                mSensitiveFiledMap.put(mItem.Id, mSensitive);
                            }
                        }
                    }
                    if(mSensitiveFiledMap.size()>0)
                    {
                        Boolean mResultSensitive = false;
                        Boolean isHeaderSensitive = false;
                        Boolean isItemSensitive = false;
                        String mHeaderJson = '';
                        String mItemJson = (String.isNotBlank(mItem.InternalEditField__c))?mItem.InternalEditField__c:'';
                        CTRSensitiveFieldList__mdt mSensitiveFieldItem = mSensitiveFiledMap.get(mItem.Id);
                        CTRSensitiveFieldList__mdt mSensitiveFieldHeader;
                        if(mItem.CTRRequestFormHeader__c != null)
                        {
                            mSensitiveFieldHeader = mSensitiveFiledMap.get(mItem.CTRRequestFormHeader__c);
                            mHeaderJson = mAllHeaderFieldChangedMap.get(mItem.CTRRequestFormHeader__c);
                        }
                        if(mSensitiveFieldHeader!= null && String.isNotBlank(mHeaderJson))
                        {
                            isHeaderSensitive = checkEditSensitiveFieldFromJson(mHeaderJson, mSensitiveFieldHeader.SensitiveField__c);
                        }
                        if(mSensitiveFieldItem != null &&  String.isNotBlank(mItemJson))
                        {
                            isItemSensitive = checkEditSensitiveFieldFromJson(mItemJson, mSensitiveFieldItem.SensitiveField__c);
                        }
                        if(isHeaderSensitive || isItemSensitive)
                        {
                            mResultSensitive = true;
                        }
                        CTRRequestFormItem__c mItemUpdate = new CTRRequestFormItem__c(Id = mItem.Id);
                        mItemUpdate.CheckSensitiveField__c = false;
                        if(mResultSensitive)
                        {
                            mItemUpdate.Sensitive__c = mResultSensitive;
                        }
                        mItemUpdateList.add(mItemUpdate);
                    }
                    
                }
                if(mItemUpdateList.size()>0)
                {
                    update mItemUpdateList;
                }
            }
        }
        catch(exception e)
        {
            system.debug('Error from checkEditSensitiveFieldAfterUpdate line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static boolean checkEditSensitiveFieldFromJson(String mJson, String mSensitiveField)
    {
        try
        {
            Boolean isSensitive = false;
            List<Object> mSensitiveFieldList = CTRRequestEditLogFieldController.convertJsonToObject(mSensitiveField);
            List<Object> mChangedFieldList = CTRRequestEditLogFieldController.convertJsonToObject(mJson);
            for(Object mChangedField: mChangedFieldList)
            {
                Map<String,Object> mChangedFieldData = (Map<String,Object>)mChangedField;
                String mApi = (String)mChangedFieldData.get('Api');
                for(Object mSensitiveFiled: mSensitiveFieldList)
                {
                    Map<String,Object> mSensitiveFiledData = (Map<String,Object>)mSensitiveFiled;
                    if(mApi == (String)mSensitiveFiledData.get('Api'))
                    {
                        isSensitive = true;
                        break;
                    }
                }
                if(isSensitive)
                {
                    break;
                }
            }
            return isSensitive;
        }
        catch(exception e)
        {
            system.debug('Error from checkEditSensitiveFieldFromJson line:'+e.getLineNumber()+' || Message: '+e.getMessage());
            return false;
        }
    }

    public static void CreateFolderSharePointAfterCreate(List<CTRRequestFormItem__c> mItemList)
    {
        try
        {
            Set<Id> mItemSetId = new Set<Id>();
            for(CTRRequestFormItem__c mItem: mItemList)
            {
                if(String.isNotBlank(mItem.SharePointSubFolderName__c) && mItem.Customer__c != null && mItem.MainSharePointFolderIsReady__c == true)
                {
                    mItemSetId.add(mItem.id);
                }
            }
            if(mItemSetId.size() > 0)
            {
                createFolderDependtoSalesOrg(mItemSetId);
            }
        }
        catch(exception e)
        {
            system.debug('Error from CreateFolderSharePointAfterCreate line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void CreateSharePointForInitialAfterUpdate(Map<Id,CTRRequestFormItem__c> mItemOldMap, Map<Id,CTRRequestFormItem__c> mItemNewMap)
    {
        try
        {
            Set<Id> mItemSetId = new Set<Id>();
            for(CTRRequestFormItem__c mItem: mItemNewMap.values())
            {
                if(mItem.MainSharePointFolderIsReady__c == true)
                {
                    if(mItem.CreateSharePointSubFolderForInitial__c != mItemOldMap.get(mItem.Id).CreateSharePointSubFolderForInitial__c && mItem.CreateSharePointSubFolderForInitial__c == true)
                    {
                        mItemSetId.add(mItem.id);
                    }
                }
            }
            if(mItemSetId.size() > 0)
            {
                createFolderDependtoSalesOrg(mItemSetId);
            }
        }
        catch(exception e)
        {
            system.debug('Error from CreateFolderSharePointAfterCreate line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void AddNewOwnerPermissionToSharePointAfterUpdate(Map<Id,CTRRequestFormItem__c> mItemOldMap, Map<Id,CTRRequestFormItem__c> mItemNewMap)
    {
        try
        {
            Set<Id> mItemSetId = new Set<Id>();
            for(CTRRequestFormItem__c mItem: mItemNewMap.values())
            {
                if(mItem.MainSharePointFolderIsReady__c == true)
                {
                    if(mItem.OwnerId != mItemOldMap.get(mItem.Id).OwnerId && mItem.OwnerId != null)
                    {
                        if(mItem.OwnerId.getSObjectType().getDescribe().getName() == 'User')
                        {
                            mItemSetId.add(mItem.id);
                        }
                    }
                }
            }
            if(mItemSetId.size() > 0)
            {
                createFolderDependtoSalesOrg(mItemSetId);
            }
        }
        catch(exception e)
        {
            system.debug('Error from CreateFolderSharePointAfterCreate line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void createFolderDependtoSalesOrg(Set<Id> mItemSetId)
    {
        try
        {
            C360Integration__c mSetting = C360Integration__c.getInstance();
            List<CTRIntegraionList__mdt > mIntegrationList = [SELECT Id,MasterLabel, DeveloperName, Endpoint__c, Token__c, Path__c FROM CTRIntegraionList__mdt WHERE DeveloperName = 'CTRCreateFolderSharepoint'];
            //
            if(mIntegrationList.size()>0)
            {
                List<CTRRequestFormItem__c> mItemFilteredList =[SELECT Id, RecordTypeName__c ,SharePointSubFolderName__c, fmlAccountTypeName__c, Customer__c, Customer__r.SFCode__c, SubBU__c, OwnerId, Owner.Email FROM CTRRequestFormItem__c WHERE Id IN: mItemSetId];
                Set<String> mSubBUSet = new Set<String>();
                Set<String> mEmployeeSet = new Set<String>();
                for(CTRRequestFormItem__c mItem: mItemFilteredList)
                {
                    if(String.isNotBlank(mItem.SubBU__c))
                    {
                        mSubBUSet.add(mItem.SubBU__c);
                    }
                }
                List<User> mUserList = new List<User>();
                List<CTRActorInProcess__mdt> mActorList = new List<CTRActorInProcess__mdt>();
                Map<String, String> mActorEmailMaping = new Map<String, String>();

                mActorList = [SELECT Id, EmployeeId__c, RecordType__c, SalesOrg__c FROM CTRActorInProcess__mdt WHERE SalesOrg__c IN: mSubBUSet];
                for(CTRActorInProcess__mdt mActor: mActorList)
                {
                    if(mActor.EmployeeId__c != null)
                    {
                        mEmployeeSet.add(mActor.EmployeeId__c); 
                    }
                }
                if(mEmployeeSet.size()>0)
                {
                   mUserList = [SELECT Id, Email, Employee_Id__c FROM User WHERE Employee_Id__c IN: mEmployeeSet AND IsActive = true];
                   if(mUserList.size()>0)
                   {
                        for(String mEmployeeId: mEmployeeSet)
                        {
                            String mEmail = '';
                            for(User mUser: mUserList)
                            {
                                if(mUser.Employee_Id__c != null && mUser.Employee_Id__c == mEmployeeId)
                                {
                                    if(mUser.Email != null)
                                    {
                                        mEmail = mUser.Email;
                                    }
                                }
                                
                            }
                            if(String.isNotBlank(mEmail))
                            {
                                mActorEmailMaping.put(mEmployeeId, mEmail);
                            }
                        }
                        
                   }
                }
                for(CTRRequestFormItem__c mItem: mItemFilteredList)
                {
                    Set<String> mEmailSet = new Set<String>();
                    List<String> mEmailList = new List<String>();
                   
                    
                    String mFolderType = '';
                    if(mItem.RecordTypeName__c.contains('Customer')) mFolderType = 'Customer';
                    if(mItem.RecordTypeName__c.contains('Supplier')) mFolderType = 'Supplier';
                    if(mItem.RecordTypeName__c.contains('Hedging')) mFolderType = 'Hedging';
                    if(String.isNotBlank(mFolderType))
                    {

                        for(CTRActorInProcess__mdt mActor: mActorList)
                        {
                            if(mActor.SalesOrg__c.contains(mItem.SubBU__c) && mActor.RecordType__c == mFolderType && mActor.EmployeeId__c != null)
                            {
                                String mEmail = mActorEmailMaping.get(mActor.EmployeeId__c);
                                if(String.isNotBlank(mEmail))
                                {
                                    mEmail = mEmail.replace('.invalid', '');
                                    mEmailSet.add(mEmail);
                                }
                            }
                        }
                        mEmailSet.add(mItem.Owner.Email);
                        mEmailList.addall(mEmailSet);

                        //String mBody = '{"MainFolder": "'+mSetting.SharePointMainFolderDuringCreate__c+'","AccFolder" : "'+mItem.Customer__r.SFCode__c+'","SubFolder" : "'+mItem.SharePointSubFolderName__c+'", "Type": "'+mFolderType+'"}';
                        String mBody = CTRSharePointLinkController.manageWrapperToCreateFolder(mSetting.SharePointMainFolderDuringCreate__c, mItem.Customer__r.SFCode__c, mItem.SharePointSubFolderName__c, mFolderType, mEmailList, 'contribute');
                        if(String.isNotBlank(mBody))
                        {
                            String mEndPoint = mSetting.HerokuIntegrationDomain__c+mIntegrationList[0].Path__c;
                            String mGatewayId = Uuid.randomUUID();
                            system.enqueuejob(new CTRTriggerWebServiceQueueable(mBody, mIntegrationList[0].Token__c, mEndPoint, 'Item Folder creation', mItem.Id, mGatewayId));

                        }
                    }
                    
                }

            }
        }
        catch(exception e)
        {
            system.debug('Error from createFolderDependtoSalesOrg line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void approvedEditRecordAfterUpdate(Map<Id,CTRRequestFormItem__c> mItemOldMap, Map<Id,CTRRequestFormItem__c> mItemNewMap)
    {
        try
        {
            set<Id> mItemSetId = new set<Id>();

            for(CTRRequestFormItem__c mItem: mItemNewMap.values())
            {
                if(mItem.RecordTypeName__c.contains('Edit') && mItem.Status__c == 'Approved')
                {
                    if(mItem.Status__c == mItemOldMap.get(mItem.Id).Status__c)
                    {
                        if(mItem.EffectiveType__c == 'Immediately' || (mItem.EffectiveType__c == 'Schedule' && mItem.EffectiveDate__c <= System.Today()))
                        {
                            mItemSetId.add(mItem.Id);
                        }
                    }
                }
            }
            if(mItemSetId.size()>0)
            {
                sendEditIntegrationViaTrigger(mItemSetId);
            }
        }
        catch(exception e)
        {
            system.debug('Error from approvedEditRecordAfterUpdate line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void sendEditIntegrationViaTrigger(Set<Id> mItemSetId)
    {
        try
        {
            CTRIntegraionList__mdt mIntegrationInitialCustomer = CTRIntegraionList__mdt.getInstance('CTRCustomer');
            CTRIntegraionList__mdt mIntegrationInintialSupplier = CTRIntegraionList__mdt.getInstance('CTRSupplier');
            C360Integration__c mSetting = C360Integration__c.getInstance();

            String mIntegrationName = '';
            
            String mEndPoint = mSetting.HerokuIntegrationDomain__c;

            List<Map<String, String>> mEditDataMapWrap = new List<Map<String, String>>();
            List<CTRRequestFormItem__c> mItemList = CTRCommitteeSendToSap.geRequestItemForSendToSAP(mItemSetId);
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
                List<CTRRequestFormHeader__c> mHeaderList = CTRCommitteeSendToSap.geRequestHeaderForSendToSAP(mHeaderSetId);
                List<CTRIntegrationMapping__mdt> mAllMappingList = [SELECT Id, BusinessUnit__c, IntegrationType__c, JsonMapping__c, RecordType__c, ViewName__c, SupportIntegrationType__c FROM CTRIntegrationMapping__mdt];

                for(CTRRequestFormItem__c mItem: mItemList)
                {
                    Map<String, String> mEditDataMap = new Map<String, String>();
                    for(CTRRequestFormHeader__c mHeader: mHeaderList)
                    {
                        if(mItem.CTRRequestFormHeader__c != null && mItem.CTRRequestFormHeader__c == mHeader.Id)
                        {
                            
                            if(mItem.RecordTypeName__c.contains('Customer') && mItem.RecordTypeName__c.contains('Supplier'))
                            {
                                String mRecordTypeName = '';
                                String mPath = '';
                                String mToken = '';
                                String mGatewayId = (mItem.GatewayId__c != null)?mItem.GatewayId__c: Uuid.randomUUID();

                                if(mItem.RecordTypeName__c.contains('Customer')) 
                                {
                                    mRecordTypeName = 'Customer';
                                    mPath = mIntegrationInitialCustomer.Path__c;
                                    mToken = mIntegrationInitialCustomer.Token__c;
                                }
                                else if(mItem.RecordTypeName__c.contains('Supplier'))
                                {
                                    mRecordTypeName = 'Supplier';
                                    mPath = mIntegrationInintialSupplier.Path__c;
                                    mToken = mIntegrationInitialCustomer.Token__c;
                                }
                                if(mPath != null)
                                {
                                    String mSendType = '';
                                    String jsonInput = '';
                                    mEndPoint += mPath;

                                    if(mItem.RecordTypeName__c.contains('Edit'))
                                    {
                                        mSendType = 'Edit '+mRecordTypeName;
                                        CTRRequestItemIntegrationEditController.mapLv1 mEditData = new CTRRequestItemIntegrationEditController.mapLv1();
                                        mEditData = CTRRequestItemIntegrationEditController.SetupJsonForCTRDataModel(mAllMappingList, mHeader,mItem, mRecordTypeName, mItem.BusinessUnit__c, mGatewayId);
                                        jsonInput = JSON.serialize(mEditData);
                                    }
                                    if(mItem.RecordTypeName__c.contains('Block'))
                                    {
                                        if(mItem.RecordTypeName__c.contains('Customer')) 
                                        {
                                            mSendType = 'Block '+mRecordTypeName;
                                            CTRBlockRequestFormItemModelData mBlockData = new CTRBlockRequestFormItemModelData();
                                            mBlockData = CTRBlockRequestFormItemModelData.SetupJsonForBlockDataModel(mHeader,mItem,'SoldTo' , mItem.BusinessUnit__c, mGatewayId);
                                            jsonInput = JSON.serialize(mBlockData);
                                        }
                                        if(mItem.RecordTypeName__c.contains('Supplier'))
                                        {
                                            mSendType = 'Block '+mRecordTypeName;
                                            CTRBlockSupplierRequestFormItemModelData mBlockSupplier = new CTRBlockSupplierRequestFormItemModelData();
                                            mBlockSupplier = CTRBlockSupplierRequestFormItemModelData.SetupJsonForBlockDataModel(mHeader,mItem, '', mItem.BusinessUnit__c, mGatewayId);
                                            jsonInput = JSON.serialize(mBlockSupplier);
                                        }
                                    }
                                    
                                    if(String.isNotBlank(jsonInput))
                                    {
                                        mEditDataMap.put('mBody',jsonInput);
                                        mEditDataMap.put('mEndPoint',mEndPoint);
                                        mEditDataMap.put('mGatewayId',mGatewayId);
                                        mEditDataMap.put('mRequestId', mItem.Id);
                                        mEditDataMap.put('mToken', mToken);
                                        mEditDataMap.put('mSendType', mSendType);
                                    }
                                }
                            }
                        }
                    }
                    if(mEditDataMap.size()>0)
                    {
                        for( Map<String, String> mDataToSend: mEditDataMapWrap)
                        {
                            system.enqueuejob(new CTRTriggerWebServiceQueueable(mDataToSend.get('mBody'), mDataToSend.get('mToken'), mDataToSend.get('mEndPoint'), mDataToSend.get('mSendType'),mDataToSend.get('mAccountId'), mDataToSend.get('mGatewayId')));
                        }
                    }

                }
            }
            
        }
        catch(exception e)
        {
            system.debug('Error from sendEditIntegrationViaTrigger line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void generateNewJsonCompareHeaderToAccountJson(Set<Id> mCustomerSetId, Set<Id> mHeaderSetId ,Set<Id> mItemSetId, String mType)
    {
        try
        {
            Map<Id, String> mItemFilteredGeneralJsonMapResult = new Map<Id, String>();
                List<CTRRequestFormItem__c> mItemList = [SELECT Id, CTRRequestFormHeader__c, CTRRequestFormHeader__r.InternalEditField__c, InternalEditField__c, RecordTypeId, RecordType.DeveloperName,
                                                        Customer__c, Customer__r.AccountNumber__c, Customer__r.SupplierNumber__c
                                                        FROM CTRRequestFormItem__c WHERE ID IN: mItemSetId];

                List<CTRRequestFormHeader__c> mHeaderList = [SELECT ID, Customer__c, Customer__r.AccountNumber__c, Customer__r.SupplierNumber__c, InternalEditField__c, RecordTypeId, RecordType.DeveloperName 
                                                        FROM CTRRequestFormHeader__c WHERE ID IN: mHeaderSetId];

                List<CTRFieldEditLog__mdt> mCounterPartyFieldLogList = [SELECT Id, Source__c, FieldList__c, Object__c FROM CTRFieldEditLog__mdt WHERE Source__c = 'Counter party'];

                Map<Id, String> mAccountJsonMapResult = new Map<Id, String>();
                Map<Id, String> mHeaderJsonMapResult = new Map<Id, String>();
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
                        String mAccountObjName = 'Account';

                        List<String> mAccountFieldList = CTRRequestEditLogFieldController.getFieldListFromJson(mFieldListMap.get(mAccountObjName), mAccountObjName);
                        if(mAccountFieldList.size()>0)
                        {
                            List<SObject> mAccountList = new List<SObject>();
                            String mAccountsoql = '';
                            mAccountsoql+= ' SELECT ' + String.join(mAccountFieldList, ',');
                            mAccountsoql+= ' FROM '+mAccountObjName;
                            mAccountsoql+= ' WHERE Id IN :mCustomerSetId ';
                            mAccountList = Database.query(mAccountsoql);
                            if(mAccountList.size()>0)
                            {
                                mAccountJsonMapResult = CTRRequestEditLogFieldController.SavePointValueRecordToJson(mAccountList, mAccountFieldList, mAccountObjName);
                            }
                        }
                        if(mAccountJsonMapResult.size()>0)
                        {
                            for(String mAccountId: mCustomerSetId)
                            {
                                String mAccountOriginalValue = mAccountJsonMapResult.get(mAccountId);
                                if(mAccountOriginalValue != null)
                                {
                                    //Replace Account Different Api To Mapping
                                    mAccountOriginalValue = mAccountOriginalValue.replace('"Api": "Phone"','"Api": "Phone__c"');
                                    mAccountOriginalValue = mAccountOriginalValue.replace('"Api": "Fax"','"Api": "Fax__c"');
                                    mAccountOriginalValue = mAccountOriginalValue.replace('"Api": "Website"','"Api": "CompanyWebsite__c"');
                                    mAccountOriginalValue = mAccountOriginalValue.replace('"Api": "Location__Latitude__s"','"Api": "LocationInGoogleMapsGeolocation__Latitude__s"');
                                    mAccountOriginalValue = mAccountOriginalValue.replace('"Api": "Location__Latitude__s"','"Api": "LocationInGoogleMapsGeolocation__Longitude__s"');
                                    mAccountJsonMapResult.put(mAccountId, mAccountOriginalValue);
                                }
                            }
                            Map<String, String> mGeneralChangedFieldMap = new Map<String, String>();
                            


                            
                        }
                    }
                }
                if(mHeaderList.size()>0)
                {
                    for(CTRRequestFormHeader__c mHeader: mHeaderList)
                    {
                        if(mHeader.InternalEditField__c != null)
                        {
                            mHeaderJsonMapResult.put(mHeader.Id, mHeader.InternalEditField__c);
                        }
                    }
                }
                for(CTRRequestFormItem__c mItem: mItemList)
                {
                    if(mItem.CTRRequestFormHeader__c != null && mItem.Customer__c != null)
                    {
                        String mAccountJson = mAccountJsonMapResult.get(mItem.Customer__c);
                        String mHeaderJson = mHeaderJsonMapResult.get(mItem.CTRRequestFormHeader__c);
                        if((mItem.RecordType.DeveloperName.contains('Customer') && mItem.Customer__r.AccountNumber__c == null) ||
                        (mItem.RecordType.DeveloperName.contains('ShipTo') && mItem.Customer__r.AccountNumber__c == null) ||
                        (mItem.RecordType.DeveloperName.contains('Supplier') && mItem.Customer__r.SupplierNumber__c == null))
                        {
                            mItemFilteredGeneralJsonMapResult.put(mItem.Id, mHeaderJson);
                        }
                        else
                        {

                        }
                    }
                }
            
        }
        catch(exception e)
        {
            system.debug('Error from compareHeaderToAccountJson line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    public static void SAPConfirmedToUpdateAccount(Set<Id> mItemSetId)
    {
        try
        {

        }
        catch(exception e)
        {
            system.debug('Error from SAPConfirmedToUpdateAccount line:'+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }
    



}