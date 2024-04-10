({
    retrieveRecordType : function(component) {
        console.log('[retrieveRecordType] recordObject -----', Object.assign({}, component.get("v.recordObject")));
        if(!$A.util.isEmpty(component.get("v.recordObject"))) {
            if(!$A.util.isEmpty(component.get("v.recordObject.RecordTypeId"))) {
                console.log(' recordType.DeveloperName -----', component.get('v.recordObject.RecordType.DeveloperName'));

                var mListFieldChanged = JSON.parse(component.get('v.recordObject.InternalEditField__c'));
                console.log(' recordType.InternalEditField__c -----', component.get('v.recordObject.InternalEditField__c'));
                if(mListFieldChanged)
                {
                    component.set('v.ChangedFieldForEDITItem',  mListFieldChanged)
                }
                if(component.get('v.recordObject.RecordType.DeveloperName').includes('Edit'))
                {
                    component.set('v.isEdit', true);
                }
                if(component.get('v.recordObject.RecordType.DeveloperName').includes('Extend'))
                {
                    component.set('v.isExtend', true);
                }
                component.set('v.recordTypeName', component.get('v.recordObject.RecordType.DeveloperName') );
                component.set('v.recordTypeId', component.get("v.recordObject.RecordTypeId"));
                this.checkRecordType(component, component.get('v.recordObject.RecordType.DeveloperName'));
                const comUtility = component.find('comUtility');
                comUtility.getPicklistValues('CTRRequestFormItem__c.' + component.get('v.interestProductField'), component.get('v.recordTypeId'));
            }
            if(!$A.util.isEmpty(component.get("v.recordObject." + component.get('v.interestProductField')))) {
                component.set("v.selectedProductType", component.get("v.recordObject." + component.get('v.interestProductField')));
            }
        }        
    },

    checkRecordType : function(component, recordType) {
        var isInitialCustomer = false;
        var isCustomer = false;
        var isSupplier = false;
        var interestProductField = 'InterestedProductTypeAsSupplierTX__c';
        if(recordType.includes('Customer'))
        {
            interestProductField = 'InterestedProductTypeAsCustomerTX__c';
            isCustomer=true;
        }
        else if(recordType.includes('Supplier'))
        {
            interestProductField = 'InterestedProductTypeAsSupplierTX__c';
            isSupplier=true;
        }
        // switch(recordType) {
        //     case 'CustomerInitial':
        //         isInitialCustomer = true;
        //         interestProductField = 'InterestedProductTypeAsCustomerTX__c';
        //         break;
        // }
        //component.set('v.isInitialCustomer', isInitialCustomer);
        component.set('v.isCustomer', isCustomer);
        component.set('v.isSupplier', isSupplier);
        component.set('v.interestProductField', interestProductField);
    },

    closeFocusedTab : function(component) {
        /*var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            $A.get("e.force:closeQuickAction").fire();
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
            $A.get('e.force:refreshView').fire();
        }).catch(function(error) {
            console.log('[handleCancel] error -----', error);
        });*/
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

    addFieldChangeToJson: function(component, event) 
    {
        if(component.get('v.recordTypeName'))
        {
        var source = 'Edit Detail';
        var label = event.getSource().get('v.id');
        var fieldName = event.getSource().get('v.fieldName');
        var value = String(event.getSource().get('v.value'));
        var fieldChangedList = component.get('v.ChangedFieldForEDITItem');
        if(value)
                {
                    value.replace("[", "");
                    value.replace("]", "");
                }
        console.log("label:"+label);
        console.log("fieldName:"+fieldName);
        console.log("value:"+value);
        if(!label)
        {
            label = event.getSource().get('v.label');
        }
        if(!fieldName)
        {
            fieldName = event.getSource().get('v.name');
        }
        
        console.log("label2:"+label);
        console.log("fieldName2:"+fieldName);

            var isExisted = false;
            for(var existing of fieldChangedList)
            {
                if(existing.Api == fieldName)
                {
                    existing.Label = label;
                    existing.Value = value;
                    existing.User = component.get('v.currentUserName');
                    existing.Source = source;
                    isExisted = true;
                }
            }
            if(isExisted == false)
            {
                var mJson = '{"Label":"'+label+'",'; 
                mJson += '"Api":"'+fieldName+'",';
                mJson += '"Source":"'+source+'",';
                mJson += '"User":"'+component.get('v.currentUserName')+'",';
                mJson += '"Value":"'+value+'"}';
                var mObj = JSON.parse(mJson);
                fieldChangedList.push(mObj);
            }
            console.log('field change: '+JSON.stringify(fieldChangedList));

            component.set('v.ChangedFieldForEDITItem', fieldChangedList);
        }
            
    },

    ProductMapping : function(component, ProductName, Type) 
    {
        var salesorg = '';
        if(Type == 'Customer')
        {
            switch (ProductName) {
                case 'Crude':
                    salesorg = '1100';
                    break;
                case 'Petroleum Products':
                    salesorg = '1100';
                    break;
                case 'Petrochemical Products':
                    salesorg = '1300';
                    break;
                case 'Lube Base Products':
                    salesorg = '1400';
                    break;
                case 'LABIX Products':
                    salesorg = '1700';
                    break;
            } 
        }
        else if (Type == 'Supplier')
        {
            switch (ProductName) {
                case 'Crude':
                    salesorg = '1100';
                    break;
                case 'B100/Ethanol':
                    salesorg = '1100';
                    break;
                case 'Petroleum and Components':
                    salesorg = '1100';
                    break;
                case 'Normal Paraffin':
                    salesorg = '1700';
                    break;
            } 
        }
        return salesorg;
    }
})