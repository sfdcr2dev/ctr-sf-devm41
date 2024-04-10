({
	doInit: function (component, event, helper) {
		//alert('HI');
	},
	scriptsLoaded: function (component, event, helper) {
		$('.select2Class').select2({
			placeholder: ' Select Multiple value'
		});
	},

	setState: function (component, event, helper) {
		component.set('v.whichState', event.getSource().get('v.name'));
	}
	// setStateOrder: function (component, event, helper) {
	// 	component.set('v.whichState', 'Order');
	// },
	// setStateWorkClearance: function (component, event, helper) {
	// 	component.set('v.whichState', 'WorkClearance');
	// },
	// setStateEQCC: function (component, event, helper) {
	// 	component.set('v.whichState', 'EQCC');
	// }
});