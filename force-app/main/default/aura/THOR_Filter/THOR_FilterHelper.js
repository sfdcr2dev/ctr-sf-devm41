({
    getContent: function (component) {
        var clickedOption = component.get("v.clickedOption");
        var userFilterActive = component.get("v.userFilterActive");

        var fromDateFilter = component.get("v.fromDateFilter");
        var toDateFilter = component.get("v.toDateFilter");

        var filterSelectedEvent = component.getEvent("filterSelectedEvent");
        filterSelectedEvent.setParams({
            "target": "filterSelected",
            "key": clickedOption,
            "userFilterActive": userFilterActive,
            "fromDateFilter": fromDateFilter,
            "toDateFilter": toDateFilter
        });
        filterSelectedEvent.fire();

        component.set("v.viewFilterOptions", false);
        component.set("v.viewDateFilter", false);
    },

    getExcludedFilter: function (component) {
        var action = component.get("c.getExcludedFilter");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let excludedFilter = response.getReturnValue();
                
                component.set("v.excludedFilter", excludedFilter);
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