({
	getRequestList: function (component) {
		console.log('Debug params',component.get('v.customerId'),component.get('v.bu'),component.get('v.recordTypeId'))
        var action = component.get('c.onloadCreatePage');
        action.setParams({
            "mAccountId": component.get('v.customerId'),
            "mRecordTypeSelectedId": component.get('v.recordTypeId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var requestList = response.getReturnValue();
				console.log('Request list ',requestList);
                if (requestList && requestList.length > 0) {
                    component.set('v.requestList', requestList);
                } else {
                    this.closeModal(component);
                    this.showToast('No record found', false);
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
})