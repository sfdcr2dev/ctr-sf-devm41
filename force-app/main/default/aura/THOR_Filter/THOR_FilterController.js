({
    doInit: function (component, event, helper) {
        helper.getExcludedFilter(component);
    },

    optionSelected: function (component, event, helper) {

        let clickedOption = event.target.id;

        component.set("v.clickedOption", clickedOption);

        helper.getContent(component);

    },

    showFilterOptions: function (component, event, helper) {

        if (!component.get("v.filterActive")) {
            component.set("v.filterActive", true);
            component.set("v.viewFilterOptions", true);
        } else {
            component.set("v.filterActive", false);
            component.set("v.clickedOption", "");
            helper.getContent(component);
        }
    },

    showDateFilter: function (component, event, helper) {

        component.set("v.dateFilterActive", true);
        component.set("v.viewDateFilter", true);
    },

    filterByResposible: function (component, event, helper) {

        if (!component.get("v.userFilterActive")) {
            component.set("v.userFilterActive", true);
        } else {
            component.set("v.userFilterActive", false);
        }

        helper.getContent(component);
    },

    submit: function (component, event, helper) {
        helper.getContent(component);
    },

    clear: function (component, event, helper) {
        component.set("v.dateFilterActive", false);
        component.set("v.fromDateFilter", null);
        component.set("v.toDateFilter", null);
        helper.getContent(component);
    },
})