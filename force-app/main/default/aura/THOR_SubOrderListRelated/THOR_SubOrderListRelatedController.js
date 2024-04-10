({
	doInit: function (component, event, helper) {
		// component.set('v.orderId', component.get('v.pageReference.state.c__recordId'));
		helper.helperInit(component, event, helper);
	},
	showmore: function (component, event, helper) {
		var status = event.getSource().get('v.name');
		component.set(
			`v.orderMap.${
				{
					New: 'newLimit',
					'In Progress': 'inprogressLimit'
				}[status]
			}`,
			component.get(
				`v.orderMap.${
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
			`v.orderMap.${
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
					componentName: 'c__THOR_OrderRecordDisplay'
				},
				state: {
					c__recordId: recordId
				}
			},
			false
		);
	},
	navigateToOrder: function (component, event, helper) {
		helper.navigateBack(component);
	},
	toggleModalDate: function (component, event, helper) {
		component.set(`v.filter.dateIsModalToggle`, !component.get(`v.filter.dateIsModalToggle`));
		var name = event.getSource().get('v.name');
		if (name === 'submit') {
			component.set(`v.filter.dateIsActive`, true);
			helper.helperInit(component, event, helper);
		} else if (name === 'clear') {
			component.set(`v.filter.CreatedDatedFrom`, null);
			component.set(`v.filter.CreatedDatedTo`, null);
			component.set(`v.filter.dateIsActive`, false);
			helper.helperInit(component, event, helper);
		}
	},
	toggleUserActive: function (component, event, helper) {
		component.set('v.filter.userIsActive', !component.get('v.filter.userIsActive'));
		helper.helperInit(component, event, helper);
	}
});