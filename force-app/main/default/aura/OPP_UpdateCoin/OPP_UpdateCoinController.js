({
	init : function(component, event, helper) {
        var action = component.get("c.getCoinBalance");
        action.setCallback(this, function(response) {
            var state = response.getState();
        });
        $A.enqueueAction(action);
    }
})