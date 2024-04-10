public class CTRInitialCustomerTOP 
{
    @AuraEnabled
    public static CTRAccountCtrl.duplicateCheckResult checkDupAccount(String jsonData,List<CTRShareholder__c>shareholderList,List<CTRShippingCountry__c>shippingList){
        
        try
        {
            System.debug(' Accomplished: '+jsonData);
            
            Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonData);
            System.debug(' cObjMap: '+cObjMap);
            String cObjJson = JSON.serialize(cObjMap);
            System.debug(' cObjJson: '+cObjJson);
            Map<String, Object> cObjMapFurious = (Map<String, Object>) JSON.deserializeUntyped(cObjJson);
            String cObjJsonDrunk = JSON.serialize(cObjMapFurious);
            
            Account accobj = (Account)JSON.deserialize(cObjJsonDrunk, Account.class);
            System.debug(' Accomplished: '+accobj);
            
            CTRAccountCtrl.duplicateCheckResult isdup = CTRAccountCtrl.checkDuplicateAccount(accobj,shippingList,shareholderList, null);
            System.debug(' isdup: '+isdup);
            return isdup;
        }
        catch(Exception e)
        {
            String mError = 'CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber();
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());            
            return new CTRAccountCtrl.DuplicateCheckResult(null, e.getMessage(), null, null );
        }
    }
    @AuraEnabled
    public static Account getAccInfomation(String recordId){
        try 
        {
            List<Account> acc = [select RecordType.Name,PaymentOverTheAmountOfUSD__c
                           ,ViolatingAntiMoneyLaunderingLaws__c,EnvironmentPolicy__c,
                           OccupationalHealthAndSafetyPolicy__c,CorporateGovernancePolicy__c,
                           TypeOfBusiness__c, TypeOfBusinessCommercialEvaluation__c
                           from Account where id =: recordId];
            return acc[0];
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null	;
        }
    }
    
    @AuraEnabled
    public static CTRRequestFormHeader__c getHeaderInfomation(String recordId){
        try 
        {
            /*List<CTRRequestFormHeader__c> header = [SELECT PaymentOverTheAmountOfUSD__c
                           ,ViolatingAntiMoneyLaunderingLaws__c,EnvironmentPolicy__c,
                           OccupationalHealthAndSafetyPolicy__c,CorporateGovernancePolicy__c,
                           TypeOfBusiness__c,Customer__c, RecordTypeId, RecordType.DeveloperName,

                           FROM CTRRequestFormHeader__c WHERE id =: recordId];*/

            List<String> mRequestHeaderFields = new List<String>(CTRRequestFormHeader__c.SObjectType.getDescribe().fields.getMap().keySet());            
                String soqlHeader = ''
                    + ' SELECT ' + String.join(mRequestHeaderFields, ',')
                    + ' ,Customer__r.AccountNumber__c, RecordType.DeveloperName'
                    + ' ,Customer__r.SupplierNumber__c'
                    + ' FROM CTRRequestFormHeader__c'
                    + ' WHERE ID = :recordId LIMIT 1'; 
            List<CTRRequestFormHeader__c> mHeaderList = Database.query(soqlHeader);
            return mHeaderList[0];
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null	;
        }
    }
    
    @AuraEnabled
    public static List<CTRShareholder__c> getShareHolderInfo(String recordId){
        try 
        {
            List<CTRShareholder__c> shList = [select Name,of_Shareholder__c from CTRShareholder__c where CTRRequestFormHeader__c =: recordId];
            return shList;
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null	;
        }
    }
    
    @AuraEnabled
    public static List<CTRShippingCountry__c> getShippingCountryInfo(String recordId){
        try 
        {
            List<CTRShippingCountry__c> spList = [select ShippingCountry__c,LocationType__c from CTRShippingCountry__c where CTRRequestFormItem__c =: recordId];
            return spList;
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null	;
        }
    }

    @AuraEnabled
    public static User getCurrentUserName(String userId){
        try 
        {
            List<User> mUser = [SELECT Id, Name, UserRole.name,Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
            return mUser[0];
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null;
        }
    }
    
    @AuraEnabled
    public static String getUserInfomation(){
        try 
        {
            //List<User> u = [select Name,UserRole.name,Profile.Name from user where id =: UserInfo.getUserId()];
            //system.debug('getUserInfo---'+u);
            Id mUserId = UserInfo.getUserId();
            System.debug('mUserId: '+mUserId);
            CTRBuProfile__mdt mBU = validateUserProfile(mUserId, null);
            System.debug('mBU.BusinessUnit__c: '+mBU.BusinessUnit__c);
            return mBU.BusinessUnit__c;
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber()); 
            return '';
        }
    }
    
    @AuraEnabled
    public static String getObjectAPIFromId(Id recordId){
        try 
        {
            String sobjectType = recordId.getSObjectType().getDescribe().getName();
            system.debug('sobjectType--'+sobjectType);
            return sobjectType;
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return 'CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber();
        }
    }
    
    @AuraEnabled
    public static CTRRequestFormItem__c getReqItemInfo(String itemId){
        try 
        {
            CTRRequestFormItem__c reqFormItem = [SELECT Id,CommercialScoringBy__c,SalesOrganizationTOP__c,SalesOrganizationTX__c,Customer__c, RecordType.DeveloperName, ApproverStep__c, SHPrescreenDecision__c, TraderPrescreenDecision__c, CMVPPrescreenDecision__c,
                                          Customer__r.AccountNumber__c, Customer__r.SupplierNumber__c, CTRRequestFormHeader__c, Status__c, RecordTypeId, CTRRequestFormHeader__r.NoOfRegistrationMinistryEnergy__c,NoOfRegistrationMinistryEnergy__c,NumberRegistrationMinistryEnergy__c,
                                          CTRRequestFormHeader__r.LegalEntity__c,CTRRequestFormHeader__r.LocationInGoogleMapsLinks__c,CTRRequestFormHeader__r.CustomersFacilityTankAndStorage__c,CTRRequestFormHeader__r.CustomersFacilityTransportation__c,
                                          CTRRequestFormHeader__r.Country__r.Code__c,Yearofexperience__c,CTRRequestFormHeader__r.Yearofexperience__c,ReputationInTheMarket__c,CTRRequestFormHeader__r.TypeOfBusinessCommercialEvaluation__c
                                          ,CTRRequestFormHeader__r.SuppliersFacilityTankAndStorage__c,CTRRequestFormHeader__r.SuppliersFacilityTransportation__c,OwnerId, SubBU__c, InterestedProductTypeAsSupplierTOP__c, isTRCR__c, 
                                          CTRRequestFormHeader__r.ApprovedChangeCounterparty__c, CTRRequestFormHeader__r.DocumentSubmittedDateTime__c,CompanyCodeTOP__c,CompanyCodeTX__c, 
                                          IsOwner__c, IsCreditOwner__c, DocumentChecklistButton__c,ApprovedChangeCounterparty__c, BusinessUnit__c
                                          FROM CTRRequestFormItem__c WHERE id =: itemId];
                                          List<User> mUser = [SELECT Id, Name,UserRole.name,Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
            String Process = 'VerifyDocuments';
            String SalesOrg = reqFormItem.SubBU__c;
            String isDom = reqFormItem.CTRRequestFormHeader__r.Country__r.Code__c == 'TH' ? 'Domestic':'International';
            String RecordType = reqFormItem.RecordType.DeveloperName.contains('Customer') ? 'Customer':'Supplier';
            String Product = '';
            if(String.isNotBlank(reqFormItem.InterestedProductTypeAsSupplierTOP__c))
            {
                if(SalesOrg == 'TOP' && RecordType == 'Supplier' && reqFormItem.InterestedProductTypeAsSupplierTOP__c.contains('Crude'))
                {
                    Product = 'Crude';
                }
            }

            String isByTX = 'No';
            String VP = 'VP';
            Map<String,List<String>>actorMap = CTRRequestFormItemController.getActor(Process,SalesOrg,isDom,RecordType,Product,isByTX,'');           
            if(actorMap != null  && reqFormItem.Status__c == 'In Review')
            {
                if(actorMap.get('Credit') != null )
                {
                    if(actorMap.get('Credit').contains(UserInfo.getUserId()))
                    {
                        reqFormItem.isTRCR__c = 'true';
                    } 
                }
            }
            if(mUser[0].Profile.Name == 'System Administrator' && reqFormItem.Status__c == 'In Review')
            {
                reqFormItem.isTRCR__c = 'true';
            }
            
            return reqFormItem;
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null;
        }
    }
    
    @AuraEnabled
    public static List<CTRRequestFormItem__c> getItemEachStage(String accId,String Stage){
        try 
        {
            List<CTRRequestFormItem__c> items = new List<CTRRequestFormItem__c>();
            if(Stage == 'InReview')
            {
                items = [select id from CTRRequestFormItem__c where Customer__c =: accId AND Status__c != 'New' AND Status__c != 'Rejected' AND Status__c != 'Approved'];
            }
            else if(Stage == 'Initial')
            {
                items = [select id,CTRRequestFormHeader__c from CTRRequestFormItem__c where Customer__c =: accId AND Status__c = 'New'];
            }
            return items;
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null;
        }
    } 
    
	@AuraEnabled
    public static CTRRequestFormItem__c createShareHolderAndDestination(List<CTRShareholder__c>shareholderList,List<CTRShippingCountry__c>shippingList,
                                                        String accId, String itemId,String headerId, Boolean isAccountCreate, Boolean isTRCR){
                                                            System.debug('itemId:'+itemId);
        try 
        {
            List<CTRShareholder__c>existingSH = [select id from CTRShareholder__c where CTRRequestFormHeader__c =: headerId];
            List<CTRShippingCountry__c>existingSC = [select id from CTRShippingCountry__c where CTRRequestFormItem__c =: itemId];
            if(existingSH.size() > 0) delete existingSH;
            if(existingSC.size() > 0) delete existingSC;
      
            List<CTRShareholder__c>insertedSH = new List<CTRShareholder__c>();
            for(CTRShareholder__c item : shareholderList)
            {
                CTRShareholder__c temp = item.clone(false);
                temp.Customer__c = accId;
                temp.CTRRequestFormHeader__c = headerId;
                insertedSH.add(temp);
            }
            List<CTRShippingCountry__c>insertedShp = new List<CTRShippingCountry__c>();
            for(CTRShippingCountry__c item : shippingList)
            {
                CTRShippingCountry__c temp = item.clone(false);
                temp.Customer__c = accId;
                temp.CTRRequestFormItem__c = itemId;
                insertedShp.add(temp);
            }
            if(insertedSH.size() > 0)
            {
                insert insertedSH;
            }
            if(insertedShp.size() > 0)
            {
                insert insertedShp;
            }
            if(!isAccountCreate)
            {
                List<CTRRequestFormItem__c> mItemList = [SELECT Id, Name, BusinessUnit__c, RecordTypeName__c,Sensitive__c FROM CTRRequestFormItem__c WHERE Id =:itemId];
                CTRRequestFormItem__c mItem = new CTRRequestFormItem__c(Id = itemId);
                System.debug('Debug item '+mItemList[0]);
                if(isTRCR && (mItemList[0].BusinessUnit__c == 'TOP' || mItemList[0].BusinessUnit__c == 'LABIX'))
                {
                    System.debug('itemId:'+itemId);
                    // CTRRequestFormItem__c mItem = new CTRRequestFormItem__c(Id = itemId);
                    mItem.ApprovedChangeCounterparty__c= 'Waiting to inform';
                    mItem.ChangedCounterParty__c = true;
                    update mItem;
                }
                if(mItemList[0].RecordTypeName__c.contains('Edit') && mItemList[0].Sensitive__c == false)
                {
                    // CTRRequestFormItem__c mItem = new CTRRequestFormItem__c(Id = itemId);
                    mItem.CheckSensitiveField__c = true;
                    update mItem;
                }
                
                CTRRequestFormItem__c responseItem = [SELECT Id, Name, BusinessUnit__c, RecordTypeName__c,Sensitive__c FROM CTRRequestFormItem__c WHERE Id =:itemId LIMIT 1];
                return responseItem;
            }
            return null;
            
        }
        catch(Exception e)
        {
            system.debug('error: CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Map<String, String>> getPicklistValue(String fieldAPI,String sObjAPI){
        List<Map<String, String>> pickListValuesList= new List<Map<String, String>>();
        try 
        {
            
            Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(sObjAPI) ;
            Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe() ;
            
            Map<String,Schema.SObjectField> fields = objDescribeSobject.fields.getMap() ;
            Schema.DescribeFieldResult fieldResult = fields.get(fieldAPI).getDescribe();
            
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
                pickListValuesList.add(new Map<String, String> {'label' => pickListVal.getLabel(), 'value' => pickListVal.getValue()});
            }
            
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
        }
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static CTRBuProfile__mdt validateUserProfile(String userId, String recordId) 
    {
        //CTRBuProfile__mdt metaBU =  CTRBuProfileController.checkBusinessUnitFromProfile(userId, recordId);// prevent error
        /*Boolean isTX = false;
        if(metaBU != null)
        {
            String mBU = metaBU.BusinessUnit__c;
            isTX = (mBU == 'TX')? true: false;
            
        }*/
        return CTRBuProfileController.checkBusinessUnitFromProfile(userId, recordId);
        //return CTRSubmitRegistrationFormController.validateUserProfile(userId);
    }

    public class initialWrapper
    {
        @AuraEnabled public string mRecordTypeId {get;set;}
        @AuraEnabled public boolean allowOpenForActor {get;set;}
    }

    
    @AuraEnabled
    public static initialWrapper getAccountRecordTypeInitial(Id RecordTypeId)
    {
        boolean allowOpenForActor = false;
        User mUser = [SELECT Id, Employee_Id__c, ProfileId, Profile.Name FROM User WHERE ID =:UserInfo.getUserId()];
        List<CTRActorInProcess__mdt> mActorList = [SELECT id, EmployeeId__c  from CTRActorInProcess__mdt where Process__c = 'NewAccount'];
        for(CTRActorInProcess__mdt mActor: mActorList)
        {
            if(mActor.EmployeeId__c == mUser.Employee_Id__c || mUser.Profile.Name == 'System Administrator')
            {
                allowOpenForActor = true;
            }
        }
        initialWrapper mInit = new initialWrapper();
        mInit.mRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Initial').getRecordTypeId();
        mInit.allowOpenForActor = allowOpenForActor;
        //RecordType mType =[SELECT Id, DeveloperName FROM RecordType WHERE Id = :RecordTypeId LIMIT 1];
        //return mType.DeveloperName;
        return mInit;
    }
    

	@AuraEnabled(cacheable=true)
    public static CTRBuProfile__mdt getBUInfo(Id recordId)
    {
        try 
        {
            CTRBuProfile__mdt currentuserBU = CTRBuProfileController.checkBusinessUnitFromProfile(UserInfo.getUserId(),recordId);
            system.debug('=====currentuserBU======'+currentuserBU);
            return currentuserBU;
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null;
        }
    }
    @AuraEnabled
    public static String getRiskCountry(Id recordId){
        try 
        {
            string result ='';
            List<CTRRequestFormItem__c> RequestFormItemList = [select Country__r.Code__c from CTRRequestFormItem__c  WHERE id =:recordId ];
            system.debug('=====RequestFormItemList======'+RequestFormItemList);
            if(!RequestFormItemList.isEmpty()){
                string itemCountry = RequestFormItemList[0].Country__r.Code__c;
                system.debug('=====itemCountry======'+itemCountry);
                List<CTR_RiskCountry__c>  RiskCountryList = [select Version__c, CountryCode__c from CTR_RiskCountry__c Order by CreatedDate Desc limit 1];
                system.debug('=====RiskCountryList=1====='+RiskCountryList);
                if(!RiskCountryList.isEmpty()){
                    String lastVersion = RiskCountryList[0].Version__c;
                    system.debug('=====lastVersion======'+lastVersion);
                    RiskCountryList = [select Version__c, CountryCode__c from CTR_RiskCountry__c where Version__c =: lastVersion and CountryCode__c =: itemCountry];
                    system.debug('=====RiskCountryList=2====='+RiskCountryList);
                    if(!RiskCountryList.isEmpty()){
                        result = 'Risk';
                    }
                    else
                        result = 'Not Risk';
                }
            }
            system.debug('=====result======'+result);
            return result;
        }
        catch(Exception e)
        {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return 'CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber();
        }
    }
    
}