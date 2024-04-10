({
    doInit: function (component, event, helper) {
        helper.init(component, event, helper);
    },

    reInit: function (component, event, helper) {
        $A.get("e.force:refreshView").fire();
    },

    goBack: function (component, event, helper) {
        let goToComponent = component.get("goToComponent");
        let fromRecordId = component.get("v.fromRecordId");

        let pageRef = {
            type: "standard__component",
            attributes: {
                componentName: goToComponent
            },
            state: {
                c__recordId: fromRecordId
            }
        };
        navLink.navigate(pageRef, true);
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

            helper.init(component, event, helper);
        }
    },
});