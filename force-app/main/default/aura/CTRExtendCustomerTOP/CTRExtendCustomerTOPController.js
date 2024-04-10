({
    doInit: function(component, event, helper) {
        console.log('[doInit] recordId -----', component.get('v.recordId'));
        console.log('[doInit] isSupplier -----', component.get('v.requestType').includes('Supplier'));
        if(!$A.util.isEmpty(component.get('v.requestType')) && component.get('v.requestType').includes('Supplier')) {
            component.set('v.isSupplier', true);
            component.set('v.interestProductField', 'InterestedProductTypeAsSupplierTOP__c');
        } else {
            component.set('v.interestProductField', 'InterestedProductTypeAsCustomerTOP__c');
        }

        if(!$A.util.isEmpty(component.get('v.recordId'))) {
            component.set('v.isEdit', true);
        }

        if(component.get('v.isEdit')) {
            if(!$A.util.isEmpty(component.get("v.recordHeader"))) {
                console.log('[doInit] recordHeader -----', Object.assign({}, component.get("v.recordHeader")));
                component.set('v.headerRecordId', component.get('v.recordHeader.Id'));
                component.set('v.ownerId', component.get('v.recordHeader.OwnerId'));
            }
            if(!$A.util.isEmpty(component.get("v.recordObject"))) {
                component.set('v.recordTypeId', component.get('v.recordObject.RecordTypeId'));
                component.set('v.requestType', component.get('v.recordObject.RecordType.Name'));
                component.set('v.selectedProductType', component.get('v.recordObject.' + component.get('v.interestProductField')));
                if(!component.get('v.isSupplier')) {
                    helper.retrieveDistributionChannel(component, component.get('v.recordObject.SalesOrganizationTOP__c'));
                    component.set('v.selectedDistributionChannel', component.get('v.recordObject.DistributionChannel__c'));
                }
                helper.setDynamicFields(component);
            }
        } else {
            helper.getCurrentUser(component);
        }
        helper.getPicklistValue(component);
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

    handleLoadItem: function(component, event, helper) {
        console.log('[handleLoadItem] -----');
        if(!component.get('v.isEdit')) {
            var editFormItemFields = component.find("editFormItemField");
            for(var i=0; i<editFormItemFields.length; i++) {
                var fieldName = editFormItemFields[i].get('v.fieldName');
                if(fieldName == 'Division__c') {
                    editFormItemFields[i].set('v.value', '00');
                } else if(fieldName == 'Customer__c') {
                    editFormItemFields[i].set('v.value', component.get('v.customerId'));
                }
            }
        }
    },

    handleLoadHeader: function(component, event, helper) {
        console.log('[handleLoadHeader] -----');
        // if(!component.get('v.isEdit')) {
            helper.prepopulateHeader(component);
        // }
    },

    handlePicklistvalues: function(component, event, helper) {
        console.log('[handlePicklistvalues] data -----', Object.assign({}, event.getParam('data')));
        var data = event.getParam('data');
        if(!$A.util.isEmpty(data)) {
            component.set('v.productTypeOptions', data.values);
        }
        component.set('v.isLoaded', true);
    },

    handleInterestProductCustomerChange: function(component, event, helper) {
        console.log('[handleInterestProductCustomerChange] -----');
        helper.setDynamicFields(component);
        component.set('v.isNotOtherProduct',true);
        helper.retrieveSalesOrgMapping(component);
        if(component.get('v.selectedProductType'))
        {
            if(component.get('v.selectedProductType').includes('Other'))
            {
                component.set('v.isNotOtherProduct',false);
            }
        }
    },

    handleSalesOrgChange: function(component, event, helper) {
        var selectedSalesOrg = event.getSource().get("v.value");
        console.log('[handleSalesOrgChange] selectedSalesOrg -----', selectedSalesOrg);
        helper.retrieveDistributionChannel(component, selectedSalesOrg);
    },

    handleInterestProductSupplierChange: function(component, event, helper) {
        console.log('[handleInterestProductSupplierChange] -----');
        helper.setDynamicFields(component);
        component.set('v.isNotOtherProduct',true);
        helper.retrieveSalesOrgMapping(component);
        if(component.get('v.selectedProductType'))
        {
            if(component.get('v.selectedProductType').includes('Other'))
            {
                component.set('v.isNotOtherProduct',false);
            }
        }
    },

    handlePurchaseOrgChange: function(component, event, helper) {
        var selectedPurchaseOrg = event.getSource().get("v.value");
        console.log('[handlePurchaseOrgChange] selectedPurchaseOrg -----', selectedPurchaseOrg);
        var editFormItemFields = component.find("editFormItemField");
        for(var i=0; i<editFormItemFields.length; i++) {
            var fieldName = editFormItemFields[i].get('v.fieldName');
            if(fieldName == 'CompanyCodeTOP__c') {
                editFormItemFields[i].set('v.value', selectedPurchaseOrg);
                break;
            }
        }
    },

    handleCancel : function(component, event, helper) {
        helper.closeFocusedTab(component);
    },
})