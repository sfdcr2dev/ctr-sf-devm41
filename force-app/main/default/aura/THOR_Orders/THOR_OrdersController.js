({
	newOrder: function (component, event, helper) {
		// component.set('v.createNew', true);
		component.find('navService').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_OrderCreation`,
							attributes: {
								uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
									let r = (Math.random() * 16) | 0,
										v = c == 'x' ? r : (r & 0x3) | 0x8;
									return v.toString(16);
								})
							}
						})
					)}`
				}
			},
			false
		);
	},

	handleCloseModal: function (component, event, helper) {
		var key = event.getParam('key');
		if (key == 'closeModal') {
			component.set('v.createNew', false);

			var reload = event.getParam('reload');
			if (reload) {
				$A.get('e.force:refreshView').fire();
			}
		}
	}
});