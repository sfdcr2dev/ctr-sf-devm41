({
    getEmailUsers: function (component, event, helper) {
        var multiPicklist = component.get("v.multiPicklist");

        if (!multiPicklist || multiPicklist.length === 0) {
            var action = component.get("c.getEmailUsers");

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('fetching users SUCCESS ' +response.getReturnValue());
                    component.set("v.multiPicklist", response.getReturnValue());
                } else {
                    console.error("Error fetching users");
                }
            });

            $A.enqueueAction(action);
        }
    },

})