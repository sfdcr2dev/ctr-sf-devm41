({

    doInit: function (component, event, helper) {
        helper.handleViewAll(component);

        helper.getContent(component);
    },

    handleViewAll: function (component, event, helper) {
        
        var key = event.getParam("key");
        if (key == 'viewAll') {
            var viewAll = event.getParam("viewAll");
            var target = event.getParam("target");

            if (target == component.get("v.target1")) {
                component.set('v.viewAll1', viewAll);
            } else if (target == component.get("v.target2")) {
                component.set('v.viewAll2', viewAll);
            } else if (target == component.get("v.target3")) {
                component.set('v.viewAll3', viewAll);                
            }
        }
        helper.handleViewAll(component);
    },

    handleFilterSelected: function (component, event, helper) {
        var target = event.getParam("target");
        if (target == 'filterSelected') {
            var filterSelected = event.getParam("key");
            component.set('v.filterSelected', filterSelected);
            
            var userFilterActive = event.getParam("userFilterActive");
            component.set('v.userFilterActive', userFilterActive);

            var fromDateFilter = event.getParam("fromDateFilter");
            component.set('v.fromDateFilter', fromDateFilter);
            var toDateFilter = event.getParam("toDateFilter");
            component.set('v.toDateFilter', toDateFilter);

            helper.getContent(component);
        }
    },
})