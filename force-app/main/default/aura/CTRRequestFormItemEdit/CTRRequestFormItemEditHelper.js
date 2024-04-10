({
    retrieveBusinessUnitFromProfile : function(component) {
        component.set('v.isLoaded', false);
        //var action = component.get("c.getBUInfo");
        var action = component.get("c.onloadEditPage");
        action.setParams({
            "mRecordId": component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('[retrieveBusinessUnitFromProfile] result -----', result);
                if(!$A.util.isEmpty(result)) 
                {
                    if(result.mBuProfile)
                    {
                        component.set('v.businessUnit', result.mBuProfile);
                        component.set('v.recordHeader', result.mRequestHeader);
                        component.set('v.currentUserName', result.mCurrentUserName);
                        this.createModal(component);
                    }
                } else {
                    component.set('v.isLoaded', true);
                    this.showToast('Warning', 'warning', 'Business Unit not found');
                }

            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[retrieveBusinessUnitFromProfile] error -----', errors[0].message);
                        this.showToast('Error', 'error', errors[0].message);
                    }
                } else {
                    console.log('[retrieveBusinessUnitFromProfile] unknown error -----');
                    this.showToast('Error', 'error', 'Unknown error');
                }
                component.set('v.isLoaded', true);
            }
        });
        $A.enqueueAction(action);
    },

    createModal : function(component) {

        console.log('[createModal] ' + component.get('v.businessUnit') + ' -----', Object.assign({}, component.get('v.recordObject')));
        var businessUnit = component.get('v.businessUnit');
        var recordTypeName = component.get('v.recordObject.RecordType.DeveloperName');
        var recordTypeId = component.get('v.recordObject.RecordTypeId');
        var countrycode = component.get('v.recordObject.CTRRequestFormHeader__r.Country__r.Code__c');
        var modalBody;
        var recordHeader = component.get('v.recordHeader');
        var modalFooter;

        var item = component.get('v.recordObject');
        var componentName = 'c:CTRRequestFormItemEditTOP';
        var DefaultSalesOrg= item.SalesOrganizationTOP__c;
        var DefaultPurchasingOrg=item.PurchasingOrganizationTOP__c;
        var isOtherProducts = false;
        var wth = false;

        console.log('businessUnit ' + businessUnit + ' -----'+ recordTypeName);
        console.log('obj ' + component.get('v.recordObject') + ' -----'+ recordTypeId);
        switch (businessUnit) {
            case 'TOP':
                // if(recordTypeName.includes('Extend')) {
                //     componentName = 'c:CTRExtendCustomerTOP';
                // } else {
                    componentName = 'c:CTRRequestFormItemEditTOP';
                //}
                DefaultSalesOrg= item.SalesOrganizationTOP__c;
                DefaultPurchasingOrg=item.PurchasingOrganizationTOP__c;
                if((item.InterestedProductTypeAsCustomerTOP__c && item.InterestedProductTypeAsCustomerTOP__c.includes('Other')) || (item.InterestedProductTypeAsSupplierTOP__c && item.InterestedProductTypeAsSupplierTOP__c.includes('Other')))
                {
                    isOtherProducts = true;
                }
                break;
            case 'TX':
                // if(recordTypeName.includes('Extend')) {
                //     componentName = 'c:CTRExtendCustomerTX';
                // }
                if(recordTypeName.includes('ShipTo')) {
                    componentName = 'c:CTRRequestShipToForm';
                } else {
                    componentName = 'c:CTRRequestFormItemEditTX';
                }
                if(countrycode)
                {
                    if(countrycode == 'TH')
                    {
                        wth = true;
                    }
                }

                DefaultSalesOrg= item.SalesOrganizationTX__c;
                DefaultPurchasingOrg=item.PurchasingOrganizationTX__c;
                break;
            case 'LABIX':
                // if(recordTypeName.includes('Extend')) {
                //     componentName = 'c:CTRExtendCustomerTOP';
                // } else {
                    componentName = 'c:CTRRequestFormItemEditTOP';
                //}
                DefaultSalesOrg= item.SalesOrganizationTOP__c;
                DefaultPurchasingOrg=item.PurchasingOrganizationTOP__c;
                if((item.InterestedProductTypeAsCustomerTOP__c && item.InterestedProductTypeAsCustomerTOP__c.includes('Other')) || (item.InterestedProductTypeAsSupplierTOP__c && item.InterestedProductTypeAsSupplierTOP__c.includes('Other')))
                {
                    isOtherProducts = true;
                }
                break;
        } 

        console.log('[createModal] recordTypeId -----', recordTypeId);
        console.log('[createModal] recordHeader -----', JSON.stringify(recordHeader));
        console.log('[createModal] recordTypeName -----', recordTypeName);
        console.log('[createModal] componentName -----', componentName);
        if(recordTypeName == 'ShipToCheckCountry' || 
        (recordTypeName.includes('Edit') && businessUnit == 'TOP'))
        {
            componentName = 'c:CTRRequestFormItemEditStandard';
            console.log('recordTypeId-2--'+recordTypeId);
            $A.createComponents([
                [(componentName), {
                    recordId: component.get('v.recordId'),
                }]
            ],
            function(components, status) { 
                if(status === 'SUCCESS') {
                    modalBody = components[0];
                    console.log('[createModal] modalBody -----', modalBody);
                    component.find('overlayLib').showCustomModal({
                        header: 'Edit Detail',
                        body: modalBody,
                        // footer: modalFooter,
                        showCloseButton: true,
                        cssClass: 'my-modal,my-custom-class,my-other-class,mymodal,slds-modal_large',
                        closeCallback: function() {
                            // window.close();
                            var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": component.get('v.recordId'),
                                "slideDevName": "detail"
                                });
                            navEvt.fire();
                            window.setTimeout(
                                $A.getCallback(function() {
                                    console.log('refresh');
                                    window.location.reload(true);
                                }), 500
                            );

                        }
                    });
                }
            });
        }
        else
        {
            if(!$A.util.isEmpty(componentName)) {
                $A.createComponents([
                    [(componentName), {
                        recordId: component.get('v.recordId'),
                        sObjectName: component.get('v.sObjectName'),
                        recordHeader: recordHeader,
                        recordObject: component.get('v.recordObject'),
                        SalesOrg: DefaultSalesOrg,
                        PurchasingOrg: DefaultPurchasingOrg,
                        isOtherProducts: isOtherProducts,
                        bu: businessUnit,
                        currentUserName: component.get('v.currentUserName'),
                        Wth: wth,
                        requestType: recordTypeName
                    }]
                ],
                function(components, status) { 
                    if(status === 'SUCCESS') {
                        modalBody = components[0];
                        console.log('[createModal] modalBody -----', modalBody);
                        component.find('overlayLib').showCustomModal({
                            header: 'Edit Detail',
                            body: modalBody,
                            // footer: modalFooter,
                            showCloseButton: true,
                            cssClass: 'my-modal,my-custom-class,my-other-class,mymodal,slds-modal_large',
                            closeCallback: function() {
                                // window.close();
                                var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({
                                    "recordId": component.get('v.recordId'),
                                    "slideDevName": "detail"
                                    });
                                navEvt.fire();
                                window.setTimeout(
                                    $A.getCallback(function() {
                                        console.log('refresh');
                                        window.location.reload(true);
                                    }), 500
                                );
                            }
                        });
                    }
                });
            }
        }
        component.set('v.isLoaded', true);
    },

    showToast : function(title, type, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"type": type,
			"message": message
		});
		toastEvent.fire();
	},
    
})