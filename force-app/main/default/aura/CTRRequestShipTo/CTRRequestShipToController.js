({
	doInit: function (component, event, helper) {
        component.set('v.showSpinner', true);
        console.log('Request type',component.get('v.requestType'))
        if(component.get('v.requestType').includes('Edit')) {
            component.set('v.isEdit',true);
        }
        console.log('Debug is edit ',component.get('v.isEdit'))
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

    handleNext: function (component, event, helper) {
        const _THIS_ = this;
        var params = { customerId: component.get('v.customerId'), recordTypeId: component.get('v.recordTypeId'), bu: component.get('v.bu'), requestType: component.get('v.requestType') }
        component.set('v.isModalOpen', false);
        component.set('v.isFormModalOpen', true);
    },
})