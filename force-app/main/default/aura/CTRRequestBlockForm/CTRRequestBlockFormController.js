({
    doInit: function (component, event, helper) {
        // component.set('v.isInitial', true);
    },

    handleLoad: function (component, event, helper) {
        component.set('v.showSpinner', false);
    },

    handleSuccess: function (component, event, helper) {
        console.log('Handle success form')
    },

    handleSubmit: function (component, event, helper) {
        helper.submitCreateRequest(component, event);
    },

    handleChangeValue: function (component, event, helper) {
        var label = event.getSource().get('v.id');
        var fieldName = event.getSource().get('v.fieldName');
        var value = event.getSource().get('v.value');
    },

    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        // -1 open/close section
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },

    closeModal: function (component, event, helper) {
        helper.closeModal(component);
    },
})