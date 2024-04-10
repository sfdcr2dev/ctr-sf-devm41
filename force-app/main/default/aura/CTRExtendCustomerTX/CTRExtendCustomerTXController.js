({
    doInit: function(component, event, helper) {
        console.log('[doInit] -----', component.get('v.recordId'));
        if(!$A.util.isEmpty(component.get('v.requestType')) && component.get('v.requestType').includes('Supplier')) {
            component.set('v.isSupplier', true);
            component.set('v.interestProductField', 'InterestedProductTypeAsSupplierTX__c');
        } else {
            component.set('v.interestProductField', 'InterestedProductTypeAsCustomerTX__c');
        }
        console.log(component.get('v.recordTypeId'))
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
                if(component.get('v.isSupplier')) {
                    component.set('v.selectedPaymentTerm', component.get('v.recordObject.PaymentTerm__c'));
                    component.set('v.selectedPaymentMethod', component.get('v.recordObject.PaymentMethod__c'));
                    helper.retrievePaymentMethodMapping(component, component.get('v.recordObject.CompanyCodeTX__c'));
                }
                helper.setDynamicFields(component);
            }
        } else {
            helper.getCurrentUser(component);
            helper.retrieveAccount(component);

            // if(!$A.util.isEmpty(component.get("v.recordObject"))) {
            //     if(component.get('v.isSupplier')) {
            //         helper.retrievePaymentMethodMapping(component, 'TX');
            //     }
            // }
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
            helper.prepopulateItem(component);
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
    },

    handleInterestProductSupplierChange: function(component, event, helper) {
        console.log('[handleInterestProductSupplierChange] -----');
        helper.setDynamicFields(component);
    },

    handleSalesOrgChange: function(component, event, helper) {
        var selectedSalesOrg = event.getSource().get("v.value");
        console.log('[handleSalesOrgChange] selectedSalesOrg -----', selectedSalesOrg);
    },

    handleCancel : function(component, event, helper) {
        helper.closeFocusedTab(component);
    },

    handleCompanyCodeChange: function(component, event, helper) {
        var selectedCompanyCode = event.getSource().get("v.value");
        console.log('[handleCompanyCodeChange] selectedCompanyCode -----', selectedCompanyCode);
        helper.retrievePaymentMethodMapping(component, selectedCompanyCode);
    },
    handleProductGroupNameClick: function(component, event, helper) {
        debugger
        window.open($A.get('$Resource.CTRTopGroupProductHierarchy'), '_blank');
    },

    handlePurchasingOrganizationChange: function(component, event, helper) {
        var selectedPurchasingOrganization = event.getSource().get("v.value");
        console.log('[handlePurchasingOrganizationChange] selectedPurchasingOrganization -----', selectedPurchasingOrganization);
        let CompanyCodeTX = '';
        
        if(selectedPurchasingOrganization == 'A000') {
            CompanyCodeTX = '2000';
        }
        else if(selectedPurchasingOrganization == 'H100') {
            CompanyCodeTX = '9100';
        }
        else if(selectedPurchasingOrganization == 'I100') {
            CompanyCodeTX = '9200';
        }
        else if(selectedPurchasingOrganization == 'S100') {
            CompanyCodeTX = '9300';
        }
        else if(selectedPurchasingOrganization == 'N100') {
            CompanyCodeTX = '9400';
        }

        component.find("editFormItemField").forEach(function(cmp) {
            var fieldName = cmp.get('v.fieldName');
            if(fieldName == 'CompanyCodeTX__c') {
                cmp.set('v.value', CompanyCodeTX);
                helper.retrievePaymentMethodMapping(component, CompanyCodeTX);
                return;
            }
        });
        
    },
    
})