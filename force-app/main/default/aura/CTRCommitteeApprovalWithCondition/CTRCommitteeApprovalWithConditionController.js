({
    doInit : function(component, event, helper) { 
        let action = component.get("c.getRecordType");
        console.log("Test doInit");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let returnValue = response.getReturnValue();
                console.log("returnValue : " + returnValue);
                component.set("v.recordTypeName", returnValue);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
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

            this.stopLoading(component);
        });
        
        $A.enqueueAction(action);
    },
})