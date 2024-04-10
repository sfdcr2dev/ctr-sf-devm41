({
    getObjectPartCodeGroup : function(component, event) {
        let action = component.get("c.getObjectPartCodeGroup");
        action.setParams({
            notificationId: component.get("v.notificationId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let objectParts = response.getReturnValue();
                component.set("v.objectPartOptions", objectParts);
                component.set("v.objectPartsFilteredAndSearched", objectParts);
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
    },
    getObjectPartCode : function(component, event) {
        let action = component.get("c.getObjectPartCode");

        action.setParams({
            objectPartCodeGroupId: component.get("v.objectPartValue")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let objectPartCodes = response.getReturnValue();
                component.set("v.objectPartCodeOptions", objectPartCodes);
                component.set("v.objectPartCodesFilteredAndSearched", objectPartCodes);
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
    },
    getDamageCodeGroup : function(component, event) {
        let action = component.get("c.getDamageCodeGroup");
        action.setParams({
            notificationId: component.get("v.notificationId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let damageCodeGroups = response.getReturnValue();
                component.set("v.damageCodeGroupOptions", damageCodeGroups);
                component.set("v.damageCodeGroupsFilteredAndSearched", damageCodeGroups);
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
    },
    getDamageCode : function(component, event) {
        let action = component.get("c.getDamageCode");
        action.setParams({
            damageCodeGroupId: component.get("v.damageCodeGroupValue")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let damageCodes = response.getReturnValue();
                component.set("v.damageCodeOptions", damageCodes);
                component.set("v.damageCodesFilteredAndSearched", damageCodes);
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
    },
})