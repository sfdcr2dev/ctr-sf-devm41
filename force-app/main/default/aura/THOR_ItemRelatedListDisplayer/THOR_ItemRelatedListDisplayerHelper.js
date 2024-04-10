({
    getCauses : function(component, event, _itemId) {
        var action = component.get("c.retrieveItemCauses");
        action.setParams({
            itemId: _itemId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();
                console.log(returnedlist);
                component.set("v.DisplayableObjectFullList", returnedlist);
                if (returnedlist && returnedlist.length) {
                    component.set("v.DisplayableObjectFullListCount", returnedlist.length);
                }
                component.set("v.labelSequence", "Cause Code Group, Cause Code, Code Text, Cause Text");

            } else if (state === "ERROR") {
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

    getActivities : function(component, event, _itemId) {
        var action = component.get("c.retrieveItemActivities");
        action.setParams({
            itemId: _itemId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();
                component.set("v.DisplayableObjectFullList", returnedlist);
                if (returnedlist && returnedlist.length) {
                    component.set("v.DisplayableObjectFullListCount", returnedlist.length);
                }
                component.set("v.labelSequence", "Activity Code Group, Activity Code, Code Text, Activity Text");

            } else if (state === "ERROR") {
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
    }
})