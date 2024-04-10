({
    doInit : function(component, event, helper) {
        helper.retrieveDueDiligenceResult(component);
    },

    handleLinkToNewsClick : function(component) {
        console.log('[handleLinkToNewsClick] -----');
        component.set('v.openLinkToNewsModal', true);
    },

    handleLinkToNewsClose : function(component) {
        component.set('v.openLinkToNewsModal', false);
    },
    
    handleReload : function(component, event, helper) {
        var action = component.get("c.doInit");
        $A.enqueueAction(action);
    },

    handleReportLink : function(component, event, helper) {
        var reportLink = event.currentTarget.getAttribute('value');
        console.log('[handleReportLink] reportLink -----', reportLink);
        window.open(reportLink);
    },
})