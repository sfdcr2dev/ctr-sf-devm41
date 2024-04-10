({
    closeModal: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isModalOpen", false);
    },

    submitCreateRequest: function (component, event) {
        component.set('v.showSpinner', true); // test
        event.preventDefault();
        const formData = event.getParam('fields');
        console.log('Debug selected request',component.get('v.selectedRequest'))
        console.log('Params ',JSON.stringify(formData),component.get('v.customerId'),component.get('v.recordTypeId'));
        var action = component.get("c.onCreateRequest");
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
    },

    showToast: function (message, isSuccess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": isSuccess ? "success" : "error",
            "message": message
        });
        toastEvent.fire();
    },
})