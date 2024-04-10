({
    getUser : function(component, event, helper) {
		var action = component.get("c.getUser");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				var value = response.getReturnValue();
				console.log(value.Profile.Name)
				if(value.Profile.Name == 'Operation') {
					component.set("v.operation", true);
				}
				else {
					component.set("v.operation", false);
				}
			}
		});
		$A.enqueueAction(action);
	},
})