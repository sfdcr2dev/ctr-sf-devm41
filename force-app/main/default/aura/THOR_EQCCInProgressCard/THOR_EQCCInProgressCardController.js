({
	doInit: function (component, event, helper) {
		// pass
	},

	goToHeaderPage: function (component, event, helper) {
		event.preventDefault();

		let eqccId = event.target.classList.value;
		component.find('navService').navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__THOR_EQCCHeaderRecordDisplay'
				},
				state: {
					c__recordId: eqccId
				}
			},
			false
		);
	}
});