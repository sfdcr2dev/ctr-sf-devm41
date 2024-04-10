({
    connectPC : function(component, event, helper) {
        var action = component.get("c.AuthenToTopauth");
        action.setParams ( { redirectURL : "https://pconboard.thaioilgroup.com" } )
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var value = response.getReturnValue();
                console.log(value)
                if(value != 'Error') {
                    component.set("v.urlPC", value);
                }
            }
        });
        $A.enqueueAction(action);
    },
    connectKPI : function(component, event, helper) {
        var action = component.get("c.AuthenToTopauth");
        action.setParams ( { redirectURL : "https://pro.thaioilgroup.com/kpi/ui_menu_report.aspx?" } )
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var value = response.getReturnValue();
                console.log(value)
                if(value != 'Error') {
                    component.set("v.urlKPI", value);
                }
            }
        });
        $A.enqueueAction(action);
    },
    connectMF : function(component, event, helper) {
        var action = component.get("c.AuthenToTopauth");
        action.setParams ( { redirectURL : "https://mfkpi.thaioilgroup.com/mfkpi" } )
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var value = response.getReturnValue();
                console.log(value)
                if(value != 'Error') {
                    component.set("v.urlMF", value);
                }
            }
        });
        $A.enqueueAction(action);
    },
})