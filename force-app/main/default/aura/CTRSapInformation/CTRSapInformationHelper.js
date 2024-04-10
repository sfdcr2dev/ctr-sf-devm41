({
    /*helperMethod : function() {

    },
    getProfile: function(component){
        
        var action = component.get('c.getUserProfile');
        action.setParams({"recordId": component.get("v.recordId")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                //component.set('v.BussinessUnit',result);
                component.set('v.BussinessUnit','TOP');
            }
        });
        $A.enqueueAction(action);
    },*/

    getDefaultData: function (component) {
        component.set('v.showLoading', true);
        console.log('defaultdata 1');
        var action = component.get('c.getSAPInfoDatav2');
        action.setParams({
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                console.log('Debug result ', result);
                if (result && result.hasPermission) {
                    //PickList Options
                    component.set('v.TypeOfBusinessList', result.mDefaultPickList.mTypeOfBusinessBranch);
                    component.set('v.CountryCodePhoneList', result.mDefaultPickList.mCountryCodePhone)
                    component.set('v.PriceGroupList', result.mDefaultPickList.mPriceGroup);
                    component.set('v.TaxClassificationList', result.mDefaultPickList.mTaxClassification);
                    component.set('v.DivisionList', result.mDefaultPickList.mDivision);
                    component.set('v.LanguageList', result.mDefaultPickList.mLanguage);
                    component.set('v.AccountGroupList', result.mDefaultPickList.mAccountGroup);
                    component.set('v.TradingPartnerList', result.mDefaultPickList.mTradingPartner);
                    component.set('v.RegionList', result.mDefaultPickList.mRegion);



                    component.set('v.SalesOrgTOPList', result.mDefaultPickList.mSalesOrgTOP);
                    component.set('v.SalesOrgTXList', result.mDefaultPickList.mSalesOrgTX);
                    component.set('v.AllDistributionChannelList', result.mDefaultPickList.mDistributionChannel)
                    component.set('v.DistributionChannelList', result.mDefaultPickList.mDistributionChannel);
                    component.set('v.PurchasingOrgTOPList', result.mDefaultPickList.mPurchasingOrgTOP);
                    component.set('v.PurchasingOrgTXList', result.mDefaultPickList.mPurchasingOrgTX);
                    component.set('v.CashManagementGroupList', result.mDefaultPickList.mCashManagementGroup);


                    component.set('v.AccountAssignmentGroupList', result.mDefaultPickList.mAccountAssignmentGroup);
                    component.set('v.PaymentGuaranteeProcedureList', result.mDefaultPickList.mPaymentGuaranteeProcedure);
                    component.set('v.CreditControlAreaList', result.mDefaultPickList.mCreditControlArea);
                    component.set('v.PartialDeliveriesperitemList', result.mDefaultPickList.mPartialDeliveriesperitem);
                    component.set('v.SalesGroupList', result.mDefaultPickList.mSalesGroup);
                    component.set('v.RiskCategoryList', result.mDefaultPickList.mRiskCategory);
                    component.set('v.PaymentTermList', result.mDefaultPickList.mPaymentTerm);
                    component.set('v.Incoterms2List', result.mDefaultPickList.mIncoterms2);
                    component.set('v.IncotermsList', result.mDefaultPickList.mIncoterms);
                    component.set('v.DeliveryPlantList', result.mDefaultPickList.mDeliveryPlant);
                    component.set('v.ShippingConditionsList', result.mDefaultPickList.mShippingConditions);
                    component.set('v.DeliveryPriorityList', result.mDefaultPickList.mDeliveryPriority);
                    component.set('v.CurrencyList', result.mDefaultPickList.mCurrency);
                    component.set('v.SalesOfficeList', result.mDefaultPickList.mSalesOffice);
                    component.set('v.SalesDistrictList', result.mDefaultPickList.mSalesDistrict);
                    component.set('v.CompanyCodeTOPList', result.mDefaultPickList.mCompanyCodeTOP);


                    console.log('defaultdata 2: ' + result.mBusinessUnit);
                    console.log('defaultdata 3: ' + result.mRecordTypeName);

                    //component.set('v.BussinessUnit','TOP');
                    //component.set('v.isTX', true);
                    component.set('v.BussinessUnit', result.mBusinessUnit);
                    if (component.get('v.BussinessUnit') == 'TX') 
                    {
                        component.set('v.isTX', true);
                        if(result.mRequestItem.MDCMApprovalStatus__c)
                        {
                            if(result.mRequestItem.MDCMApprovalStatus__c == 'Waiting for Approval')
                            {
                                component.set('v.PendingApproval',true);
                                component.set('v.SentGeneralView', true);
                            }
                        }
                    }
                    else {
                        component.set('v.isTOP', true);
                        console.log('defaultdata 3.5: ' + JSON.stringify(result.mProductMapDependencyTOP));
                        if (component.get('v.BussinessUnit') == 'TOP') {
                            if (result.mRecordTypeName.includes('Customer')) {
                                console.log('mProductMapDependencyTOP:' + result.mProductMapDependencyTOP);
                                component.set('v.mDependencyMap', result.mProductMapDependencyTOP);
                                console.log('mProductMapDependencyTOP1:' + JSON.stringify(component.get('v.mDependencyMap')));
                                //console.log('mProductMapDependencyTOP2:' + JSON.stringify(component.get('v.mDependencyMap')["TOPG"].mCurrencyMap));

                            }
                        }
                    }
                    console.log('result.mCurrentUserName'+result.mCurrentUserName);
                    component.set('v.currentUserName', result.mCurrentUserName);
                    component.set('v.recordTypeNameCustomer', result.mRecordTypeName.includes('Customer'));
                    console.log('defaultdata 4: ' + result.mRecordTypeName.includes('Customer'));
                    if(result.mRecordTypeName.includes('ShipTo'))
                    {
                        component.set('v.isNotShipTo', false);
                    }
                    if ((result.mRequestItem.Customer__r.AccountNumber__c || result.mRequestItem.Customer__r.SupplierNumber__c) && !result.mRecordTypeName.includes('Edit')) {
                        component.set('v.SentGeneralView', true);
                    }

                    component.set('v.recordTypeName', result.mRecordTypeName);
                    console.log('recordTypeNameCustomer:' + component.get('v.recordTypeNameCustomer'));
                    component.set('v.requestFormItemObj', result.mRequestItem);
                    component.set('v.requestFormHeaderObj', result.mRequestHeader);
                    component.set('v.recordIdFormHeader', result.mHeaderId);
                    if (result.mRecordTypeName.includes('Edit')) {
                        if (result.mRequestHeader) {
                            if (result.mRequestHeader.InternalEditField__c) {
                                var mListFieldChanged = JSON.parse(result.mRequestHeader.InternalEditField__c);
                                component.set('v.ChangedFieldForEDITHeader', mListFieldChanged);
                            }

                        }
                        if (result.mRequestItem) {
                            if (result.mRequestItem.InternalEditField__c) {
                                var mListFieldChanged = JSON.parse(result.mRequestItem.InternalEditField__c);
                                component.set('v.ChangedFieldForEDITItem', mListFieldChanged);
                            }
                        }
                    }

                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Do not have permission",
                        "type": "error"
                    });
                    toastEvent.fire();

                    $A.get("e.force:closeQuickAction").fire();
                    this.closeModal(component);
                }
                component.set('v.showLoading', false);
                component.set('v.isModalOpen', true);

            }
        });
        $A.enqueueAction(action);
    },
    checkRequiredFields: function (component) {
        //Check validate fields 
        var ValidateMessageList = [];
        var ValidateGeneralList = [];
        var ValidateSalesList = [];
        var ValidatePurchasingList = [];
        var ValidateCompanyList = [];
        var ValidateFinancialList = [];

        // Get Object
        var requestFormHeaderObj = component.get('v.requestFormHeaderObj');
        var requestFormItemObj = component.get('v.requestFormItemObj');
        // Get RecordType Name
        var recordTypeNameCustomer = component.get('v.recordTypeNameCustomer');

        //TX
        if (component.get('v.isTX')) {
            // Check RecordType contains Customer
            if (recordTypeNameCustomer) {

                if (!requestFormHeaderObj.CustomerNameLocal1__c) { ValidateMessageList.push('Name ') }
                if (!requestFormHeaderObj.CustomerNameEN1__c) { ValidateMessageList.push('Name(Eng) ') }
                if (!requestFormHeaderObj.CustomerSearchTermLocal__c) { ValidateMessageList.push('Search Term 1 ') }
                if (!requestFormHeaderObj.StreetLocal__c) { ValidateMessageList.push('Street/House number') }
                if (!requestFormHeaderObj.DistrictLocalText__c) { ValidateMessageList.push('District ') }
                if (!requestFormHeaderObj.PostalCodeLocalText__c) { ValidateMessageList.push('Postal Code/City ') }
                if (!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c.length == 0) { ValidateMessageList.push('Country ') }
                if (!requestFormHeaderObj.MobilePhone__c) { ValidateMessageList.push('Mobile Phone ') }
                if (!requestFormItemObj.SalesOrganizationTX__c) { ValidateMessageList.push('Sales Organization ') }
                if (!requestFormHeaderObj.AccountGroup__c) { ValidateMessageList.push('Account Group ') }
                if (!requestFormHeaderObj.RegionSAP__c) { ValidateMessageList.push('Region ') }
                if (!requestFormItemObj.DistributionChannel__c) { ValidateMessageList.push('Distribution Channel ') }
                if (!requestFormItemObj.Division__c) { ValidateMessageList.push('Division ') }
                if (!requestFormItemObj.Industry__c) { ValidateMessageList.push('Industry ') }
                if (!requestFormItemObj.CustomerType__c) { ValidateMessageList.push('Customer Type ') }
                if (!requestFormItemObj.CustomerGroup__c) { ValidateMessageList.push('Customer Group ') }
                if (!requestFormHeaderObj.TypeOfBusinessBranch__c) { ValidateMessageList.push('Type Of Business (Branch) ') }
                if (!requestFormHeaderObj.TaxCode1__c) { ValidateMessageList.push('TAX Number ') }
                if (!requestFormItemObj.Application__c) { ValidateMessageList.push('Application ') }
                if (!requestFormItemObj.InterGroup__c) { ValidateMessageList.push('InterGroup ') }
                if (!requestFormItemObj.ReconAccount__c) { ValidateMessageList.push('Recon. Account ') }
                if (!requestFormItemObj.SortKey__c) { ValidateMessageList.push('Sort Key ') }
                if (!requestFormItemObj.CashManagementGroup__c) { ValidateMessageList.push('Cash Mgmnt Group ') }
                if (!requestFormItemObj.Authorization__c) { ValidateMessageList.push('Authorization ') }
                if (!requestFormItemObj.PaymentHistoryRecord__c) { ValidateMessageList.push('Payment History Record ') }
                if (!requestFormHeaderObj.TransportationZone__c) { ValidateMessageList.push('Transportation Zone ') }

                // sales tab Item 
                if (!requestFormItemObj.SalesDistrict__c) { ValidateMessageList.push('Sales District ') }
                if (!requestFormItemObj.SalesOffice__c) { ValidateMessageList.push('Sales Office ') }
                if (!requestFormItemObj.SalesGroup__c) { ValidateMessageList.push('Sales Group ') }
                if (!requestFormItemObj.Currency__c) { ValidateMessageList.push('Currency ') }
                if (!requestFormItemObj.OrderProbability__c) { ValidateMessageList.push('Order probab. ') }
                if (!requestFormItemObj.ExchangeRateType__c) { ValidateMessageList.push('Exch. Rate Type ') }
                if (!requestFormItemObj.CustPriceProc__c) { ValidateMessageList.push('Cust.pice.proc ') }
                if (!requestFormItemObj.CustStatGroup__c) { ValidateMessageList.push('Cust Stats.Grp ') }
                if (!requestFormItemObj.OrderCombination__c) { ValidateMessageList.push('Order Combination ') }
                if (!requestFormItemObj.DeliveryPriority__c) { ValidateMessageList.push('Delivery Priority ') }
                if (!requestFormItemObj.ShippingConditions__c) { ValidateMessageList.push('Shipping Conditions ') }
                if (!requestFormItemObj.DeliveryPlant__c) { ValidateMessageList.push('Delivery Plant ') }
                if (!requestFormItemObj.PartialDeliveriesperitem__c) { ValidateMessageList.push('Partail delivery per item ') }
                if (!requestFormItemObj.MaxPartialDeliveries__c) { ValidateMessageList.push('Max Partail delivery') }
                if (!requestFormItemObj.UnderdeliveryTolerance__c) { ValidateMessageList.push('Underdel tolerance ') }
                if (!requestFormItemObj.OverdeliveryTolerance__c) { ValidateMessageList.push('Overdeliv. tolerance ') }
                if (!requestFormItemObj.Rebate__c) { ValidateMessageList.push('Rebate ') }
                if (!requestFormItemObj.IsPriceDetermin__c) { ValidateMessageList.push('Price determin ') }
                if (!requestFormItemObj.Incoterms__c) { ValidateMessageList.push('Incoterms ') }
                if (!requestFormItemObj.Incoterms2__c) { ValidateMessageList.push('Incoterms2 ') }
                if (!requestFormItemObj.CreditControlArea__c) { ValidateMessageList.push('Credit Control Area ') }
                if (!requestFormItemObj.TermOfPayment__c) { ValidateMessageList.push('PaymentTerm ') }
                if (!requestFormItemObj.PaymentGuaranteeProcedure__c) { ValidateMessageList.push('Payment Guarantee Procedure ') }
                if (!requestFormItemObj.TaxClassification__c) { ValidateMessageList.push('Tax Classification ') }
                if (!requestFormItemObj.AccountAssignmentGroup__c) { ValidateMessageList.push('Account Assignment Group ') }
                if (!requestFormItemObj.RiskCategory__c) { ValidateMessageList.push('Risk Category  ') }


            }
            // Check RecordType contains Supplier
            else if (!recordTypeNameCustomer) {

                //if(!requestFormHeaderObj.CustomerNameLocal1__c){ ValidateMessageList.push('Name ')}
                //if(!requestFormHeaderObj.CustomerNameEN1__c){ ValidateMessageList.push('Name(Eng) ')}
                if (!requestFormHeaderObj.SupplierSearchTermLocal__c) { ValidateMessageList.push('Search Term 1 ') }
                if (!requestFormHeaderObj.StreetLocal__c) { ValidateMessageList.push('Street/House number ') }
                if (!requestFormHeaderObj.DistrictLocalText__c) { ValidateMessageList.push('District ') }
                if (!requestFormHeaderObj.PostalCodeLocalText__c) { ValidateMessageList.push('Postal Code/City') }
                if (!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c.length == 0) { ValidateMessageList.push('Country ') }
                if (!requestFormHeaderObj.Phone__c) { ValidateMessageList.push('Phone ') }
                if (!requestFormHeaderObj.AccountGroup__c) { ValidateMessageList.push('Account Group ') }
                if (!requestFormHeaderObj.TaxCode1__c) { ValidateMessageList.push('TAX Number ') }
                if (!requestFormHeaderObj.GroupKeyAccountKeyofBank__c) { ValidateMessageList.push('Group Key(Account Key of Bank) ') }
                //if(!requestFormHeaderObj.VATRegno__c){ ValidateMessageList.push('VAT Reg no. ')}
                if (!requestFormItemObj.TermOfPayment__c) { ValidateMessageList.push('Payment Term ') }
                if (!requestFormItemObj.PaymentMethod__c) { ValidateMessageList.push('Payment Method ') }
                if (!requestFormItemObj.AccigClerk__c) { ValidateMessageList.push('Acctg Clerk ') }
                //if(!requestFormItemObj.Currency__c){ ValidateMessageList.push('Order currency ')}
                //if(!requestFormItemObj.ReconAccount__c){ ValidateMessageList.push('Recon. Account ')}
                //if(!requestFormItemObj.SortKey__c){ ValidateMessageList.push('Sort Key ')}
                //if(!requestFormItemObj.CashManagementGroup__c){ ValidateMessageList.push('Cash Mgmnt Group ')}

            }

        }
        else if (component.get('v.isTOP')) {
            if (recordTypeNameCustomer) {
                // Tab General
                if (!requestFormItemObj.SalesOrganizationTOP__c) { ValidateMessageList.push('Sales Organization ') }
                if (!requestFormHeaderObj.AccountGroup__c) { ValidateMessageList.push('Account Group ') }
                if (!requestFormItemObj.DistributionChannel__c) { ValidateMessageList.push('Distribution Channel ') }
                if (!requestFormHeaderObj.Industry__c) { ValidateMessageList.push('Industry ') }
                if (!requestFormHeaderObj.CustomerType__c) { ValidateMessageList.push('Customer Type ') }
                if (!requestFormHeaderObj.TypeOfBusinessBranch__c) { ValidateMessageList.push('Type Of Business (Branch) ') }
                if (!requestFormHeaderObj.TaxCode1__c) { ValidateMessageList.push('TAX Number ') }

                if (!requestFormHeaderObj.CustomerNameLocal1__c) { ValidateMessageList.push('Name* ') }
                if (!requestFormHeaderObj.CustomerSearchTermLocal__c) { ValidateMessageList.push('Search Term 1* ') }

                if (!requestFormHeaderObj.StreetLocal__c) { ValidateMessageList.push('Street ') }
                if (!requestFormHeaderObj.HousenoLocal__c) { ValidateMessageList.push('House no ') }
                if (!requestFormHeaderObj.DistrictLocalText__c) { ValidateMessageList.push('District* ') }
                if (!requestFormHeaderObj.PostalCodeLocalText__c) { ValidateMessageList.push('Postal Code/City* ') }
                if (!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c == 0) { ValidateMessageList.push('Country* ') }
                if (!requestFormHeaderObj.Language__c) { ValidateMessageList.push('Language* ') }

                // Tab Sales (Req Item)
                if (!requestFormItemObj.Currency__c) { ValidateMessageList.push('Currency* ') }
                if (!requestFormHeaderObj.TaxClassification__c) { ValidateMessageList.push('Tax Classification* ') }
                if (!requestFormItemObj.AccountAssignmentGroup__c) { ValidateMessageList.push('Account Assignment Group* ') }
                if (!requestFormItemObj.TermOfPayment__c) { ValidateMessageList.push('Payment Terms* ') }
                if (!requestFormItemObj.PaymentGuaranteeProcedure__c) { ValidateMessageList.push('Payment Guarantee Procedure* ') }

            } else if (!recordTypeNameCustomer) {
                // Tab General
                if (!requestFormHeaderObj.AccountGroup__c) { ValidateMessageList.push('Account Group* ') }
                if (!requestFormHeaderObj.TypeOfBusinessBranch__c) { ValidateMessageList.push('Type Bussiness (Branch)* ') }
                if (!requestFormHeaderObj.TaxCode1__c) { ValidateMessageList.push('TAX Number* ') }
                if (!requestFormHeaderObj.CustomerNameLocal1__c) { ValidateMessageList.push('Name* ') }
                if (!requestFormHeaderObj.SupplierSearchTermLocal__c) { ValidateMessageList.push('Search Term 1* ') }
                if (!requestFormHeaderObj.StreetLocal__c) { ValidateMessageList.push('Street ') }
                if (!requestFormHeaderObj.DistrictLocalText__c) { ValidateMessageList.push('District* ') }
                if (!requestFormHeaderObj.PostalCodeLocalText__c) { ValidateMessageList.push('Postal Code/City* ') }
                if (!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c == 0) { ValidateMessageList.push('Country* ') }
                if (!requestFormHeaderObj.Language__c) { ValidateMessageList.push('Language* ') }
                // Tab Purchasing
                if (!requestFormItemObj.Currency__c) { ValidateMessageList.push('Order currency* ') }
                if (!requestFormItemObj.TermOfPayment__c) { ValidateMessageList.push('Terms of payment* ') }
            }
        }
        return ValidateMessageList;
    },
    checkRequiredFieldsv2: function (component) {
        //Check validate fields 
        var ValidateMessageList = [];
        var ValidateMessageMap = new Map();

        var ValidateGeneralList = [];
        var ValidateSalesList = [];
        var ValidatePurchasingList = [];
        var ValidateCompanyList = [];
        var ValidateFinancialList = [];

        // Get Object
        var requestFormHeaderObj = component.get('v.requestFormHeaderObj');
        var requestFormItemObj = component.get('v.requestFormItemObj');
        // Get RecordType Name
        var recordTypeNameCustomer = component.get('v.recordTypeNameCustomer');

        //TX
        if (component.get('v.isTX')) {
            // Check RecordType contains Customer
            if (recordTypeNameCustomer) {

                if (!requestFormHeaderObj.CustomerNameLocal1__c) { ValidateGeneralList.push('Name ') }
                if (!requestFormHeaderObj.CustomerNameEN1__c) { ValidateGeneralList.push('Name(Eng) ') }
                if (!requestFormHeaderObj.CustomerSearchTermLocal__c) { ValidateGeneralList.push('Search Term 1 ') }
                if (!requestFormHeaderObj.StreetLocal__c) { ValidateGeneralList.push('Street/House number ') }
                if (!requestFormHeaderObj.DistrictLocalText__c) { ValidateGeneralList.push('District ') }
                if (!requestFormHeaderObj.PostalCodeLocalText__c || requestFormHeaderObj.PostalCodeLocalText__c.length == 0) { ValidateGeneralList.push('Postal Code/City ') }
                if (!requestFormHeaderObj.StreetEN__c) { ValidateGeneralList.push('Street/House number(Eng) ') }
                if (!requestFormHeaderObj.DistrictENText__c) { ValidateGeneralList.push('District (Eng) ') }
                //if(!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c.length == 0){ ValidateGeneralList.push('Country ')}
                if (!requestFormHeaderObj.Language__c) { ValidateGeneralList.push('Language ') }
                if (!requestFormHeaderObj.MobileCountryCode__c) { ValidateGeneralList.push('Mobile Phone (Country Code)') }
                if (!requestFormHeaderObj.MobilePhone__c) { ValidateGeneralList.push('Mobile Phone ') }
                if (!requestFormHeaderObj.PhoneCountryCode__c) { ValidateGeneralList.push('Phone (Country Code) ') }
                if (!requestFormHeaderObj.Phone__c) { ValidateGeneralList.push('Phone ') }

                // if (!requestFormItemObj.SalesOrganizationTX__c) { ValidateGeneralList.push('Sales Organization ') } // move to sales tab
                if (!requestFormHeaderObj.TypeOfBusinessBranch__c) { ValidateGeneralList.push('Type Of Business (Branch) ') }
                // if (!requestFormHeaderObj.TaxCode1__c) { ValidateGeneralList.push('TAX Number ') }
                if (!requestFormHeaderObj.TAXClassification__c || requestFormHeaderObj.TAXClassification__c.length == 0) { ValidateGeneralList.push('Tax Classification ') }

                // if (!requestFormHeaderObj.AccountGroup__c) { ValidateGeneralList.push('Account Group ') }
                // if (!requestFormHeaderObj.RegionSAP__c) { ValidateGeneralList.push('Region ') }
                if (!requestFormHeaderObj.TransportationZone__c) { ValidateGeneralList.push('Transportation Zone ') }
                //if(!requestFormHeaderObj.TradingPartner__c){ ValidateGeneralList.push('TradingPartner ')}
                // if (!requestFormItemObj.DistributionChannel__c) { ValidateGeneralList.push('Distribution Channel ') } // move to sales tab
                // if (!requestFormItemObj.Division__c) { ValidateGeneralList.push('Division ') } // move to sales tab
                if (!requestFormItemObj.CustomerType__c) { ValidateGeneralList.push('Customer Type ') }
                if (!requestFormItemObj.CustomerGroup__c) { ValidateGeneralList.push('Customer Group ') }
                if (!requestFormItemObj.Industry__c) { ValidateGeneralList.push('Industry ') }
                if (!requestFormItemObj.SubIndustry__c) { ValidateGeneralList.push('Sub-Industry') }
                if (!requestFormItemObj.Application__c) { ValidateGeneralList.push('Application ') }
                if (!requestFormItemObj.InterGroup__c) { ValidateGeneralList.push('InterGroup ') }



                // sales tab Item 
                // if (!requestFormItemObj.SalesOrganizationTX__c) { ValidateSalesList.push('Sales Organization ') }
                // if (!requestFormItemObj.DistributionChannel__c) { ValidateSalesList.push('Distribution Channel ') }
                // if (!requestFormItemObj.Division__c) { ValidateSalesList.push('Division ') }
                if (!requestFormItemObj.SalesDistrict__c) { ValidateSalesList.push('Sales District ') }
                if (!requestFormItemObj.SalesOffice__c) { ValidateSalesList.push('Sales Office ') }
                if (!requestFormItemObj.SalesGroup__c) { ValidateSalesList.push('Sales Group ') }
                // if (!requestFormItemObj.Currency__c) { ValidateSalesList.push('Currency ') }
                // if (!requestFormItemObj.OrderProbability__c) { ValidateSalesList.push('Order probab. ') }
                if (!requestFormItemObj.ExchangeRateType__c) { ValidateSalesList.push('Exch. Rate Type ') }
                if (!requestFormItemObj.CustPriceProc__c) { ValidateSalesList.push('Cust.pice.proc ') }
                if (!requestFormItemObj.CustStatGroup__c) { ValidateSalesList.push('Cust Stats.Grp ') }

                // if (!requestFormItemObj.OrderCombination__c) { ValidateSalesList.push('Order Combination ') }
                if (!requestFormItemObj.DeliveryPriority__c) { ValidateSalesList.push('Delivery Priority ') }
                if (!requestFormItemObj.ShippingConditions__c) { ValidateSalesList.push('Shipping Conditions ') }
                if (!requestFormItemObj.DeliveryPlant__c) { ValidateSalesList.push('Delivery Plant ') }
                //if (!requestFormItemObj.PartialDeliveriesperitem__c) { ValidateSalesList.push('Partial delivery per item ') }
                if (!requestFormItemObj.MaxPartialDeliveries__c || requestFormItemObj.MaxPartialDeliveries__c.length == 0) { ValidateSalesList.push('Max Partail delivery') }
                if (!requestFormItemObj.UnderdeliveryTolerance__c || requestFormItemObj.UnderdeliveryTolerance__c.length == 0) { ValidateSalesList.push('Underdel tolerance ') }
                if (!requestFormItemObj.OverdeliveryTolerance__c || requestFormItemObj.OverdeliveryTolerance__c.length == 0) { ValidateSalesList.push('Overdeliv. tolerance ') }

                // if (!requestFormItemObj.Rebate__c) { ValidateSalesList.push('Rebate ') }
                // if (!requestFormItemObj.IsPriceDetermin__c) { ValidateSalesList.push('Price determin ') }
                if (!requestFormItemObj.Incoterms__c) { ValidateSalesList.push('Incoterms ') }
                // if (!requestFormItemObj.Incoterms2__c) { ValidateSalesList.push('Incoterms2 ') }
                if (!requestFormItemObj.CreditControlArea__c) { ValidateSalesList.push('Credit Control Area ') }
                // if (!requestFormItemObj.TermOfPayment__c) { ValidateSalesList.push('Term of payment ') }
                if (!requestFormItemObj.PaymentGuaranteeProcedure__c) { ValidateSalesList.push('Payment Guarantee Procedure ') }
                if (!requestFormItemObj.AccountAssignmentGroup__c) { ValidateSalesList.push('Account Assignment Group ') }
                // if (!requestFormItemObj.RiskCategory__c) { ValidateSalesList.push('Risk Category  ') }

                if(component.get('v.isNotShipTo'))
                {
                    //Company financial view tab
                    // if (!requestFormItemObj.ReconAccount__c) { ValidateFinancialList.push('Recon. Account ') }
                    // if (!requestFormItemObj.SortKey__c) { ValidateFinancialList.push('Sort Key ') }
                    // if (!requestFormItemObj.CashManagementGroup__c) { ValidateFinancialList.push('Cash Mgmnt Group ') }
                    // if (!requestFormItemObj.Authorization__c) { ValidateFinancialList.push('Authorization ') }
                    // if (!requestFormItemObj.PaymentHistoryRecord__c) { ValidateFinancialList.push('Payment History Record ') }
                }



            }
            // Check RecordType contains Supplier
            else if (!recordTypeNameCustomer) {

                //General view supplier
                if (!requestFormHeaderObj.CustomerNameLocal1__c) { ValidateGeneralList.push('Name ') }
                if (!requestFormHeaderObj.CustomerNameEN1__c) { ValidateGeneralList.push('Name(Eng) ') }
                if (!requestFormHeaderObj.SupplierSearchTermLocal__c) { ValidateGeneralList.push('Search Term 1 ') }
                if (!requestFormHeaderObj.StreetLocal__c) { ValidateGeneralList.push('Street/House number ') }
                if (!requestFormHeaderObj.DistrictLocalText__c) { ValidateGeneralList.push('District ') }
                if (!requestFormHeaderObj.PostalCodeLocalText__c || requestFormHeaderObj.PostalCodeLocalText__c.length == 0) { ValidateGeneralList.push('Postal Code/City') }
                if (!requestFormHeaderObj.StreetEN__c) { ValidateGeneralList.push('Street/House number(Eng) ') }
                if (!requestFormHeaderObj.DistrictENText__c) { ValidateGeneralList.push('District (Eng) ') }
                // if (!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c.length == 0) { ValidateGeneralList.push('Country ') }
                if (!requestFormHeaderObj.Language__c) { ValidateGeneralList.push('Language ') }
                if (!requestFormHeaderObj.MobileCountryCode__c) { ValidateGeneralList.push('Mobile Phone Country Code') }
                if (!requestFormHeaderObj.MobilePhone__c) { ValidateGeneralList.push('Mobile Phone ') }
                if (!requestFormHeaderObj.PhoneCountryCode__c) { ValidateGeneralList.push('Phone Country Code ') }
                if (!requestFormHeaderObj.Phone__c) { ValidateGeneralList.push('Phone ') }
                //if(!requestFormHeaderObj.Phone__c){ ValidateGeneralList.push('Phone ')}
                if (!requestFormHeaderObj.AccountGroup__c) { ValidateGeneralList.push('Account Group ') }
                // if (!requestFormHeaderObj.TaxCode1__c) { ValidateGeneralList.push('TAX Number ') }
                // if (!requestFormHeaderObj.GroupKeyAccountKeyofBank__c) { ValidateGeneralList.push('Group Key(Account Key of Bank) ') }

                //purchasing view
                //if(!requestFormHeaderObj.VATRegno__c){ ValidatePurchasingList.push('VAT Reg no. ')}
                if (!requestFormItemObj.TermOfPayment__c || requestFormItemObj.TermOfPayment__c.length == 0) { ValidatePurchasingList.push('Term of payment ') }
                if (!requestFormItemObj.Incoterms__c) { ValidatePurchasingList.push('Incoterms ') }
                // if (!requestFormItemObj.Currency__c) { ValidatePurchasingList.push('Order currency ') }

                // if(component.get('v.isNotShipTo'))
                // {
                    //Company view
                    // if (!requestFormItemObj.ReconAccount__c) { ValidateCompanyList.push('Recon. Account ') }
                    // if (!requestFormItemObj.SortKey__c) { ValidateCompanyList.push('Sort Key ') }
                    // if (!requestFormItemObj.CashManagementGroup__c) { ValidateCompanyList.push('Cash Mgmnt Group ') }
                    if (!requestFormItemObj.PaymentMethod__c) { ValidateCompanyList.push('Payment Method ') }
                    if (!requestFormItemObj.AccigClerk__c) { ValidateCompanyList.push('Acctg Clerk ') }

                //}

            }

        }
        else if (component.get('v.isTOP')) {
            if (recordTypeNameCustomer) {
                // Tab General
                //if (!requestFormItemObj.SalesOrganizationTOP__c) { ValidateGeneralList.push('Sales Organization ') }
                if (!requestFormHeaderObj.AccountGroup__c) { ValidateGeneralList.push('Account Group ') }
                if(requestFormHeaderObj.AccountGroup__c)
                {
                    if(requestFormHeaderObj.AccountGroup__c == 'TOPG')
                    {
                        if (!requestFormHeaderObj.TradingPartner__c) { ValidateGeneralList.push('Trading Partner ') }
                        
                    }
                }

                //if (!requestFormHeaderObj.Industry__c) { ValidateGeneralList.push('Industry ') }
                //if (!requestFormHeaderObj.CustomerType__c) { ValidateGeneralList.push('Customer Type ') }
                if (!requestFormHeaderObj.TypeOfBusinessBranch__c) { ValidateGeneralList.push('Type Of Business (Branch) ') }
                //if (!requestFormHeaderObj.TypeOfBusinessBranch__c) { ValidateGeneralList.push('Type Of Business (Branch) ') }
                //if (!requestFormHeaderObj.TaxCode1__c) { ValidateGeneralList.push('TAX Number ') }

                if (!requestFormHeaderObj.CustomerNameLocal1__c) { ValidateGeneralList.push('Name ') }
                if (!requestFormHeaderObj.CustomerSearchTermLocal__c) { ValidateGeneralList.push('Search Term 1 ') }

                if (!requestFormHeaderObj.StreetLocal__c) { ValidateGeneralList.push('Street ') }
                if (!requestFormHeaderObj.HousenoLocal__c) { ValidateGeneralList.push('House no ') }
                if (!requestFormHeaderObj.DistrictLocalText__c) { ValidateGeneralList.push('District ') }
                if (!requestFormHeaderObj.PostalCodeLocalText__c) { ValidateGeneralList.push('Postal Code/City ') }
                //if (!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c == 0) { ValidateGeneralList.push('Country ') }
                if (!requestFormHeaderObj.Language__c) { ValidateGeneralList.push('Language ') }
                if (!requestFormHeaderObj.MobileCountryCode__c) { ValidateGeneralList.push('Mobile Phone Country Code ') }
                if (!requestFormHeaderObj.MobilePhone__c) { ValidateGeneralList.push('Mobile Phone ') }
                if (!requestFormHeaderObj.PhoneCountryCode__c) { ValidateGeneralList.push('Phone Country Code ') }
                if (!requestFormHeaderObj.Phone__c) { ValidateGeneralList.push('Phone ') }

                // Tab Sales (Req Item)
                //if (!requestFormItemObj.DistributionChannel__c) { ValidateSalesList.push('Distribution Channel ') }
                //if (!requestFormItemObj.Division__c) { ValidateSalesList.push('Division ') }
                if (!requestFormItemObj.Currency__c) { ValidateSalesList.push('Currency ') }
                if (!requestFormHeaderObj.TAXClassification__c) { ValidateSalesList.push('Tax Classification ') }
                if (!requestFormItemObj.AccountAssignmentGroup__c) { ValidateSalesList.push('Account Assignment Group ') }
                if (!requestFormItemObj.Incoterms__c) { ValidateSalesList.push('Incoterms ') }
                if (!requestFormItemObj.TermOfPayment__c || requestFormItemObj.TermOfPayment__c.length == 0) { ValidateSalesList.push('Payment Terms ') }
                if (!requestFormItemObj.PaymentGuaranteeProcedure__c) { ValidateSalesList.push('Payment Guarantee Procedure ') }

            } else if (!recordTypeNameCustomer) {
                // Tab General
                //if (!requestFormItemObj.PurchasingOrganizationTOP__c) { ValidateGeneralList.push('Purchasing Organization ') }
                if (!requestFormHeaderObj.AccountGroup__c) { ValidateGeneralList.push('Account Group ') }
                if(requestFormHeaderObj.AccountGroup__c)
                {
                    if(requestFormHeaderObj.AccountGroup__c == 'TOPG')
                    {
                        if (!requestFormHeaderObj.TradingPartner__c) { ValidateGeneralList.push('Trading Partner ') }
                        
                    }
                }
                if (!requestFormHeaderObj.TypeOfBusinessBranch__c) { ValidateGeneralList.push('Type Bussiness (Branch) ') }
                //if (!requestFormHeaderObj.TaxCode1__c) { ValidateGeneralList.push('TAX Number ') }
                if (!requestFormHeaderObj.CustomerNameLocal1__c) { ValidateGeneralList.push('Name ') }
                if (!requestFormHeaderObj.SupplierSearchTermLocal__c) { ValidateGeneralList.push('Search Term 1 ') }
                if (!requestFormHeaderObj.StreetLocal__c) { ValidateGeneralList.push('Street ') }
                if (!requestFormHeaderObj.HousenoLocal__c) { ValidateGeneralList.push('House no ') }
                if (!requestFormHeaderObj.DistrictLocalText__c) { ValidateGeneralList.push('District ') }
                if (!requestFormHeaderObj.PostalCodeLocalText__c) { ValidateGeneralList.push('Postal Code/City ') }
                //if (!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c == 0) { ValidateGeneralList.push('Country ') }
                if (!requestFormHeaderObj.Language__c) { ValidateGeneralList.push('Language ') }
                if (!requestFormHeaderObj.MobileCountryCode__c) { ValidateGeneralList.push('Mobile Country Code ') }
                if (!requestFormHeaderObj.MobilePhone__c) { ValidateGeneralList.push('Mobile Phone ') }
                if (!requestFormHeaderObj.PhoneCountryCode__c) { ValidateGeneralList.push('Phone Country Code ') }
                if (!requestFormHeaderObj.Phone__c) { ValidateGeneralList.push('Phone ') }

                // Tab Purchasing
                if (!requestFormItemObj.Currency__c) { ValidatePurchasingList.push('Order currency ') }
                if (!requestFormItemObj.TermOfPayment__c || requestFormItemObj.TermOfPayment__c.length == 0) { ValidatePurchasingList.push('Terms of payment ') }
                if (!requestFormItemObj.Incoterms__c) { ValidatePurchasingList.push('Incoterms ') }
            }
        }
        if (ValidateGeneralList.length > 0) {
            console.log('General view' + ValidateGeneralList.toString());
            var General = '{"Key": "General view", "Values": "' + ValidateGeneralList.toString() + '"}';
            //ValidateMessageMap.set("General view", ValidateGeneralList.toString());
            var mObj = JSON.parse(General);
            ValidateMessageList.push(mObj);
            console.log('gen:' + General);
        }
        if (ValidateSalesList.length > 0) {
            console.log('Sales view');
            var Sales = '{"Key": "Sales view", "Values": "' + ValidateSalesList.toString() + '"}';
            //ValidateMessageMap.set("Sales view", ValidateSalesList.toString());
            var mObj = JSON.parse(Sales);
            ValidateMessageList.push(mObj);
            console.log('Sales:' + Sales);

        }
        if (ValidatePurchasingList.length > 0) {
            console.log('Purchasing view');
            var Purchasing = '{"Key": "Purchasing view", "Values": "' + ValidatePurchasingList.toString() + '"}';
            //ValidateMessageMap.set("Purchasing view", ValidatePurchasingList.toString());
            var mObj = JSON.parse(Purchasing);
            ValidateMessageList.push(mObj);

            console.log('Sales:' + Sales);

        }
        if (ValidateCompanyList.length > 0) {
            console.log('Company view');
            var Company = '{"Key": "Company view", "Values": "' + ValidateCompanyList.toString() + '"}';
            var mObj = JSON.parse(Company);

            //ValidateMessageMap.set("Company view", ValidateCompanyList.toString());
            ValidateMessageList.push(mObj);
        }
        console.log('HELPER V2: ' + JSON.stringify(ValidateMessageList));

        return ValidateMessageList;
    },
    saveRequestItemAndRequestHeader: function (component) {
        console.log('saveRequestItemAndRequestHeader')
        component.set('v.showLoading', true);
        var mRecordTypeName = component.get('v.recordTypeName');
        var mHeader = component.get('v.requestFormHeaderObj');
        var mItem = component.get('v.requestFormItemObj');
        if (mRecordTypeName.includes('Edit')) {
            if (component.get('v.ChangedFieldForEDITHeader')) {
                var jsonChanged = JSON.stringify(component.get('v.ChangedFieldForEDITHeader'));
                mHeader.InternalEditField__c = jsonChanged;
            }
            if (component.get('v.ChangedFieldForEDITItem')) {
                var jsonChanged = JSON.stringify(component.get('v.ChangedFieldForEDITItem'));
                mItem.InternalEditField__c = jsonChanged;
            }
        }

        var action = component.get("c.saveReqFormItemAndReqFormHeader");
        action.setParams({
            "recordIdFormItem": component.get('v.recordId'),
            "reqFormHeaderObj": mHeader,
            "reqFormItemObj": mItem
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnvale = response.getReturnValue();
                console.log('Debugresult val',returnvale)
                this.toastEvent('Success', 'Sap information saved successfully', 'success');
                console.log('Close modal',component)
                this.closeModal(component);
                // component.set('v.isModalOpen',false);
                // $A.get("e.force:closeQuickAction").fire();
                component.set('v.showLoading', false);
                location.reload();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.toastEvent('Error', errors[0].message, 'error');
                    component.set('v.showLoading', false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    closeModal: function (component) {
        component.set('v.isModalOpen', false);
        $A.get("e.force:closeQuickAction").fire();
    },
    toastEvent: function (Title, Message, Type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": Title,
            "message": Message,
            "type": Type
        });
        toastEvent.fire();
    },
})