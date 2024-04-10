({
    doInit: function (component, event, helper) {
        // Clear values
        component.set("v.records", [{}])
        component.set("v.recordsOther", [{}])

        helper.getCase(component, event, helper);
        helper.getIsEmployee(component);
        helper.getDescribeFieldResult(component, 'Case', ['Creator_Email__c', 'Software_Type__c', 'Hardware_to_install__c'])
        helper.getDescribeFieldResult(component, 'OPP_Case_Line_Items__c', ['OPP_Software_Asset__c', 'Software_Other__c', 'Asset_Owner__c', 'OPP_IT_Asset__c'])
        helper.getPicklistValuesMap(component, 'Case', 'Software_Type__c');
        helper.getPicklistValuesSoftwareAsset(component);
        helper.getCaseRecordTpyeInfoes(component, event, helper);
        
    },
    preventBlock: function (component, event, helper) {
        event.preventDefault();
    },
    handleAutoApproval: function (component, event, helper) {
        component.set('v.autoApproval', true);
        component.find('utilityLwcButton').submit_click();
    },
    handleSubmit: function (component, event, helper) {
        event.preventDefault();
        var isValid = true;
        var fields = event.getParam("fields");
        fields.Auto_Submit__c = component.get('v.autoApproval')
        component.set('v.autoApproval', false);
		console.log(fields)
        // OPP Case line item - IT Asset
        var ITAssetItem = component.find('ITAssetItem')
        ITAssetItem = Array.isArray(ITAssetItem) ? ITAssetItem : [ITAssetItem]
        isValid = ITAssetItem.reduce(function (isValid, item) {
            item.showHelpMessageIfInvalid()
            item.focus()
            return isValid && item.checkValidity()
        }, isValid)
        if (!isValid) return;

        component.set("v.isLoading", true)
        component.find('softwareForm').submit(fields);
    },
    closeModal: function (component, event, helper) {
        helper.hanldeAfterCloseModal(component, event, helper)
    },
    handleSuccess: function (component, event, helper) {
        helper.createCaseLineItem(component, event, helper);


    },
    handleError: function (component, event, helper) {
        component.set('v.isLoading', false)


    },
    handleAdd: function (component, event, helper) {
        var softwareType = component.get('v.case.Software_Type__c')
        if (['Standard Software', 'Specific Software'].includes(softwareType)) {
            component.set("v.records", [
                ...component.get("v.records"),
                {}
            ]);
        }
        else if (softwareType == 'Other') {
            component.set("v.recordsOther", [
                ...component.get("v.recordsOther"),
                {}
            ]);
        }
    },
    handleRemove: function (component, event, helper) {
        var index = event.target.name;
        if (index && component.get("v.records.length") > 1) {
            component.get("v.records").splice(index, 1);
            component.set("v.records", component.get("v.records"));
        }
    },
    handleRemoveOther: function (component, event, helper) {
        var index = event.target.name;
        if (index && component.get("v.recordsOther.length") > 1) {
            component.get("v.recordsOther").splice(index, 1);
            component.set("v.recordsOther", component.get("v.recordsOther"));
        }
    },
    handleITAssetOwnerItem: function (component, event, helper) {
        var cmptarget = event.getSource();
        var requesterId = cmptarget.get('v.value')
        requesterId = Array.isArray(requesterId) ? requesterId[0] : requesterId
        var index = cmptarget.get('v.class').split(' ')[0];

        if (['Standard Software', 'Specific Software'].includes(component.get('v.case.Software_Type__c'))) {
            component.set(`v.records.${index}.OPP_IT_Asset__c`, null);
        } else {
            component.set(`v.recordsOther.${index}.OPP_IT_Asset__c`, null);
        }

        helper.getPicklistValuesITAsset(component, requesterId, index);

    },
    handleSoftwareAsset: function (component, event, helper) {
        var value = event.getSource().get("v.value")
        var index = event.getSource().get("v.name");
        // console.log(value, index, component.get(`v.picklistMap.Case.SoftwareAssetTemp.${component.get('v.picklistMap.Case.SoftwareAssetTemp').findIndex(f => f.Id === value)}.Price`))
        var cmpDisplay = component.find('price_software')
        cmpDisplay = Array.isArray(cmpDisplay) ? cmpDisplay : [cmpDisplay]
        cmpDisplay[index].set('v.value', component.get(`v.picklistMap.Case.SoftwareAssetTemp.${component.get('v.picklistMap.Case.SoftwareAssetTemp').findIndex(f => f.Id === value)}.Price`))
    },
    handlesoftwareType: function (component, event, helper) {
        var cmp = event.getSource();
        var price_software = component.find('price_software')
        if (price_software) {
            price_software = Array.isArray(price_software) ? price_software : [price_software]
            price_software.forEach(e => e.set('v.value', ''))
        }
        
        
        /*
        var developName = ['Standard Software', 'Specific Software']
            .includes(component.get('v.case.Software_Type__c'))
            ? '_SW'
            : '_SW_NON'
        */
        // Set default record type and onchnage
        //component.set(`v.case.RecordTypeId`,
        //    component.get(`v.recordTypeIdsMap.${developName}.recordTypeId`));

        var requesterType = component.get('v.case.Requester_Type__c');
        if (requesterType) {
            var requester = requesterType.replace('Section Head', 'SectHead').trim();
            console.log(requester);
            helper.changeRecordType(component, requester);
        } else {
            component.set('v.case.RecordTypeId', null);
        }

        // fitler Software asset by standard or specific type
        component.set("v.picklistMap.Case.SoftwareAssetTemp",
            component.get('v.case.Software_Type__c') === 'Standard Software'
                ? component.get('v.picklistMap.Case.SoftwareAsset')
                    .filter(f => f.License_Type__c && f.License_Type__c.includes('Standard Software1'))
                // Is not standard software
                : component.get('v.picklistMap.Case.SoftwareAsset')
                    .filter(f => f.License_Type__c && !f.License_Type__c.includes('Standard Software1'))
        )

    },
    
	handleRequester: function (component, event, helper) {
		helper.getRequesterType(component, component.get('v.case.Requester__c'));
	},
})