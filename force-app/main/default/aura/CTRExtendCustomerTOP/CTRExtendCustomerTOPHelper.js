({
    initialize: function(component) {
        try {
            this._components = [
                component.find('Owner'),
                component.find('SalesOrganizationTOP__c'),
                component.find('CompanyCodeTOP__c'),
                component.find('Name'),
                component.find('RequestType'),
                component.find('Customer__c'),
                component.find('Objective__c'),
                component.find('InterestedProductTypeAsCustomerTOP__c'),
                component.find('LubeBaseProducts__c'),
                component.find('LABIXProducts__c'),
                component.find('CustomerOtherProducts__c'),
            ];
        } catch(ex) {
            console.error(ex);
        }
    },

    getPicklistValue: function(component) {
        console.log('[getPicklistValue] -----');
        const comUtility = component.find('comUtility');
        comUtility.getPicklistValues('CTRRequestFormItem__c.' + component.get('v.interestProductField'), component.get('v.recordTypeId'));
    },

    getCurrentUser: function(component) {
        component.set('v.ownerId', $A.get("$SObjectType.CurrentUser.Id"));
    },

    saveRequest: function(component) {
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
            requestItem[cmp.get('v.fieldName')] = (!$A.util.isEmpty(cmp.get('v.value')) ? cmp.get('v.value') : null);
        });
        if(!$A.util.isEmpty(requestItem['SalesOrganizationTOP__c'])) { requestItem['SalesOrganization__c'] = requestItem['SalesOrganizationTOP__c']; }
        if(!$A.util.isEmpty(requestItem['PurchasingOrganizationTOP__c'])) { requestItem['PurchasingOrganization__c'] = requestItem['PurchasingOrganizationTOP__c']; }

        if(!$A.util.isEmpty(requestItem['InterestedProductTypeAsCustomerTOP__c'])) { requestHeader['InterestedProductTypeAsCustomerTOP__c'] = requestItem['InterestedProductTypeAsCustomerTOP__c']; }
        if(!$A.util.isEmpty(requestItem['InterestedProductTypeAsSupplierTOP__c'])) { requestHeader['InterestedProductTypeAsSupplierTOP__c'] = requestItem['InterestedProductTypeAsSupplierTOP__c']; }


        requestHeader['OwnerId'] = ownerId;
        requestHeader['Customer__c'] = requestItem['Customer__c'];
        if(!$A.util.isEmpty(requestItem['LubeBaseProduct__c'])) { requestHeader['LubeBaseProduct__c'] = requestItem['LubeBaseProduct__c']; }
        if(!$A.util.isEmpty(requestItem['LABIXProduct__c'])) { requestHeader['LABIXProduct__c'] = requestItem['LABIXProduct__c']; }
        if(!$A.util.isEmpty(requestItem['CustomerOtherProducts__c'])) { requestHeader['CustomerOtherProducts__c'] = requestItem['CustomerOtherProducts__c']; }
        // if(!$A.util.isEmpty(requestItem['SalesOrganization__c'])) { requestHeader['SalesOrganization__c'] = requestItem['SalesOrganization__c']; }
        // if(!$A.util.isEmpty(requestItem['PurchasingOrganization__c'])) { requestHeader['PurchasingOrganization__c'] = requestItem['PurchasingOrganization__c']; }
        component.find("editFormHeaderField").forEach(function(cmp) {
            console.log('[getFormData] ' + cmp.get('v.fieldName') + ' -----', cmp.get('v.value'));
            requestHeader[cmp.get('v.fieldName')] = (!$A.util.isEmpty(cmp.get('v.value')) ? cmp.get('v.value') : null);
        });

        console.log('[getFormData] requestItem -----', requestItem);
        console.log('[getFormData] requestHeader -----', requestHeader);
        // return {
        //     CTRRequestFormHeader__c: {
        //         OwnerId: component.find('Owner').get('v.selectedRecordId'),
        //         Customer__c: component.find('Customer__c').get('v.value'),
        //         SalesOrganizationTOP__c: component.find('SalesOrganizationTOP__c').get('v.value'),
        //         ContactSalutation__c: component.find("ContactSalutation__c").get('v.value'),
        //         Nickname__c: component.find("Nickname__c").get('v.value'),
        //         FirstName__c: component.find("FirstName__c").get('v.value'),
        //         LastName__c: component.find("LastName__c").get('v.value'),
        //         Position__c: component.find("Position__c").get('v.value'),
        //         Email__c: component.find("Email__c").get('v.value'),
        //         MobileCountryCode__c: component.find("MobileCountryCode__c").get('v.value'),
        //         MobilePhone__c: component.find("MobilePhone__c").get('v.value'),
        //         PhoneCountryCode__c: component.find("PhoneCountryCode__c").get('v.value'),
        //         Phone__c: component.find("Phone__c").get('v.value'),
        //         PhoneExtension__c: component.find("PhoneExtension__c").get('v.value'),
        //         FaxCountryCode__c: component.find("FaxCountryCode__c").get('v.value'),
        //         Fax__c: component.find("Fax__c").get('v.value'),
        //         FaxExtension__c: component.find("FaxExtension__c").get('v.value')
        //     },
        //     CTRRequestFormItem__c: {
        //         Name: component.find('Name').get('v.value'),
        //         // RequestType: component.find('RequestType').get('v.value'),
        //         Customer__c: component.find('Customer__c').get('v.value'),
        //         Objective__c: component.find('Objective__c').get('v.value'),
        //         InterestedProductTypeAsCustomerTOP__c: component.find('InterestedProductTypeAsCustomerTOP__c').get('v.value'),
        //         LubeBaseProducts__c: component.find('LubeBaseProducts__c').get('v.value'),
        //         LABIXProducts__c: component.find('LABIXProducts__c').get('v.value'),
        //         CustomerOtherProducts__c: component.find('CustomerOtherProducts__c').get('v.value'),
        //         CompanyCodeTOP__c: component.find('CompanyCodeTOP__c').get('v.value'),
        //         RecordTypeId: component.get('v.recordTypeId'),
        //     },
        //     CTRShippingCountry__c: component.get('v.shippingList'),
        // }
        return {
            CTRRequestFormHeader__c: requestHeader,
            CTRRequestFormItem__c: requestItem,
            CTRShippingCountry__c: component.get('v.shippingList'),
        }
    },

    validateFormData: function(component) {
        console.log('[validateFormData] -----');
        let allValid = true;
        if($A.util.isEmpty(component.find('editFormItemOwner').get('v.selectedRecordId'))) {
            allValid = false;
        }
        component.find("editFormItemField").forEach(function(cmp) {
            if(!$A.util.isEmpty(cmp.get('v.fieldName')) && cmp.get('v.required') && $A.util.isEmpty(cmp.get('v.value'))) {
                console.log('[validateFormData] editFormItemField -----', cmp.get('v.fieldName'));
                allValid = allValid && false;
            }
        });
        component.find("editFormHeaderField").forEach(function(cmp) {
            if(!$A.util.isEmpty(cmp.get('v.fieldName')) && cmp.get('v.required') && $A.util.isEmpty(cmp.get('v.value'))) {
                console.log('[validateFormData] editFormHeaderField -----', cmp.get('v.fieldName'));
                allValid = allValid && false;
            }
        });
        component.find("inputCustomField").forEach(function(cmp) {
            if(!$A.util.isEmpty(cmp.get('v.name')) && cmp.get('v.required') && $A.util.isEmpty(cmp.get('v.value'))) {
                console.log('[validateFormData] inputCustomField -----', cmp.get('v.name'));
                allValid = allValid && cmp.checkValidity();
            }
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
            if(!$A.util.isEmpty(component.get("v.recordHeader"))) {
                component.find("editFormHeaderField").forEach(function(cmp) {
                    var fieldName = cmp.get('v.fieldName');
                    if(fieldName == 'LastName__c') {
                        cmp.set('v.value', component.get('v.recordHeader.LastName__c'));
                    } else if(fieldName == 'Email__c') {
                        cmp.set('v.value', component.get('v.recordHeader.Email__c'));
                    }
                });
            }
            component.set("v.showLoading", false);
        } else {
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
                        component.find("editFormHeaderField").forEach(function(cmp) {
                            var fieldName = cmp.get('v.fieldName');
                            var value;
                            switch(fieldName) {
                                case 'Phone__c':
                                    value = result[fieldName.replace('__c', '')];
                                    break;
                                case 'Fax__c':
                                    value = result[fieldName.replace('__c', '')];
                                    break;
                                default:
                                    value = result[fieldName];
                            }
                            console.log('[prepopulateHeader] ' + fieldName + ' -----', value);
                            if(!$A.util.isEmpty(value)) {
                                cmp.set('v.value', value);
                            }
                        });
                    } else {
                        this.showToast('Couldn\'t get Account detail', false);
                    }
                    component.set("v.showLoading", false);
                }
            });
            $A.enqueueAction(action);
        }
        
    },

    retrieveSalesOrgMapping: function(component) {
        console.log('[retrieveSalesOrgMapping] -----'+component.get('v.selectedProductType'));
        component.set('v.showLoading', true);
        component.set('v.isNotOtherProduct',true);
        var action = component.get('c.retrieveSalesOrgMapping');
        var isSupplier = component.get('v.isSupplier');
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
                    var match = false;
                    var editFormItemFields = component.find("editFormItemField");
                    for(var i=0; i<editFormItemFields.length; i++) {
                        var fieldName = editFormItemFields[i].get('v.fieldName');
                        if(isSupplier && fieldName == 'PurchasingOrganizationTOP__c')
                        {
                            editFormItemFields[i].set('v.value', '1100');
                        }
                        if((!isSupplier && fieldName == 'SalesOrganizationTOP__c') || (isSupplier && fieldName == 'CompanyCodeTOP__c')) {
                            if(editFormItemFields[i].get('v.value') != result) {
                                editFormItemFields[i].set('v.value', result);
                                
                            }
                            break;
                        }
                    }
                    
                    if(!isSupplier) { this.retrieveDistributionChannel(component, result); }
				} else {
					// this.showToast('Couldn\'t retrieve Sales Organization', false);
				}
				component.set("v.showLoading", false);
			}
		});
		$A.enqueueAction(action);
    },

    retrieveDistributionChannel: function(component, selectedSalesOrg) {
        console.log('[retrieveDistributionChannel] -----');
        component.set('v.showLoading', true);
        component.set('v.selectedDistributionChannel', null);
        var action = component.get('c.retrieveDistributionChannel');
        action.setParams({
            'selectedProductType': component.get('v.selectedProductType'),
            'selectedSalesOrg': selectedSalesOrg,
            'bu': component.get('v.bu')
        });
        action.setCallback(this, function (res) {
			var state = res.getState();
			if (state === 'SUCCESS') {
				var result = res.getReturnValue();
				console.log('result -----', result);
				if(!$A.util.isEmpty(result)) {
                    component.set('v.distributionChannelOptions', result);
				} else {
                    component.set('v.distributionChannelOptions', []);
					// this.showToast('Couldn\'t retrieve Distribution Channel', false);
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
        var isPetroluem = false;
        if(selectedProductType.includes('Lube Base')) {
            isLube = true;
        } else if(selectedProductType.includes('LABIX')) {
            isLABIX = true;
        } else if(selectedProductType.includes('Other')) {
            isOtherProduct = true;
        } else if(selectedProductType.includes('Petroleum')) {
            isPetroluem = true;
        }
        component.set('v.isLube', isLube);
        component.set('v.isLABIX', isLABIX);
        component.set('v.isOtherProduct', isOtherProduct);
        component.set('v.isPetroluem', isPetroluem);
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