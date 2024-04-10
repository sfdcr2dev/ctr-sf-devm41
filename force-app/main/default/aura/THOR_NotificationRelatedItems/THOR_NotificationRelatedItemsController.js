({
	doInit: function (component, event, helper) {
		component.set(
			'v.notificationId',
			component.get('v.notificationId')
				? component.get('v.notificationId')
				: component.get('v.pageReference.state.c__notificationId')
		);

		helper.getRelatedObjects(component);
		helper.handleSetInterval(component);
	},

	handleRefresh: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	},

	insertNewItem: function (component, event, helper) {
		component.find('navLink').navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__THOR_InsertItemObjectPart'
				},
				state: {
					c__notificationId: component.get('v.notificationId')
				}
			},
			false
		);
	},

	redirectBack: function (component, event, helper) {
		component.find('navLink').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: '/apex/previous_back'
				}
			},
			true
		);
	},

	navigateToItemDetail: function (component, event, helper) {
		if (event.target) {
			let recordId = event.currentTarget.id;
			let navigateToComponent = 'c__THOR_ItemRecordDisplay';
			event.preventDefault();
			event.stopPropagation();
			component.find('navLink').navigate(
				{
					type: 'standard__component',
					attributes: {
						componentName: navigateToComponent
					},
					state: {
						c__recordId: recordId
					}
				},
				false
			);
		}
	}
});