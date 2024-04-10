({
    retrieveAccount: function(component) {
        component.set("v.showLoading", true);
        var action = component.get('c.getAccount');
            action.setParams({ 
                'accountId': component.get('v.customerId')
            });
            action.setCallback(this, function (res) {
                var state = res.getState();
                if (state === 'SUCCESS') {
                    var result = res.getReturnValue();
                    console.log('result -----', result);
                    if(result) {
                        component.set('v.accountObject', result);
                    } else {
                        this.showToast('Couldn\'t get Account detail', false);
                    }
                    component.set("v.showLoading", false);
                }
            });
            $A.enqueueAction(action);
    },

    getPicklistValue: function(component) {
        console.log('[getPicklistValue] -----');
        const comUtility = component.find('comUtility');
        comUtility.getPicklistValues('CTRRequestFormItem__c.InterestedProductTypeAsCustomerTX__c', component.get('v.recordTypeId'));
    },

    getCurrentUser: function(component) {
        component.set('v.ownerId', $A.get("$SObjectType.CurrentUser.Id"));
    },

    saveRequest: function(component) {
        debugger
        console.log('[saveRequest] -----');
        component.set('v.showLoading', true);
        component.set('v.displayWarning', false);
        const _THIS_ = this;
        return new Promise($A.getCallback(function(resolve, reject) {
            if (_THIS_.validateFormData(component)) {
                const formData = _THIS_.getFormData(component);
                const action = component.get("c.saveRequest");
                action.setParams({
                    'requestHeader': formData.CTRRequestFormHeader__c,
                    'requestItem': formData.CTRRequestFormItem__c,
                    'shippingCountries': formData.CTRShippingCountry__c,
                    'bu': component.get('v.bu'),
                    'isSupplier': component.get('v.isSupplier')
                });
                action.setCallback(this, function (response) {
                    const state = response.getState();
                    if (state === 'SUCCESS') {
                        const result = response.getReturnValue();
                        if(!$A.util.isEmpty(result.recordId)) {
                            _THIS_.showToast('Record has been save successfully.', true);
                            if(component.get('v.isEdit')) _THIS_.closeFocusedTab(component);
                        } else {
                            if(component.get('v.isEdit')) {
                                _THIS_.showToast(result.errorMessage, false);
                                component.set('v.displayWarning', true);
                                component.set('v.warningMessage', result.errorMessage);
                            }
                        }
                        resolve(result);
                    } else if (state === 'ERROR') {
                        const errors = response.getError();
                        if (errors && errors[0] && errors[0].message) {
                            _THIS_.showToast(errors[0].message, false);
                            console.log("Error message: " + errors[0].message);
                        }
                        reject(errors);
                    }
                    component.set('v.showLoading', false);
                });
                $A.enqueueAction(action);
            } else {
                console.log('validateFormData failed');
                _THIS_.showToast('Please complete all required fields.', false);
                component.set('v.showLoading', false);
                reject();
            }
        }));
    },

    getFormData: function(component) {
        console.log('[getFormData] -----');
        debugger
        var ownerId = component.find('editFormItemOwner').get('v.selectedRecordId');
        var bu = component.get('v.bu');
        var interestProductField = component.get('v.interestProductField');
        var requestItem = {};
        var requestHeader = {};
        if(component.get('v.isEdit')) {
            requestItem['Id'] = component.get('v.recordId');
            requestHeader['Id'] = component.get('v.headerRecordId');
        }
        
        requestItem[interestProductField] = component.get('v.selectedProductType');
        requestHeader[interestProductField] = requestItem[interestProductField];

        requestItem['OwnerId'] = ownerId;
        requestItem['RecordTypeId'] = component.get('v.recordTypeId');
        if(!$A.util.isEmpty(component.get('v.selectedDistributionChannel'))) { requestItem['DistributionChannel__c'] = component.get('v.selectedDistributionChannel'); }
        component.find("editFormItemField").forEach(function(cmp) {
            console.log('[getFormData] ' + cmp.get('v.fieldName') + ' -----', cmp.get('v.value'));
            if(cmp.get('v.value')){
                requestItem[cmp.get('v.fieldName')] = cmp.get('v.value')
            }else{
                if(!requestItem[cmp.get('v.fieldName')] ){
                    requestItem[cmp.get('v.fieldName')] = null
                }
            }
        });
        if(!$A.util.isEmpty(requestItem['SalesOrganizationTX__c'])) { requestItem['SalesOrganization__c'] = requestItem['SalesOrganizationTX__c']; }
        if(!$A.util.isEmpty(requestItem['PurchasingOrganizationTX__c'])) { requestItem['PurchasingOrganization__c'] = requestItem['PurchasingOrganizationTX__c']; }
        if(component.get('v.isSupplier') && !$A.util.isEmpty(component.find('editFormItemPayment').get('v.selectedRecordId'))) { requestItem['PaymentTerm__c'] = component.find('editFormItemPayment').get('v.selectedRecordId'); }
        if(!$A.util.isEmpty(component.get('v.selectedPaymentMethod'))) { requestItem['PaymentMethod__c'] = component.get('v.selectedPaymentMethod'); }

        requestHeader['OwnerId'] = ownerId;
        requestHeader['Customer__c'] = requestItem['Customer__c'];
        if(!$A.util.isEmpty(requestItem['CustomerProductIdentification__c'])) { requestHeader['CustomerProductIdentification__c'] = requestItem['CustomerProductIdentification__c']; }
        
        if(!$A.util.isEmpty(requestItem['InterestedProductTypeAsCustomerTX__c'])) { requestHeader['InterestedProductTypeAsCustomerTX__c'] = requestItem['InterestedProductTypeAsCustomerTX__c']; }
        if(!$A.util.isEmpty(requestItem['InterestedProductTypeAsSupplierTX__c'])) { requestHeader['InterestedProductTypeAsSupplierTX__c'] = requestItem['InterestedProductTypeAsSupplierTX__c']; }


        // requestHeader['CreditControlArea__c'] = requestItem['CreditControlArea__c'];
        // if(!$A.util.isEmpty(requestItem['Incoterms__c'])) { requestHeader['Incoterms__c'] = requestItem['Incoterms__c']; }
        // if(!$A.util.isEmpty(requestItem['PaymentGuaranteeProcedure__c'])) { requestHeader['PaymentGuaranteeProcedure__c'] = requestItem['PaymentGuaranteeProcedure__c']; }
        // if(!$A.util.isEmpty(requestItem['Incoterms2__c'])) { requestHeader['Incoterms2__c'] = requestItem['Incoterms2__c']; }
        if(!$A.util.isEmpty(requestItem['AccountAssignmentGroup__c'])) { requestHeader['AccountAssignmentGroup__c'] = requestItem['AccountAssignmentGroup__c']; }
        if(!$A.util.isEmpty(requestItem['SupplierProductIdentification__c'])) { requestHeader['SupplierProductIdentification__c'] = requestItem['SupplierProductIdentification__c']; }
        // if(!$A.util.isEmpty(requestItem['SalesOrganization__c'])) { requestHeader['SalesOrganization__c'] = requestItem['SalesOrganization__c']; }
        // if(!$A.util.isEmpty(requestItem['PurchasingOrganization__c'])) { requestHeader['PurchasingOrganization__c'] = requestItem['PurchasingOrganization__c']; }
        // component.find("editFormHeaderField").forEach(function(cmp) {
        //     console.log('[getFormData] ' + cmp.get('v.fieldName') + ' -----', cmp.get('v.value'));
        //     requestHeader[cmp.get('v.fieldName')] = (!$A.util.isEmpty(cmp.get('v.value')) ? cmp.get('v.value') : null);
        // });

        console.log('[getFormData] requestHeader -----', requestHeader);
        console.log('[getFormData] requestItem -----', requestItem);
        console.log('[getFormData] CTRShippingCountry__c -----', component.get('v.shippingList'));
        return {
            CTRRequestFormHeader__c: requestHeader,
            CTRRequestFormItem__c: requestItem,
            CTRShippingCountry__c: component.get('v.shippingList'),
        }
    },

    validateFormData: function(component) {
        debugger
        console.log('[validateFormData] -----');
        let allValid = true;
        if($A.util.isEmpty(component.find('editFormItemOwner').get('v.selectedRecordId'))) {
            allValid = false;
        }
        console.log('[validateFormData] ---1--'+allValid);
        if(component.get('v.isSupplier') && $A.util.isEmpty(component.find('editFormItemPayment').get('v.selectedRecordId'))) {
            allValid = false;
        }
        console.log('[validateFormData] --2---'+allValid);
        console.log('[validateFormData] --component.get(v.isSupplie)---'+component.get('v.isSupplier'));
        component.find("editFormItemField").forEach(function(cmp) {
            if(component.get('v.isSupplier'))
            {
                
                if(!$A.util.isEmpty(cmp.get('v.fieldName')) && cmp.get('v.required') && $A.util.isEmpty(cmp.get('v.value'))) {
                    if(!cmp.get('v.fieldName').includes('Customer') && (cmp.get('v.fieldName') != 'InterGroup__c' && cmp.get('v.fieldName') != 'SubIndustry__c' && cmp.get('v.fieldName') != 'Industry__c'))
                    {
                        console.log('[validateFormData] editFormItemField -----', cmp.get('v.fieldName'));
                        allValid = allValid && false;
                        console.log('[validateFormData] --3---'+allValid);
                    }
                }
                
            }
            else
            {
                if(!$A.util.isEmpty(cmp.get('v.fieldName')) && cmp.get('v.required') && $A.util.isEmpty(cmp.get('v.value'))) {
                    console.log('[validateFormData] editFormItemField -----', cmp.get('v.fieldName'));
                    allValid = allValid && false;
                    console.log('[validateFormData] --cusss---'+allValid);
                }
            }
            
        });
        console.log('[validateFormData] --4---'+allValid);
        // component.find("editFormHeaderField").forEach(function(cmp) {
        //     if(!$A.util.isEmpty(cmp.get('v.fieldName')) && cmp.get('v.required') && $A.util.isEmpty(cmp.get('v.value'))) {
        //         console.log('[validateFormData] editFormHeaderField -----', cmp.get('v.fieldName'));
        //         allValid = allValid && false;
        //     }
        // });
        component.find("inputCustomField").forEach(function(cmp) {
            if(!$A.util.isEmpty(cmp.get('v.name')) && cmp.get('v.required') && $A.util.isEmpty(cmp.get('v.value'))) {
                console.log('[validateFormData] inputCustomField -----', cmp.get('v.name'));
                /*
                if(component.get('v.isSupplier') && cmp.get('v.name') != 'PaymentMethod__c')
                {
                    allValid = allValid && cmp.checkValidity();
                }
                else
                {
                    allValid = allValid && cmp.checkValidity();
                }*/
                    allValid = allValid && cmp.checkValidity();
                
                console.log('[validateFormData] --5---'+allValid);
            }
            console.log('[validateFormData] --6---'+allValid);
        });
        
        return allValid;
    },

    showToast: function(message, isSuccess) {
        const toastType = isSuccess ? "success" : "error";
        const toastParams = {
            type: toastType,
            message: message
        };
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },

    prepopulateHeader: function(component) {
        console.log('[prepopulateHeader] -----');
        component.set("v.showLoading", true);
        if(component.get('v.isEdit')) {
            if(!$A.util.isEmpty(component.get("v.recordObject"))) {
                component.find("editFormItemField").forEach(function(cmp) {
                    var fieldName = cmp.get('v.fieldName');
                    if(fieldName == 'LastName__c') {
                        cmp.set('v.value', component.get('v.recordObject.LastName__c'));
                    } else if(fieldName == 'Email__c') {
                        cmp.set('v.value', component.get('v.recordObject.Email__c'));
                    } else if(fieldName == 'AccountGroup__c') {
                        cmp.set('v.value', component.get('v.recordObject.AccountGroup__c'));
                    }
                });
            }
            component.set("v.showLoading", false);
        } else {
            var accountObject = component.get('v.accountObject');
            if(!$A.util.isEmpty(accountObject)) {
                component.find("editFormItemField").forEach(function(cmp) {
                    var fieldName = cmp.get('v.fieldName');
                    var value;
                    switch(fieldName) {
                        case 'Phone__c':
                            value = accountObject[fieldName.replace('__c', '')];
                            break;
                        case 'Fax__c':
                            value = accountObject[fieldName.replace('__c', '')];
                            break;
                        default:
                            value = accountObject[fieldName];
                    }
                    // console.log('[prepopulateHeader] ' + fieldName + ' -----', value);
                    if(!$A.util.isEmpty(value)) {
                        cmp.set('v.value', value);
                    }
                });
            }
        }
        component.set("v.showLoading", false);
    },

    prepopulateItem: function(component) {
        component.set("v.showLoading", true);
        var accountObject = component.get('v.accountObject');
        if(!$A.util.isEmpty(accountObject)) {
            component.find("editFormItemField").forEach(function(cmp) {
                var fieldName = cmp.get('v.fieldName');

                if(fieldName != 'PaymentGuaranteeProcedure__c'  && fieldName != 'TaxClassification__c' && fieldName != 'CustomerType__c')
                {
                    var value = accountObject[fieldName];
                    // console.log('[prepopulateItem] ' + fieldName + ' -----', value);
                    if(!$A.util.isEmpty(value)) {
                        cmp.set('v.value', value);
                    }
                }
                if(fieldName == 'CustomerType__c')
                {
                    cmp.set('v.value','');
                }
                

                if(fieldName == 'Phone__c') 
                {
                    cmp.set('v.value', accountObject['Phone']);
                }
                if(fieldName == 'WHTaxCountry__c') 
                {
                    cmp.set('v.value', accountObject['fmlCountryCode__c']);
                }
                // if(accountObject['fmlCountryCode__c'])
                // {
                //     if(accountObject['fmlCountryCode__c'] == 'TH')
                //     {
                        if(fieldName == 'Wthttype1__c') {
                            cmp.set('v.value', 'J1');
                        }
                        if(fieldName == 'Wthttype2__c') {
                            cmp.set('v.value', 'J2');
                        }
                        if(fieldName == 'Recty1__c') {
                            cmp.set('v.value', '53');
                        }
                        if(fieldName == 'Recty2__c') {
                            cmp.set('v.value', '53');
                        }
                        if(fieldName == 'Liable1__c') {
                            cmp.set('v.value', true);
                        }
                        if(fieldName == 'Liable2__c') {
                            cmp.set('v.value', true);
                        }
                        //cmp.set('v.LockWTH', true);
                //     }
                // }
                if(!component.get('v.isSupplier'))
                {
                    if(fieldName == 'PartialDeliveriesperitem__c') {
                        cmp.set('v.value', 'B');
                    }
                }

                // Set default value
                if(fieldName == 'SortKey__c') {
                    cmp.set('v.value', '009');
                }
                else if(fieldName == 'Division__c') {
                    cmp.set('v.value', '00');
                }
                else if(fieldName == 'ExchangeRateType__c') {
                    cmp.set('v.value', 'B');
                }
                else if(fieldName == 'CustPriceProc__c') {
                    cmp.set('v.value', '1');
                }
                
                else if(fieldName == 'MaxPartialDeliveries__c') {
                    cmp.set('v.value', '1');
                }
                else if(fieldName == 'UnderdeliveryTolerance__c') {
                    cmp.set('v.value', '5');
                }
                else if(fieldName == 'OverdeliveryTolerance__c') {
                    cmp.set('v.value', '5');
                }
                else if(fieldName == 'OrderProbability__c') {
                    cmp.set('v.value', '0');
                }
                else if(fieldName == 'OrderCombination__c') {
                    cmp.set('v.value', 'false');
                }
                else if(fieldName == 'Rebate__c') {
                    cmp.set('v.value', 'true');
                }
                else if(fieldName == 'IsPriceDetermin__c') {
                    cmp.set('v.value', 'true');
                }
                else if(fieldName == 'Chkdoubleinv__c') {
                    cmp.set('v.value', 'true');
                }
                else if(fieldName == 'AutomaticPurchaseOrder__c') {
                    cmp.set('v.value', 'true');
                }
                else if(fieldName == 'ShippingConditions__c') 
                {
                    cmp.set('v.value', '02');
                }
            });
        }
        component.set("v.showLoading", false);
    },

    retrieveSalesOrgMapping: function(component) {
        console.log('[retrieveSalesOrgMapping] -----');
        component.set('v.showLoading', true);
        var action = component.get('c.retrieveSalesOrgMapping');
        action.setParams({
            'selectedProductType': component.get('v.selectedProductType'),
            'bu': component.get('v.bu')
        });
        action.setCallback(this, function (res) {
			var state = res.getState();
			if (state === 'SUCCESS') {
				var result = res.getReturnValue();
				console.log('result -----', result);
				if(!$A.util.isEmpty(result)) {
                    var editFormItemFields = component.find("editFormItemField");
                    for(var i=0; i<editFormItemFields.length; i++) {
                        var fieldName = editFormItemFields[i].get('v.fieldName');
                        if(fieldName == 'SalesOrganizationTX__c') {
                            if(editFormItemFields[i].get('v.value') != result) {
                                editFormItemFields[i].set('v.value', result);
                            }
                            break;
                        }
                    }
				} else {
					this.showToast('Couldn\'t retrieve Sales Organization', false);
				}
				component.set("v.showLoading", false);
			}
		});
		$A.enqueueAction(action);
    },

    retrievePaymentMethodMapping: function(component, selectedCompanyCode) {
        console.log('[retrievePaymentMethodMapping] -----');
        component.set('v.showLoading', true);
        var action = component.get('c.retrievePaymentMethodMapping');
        action.setParams({
            'selectedCompanyCode': selectedCompanyCode
        });
        action.setCallback(this, function (res) {
			var state = res.getState();
			if (state === 'SUCCESS') {
				var result = res.getReturnValue();
				console.log('result -----', result);
				if(!$A.util.isEmpty(result)) {
                    component.set('v.paymentMethodOptions', result);
				} else {
                    component.set('v.paymentMethodOptions', []);
					// this.showToast('Couldn\'t retrieve Payment Method', false);
				}
				component.set("v.showLoading", false);
			}
		});
		$A.enqueueAction(action);
    },

    setDynamicFields: function(component) {
        var selectedProductType = component.get('v.selectedProductType');
        var isLube = false;
        var isLABIX = false;
        var isOtherProduct = false;
        if(selectedProductType.includes('Lube Base')) {
            isLube = true;
        } else if(selectedProductType.includes('LABIX')) {
            isLABIX = true;
        } else if(selectedProductType.includes('Other')) {
            isOtherProduct = true;
        }
        component.set('v.isLube', isLube);
        component.set('v.isLABIX', isLABIX);
        component.set('v.isOtherProduct', isOtherProduct);
    },

    closeFocusedTab : function(component) {
        // window.close();
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get('v.recordId'),
            "slideDevName": "detail"
            });
        navEvt.fire();
        window.setTimeout(
            $A.getCallback(function() {
                console.log('refresh');
                window.location.reload(true);
            }), 500
        );
    },
})