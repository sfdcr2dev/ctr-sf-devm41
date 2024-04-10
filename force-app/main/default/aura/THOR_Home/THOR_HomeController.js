({
    /*
        https://rajvakati.com/2018/11/13/navigate-to-component-using-lightningnavigation/
    */
    init: function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__THOR_CalendarNavHelper",
            },
        };
        component.set("v.pageReference", pageReference);
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            component.set("v.navUrl", url ? url : defaultUrl);
        }), $A.getCallback(function(error) {
            component.set("v.navUrl", defaultUrl);
        }));
    },

    openCalendar : function(component, event, helper) {
        var navService = component.find("navService");
        // Uses the pageReference definition in the init handler
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    }
})