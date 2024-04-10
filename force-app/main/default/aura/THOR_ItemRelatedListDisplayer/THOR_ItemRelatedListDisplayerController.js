({
    doInit: function (component, event, helper) {
        var obj = component.get("v.objectName");
        var itemId = component.get("v.recordId");
        if (obj == "Causes") {
            helper.getCauses(component,event,itemId);
        } else {
            helper.getActivities(component,event,itemId);
        }    
    },
    handleViewAll: function (component) {
        var viewMoreLess = "Show less";
        
        component.set('v.viewAll', !component.get('v.viewAll'));

        if (!component.get("v.viewAll")) {
            viewMoreLess = component.get("v.viewAllTitle");
        }

        component.set("v.viewMoreLess", viewMoreLess);
    }
})