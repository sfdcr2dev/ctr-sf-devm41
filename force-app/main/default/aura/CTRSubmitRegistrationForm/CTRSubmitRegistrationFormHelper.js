({
    validateUserProfile : function(component) {
        component.set('v.isLoaded', false);
        var action = component.get("c.validateUserProfile");
        action.setParams({
            "userId": $A.get("$SObjectType.CurrentUser.Id")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.isTX', result);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[validateUserProfile] error -----', errors[0].message);
                        this.showToast('Error', 'error', errors[0].message);
                    }
                } else {
                    console.log('[validateUserProfile] unknown error -----');
                    this.showToast('Error', 'error', 'Unknown error');
                }
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
    },

    updateRequestFormStatus : function(component) {
        component.set('v.isLoaded', false);
        var action = component.get("c.updateRequestFormStatus");
        var inputData = {};
        inputData['recordId'] = component.get('v.recordId');
        inputData['status'] = 'Pre Screen';
        action.setParams({
            "inputData": inputData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result == 'success') {
                    this.showToast('Success', 'success', 'Status has been updated.');
                    this.closeModal(component);
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.showToast('Error', 'error', 'Failed to update Status.');
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[updateRequestFormStatus] error -----', errors[0].message);
                        this.showToast('Error', 'error', errors[0].message);
                    }
                } else {
                    console.log('[updateRequestFormStatus] unknown error -----');
                    this.showToast('Error', 'error', 'Unknown error');
                }
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
    },

    closeModal : function(component) {
        component.set("v.isLoaded", true);
        $A.get("e.force:closeQuickAction").fire();
    },

    showToast : function(title, type, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"type": type,
			"message": message
		});
		toastEvent.fire();
	},
})