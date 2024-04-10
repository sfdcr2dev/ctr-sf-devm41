({
	doInit : function(component, event, helper) {
        helper.setData(component);
        helper.getComplianceNews(component);
        component.set('v.openModal', true);
        component.set('v.isLoaded', true);
    },
    
    handleClose : function(component, event, helper) {
        helper.closeModal(component);
    }
})