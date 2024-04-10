({
	previousBack: function (component, event, helper) {
		component.find('navService').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: '/apex/previous_back'
				}
			},
			true
		);
	}
});