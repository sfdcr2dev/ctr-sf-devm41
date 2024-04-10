public with sharing class CTRAccountCtrl 
{

    // Result Account Duplicate Checked 
    public class duplicateCheckResult 
    {
        @AuraEnabled public Boolean isDuplicate;
        @AuraEnabled public String newRequestHeaderId;
        @AuraEnabled public Boolean isNewRequestHeader;
        @AuraEnabled public String AccountId;
        //@AuraEnabled public String newRequestItemId;


        public duplicateCheckResult(Boolean isDuplicate, String newRequestHeaderId, Boolean isNewRequestHeader, String AccountId)//, StringnewRequestItemId) 
        {
            this.isDuplicate = isDuplicate;
            this.newRequestHeaderId = newRequestHeaderId;
            this.isNewRequestHeader = isNewRequestHeader;
            this.AccountId = AccountId;
            //this.isNewRequestHeader = newRequestItemId;
        }
    }

    // Result Request Item Duplicate checked
    public class dupReqItemResult {
        public String[] dupReqItem;
        public CTRRequestFormItem__c[] reqItemRec;

        public dupReqItemResult(String[] dupReqItem, CTRRequestFormItem__c[] reqItemRec) {
            this.dupReqItem = dupReqItem;
            this.reqItemRec = reqItemRec;
        }
    }

    // Check Duplicate Account
    public static duplicateCheckResult checkDuplicateAccount (Account account, List<CTRShippingCountry__c> shipCntry, List<CTRShareholder__c> shareHolder, Id mLeadId) 
    {
        Savepoint sp = Database.setSavepoint();
        try 
        {
        // Variable for checking duplicate
        String taxNumber = String.isBlank(account.TaxCode1__c) ? '' : account.TaxCode1__c;
        String accountNumber = String.isBlank(account.AccountNumber__c) ? '' : account.AccountNumber__c;
        String supplierNumber = String.isBlank(account.SupplierNumber__c) ? '' : account.SupplierNumber__c;
        System.debug('account'+account);

        // Get RecordType Info
        Schema.RecordTypeInfo accRT = Account.getSObjectType().getDescribe().getRecordTypeInfosById().get(account.RecordTypeId);
        Id initialRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Initial').getRecordTypeId();

        // Get Current User Profile Info
        //Profile userProfile = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        string BuProfile = 'TOP';//CTRBuProfileController.checkBusinessUnitFromProfile(UserInfo.getUserId(), null).BusinessUnit__c;
        System.debug('BuProfile'+BuProfile);
        // Query Request Form RecordType by DeveloperName
        Map<String, Schema.RecordTypeInfo> reqItemRT = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName();
        Id cusInitRT = reqItemRT.get('CustomerInitial').getRecordTypeId();
        Id supInitRT = reqItemRT.get('SupplierInitial').getRecordTypeId();
        Id cusExtdRT = reqItemRT.get('CustomerExtend').getRecordTypeId();
        Id supExtdRT = reqItemRT.get('SupplierExtend').getRecordTypeId();

        // Set Interested Product
        String intProdCus = '';//account.InterestedProductTypeCustomer__c;
        String intProdSup = '';//account.InterestedProductTypeSupplier__c;
        System.debug('mLeadId '+mLeadId);
        if(mLeadId != null)
        {
            System.debug('account.LeadName__c'+account.LeadName__c);
            System.debug('account.LeadName__r.RecordType.DeveloperName'+account.LeadName__r.RecordType.DeveloperName);
            intProdCus = (account.LeadName__r.RecordType.DeveloperName.contains('TOP'))? account.InterestedProductTypeAsCustomerTOP__c: account.InterestedProductTypeAsCustomerTX__c;
            intProdSup = (account.LeadName__r.RecordType.DeveloperName.contains('TOP'))? account.InterestedProductTypeAsSupplierTOP__c: account.InterestedProductTypeAsSupplierTX__c;
        }
        else
        {
            System.debug('BuProfile '+BuProfile);
            intProdCus = (BuProfile == 'TOP' || BuProfile == 'LABIX')? account.InterestedProductTypeAsCustomerTOP__c: account.InterestedProductTypeAsCustomerTX__c;
            intProdSup = (BuProfile == 'TOP' || BuProfile == 'LABIX')? account.InterestedProductTypeAsSupplierTOP__c: account.InterestedProductTypeAsSupplierTX__c;
        }

        System.debug('intProdCus '+intProdCus);
        System.debug('intProdSup '+intProdSup);
        // Split Interested Product
        //List<String> intProdList = new List<String>();
        List<String> intProdCusList = new List<String>();
        List<String> intProdSupList = new List<String>();

        if (String.isNotBlank(intProdCus)) 
        {
            intProdCusList = intProdCus.split(';');
            //intProdList.addAll(intProdCusList);
        }
        if (String.isNotBlank(intProdSup)) 
        {
            intProdSupList = intProdSup.split(';');
            //intProdList.addAll(intProdSupList);
        }
        // Variable
        String newReqHeaderId = '';
        String ctrUserId = '';
        Boolean isNewHeader = true;
        String newReqItemId = '';
        String newAccId = '';

        // Query Duplicate Account
        List<Account> duplicateAccounts = new List<Account>();
        if (mLeadId == null) 
        {

            List<String> mAccountFields = new List<String>(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().keySet());            
            String soqlAccount = '';
            soqlAccount+= ' SELECT ' + String.join(mAccountFields, ',');
            soqlAccount+= ' ,LeadName__r.Buyer__c, LeadName__r.Seller__c, Country__r.Code__c';
            soqlAccount+= ' FROM Account';
            soqlAccount+= ' WHERE (TaxCode1__c = :taxNumber AND TaxCode1__c != null'; //'AND AccountNumber__c = :accountNumber';
                if(account.Id != null)
                {
                    soqlAccount+=' AND Id != \''+account.Id+'\'';
                }
            soqlAccount+= ') OR (TaxCode1__c = :taxNumber AND TaxCode1__c != null';//' AND SupplierNumber__c = :supplierNumber';
            if(account.Id != null)
                {
                    soqlAccount+=' AND Id != \''+account.Id+'\'';
                    //soqlAccount+= ' AND Id != :account.Id';
                }
                soqlAccount+= ') LIMIT 1';

                system.debug('soqlAccount '+ soqlAccount);
            duplicateAccounts = Database.query(soqlAccount);

        }
        else
        {
            system.debug('account.LeadName__r.RecordType.DeveloperName:'+account.LeadName__r.RecordType.DeveloperName);
            BuProfile = (account.LeadName__r.RecordType.DeveloperName.contains('Tx'))?'TX':'TOP';
            
            system.debug('BuProfile1: '+BuProfile);
        }
        
        
            system.debug('BuProfile2: '+BuProfile);
            if (duplicateAccounts.isEmpty() && mLeadId == null) 
            {
                System.debug('Duplicate Account Not Found. not converted');
                System.debug('accRT.getDeveloperName()'+accRT.getDeveloperName());
                if (accRT.getDeveloperName() == 'Initial') 
                {
                    // Create New Account
                    account.recordtypeId = initialRecordTypeId;
                    insert account;
                    newAccId = account.Id;
                    System.debug('inserted Account Id: ' + account.Id);
                    System.debug('intProdCus ' + intProdCus);
                    System.debug('intProdSup ' + intProdSup);
                    if (String.isNotBlank(intProdCus) || String.isNotBlank(intProdSup)) {
                        // Create CTR_User Record
                        ctrUserId = createCTRUser(account);
                        // Create Request Header Record
                        newReqHeaderId = createReqHeader(account, intProdCus, intProdSup, ctrUserId, mLeadId, BuProfile);

                        if (BuProfile == 'TOP' || BuProfile == 'LABIX' || BuProfile == 'TX') 
                        {
                            if (String.isNotBlank(intProdCus)) 
                            {
                                // Create Request Form Item Record by Interested Product Type Customer
                                createReqItem(account, newReqHeaderId, intProdCusList, BuProfile, cusInitRT, shipCntry, 'Customer');
                            }
                            
                            if (String.isNotBlank(intProdSup)) 
                            {
                                // Create Request Form Item Record by Interested Product Type Supplier
                                createReqItem(account, newReqHeaderId, intProdSupList, BuProfile, supInitRT, shipCntry, 'Supplier');
                            }
                        }
                    }
                    // Create Share Holder Record Relate with Request Header
                    if (shareHolder != null && String.isNotBlank(newReqHeaderId)) 
                    { 
                        createShareHolder(account, newReqHeaderId, shareHolder);
                    }
                }

            } 
            else if (!duplicateAccounts.isEmpty() || mLeadId!=null) 
            {
                Account extAccount = new Account();
                if (!duplicateAccounts.isEmpty()) 
                {
                    extAccount = duplicateAccounts[0];
                } 
                else if (mLeadId != null) 
                {
                    extAccount = account;
                }
                newAccId = extAccount.Id;
                System.debug('Duplicate Account Found Id : ' + extAccount.Id);
                if (accRT.getDeveloperName() == 'Initial' || mLeadId != null) 
                {  
                    // Check Request Item
                    Boolean checkReqItemRT = checkExtReqItem(extAccount);
                    Boolean checkSalesOrgAndProdCus = checkSalesOrgAndProd(extAccount, intProdCusList, 'Customer');
                    Boolean checkSalesOrgAndProdSup = checkSalesOrgAndProd(extAccount, intProdSupList, 'Supplier');
                    Boolean checkField = false;
					System.debug('extAccount : ' + extAccount);
                    if ((String.isBlank(extAccount.AccountNumber__c) && String.isBlank(extAccount.SupplierNumber__c)) || 
                        String.isNotBlank(intProdCus) || 
                        String.isNotBlank(intProdSup))
                    {
                        checkField = true;
                    }
					System.debug('if4 : ' + checkField);
                    System.debug('BuProfile : ' + BuProfile);

                    if (BuProfile == 'TOP' || BuProfile == 'LABIX') 
                    {
                        if (checkField) 
                        {
                            System.debug('Account has no Account Number or Supplier Number.');
                            if (checkReqItemRT && (!checkSalesOrgAndProdCus || !checkSalesOrgAndProdSup)) 
                            {
                                System.debug('checkReqItemRT: ' + checkReqItemRT);
                                // Create CTR_User Record
                                ctrUserId = createCTRUser(extAccount);
                                // Create Request Header Record
                                System.debug('extAccount: ' + extAccount.DistrictLocalText__c);

                                newReqHeaderId = createReqHeader(extAccount, intProdCus, intProdSup, ctrUserId, mLeadId, BuProfile);
                                
                                if (String.isNotBlank(intProdCus)) 
                                {
                                    // Create Request Form Item Record by Interested Product Type Customer
                                    createReqItem(extAccount, newReqHeaderId, intProdCusList, BuProfile, cusInitRT, shipCntry, 'Customer');
                                }
                                if (String.isNotBlank(intProdSup)) 
                                {
                                    // Create Request Form Item Record by Interested Product Type Supplier
                                    createReqItem(extAccount, newReqHeaderId, intProdSupList, BuProfile, supInitRT, shipCntry, 'Supplier');
                                }
                            }
                             else if (checkSalesOrgAndProdCus && checkSalesOrgAndProdSup) 
                             {
                                isNewHeader = false;
                                System.debug('NO ACTION!');
                            }
                        }
                        else 
                        {
                            System.debug('Account has Account Number or Supplier Number.');
                            if (checkSalesOrgAndProdCus && checkSalesOrgAndProdSup) 
                            {
                                isNewHeader = false;
                                System.debug('NO ACTION!');
                            }
                            else 
                            {
                                if (!checkReqItemRT) 
                                {
                                    isNewHeader = false;
                                    System.debug('NO ACTION!');
                                }
                                else 
                                {
                                    // Create CTR_User Record
                                    ctrUserId = createCTRUser(extAccount);

                                    // Create Request Header Record
                                    newReqHeaderId = createReqHeader(extAccount, intProdCus, intProdSup, ctrUserId, mLeadId, BuProfile);
                                        
                                    if (String.isNotBlank(intProdCus)) 
                                    {
                                        // Create Request Form Item Record by Interested Product Type Customer
                                        createReqItem(extAccount, newReqHeaderId, intProdCusList, BuProfile, cusExtdRT, shipCntry, 'Customer');
                                    }
                                    if (String.isNotBlank(intProdSup)) 
                                    {
                                        // Create Request Form Item Record by Interested Product Type Supplier
                                        createReqItem(extAccount, newReqHeaderId, intProdSupList, BuProfile, supExtdRT, shipCntry, 'Supplier');
                                    }
                                }
                            }
                        }
                    }
                    else if (BuProfile == 'TX') 
                    {
                        if (checkField) 
                        {
                            System.debug('Account has no Account Number or Supplier Number.');
                            if (checkReqItemRT ) {
                                System.debug('checkReqItemRT: ' + checkReqItemRT);
                                // Create CTR_User Record
                                ctrUserId = createCTRUser(extAccount);
                                // Create Request Header Record
                                System.debug('extAccount: ' + extAccount.DistrictLocalText__c);

                                newReqHeaderId = createReqHeader(extAccount, intProdCus, intProdSup, ctrUserId, mLeadId, BuProfile);
                                
                                if (String.isNotBlank(intProdCus)) 
                                {
                                    // Create Request Form Item Record by Interested Product Type Customer
                                    createReqItem(extAccount, newReqHeaderId, intProdCusList, BuProfile, cusInitRT, shipCntry, 'Customer');
                                }
                                if (String.isNotBlank(intProdSup)) 
                                {
                                    // Create Request Form Item Record by Interested Product Type Supplier
                                    createReqItem(extAccount, newReqHeaderId, intProdSupList, BuProfile, supInitRT, shipCntry, 'Supplier');
                                }
                            }
                            else
                            {
                                isNewHeader = false;
                                System.debug('NO ACTION!');}
                            
                        }
                        else 
                        {
                            System.debug('Account has Account Number or Supplier Number.');
                                if (!checkReqItemRT) 
                                {
                                    isNewHeader = false;
                                    System.debug('NO ACTION!');
                                }
                                else 
                                {
                                    // Create CTR_User Record
                                    ctrUserId = createCTRUser(extAccount);

                                    // Create Request Header Record
                                    newReqHeaderId = createReqHeader(extAccount, intProdCus, intProdSup, ctrUserId, mLeadId, BuProfile);
                                        
                                    if (String.isNotBlank(intProdCus)) 
                                    {
                                        // Create Request Form Item Record by Interested Product Type Customer
                                        createReqItem(extAccount, newReqHeaderId, intProdCusList, BuProfile, cusExtdRT, shipCntry, 'Customer');
                                    }
                                    if (String.isNotBlank(intProdSup)) 
                                    {
                                        // Create Request Form Item Record by Interested Product Type Supplier
                                        createReqItem(extAccount, newReqHeaderId, intProdSupList, BuProfile, supExtdRT, shipCntry, 'Supplier');
                                    }
                                }
                        }
                            
                    }
                }
            
                // Create Share Holder Record Relate with Request Header
                if (shareHolder != null && String.isNotBlank(newReqHeaderId)) 
                { 
                        createShareHolder(extAccount, newReqHeaderId, shareHolder);
                }
            }
            return new DuplicateCheckResult(!duplicateAccounts.isEmpty(), newReqHeaderId, isNewHeader, newAccId );
        }
         catch (Exception e) 
        {
            System.debug('Error occurred when insert Account: ' + e.getMessage());
            System.debug('Error Line ' + e.getLineNumber());

            // if ( mLeadId == null) {
            //     throw new AuraHandledException(e.getMessage());
            // }
            Database.rollback(sp);
            return new DuplicateCheckResult(null, e.getMessage(), null,  null);
        }

        
    }

    // Check Request Item Status
    public static Boolean checkExtReqItem (Account account) 
    {

        List<CTRRequestFormItem__c> mItemList = [SELECT Id, RecordType.DeveloperName, Status__c
                                                        FROM CTRRequestFormItem__c 
                                                        WHERE Customer__c = :account.Id
                                                        //AND Status__c != 'Rejected'
                                                        //AND Status__c != 'Approved'
                                                        //AND Status__c != 'New'
                                                        //LIMIT 1
                                                        ];
        Boolean ToCreateItem = false;
        System.debug('Item size: '+mItemList.size());
        if(mItemList.size()>0)
        {
            for(CTRRequestFormItem__c mItem: mItemList)
            {
                if(mItem.Status__c != 'Rejected' && mItem.Status__c != 'Approved' && mItem.Status__c != 'New')
                {
                    ToCreateItem= true;
                }
            }
        }
        else
        {
            ToCreateItem = true;
        }
        //System.debug('checkStatus: ' + checkStatus.isEmpty());
        return ToCreateItem;
    }

    // Check record with the Product and Sales Organization already exists
    public static Boolean checkSalesOrgAndProd(Account account, String[] intProdList, String typeName) 
    {
        List<CTRRequestFormItem__c> existingRecords = [SELECT Id, SalesOrganization__c,PurchasingOrganization__c, Product__c, RecordType.DeveloperName
                                                        FROM CTRRequestFormItem__c 
                                                        WHERE Customer__c = :account.Id];
    
        Set<String> mappedValues = new Set<String>();
        for (CTRRequestFormItem__c existingRecord : existingRecords) {
            if (existingRecord.RecordType.DeveloperName.contains('Customer')) 
            {
                mappedValues.add(existingRecord.Product__c + '-' + existingRecord.SalesOrganization__c + '-' + 'Customer');
            }
            if (existingRecord.RecordType.DeveloperName.contains('Supplier')) 
            {
                mappedValues.add(existingRecord.Product__c + '-' + existingRecord.PurchasingOrganization__c + '-' + 'Supplier');
            }
        }
    
        for (String prodCustomer : intProdList) 
        {
            String salesOrg = (typeName == 'Customer')?mapSalesOrgWithProd().get(prodCustomer):mapPurchasingOrgWithProd().get(prodCustomer) ;

            if (salesOrg != null && !mappedValues.contains(prodCustomer + '-' + salesOrg + '-' + typeName)) 
            {
                return false;
            }
        }
    
        return true;
    }
    
        // Map Sales Organization With Interested Product
        public static Map<String, String> mapSalesOrgWithProd() 
        {
            return new Map<String, String>
            {
                'Crude' => '1100',
                'Petroleum Products' => '1100',
                'Petrochemical Products' => '1300',
                'Lube Base Products' => '1400',
                'LABIX Products' => '1700'
            };
        }


        public static Map<String, String> mapPurchasingOrgWithProd() 
        {
            return new Map<String, String>
            {
                'Crude' => '1100',
                'B100/Ethanol' => '1100',
                'Petroleum and Components' => '1100',
                'Normal Paraffin' => '1100'
            };
        }

        public static Map<String, String> mapCompanyCodeWithProd() 
        {
            return new Map<String, String>
            {
                'Crude' => '1100',
                'B100/Ethanol' => '1100',
                'Petroleum and Components' => '1100',
                'Normal Paraffin' => '1700'
            };
        }
        

    // Create Request Form Item Record by Interested Product
    public static dupReqItemResult createReqItem(Account account, String reqHeaderId, String[] intProdList, 
                                                    String profile, Id reqItemRT, 
                                                    List<CTRShippingCountry__c> shipCntry, String typeName) 
    {
        system.debug('createReqItem');
        List<String> duplicateRecords = new List<String>();
        List<CTRRequestFormItem__c> reqFormToInsert = new List<CTRRequestFormItem__c>();

        List<CTRRequestFormItem__c> existingRecords = [SELECT Id, Product__c, SalesOrganization__c, PurchasingOrganization__c, RecordType.DeveloperName
                                                            FROM CTRRequestFormItem__c 
                                                            WHERE Customer__c = :account.Id
                                                            AND Product__c IN :intProdList
                                                            AND (SalesOrganization__c IN :mapSalesOrgWithProd().values() 
                                                            OR PurchasingOrganization__c IN: mapPurchasingOrgWithProd().values())];
            
        Set<String> existingRecordsSet = new Set<String>();
        for (CTRRequestFormItem__c existingRecord : existingRecords) 
        {
            if (existingRecord.RecordType.DeveloperName.contains('Customer')) 
            {
                existingRecordsSet.add(existingRecord.Product__c + '-' + existingRecord.SalesOrganization__c + '-' + 'Customer');
            }
            if (existingRecord.RecordType.DeveloperName.contains('Supplier')) 
            {
                existingRecordsSet.add(existingRecord.Product__c + '-' + existingRecord.PurchasingOrganization__c + '-' + 'Supplier');
            }
        } 
        system.debug('profile '+profile);
        if (profile == 'TOP' || profile == 'LABIX') 
        {
            for (Integer i = 0; i < intProdList.size(); i++) 
            {
                system.debug('test 1 '+intProdList[i]);
                String salesOrg = (typeName == 'Customer')?mapSalesOrgWithProd().get(intProdList[i]): mapPurchasingOrgWithProd().get(intProdList[i]);
                system.debug('test 2 salesOrg ' +salesOrg);
                String prodSalesOrgKey = intProdList[i] + '-' + salesOrg + '-' + typeName;
                if (!existingRecordsSet.contains(prodSalesOrgKey)) 
                {
                    CTRRequestFormItem__c newReqForm = manageRequestItem(account, intProdList[i], reqHeaderId, reqItemRT, salesOrg, typeName, profile);

                    system.debug('test 3 ');
                    system.debug('test 4 SalesOrganization__c '+newReqForm.SalesOrganization__c);
                    system.debug('test 5 PurchasingOrganization__c '+newReqForm.PurchasingOrganization__c);
                    reqFormToInsert.add(newReqForm);
                } 
                else 
                {
                    duplicateRecords.add('NO ACTION! Matching product found: ' + intProdList[i]);
                    System.debug('NO ACTION! ' + intProdList[i]);
                }
            }
        }
        else if (profile == 'TX') 
        {
            List<CTRRequestFormItem__c> ExistingRecordsTX = new list<CTRRequestFormItem__c>();
            if(typeName =='Customer')
            {
                ExistingRecordsTX = [SELECT Id, Seller__c,Product__c
                                                            FROM CTRRequestFormItem__c 
                                                            WHERE Customer__c = :account.Id and SalesOrganization__c =:account.LeadName__r.Seller__c];
            }
            else if(typeName =='Supplier')
            {
                ExistingRecordsTX = [SELECT Id, Seller__c,Product__c
                                                            FROM CTRRequestFormItem__c 
                                                            WHERE Customer__c = :account.Id and PurchasingOrganization__c =:account.LeadName__r.Buyer__c];
            }

            system.debug('ExistingRecordsTX '+ExistingRecordsTX);
            list<string>SellerList = new list<string>();
            for(CTRRequestFormItem__c item : ExistingRecordsTX)
            {
                SellerList.add(item.Product__c);
                system.debug('item.Product__c '+item.Product__c);
            }
            
            	/*List<CTRRequestFormItem__c> existingRecordsTX = [SELECT Id, Product__c, SalesOrganization__c, RecordType.DeveloperName
                                                            FROM CTRRequestFormItem__c 
                                                            WHERE Customer__c = :account.Id
                                                            AND ((Status__c != 'New' AND Status__c != 'Approved' AND Status__c != 'Rejected') 
    														OR (Seller__c in:SellerList)];*/
            //seller มีซ้ำหรือไม่มี
            system.debug('existingRecordsTX.size() '+existingRecordsTX.size());
            system.debug('intProdList '+intProdList);
            String mEachProduct = '';
           	for (Integer i = 0; i < intProdList.size(); i++) 
            {
                system.debug('intProdList[i] '+intProdList[i]); 
                mEachProduct +=intProdList[i]+';';
                system.debug('!SellerList.contains(intProdList[i]) '+ !SellerList.contains(intProdList[i]));    
                if (!SellerList.contains(intProdList[i])) 
                {
                	system.debug('reqItemRT '+reqItemRT); 
                	
                /*
                	if(account.AccountNumber__c != null){
                		newReqForm.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get(typeName+'Extend').getRecordTypeId();
                	}else{
                    	newReqForm.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get(typeName+'Initial').getRecordTypeId();
                	}*/
                    //CTRRequestFormItem__c newReqForm = manageRequestItem(account, intProdList[i], reqHeaderId, reqItemRT,'', typeName, profile);
                	//reqFormToInsert.add(newReqForm);
                
        		}
                else 
                {
                	duplicateRecords.add('NO ACTION! Matching Customer found');
                	System.debug('NO ACTION! ');
            	}
            }
            CTRRequestFormItem__c newReqForm = manageRequestItem(account, mEachProduct, reqHeaderId, reqItemRT,'', typeName, profile);
            reqFormToInsert.add(newReqForm);
        }
        /*
        for (Integer i = 0; i < intProdList.size(); i++) {
            String salesOrg = mapSalesOrgWithProd().get(intProdList[i]);
            String prodSalesOrgKey = intProdList[i] + '-' + salesOrg + '-' + typeName;
            if (!existingRecordsSet.contains(prodSalesOrgKey)) {
                CTRRequestFormItem__c newReqForm = new CTRRequestFormItem__c();
                newReqForm.RecordTypeId = reqItemRT;
                newReqForm.Product__c = intProdList[i];
                newReqForm.CTRRequestFormHeader__c = reqHeaderId;
                newReqForm.Customer__c = account.Id;
                newReqForm.Status__c = 'New';
                newReqForm.Owner__c = UserInfo.getUserId();
                newReqForm.Name = account.CompanyNameLocal__c;
                
                if (profile == 'TOP' || profile == 'System Administrator') {
                    newReqForm.SalesOrganization__c = salesOrg;
                } else if (profile == 'TX') {
                    newReqForm.SalesOrganization__c = account.SalesOrganization__c;
                }
                reqFormToInsert.add(newReqForm);
            } else {
                duplicateRecords.add('NO ACTION! Matching product found: ' + intProdList[i]);
                System.debug('NO ACTION! ' + intProdList[i]);
            }
        }
        */
                	
        if(reqFormToInsert.size()>0)
        {
            System.debug('Insert form item '+reqFormToInsert.size());
            Integer retry = 3;
            for(Integer i = 0; i < retry; i++) { // retry 3 times if failed
                try {
                    insert reqFormToInsert;
                    System.debug('Insert item on account trigger success '+String.valueOf(i));
                    break;
                } catch(Exception e)  {
                    System.debug('Retry# '+String.valueOf(i)+': Error occurred when insert item on account trigger: ' + e.getMessage());
                    if(!(e.getMessage() != null && e.getMessage().contains('duplicate value found: UniqueRunningNumber__c'))) {
                        System.debug('Error is not duplicate -> Break');
                        break; // if another error -> break
                    }
                    System.debug('Duplicate unique running number -> Retry');
                    // if error message is duplicate unique number -> continue retry
                }
            }
        }

        if (shipCntry != null && !reqFormToInsert.isEmpty()) 
        {
            createShipCntry(account, reqFormToInsert, shipCntry);
        }

        return new dupReqItemResult(duplicateRecords, reqFormToInsert);
    }

    public static CTRRequestFormItem__c manageRequestItem (Account mAccount, String mProduct, String mRequestHeaderId, Id mRecordTypeId, String mSalesOrg, String mType, String mBu)
    {
        mProduct = (mProduct != null)?mProduct:'Other Products';
        CTRRequestFormItem__c newReqForm = new CTRRequestFormItem__c();
        newReqForm.RecordTypeId = mRecordTypeId;
        newReqForm.Product__c = mProduct;
        newReqForm.CTRRequestFormHeader__c = mRequestHeaderId;
        newReqForm.Customer__c = mAccount.Id;
        newReqForm.OwnerId = UserInfo.getUserId();
        newReqForm.Name = mAccount.CompanyNameLocal__c;
        newReqForm.Status__c = 'New';
        newReqForm.Approval_Step__c = 'Open';
        newReqForm.MaxPartialDeliveries__c = 0;
        newReqForm.UnderdeliveryTolerance__c = 0;
        newReqForm.OverdeliveryTolerance__c = 0;

        if(mBu == 'TX')
        {
            newReqForm.WHTaxCountry__c = (mAccount.Country__c != null &&  mAccount.Country__r.Code__c != null)?mAccount.Country__r.Code__c:'';
            newReqForm.Liable1__c = true;
            newReqForm.Liable2__c = true;
            newReqForm.GRBasedInvVerif__c = true;
            newReqForm.Recty1__c = '53';
            newReqForm.Recty2__c = '53';
            newReqForm.Wthttype1__c = 'J1';
            newReqForm.Wthttype2__c = 'J2';
            newReqForm.SortKey__c = '009';
            newReqForm.Division__c = '00';
            newReqForm.ExchangeRateType__c = 'B';
            newReqForm.CustPriceProc__c = '1';
            newReqForm.CustStatGroup__c = '1';
            //newReqForm.PartialDeliveriesperitem__c = 'B';
            newReqForm.MaxPartialDeliveries__c = 1;
            newReqForm.UnderdeliveryTolerance__c = 5;
            newReqForm.OverdeliveryTolerance__c = 5;
            newReqForm.OrderProbability__c = 0;
            newReqForm.OrderCombination__c = false;
            newReqForm.Rebate__c = true;
            newReqForm.Chkdoubleinv__c = true;
            newReqForm.IsPriceDetermin__c = true;
            newReqForm.ShippingConditions__c = '02';
            newReqForm.automaticPurchaseOrder__c = true;
            newReqForm.SalesOrganization__c = mAccount.LeadName__r.Seller__c;
            newReqForm.PurchasingOrganization__c = mAccount.LeadName__r.Buyer__c;
            System.debug('mType: '+mType);
            System.debug('mProduct: '+mProduct);


            if(mType == 'Customer')
            {
                newReqForm.InterestedProductTypeAsCustomerTX__c = mAccount.LeadName__r.InterestedProductTypeAsCustomerTX__c;
                if(mProduct.contains('Lube'))
                {
                    newReqForm.LubeBaseProducts__c = mAccount.LubeBaseProduct__c;
                }

                if(mProduct.contains('Other'))
                {
                    newReqForm.CustomerProductIdentification__c = mAccount.CustomerProductIdentification__c;
                }
                
            }
            else if(mType == 'Supplier')
            {
                newReqForm.InterestedProductTypeAsSupplierTX__c =  mAccount.LeadName__r.InterestedProductTypeAsSupplierTX__c;

                if(mProduct.contains('Other'))
                {
                    newReqForm.SupplierProductIdentification__c = mAccount.SupplierProductIdentification__c;
                }
            }
        }
        else
        {
            if(mType == 'Customer')
            {
                newReqForm.InterestedProductTypeAsCustomerTOP__c = mProduct;
                newReqForm.SalesOrganization__c = mSalesOrg;
                if(mProduct.contains('Lube'))
                {
                    newReqForm.LubeBaseProducts__c = mAccount.LubeBaseProduct__c;
                }
                if(mProduct.contains('LABIX'))
                {
                    newReqForm.LABIXProducts__c = mAccount.LABIXProduct__c;
                }
                if(mProduct.contains('Other'))
                {
                    newReqForm.CustomerProductIdentification__c = mAccount.CustomerProductIdentification__c;
                }
            }
            else if(mType == 'Supplier')
            {
                newReqForm.InterestedProductTypeAsSupplierTOP__c = mProduct;
                newReqForm.PurchasingOrganization__c = mSalesOrg;
                if(mProduct.contains('Petroleum'))
                {
                    newReqForm.PetroleumAndComponentsProducts__c = mAccount.PetroleumAndComponentsProducts__c;
                }
                if(mProduct.contains('Other'))
                {
                    newReqForm.SupplierProductIdentification__c = mAccount.SupplierProductIdentification__c;
                }
                //newReqForm.CompanyCodeTOP__c = mapCompanyCodeWithProd().get(mProduct);
            }
        }
        //newReqForm.SalesOrganization__c = (mSalesOrg != '')?mSalesOrg:mAccount.LeadName__r.Seller__c;
        //newReqForm.PurchasingOrganization__c = mAccount.LeadName__r.Buyer__c;
        newReqForm.Name = mType+' - '+mProduct;
        return newReqForm;
    }

    // Create Share Holder Record
    public static void createShareHolder(Account account, String newReqHeaderId, List<CTRShareholder__c> shareHolders) 
    {

        List<CTRShareholder__c> shrhldToInsert = new List<CTRShareholder__c>();

        for (CTRShareholder__c shareHolder : shareHolders) 
        {
            CTRShareholder__c newShareHolder = new CTRShareholder__c();
            newShareHolder.of_Shareholder__c = shareHolder.of_Shareholder__c;
            newShareHolder.CTRRequestFormHeader__c = newReqHeaderId;
            newShareHolder.Customer__c = account.Id;
            newShareHolder.OwnerId = UserInfo.getUserId();
            newShareHolder.Name = shareHolder.Name;
            shrhldToInsert.add(newShareHolder);
        }
        if(shrhldToInsert.size()>0)
        {
            insert shrhldToInsert;
        }
    }

    // Creat CTR_User Record
    public static String createCTRUser(Account account) 
    {
        if (account.Email__c != null) 
        {
            List<CTRUser__c> existingUsers = [SELECT Id FROM CTRUser__c WHERE Email__c = :account.Email__c LIMIT 1];
            String returnId = '';
            if (existingUsers.isEmpty()) 
            {
                CTRUser__c ctrUser = new CTRUser__c();
                ctrUser.Name = account.FirstName__c + ' ' + account.LastName__c;
                ctrUser.Email__c = account.Email__c;
                ctrUser.Username__c = account.Email__c;
                ctrUser.IsTemporary__c = true;
                ctrUser.InitialPassword__c = true;
                ctrUser.InitialPasswordSecret__c = account.HerokuInitialSecret__c;
                ctrUser.CompanyName__c = account.Id;
                insert ctrUser;
                
                
                returnId = ctrUser.Id;
            }
            else 
            {
                returnId = existingUsers[0].Id;
            }
            
            Account updatedAcc = new Account(id = account.Id);
            updatedAcc.CTRUser__c = returnId;
            update updatedAcc;
            
            return returnId;
        } 
        else 
        {
            return null;
        }
    }

    // Create Request Header Record
    public static CTRRequestFormHeader__c createReqHeader(Account mAccount, String intProdCus, String intProdSup, String ctrUserId, Id mLeadId, String BuProfile, Boolean doInsert) 
    {
        CTRRequestFormHeader__c mHeader = new CTRRequestFormHeader__c();
        mHeader.Status__c = 'New';
        mHeader.LeadName__c = mLeadId;
        //mHeader.InterestedProductTypeCustomer__c = intProdCus;
        //mHeader.InterestedProductTypeSupplier__c = intProdSup;
        String mLanguage = '';
        if(mLeadId != null)
        {
            if(mAccount.LeadName__r.RecordType.DeveloperName.contains('TOP'))
            {
                mHeader.InterestedProductTypeAsCustomerTOP__c = intProdCus;
                mHeader.InterestedProductTypeAsSupplierTOP__c = intProdSup;
                mLanguage = '2';
            }
            else
            {
                mHeader.InterestedProductTypeAsCustomerTX__c = intProdCus;
                mHeader.InterestedProductTypeAsSupplierTX__c = intProdSup;
                mLanguage = 'E';
            }
        }
        else
        {
            if(BuProfile == 'TOP' || BuProfile == 'LABIX')
            {
                mHeader.InterestedProductTypeAsCustomerTOP__c = intProdCus;
                mHeader.InterestedProductTypeAsSupplierTOP__c = intProdSup;
                mLanguage = '2';
            }
            else
            {
                mHeader.InterestedProductTypeAsCustomerTX__c = intProdCus;
                mHeader.InterestedProductTypeAsSupplierTX__c = intProdSup;
                mLanguage = 'E';
            }
        }
        mHeader.OwnerId = UserInfo.getUserId();
        mHeader.Customer__c = mAccount.Id;
        mHeader.CTRUser__c = ctrUserId;

        mHeader.CompanyNameENF__c = mAccount.CompanyNameENF__c;
        mHeader.CompanyNameLocal__c = mAccount.CompanyNameLocal__c;
        mHeader.FormerNameofCompany__c = mAccount.FormerNameofCompany__c;
        mHeader.CustomerType__c = mAccount.CustomerType__c;
        mHeader.TypeOfBusinessCommercialEvaluation__c = mAccount.TypeOfBusinessCommercialEvaluation__c;
        mHeader.TypeOfBusiness__c = mAccount.TypeOfBusiness__c;
        mHeader.LegalEntity__c = mAccount.LegalEntity__c;
        mHeader.IncoperationDate__c = mAccount.IncoperationDate__c;
        mHeader.TaxCode1__c = mAccount.TaxCode1__c;
        mHeader.Language__c = mLanguage;//mAccount.SpecifyLanguagesOfCompanyName__c;
        mHeader.SpecifyLanguagesOfCompanyName__c = mAccount.SpecifyLanguagesOfCompanyName__c;
        mHeader.SupplierType__c = mAccount.SupplierType__c;
        mHeader.Country__c = mAccount.Country__c;
        mHeader.TypeOfBusinessOthers__c = mAccount.TypeOfBusinessOthers__c;
        mHeader.LegalEntityOthers__c = mAccount.LegalEntityOthers__c;
        mHeader.Yearofexperience__c = mAccount.Yearofexperience__c;
        mHeader.CompanyWebsite__c = mAccount.CompanyWebsite__c;
        mHeader.NoOfRegistrationMinistryEnergy__c = mAccount.NoOfRegistrationMinistryEnergy__c;
        mHeader.CustomerSearchTermLocal__c = mAccount.CustomerSearchTermLocal__c;
        mHeader.CustomerSearchTermEN__c = mAccount.CustomerSearchTermEN__c;
        mHeader.SupplierSearchTermLocal__c = mAccount.SupplierSearchTermLocal__c;
        mHeader.SupplierSearchTermEN__c = mAccount.SupplierSearchTermEN__c;
        mHeader.CoName__c = mAccount.CoName__c;
        mHeader.HousenoLocal__c = mAccount.HousenoLocal__c;
        mHeader.RoomLocal__c = mAccount.RoomLocal__c;
        mHeader.BuildingCodeLocal__c = mAccount.BuildingCodeLocal__c;
        mHeader.FloorLocal__c = mAccount.FloorLocal__c;
        mHeader.StreetLocal__c = mAccount.StreetLocal__c;
        mHeader.SubDistrictLocalText__c = mAccount.SubDistrictLocalText__c;
        mHeader.CityStateLocal__c = mAccount.CityStateLocal__c;
        mHeader.DistrictLocalText__c = mAccount.DistrictLocalText__c;
        mHeader.PostalCodeLocalText__c = mAccount.PostalCodeLocalText__c;
        mHeader.LocationInGoogleMapsLinks__c = mAccount.LocationInGoogleMapsLinks__c;
        mHeader.LocationInGoogleMapsGeolocation__Latitude__s = mAccount.Location__Latitude__s;
        mHeader.LocationInGoogleMapsGeolocation__Longitude__s = mAccount.Location__Longitude__s;
        mHeader.SameRegisteredAddress__c = mAccount.SameRegisteredAddress__c;
        mHeader.MailingCoName__c = mAccount.MailingCoName__c;
        mHeader.MailingHousenoLocal__c = mAccount.MailingHousenoLocal__c;
        mHeader.MailingRoom__c = mAccount.MailingRoom__c;
        mHeader.MailingBuildingCode__c = mAccount.MailingBuildingCode__c;
        mHeader.MailingFloor__c = mAccount.MailingFloor__c;
        mHeader.MailingStreet__c = mAccount.MailingStreet__c;
        mHeader.MailingSubDistrict__c = mAccount.MailingSubDistrict__c;
        mHeader.MailingCity__c = mAccount.MailingCity__c;
        mHeader.MailingDistrict__c = mAccount.MailingDistrict__c;
        mHeader.MailingPostalCode__c = mAccount.MailingPostalCode__c;
        mHeader.ContactSalutation__c = mAccount.ContactSalutation__c;
        mHeader.FirstName__c = mAccount.FirstName__c;
        mHeader.Position__c = mAccount.Position__c;
        mHeader.MobileCountryCode__c = mAccount.MobileCountryCode__c;
        mHeader.PhoneCountryCode__c = mAccount.PhoneCountryCode__c;
        mHeader.FaxCountryCode__c = mAccount.FaxCountryCode__c;
        mHeader.Nickname__c = mAccount.Nickname__c;
        mHeader.LastName__c = mAccount.LastName__c;
        mHeader.Email__c = mAccount.Email__c;
        mHeader.MobilePhone__c = mAccount.MobilePhone__c;
        mHeader.Phone__c = mAccount.Phone;
        mHeader.Fax__c = mAccount.Fax;
        mHeader.TimeZone__c = mAccount.TimeZone__c;
        mHeader.UltimateParentCompany__c = mAccount.UltimateParentCompany__c;

        mHeader.LubeBaseProduct__c = mAccount.LubeBaseProduct__c;
        mHeader.LABIXProduct__c = mAccount.LABIXProduct__c;
        mHeader.PetroleumAndComponentsProducts__c = mAccount.PetroleumAndComponentsProducts__c;
        mHeader.CustomerProductIdentification__c = mAccount.CustomerProductIdentification__c;
        mHeader.SupplierProductIdentification__c = mAccount.SupplierProductIdentification__c;
        //mHeader.SalesOrganization__c = mAccount.SalesOrganization__c;
        mHeader.CompanyPurchasingVolumnperGrade__c = mAccount.CompanyPurchasingVolumnperGrade__c;
        //mHeader.PurchasingOrganization__c = mAccount.PurchasingOrganization__c;
        mHeader.EstimatedMonthlyPurchaseUnit__c = mAccount.EstimatedMonthlyPurchaseUnit__c;
        mHeader.StartTradingDate__c = mAccount.StartTradingDate__c;
        mHeader.CustomerPurchaseProductFrom__c = mAccount.CustomerPurchaseProductFrom__c;
        mHeader.CustomersFacilityTankAndStorage__c = mAccount.CustomersFacilityTankAndStorage__c;
        mHeader.CustomersFacilityTransportation__c = mAccount.CustomersFacilityTransportation__c;
        mHeader.SupplierSupplyProductTo__c = mAccount.SupplierSupplyProductTo__c;
        mHeader.SuppliersFacilityTankAndStorage__c = mAccount.SuppliersFacilityTankAndStorage__c;
        mHeader.SuppliersFacilityTransportation__c = mAccount.SuppliersFacilityTransportation__c;
        mHeader.EnvironmentPolicy__c = mAccount.EnvironmentPolicy__c;
        mHeader.SocialResponsibilityPolicy__c = mAccount.SocialResponsibilityPolicy__c;
        mHeader.CorporateGovernancePolicy__c = mAccount.CorporateGovernancePolicy__c;
        mHeader.OccupationalHealthAndSafetyPolicy__c = mAccount.OccupationalHealthAndSafetyPolicy__c;
        mHeader.HumanRightsPolicy__c = mAccount.HumanRightsPolicy__c;
        mHeader.HasIssuesDuringThePast5Years__c = mAccount.HasIssuesDuringThePast5Years__c;
        mHeader.SpecifyIssuesDuringThePast5Years__c = mAccount.SpecifyIssuesDuringThePast5Years__c;
        mHeader.PaymentOverTheAmountOfUSD__c = mAccount.PaymentOverTheAmountOfUSD__c;
        mHeader.ReasonOfTheDefault__c = mAccount.ReasonOfTheDefault__c;
        mHeader.HasFailedSupplyInLast3Years__c = mAccount.HasFailedSupplyInLast3Years__c;
        mHeader.SpecifyFailedSupplyInLast3Years__c = mAccount.SpecifyFailedSupplyInLast3Years__c;
        mHeader.HasSanctionedTarget__c = mAccount.HasSanctionedTarget__c;
        mHeader.SpecifySanctionedTarget__c = mAccount.SpecifySanctionedTarget__c;
        mHeader.CEOFirstName__c = mAccount.CEOFirstName__c;
        mHeader.CEOLastName__c = mAccount.CEOLastName__c;
        mHeader.ImmidiateParentCompany__c = mAccount.ImmidiateParentCompany__c;
        mHeader.MainService__c = mAccount.MainService__c;
        mHeader.OtherMainService__c = mAccount.OtherMainService__c;
        mHeader.MainProduct__c = mAccount.MainProduct__c;
        mHeader.OtherMainProduct__c = mAccount.OtherMainProduct__c;
        mHeader.CompanyLatestCreditRating__c = mAccount.CompanyLatestCreditRating__c;

		mHeader.RecordTypeId = Schema.SObjectType.CTRRequestFormHeader__c.getRecordTypeInfosByDeveloperName().get('NewCounterparty').getRecordTypeId();//
        
        if(doInsert) insert mHeader;
        System.debug('newReqHeader Id: ' + mHeader.Id); 
        return mHeader;
    }

    public static String createReqHeader(Account mAccount, String intProdCus, String intProdSup, String ctrUserId, Id mLeadId, String BuProfile) {
        return createReqHeader(mAccount, intProdCus, intProdSup, ctrUserId, mLeadId, BuProfile, true).Id;
    }

    // Create Shipping Country Record
    public static void createShipCntry(Account account, List<CTRRequestFormItem__c> reqItems, List<CTRShippingCountry__c> shipCntrys) 
    {
        Map<String, Schema.RecordTypeInfo> reqItemRT = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName();
        List<CTRShippingCountry__c> shipCntryToInsert = new List<CTRShippingCountry__c>();

        for (CTRShippingCountry__c shipCntry : shipCntrys) 
        {
            for (CTRRequestFormItem__c reqItem : reqItems) 
            {
                if(reqItemRT.get('SupplierInitial').getRecordTypeId() != reqItem.RecordTypeId && 
                reqItemRT.get('SupplierInitial').getRecordTypeId() != reqItem.RecordTypeId)
                {
                    CTRShippingCountry__c newShipCntry = new CTRShippingCountry__c();
                    newShipCntry.Customer__c = account.Id;
                    newShipCntry.CTRRequestFormItem__c = reqItem.Id;
                    newShipCntry.LocationType__c = shipCntry.LocationType__c;
                    newShipCntry.ShippingCountry__c = shipCntry.ShippingCountry__c;
                    newShipCntry.OwnerId = UserInfo.getUserId();
                    shipCntryToInsert.add(newShipCntry);
                }

            }
        }
        if(shipCntryToInsert.size()>0)
        {
            insert shipCntryToInsert;
        }
    }

    
}