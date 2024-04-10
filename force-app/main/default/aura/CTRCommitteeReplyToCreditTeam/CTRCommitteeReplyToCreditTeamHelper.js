({
	getCTRCommitteeApprovalId: function (component) {
        //alert('getCTRCommitteeApprovalId');
        var recordId = component.get("v.recordId");
        //var userId = component.get("v.userId");
        // Process to apex class.
        var action = component.get("c.getCTRCommitteeApprovalId");
        action.setParams({
            recordId: recordId//,
            //userId: userId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                    component.set("v.CTRCommitteeApprovalId", response.getReturnValue());
                } else {
                    console.error("Error fetching CTRCommitteeApprovalId");
                    var toastEvent = $A.get("e.force:showToast");
            		toastEvent.setParams({
                		type: 'Error',
                		message: 'Error fetching CTRCommitteeApprovalId',
            		});
            		toastEvent.fire();
                	}
        });
        $A.enqueueAction(action);
    },
})