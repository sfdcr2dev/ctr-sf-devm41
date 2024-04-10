({ 
    loadCategories: function (component, event, helper) {
        var action = component.get("c.getCategoryPicklistValuesIntoList");

        action.setCallback(this, function(response) {
			var state = response.getState();
            
            if (state === "SUCCESS") {
                //alert("From server: " + response.getReturnValue());
                console.log(response.getReturnValue())

                component.set("v.categories", response.getReturnValue())
                
                helper.loadApplications(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
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
    
    loadApplications: function(component, event, helper) {
        var action = component.get("c.getActiveApplications");

        action.setCallback(this, function(response) {
			var state = response.getState();
            
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                //alert("From server: " + response.getReturnValue());
                console.log(response.getReturnValue())
                
                component.set("v.applications", response.getReturnValue())
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
                // 
                //helper.loadAlertsGroupByApplication(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
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
    
    loadAlertsGroupByApplication: function(component, event, helper) {
        var action = component.get("c.getActiveApplicationInCategory");

        action.setCallback(this, function(response) {
			var state = response.getState();
            
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                //alert("From server: " + response.getReturnValue());
                console.log(response.getReturnValue())
                
                component.set("v.alerts", response.getReturnValue())
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
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

    loadNotiApp: function(component, event, helper) {
        var action = component.get("c.getOtherApplications");

        action.setCallback(this, function(response) {
			var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.notifications", response.getReturnValue());
                component.set('v.lstContentDoc', response.getReturnValue());
                
                this.loadCountNotificationGroupByApplication(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
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
    
    loadCountNotificationGroupByApplication : function(component, event, helper) {
        var action = component.get("c.countNotificationGroupByApplication");

        action.setCallback(this, function(response) {
			var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                
                component.set("v.applicationNotifications", response.getReturnValue())
            }
        });
        
        $A.enqueueAction(action);
    },

})