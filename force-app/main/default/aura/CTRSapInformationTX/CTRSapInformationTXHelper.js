({
    getDefaultData: function(component){
        component.set('v.showLoading',true);

        var action = component.get('c.getSAPInfoData');
        action.setParams({
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                if(result)
                {
                    component.set('v.recordTypeNameCustomer',result.mRecordTypeName.includes('Customer'));
                    component.set('v.requestFormItemObj',result.mRequestItem);
                    component.set('v.requestFormHeaderObj',result.mRequestHeader);    
                    component.set('v.recordIdFormHeader',result.mHeaderId);

                    //PickList Options
                    /*component.set('v.PriceGroupList',result.mDefaultPickList.mPriceGroup);
                    component.set('v.PaymentGuaranteeProcedureList',result.mDefaultPickList.mPaymentGuaranteeProcedure);
                    component.set('v.PaymentTermList',result.mDefaultPickList.mPaymentTerm);
                    component.set('v.IncotermsList',result.mDefaultPickList.mIncoterms);
                    component.set('v.accountAssignmentGroupList',result.mDefaultPickList.mAccountAssignmentGroup);
                    component.set('v.taxClassificationList',result.mDefaultPickList.mTaxClassification);
                    component.set('v.currencyList',result.mDefaultPickList.mCurrency);*/
                    
                    component.set('v.CountryCodePhoneList',result.mDefaultPickList.mCountryCodePhone);


                    component.set('v.AccountAssignmentGroupList',result.mDefaultPickList.mAccountAssignmentGroup);
                    component.set('v.PaymentGuaranteeProcedureList',result.mDefaultPickList.mPaymentGuaranteeProcedure);
                    component.set('v.CreditControlAreaList',result.mDefaultPickList.mCreditControlArea);
                    component.set('v.PartialDeliveriesperitemList',result.mDefaultPickList.mPartialDeliveriesperitem);
                    component.set('v.SalesGroupList',result.mDefaultPickList.mSalesGroup);
                    component.set('v.RiskCategoryList',result.mDefaultPickList.mRiskCategory);
                    component.set('v.PaymentTermList',result.mDefaultPickList.mPaymentTerm);
                    component.set('v.Incoterms2List',result.mDefaultPickList.mIncoterms2);
                    component.set('v.IncotermsList',result.mDefaultPickList.mIncoterms);
                    component.set('v.DeliveryPlantList',result.mDefaultPickList.mDeliveryPlant);
                    component.set('v.ShippingConditionsList',result.mDefaultPickList.mShippingConditions);
                    component.set('v.DeliveryPriorityList',result.mDefaultPickList.mDeliveryPriority);
                    component.set('v.CurrencyList',result.mDefaultPickList.mCurrency);
                    component.set('v.SalesOfficeList',result.mDefaultPickList.mSalesOffice);
                    component.set('v.SalesDistrictList',result.mDefaultPickList.mSalesDistrict);

                }

                /*component.set('v.recordTypeNameCustomer',result.includes('Customer'));
                // recordType includes Customer
                if(result.includes('Customer') == true){
                    console.log('getting picklist');
                    this.getAllPicklist(component);
                    this.getRequiredHeaderTX(component);

                    this.getCustomerSalesTab(component);

                }
                // recordType includes Supplier
                else{
                    this.getRequiredHeaderTX(component);
                }   */
                component.set('v.showLoading',false);

            }
        });
        $A.enqueueAction(action);
    },
    addFieldChangeToJson: function(component, event, level) 
    {
        var source = 'SAP Information';
        var label = event.getSource().get('v.id');
        var fieldName = event.getSource().get('v.fieldName');
        var value = String(event.getSource().get('v.value'));
        var fieldChangedList = (level == 'Header')?component.get('v.ChangedFieldForEDITHeader'):component.get('v.ChangedFieldForEDITItem');
        if(value)
                {
                    value.replace("[", "");
                    value.replace("]", "");
                }
        console.log("label:"+label);
        console.log("fieldName:"+fieldName);
        console.log("value:"+value);
        if(!label)
        {
            label = event.getSource().get('v.label');
        }
        if(!fieldName)
        {
            fieldName = event.getSource().get('v.name');
        }
        
        console.log("label2:"+label);
        console.log("fieldName2:"+fieldName);

            var isExisted = false;
            console.log("fieldChangedList:"+fieldChangedList.length);
        if(fieldName)
        {
            if(fieldChangedList.length > 0)
        {
            for(var existing of fieldChangedList)
            {
                if(existing.Api == fieldName)
                {
                    existing.Label = label;
                    existing.Value = value;
                    existing.User = component.get('v.currentUserName');
                    existing.Source = source;
                    isExisted = true;
                }
            }
        }
            
            if(isExisted == false)
            {
                var mJson = '{"Label":"'+label+'",'; 
                mJson += '"Api":"'+fieldName+'",';
                mJson += '"Source":"'+source+'",';
                mJson += '"User":"'+component.get('v.currentUserName')+'",';
                mJson += '"Value":"'+value+'"}';
                var mObj = JSON.parse(mJson);
                fieldChangedList.push(mObj);
            }
            console.log('field change: '+JSON.stringify(fieldChangedList));
            if(level == 'Header')
            {
                component.set('v.ChangedFieldForEDITHeader', fieldChangedList);
            }
            else if(level == 'Item')
            {
                component.set('v.ChangedFieldForEDITItem', fieldChangedList);
            }
        }
        
    },
    /*getRecordTypeName: function(component){
        var action = component.get('c.getRecordTypeName');
        action.setParams({
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.recordTypeNameCustomer',result.includes('Customer'));
                // recordType includes Customer
                if(result.includes('Customer') == true){
                    console.log('getting picklist');
                    this.getAllPicklist(component);
                    this.getRequiredHeaderTX(component);

                    this.getCustomerSalesTab(component);

                }
                // recordType includes Supplier
                else{
                    this.getRequiredHeaderTX(component);
                }   
            }
        });
        $A.enqueueAction(action);
    },
    getCustomerSalesTab: function(component){
        var action = component.get('c.getCustomerSalesTab');
        action.setParams({
            "recordIdFormItem": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.requestFormItemObj',result);
            }
        });
        $A.enqueueAction(action);
    },
    getRequiredHeaderTX: function (component) {
        var recordId = component.get('v.recordId');
        var action = component.get("c.getRequiredHeaderTX");
        action.setParams({
            "recordIdFormItem": recordId
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                component.set('v.requestFormHeaderObj',returnValue);                
            }
        });
        $A.enqueueAction(action);
    },
    getIdFormHeader: function (component) {
        var recordId = component.get('v.recordId');
        var action = component.get("c.getIdFormHeader");
        action.setParams({
            "recordIdFormItem": recordId
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                component.set('v.recordIdFormHeader',returnValue);
            }
        });
        $A.enqueueAction(action);
    },*/
    /*checkRequiredFields: function(component){
        //Check validate fields 
        var ValidateMessageList = [];
        // Get Object
        var requestFormHeaderObj = component.get('v.requestFormHeaderObj');
        var requestFormItemObj = component.get('v.requestFormItemObj');
        // Get RecordType Name
        var recordTypeNameCustomer = component.get('v.recordTypeNameCustomer');
        // Check RecordType contains Customer
        if(recordTypeNameCustomer){
            if(!requestFormHeaderObj.CustomerNameLocal1__c){ ValidateMessageList.push('Name ')}
            if(!requestFormHeaderObj.CustomerNameEN1__c){ ValidateMessageList.push('Name(Eng) ')}
            if(!requestFormHeaderObj.CustomerSearchTermLocal__c){ ValidateMessageList.push('Search Term 1 ')}
            if(!requestFormHeaderObj.StreetLocal__c){ ValidateMessageList.push('Street/House number')}
            if(!requestFormHeaderObj.DistrictLocal__c || requestFormHeaderObj.DistrictLocal__c.length == 0){ ValidateMessageList.push('District ')}
            if(!requestFormHeaderObj.PostalCodeLocalText__c){ ValidateMessageList.push('Postal Code/City ')}
            if(!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c.length == 0){ ValidateMessageList.push('Country ')}
            if(!requestFormHeaderObj.Phone__c){ ValidateMessageList.push('Phone ')}
            if(!requestFormHeaderObj.SalesOrganization__c){ ValidateMessageList.push('Sales Organization ')}
            if(!requestFormHeaderObj.AccountGroup__c){ ValidateMessageList.push('Account Group ')}
            if(!requestFormHeaderObj.RegionSAP__c){ ValidateMessageList.push('Region ')}
            if(!requestFormHeaderObj.Division__c){ ValidateMessageList.push('Division ')}
            if(!requestFormHeaderObj.Industry__c){ ValidateMessageList.push('Industry ')}
            if(!requestFormHeaderObj.CustomerType__c){ ValidateMessageList.push('Customer Type ')}
            if(!requestFormHeaderObj.CustomerGroup__c){ ValidateMessageList.push('Customer Group ')}
            if(!requestFormHeaderObj.TypeOfBusinessBranch__c){ ValidateMessageList.push('Type Of Business (Branch) ')}
            if(!requestFormHeaderObj.TaxCode1__c){ ValidateMessageList.push('TAX Number ')}
            if(!requestFormHeaderObj.Application__c){ ValidateMessageList.push('Application ')}
            if(!requestFormHeaderObj.InterGroup__c){ ValidateMessageList.push('InterGroup ')}
            if(!requestFormHeaderObj.ReconAccount__c){ ValidateMessageList.push('Recon. Account ')}
            if(!requestFormHeaderObj.SortKey__c){ ValidateMessageList.push('Sort Key ')}
            if(!requestFormHeaderObj.CashManagementGroup__c){ ValidateMessageList.push('Cash Mgmnt Group ')}
            if(!requestFormHeaderObj.Authorization__c){ ValidateMessageList.push('Authorization ')}
            if(!requestFormHeaderObj.PaymentHistoryRecord__c){ ValidateMessageList.push('Payment History Record ')}

            // sales tab Item 
            //if(!requestFormItemObj.SalesDistrict__c){ ValidateMessageList.push('Sales District ')}
            //if(!requestFormItemObj.SalesOffice__c){ ValidateMessageList.push('Sales Office ')}
            //if(!requestFormItemObj.SalesGroup__c){ ValidateMessageList.push('Sales Group ')}
            if(!requestFormItemObj.Currency__c){ ValidateMessageList.push('Currency ')}
            if(!requestFormItemObj.OrderProbability__c){ ValidateMessageList.push('Order probab. ')}
ฃ            if(!requestFormItemObj.Custpiceproc__c){ ValidateMessageList.push('Cust.pice.proc ')}
            if(!requestFormItemObj.CustStatGroup__c){ ValidateMessageList.push('Cust Stats.Grp ')}
            if(!requestFormItemObj.OrderCombination__c){ ValidateMessageList.push('Order Combination ')}
            if(!requestFormItemObj.DeliveryPriority__c){ ValidateMessageList.push('Delivery Priority ')}
            if(!requestFormItemObj.Shipping_Conditions__c){ ValidateMessageList.push('Shipping Conditions ')}
            if(!requestFormItemObj.DeliveryPlant__c){ ValidateMessageList.push('Delivery Plant ')}
            if(!requestFormItemObj.TransportationZone__c){ ValidateMessageList.push('Transportation Zone ')}
            if(!requestFormItemObj.PartialDeliveriesperitem__c){ ValidateMessageList.push('Partail delivery per item ')}
            if(!requestFormItemObj.UnderdeliveryTolerance__c){ ValidateMessageList.push('Underdel tolerance ')}
            if(!requestFormItemObj.OverdeliveryTolerance__c){ ValidateMessageList.push('Overdeliv. tolerance ')}
            if(!requestFormItemObj.Rebate__c){ ValidateMessageList.push('Rebate ')}
            if(!requestFormItemObj.IsPriceDetermin__c){ ValidateMessageList.push('Price determin ')}
            if(!requestFormItemObj.Incoterms__c){ ValidateMessageList.push('Incoterms ')}
            if(!requestFormItemObj.Incoterms2__c){ ValidateMessageList.push('Incoterms2 ')}
            if(!requestFormItemObj.CreditControlArea__c){ ValidateMessageList.push('Credit Control Area ')}
            if(!requestFormItemObj.PaymentTerm__c){ ValidateMessageList.push('PaymentTerm ')}
            if(!requestFormItemObj.PaymentGuaranteeProcedure__c){ ValidateMessageList.push('Payment Guarantee Procedure ')}
            if(!requestFormItemObj.AccountAssignmentGroup__c){ ValidateMessageList.push('Account Assignment Group ')}
            if(!requestFormItemObj.RiskCategory__c){ ValidateMessageList.push('Risk Category  ')}
             
            return ValidateMessageList;
        }
        // Check RecordType contains Supplier
        else if(!recordTypeNameCustomer){
            if(!requestFormHeaderObj.CustomerNameLocal1__c){ ValidateMessageList.push('Name ')}
            if(!requestFormHeaderObj.CustomerNameEN1__c){ ValidateMessageList.push('Name(Eng) ')}
            if(!requestFormHeaderObj.SupplierSearchTermLocal__c){ ValidateMessageList.push('Search Term 1 ')}
            if(!requestFormHeaderObj.StreetLocal__c){ ValidateMessageList.push('Street/House number ')}
            if(!requestFormHeaderObj.DistrictLocal__c || requestFormHeaderObj.DistrictLocal__c.length == 0){ ValidateMessageList.push('District ')}
            if(!requestFormHeaderObj.PostalCodeLocalText__c){ ValidateMessageList.push('Postal Code/City')}
            if(!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c.length == 0){ ValidateMessageList.push('Country ')}
            if(!requestFormHeaderObj.Phone__c){ ValidateMessageList.push('Phone ')}
            if(!requestFormHeaderObj.AccountGroup__c){ ValidateMessageList.push('Account Group ')}
            if(!requestFormHeaderObj.TaxCode1__c){ ValidateMessageList.push('TAX Number ')}
            if(!requestFormHeaderObj.GroupKeyAccountKeyofBank__c){ ValidateMessageList.push('Group Key(Account Key of Bank) ')}
            if(!requestFormHeaderObj.VATRegno__c){ ValidateMessageList.push('VAT Reg no. ')}
            if(!requestFormHeaderObj.PaymentTerm__c){ ValidateMessageList.push('Payment Term ')}
            if(!requestFormHeaderObj.PaymentMethod__c){ ValidateMessageList.push('Payment Method ')}
            if(!requestFormHeaderObj.AccigClerk__c){ ValidateMessageList.push('Acctg Clerk ')}
            if(!requestFormHeaderObj.Ordercurrency__c){ ValidateMessageList.push('Order currency ')}
            if(!requestFormHeaderObj.ReconAccount__c){ ValidateMessageList.push('Recon. Account ')}
            if(!requestFormHeaderObj.SortKey__c){ ValidateMessageList.push('Sort Key ')}
            if(!requestFormHeaderObj.CashManagementGroup__c){ ValidateMessageList.push('Cash Mgmnt Group ')}
            
            return ValidateMessageList;
        }
    },*/
    saveRequestItemAndRequestHeader: function (component) {
        component.set('v.showLoading',true);
        var action = component.get("c.saveReqFormItemAndReqFormHeader");
        action.setParams({
            "recordIdFormItem": component.get('v.recordId'),
            "reqFormHeaderObj": component.get('v.requestFormHeaderObj'),
            "reqFormItemObj": component.get('v.requestFormItemObj')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnvale = response.getReturnValue();
                this.toastEvent('Success','Sap information saved successfully', 'success');
                component.set('v.showLoading',false);
                this.closeModal(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.toastEvent('Error',errors[0].message, 'error');
                    component.set('v.showLoading',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    closeModal:function(component){
        component.set('v.isModalOpen',false);
        $A.get("e.force:closeQuickAction").fire();
    },
    toastEvent : function(Title, Message, Type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": Title,
            "message": Message,
            "type": Type
        });
        toastEvent.fire();
    },
    /*getAllDropdown : function(component){
        this.SalesDistrictList(component);
        this.SalesOfficeList(component);
        this.CurrencyList(component);
        this.DeliveryPriorityList(component);
        this.ShippingConditionsList(component);
        this.DeliveryPlantList(component);
        this.IncotermsList(component);
        this.Incoterms2List(component);
        this.PaymentTermList(component);
        this.RiskCategoryList(component);

        this.SalesGroupList(component);
        this.PartialDeliveriesperitemList(component);
        this.CreditControlAreaList(component);
        this.PaymentGuaranteeProcedureList(component);
        this.AccountAssignmentGroupList(component);
    },
    SalesDistrictList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"SalesDistrict__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.SalesDistrictList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    SalesOfficeList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"SalesOffice__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.SalesOfficeList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    CurrencyList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"Currency__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.CurrencyList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    DeliveryPriorityList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"DeliveryPriority__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.DeliveryPriorityList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    ShippingConditionsList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"Shipping_Conditions__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.ShippingConditionsList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    DeliveryPlantList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"DeliveryPlant__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.DeliveryPlantList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    IncotermsList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"Incoterms__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.IncotermsList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    Incoterms2List : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"Incoterms2__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.Incoterms2List',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    PaymentTermList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"PaymentTerm__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.PaymentTermList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    RiskCategoryList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"RiskCategory__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.RiskCategoryList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    SalesGroupList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"SalesGroup__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.SalesGroupList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    PartialDeliveriesperitemList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"PartialDeliveriesperitem__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.PartialDeliveriesperitemList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    CreditControlAreaList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"CreditControlArea__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.CreditControlAreaList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    PaymentGuaranteeProcedureList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"PaymentGuaranteeProcedure__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.PaymentGuaranteeProcedureList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    AccountAssignmentGroupList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"AccountAssignmentGroup__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.AccountAssignmentGroupList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    getAllPicklist: function(component) {
        component.set('v.showLoading',true);
        console.log('start get picklist');

        var action = component.get('c.getRequestItemPickList');
        //action.setParams({"obj":"CTRRequestFormItem__c","str":"PriceGroup__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('result state picklist'+state);

            if(state =="SUCCESS"){
                
                var result = response.getReturnValue();
                console.log('result get picklist'+result);

                    component.set('v.AccountAssignmentGroupList',result.mAccountAssignmentGroup);
                    component.set('v.PaymentGuaranteeProcedureList',result.mPaymentGuaranteeProcedure);
                    component.set('v.CreditControlAreaList',result.mCreditControlArea);
                    component.set('v.PartialDeliveriesperitemList',result.mPartialDeliveriesperitem);
                    component.set('v.SalesGroupList',result.mSalesGroup);
                    component.set('v.RiskCategoryList',result.mRiskCategory);
                    component.set('v.PaymentTermList',result.mPaymentTerm);
                    component.set('v.Incoterms2List',result.mIncoterms2);
                    component.set('v.IncotermsList',result.mIncoterms);
                    component.set('v.DeliveryPlantList',result.mDeliveryPlant);
                    component.set('v.ShippingConditionsList',result.mShippingConditions);
                    component.set('v.DeliveryPriorityList',result.mDeliveryPriority);
                    component.set('v.CurrencyList',result.mCurrency);
                    component.set('v.SalesOfficeList',result.mSalesOffice);
                    component.set('v.SalesDistrictList',result.mSalesDistrict);

                
                
            }
            component.set('v.showLoading',false);
        });
        $A.enqueueAction(action);
    }*/
})