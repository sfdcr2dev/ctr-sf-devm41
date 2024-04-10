({
    getApplications : function(component, event, helper) {
		var action = component.get("c.getApplications");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				component.set("v.applications", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},
    pinnedApps : function(component, event, helper) {
		var evt = $A.get("e.force:navigateToComponent");
		evt.setParams({
			componentDef: "c:OPP_PinnedApps"
		});
		evt.fire();
	},
})