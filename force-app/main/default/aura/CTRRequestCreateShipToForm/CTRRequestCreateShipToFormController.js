({
    doInit: function (component, event, helper) {
        // component.set('v.isInitial', true);
    },

    handleRecordUpdated: function (component, event, helper) {
        const loadRecord = component.get("v.targetRecord");
        component.set("v.recordOwner", loadRecord != null ? loadRecord.Owner.Name : null);
        console.log('Debug load record',component.get('v.recordOwner'), JSON.parse(JSON.stringify(component.get("v.targetRecord"))));
    },

    handleLoad: function (component, event, helper) {
        component.set('v.showSpinner', false);
    },

    handleSuccess: function (component, event, helper) {
        console.log('Handle success form')
        event.preventDefault();
        const formData = event.getParam('fields');
        console.log('Handle success form after',JSON.stringify(formData))
    },

    handleError: function (component, event, helper) {
        console.log('Handle error form')
    },

    handleSubmit: function (component, event, helper) {
       helper.submitCreateShipTo(component, event, helper); 
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

    validateField: function (component, event, helper) {
        var cmp = event.getSource();
        var fieldName = cmp.get('v.fieldName');
        var value = cmp.get('v.value');
        console.log('Debug validate ',fieldName,value)
        if(cmp.get("v.required") == true && cmp.get("v.disabled") == false && (value == null || value == '')) {
            console.log('Found error input ',fieldName,value)
            // if(!$A.util.hasClass(cmp,'slds-has-error')) {
                $A.util.addClass(cmp, "slds-has-error");
                $A.util.addClass(component.find('error-'+fieldName), "custom-error-enabled");
            // }
        } else {
            $A.util.removeClass(cmp, "slds-has-error");
            $A.util.removeClass(component.find('error-'+fieldName), "custom-error-enabled");
        }
    },
})