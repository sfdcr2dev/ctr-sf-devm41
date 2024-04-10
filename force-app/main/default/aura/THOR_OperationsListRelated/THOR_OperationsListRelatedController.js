({
	doInit: function (component, event, helper) {
		helper.helperInit(component, event, helper);
	},
	showmore: function (component, event, helper) {
		component.set(`v.config.newLimit`, component.get(`v.config.newList.length`));
	},
	showless: function (component, event, helper) {
		component.set(`v.config.newLimit`, 3);
	},

	reInitRetriever: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	},

	navigateToDisplay: function (component, event, helper) {
		var recordId = event.currentTarget.getAttribute('data-record-id');
		var navService = component.find('navLink');
		navService.navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__THOR_OperationRecordDisplay'
				},
				state: {
					c__recordId: recordId
				}
			},
			false
		);
	}
});