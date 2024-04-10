({
	doInit: function (component, event, helper) {
		// console.log(JSON.parse(JSON.stringify(component.get('v.pageReference'))));
		// component.set('v.orderId', component.get('v.pageReference.state.c__recordId'));

		helper.helperInit(component, event, helper);
	},
	showmore: function (component, event, helper) {
		var status = event.getSource().get('v.name');
		component.set(
			`v.config.${
				{
					New: 'newLimit',
					'In Progress': 'inprogressLimit'
				}[status]
			}`,
			component.get(
				`v.config.${
					{
						New: 'newList',
						'In Progress': 'inprogressList'
					}[status]
				}.length`
			)
		);
	},
	showless: function (component, event, helper) {
		var status = event.getSource().get('v.name');
		component.set(
			`v.config.${
				{
					New: 'newLimit',
					'In Progress': 'inprogressLimit'
				}[status]
			}`,
			3
		);
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
					componentName: 'c__THOR_NotificationRecordDisplay'
				},
				state: {
					c__recordId: recordId
				}
			},
			false
		);
	}
});