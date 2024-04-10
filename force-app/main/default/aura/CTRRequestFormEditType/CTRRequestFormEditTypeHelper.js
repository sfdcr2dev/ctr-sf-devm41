({
    getRequestList: function (component) {
        console.log('Onload edit ', component.get('v.customerId'), component.get('v.recordTypeId'), component.get('v.bu'))
        var action = component.get('c.onloadCreatePage');
        action.setParams({
            "mAccountId": component.get('v.customerId'),
            "mRecordTypeSelectedId": component.get('v.recordTypeId'),
            "mBusinessUnit": component.get('v.bu'),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var requestList = response.getReturnValue();
                // this.showToast('Record saved successfully', true);
                console.log('Debug request ', requestList)

                if (requestList && requestList.length > 0) {
                    requestList.forEach(request => {
                        if (request.mSelected) {
                            var selectedItem = { index: selectIdx };
                            component.set('v.selectedRequest', selectedItem)
                        }
                    });
                    component.set('v.requestList', requestList);
                } else {
                    this.closeModal(component);
                    this.showToast('No record to edit', false);
                }
                // this.toggleAlert(component);

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
        // var navEvt = $A.get("e.force:navigateToSObject"); 
        // navEvt.setParams({ "recordId": 'a3c1m000000MMRoAAO', "slideDevName": "related" }); 
        // navEvt.fire(); 
        console.log('Onsave edit ', component.get('v.recordTypeId'),component.get('v.bu'),requestWrapper);
        component.set('v.showSpinner', true);
        var action = component.get('c.onCreateEditRequest');
        action.setParams({
            "CustomerId": component.get('v.customerId'),
            "RecordType": component.get('v.recordTypeId'),
            "BusinessUnit": component.get('v.bu'),
            "mRequestWrapper": requestWrapper
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                // this.showToast('Record saved successfully', true);
                console.log('Debug result ', result)
                component.set('v.showSpinner', false);
                if(result) {
                    this.showToast('The request has been created.',true)
                    console.log('debug inserted id ',result);
                    var navEvt = $A.get("e.force:navigateToSObject"); 
                    navEvt.setParams({ "recordId": result, "slideDevName": "related" }); 
                    navEvt.fire(); 
                } else {
                    this.showToast('Failed to create request, Not found recordtype', false);
                }

                // if(requestList && requestList.length > 0) {
                //     requestList.forEach(request => {
                //         if (request.mSelected) {
                //             var selectedItem = { index: selectIdx };
                //             component.set('v.selectedRequest',selectedItem)
                //         }
                //     });
                //     component.set('v.requestList',requestList);
                //     this.showToast('Record has been saved',true)
                // } else {
                //     this.closeModal(component);
                //     this.showToast('No record to edit', false);
                // }
                // this.toggleAlert(component);

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