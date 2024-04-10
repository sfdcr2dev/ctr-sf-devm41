({
    retireveRelated : function(component, event) {
          
        let action = component.get("c.getWorkClearance");
        
        let id =component.get("v.recordId");

        action.setParams({ notificationIdentifier : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                // let relatedWorkClearances = [];
                // let returnValue = response.getReturnValue();
                // for(var key in returnValue){
                //     relatedWorkClearances.push(returnValue[key]);
                // }
                //component.set("v.RelatedWorkClearances", relatedWorkClearances);
                var value = response.getReturnValue();
                component.set("v.wcId", value.Id);
                component.set("v.workclearance", value);
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
            component.set("v.finishedLoading", "true");

            this.stopLoading(component);
        });
        
        $A.enqueueAction(action);
    },
    
    stopLoading : function(component) {
        var stopLoadingEvent = component.getEvent("stopLoadingEvent");
        stopLoadingEvent.setParams({
            "target": "stopLoading"
        });
        stopLoadingEvent.fire();
    }
})