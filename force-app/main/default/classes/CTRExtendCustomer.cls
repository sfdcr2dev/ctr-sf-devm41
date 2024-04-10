public with sharing class CTRExtendCustomer {

    private static final String CTRREQUESTITEMSALESORGMAPPING = 'CTRRequestItemSalesOrgMapping';
    private static final String CTRREQUESTITEMPAYMENTMETHODMAPPING = 'CTRRequestItemPaymentMethodMapping';
    private static final String INTERESTEDPRODUCTTYPEASCUSTOMERTOPFIELD = 'InterestedProductTypeAsCustomerTOP__c';
    private static final String INTERESTEDPRODUCTTYPEASCUSTOMERTXFIELD = 'InterestedProductTypeAsCustomerTX__c';
    private static final String INTERESTEDPRODUCTTYPEASSUPPLIERTOPFIELD = 'InterestedProductTypeAsSupplierTOP__c';
    private static final String INTERESTEDPRODUCTTYPEASSUPPLIERTXFIELD = 'InterestedProductTypeAsSupplierTX__c';
    private static final String NEWSTATUS = 'New';
    private static final String NEWCOUNTERPARTY = 'NewCounterparty';
    private static final String CUSTOMERINITIAL = 'CustomerInitial';
    private static final String SUPPLIERINITIAL = 'SupplierInitial';
    private static final String EXTENSION = 'Extension';

    @AuraEnabled
    public static Map<String, Object> saveRequest(CTRRequestFormHeader__c requestHeader, CTRRequestFormItem__c requestItem, List<CTRShippingCountry__c> shippingCountries, String bu, Boolean isSupplier) {
        Map<String, Object> result = new Map<String, Object>();
        System.debug(requestHeader);
        System.debug(requestItem);
        System.debug(shippingCountries);
        System.debug(bu);
        try {
            Account account = getAccount(requestHeader.Customer__c);
            sObject createReqHeader = Schema.getGlobalDescribe().get('CTRRequestFormHeader__c').newSObject();
            List<CTRRequestFormHeader__c> existingReqFormHeaders = validateDuplicateRequestForm(requestHeader, requestItem, bu, isSupplier);
            Boolean doCreate = true;

            // check scenario #2
            if(existingReqFormHeaders != null && !existingReqFormHeaders.isEmpty()) {
                for(CTRRequestFormHeader__c eachHeader : existingReqFormHeaders) {
                    if(eachHeader.CTRRequestFormItem__r != null && !eachHeader.CTRRequestFormItem__r.isEmpty()) {
                        result.put('errorMessage', 'This request is duplicated product with record [' + eachHeader.CTRRequestFormItem__r[0].Name + ']');
                        doCreate = false;
                        break;
                    }
                }
            } 
            
            // check scenario #3
            if(doCreate && ((!isSupplier && !String.isBlank(account.AccountNumber__c)) || (isSupplier && !String.isBlank(account.SupplierNumber__c)))) {
                if(!isSupplier && !String.isBlank(account.AccountNumber__c)) { // customer scenario
                    String salesOrg = requestItem.SalesOrganization__c; // (!String.isBlank(requestItem.SalesOrganizationTOP__c) ? requestItem.SalesOrganizationTOP__c : requestItem.SalesOrganizationTX__c);
                    String mKey = account.AccountNumber__c+salesOrg+requestItem.DistributionChannel__c+requestItem.Division__c;
                    List<C360_SalesArea__c> salesAreaList = Database.query('SELECT Id FROM C360_SalesArea__c WHERE Key__c = :mKey');
                    if(!salesAreaList.isEmpty()) {
                        result.put('errorMessage', 'This customer has been registered in this area.');
                        doCreate = false;
                    }
                } else if(isSupplier && !String.isBlank(account.SupplierNumber__c)) { // supplier scenario
                    String purchaseOrg = requestItem.PurchasingOrganization__c; // (!String.isBlank(requestItem.PurchasingOrganizationTOP__c) ? requestItem.PurchasingOrganizationTOP__c : requestItem.PurchasingOrganizationTX__c);
                    String mKey = account.SupplierNumber__c+purchaseOrg;
                    List<CTRPurchasingView__c> purViewList = Database.query('SELECT Id FROM CTRPurchasingView__c WHERE Key__c = :mKey');
                    if(!purViewList.isEmpty()) {
                        result.put('errorMessage', 'This supplier has been registered in this area.');
                        doCreate = false;
                    }
                }
            } else if(doCreate && ((!isSupplier && String.isBlank(account.AccountNumber__c)) || (isSupplier && String.isBlank(account.SupplierNumber__c))) && existingReqFormHeaders != null && !existingReqFormHeaders.isEmpty() && String.isBlank(requestHeader.Id)) { // check scenario #4
                for(CTRRequestFormHeader__c eachHeader : existingReqFormHeaders) {
                    if(eachHeader.RecordType.DeveloperName == NEWCOUNTERPARTY) {
                        createReqHeader = eachHeader;
                        break;
                    }
                }
            } else if(!String.isBlank(requestHeader.Id)) { // edit scenario
                createReqHeader = requestHeader;
            }

            if(doCreate) {
                String intProdCus = String.isNotBlank(requestItem.InterestedProductTypeAsCustomerTOP__c) ? requestItem.InterestedProductTypeAsCustomerTOP__c : requestItem.InterestedProductTypeAsCustomerTX__c;
                String intProdSup = String.isNotBlank(requestItem.InterestedProductTypeAsSupplierTOP__c) ? requestItem.InterestedProductTypeAsSupplierTOP__c : requestItem.InterestedProductTypeAsSupplierTX__c;
                // List<String> intProdCusList = (String.isNotBlank(intProdCus)) ? intProdCus.split(';') : new List<String>();
                // List<String> intProdSupList = (String.isNotBlank(intProdSup)) ? intProdSup.split(';') : new List<String>();
                
                Savepoint sp = Database.setSavepoint();
                try {
                    Map<String, Object> inputReqFormHeaderMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(requestHeader));
                    System.debug('inputReqFormHeaderMap -----' + inputReqFormHeaderMap);
                    String selectedProductTypeField = '';
                    if(bu == 'TOP' || bu == 'LABIX') {
                        if(isSupplier) {
                            selectedProductTypeField = INTERESTEDPRODUCTTYPEASSUPPLIERTOPFIELD;
                        } else {
                            selectedProductTypeField = INTERESTEDPRODUCTTYPEASCUSTOMERTOPFIELD;
                        }
                    } else if(bu == 'TX') {
                        if(isSupplier) {
                            selectedProductTypeField = INTERESTEDPRODUCTTYPEASSUPPLIERTXFIELD;
                        } else {
                            selectedProductTypeField = INTERESTEDPRODUCTTYPEASCUSTOMERTXFIELD;
                        }
                    }
                    if(createReqHeader != null && createReqHeader.Id != null) {
                        if(inputReqFormHeaderMap != null && !String.isBlank(selectedProductTypeField)) {
                            Set<String> selectedProductTypes = new Set<String>();
                            List<sObject> existingReqFormItems = Database.query('SELECT ' + selectedProductTypeField + ' FROM CTRRequestFormItem__c WHERE CTRRequestFormHeader__c = \'' + createReqHeader.Id + '\'' + (!String.isBlank(requestItem.Id) ? ' AND Id != \'' + requestItem.Id + '\'' : ''));
                            System.debug('existingReqFormItems -----' + existingReqFormItems);
                            if(existingReqFormItems != null && !existingReqFormItems.isEmpty()) {
                                for(sObject eachItem : existingReqFormItems) {
                                    if(eachItem.get(selectedProductTypeField) != null && !String.isBlank(String.valueOf(eachItem.get(selectedProductTypeField)))) {
                                        selectedProductTypes.add(String.valueOf(eachItem.get(selectedProductTypeField)));
                                    }
                                }
                            }
                            selectedProductTypes.add((String) inputReqFormHeaderMap.get(selectedProductTypeField));
                            System.debug('selectedProductTypes -----' + selectedProductTypes);
                            createReqHeader.put(selectedProductTypeField, String.join(new List<String>(selectedProductTypes), ';'));
                        }
                        if(String.isBlank(requestItem.Id)) {
                            Id reqFormItemRecordType;
                            if(isSupplier) {
                                reqFormItemRecordType = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get(SUPPLIERINITIAL).getRecordTypeId();
                            } else {
                                reqFormItemRecordType = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get(CUSTOMERINITIAL).getRecordTypeId();
                            }
                            requestItem.RecordTypeId = reqFormItemRecordType; // assign new recordtype for scenario #4
                        }
                    } else {
                        Id reqFormHeaderExtension = Schema.SObjectType.CTRRequestFormHeader__c.getRecordTypeInfosByDeveloperName().get(EXTENSION).getRecordTypeId();
                        createReqHeader = CTRAccountCtrl.createReqHeader(account, intProdCus, intProdSup, account.CTRUser__c, null, bu, false);
                        createReqHeader.put('RecordTypeId', reqFormHeaderExtension);
                        createReqHeader.put('Status__c', NEWSTATUS);
                        if(inputReqFormHeaderMap != null) {
                            for(String headerKey : inputReqFormHeaderMap.keySet()) {
                                System.debug('headerKey -----' + headerKey);
                                if(headerKey != 'attributes') {
                                    if(createReqHeader.get(headerKey) != inputReqFormHeaderMap.get(headerKey)) {
                                        createReqHeader.put(headerKey, inputReqFormHeaderMap.get(headerKey));
                                    }
                                }
                            }
                        }
                    }
                    System.debug('createReqHeader -----' + createReqHeader);
                    upsert createReqHeader;
        
                    
                    if(bu == 'TOP' || bu == 'LABIX' || bu == 'TX') {
                        // if(intProdCusList.size() > 0) {
                        //     CTRAccountCtrl.createReqItem(account, createReqHeader.Id, intProdCusList, bu, requestItem.RecordTypeId, shippingCountries, 'Customer');
                        // }
                        // if(intProdSupList.size() > 0) {
                        //     CTRAccountCtrl.createReqItem(account, createReqHeader.Id, intProdSupList, bu, requestItem.RecordTypeId, shippingCountries, 'Supplier');
                        // }
                        if(String.isBlank(requestItem.Id)) {
                            requestItem.CTRRequestFormHeader__c = createReqHeader.Id;
                            requestItem.Status__c = NEWSTATUS;
                        }
                        System.debug('requestItem -----' + requestItem);
                        upsert requestItem;
                    }
                    result.put('recordId', requestItem.Id);
                } catch (DmlException dmlex) {
                    Database.rollback(sp);
                    throw dmlex;
                }
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        System.debug('result -----' + result);
        return result;
    }

    @AuraEnabled
    public static List<Map<String, String>> getPicklistValue(String fieldAPI,String sObjAPI) {
        return CTRInitialCustomerTOP.getPicklistValue(fieldAPI, sObjAPI);
    }

    @AuraEnabled(cacheable=true)
    public static String getCurrentUser() {
        return UserInfo.getUserId();
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccount(String accountId) {
        return [SELECT Id, CTRUser__c, CompanyNameENF__c, CompanyNameLocal__c, FormerNameofCompany__c, CustomerType__c, TypeOfBusinessCommercialEvaluation__c, TypeOfBusiness__c, LegalEntity__c, IncoperationDate__c, TaxCode1__c, SpecifyLanguagesOfCompanyName__c, SupplierType__c, Country__c, 
                TypeOfBusinessOthers__c, LegalEntityOthers__c, Yearofexperience__c, CompanyWebsite__c, NoOfRegistrationMinistryEnergy__c, CustomerSearchTermLocal__c, CustomerSearchTermEN__c, SupplierSearchTermLocal__c, SupplierSearchTermEN__c, CoName__c, HousenoLocal__c, RoomLocal__c, 
                BuildingCodeLocal__c, FloorLocal__c, StreetLocal__c, SubDistrictLocalText__c, CityStateLocal__c, DistrictLocalText__c, PostalCodeLocalText__c, LocationInGoogleMapsLinks__c, Location__Latitude__s, Location__Longitude__s, SameRegisteredAddress__c, MailingCoName__c, MailingHousenoLocal__c, 
                MailingRoom__c, MailingBuildingCode__c, MailingFloor__c, MailingStreet__c, MailingSubDistrict__c, MailingCity__c, MailingDistrict__c, MailingPostalCode__c, ContactSalutation__c, FirstName__c, Position__c, MobileCountryCode__c, PhoneCountryCode__c, FaxCountryCode__c, Nickname__c, LastName__c, 
                Email__c, MobilePhone__c, Phone, Fax, LubeBaseProduct__c, LABIXProduct__c, PetroleumAndComponentsProducts__c, CustomerOtherProducts__c, SupplierOtherProducts__c, CustomerProductIdentification__c, SupplierProductIdentification__c, SalesOrganization__c, CompanyPurchasingVolumnperGrade__c, 
                PurchasingOrganization__c, EstimatedMonthlyPurchaseUnit__c, StartTradingDate__c, CustomerPurchaseProductFrom__c, CustomersFacilityTankAndStorage__c, CustomersFacilityTransportation__c, SupplierSupplyProductTo__c, SuppliersFacilityTankAndStorage__c, SuppliersFacilityTransportation__c, 
                EnvironmentPolicy__c, SocialResponsibilityPolicy__c, CorporateGovernancePolicy__c, OccupationalHealthAndSafetyPolicy__c, HumanRightsPolicy__c, HasIssuesDuringThePast5Years__c, SpecifyIssuesDuringThePast5Years__c, PaymentOverTheAmountOfUSD__c, ReasonOfTheDefault__c, HasFailedSupplyInLast3Years__c, 
                SpecifyFailedSupplyInLast3Years__c, HasSanctionedTarget__c, SpecifySanctionedTarget__c, CEOFirstName__c, CEOLastName__c, ImmidiateParentCompany__c, MainService__c, OtherMainService__c, MainProduct__c, OtherMainProduct__c, CompanyLatestCreditRating__c, PhoneExtension__c, FaxExtension__c, 
                TimeZone__c, UltimateParentCompany__c, AccountNumber__c, AccountGroup__c, TaxClassification__c, AccountAssignmentGroup__c, Incoterms2Port__c, PaymentGuaranteeProcedure__c, PriceDetermin__c, Rebate__c, SupplierNumber__c,Country__r.Code__c, fmlCountryCode__c FROM Account WHERE Id = :accountId LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static String retrieveSalesOrgMapping(String selectedProductType, String bu) {
        String result = '';
        try {
            Map<String, CTRGeneralSetting__mdt> configMap = CTRCheckDueDiligenceController.getGeneralSetting(new List<String> {CTRREQUESTITEMSALESORGMAPPING});
            if(configMap != null && !configMap.isEmpty() && configMap.containsKey(CTRREQUESTITEMSALESORGMAPPING)) {
                if(!String.isBlank(configMap.get(CTRREQUESTITEMSALESORGMAPPING)?.LongValue__c)) {
                    Map<String, Object> buMap = (Map<String, Object>) JSON.deserializeUntyped(configMap.get(CTRREQUESTITEMSALESORGMAPPING).LongValue__c);
                    if(buMap != null && !buMap.isEmpty() && buMap.containsKey(bu)) {
                        Map<String, Object> productMap = (Map<String, Object>) buMap.get(bu);
                        if(productMap != null && !productMap.isEmpty() && productMap.containsKey(selectedProductType)) {
                            result = (String) productMap.get(selectedProductType);
                        }
                    }
                }
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return result;
    }

    @AuraEnabled
    public static List<Map<String, String>> retrieveDistributionChannel(String selectedProductType, String selectedSalesOrg, String bu) {
        List<Map<String, String>> options = new List<Map<String, String>>();
        try {
            if(!String.isBlank(selectedProductType) && !String.isBlank(selectedSalesOrg)) {
                List<Map<String, String>> defaultOptions = CTRInitialCustomerTOP.getPicklistValue('DistributionChannel__c', 'CTRRequestFormItem__c');
                List<CTRDependentPicklist__mdt> picklistValues = [SELECT DistributionChannel__c FROM CTRDependentPicklist__mdt WHERE Product__c =: selectedProductType AND SalesOrganization__c =: selectedSalesOrg AND DistributionChannel__c != null ORDER BY DistributionChannel__c ASC];
                if(!picklistValues.isEmpty()) {
                    Set<String> optionKeys = new Set<String>();
                    if(!defaultOptions.isEmpty()) {
                        for(CTRDependentPicklist__mdt channel : picklistValues) {
                            for(Map<String, String> defaultVal : defaultOptions) {
                                if(optionKeys != null && !optionKeys.isEmpty() && optionKeys.contains(defaultVal.get('value'))) { continue; }

                                if(channel.DistributionChannel__c == defaultVal.get('value')) {
                                    options.add(defaultVal);
                                    optionKeys.add(defaultVal.get('value'));
                                }
                            }
                        }
                    }
                } else if(defaultOptions != null && !defaultOptions.isEmpty()) {
                    options.addAll(defaultOptions);
                }
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        System.debug('options -----' + options);
        return options;
    }

    private static List<CTRRequestFormHeader__c> validateDuplicateRequestForm(CTRRequestFormHeader__c requestHeader, CTRRequestFormItem__c reqFormItem, String bu, Boolean isSupplier) {
        List<CTRRequestFormHeader__c> existingReqFormHeaders = new List<CTRRequestFormHeader__c>();
        List<String> whereSqls = new List<String>();
        List<String> headerWhereSqls = new List<String>();
        if(!String.isBlank(reqFormItem.Customer__c)) {
            whereSqls.add('Customer__c = \'' + reqFormItem.Customer__c + '\'');
            headerWhereSqls.add('Customer__c = \'' + reqFormItem.Customer__c + '\'');
        }
        // if(bu == 'TOP' || bu == 'LABIX') {
        //     if(isSupplier) {
        //         if(!String.isBlank(reqFormItem.InterestedProductTypeAsSupplierTOP__c)) {
        //             whereSqls.add('InterestedProductTypeAsSupplierTOP__c = \'' + reqFormItem.InterestedProductTypeAsSupplierTOP__c + '\'');
        //             // headerWhereSqls.add('InterestedProductTypeAsSupplierTOP__c INCLUDES (\'' + requestHeader.InterestedProductTypeAsSupplierTOP__c + '\')');
        //         }
        //         if(!String.isBlank(reqFormItem.PurchasingOrganizationTOP__c)) {
        //             whereSqls.add('PurchasingOrganizationTOP__c = \'' + reqFormItem.PurchasingOrganizationTOP__c + '\'');
        //         }
        //     } else {
        //         if(!String.isBlank(reqFormItem.InterestedProductTypeAsCustomerTOP__c)) {
        //             whereSqls.add('InterestedProductTypeAsCustomerTOP__c = \'' + reqFormItem.InterestedProductTypeAsCustomerTOP__c + '\'');
        //             // headerWhereSqls.add('InterestedProductTypeAsCustomerTOP__c INCLUDES (\'' + requestHeader.InterestedProductTypeAsCustomerTOP__c + '\')');
        //         }
        //         if(!String.isBlank(reqFormItem.SalesOrganizationTOP__c)) {
        //             whereSqls.add('SalesOrganizationTOP__c = \'' + reqFormItem.SalesOrganizationTOP__c + '\'');
        //         }
        //     }
        // } else {
        //     if(isSupplier) {
        //         if(!String.isBlank(reqFormItem.InterestedProductTypeAsSupplierTX__c)) {
        //             whereSqls.add('InterestedProductTypeAsSupplierTX__c = \'' + reqFormItem.InterestedProductTypeAsSupplierTX__c + '\'');
        //         }
        //         if(!String.isBlank(reqFormItem.PurchasingOrganizationTX__c)) {
        //             whereSqls.add('PurchasingOrganizationTX__c = \'' + reqFormItem.PurchasingOrganizationTX__c + '\'');
        //         }
        //     } else {
        //         if(!String.isBlank(reqFormItem.InterestedProductTypeAsCustomerTX__c)) {
        //             whereSqls.add('InterestedProductTypeAsCustomerTX__c = \'' + reqFormItem.InterestedProductTypeAsCustomerTX__c + '\'');
        //             // headerWhereSqls.add('InterestedProductTypeAsCustomerTX__c INCLUDES (\'' + requestHeader.InterestedProductTypeAsCustomerTX__c + '\')');
        //         }
        //         if(!String.isBlank(reqFormItem.SalesOrganizationTX__c)) {
        //             whereSqls.add('SalesOrganizationTX__c = \'' + reqFormItem.SalesOrganizationTX__c + '\'');
        //         }
        //     }
        // }
        if(isSupplier) {
            if(!String.isBlank(reqFormItem.PurchasingOrganization__c)) {
                whereSqls.add('PurchasingOrganization__c = \'' + reqFormItem.PurchasingOrganization__c + '\'');
            }
            if(bu == 'TOP' || bu == 'LABIX') {
                if(!String.isBlank(reqFormItem.InterestedProductTypeAsSupplierTOP__c)) {
                    //whereSqls.add('InterestedProductTypeAsSupplierTOP__c = \'' + reqFormItem.InterestedProductTypeAsSupplierTOP__c + '\'');
                    whereSqls.add('InterestedProductTypeAsSupplierTOP__c INCLUDES (\'' + reqFormItem.InterestedProductTypeAsSupplierTOP__c + '\')');
                    // headerWhereSqls.add('InterestedProductTypeAsSupplierTOP__c INCLUDES (\'' + requestHeader.InterestedProductTypeAsSupplierTOP__c + '\')');
                }
            } else {
                if(!String.isBlank(reqFormItem.InterestedProductTypeAsSupplierTX__c)) {
                    //whereSqls.add('InterestedProductTypeAsSupplierTX__c = \'' + reqFormItem.InterestedProductTypeAsSupplierTX__c + '\'');
                    whereSqls.add('InterestedProductTypeAsSupplierTX__c INCLUDES (\'' + reqFormItem.InterestedProductTypeAsSupplierTX__c + '\')');
                }
            }
        } else {
            if(!String.isBlank(reqFormItem.SalesOrganization__c)) {
                whereSqls.add('SalesOrganization__c = \'' + reqFormItem.SalesOrganization__c + '\'');
            }
            if(bu == 'TOP' || bu == 'LABIX') {
                if(!String.isBlank(reqFormItem.InterestedProductTypeAsCustomerTOP__c)) {
                    //whereSqls.add('InterestedProductTypeAsCustomerTOP__c = \'' + reqFormItem.InterestedProductTypeAsCustomerTOP__c + '\'');
                    whereSqls.add('InterestedProductTypeAsCustomerTOP__c INCLUDES (\'' + reqFormItem.InterestedProductTypeAsCustomerTOP__c + '\')');
                    // headerWhereSqls.add('InterestedProductTypeAsCustomerTOP__c INCLUDES (\'' + requestHeader.InterestedProductTypeAsCustomerTOP__c + '\')');
                }
            } else {
                if(!String.isBlank(reqFormItem.InterestedProductTypeAsCustomerTX__c)) {
                    //whereSqls.add('InterestedProductTypeAsCustomerTX__c = \'' + reqFormItem.InterestedProductTypeAsCustomerTX__c + '\'');
                    whereSqls.add('InterestedProductTypeAsCustomerTX__c INCLUDES (\'' + reqFormItem.InterestedProductTypeAsCustomerTX__c + '\')');
                    // headerWhereSqls.add('InterestedProductTypeAsCustomerTX__c INCLUDES (\'' + requestHeader.InterestedProductTypeAsCustomerTX__c + '\')');
                }
            }
            
            if(!String.isBlank(reqFormItem.DistributionChannel__c)) {
                whereSqls.add('DistributionChannel__c = \'' + reqFormItem.DistributionChannel__c + '\'');
            }
            if(!String.isBlank(reqFormItem.Division__c)) {
                whereSqls.add('Division__c = \'' + reqFormItem.Division__c + '\'');
        }
        }
        Set<String> statusList = new Set<String> {'Approved', 'Rejected'};
        if(!statusList.isEmpty()) {
            whereSqls.add('Status__c !=: statusList');
        }
        /* //check only customer
        if(!String.isBlank(reqFormItem.DistributionChannel__c)) {
            whereSqls.add('DistributionChannel__c = \'' + reqFormItem.DistributionChannel__c + '\'');
        }
        if(!String.isBlank(reqFormItem.Division__c)) {
            whereSqls.add('Division__c = \'' + reqFormItem.Division__c + '\'');
        }*/
        if(!String.isBlank(reqFormItem.Id)) {
            whereSqls.add('Id != \'' + reqFormItem.Id + '\'');
        }
        if(!whereSqls.isEmpty() && !headerWhereSqls.isEmpty()) {
            existingReqFormHeaders = Database.query('SELECT Id, RecordTypeId, RecordType.DeveloperName, InterestedProductTypeAsCustomerTOP__c, InterestedProductTypeAsCustomerTX__c, InterestedProductTypeAsSupplierTOP__c, InterestedProductTypeAsSupplierTX__c, (SELECT Id, Name FROM CTRRequestFormItem__r WHERE ' + String.join(whereSqls, ' AND ') + ') FROM CTRRequestFormHeader__c WHERE ' + String.join(headerWhereSqls, ' AND '));
        }
        System.debug('existingReqFormHeaders -----' + existingReqFormHeaders);
        return existingReqFormHeaders;
    }

    @AuraEnabled
    public static List<Map<String, String>> retrievePaymentMethodMapping(String selectedCompanyCode) {
        List<Map<String, String>> options = new List<Map<String, String>>();
        try {
            if(!String.isBlank(selectedCompanyCode)) {
                Map<String, CTRGeneralSetting__mdt> configMap = CTRCheckDueDiligenceController.getGeneralSetting(new List<String> {CTRREQUESTITEMPAYMENTMETHODMAPPING});
                if(configMap != null && !configMap.isEmpty() && configMap.containsKey(CTRREQUESTITEMPAYMENTMETHODMAPPING)) {
                    Map<String, Object> companyCodeMap = (Map<String, Object>) JSON.deserializeUntyped(configMap.get(CTRREQUESTITEMPAYMENTMETHODMAPPING).LongValue__c);
                    if(companyCodeMap != null && !companyCodeMap.isEmpty() && companyCodeMap.containsKey(selectedCompanyCode)) {
                        List<Object> paymentMethodList = (List<Object>) companyCodeMap.get(selectedCompanyCode);
                        System.debug('paymentMethodList -----' + paymentMethodList);
                        if(paymentMethodList != null) {
                            List<Map<String, String>> defaultOptions = CTRInitialCustomerTOP.getPicklistValue('PaymentMethod__c', 'CTRRequestFormItem__c');
                            if(!defaultOptions.isEmpty()) {
                                for(Object payment : paymentMethodList) {
                                    for(Map<String, String> defaultVal : defaultOptions) {
                                        if(String.valueOf(payment) == defaultVal.get('value')) {
                                            options.add(defaultVal);
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        System.debug('options -----' + options);
        return options;
    }
}