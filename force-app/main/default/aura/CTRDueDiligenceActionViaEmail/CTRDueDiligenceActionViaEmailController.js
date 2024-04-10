({
    doInit : function(component, event, helper) {
        component.set('v.isSubmitted', false);
        component.set('v.canSubmit', true);
        component.set('v.isCancelled', false);
        helper.isEnhancedDueDiligenceValid(component);
    },

    handleSubmit : function(component, event, helper) {
        console.log('[handleSubmit] dueDiligenceComment -----', component.get('v.dueDiligenceComment'));
        component.set("v.isLoaded", false);
        if(!$A.util.isEmpty(component.get('v.dueDiligenceComment'))) {
            helper.saveActionViaEmail(component);
        } else {
            component.set("v.isLoaded", true);
            console.log('[handleSubmit] -----', 'Please complete all required fields.');
            alert('Please complete all required fields.');
        }
    },

    handleCancel : function(component, event, helper) {
        component.set('v.isCancelled', true);
    },
})