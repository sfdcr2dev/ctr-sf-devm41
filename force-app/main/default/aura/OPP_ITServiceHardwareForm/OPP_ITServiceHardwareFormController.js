({
    doInit: function (component, event, helper) {
        // Clear values
        component.set("v.records", [{}])
        component.set("v.recordsOther", [{}])

        helper.getCase(component, event, helper);
        helper.getIsEmployee(component);
        helper.getDescribeFieldResult(component, 'Case', ['Creator_Email__c', 'Request_Type__c', 'Hardware_Type__c'])
        helper.getDescribeFieldResult(component, 'OPP_Case_Line_Items__c', ['Hardware_Item__c', 'Hardware_Other__c', 'Asset_Owner__c', 'OPP_IT_Asset__c'])
        helper.getPicklistValuesMap(component, 'Case', 'Request_Type__c');
        helper.getPicklistValuesMap(component, 'Case', 'Hardware_Type__c');
        helper.getPicklistValuesMap(component, 'OPP_Case_Line_Items__c', 'Hardware_Item__c');

        helper.getCaseRecordTpyeInfoes(component, event, helper)

    },
    closeModal: function (component, event, helper) {
        helper.hanldeAfterCloseModal(component, event, helper)
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
        // Clear error message
        helper.reportValidity(component, 'Borrow_Period_End_date__c', '')

        var fields = event.getParam("fields");
        fields.Auto_Submit__c = component.get('v.autoApproval')
        component.set('v.autoApproval', false);

        if (fields.Request_Type__c === 'Borrow') {
            if (fields.Borrow_Period_End_date__c < fields.Borrow_Period_Start_date__c || !fields.Borrow_Period_Start_date__c) {
                helper.reportValidity(component, 'Borrow_Period_End_date__c', 'Borrow End date must be more than Borrow start date')

                component.set("v.isLoading", false);
                isValid = false
            }
        }

        // OPP Case line item - IT Asset
        var hardwareItemCMP = component.find('hardware_item')
        hardwareItemCMP = Array.isArray(hardwareItemCMP) ? hardwareItemCMP : [hardwareItemCMP]
        isValid = hardwareItemCMP.reduce((isValid, item) => {
            item.showHelpMessageIfInvalid()
            item.focus()
            return isValid && item.checkValidity()
        }, isValid)

        // var assetownerItemCMP = component.find('assetowner_item')
        // assetownerItemCMP = Array.isArray(assetownerItemCMP) ? assetownerItemCMP : [assetownerItemCMP]
        // isValid = assetownerItemCMP.reduce(function (isValid, item) {
        //     item.reportValidity()
        //     return isValid && item.get('v.value')
        // }, isValid)

        if (!isValid) return;

        // successfully
        component.set("v.isLoading", true)
        component.find('hardware2Form').submit(fields);

    },
    handleSuccess: function (component, event, helper) {
        helper.createCaseLineItem(component, event, helper);


    },
    handleError: function (component, event, helper) {
        component.set('v.isLoading', false)


    },
    handleAdd: function (component, event, helper) {
        var hardwareType = component.get('v.case.Hardware_Type__c')

        if (hardwareType == 'Standard Hardware') {
            component.set("v.records", [
                ...component.get('v.records'),
                {}
            ]);
        }
        else if (hardwareType == 'Other Hardware') {
            component.set("v.recordsOther", [
                ...component.get('v.recordsOther'),
                {}
            ]);
        }
    },
    handleRemove: function (component, event, helper) {
        var index = event.target.name
        if (index && component.get("v.records.length") > 1) {
            component.get("v.records").splice(index, 1);
            component.set("v.records", component.get("v.records"))
        }
    },
    handleRemoveOther: function (component, event, helper) {
        var index = event.target.name
        if (index && component.get("v.recordsOther.length") > 1) {
            component.get("v.recordsOther").splice(index, 1);
            component.set("v.recordsOther", component.get("v.recordsOther"))
        }
    },
    handleAssetOwnerItem: function (component, event, helper) {
        var cmptarget = event.getSource();
        var requesterId = cmptarget.get('v.value')
        requesterId = Array.isArray(requesterId) ? requesterId[0] : requesterId
        var index = cmptarget.get('v.class').split(' ')[0];
        // console.log(index)
        if (component.get('v.case.Hardware_Type__c') == 'Standard Hardware') {
            component.set(`v.records.${index}.OPP_IT_Asset__c`, null);
        } else if (component.get('v.case.Hardware_Type__c') == 'Other Hardware') {
            component.set(`v.recordsOther.${index}.OPP_IT_Asset__c`, null);
        }


        helper.getPicklistValuesITAsset(component, requesterId, index)
    },
    // handleRequester: function (component, event, helper) {
    //     helper.getPicklistValuesITAsset(component)
    // },
    handleHardwareType: function (component, event, helper) {
        //var hardwareType = component.get('v.case.Hardware_Type__c')
        //var developName = hardwareType === 'Standard Hardware' ? 'Hardware_Catalog' : 'Hardware_Non_Catalog'
        //component.set("v.case.RecordTypeId",
        //    component.get(`v.recordTypeIdsMap.${developName}.recordTypeId`))
        var requesterType = component.get('v.case.Requester_Type__c');
		if (requesterType) {
			var requester = requesterType.replace('Section Head', 'SectHead').trim();
			console.log(requester);
			helper.changeRecordType(component, requester);
		} else {
			component.set('v.case.RecordTypeId', null);
		}
    },

	handleRequester: function (component, event, helper) {
		helper.getRequesterType(component, component.get('v.case.Requester__c'));
	},
})