({
    doInit : function(component, event, helper) {
        component.set("v.isLoaded", true);
    },

    handleCancel : function(component, event, helper) {
        helper.closeModal(component);
    },

    handleConfirm : function(component, event, helper) {
        helper.performRejectRequestForm(component);
    },
})