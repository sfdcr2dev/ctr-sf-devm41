({
    retrieveCodeGroupsFiltered : function(component, event) {
        let action = component.get("c.getCauseCodeGroupsFiltered");
        action.setParams({
            NotiId: component.get("v.notificationId")
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let returnValue = response.getReturnValue();
                component.set("v.codeGroupsFiltered", returnValue);
                component.set("v.codeGroupsFilteredAndSearched", returnValue);
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

    retrieveCausesFiltered : function(component, event) {
        let action = component.get("c.getCausesFiltered");
        action.setParams({
            NotiId: component.get("v.notificationId"),
            codeGroupId: component.get("v.codeGroupId")
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let returnValue = response.getReturnValue()
                component.set("v.causesFiltered", returnValue);
                component.set("v.causesFilteredAndSearched", returnValue);

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

    retrieveCausesRelatedToItem : function(component, event) {
        let action = component.get("c.getCausesRelatedToItem");

        action.setParams({
            itemId: component.get("v.itemId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();
                component.set("v.causesRelatedToItem", returnedlist);
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
    
    prepareComponent: function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        if (pageRef) {
            var notificationId = pageRef.state.c__notificationId;
            var itemId = pageRef.state.c__itemId;
            component.set("v.notificationId", notificationId);
            component.set("v.itemId", itemId);
            
            component.set("v.labelSequence", "Cause Code Group, Cause Code, Code Text, Cause Text");
            helper.retrieveCodeGroupsFiltered(component, event);
            helper.retrieveCausesRelatedToItem(component, event);
        } else {
            component.set("v.labelSequence", "Cause Code Group, Cause Code, Code Text, Cause Text");
            helper.retrieveCodeGroupsFiltered(component, event);
            helper.retrieveCausesRelatedToItem(component, event);
            //helper.retrieveCausesFiltered(component, event);
        }
    },
    
    checkWriteAccess: function(component) {
        var pageRef = component.get("v.pageReference");
        if (pageRef) {
            var recordId = pageRef.state.c__itemId;
        }
        let action = component.get('c.hasWriteAccess');
        
        action.setParams({
            itemId: recordId
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

    getCauseData : function(component, event) {
        let action = component.get("c.getCauseById");
        action.setParams({
            causeId: component.get("v.causeId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let item = response.getReturnValue();
                component.set("v.integrationFlagValue", item.Integration_Flag__c);
                component.set("v.integrationStatusValue", item.Integration_Status__c);
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