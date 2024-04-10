({
	doInit: function (component, event, helper) {
		// Set default values for case line item
		component.set('v.records', [{}]);
		component.set('v.recordsOther', [{}]);

		helper.getCaseInfo(component, event, helper);
		helper.getIsEmployee(component);
		helper.getCaseRecordTpyeInfoes(component, event, helper);

		helper.getDescribeFieldResult(component, 'Case', ['Creator_Email__c', 'Stationery_Type__c']);
		helper.getDescribeFieldResult(component, 'OPP_Case_Line_Items__c', ['Stationery_Item__c', 'Quantity__c']);
		helper.getPicklistValuesMap(component, 'Case', 'Stationery_Type__c');
		helper.getPicklistValuesMap(component, 'OPP_Case_Line_Items__c', 'Stationery_Item__c');
	},
	closeModal: function (component, event, helper) {
		// event.preventDefault();
		if (component.get('v.formFactor') === 'PHONE') {
			var navService = component.find('navService');
			navService.navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: '/apex/previous_back'
					}
				},
				true
			);
		} else {
			var navigateToURL = $A.get('e.force:navigateToURL');
			navigateToURL.setParams({
				isredirect: true,
				url: '/lightning/n/DG_Service'
			});
			navigateToURL.fire();
		}
	},
	handleAdd: function (component, event, helper) {
		component.set('v.records', [...component.get('v.records'), {}]);
	},
	handleRemove: function (component, event, helper) {
		if (component.get('v.records.length') > 1) {
			component.get('v.records').splice(event.target.name, 1);
			component.set('v.records', component.get('v.records'));
		}
	},
	handleStationeryType: function (component, event, helper) {
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

	handleAutoApproval: function (component, event, helper) {
		component.set('v.autoApproval', true);
		component.find('utilityLwcButton').submit_click();
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault();
		var isValid = true;
		var fields = event.getParam('fields');
		fields.Auto_Submit__c = component.get('v.autoApproval');
		component.set('v.autoApproval', false);

		var statation_item = component.find('statation_item');
		statation_item = Array.isArray(statation_item) ? statation_item : [statation_item];
		statation_item.reduce((isValid, item) => {
			item.showHelpMessageIfInvalid();
			item.focus();
			return isValid && item.checkValidity();
		}, isValid);

		if (!isValid) return;

		component.set('v.isLoading', true);
		component.find('recordEditForm').submit(fields);
	},
	handleSuccess: function (component, event, helper) {
		helper.createCaseLineItem(component, event, helper);
	},
	handleError: function (component, event, helper) {
		component.set('v.isLoading', false);
	}
});