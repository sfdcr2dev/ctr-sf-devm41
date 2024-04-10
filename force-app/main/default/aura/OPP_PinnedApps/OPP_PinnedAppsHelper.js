({
    getApplications : function(component, event, helper) {
        var action = component.get("c.getApplications");
        if(action) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    helper.getDefaultApplications(component, event, helper);
                    component.set("v.applications", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
    },
    getDefaultApplications : function(component, event, helper) {
        var action = component.get("c.getDefaultApplications");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var deApps = [];
                var apps = response.getReturnValue();
                apps.forEach(function(item) {
                    if(!$A.util.isUndefinedOrNull(item.OPP_Application__c)) {
                        deApps.push(item.OPP_Application__c);
                    }
                })
                component.set("v.deApps", deApps);
            }
        });
        $A.enqueueAction(action);
    },
    getCountApplications : function(component, event, helper) {
        var action = component.get("c.getCountApplications");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.count", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    updateApplication : function(component, event, helper) {
        var count = component.get("v.count");
        var checked = event.target.checked;
        var id = event.target.id;
        var deApps = component.get("v.deApps");
        if(checked) {
            if(count <= 5) {
                deApps.push(id);
                component.set("v.deApps", deApps);
                count++;
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": "You cannot add the favorite applications more than six applications"
                });
                toastEvent.fire();
                document.getElementById(id).checked = false;
            }
        }
        else {
            var newDeApps = deApps.filter(function(value, index, arr) {
                return value != id;
            });
            count--;
            component.set("v.deApps", newDeApps);
        }
        component.set("v.count", count);
    },
    loadCategories: function (component, event, helper) {
        var action = component.get("c.getCategoryPicklistValuesIntoList");

        action.setCallback(this, function(response) {
			var state = response.getState();
            
            if (state === "SUCCESS") {

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
        var action = component.get("c.getNotificationApplications");

        action.setCallback(this, function(response) {
			var state = response.getState();
            
            if (state === "SUCCESS") {
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
                
                component.set("v.applicationNotifications", response.getReturnValue())
            }
        });
        
        $A.enqueueAction(action);
    },
    save : function(component, event, helper) {
        var deApps = component.get("v.deApps");
        var action = component.get("c.updateFavApps");
        action.setParams ({
            'jsonString' : JSON.stringify(deApps)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success!',
                    message : 'Your favorite applications have updated!',
                    duration : '5000',
                    key : 'info_alt',
                    type : 'success',
                    mode : 'pester'
                });
                toastEvent.fire();

                var evt = $A.get("e.force:navigateToURL");
                evt.setParams({
                    url: "/lightning/n/spacex"
                });
                evt.fire();
            }
        });
        $A.enqueueAction(action);
    }
})