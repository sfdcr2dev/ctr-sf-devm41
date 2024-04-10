({
    doInit: function (component, event, helper) {
        // Clear values
        component.set("v.records", [{}])

        helper.getCase(component, event, helper);
        helper.getIsEmployee(component);
        helper.getDescribeFieldResult(component, 'Case', ['Creator_Email__c']);
        helper.getDescribeFieldResult(component, 'OPP_Case_Line_Items__c', ['Incident_Item__c', 'Detail__c'])
        helper.getPicklistValuesMap(component, 'OPP_Case_Line_Items__c', 'Incident_Item__c')
    },
    closeModal: function (component, event, helper) {
        event.preventDefault();
        if (component.get('v.formFactor') === 'PHONE') {
            var navService = component.find('navService');
            navService.navigate({
                type: 'standard__webPage',
                attributes: {
                    url: '/apex/previous_back'
                }
            }, true);
        } else {
            var navigateToURL = $A.get("e.force:navigateToURL");
            navigateToURL.setParams({
                isredirect: true,
                url: "/lightning/n/DG_Service"
            });
            navigateToURL.fire();
        }
    },
    handleAutoApproval: function (component, event, helper) {
        component.set('v.autoApproval', true);
        component.find('utilityLwcButton').submit_click();
    },
    handleSubmit: function (component, event, helper) {
        event.preventDefault();
        var isValid = true

        var fields = event.getParam("fields");
        // fields.Auto_Submit__c = component.get('v.autoApproval') ? true : false;

        var incident_item = component.find('incident_item');
        incident_item = Array.isArray(incident_item) ? incident_item : [incident_item]
        isValid = incident_item.reduce((isValid, item) => {
            item.showHelpMessageIfInvalid()
            item.focus()
            return isValid && item.checkValidity()
        }, isValid)
        if (!isValid) return;

        component.set('v.isLoading', true);
        component.find("incidentform").submit(fields);
    },
    handleSuccess: function (component, event, helper) {
        helper.createCaseLineItem(component, event, helper)
    },
    handleError: function (component, event, helper) {
        component.set('v.isLoading', false)
    },
    handleAdd: function (component, event, helper) {
        component.set('v.records', [
            ...component.get('v.records'),
            {

            }
        ])
    },
    handleRemove: function (component, event, helper) {
        if (component.get('v.records.length') > 1) {
            component.get('v.records').splice(event.target.name, 1)
            component.set('v.records', component.get('v.records'))
        }
    },
})