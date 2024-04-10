({
    doInit : function(component, event, helper) {
        helper.validateUserProfile(component);
    },
    
    handleCancel : function(component, event, helper) {
        helper.closeModal(component);
    },

    handleConfirm : function(component, event, helper) {
        helper.updateRequestFormStatus(component);
    },
})