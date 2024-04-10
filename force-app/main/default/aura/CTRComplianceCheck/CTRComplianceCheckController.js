({
    doInit : function(component, event, helper) {
        helper.getShippingCountry(component);
    },
    
    handleCancel : function(component, event, helper) {
        helper.closeModal(component);
    },

    handleLoad : function(component, event, helper) {
        component.set("v.isLoaded", true);
    },

    handleSubmit : function(component, event, helper) {
        component.set("v.isLoaded", false);
        event.preventDefault();
        const fields = event.getParam("fields");
        fields.ComplianceCheckby__c = component.get("v.userRecordObject.Name");
        fields.ComplianceCheck__c = true;
        component.find('recordEditForm').submit(fields);
    },

    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        console.log('[handleSuccess] record -----', Object.assign({}, record));
        helper.validateRelatedShiptoAndShareholder(component);
    },

    handleError : function(component, event, helper) {
        console.log('[handleError] error -----', JSON.stringify(event.getParam("error")));
        helper.showToast('Error', 'error', event.getParam("message"));
        component.set("v.isLoaded", true);
    },

    addNewRowShipto : function(component, event, helper) {
        helper.createObjectDataShipto(component, event);
    },

    handleDeletedRowShipto : function(component, event, helper) {
        var index = event.getParam("indexVar");
        var shiptoList = component.get("v.shiptoList");
        shiptoList.splice(index, 1);
        component.set("v.shiptoList", shiptoList);
    },

    addNewRowShareholder : function(component, event, helper) {
        helper.createObjectDataShareholder(component, event);
    },

    handleDeletedRowShareholder : function(component, event, helper) {
        var index = event.getParam("indexVar");
        var shareholderList = component.get("v.shareholderList");
        shareholderList.splice(index, 1);
        component.set("v.shareholderList", shareholderList);
    },
})