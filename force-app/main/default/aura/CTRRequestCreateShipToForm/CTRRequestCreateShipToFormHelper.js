({
    closeModal: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isModalOpen", false);
    },

    submitCreateShipTo: function (component, event, helper) {
        const formData = helper.validateRequiredData(component);
        console.log('Debug form data',formData)
        if(formData) {
            component.set('v.showSpinner', true); // test
            var action = component.get("c.createShipTo");
            action.setParams({
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
            
            if(cmp.get("v.required") == true && cmp.get("v.disabled") == false && (value == null || value == '')) {
                // if(!$A.util.hasClass(cmp,'slds-has-error')) {
                    $A.util.addClass(cmp, "slds-has-error");
                    $A.util.addClass(component.find('error-'+fieldName), "custom-error-enabled");
                // }
                isError = true;
            } else {
                $A.util.removeClass(cmp, "slds-has-error");
                $A.util.removeClass(component.find('error-'+fieldName), "custom-error-enabled");
            }
        })

        if(isError) {
            return null;
        }
        return convertObj;
    }

})