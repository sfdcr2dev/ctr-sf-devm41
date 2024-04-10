({
    doInit: function (component, event, helper) {
        helper.reInit(component, event, helper);
    },

    handleApprove : function(component, event, helper) {
        let scrollAction = component.get('c.scrollToTop');
        $A.enqueueAction(scrollAction);
        var stepId = component.get("v.eqccStepId");
        component.set('v.approvalAction', 'Approve');
        component.set("v.approvalActionText", 'Approve');
        component.set('v.isComment', true);
    },

    handleSubmit : function(component, event, helper){
        event.preventDefault(); // Prevent default submit
    },

    handleClose : function(component, event, helper){
        var commentArea = component.find("commentArea");

        if (commentArea){
            commentArea.set('v.value', '');
        }

        component.set('v.isComment', false);
    },

    handleRevision : function(component, event, helper) {
        let scrollAction = component.get('c.scrollToTop');
        $A.enqueueAction(scrollAction);
        var stepId = component.get("v.eqccStepId");
        component.set('v.approvalAction', 'Reject');
        component.set("v.approvalActionText", 'Revise');
        component.set('v.isComment', true);
    },

    handleReassign : function(component, event, helper) {
        let scrollAction = component.get('c.scrollToTop');
        $A.enqueueAction(scrollAction);
        var stepId = component.get("v.eqccStepId");
        component.set('v.approvalAction', 'Reassign');
        component.set("v.approvalActionText", 'Reassign');
        component.set('v.isComment', true);
    },

    scrollToTop: function() {
        var scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
    },

    handleApprovalAction : function(component, event, helper) {
        var stepId = component.get("v.eqccStepId");
        var currentAction = component.get('v.approvalAction');
        component.set('v.isComment', false);
        if (currentAction === 'Approve' || currentAction === 'Reject'){
            helper.submitApproveReject(component, event, helper, stepId, currentAction);
        }
        else{
            helper.submitReassign(component, event, helper, stepId, 'Reassign', component.get("v.reassignId"));
            component.find('notifLib').showToast({
                "variant": "success",
                "title": "Check Sheet Reassigned"
            });
            helper.canApprove(component, event, component.get('v.eqccStepId'));
        }
    },

    handleUserSelected: function(component, event, helper) {
        var target = event.getParam("target");
        if (target === 'User') {
            var key = event.getParam("key");
            component.set('v.reassignId', key);
        }
    },

    forceRefresh: function (component, event, helper) {
        $A.get("e.force:refreshView").fire();
    },
})