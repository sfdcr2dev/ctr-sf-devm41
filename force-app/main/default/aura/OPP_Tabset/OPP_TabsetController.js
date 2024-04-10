({
    doInit : function(component, event, helper) {
        helper.connectPC(component, event, helper);
        helper.connectKPI(component, event, helper);
        helper.connectMF(component, event, helper);
    }
})