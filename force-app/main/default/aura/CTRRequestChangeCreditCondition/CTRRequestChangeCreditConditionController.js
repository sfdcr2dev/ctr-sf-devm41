({
    doInit: function (component, event, helper) {
        component.set('v.showSpinner', true);
        var requestType = component.get('v.requestType');
        if(requestType.includes('Customer')) {
            component.set('v.counterPartyType','Customer');
        } else {
            component.set('v.counterPartyType','Supplier');
        }
        helper.getRequestList(component, event, helper);
    },
    closeModal: function (component, event, helper) {
        helper.closeModal(component);
    },
    handleRecordUpdated: function (component, event, helper) {
        console.log("handleRecordUpdated");
        console.log(component.get("v.customerId"));
        console.log(JSON.parse(JSON.stringify(component.get("v.targetRecord"))));
    },
    handleSelect: function (component, event, helper) {
        var selectValue = event.getSource().get("v.value");
        var selectName = event.getSource().get("v.name");
        var selectIdx = selectName.split('_')[1];
        var selectedRequest = component.get('v.selectedRequest');

        var requestList = component.get('v.requestList');
        requestList.forEach(request => {
            request.mSelected = false;
            if (request.mIndex == selectIdx) {
                request.mSelected = true;
                selectedRequest = request;
            }
        });

        component.set('v.selectedRequest', selectedRequest);
        component.set('v.requestList', requestList);
    },

    handleSave: function (component, event, helper) {
        var selectedRequest = component.get('v.selectedRequest');
        if (selectedRequest) {
            helper.saveRequest(component)
        }
    }
})