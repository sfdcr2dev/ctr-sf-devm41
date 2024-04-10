({
	navigateBack: function (component) {
		var pageRef = component.get('v.pageReference');
		let navLink = component.find('navLink');
		pageRef = {
			type: 'standard__component',
			attributes: {
				componentName: 'c__THOR_OrderRecordDisplay'
			},
			state: {
				c__recordId: component.get('v.orderId')
			}
		};
		navLink.navigate(pageRef, true);
	}
});