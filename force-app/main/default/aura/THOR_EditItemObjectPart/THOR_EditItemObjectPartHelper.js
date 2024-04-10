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

    getItemData : function(component, event) {
        let action = component.get("c.getItemById");
        action.setParams({
            itemId: component.get("v.itemId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let item = response.getReturnValue();
                component.set("v.objectPartValue", item.Object_Part_Code_Group__c);
                if (item) {
                    if (item.Object_Part_Code_Group__r) {
                        component.set("v.objectPartTextValue", item.Object_Part_Code_Group__r.Description__c);
                    }
                    component.set("v.objectPartCodeValue", item.Object_Part__c);
                    component.set("v.objectPartCodeTextValue", item.Object_Part_Code_Text__c);
                    component.set("v.damageCodeGroupValue", item.Damage_Code_Group__c);
                    if (item.Damage_Code_Group__r) {
                        component.set("v.damageCodeGroupTextValue", item.Damage_Code_Group__r.Description__c);
                    }
                    component.set("v.damageCodeValue", item.Damage__c);
                    component.set("v.damageCodeTextValue", item.DamageText__c);
                    component.set("v.textValue", item.Text__c);
                    component.set("v.integrationFlagValue", item.Integration_Flag__c);
                    component.set("v.integrationStatusValue", item.Integration_Status__c);
                }
                
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