({
    getRequestList: function (component) {
        var action = component.get('c.onloadCreatePage');
        action.setParams({
            "mAccountId": component.get('v.customerId'),
            "mBusinessUnit": component.get('v.bu'),
            "mRecordTypeSelectedId": component.get('v.recordTypeId'),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var requestList = response.getReturnValue();
                if (requestList && requestList.length > 0) {
                    component.set('v.requestList', requestList);
                } else {
                    this.closeModal(component);
                    this.showToast('No record to change credit condition', false);
                }

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
            }
            component.set('v.showSpinner', false);
        });
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

    closeModal: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isModalOpen", false);
    },
    
    saveRequest: function (component) {
        var requestWrapper = component.get('v.selectedRequest');
        component.set('v.showSpinner', true);
        var action = component.get('c.createRequest');
        action.setParams({
            "customerId": component.get('v.customerId'),
            "businessUnit": component.get('v.bu'),
            "recordTypeId": component.get('v.recordTypeId'),
            "mRequestWrapper": requestWrapper
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseResult = response.getReturnValue();
                console.log('Debug result ', responseResult)
                component.set('v.showSpinner', false);
                if(responseResult.result) {
                    this.showToast('The request has been created.',true)
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
        });
        $A.enqueueAction(action);
    }
})