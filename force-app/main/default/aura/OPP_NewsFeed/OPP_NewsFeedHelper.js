({
    getNews : function(component, event, helper) {
		var action = component.get("c.getNews");
		action.setParams ({
			'size': component.get("v.size"),
			'showAll': component.get("v.showAll")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				component.set("v.news", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},
	newPage : function(component, event, helper) {
		var evt = $A.get("e.force:navigateToURL");
		evt.setParams({
			url: "/lightning/n/opp_news"
		});
		evt.fire();
	},
})