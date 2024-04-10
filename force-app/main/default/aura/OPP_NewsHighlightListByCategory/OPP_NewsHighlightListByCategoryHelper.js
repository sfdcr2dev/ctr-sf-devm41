({
	loadPublishedNews: function (component, event, helper) {
        var category = component.get("v.category");
        var action = component.get("c.getPublishedNewsByCategory");
        
        action.setParams({ category: category });

        action.setCallback(this, function(response) {
			var state = response.getState();

            if (state === "SUCCESS") {
                component.set("v.news", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                console.log('loadPublishedNews: INCOMPLETE');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },
})