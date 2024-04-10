({

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

            // var isExisted = false;
            // for(var existing of fieldChangedList)
            // {
            //     if(existing.Api == fieldName)
            //     {
            //         existing.Label = label;
            //         existing.Value = value;
            //         existing.Source = source;
            //         isExisted = true;
            //     }
            // }
            // if(isExisted == false)
            // {
            //     var mJson = '{"Label":"'+label+'",'; 
            //     mJson += '"Api":"'+fieldName+'",';
            //     mJson += '"Source":"'+source+'",';
            //     mJson += '"Value":"'+value+'"}';
            //     var mObj = JSON.parse(mJson);
            //     fieldChangedList.push(mObj);
            // }
            // console.log('field change: '+JSON.stringify(fieldChangedList));
            // if(level == 'Header')
            // {
            //     component.set('v.ChangedFieldForEDITHeader', fieldChangedList);
            // }
            // else if(level == 'Item')
            // {
            //     component.set('v.ChangedFieldForEDITItem', fieldChangedList);
            // }
            this.addToJsonHelper(component, fieldChangedList, label, fieldName, value, level);
    },

    addToJsonHelper: function(component, fieldChanged, label, fieldName, value, level) 
    {
        var fieldChangedList = [];
        if(level == 'Header')
        {
            fieldChangedList = component.get('v.ChangedFieldForEDITHeader');
        }
        else if(level == 'Item')
        {
            fieldChangedList = component.get('v.ChangedFieldForEDITItem');
        }
        var source = 'SAP Information';
        var isExisted = false;
        if(fieldName)
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


    DependencyHelper: function(component, event, typefunc) 
    {
        component.set('v.DisabledDistribution',true);
        component.set('v.loadedValue',false);

        var AccountGroup = component.get('v.AccountGroupValue');
        var mHeader = component.get('v.requestFormHeaderObj');
        var mItem = component.get('v.requestFormItemObj');
        var mDependencyMap = component.get('v.mDependencyMap');
        var DependencyData;
        console.log('mProductMapDependencyTOP1:'+JSON.stringify( component.get('v.mDependencyMap')));

        if(mDependencyMap)
        {
            if(mHeader.AccountGroup__c)
            {
                DependencyData = mDependencyMap[mHeader.AccountGroup__c];
                if(DependencyData)
                {
                    component.set('v.DistributionChannelList',DependencyData.mDistributionChannel);
                    component.set('v.DisabledDistribution',false);
                    console.log('P:'+mItem.InterestedProductTypeAsCustomerTOP__c);

                    if(mItem.InterestedProductTypeAsCustomerTOP__c.includes('Petroleum Products'))
                    {
                        console.log('L:'+DependencyData.mLanguageValue);
                        console.log('T:'+DependencyData.mTaxClassification);
                        console.log('C:'+DependencyData.mCurrency);
                        if(DependencyData.mLanguageValue)
                        {
                            if(mHeader.Language__c != DependencyData.mLanguageValue)
                            {
                                mHeader.Language__c = DependencyData.mLanguageValue;
                                if(component.get('v.recordTypeName').includes('Edit'))
                                {
                                    console.log('Language__c:'+DependencyData.mLanguageValue);
                                    console.log(component);
                                    console.log(component.get('v.ChangedFieldForEDITHeader'));
                                    
                                    this.addToJsonHelper(component, component.get('v.ChangedFieldForEDITHeader'), 'Language', 'Language__c', DependencyData.mLanguageValue, 'Header');
                                }
                            }
                        }
                        if(DependencyData.mTaxClassification)
                        {
                            if(mHeader.TAXClassification__c != DependencyData.mTaxClassification)
                            {
                                mHeader.TAXClassification__c = DependencyData.mTaxClassification;
                                if(component.get('v.recordTypeName').includes('Edit'))
                                {
                                    console.log('TAXClassification__c:'+DependencyData.mTaxClassification);
                                    this.addToJsonHelper(component, component.get('v.ChangedFieldForEDITHeader'), 'Tax Classification', 'TAXClassification__c', DependencyData.mTaxClassification, 'Header');
                                }
                            }
                        }
                        if(DependencyData.mCurrency)
                        {
                            if(mItem.Currency__c != DependencyData.mCurrency)
                            {
                                mItem.Currency__c = (DependencyData.mCurrency)?DependencyData.mCurrency:'';
                                if(component.get('v.recordTypeName').includes('Edit'))
                                {
                                    console.log('Currency__c:'+DependencyData.mCurrency);
                                    this.addToJsonHelper(component, component.get('v.ChangedFieldForEDITItem'), 'Order Currency', 'Currency__c', DependencyData.mCurrency, 'Item');
                                }
                            }
                        }
                        if(DependencyData.mAccountAssignmentGroup)
                        {
                            if(mItem.AccountAssignmentGroup__c != DependencyData.mAccountAssignmentGroup)
                            {
                                mItem.AccountAssignmentGroup__c = (DependencyData.mAccountAssignmentGroup)?DependencyData.mAccountAssignmentGroup:'';
                                if(component.get('v.recordTypeName').includes('Edit'))
                                {
                                    console.log('AccountAssignmentGroup__c:'+DependencyData.mAccountAssignmentGroup);
                                    this.addToJsonHelper(component, component.get('v.ChangedFieldForEDITItem'), 'Account Assignment Group', 'AccountAssignmentGroup__c', DependencyData.mAccountAssignmentGroup, 'Item');
                                }
                            }
                        }
                        if(DependencyData.mPaymentGuaranteeProcedureValueMap && mItem.ChangeCreditCreditCondition__c)
                        {
                            if(DependencyData.mPaymentGuaranteeProcedureValueMap[mItem.ChangeCreditCreditCondition__c])
                            {
                                mItem.PaymentGuaranteeProcedure__c = DependencyData.mPaymentGuaranteeProcedureValueMap[mItem.ChangeCreditCreditCondition__c];
                                if(component.get('v.recordTypeName').includes('Edit'))
                                {
                                    console.log('PaymentGuaranteeProcedure__c:'+DependencyData.mPaymentGuaranteeProcedureValueMap[mItem.ChangeCreditCreditCondition__c]);
                                    this.addToJsonHelper(component, component.get('v.ChangedFieldForEDITItem'), 'Payment Guarantee Procedure', 'PaymentGuaranteeProcedure__c', DependencyData.mPaymentGuaranteeProcedureValueMap[mItem.ChangeCreditCreditCondition__c], 'Item');
                                }
                            }
                        }
                        component.set('v.requestFormHeaderObj'+mHeader);
                        component.set('v.requestFormItemObj'+mItem);
                        console.log('UH1:'+component.get('v.requestFormHeaderObj').Language__c);
                        console.log('UI1:'+component.get('v.requestFormItemObj').Currency__c);

                    }
                }
            }
            else
            {
                component.set('v.DistributionChannelList', component.get('v.AllDistributionChannelList'));
                component.set('v.DisabledDistribution',true);
            }
        }
        else
        {
            component.set('v.DistributionChannelList', component.get('v.AllDistributionChannelList'));
        }
        console.log('DistributionChannelList'+JSON.stringify( component.get('v.DistributionChannelList')));
        component.set('v.loadedValue',true);

    }
    /*getDefaultData: function(component){
        component.set('v.showLoading',true);

        var action = component.get('c.getSAPInfoData');
        action.setParams({
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state: '+state);
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                if(result)
                {
                    console.log('result: '+result);
                    component.set('v.recordTypeNameCustomer',result.mRecordTypeName.includes('Customer'));
                    component.set('v.requestFormItemObj',result.mRequestItem);
                    component.set('v.requestFormHeaderObj',result.mRequestHeader);    
                    component.set('v.recordIdFormHeader',result.mHeaderId);

                    //PickList Options
                    component.set('v.PriceGroupList',result.mDefaultPickList.mPriceGroup);
                    component.set('v.PaymentGuaranteeProcedureList',result.mDefaultPickList.mPaymentGuaranteeProcedure);
                    component.set('v.PaymentTermList',result.mDefaultPickList.mPaymentTerm);
                    component.set('v.IncotermsList',result.mDefaultPickList.mIncoterms);
                    component.set('v.AccountAssignmentGroupList',result.mDefaultPickList.mAccountAssignmentGroup);
                    component.set('v.taxClassificationList',result.mDefaultPickList.mTaxClassification);
                    component.set('v.currencyList',result.mDefaultPickList.mCurrency);


                }

                component.set('v.showLoading',false);

            }
        });
        $A.enqueueAction(action);
    },*/
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
                    this.getAllPicklist(component);
                    //this.getRequired(component);
                    this.getCustomerSalesTab(component);
                }
                // recordType includes Supplier
                else{
                    this.getRequired(component);
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
    },
    
    getRequired: function (component) {
        var recordId = component.get('v.recordId');
        var action = component.get("c.getRequiredHeaderTOP");
        action.setParams({
            "recordIdFormItem": recordId
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                // set fields required requestFormHeaderObj
                component.set('v.requestFormHeaderObj',returnValue);
            }
        });
        $A.enqueueAction(action);
    },*/
    /*checkRequiredFields: function(component){
        var ValidateMessageList = [];
        var requestFormHeaderObj = component.get('v.requestFormHeaderObj');
        var requestFormItemObj = component.get('v.requestFormItemObj');
        var recordTypeNameCustomer = component.get('v.recordTypeNameCustomer');
        
        if(recordTypeNameCustomer){
            // Tab General
            if(!requestFormHeaderObj.CustomerNameLocal1__c){ ValidateMessageList.push( 'Name* ')}
            if(!requestFormHeaderObj.SupplierSearchTermLocal__c){ ValidateMessageList.push( 'Search Term 1* ')}
            if(!requestFormHeaderObj.StreetLocal__c){ ValidateMessageList.push( 'Street ')}
            if(!requestFormHeaderObj.DistrictLocal__c || requestFormHeaderObj.DistrictLocal__c.length == 0){ ValidateMessageList.push( 'District* ')}
            if(!requestFormHeaderObj.PostalCodeLocalText__c){ ValidateMessageList.push( 'Postal Code/City* ')}
            if(!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c == 0){ ValidateMessageList.push( 'Country* ')}
            if(!requestFormHeaderObj.Language__c){ ValidateMessageList.push( 'Language* ')}
            
            // Tab Sales (Req Item)
            if(!requestFormItemObj.Currency__c){ ValidateMessageList.push( 'Currency* ')}
            if(!requestFormItemObj.TaxClassification__c){ ValidateMessageList.push( 'Tax Classification* ')}
            if(!requestFormItemObj.AccountAssignmentGroup__c){ ValidateMessageList.push( 'Account Assignment Group* ')}
            if(!requestFormItemObj.PaymentTerm__c){ ValidateMessageList.push( 'Payment Terms* ')}
            if(!requestFormItemObj.PaymentGuaranteeProcedure__c){ ValidateMessageList.push( 'Payment Guarantee Procedure* ')}

        }else if(!recordTypeNameCustomer){
            // Tab General
            if(!requestFormHeaderObj.AccountGroup__c){ ValidateMessageList.push( 'Account Group* ')}
            if(!requestFormHeaderObj.TypeOfBusinessBranch__c){ ValidateMessageList.push( 'Type Bussiness (Branch)* ')}
            if(!requestFormHeaderObj.TaxCode1__c){ ValidateMessageList.push( 'TAX Number* ')}
            if(!requestFormHeaderObj.CustomerNameLocal1__c){ ValidateMessageList.push( 'Name* ')}
            if(!requestFormHeaderObj.SupplierSearchTermLocal__c){ ValidateMessageList.push( 'Search Term 1* ')}
            if(!requestFormHeaderObj.StreetLocal__c){ ValidateMessageList.push( 'Street ')}
            if(!requestFormHeaderObj.DistrictLocal__c || requestFormHeaderObj.DistrictLocal__c.length == 0){ ValidateMessageList.push( 'District* ')}
            if(!requestFormHeaderObj.PostalCodeLocalText__c){ ValidateMessageList.push( 'Postal Code/City* ')}
            if(!requestFormHeaderObj.Country__c || requestFormHeaderObj.Country__c == 0){ ValidateMessageList.push( 'Country* ')}
            if(!requestFormHeaderObj.Language__c){ ValidateMessageList.push( 'Language* ')}
            // Tab Purchasing
            if(!requestFormHeaderObj.Ordercurrency__c){ ValidateMessageList.push( 'Order currency* ')}
            if(!requestFormHeaderObj.Incoterms2Port__c){ ValidateMessageList.push( 'Terms of payment* ')}
        }
        return ValidateMessageList;
    },
    saveRequestHeader: function (component) {
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
    getAllDropdown : function(component){
        this.CurrencyList(component);
        this.TaxClassificationList(component);
        this.AccountAssignmentGroupList(component);
        this.IncotermsList(component);
        this.PaymentTermList(component);
        this.PaymentGuaranteeProcedureList(component);
        this.PriceGroupList(component);
    },
    CurrencyList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"Currency__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.currencyList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    TaxClassificationList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"TaxClassification__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.taxClassificationList',result);
                
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
                component.set('v.accountAssignmentGroupList',result);
                
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
    PriceGroupList : function(component) {
        var action = component.get('c.pickListDropdownModel');
        action.setParams({"obj":"CTRRequestFormItem__c","str":"PriceGroup__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.PriceGroupList',result);
                
            }
        });
        $A.enqueueAction(action);
    },
    getAllPicklist: function(component) {
        var action = component.get('c.getRequestItemPickList');
        //action.setParams({"obj":"CTRRequestFormItem__c","str":"PriceGroup__c"});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state =="SUCCESS"){
                var result = response.getReturnValue();
                if(result)
                {
                    component.set('v.PriceGroupList',result.mPriceGroup);
                    component.set('v.PaymentGuaranteeProcedureList',result.mPaymentGuaranteeProcedure);
                    component.set('v.PaymentTermList',result.mPaymentTerm);
                    component.set('v.IncotermsList',result.mIncoterms);
                    component.set('v.accountAssignmentGroupList',result.mAccountAssignmentGroup);
                    component.set('v.taxClassificationList',result.mTaxClassification);
                    component.set('v.currencyList',result.mCurrency);
                }
                
            }
        });
        $A.enqueueAction(action);
    }
    */
})