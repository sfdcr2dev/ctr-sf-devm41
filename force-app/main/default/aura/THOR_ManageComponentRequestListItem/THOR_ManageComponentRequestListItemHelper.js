({
    updateQuantity: function (component) {
        let updateQuantityEvt = component.getEvent("updateQuantity");
        updateQuantityEvt.setParams({
            itemId: component.get("v.recordId"),
            newQuantity: component.get("v.quantity")
        });
        updateQuantityEvt.fire();
    },

    updateSelection: function (component) {
        let componentSelectEvt = component.getEvent("componentSelect");
        componentSelectEvt.setParams({
            recordId: component.get("v.recordId"),
            selected: component.get("v.selected")
        });
        componentSelectEvt.fire();
    }
});