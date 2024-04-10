({
    getCauses : function(component, event) {
        var action = component.get("c.retrieveCauses");
        action.setParams({
            item: component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();

                if (returnedlist.length > 0) {
                    var labelSequence = 'Cause name';
                    returnedlist[0].dropableBody.forEach(element => {
                        labelSequence += ', ' + element.label;
                    });
                }

                component.set("v.DisplayableObjectFullList", returnedlist);
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
            
        });

        $A.enqueueAction(action);
    },

    getActivities : function(component, event) {
        var action = component.get("c.retrieveActivities");
        action.setParams({
            item: component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();

                if (returnedlist.length > 0) {
                    var labelSequence = 'Activity name';
                    returnedlist[0].dropableBody.forEach(element => {
                        labelSequence += ', ' + element.label;
                    });
                }

                component.set("v.DisplayableObjectFullList", returnedlist);
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
            
        });

        $A.enqueueAction(action);
    },

    getItems : function(component, event) {
        var action = component.get("c.retrieveItems");
        action.setParams({
            notificationId: component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();

                if (returnedlist.length > 0) {
                    var labelSequence = 'Activity name';
                    returnedlist[0].dropableBody.forEach(element => {
                        labelSequence += ', ' + element.label;
                    });
                }

                component.set("v.DisplayableObjectFullList", returnedlist);
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
            
        });

        $A.enqueueAction(action);
    }
})