({
    doInit: function (component, event, helper) {
        console.log('Do init', component.get('v.recordId'), JSON.stringify(component.get('v.recordHeader')), component.get('v.sObjectName'));
        if (component.get('v.recordHeader')) {
            component.set('v.recordHeaderId', component.get('v.recordHeader').Id);
        }

        console.log('Before get default item',component.get('v.recordId'))
        if(component.get('v.sObjectName') == 'Account') { // edit from item detail screen
            helper.handleDefaultId(component, event, helper);
        } else {
            helper.getDefaultData(component, event, helper);
        }
        console.log('Initial ship to form ')
    },

    handleRecordUpdated: function (component, event, helper) {
        console.log('Start load record')
        const loadRecord = component.get("v.targetRecord");
        component.set("v.recordOwner", loadRecord != null ? loadRecord.Owner.Name : null);
        console.log('Debug load record', component.get('v.recordOwner'), JSON.parse(JSON.stringify(component.get("v.targetRecord"))));
    },

    handleLoad: function (component, event, helper) {
        console.log('Debug load ',component.get('v.useSObjectName'),component.get('v.defaultInputRecordId'))
        // component.set('v.showSpinner', false);
    },

    handleSuccess: function (component, event, helper) {
        console.log('Handle success form')
        event.preventDefault();
        const formData = event.getParam('fields');
        console.log('Handle success form after', JSON.stringify(formData))
    },

    handleError: function (component, event, helper) {
        console.log('Handle error form')
    },

    handleSubmit: function (component, event, helper) {
        helper.submitRequestShipTo(component, event, helper);
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

    handleAddJsonHeader: function(component, event, helper) 
    {
        helper.validateField(component, event, helper);
        if(component.get('v.sObjectName') != 'Account' && component.get('v.requestType').includes('Edit'))
        {
            helper.addFieldChangeToJson(component,event,'Header');
        }
    },
    handleAddJsonItem: function(component, event, helper) 
    {
        helper.validateField(component, event, helper);
        if(component.get('v.sObjectName') != 'Account' && component.get('v.requestType').includes('Edit'))
        {
            helper.addFieldChangeToJson(component,event,'Item');
        }
    },
})