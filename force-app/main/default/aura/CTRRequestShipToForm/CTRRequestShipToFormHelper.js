({
    closeModal: function (component) {
        if (component.get('v.recordId')) { // edit from item detail page
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get('v.recordId'),
                "slideDevName": "detail"
            });
            navEvt.fire();
        } else {
            $A.get("e.force:closeQuickAction").fire();
            component.set("v.isModalOpen", false);
        }
    },

    submitRequestShipTo: function (component, event, helper) {
        const formData = helper.validateRequiredData(component);
        console.log('Debug form data', formData)
        if (formData) {
            if (component.get('v.ChangedFieldForEDITHeader')) {
                var jsonChanged = JSON.stringify(component.get('v.ChangedFieldForEDITHeader'));
                formData.HeaderInternalEditField = jsonChanged;
            }
            if (component.get('v.ChangedFieldForEDITItem')) {
                var jsonChanged = JSON.stringify(component.get('v.ChangedFieldForEDITItem'));
                formData.ItemInternalEditField = jsonChanged;
            }
            console.log('Debug form data before sending', formData)

            component.set('v.showSpinner', true); // test
            var action = component.get("c.saveRequestShipTo");
            action.setParams({
                "mItemId": component.get('v.recordId'),
                "formData": JSON.stringify(formData),
                "customerId": component.get('v.customerId'),
                "itemRecordTypeId": component.get('v.recordTypeId'),
                "requestWrapper": component.get('v.selectedRequest')
            });

            action.setCallback(this, function (response) {
                var state = response.getState();

                if (state === "SUCCESS") {
                    var responseResult = response.getReturnValue();
                    console.log('Debug result ', responseResult)
                    component.set('v.showSpinner', false);
                    if (responseResult.result) {
                        this.showToast('The request has been created.', true)
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({ "recordId": responseResult.resRecordId, "slideDevName": "related" });
                        navEvt.fire();
                    } else {
                        this.showToast(responseResult.message, false);
                    }
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors && errors[0] && errors[0].message) {
                        this.showToast(errors[0].message, false);
                        console.log("Error message: " + errors[0].message);
                    }
                }
                component.set('v.showSpinner', false);
            }
            );
            $A.enqueueAction(action);
        }

    },

    getDefaultData: function (component, event, helper) {
        // component.set('v.showSpinner', true); // test
        var action = component.get("c.getDefaultItem");
        action.setParams({
            "mItemId": component.get('v.recordId'),
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseResult = response.getReturnValue();
                console.log('Default item ', responseResult);
                if (responseResult) {
                    

                    if (responseResult.mRequestHeader) {
                        if (responseResult.mRequestHeader.InternalEditField__c) {
                            var mListFieldChanged = JSON.parse(responseResult.mRequestHeader.InternalEditField__c);
                            component.set('v.ChangedFieldForEDITHeader', mListFieldChanged);
                        }
                    }
                    if (responseResult.mRequestItem) {
                        if (responseResult.mRequestItem.InternalEditField__c) {
                            var mListFieldChanged = JSON.parse(responseResult.mRequestItem.InternalEditField__c);
                            component.set('v.ChangedFieldForEDITItem', mListFieldChanged);
                        }

                        var selectedRequest = {
                            mAccountId: responseResult.mRequestItem.Customer__c,
                            mLabelSalesOrg: responseResult.mRequestItem.salesOrgLabel,
                            mLabelDistributionChannel: responseResult.mRequestItem.divisionLabel,
                            mCountry: responseResult.mRequestItem.Customer__r.Country__c ? responseResult.mRequestItem.Customer__r.Country__r.Description__c : null,
                            mLabelDivision: responseResult.mRequestItem.distChLabel
                        };
                        component.set('v.selectedRequest', selectedRequest);
                        helper.handleDefaultId(component, event, helper);
                    }
                    // component.set('v.useCustomerId', responseResult.Customer__c);
                    // helper.initialCustomer(component, event, helper);


                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
            }
            component.set('v.showSpinner', false);
        }
        );
        $A.enqueueAction(action);
    },

    showToast: function (message, isSuccess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": isSuccess ? "success" : "error",
            "message": message
        });
        toastEvent.fire();
    },


    validateRequiredData: function (component) {
        var isError = false;
        var convertObj = {};
        component.find("editFormAccountField").forEach(function (cmp) {
            var fieldName = cmp.get('v.fieldName');
            var value = cmp.get('v.value');
            convertObj[fieldName] = value;

            if (cmp.get("v.required") == true && cmp.get("v.disabled") == false && (value == null || value == '')) {
                // if(!$A.util.hasClass(cmp,'slds-has-error')) {
                $A.util.addClass(cmp, "slds-has-error");
                $A.util.addClass(component.find('error-' + fieldName), "custom-error-enabled");
                // }
                isError = true;
            } else {
                $A.util.removeClass(cmp, "slds-has-error");
                $A.util.removeClass(component.find('error-' + fieldName), "custom-error-enabled");
            }
        })
        console.log('Actual form data', convertObj)

        if (isError) {
            return null;
        }
        return convertObj;
    },

    handleDefaultId: function (component, event, helper) {
        if(component.get('v.sObjectName') != 'Account') {
            component.set('v.useSObjectName','CTRRequestFormHeader__c')
        }

        if (component.get('v.sObjectName') == 'Account') {
            // request item
            if (component.get('v.requestType').includes('Edit')) {
                component.set('v.isEdit', true);
                if (component.get('v.selectedRequest')) {
                    component.set('v.useCustomerId', component.get('v.selectedRequest').mAccountId);
                    component.set('v.defaultInputRecordId', component.get('v.selectedRequest').mAccountId);
                }
            } else {
                component.set('v.useCustomerId', component.get('v.customerId'));
            }
        } else {
            // press edit button
            // component.set('v.useCustomerId', component.get('v.selectedRequest').mAccountId);
            component.set('v.defaultInputRecordId', component.get('v.recordHeaderId'));
            if (component.get('v.requestType').includes('Edit')) {
                component.set('v.isEdit', true);
            }
        }
        console.log('Debug default object ', component.get('v.sObjectName'), component.get('v.defaultInputRecordId'))
        component.set('v.showSpinner', false);
        component.set('v.isInitial', true);
    },

    addFieldChangeToJson: function (component, event, level) {
        var source = 'Ship-To';
        var label = event.getSource().get('v.id');
        var fieldName = event.getSource().get('v.fieldName');
        var value = String(event.getSource().get('v.value'));
        var fieldChangedList = (level == 'Header') ? component.get('v.ChangedFieldForEDITHeader') : component.get('v.ChangedFieldForEDITItem');
        if (value) {
            value.replace("[", "");
            value.replace("]", "");
        }
        console.log("label:" + label);
        console.log("fieldName:" + fieldName);
        console.log("value:" + value);
        if (!label) {
            label = event.getSource().get('v.label');
        }
        if (!fieldName) {
            fieldName = event.getSource().get('v.name');
        }

        console.log("label2:" + label);
        console.log("fieldName2:" + fieldName);

        var isExisted = false;
        console.log("fieldChangedList:" + fieldChangedList.length);
        if (fieldName) {
            if (fieldChangedList.length > 0) {
                for (var existing of fieldChangedList) {
                    if (existing.Api == fieldName) {
                        existing.Label = label;
                        existing.Value = value;
                        existing.User = component.get('v.currentUserName');
                        existing.Source = source;
                        isExisted = true;
                    }
                }
            }

            if (isExisted == false) {
                var mJson = '{"Label":"' + label + '",';
                mJson += '"Api":"' + fieldName + '",';
                mJson += '"Source":"' + source + '",';
                mJson += '"User":"' + component.get('v.currentUserName') + '",';
                mJson += '"Value":"' + value + '"}';
                var mObj = JSON.parse(mJson);
                fieldChangedList.push(mObj);
            }
            console.log('field change: ', JSON.parse(JSON.stringify(fieldChangedList)));
            if (level == 'Header') {
                component.set('v.ChangedFieldForEDITHeader', fieldChangedList);
            }
            else if (level == 'Item') {
                component.set('v.ChangedFieldForEDITItem', fieldChangedList);
            }
        }

    },

    validateField: function (component, event, helper) {
        var cmp = event.getSource();
        var fieldName = cmp.get('v.fieldName');
        var value = cmp.get('v.value');
        if (cmp.get("v.required") == true && cmp.get("v.disabled") == false && (value == null || value == '')) {
            // if(!$A.util.hasClass(cmp,'slds-has-error')) {
            $A.util.addClass(cmp, "slds-has-error");
            $A.util.addClass(component.find('error-' + fieldName), "custom-error-enabled");
            // }
        } else {
            $A.util.removeClass(cmp, "slds-has-error");
            $A.util.removeClass(component.find('error-' + fieldName), "custom-error-enabled");
        }

    },
})