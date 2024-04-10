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
        return new Promise($A.getCallback(function(resolve, reject) {
            const action = component.get("c.getPicklistValue");
            action.setParams({
                "sObjAPI": "CTRRequestFormHeader__c",
                "fieldAPI": "SalesOrganization__c",
            });
            action.setCallback(this, function (response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    const result = [{ label: "--None--", value: ""}];
                    result.push(...response.getReturnValue());
                    component.set("v.salesOrgOptions", result);
                    resolve(result);
                } else if (state === "ERROR") {
                    const errors = response.getError();
                    if (errors && errors[0] && errors[0].message) {
                        this.showToast(errors[0].message, false);
                        console.log("Error message: " + errors[0].message);
                    }
                    reject(errors);
                }
            });
            $A.enqueueAction(action);
        }));
    },

    getCurrentUser: function(component) {
        return new Promise($A.getCallback(function (resolve, reject) {
            const action = component.get("c.getCurrentUser")
            action.setCallback(this, function (response) {
                let state = response.getState()
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue())
                } else {
                    reject(response.getError())
                }
            })
            $A.enqueueAction(action)
        }));
    },

    saveRequest: function(component) {
        console.log('[saveRequest] -----');
        component.set('v.showLoading', true);
        const _THIS_ = this;
        return new Promise($A.getCallback(function(resolve, reject) {
            const formData = _THIS_.getFormData(component);
            if (_THIS_.validateFormData(component, formData)) {
                const action = component.get("c.saveRequest");
                action.setParams({
                    'requestHeader': formData.CTRRequestFormHeader__c,
                    'requestItem': formData.CTRRequestFormItem__c,
                    'shippingCountries': formData.CTRShippingCountry__c,
                    'bu': component.get('v.bu'),
                });
                action.setCallback(this, function (response) {
                    const state = response.getState();
                    if (state === 'SUCCESS') {
                        const result = response.getReturnValue();
                        _THIS_.showToast('Record has been save successfully.', true);
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
                component.set('v.showLoading', false);
                reject();
            }
        }));
    },

    getFormData: function(component) {
        console.log('[getFormData] -----');
        return {
            CTRRequestFormHeader__c: {
                OwnerId: component.find('Owner').get('v.selectedRecordId'),
                Customer__c: component.find('Customer__c').get('v.value'),
                SalesOrganizationTOP__c: component.find('SalesOrganizationTOP__c').get('v.value'),
                ContactSalutation__c: component.find("ContactSalutation__c").get('v.value'),
                Nickname__c: component.find("Nickname__c").get('v.value'),
                FirstName__c: component.find("FirstName__c").get('v.value'),
                LastName__c: component.find("LastName__c").get('v.value'),
                Position__c: component.find("Position__c").get('v.value'),
                Email__c: component.find("Email__c").get('v.value'),
                MobileCountryCode__c: component.find("MobileCountryCode__c").get('v.value'),
                MobilePhone__c: component.find("MobilePhone__c").get('v.value'),
                PhoneCountryCode__c: component.find("PhoneCountryCode__c").get('v.value'),
                Phone__c: component.find("Phone__c").get('v.value'),
                PhoneExtension__c: component.find("PhoneExtension__c").get('v.value'),
                FaxCountryCode__c: component.find("FaxCountryCode__c").get('v.value'),
                Fax__c: component.find("Fax__c").get('v.value'),
                FaxExtension__c: component.find("FaxExtension__c").get('v.value')
            },
            CTRRequestFormItem__c: {
                Name: component.find('Name').get('v.value'),
                // RequestType: component.find('RequestType').get('v.value'),
                Customer__c: component.find('Customer__c').get('v.value'),
                Objective__c: component.find('Objective__c').get('v.value'),
                InterestedProductTypeAsCustomerTOP__c: component.find('InterestedProductTypeAsCustomerTOP__c').get('v.value'),
                LubeBaseProducts__c: component.find('LubeBaseProducts__c').get('v.value'),
                LABIXProducts__c: component.find('LABIXProducts__c').get('v.value'),
                CustomerOtherProducts__c: component.find('CustomerOtherProducts__c').get('v.value'),
                CompanyCodeTOP__c: component.find('CompanyCodeTOP__c').get('v.value'),
                RecordTypeId: component.get('v.recordTypeId'),
            },
            CTRShippingCountry__c: component.get('v.shippingList'),
        }
    },

    validateFormData: function(component, formData) {
        console.log('[validateFormData] -----', formData);
        let isValid = true;
        // this._components.forEach(function(cmp) {
        //     if (typeof cmp.reportValidity === 'function') {
        //         isValid = isValid && cmp.reportValidity();
        //     }
        // })
        return isValid;
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
					component.find("ContactSalutation__c").set("v.value", result.ContactSalutation__c);
                    component.find("Nickname__c").set("v.value", result.Nickname__c);
                    component.find("FirstName__c").set("v.value", result.FirstName__c);
                    component.find("LastName__c").set("v.value", result.LastName__c);
                    component.find("Position__c").set("v.value", result.Position__c);
                    component.find("Email__c").set("v.value", result.Email__c);
                    component.find("MobileCountryCode__c").set("v.value", result.MobileCountryCode__c);
                    component.find("MobilePhone__c").set("v.value", result.MobilePhone__c);
                    component.find("PhoneCountryCode__c").set("v.value", result.PhoneCountryCode__c);
                    component.find("Phone__c").set("v.value", result.Phone);
                    component.find("PhoneExtension__c").set("v.value", result.PhoneExtension__c);
                    component.find("FaxCountryCode__c").set("v.value", result.FaxCountryCode__c);
                    component.find("Fax__c").set("v.value", result.Fax);
                    component.find("FaxExtension__c").set("v.value", result.FaxExtension__c);
				} else {
					this.showToast('Couldn\'t get account detail', false);
				}
				component.set("v.showLoading", false);
			}
		});
		$A.enqueueAction(action);
    },
})