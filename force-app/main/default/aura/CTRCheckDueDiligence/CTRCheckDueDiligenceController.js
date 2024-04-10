({
    doInit : function(component, event, helper) {
        helper.retrieveRiskLevel(component);
    },

    handleCancel : function(component, event, helper) {
        helper.closeModal(component);
    },

    handleSave : function(component, event, helper) {
        helper.updateDueDiligence(component, 'save');
    },

    handleSubmit : function(component, event, helper) {
        helper.updateDueDiligence(component, 'submit');
    },

    handleRiskLevelClick : function(component, event, helper) {
        var fieldName = event.currentTarget.getAttribute('data-auraid');
        console.log('[handleRiskLevelClick] fieldName -----', fieldName);
        var value = event.currentTarget.getAttribute('value');
        console.log('[handleRiskLevelClick] value -----', value);
        helper.updateRiskLevel(component, fieldName, value);
    },

    handleRiskLevelBySystemChange : function(component, event, helper) {
        console.log('[handleRiskLevelBySystemChange] value -----', Object.assign({}, event.getParam("value")));
        var riskLevelBySystem = event.getParam("value");
        helper.updateRiskLevel(component, riskLevelBySystem.fieldName, riskLevelBySystem.value);
    },
})