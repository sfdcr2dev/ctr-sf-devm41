({
	init:function(component,event,helper){
        helper.getDetail(component,event,helper);
        var sobjecttype = component.get("v.sobjecttype");
    },
    openModelApprove: function(component, event, helper) {
        component.set("v.comment", '');
        component.set("v.checkBoxState", false);
        component.set("v.isModalApproveOpen", true);
    },
    closeModalApprove: function(component, event, helper) { 
        component.set("v.isModalApproveOpen", false);
        $A.get("e.force:closeQuickAction").fire();
    },
    approve: function(component, event, helper) {
        helper.goToApproval(component, event, helper,'Approve');
        component.set("v.isModalApproveOpen", false);
    },
    openModelReject: function(component, event, helper) {
        component.set("v.comment", '');
        component.set("v.checkBoxState", false);
        component.set("v.isModalRejectOpen", true);
    },
    closeModalReject: function(component, event, helper) { 
        component.set("v.isModalRejectOpen", false);
    },
    reject: function(component, event, helper) {
        helper.goToApproval(component, event, helper,'Reject');
        component.set("v.isModalRejectOpen", false);
    },
    openModelSendBack: function(component, event, helper) {
        component.set("v.comment", '');
        component.set("v.checkBoxState", false);
        component.set("v.isModalSendBackOpen", true);
    },
    closeModalSendBack: function(component, event, helper) { 
        component.set("v.isModalSendBackOpen", false);
    },
    sendBack: function(component, event, helper) {
        helper.goToApproval(component, event, helper,'Removed'); // Recall
        component.set("v.isModalSendBackOpen", false);
    },
    openModelHold: function(component, event, helper) {
        component.set("v.comment", '');
        component.set("v.isModalHoldOpen", true);
    },
    closeModalHold: function(component, event, helper) { 
        component.set("v.isModalHoldOpen", false);
    },
    hold: function(component, event, helper) {
        helper.goToApproval(component, event, helper,'Hold');
        component.set("v.isModalHoldOpen", false);
    },
    Showhide : function(component, event, helper) {
        let checkBoxState = event.getSource().get('v.value');
        component.find("disableenable").set("v.disabled", !checkBoxState);
    },
    showhideOther : function(component, event, helper) {
        let checkBoxState = event.getSource().get('v.value');
        var validity = component.find("comment").get("v.validity");
        component.set('v.checkBoxState', checkBoxState);
        if (validity.valid == true && checkBoxState == true) {
            component.find("disableenable").set("v.disabled", false);
        } else {
            component.find("disableenable").set("v.disabled", true);
        }
    },
    handleChange : function (component, event) {
        var checkBoxState = component.get("v.checkBoxState");
        var validity = component.find("comment").get("v.validity");
        if (validity.valid == true && checkBoxState == true) {
            component.find("disableenable").set("v.disabled", false);
        } else {
            component.find("disableenable").set("v.disabled", true);
        }
    },
    handleChangeHold : function (component, event) {
        var validity = component.find("comment").get("v.validity");
        if (validity.valid == true) {
            component.find("disableenable").set("v.disabled", false);
        } else {
            component.find("disableenable").set("v.disabled", true);
        }
    }
})