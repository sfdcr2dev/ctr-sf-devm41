({
    // Utility class for closing custom modal.
    closeModal: function (component, event, helper) {
        component.find("overlayLib").notifyClose();
    },
})