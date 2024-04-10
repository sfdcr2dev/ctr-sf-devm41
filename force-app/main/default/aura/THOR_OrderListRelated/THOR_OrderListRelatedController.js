({
	doInit: function (component, event, helper) {
		helper.retireveRelated(component, event);
	},

	getMessage: function (component, event) {
		var params = event.getParam('arguments');
		if (params) {
			var param1 = params.Title;
			return param1;
		}
		return '';
	},

	navigateToRelated: function (component, event, helper) {
		let optionclicked = event.target.id;
		let recordId = component.get('v.recordId');
		let navLink = component.find('navLink');

		event.preventDefault();
		navLink.navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__THOR_OrderListRelatedDisplayer'
				},
				state: {
					c__recordId: recordId,
					c__relatedType: optionclicked
				}
			},
			false
		);

		// let pageRef;
		// if (optionclicked === 'Orders__r') {
		// 	pageRef = {
		// 		type: 'standard__component',
		// 		attributes: {
		// 			componentName: 'c__THOR_OrderListRelatedDisplayer'
		// 		},
		// 		state: {
		// 			c__recordId: recordId,
		// 			c__ListType1: 'New Sub Orders',
		// 			c__ListType2: 'Execution Sub Orders'
		// 		}
		// 	};
		// } else if (optionclicked === 'Notifications__r') {
		// 	pageRef = {
		// 		type: 'standard__component',
		// 		attributes: {
		// 			componentName: 'c__THOR_OrderListRelatedDisplayer'
		// 		},
		// 		state: {
		// 			c__recordId: recordId,
		// 			c__ListType1: 'New Notifications',
		// 			c__ListType2: 'Execution Notifications'
		// 		}
		// 	};
		// } else if (optionclicked === 'Order_Operations__r') {
		// 	pageRef = {
		// 		type: 'standard__component',
		// 		attributes: {
		// 			componentName: 'c__THOR_OrderListRelatedDisplayer'
		// 		},
		// 		state: {
		// 			c__recordId: recordId,
		// 			c__ListType1: 'Related Operations',
		// 			c__ListType2: 'none'
		// 		}
		// 	};
		// }
		// event.preventDefault();
		// navLink.navigate(pageRef, false);
	}
});