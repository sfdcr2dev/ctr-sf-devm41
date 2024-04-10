({
	navigateToRecord: function (component, event, helper) {
		let navigateToComponent = component.get('v.navigateToComponent');
		event.preventDefault();
		event.stopPropagation();
		if (component.get('v.isNavigable')) {
			if (navigateToComponent) {
				component.find('navLink').navigate(
					{
						type: 'standard__component',
						attributes: {
							componentName: navigateToComponent
						},
						state: {
							c__recordId: component.get('v.recordId')
						}
					},
					false
				);
			} else {
				component.find('navLink').navigate(
					{
						type: 'standard__recordPage',
						attributes: {
							actionName: 'view',
							recordId: component.get('v.recordId')
						}
					},
					false
				);
			}
		}
	}
});