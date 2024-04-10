({
	doInit: function (component, event, helper) {
		helper.retireveRequests(component, event);
		helper.retrieveCartCount(component);
	},

	navigateToAddRequest: function (component) {
		component.find('navService').navigate(
			// {
			// 	type: 'standard__component',
			// 	attributes: {
			// 		componentName: 'c__THOR_AddComponentRequest'
			// 	},
			// 	state: {
			// 		c__recordId: component.get('v.recordId')
			// 	}
			// },
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_AddComponentRequest`,
							attributes: {
								recordId: component.get('v.recordId'),
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
	navigateToCart: function (component) {
		component.find('navService').navigate(
			// {
			// 	type: 'standard__component',
			// 	attributes: {
			// 		componentName: 'c__THOR_ManageComponentRequest'
			// 	},
			// 	state: {
			// 		c__recordId: component.get('v.recordId')
			// 	}
			// },
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_ManageComponentRequest`,
							attributes: {
								recordId: component.get('v.recordId'),
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
	}
});