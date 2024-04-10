({
    close : function(component) {
        var closeEvent = component.getEvent('eqccCreationEvent');
        closeEvent.fire();
    },

    navigateToSheet : function(component, stepId) {
        component.find("navService").navigate({
            type: 'standard__component',
            attributes: {
                "componentName": "c__THOR_ApprovalSteps"
            },
            state: {
                "c__recordId": stepId,
                "c__forApprovals": false
            }
        });
        this.close(component);
    },

    getStepIdAndNavigate : function(component, headerSheetId) {
        let action = component.get("c.getIdOfCurrentStep");

        action.setParams({
            headerSheetId: headerSheetId
        });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let returnValue = response.getReturnValue();

                this.navigateToSheet(component, returnValue);
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
        });
        
        $A.enqueueAction(action);
    }
})