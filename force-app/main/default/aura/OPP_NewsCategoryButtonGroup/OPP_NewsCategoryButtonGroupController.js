({
    init : function(component, event, helper) {
        helper.loadCategories(component, event, helper);
    },

    selectedCategoryChanged : function(component, event, helper) {
        var value = event.getSource().get("v.value");
        component.set("v.selectedCategory", value);

        var action = component.get("c.fireNewsCategoryChangedEvent");
        $A.enqueueAction(action);
    },

    fireNewsCategoryChangedEvent : function(component, event, helper) {
        var selectedCategory = component.get("v.selectedCategory");
        var appEvent = $A.get("e.c:OPP_NewsCategoryChangedEvent");
        appEvent.setParams({ "category": selectedCategory });
        appEvent.fire();
    },
})