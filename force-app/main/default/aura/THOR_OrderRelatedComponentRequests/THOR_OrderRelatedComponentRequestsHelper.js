({
	retireveRequests: function (component, event) {
		let action = component.get('c.retrieveComponentsRequests');
		action.setParams({
			orderId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let returnedList = response.getReturnValue();
				component.set('v.items', returnedList);

				if (returnedList.length > 0) {
					component.set(
						'v.labelSequence',
						returnedList[0].dropableBody.reduce((l, item) => (l.push(item.label), l), []).join(', ')
					);
				}
			} else if (state === 'ERROR') {
				let errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.error('Error message: ' + errors[0].message);
					}
				} else {
					console.log('Unknown error');
				}
			}
			component.set('v.finishedLoading', 'true');

			component.set('v.isLoadingRequests', false);
			this.stopLoading(component);
		});

		component.set('v.isLoadingRequests', true);
		this.stopLoading(component);

		$A.enqueueAction(action);
	},
	retrieveCartCount: function (component) {
		let action = component.get('c.getCartCount');
		action.setParams({
			orderId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				component.set('v.cartCount', response.getReturnValue());
			} else if (state === 'ERROR') {
				let errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.error('Error message: ' + errors[0].message);
					}
				} else {
					console.log('Unknown error');
				}
			}

			component.set('v.isLoadingCartCount', false);
			this.stopLoading(component);
		});

		component.set('v.isLoadingCartCount', true);
		this.stopLoading(component);
		$A.enqueueAction(action);
	},

	stopLoading: function (component) {
		var isLoadingRequests = component.get('v.isLoadingRequests');
		var isLoadingCartCount = component.get('v.isLoadingCartCount');
		if (!isLoadingRequests && !isLoadingCartCount) {
			var stopLoadingEvent = component.getEvent('stopLoadingEvent');
			stopLoadingEvent.setParams({
				target: 'stopLoading'
			});
			stopLoadingEvent.fire();
		}
	}
});