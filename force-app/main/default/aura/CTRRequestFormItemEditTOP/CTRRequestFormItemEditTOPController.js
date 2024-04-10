({
    doInit: function (component, event, helper) {
        console.log('[doInit] recordId -----' + component.get('v.recordId'));
        helper.retrieveRecordType(component);
        component.set("v.DefaultSalesOrg", component.get("v.SalesOrg"));
        component.set("v.DefaultPurchasingOrg", component.get("v.PurchasingOrg"));
        console.log('default Sales org:'+component.get("v.DefaultSalesOrg"));
        console.log(' Sales org:'+component.get("v.SalesOrg"));
    },

    handleToggleSection: function (component, event, helper) {
        var sectionAuraId = event.currentTarget.getAttribute('data-auraid');
        console.log('[handleToggleSection] selectionAuraId -----', sectionAuraId);

        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        // console.log('[handleToggleSection] sectionDiv -----', sectionDiv);
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        // console.log('[handleToggleSection] sectionState -----', sectionState);
        // -1 open/close section
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section'); // slds-is-close 
        }
    },

    handlePicklistvalues : function(component, event, helper) {
        console.log('[handlePicklistvalues] data -----', Object.assign({}, event.getParam('data')));
        var data = event.getParam('data');
        if(!$A.util.isEmpty(data)) {
            component.set('v.productTypeOptions', data.values);
        }
        component.set('v.isLoaded', true);
    },

    handleLoad : function(component, event, helper) {
        component.set('v.isLoaded', true);
    },

    handleSubmit : function(component, event, helper) {
        component.set("v.isLoaded", false);
        event.preventDefault();

        // validate required fields
        var allValid = true;
        component.find('inputCustom').forEach(function(f) {
            console.log('f required -----', f.get('v.required'));
            console.log('f name -----', f.get('v.name'));
            console.log('f reportValidity -----', f.reportValidity());
            if(f.get('v.required')) {
                f.reportValidity();
                allValid = allValid && f.checkValidity();
            }
        });
        // var inputCustom = component.find('inputCustom');
        // inputCustom.reportValidity();
        // allValid = inputCustom.checkValidity();
        console.log('[handleSubmit] allValid -----', allValid);
        
        if(allValid) {
            var fields = event.getParam('fields');
            fields[component.get('v.interestProductField')] = component.get('v.selectedProductType');
            console.log('[handleSubmit] fields -----', Object.assign({}, fields));
            component.find('recordEditForm').submit(fields);
        } else {
            component.set("v.isLoaded", true);
            helper.showToast('Warning', 'warning', 'Please complete all required fields.');
        }
    },

    handleSuccess : function(component, event, helper) {
        component.set("v.isLoaded", true);
        helper.showToast('Success', 'success', 'Request Form Item has been updated successfully.');
        helper.closeFocusedTab(component);
    },

    handleError : function(component, event, helper) {
        component.set("v.isLoaded", true);
        console.log('error: '+JSON.stringify(event.getParams()));
        helper.showToast('Error', 'error', event.getParam("detail"));
    },

    handleCancel : function(component, event, helper) {
        helper.closeFocusedTab(component);
    },
    handleInterestProductCustomerChange : function(component,event,helper) 
    {
        var custproduct = component.get('v.selectedProductType');
        
        if (custproduct.includes("Lube Base Products")) 
        {
            component.set('v.isLube', true);
        }
        else 
        {
            component.set('v.isLube', false);
        }
        if (custproduct.includes("LABIX Products")) 
        {
            component.set('v.isLABIX', true);
        }
        else 
        {
            component.set('v.isLABIX', false);
        }
        if(custproduct.includes("Other Products"))
        {
            component.set('v.isOtherProductCustomer', true);
            component.set('v.isOtherProducts',true);
        }
        else
        {
            component.set('v.isOtherProductCustomer', false);
            component.set('v.isOtherProducts',false);
            //component.set('v.SalesOrg',component.get('v.DefaultSalesOrg'));
            var salesorg = helper.ProductMapping(component, custproduct, 'Customer');
            component.set('v.SalesOrg',salesorg);
        }

        
    },
    handleInterestProductSupplierChange : function(component,event,helper) 
    {
        var supplproduct = component.get('v.selectedProductType');
        if(supplproduct)
        {
            
            if(supplproduct.includes("Petroleum and Components"))
            {
                component.set('v.isPetroluem',true);
            }
            else
            {
                component.set('v.isPetroluem',false);
            }
            if(supplproduct.includes("Other Products"))
            {
                component.set('v.isOtherProductSupplier', true);

                component.set('v.isOtherProducts',true);
            }
            else
            {
                component.set('v.isOtherProductSupplier', false);

                component.set('v.isOtherProducts',false);
                var comCode = helper.ProductMapping(component, supplproduct, 'Supplier');
                component.set('v.PurchasingOrg',comCode);

            }
        }
        else
        {
            component.set('v.isOtherProducts',false);
            component.set('v.PurchasingOrg','');
        }

    },
})