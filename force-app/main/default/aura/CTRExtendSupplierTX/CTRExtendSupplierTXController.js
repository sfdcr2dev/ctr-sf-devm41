({
    doInit: function(component, event, helper) {
        helper.initialize(component);
        helper.getPicklistValue(component);
        helper.getCurrentUser(component)
            .then($A.getCallback(function(userId) {
                component.set('v.ownerId', userId);
            }));
    },

    toggleSection: function(component, event, helper) {
        var sectionAuraId = event.target.getAttribute("aria-controls");
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section');
        }
    },

    handleSubmit: function(component, event, helper) {
        event.preventDefault();
    },

    handleSaveRequest: function(component, event, helper) {
        return helper.saveRequest(component);
    },

    handleLoadHeader: function(component, event, helper) {
        console.log('[handleLoadHeader] -----');
        helper.prepopulateHeader(component);
    },
})