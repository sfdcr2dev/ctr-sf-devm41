public class CTRLeadConvert {

    public class ConvertResults {
        @InvocableVariable(label='New Request Header ID')
        public String newRequestHeaderId;

        @InvocableVariable(label='Existing Account')
        public Boolean existingAccount;

        @InvocableVariable(label='Is New Request Header')
        public Boolean isNewReqHeader;

        @InvocableVariable(label='Converted Account ID')
        public String convertedAccountId;
    }
    
    @InvocableMethod
    public static List<ConvertResults> assignLeads(List<Id> LeadIds) {
        List<ConvertResults> results = new List<ConvertResults>();
        try {
            LeadStatus cLeadStatus=[SELECT Id,MasterLabel FROM LeadStatus WHERE isConverted=true limit 1];
            List<Database.LeadConvert> massLeadConvert=new List<Database.LeadConvert>();
            List<Lead> leadList = [SELECT Id, Company, TaxNumber__c, FormerNameofCompany__c, Email, InterestedProductTypeasCustomer__c, InterestedProductTypeasSupplier__c,
                                    Salutation,FirstName, LastName, DoNotCall, Title, Phone, MobilePhone, Fax, Website, Status, OwnerId, Name, HouseNo__c, BuildingCode__c, 
                                    Room__c,Floor__c,Street__c, SubDistrict__c, District__c,PostalCode__c,NickName__c
                                    FROM Lead WHERE Id =: LeadIds[0]];
            List<Account>exisitngAccList = [SELECT Id FROM Account Where Name=:leadList[0].Company AND TaxNumber__c=:leadList[0].TaxNumber__c AND FormerNameofCompany__c=:leadList[0].FormerNameofCompany__c];
            String accountId = '';
            Boolean isExtAcc = false;
            if(exisitngAccList.size() > 0)
            {
                accountId = exisitngAccList[0].Id;
                isExtAcc = true;
            }
            List<Contact>exisitngContactList = new List<Contact>();
            if(accountId != '')
            {
                exisitngContactList = [SELECT Id FROM Contact Where Email=:leadList[0].Email and AccountId=:accountId];
            }
            for(Id currentLead:LeadIds){
                Database.LeadConvert LeadConvert=new Database.LeadConvert();
                LeadConvert.setLeadId(currentLead);
                LeadConvert.setConvertedStatus(cLeadStatus.MasterLabel);
                LeadConvert.setDoNotCreateOpportunity(true);
                //for lead convert to existing account/contact
                if(accountId != '') {
                    LeadConvert.setaccountId(accountId);
                }
                if(exisitngContactList.size() > 0) {
                    LeadConvert.setcontactId(exisitngContactList[0].Id);
                }
                massLeadConvert.add(LeadConvert);
            }
            if(!massLeadConvert.isEmpty()){
                id mUserId = UserInfo.getUserId();
                string BuProfile = CTRBuProfileController.checkBusinessUnitFromProfile(mUserId, null).BusinessUnit__c;
                // if(Test.isRunningTest()) {
                //     BuProfile = 'TX';
                // }
                List<Database.LeadConvertResult> lcr=Database.convertLead(massLeadConvert);
                if (lcr[0].isSuccess())  
                {
                    Lead mLead = leadList[0];
                    if (String.isBlank(accountId)) 
                    { 
                        accountId = lcr[0].getAccountId();
                    }
                    
                    Account updAccount = new Account(Id = accountId);
                        //updAccount.InterestedProductTypeCustomer__c = mLead.InterestedProductTypeasCustomer__c;
                        //updAccount.InterestedProductTypeSupplier__c =  mLead.InterestedProductTypeasSupplier__c;
                        updAccount.ContactSalutation__c = mLead.Salutation;
                        updAccount.FirstName__c = mLead.FirstName;
                        updAccount.LastName__c = mLead.LastName;
                        updAccount.MobilePhone__c = mLead.MobilePhone;
                        updAccount.Email__c = mLead.Email;
                        //updAccount.StatusDeletionIndicator__c = 'Active';
                        updAccount.OwnerId = mLead.OwnerId;
                        updAccount.LeadOwner__c = mLead.OwnerId;
                        updAccount.TaxCode1__c = mLead.TAXNumber__c;
                        updAccount.LeadName__c = mLead.Id;
                        updAccount.Nickname__c = mLead.NickName__c;
                        updAccount.CompanyNameENF__c = mLead.Company;
                        //updAccount.LeadSource__c = mLead.LeadSource;
                        updAccount.Name = mLead.Company;
                        
                        if(BuProfile == 'TX')
                        {
                            
                            updAccount.HousenoEN__c = mLead.HouseNo__c;
                            updAccount.BuildingCodeEN__c = mLead.BuildingCode__c;
                            updAccount.RoomEN__c = mLead.Room__c;
                            updAccount.FloorEN__c = mLead.Floor__c;
                            updAccount.FloorLocal__c = mLead.Floor__c;
                            updAccount.StreetEN__c = mLead.Street__c;
                            updAccount.SubDistrictENText__c = mLead.SubDistrict__c;
                            updAccount.DistrictENText__c = mLead.District__c;
                            updAccount.PostalCodeENText__c = mLead.PostalCode__c;
                            updAccount.Email__c = mLead.Email;
                        }

                        
                        update updAccount;
                        System.debug('updAccount'+updAccount.LeadName__c);
                    system.debug('lcr:'+lcr[0]);
                    List<Account> cvtAcctList = convertedAccount(lcr[0].getAccountId());
                    system.debug('cvtAcctList:'+cvtAcctList[0]);
                    Account mAccount = cvtAcctList[0];

                    CTRAccountCtrl.duplicateCheckResult dupResult = CTRAccountCtrl.checkDuplicateAccount(cvtAcctList[0], null, null, leadList[0].id);
                    
                    ConvertResults result = new ConvertResults();
                    result.newRequestHeaderId = dupResult.newRequestHeaderId;
                    result.existingAccount = isExtAcc;
                    result.isNewReqHeader = dupResult.isNewRequestHeader;      
                    result.convertedAccountId = cvtAcctList[0].Id;

                    results.add(result);
                }
            }
        } catch(Exception e) {
            system.debug('CTRLeadConvert----'+e.getmessage()+' line:'+e.getLineNumber());
        }
        return results;
    }

    public static List<Account> convertedAccount(Id accountId) {

        List<Account> cvtAcctList = new List<Account>();
            List<String> mAccountFields = new List<String>(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().keySet());            
            String soqlAccount = '';
            soqlAccount+= ' SELECT ' + String.join(mAccountFields, ',');
            soqlAccount+= ' ,LeadName__r.Buyer__c, LeadName__r.Seller__c, LeadName__r.RecordTypeId, LeadName__r.RecordType.DeveloperName';
            soqlAccount+= ' ,LeadName__r.InterestedProductTypeAsSupplierTX__c, LeadName__r.InterestedProductTypeAsCustomerTX__c, Country__r.Code__c';
            soqlAccount+= ' FROM Account';
            soqlAccount+= ' WHERE Id = \''+accountId+'\'';
            cvtAcctList = Database.query(soqlAccount);
        /*List<Account> cvtAcctList = [SELECT Id, IsDeleted, MasterRecordId, Name, Type, RecordTypeId, ParentId, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, 
                                        BillingLongitude, BillingGeocodeAccuracy, BillingAddress, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingLongitude, 
                                        ShippingGeocodeAccuracy, ShippingAddress, Phone, Fax, AccountNumber, Website, PhotoUrl, Sic, Industry, AnnualRevenue, NumberOfEmployees, Ownership, TickerSymbol, Description, Rating, 
                                        Site, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Jigsaw, JigsawCompanyId, AccountSource, 
                                        SicDesc, AccountGroup__c, AccountNumber__c, BuildingCodeEN__c, BuildingCodeLocal__c, BusinessBackground__c, CityStateLocalText__c, CityStateLocal__c, Comment__c, CompanyNameENF__c, 
                                        CompanyProfile__c, CountryText__c, Country__c, CreateDateinSAP__c, CustomerNameEN1__c, CustomerNameEN2__c, CustomerNameEN3__c, CustomerNameEN4__c, CustomerNameLocal1__c, CustomerNameLocal2__c, 
                                        CustomerNameLocal3__c, CustomerNameLocal4__c, CustomerType__c, DistrictENText__c, DistrictEN__c, DistrictLocalText__c, DistrictLocal__c, DocumentURL__c, EmailText__c, Email__c, EstablishedYear__c, 
                                        FaxExtension__c, FloorEN__c, FloorLocal__c, HousenoEN__c, HousenoLocal__c, Industry__c, LABIX__c, LineOfficial__c, ListedinStockMarket__c, Location__Latitude__s, Location__Longitude__s, Location__c, MobilePhone__c, 
                                        NoofBranch__c, OneFirmTrade__c, OtherRegistrationDocument__c, Overview__c, PhoneExtension__c, PostalCodeENText__c, PostalCodeLocalText__c, ProvinceENText__c, ProvinceEN__c, RegistrationDocument__c, 
                                        RoomEN__c, RoomLocal__c, SLA__c, StatusDeletionIndicator__c, StreetEN__c, StreetLocal__c, SubDistrictENText__c, SubDistrictEN__c, SubDistrictLocalText__c, SubDistrictLocal__c, TOPSOLVENTJSKem__c, 
                                        TOPSOLVENTTH__c, TOPSOLVENTTSChem__c, TOPSOLVENTTSR__c, TOPSOLVENTVN__c, TaxCode1__c, TaxCode2__c, ThaiLubeBase__c, ThaiOil__c, ThaiParaxylene__c, TimeZone__c, 
                                        TransportationZone__c, CompanyNameEN__c, NumberofEstablishedYear__c, Region__c, MailingHousenoLocal__c, TAXNumber__c, FormerNameofCompany__c, CompanyNameLocal__c, IncoperationDate__c, 
                                        InterestedProductTypeCustomer__c, FirstName__c, LastName__c, CountryCode__c, InterestedProductTypeSupplier__c, CompanyPurchasingVolumnperGrade__c, PaymentOverTheAmountOfUSD__c, ReasonOfTheDefault__c, 
                                        ViolatingAntiMoneyLaunderingLaws__c, TradderLicenseNumber__c, DestinationCountry__c, Yearofexperience__c, EstimatedMonthlyPurchaseQuantity__c, Unit__c, EnvironmentPolicy__c, OccupationalHealthAndSafetyPolicy__c, 
                                        CorporateGovernancePolicy__c, SupplierNumber__c, SFCode__c, ImmidiateParentCompany__c, UltimateParentCompany__c, TypeOfBusiness__c, TypeOfBusinessOthers__c, MainService__c, MainProduct__c, OtherMainService__c, 
                                        OtherMainProduct__c, CompanyLatestCreditRating__c, SameRegisteredAddress__c, LubeBaseProduct__c, LABIXProduct__c, ReasonOfViolatingantimoneylaw__c, NoOfRegistrationMinistryEnergy__c, StartTradingDate__c, CEOFirstName__c, LeadName__c, LeadOwner__c, ReferalBy__c, 
                                        MailingDistrict__c, MailingCountry__c, MailingStreet__c, MailingCity__c, MailingPostalCode__c, SAPCCA__c, CEOLastName__c, DistributionChannel__c, SalesDistrict__c, Division__c, CashManagementGroup__c, ReconciliationAccount__c, 
                                        SalesOffice__c, Currency__c, ExchangeRateType__c, CustomerPricingProcedure__c, DeliveryPriority__c, DeliveryPlant__c, MaxPartialDeliveries__c, ShippingConditions__c, OverDeliveries__c, PartialDeliveriesperitem__c, Position__c, SameAddressasSoldTo__c, 
                                        HerokuInitialSecret__c, SalesGroup__c, PhoneCountryCode__c, IsHeroku__c, CTRUser__c, SalesOrganization__c, CustomerSearchTermLocal__c, SupplierType__c, CompanyWebsite__c, CustomerSearchTermEN__c, SupplierSearchTermLocal__c, CreditControlArea__c, 
                                        Incoterms__c, Incoterms2Port__c, PaymentGuaranteeProcedure__c, AccountAssignmentGroup__c, SupplierSearchTermEN__c, TAXClassification__c, SortKey__c, UnderdeliveryTolerance__c, OverdeliveryTolerance__c, CompanyHaveAnyTargetsInsactionsDesc__c, 
                                        CompanyHhaveAnyTargetsInsactions__c, HumanRightsPolicy__c, CoName__c, EstimatedMonthlyPurchaseUnit__c, SpecifyLanguagesOfCompanyName__c, LegalEntity__c, LegalEntityOthers__c, ContactSalutation__c, SupplierBlockAll__c, CustomerBlockAll__c, RegionSAP__c, LinktoRecord__c,
                                        Nickname__c, FaxCountryCode__c, MobileCountryCode__c, CustomerProductIdentification__c, SupplierProductIdentification__c, LocationInGoogleMapsLinks__c, LocationInGoogleMapsLatitude__c, LocationInGoogleMapsLongtitude__c, MailingBuildingCode__c, MailingRoom__c, MailingFloor__c,
                                        MailingSubDistrict__c, PetroleumAndComponentsProducts__c, CustomerPurchaseProductFrom__c, SupplierSupplyProductTo__c, SocialResponsibilityPolicy__c, HasIssuesDuringThePast5Years__c, SpecifyIssuesDuringThePast5Years__c, HasFailedSupplyInLast3Years__c, SpecifyFailedSupplyInLast3Years__c, 
                                        HasSanctionedTarget__c, SpecifySanctionedTarget__c, Seller__c, Rebate__c, PriceDetermin__c, OrderProbab__c, OrderCombination__c, PaymentHistoryRecord__c, RecAccount__c, Authorization__c, Buyer__c, GroupKeyAccountKeyOfBank__c, VatRegNo__c, Liable1__c, Liable2__c, PaymentTerm__c, ChkDoubleInv__c, 
                                        AcctgClerk__c, OrderCurrency__c, GRBasedInvVerif__c, AutomaticPurchaseOrder__c, WthTaxType2__c, WthTaxType1__c, WHTaxCountry__c, RecTy1__c, RecTy2__c, PurchasingOrganization__c, MailingCoName__c, CustomerOtherProducts__c, SupplierOtherProducts__c, TradingPartner__c, CustomersFacilityTankAndStorage__c, 
                                        CustomersFacilityTransportation__c, SuppliersFacilityTankAndStorage__c, SuppliersFacilityTransportation__c, SectionofLeadOwner__c, TypeOfBusinessCommercialEvaluation__c, Lead__c, InterestedProductTypeCustomerTOP__c, InterestedProductTypeasCustomerTX__c, InterestedProductTypeSupplierTOP__c, 
                                        Interested_Product_Type_as_Supplier_TX__c FROM Account WHERE Id = :accountId];*/



        //[SELECT Id, Name, AccountNumber__c, SupplierNumber__c, FirstName__c, LastName__c, Email__c, HerokuInitialSecret__c, 
        //                                                 CompanyNameLocal__c, InterestedProductTypeCustomer__c, InterestedProductTypeSupplier__c, SalesOrganization__c,
        //                                                 FormerNameofCompany__c, TAXNumber__c, RecordTypeId, DistrictLocalText__c, CompanyNameENF__c,
        //                                                 CustomerType__c, CustomerSearchTermLocal__c, SupplierSearchTermLocal__c, IncoperationDate__c,
        //                                                 CompanyWebsite__c, Country__c, CustomerSearchTermEN__c, SupplierSearchTermEN__c, HousenoLocal__c,
        //                                                 StreetLocal__c, CityStateLocal__c, PostalCodeLocalText__c, MailingHousenoLocal__c, MailingStreet__c, MailingDistrict__c,
        //                                                 MailingCity__c, MailingPostalCode__c, CountryCode__c, MobilePhone__c, LubeBaseProduct__c, LABIXProduct__c,
        //                                                 CompanyPurchasingVolumnperGrade__c, ReasonOfTheDefault__c, PaymentOverTheAmountOfUSD__c, ViolatingAntiMoneyLaunderingLaws__c,
        //                                                 ReasonOfViolatingantimoneylaw__c, NoOfRegistrationMinistryEnergy__c, StartTradingDate__c, Yearofexperience__c,
        //                                                 EnvironmentPolicy__c, OccupationalHealthAndSafetyPolicy__c, CorporateGovernancePolicy__c, CEOFirstName__c,
        //                                                 CEOLastName__c, ImmidiateParentCompany__c, UltimateParentCompany__c, TypeOfBusinessOthers__c, MainService__c,
        //                                                 MainProduct__c, OtherMainService__c, OtherMainProduct__c, CompanyLatestCreditRating__c,Seller__c,ReferalBy__c

        //                                                 FROM Account WHERE Id = :accountId];
        
        return cvtAcctList;
    }
}