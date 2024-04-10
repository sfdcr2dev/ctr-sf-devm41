({
    taskPage : function(component, event, helper) {
		var evt = $A.get("e.force:navigateToURL");
		evt.setParams({
			url: "/lightning/n/opp_mytasks"
		});
		evt.fire();
	},
    getNotifications : function(component, event, helper) {
		var action = component.get("c.getCountNotifications");
        if (action) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    component.set("v.notifications", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);    
        }
	},
	getApplicationNames : function(component, event, helper) {
		var action = component.get("c.getApplicationNames");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				component.set("v.applications", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},
})