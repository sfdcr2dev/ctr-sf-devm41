({
	checkWriteAccess : function(component) {
        var pageRef = component.get("v.pageReference");
        if (pageRef) {
            var recordId = pageRef.state.c__recordId;
            component.set("v.recordId", recordId);
        }
		let action = component.get('c.hasWriteAccess');
        
        action.setParams({
            recordId: recordId
        });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.hasWriteAccess', response.getReturnValue());
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " +
                                      errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
	},
    
    getRelatedObjects: function(component) {
        var pageRef = component.get("v.pageReference");
        if (pageRef) {
            var recordId = pageRef.state.c__recordId;
            component.set("v.recordId", recordId);
        }
        var action = component.get("c.getRelatedObjects");
        action.setParams({
            notificationIdentifier: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var labelSequence = '';
                var returnedlist = response.getReturnValue().relatedItems;
                if (returnedlist.length > 0) {
                    returnedlist[0].dropableBody.forEach(element => {
                        labelSequence += ', ' + element.label;
                    });
                }
                if (labelSequence != '') {
                    labelSequence = labelSequence.substring(1);
                }
                component.set("v.DisplayableObjectFullList", returnedlist);
                component.set("v.totalCards", "Items");
                component.set("v.labelSequence", labelSequence);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.isLoading", false);
        });
        component.set("v.isLoading", true);
        $A.enqueueAction(action);
    }
})