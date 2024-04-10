({
    closeModal: function (component, reload) {
        var handleViewEvent = component.getEvent("closeModalEvent");
        handleViewEvent.setParams({
            "key": "closeModal"
        });
        handleViewEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    },

    closeConfirmation: function (component, reload) {
        var handleViewEvent = component.getEvent("closeModalEvent");
        handleViewEvent.setParams({
            "key": "closeConfirmation"
        });
        handleViewEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    },
})