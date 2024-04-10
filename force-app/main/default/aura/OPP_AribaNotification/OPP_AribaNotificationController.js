({
	doInit : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function () {
                var action = component.get("c.getMyPendingApprovables");
                action.setCallback(this, function(response) {
                    var state = response.getState();
                });
                $A.enqueueAction(action);
            }),
            500
        );
	}
})