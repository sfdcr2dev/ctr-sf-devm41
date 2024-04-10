({
    doInit: function (component, event, helper) {
        helper.component = component;
        helper.getRequestItem()
            .then($A.getCallback(function(returnValue) {
                helper.setRequestType(returnValue);
            }));
    },
})