public class CTRRequestFormItemController {  

    @AuraEnabled
    public static void getRequestItemRecordType() {
        List<SelectOption> recordTypes = new List<SelectOption>();
        for (RecordTypeInfo info: CTRRequestFormItem__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.isAvailable()) {
                recordTypes.add(new SelectOption(info.getRecordTypeId(), info.getName()));
            }
        }

        // Include these next 3 lines to output the results during development and debugging
        for( SelectOption selopt: recordTypes ) {
            System.debug( selopt.getLabel() + ',' + selopt.getValue() );
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<CTRRequestFormItem__c> getRequestFormItem(String recID) {
        try {
            
            if(recID != '' || recID != null) {
                List<CTRRequestFormItem__c>itemList = [SELECT id,CTRRequestFormHeader__r.TypeOfBusinessCommercialEvaluation__c,CTRRequestFormHeader__r.CustomerPurchaseProductFrom__c,CTRRequestFormHeader__r.LegalEntity__c,OwnersSectionHead__c,OwnersCMVP__c,WaiveRequest__c,TraderRemark__c,RecordTypeId,RecordType.DeveloperName,
                                                       DeclareTheInformation__c,OwnerId, Name,AgreeRegisterCustomer__c,ReputationInTheMarket__c,ResultFromNewsScreening__c,TraderPreScreenDecision__c,SHPrescreenDecision__c,Approval_Step__c,
                                                       Credit_Condition__c,CMVPPreScreenDecision__c,CurrentApprover__c,LinkToNEWS__c,ImportExcelSummary__c,TypeOfBusiness__c,CashOnDelivery__c,HavingCollateral__c,
                                                       BuyTradeEndorsement__c,BuyTradeDCLCondition__c,Thelevelofreputation__c,ApprovalTrader_CreditCondition__c,CTRRequestFormHeader__r.Customer__r.CTRUser__c
                                                       ,BusinessUnit__c,Status__c,CommercialScoringResult__c,InterestedProductTypeAsCustomerTOP__c,InterestedProductTypeAsCustomerTX__c,InterestedProductTypeAsSupplierTOP__c,InterestedProductTypeAsSupplierTX__c,
                                                       HavingOpenedCredit__c,fmlPositionNameOfVP__c,InternalCreditRating__c,SubBU__c,CTRRequestFormHeader__r.Country__r.Code__c,InterestedProductTypeAsSupplier__c FROM CTRRequestFormItem__c WHERE id =: recID];
                
                String ownerEmpId = '';
                if(itemList[0].BusinessUnit__c == 'TX')
                {
                    ownerEmpId = [Select Employee_Id__c from User where Id =: itemList[0].OwnerId].Employee_Id__c;
                }
                
                String Process = 'TraderSheet';
                String SalesOrg = itemList[0].SubBU__c;
                String isDom = itemList[0].CTRRequestFormHeader__r.Country__r.Code__c == 'TH' ? 'Domestic':'International';
                String RecordType = itemList[0].RecordType.DeveloperName.contains('Customer') ? 'Customer':'Supplier';
                String Product = '';
                if(SalesOrg == 'TOP' && RecordType == 'Supplier' && itemList[0].InterestedProductTypeAsSupplierTOP__c != null)
                {
                    if(itemList[0].InterestedProductTypeAsSupplierTOP__c.contains('Crude'))
                    {
                        Product = 'Crude';
                    }
                    
                }
                String isByTX = 'No';
                String VP = 'VP';
                Map<String,List<String>>actorMap = getActor(Process,SalesOrg,isDom,RecordType,Product,isByTX,ownerEmpId); 
                if(actorMap != null)
                {
                    if(actorMap.get('TraderHead') != null)
                    {
                        if(actorMap.get('TraderHead').size() > 0)
                        {
                            itemList[0].OwnersSectionHead__c = actorMap.get('TraderHead')[0];
                        }
                        
                    }
                    if(actorMap.get(VP) != null)
                    {
                        if(actorMap.get(VP).size() > 0)
                        {
                            itemList[0].OwnersCMVP__c = actorMap.get(VP)[0];
                        }
                        
                    }
                    
                }
                if(itemList[0].CurrentApprover__c == null || itemList[0].CurrentApprover__c == '')
                {
                    itemList[0].CurrentApprover__c = 'Trader';
                }
				/*
                if(itemList[0].CurrentApprover__c =='Trader') {
                    PISUsers__c sectionhead = CTRBuProfileController.getReportToPIS(UserInfo.getUserId());
                    PISUsers__c vp = CTRBuProfileController.getReportToPIS(sectionhead.User__c);

                    itemList[0].OwnersSectionHead__c = (sectionhead != null)?sectionhead.User__c: null;
                    itemList[0].OwnersCMVP__c = (vp != null)?vp.User__c: null;
                    //itemList[0].ApproverTraderName__c = itemList[0].OwnerId;
                }*/
                return itemList;
            } else {
                return null;
            }
        } catch(Exception e) {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String,List<String>> getActor(String Process,String SalesOrg, String IsDom, String RecordType, String Product,String isByTX,String OwnerEmpId) {
        try {
            List<CTRActorInProcess__mdt>actorList = [Select id,Step__c,EmployeeId__c,ActorTeam__c From CTRActorInProcess__mdt 
                                                     Where Process__c =: Process AND SalesOrg__c =:SalesOrg AND Type__c =: IsDom AND RecordType__c =: RecordType
                                                     AND Product__c =: Product AND InterByTX__c =: isByTX
                                                    ];
            
            List<CTRActorInProcess__mdt>ownerActor = [Select id,ActorTeam__c From CTRActorInProcess__mdt 
                                                     Where EmployeeId__c =: OwnerEmpId Limit 1
                                                    ];
            
            map<String,List<String>>actorMap = new map<String,List<String>>();
            map<String,String>userMap = new map<String,String>();
            for(CTRActorInProcess__mdt item : actorList)
            {
                
                if(!actorMap.containsKey(item.Step__c))
                {
                    List<String>tempList = new List<String>();
                    if(item.Step__c == 'TraderHead' && OwnerEmpId != '' && ownerActor.size() > 0) //TXActor
                    {
                        if(item.ActorTeam__c == ownerActor[0].ActorTeam__c)
                        {
                            tempList.add(item.EmployeeId__c);
                            actorMap.put(item.Step__c,tempList);
                        }
                        
                    }
                    else
                    {
                        tempList.add(item.EmployeeId__c);
                        actorMap.put(item.Step__c,tempList);
                    }
                }
                else
                {
                    List<String>tempList = actorMap.get(item.Step__c);
                    if(item.Step__c == 'TraderHead' && OwnerEmpId != '' && ownerActor.size() > 0) //TXActor
                    {
                        if(item.ActorTeam__c == ownerActor[0].ActorTeam__c)
                        {
                            tempList.add(item.EmployeeId__c);
                            actorMap.put(item.Step__c,tempList);
                        }
                        
                    }
                    else
                    {
                        tempList.add(item.EmployeeId__c);
                        actorMap.put(item.Step__c,tempList);
                    }
                    
                }
                
            }
            List<String>allUser = new List<String>();
            for(String key : actorMap.keySet())
            {
                for(String val : actorMap.get(key))
                {
                    allUser.add(val);
                }
            }
            List<User>userList = [select id,Employee_Id__c from user where Employee_Id__c IN: allUser AND isActive = true];
            for(User iUser : userList)
            {
                userMap.put(iUser.Employee_Id__c,iUser.id);
            }
            
            for(String key : actorMap.keyset())
            {
                /*
                String empid = actorMap.get(key);
                String userId = userMap.get(empid);
                actorMap.put(key,userId);*/
                List<String>userIdList = new List<String>();
                for(String empId : actorMap.get(key))
                {
                    String userId = userMap.get(empid);
                    if(userId != null)
                    {
                        userIdList.add(userId);
                    }
                    
                }
                actorMap.put(key,userIdList); //key = stepname , value = userId list
            }
            return actorMap;
        } catch(Exception e) {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static CTRBuProfile__mdt getBUInfo(Id recordId) {
        try {
            CTRBuProfile__mdt currentuserBU = CTRBuProfileController.checkBusinessUnitFromProfile(UserInfo.getUserId(),recordId);
            return currentuserBU;
        } catch(Exception e) {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static User getUserInfomation(Id recordId) {
        try  {
            List<User> u = [select id,Name,UserRole.name,Profile.Name from user where id =: UserInfo.getUserId()];
            system.debug('getUserInfo---'+u);
            return u[0];
        } catch(Exception e) {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
            //return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getShippingCountry(Id recordId) {
        try {
            system.debug('---getShippingCountry---'+recordId);
            String ShippingCountrystr = '';
            List<CTRShippingCountry__c> SClist = [select ShippingCountry__c from CTRShippingCountry__c where CTRRequestFormItem__c =: recordId and ShippingCountry__c != ''];
            system.debug('---SClist---'+SClist);
            if (SClist.size() > 0) {
                integer i=0;
                for (CTRShippingCountry__c sc : SClist) {
                    system.debug('---sc.ShippingCountry__c---'+sc.ShippingCountry__c);
                    ShippingCountrystr += sc.ShippingCountry__c;
                    i++;
                    if(i < SClist.size())
                        ShippingCountrystr += ', ';
                }
            }
            system.debug('---ShippingCountrystr---'+ShippingCountrystr);
            return ShippingCountrystr;
        } catch(Exception e) {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            return '';
        }
    }

    @AuraEnabled(cacheable=true)
    public static void deleteAttachments(Id recordId, String type) {
        List<CTRRequestFormItem__c> items = [SELECT Id, EmailPageAttachment__c, CustomerAttachment__c, CommitteeAttachment__c, SummarizeReportAttachment__c FROM CTRRequestFormItem__c WHERE Id = :recordId];
        if (items.size() <= 0)
            return;

        String files = '';
        CTRRequestFormItem__c item = items[0];
        if (type == 'EmailPageAttachement__c') {
            files = item.EmailPageAttachment__c;
            item.EmailPageAttachment__c = '';
        } else if (type == 'CustomerAttachment__c') {
            files = item.CustomerAttachment__c;
            item.CustomerAttachment__c = '';
        } else if (type == 'CommitteeAttachment__c') {
            files = item.CommitteeAttachment__c;
            item.CommitteeAttachment__c = '';
        } else if (type == 'SummarizeReportAttachment__c') {
            files = item.SummarizeReportAttachment__c;
            item.SummarizeReportAttachment__c = '';
        }
               
        if (String.isBlank(files?.trim()))
            return;
          
        List<String> lstFiles = files.split(',');
        List<Id> lstDocId = new List<Id>();
        List<ContentDocumentLink> lstDocLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId AND ContentDocument.Title IN :lstFiles];
        for (ContentDocumentLink docLink : lstDocLinks) {
            lstDocId.add(docLink.ContentDocumentId);
        }
        
        List<ContentDocument> lstDocs = [SELECT Id FROM ContentDocument WHERE Id IN :lstDocId];
        Savepoint sp = Database.setSavePoint();
        try {
            delete lstDocs;
            update item;
        } catch (Exception ex) {
            Database.rollback(sp);
        }

    }
    
    @AuraEnabled
    public static void CreatedNotiforHeroku(String recID) {
        try {
            
            String requestItemId = recID;
            CTRRequestFormItem__c item = [SELECT Id, CTRRequestFormHeader__r.Customer__r.CTRUser__c FROM CTRRequestFormItem__c WHERE Id = :requestItemId];
            
            CTRNotification__c noti = new CTRNotification__c();
            noti.Title__c = 'Additional Information and Documents Required';
            noti.Body__c = 'Please update additional information and documents clicking here';
            noti.Type__c = 'AdditionalInformation';
            noti.TargetId__c = requestItemId;
            noti.CTRUser__c = item.CTRRequestFormHeader__r.Customer__r.CTRUser__c;
            insert noti;
        } catch(Exception e) {
            system.debug('CTRInitialCustomerTOP---'+e.getmessage()+' line:'+e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
           
        }
    }
}