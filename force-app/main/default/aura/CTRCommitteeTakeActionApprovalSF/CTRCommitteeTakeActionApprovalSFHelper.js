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
                const returnValue = response.getReturnValue();
                if(!returnValue){
                    this.closeModal(component);
                    this.toastEvent('Error','Do not have permission','error');
                } else {
                    component.set("v.CTRCommitteeApprovalId", response.getReturnValue());
                }
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
    closeModal: function (component) {
        const closeQuickAction = $A.get("e.force:closeQuickAction");
        if (closeQuickAction) {
            closeQuickAction.fire();
        }
        component.set("v.isModalOpen", false);
    },
    toastEvent : function(Title, Message, Type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": Title,
            "message": Message,
            "type": Type
        });
        toastEvent.fire();
    },
})