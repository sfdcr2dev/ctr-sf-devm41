public class CTRAccountHandler 
{

    public static void CreateFolderSharePointAfterCreate(Map<Id, Account> mAccountOldMap, Map<Id, Account> mAccountNewMap)
    {
        try
        {
            List<Account> mAccountCreateFolderList = new List<Account>();
            List<Account> mAccountReNameFolderList = new List<Account>();
            Set<Id> mAccountSetId = new Set<Id>();
            
            for(Account mAccount: mAccountNewMap.values())
            {
                if(mAccount.isMigrateData__c == false)
                {
                    if(mAccount.SubmitToCreateSharePointFolder__c == true && mAccount.SubmitToCreateSharePointFolder__c != mAccountOldMap.get(mAccount.Id).SubmitToCreateSharePointFolder__c)
                    {
                        if(mAccount.SFCode__c != null)
                        {
                            if(mAccount.LeadNo__c != null)
                            {
                                mAccountReNameFolderList.add(mAccount);
                            }
                            else
                            {
                                mAccountCreateFolderList.add(mAccount);
                            }
                        }
                    }
                }

            }
            if(mAccountReNameFolderList.size()>0 || mAccountCreateFolderList.size()>0)
            {
                C360Integration__c mSetting = C360Integration__c.getInstance();
                List<Map<String, String>> mSendDataList = new List<Map<String, String>>();
                Map<String, Object> mDataToSendMap = new Map<String, Object>();
                if(mAccountReNameFolderList.size()>0)
                {
                    List<CTRIntegraionList__mdt > mIntegrationList = [SELECT Id,MasterLabel, DeveloperName, Endpoint__c, Token__c, Path__c FROM CTRIntegraionList__mdt WHERE DeveloperName = 'CTRRenameFolderSharepoint'];
                    if(mIntegrationList.size()>0)
                    {
                        for(Account mAccount: mAccountReNameFolderList)
                        {
                            Map<String, String> mDataMap = new Map<String, String>();
                            if(String.isNotBlank(mSetting.SharePointMainFolderDuringCreate__c) && String.isNotBlank(mSetting.HerokuIntegrationDomain__c) && String.isNotBlank(mIntegrationList[0].Path__c))
                            {
                                mDataMap.put('mBody','{"MainFolder": "'+mSetting.SharePointMainFolderDuringCreate__c+'","NewFolderName" : "'+mAccount.SFCode__c+'","OldFolderName" : "'+mAccount.LeadNo__c+'"}');
                                mDataMap.put('mEndPoint',mSetting.HerokuIntegrationDomain__c+mIntegrationList[0].Path__c);
                                mDataMap.put('mGatewayId',Uuid.randomUUID());
                                mDataMap.put('mAccountId', mAccount.Id);
                                mDataMap.put('mToken', mIntegrationList[0].Token__c);
                                mDataMap.put('mSendType', 'Account Folder rename');
                            }
                            if(mDataMap.size()>0)
                            {
                                mSendDataList.add(mDataMap);
                                mDataToSendMap.put(mAccount.Id, mDataMap);
                            }

                        }
                    }
                }

                if(mAccountCreateFolderList.size()>0)
                {
                    List<CTRIntegraionList__mdt > mIntegrationList = [SELECT Id,MasterLabel, DeveloperName, Endpoint__c, Token__c, Path__c FROM CTRIntegraionList__mdt WHERE DeveloperName = 'CTRCreateFolderSharepoint'];
                    if(mIntegrationList.size()>0)
                    {
                        for(Account mAccount: mAccountCreateFolderList)
                        {
                            Map<String, String> mDataMap = new Map<String, String>();
                            if(String.isNotBlank(mSetting.SharePointMainFolderDuringCreate__c) && String.isNotBlank(mSetting.HerokuIntegrationDomain__c) && String.isNotBlank(mIntegrationList[0].Path__c))
                            {
                                String mBody = CTRSharePointLinkController.manageWrapperToCreateFolder(mSetting.SharePointMainFolderDuringCreate__c, mAccount.SFCode__c, 'Common', '', new List<String>(), '');
                                if(String.isNotBlank(mBody))
                                {
                                    mDataMap.put('mBody',mBody);
                                    mDataMap.put('mEndPoint',mSetting.HerokuIntegrationDomain__c+mIntegrationList[0].Path__c);
                                    mDataMap.put('mGatewayId',Uuid.randomUUID());
                                    mDataMap.put('mAccountId', mAccount.Id);
                                    mDataMap.put('mToken', mIntegrationList[0].Token__c);
                                    mDataMap.put('mSendType', 'Account Folder creation');
                                }
                            }
                            if(mDataMap.size()>0)
                            {
                                mSendDataList.add(mDataMap);
                                mDataToSendMap.put(mAccount.Id, mDataMap);
                            }
                            //system.enqueuejob(new CTRTriggerWebServiceQueueable(mBody, mIntegrationList[0].Token__c, mEndPoint, 'Folder creation', mAccount.Id, mGatewayId));
                        }
                    }

                }
                if(mDataToSendMap.size()>0)
                {
                    for(Map<String, String> mDataToSend: mSendDataList)
                    {
                        system.enqueuejob(new CTRTriggerWebServiceQueueable(mDataToSend.get('mBody'), mDataToSend.get('mToken'), mDataToSend.get('mEndPoint'), mDataToSend.get('mSendType'),mDataToSend.get('mAccountId'), mDataToSend.get('mGatewayId')));
                    }
                }
            }
        }
        catch(exception e)
        {
            System.debug('Error from CTRAccountHandler.CreateFolderSharePointAfterCreate Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    } 

    public static void createRequestFolderAfterSharepointFolderReady(Map<Id, Account> mAccountOldMap, Map<Id, Account> mAccountNewMap)
    {
        try
        {
            set<Id> mAccountSetId = new Set<Id>();
            for(Account mAccount: mAccountNewMap.values())
            {
                if(mAccount.CreateSharePointSubFolder__c == true && mAccount.CreateSharePointSubFolder__c != mAccountOldMap.get(mAccount.Id).CreateSharePointSubFolder__c)
                {
                    mAccountSetId.add(mAccount.Id);
                }
            }
            if(mAccountSetId.size()>0)
            {
                Map<Id, CTRRequestFormItem__c> mItemMap = new Map<Id,CTRRequestFormItem__c> ([SELECT Id, Name FROM CTRRequestFormItem__c WHERE Customer__c IN: mAccountSetId]);
                if(mItemMap.size()>0)
                {
                    CTRRequestItemHandler.createFolderDependtoSalesOrg(mItemMap.keySet());
                }
            }
        }
        catch(exception e)
        {
            System.debug('Error from CTRAccountHandler.CreateFolderSharePointAfterCreate Line: '+e.getLineNumber()+' || Message: '+e.getMessage());
        }
    }

    /*@future (callout = true)
    public static void getTokenAndCreateFolderToSharePoint(Set<Id> mAccountSetId)
    {
        //CTRHerokuController.TokenResultWrapper mTokenResult = CTRHerokuController.getToken();
        List<CTRIntegraionList__mdt > mIntegrationList = [SELECT Id,MasterLabel, DeveloperName, Endpoint__c, Token__c, Path__c
                                                            FROM CTRIntegraionList__mdt WHERE DeveloperName = 'CTRCreateFolderSharepoint'];
        //System.debug('Result Token: '+mTokenResult.mResult);

        //if(!mTokenResult.mResult.contains('error'))
        if(mIntegrationList.size()>0)
        {
            List<String> mAccountFields = new List<String>(Account.SObjectType.getDescribe().fields.getMap().keySet());
            String soqlItem = ''
            + ' SELECT ' + String.join(mAccountFields, ',')
            + ' FROM Account'
            + ' WHERE ID IN :mAccountSetId';
            List<Account> mAccountList = Database.query(soqlItem);
            C360Integration__c mSetting = C360Integration__c.getInstance();

            if(mAccountList.size()>0)
            {
                for(Account mAccount: mAccountList)
                {
                    String mBody = '{"MainFolder": "Account","Folder" : "'+mAccount.SFCode__c+'","SubFolder" : "Common"}';
                    String mEndPoint = mSetting.HerokuIntegrationDomain__c+mIntegrationList[0].Path__c;

                    HttpRequest request = new HttpRequest();
                    request.setMethod('POST');  
                    request.setHeader('Content-Type', 'application/json');
                    request.setBody(mBody);
                    request.setEndpoint(mEndPoint);
                    request.setHeader('Authorization', 'Bearer ' +  mIntegrationList[0].Token__c);

                    Http http = new Http();
                    HttpResponse response = http.send(request);

                    if (response.getStatusCode() == 200) 
                    {
                        // Successful response
                        System.debug('Success Response: ' + response.getBody());

                    } 
                    else 
                    {
                        // Error handling
                        System.debug('HTTP error: ' + response.getStatusCode() + ' ' + response.getBody());
                    }

                    //String mJson = JSON.serialize(mBody);
                    //System.enqueuejob(new CTRTriggerWebServiceQueueable(mBody, mTokenResult.mToken, mEndpoint));
                }
            }
        }
    }*/

    
}