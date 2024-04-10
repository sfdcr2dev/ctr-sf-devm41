({
	closeOrder: function (component, event, helper) {
		component.set('v.closing', true);
		var action = component.get('c.getCloseOrderStatus');
		action.setParams({
			orderId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				let closeOrderCondition = response.getReturnValue();

				component.set('v.closeOrderCondition', closeOrderCondition);

				this.closeOrderToast(component);
			} else if (state === 'ERROR') {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log('Error message: ' + errors[0].message);
					}
				} else {
					console.log('Unknown error');
				}
			}
		});

		$A.enqueueAction(action);
	},

	closeOrderToast: function (component) {
		var helper = this;
		var toastEvent = $A.get('e.force:showToast');

		var closeOrderCondition = component.get('v.closeOrderCondition');
		if (closeOrderCondition.canClose) {
			// toastEvent.setParams({
			// 	title: 'Success!',
			// 	message: 'Order was closed',
			// 	type: 'success'
			// });
			// toastEvent.fire();

			//reload components
			// component.set('v.isClosed', true);
			component.find('orderLoader').reloadRecord(true);
			var recordId = component.get('v.recordId');
			component.set('v.recordId', null);
			component.set('v.recordId', recordId);
		} else {
			toastEvent.setParams({
				title: 'Warning!',
				message: closeOrderCondition.message,
				type: 'warning'
			});
			toastEvent.fire();
		}
	},
	setTimeout: function (component) {
		var action = component.get('c.setTimeoutOrder');
		action.setParams({
			orderId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				$A.get('e.force:refreshView').fire();
			} else {
				console.error(response.getError());
			}
		});
		if (component.get('v.hasWriteAccess')) $A.enqueueAction(action);
	},
	handleSetTimeout: function (component) {
		var helper = this;
		var timeout = setTimeout(
			$A.getCallback(() => {
				console.warn('Timeout');
				if (component.get('v.orderRecord.Integration_Status__c') === 'In Progress') {
					helper.setTimeout(component);
				}
			}),
			60 * 1000
		);
		component.set('v.timeout', timeout);
	},
	handleSetInterval: function (component) {
		var helper = this;
		// Set timeout when waiting long time more 1 minute
		helper.handleSetTimeout(component);

		var intervalGetInfo = setInterval(
			$A.getCallback(() => {
				// component.find('orderLoader').reloadRecord(true);
				if (
					component.find('orderLoader') &&
					component.get('v.orderRecord.Integration_Status__c') &&
					component.get('v.orderRecord.Integration_Status__c') === 'In Progress'
				) {
					component.find('orderLoader').reloadRecord(true);
				} else if (
					component.find('orderLoader') &&
					component.get('v.interval') &&
					component.get('v.orderRecord.Integration_Status__c') &&
					component.get('v.orderRecord.Integration_Status__c') !== 'In Progress'
				) {
					console.warn('clearInterval');
					clearInterval(component.get('v.interval'));
					component.set('v.interval', null);

					console.warn('clearTimeout');
					clearTimeout(component.get('v.timeout'));
					component.set('v.timeout', null);
				}
			}),
			5000
		);
		component.set('v.interval', intervalGetInfo);
	}
});