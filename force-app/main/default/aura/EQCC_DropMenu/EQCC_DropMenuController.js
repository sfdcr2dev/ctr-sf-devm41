({
    handleSelect: function(component, event) {
        let selectedMenuItemValue = event.getParam("value");
        component.set("v.selected", selectedMenuItemValue);
    },
    itemsChange: function(component) {
        let selectedMenuItemValue = component.get("v.selected");
        if(selectedMenuItemValue === '') component.set("v.iconName", 'utility:steps');
        if(selectedMenuItemValue === 'Pass') component.set("v.iconName", 'utility:success');
        if(selectedMenuItemValue === 'Not Pass') component.set("v.iconName", 'utility:clear');
        if(selectedMenuItemValue === 'NA') component.set("v.iconName", 'utility:dash');
    }
})