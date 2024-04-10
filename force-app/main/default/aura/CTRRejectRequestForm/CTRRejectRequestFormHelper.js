({
    performRejectRequestForm : function(component) {
        var action = component.get("c.rejectRequestForm");
            action.setParams({
                "recordId": component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    // var result = response.getReturnValue();
                    this.showToast('Success', 'success', 'Request Form has been rejected.');
                    this.closeModal(component);
                    $A.get('e.force:refreshView').fire();

                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if(errors) {
                        if(errors[0] && errors[0].message) {
                            console.log('[performRejectRequestForm] error -----', errors[0].message);
                            this.showToast('Error', 'error', errors[0].message);
                        }
                    } else {
                        console.log('[performRejectRequestForm] unknown error -----');
                        this.showToast('Error', 'error', 'Unknown error');
                    }
                }
            });
            $A.enqueueAction(action);
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

    closeModal : function(component) {
        component.set("v.isLoaded", true);
        $A.get("e.force:closeQuickAction").fire();
    },
})