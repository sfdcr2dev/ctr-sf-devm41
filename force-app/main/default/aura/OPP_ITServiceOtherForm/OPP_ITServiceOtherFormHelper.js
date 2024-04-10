({
    getCase: function (component, event, helper) {
        var action = component.get("c.getOtherCase");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.case", result);
            }
            else {
                var error = response.getError();
                error.forEach(e => console.error(e))
            }
        });
        $A.enqueueAction(action);
    },
    getIsEmployee: function (component) {
        var action = component.get("c.isEmployee");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.isEmployee", result);
            }
        });
        $A.enqueueAction(action);
    },
    getDescribeFieldResult: function (component, sObjectName, fields) {
        var action = component.get("c.getDescribeFieldResult");
        action.setParams({
            sObjectName: sObjectName,
            fields: fields
        })
        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set(`v.describeFields.${sObjectName}`, result);
            }
            else {
                var error = response.getError();
                console.error(error);
            }
        });
        $A.enqueueAction(action);
    },
})