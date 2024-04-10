({
	handleSetInterval: function (component) {
		var helper = this;
		var intervalGetInfo = setInterval(
			$A.getCallback(() => {
				// && window.location.pathname.includes('THOR_ManageComponentRequest')
				if (component.get('v.isModalAction.integration')) {
					// helper.getCart(component, 'Pending for Approval');
					helper.getCart(component, 'Draft');
				} else if (component.get('v.interval') && !component.get('v.isModalAction.integration')) {
					// || !window.location.pathname.includes('THOR_ManageComponentRequest')
					console.warn('clearInterval');
					clearInterval(component.get('v.interval'));
				}
			}),
			5000
		);
		component.set('v.interval', intervalGetInfo);
	},
	handleSetTimeout: function (component) {
		var helper = this;
		var timeout = setTimeout(
			$A.getCallback(() => {
				console.warn('setTimeout');
				if (
					component.get('v.cart') &&
					component.get('v.cart').every((e) => !e.Integration_Status__c || e.Integration_Status__c === 'In Progress')
				) {
					helper.saveCartTimeout(component);
				}
			}),
			120 * 1000
		);
		component.set('v.timeout', timeout);
	},
	saveCartTimeout: function (component) {
		var helper = this;
		var action = component.get('c.saveCartTimeout');
		action.setParams({
			orderId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				console.log({ result });
				helper.getCart(component, 'Draft');
			} else {
				console.error(JSON.parse(JSON.stringify(response.getError())));
			}
		});
		$A.enqueueAction(action);
	},
	getCart: function (component, requesterStatus) {
		component.set('v.isLoading', true);
		let action = component.get('c.getCart');
		action.setParams({
			orderId: component.get('v.recordId'),
			requesterStatus
		});
		action.setCallback(this, function (response) {
			component.set('v.isLoading', false);
			let state = response.getState();
			if (state === 'SUCCESS') {
				let cart = response.getReturnValue();
				component.set('v.cart', cart);

				// if (requesterStatus == 'Draft') {
				// 	component.set('v.cart', cart);
				// } else if (requesterStatus == 'Pending for Approval') {
				// 	component.set('v.cartPendingApproval', cart);
				// }
			} else if (state === 'ERROR') {
				console.log(JSON.parse(JSON.stringify(response.getError())));
			}
		});
		$A.enqueueAction(action);
	},
	getOrderOperations: function (component) {
		let action = component.get('c.getOrderOperations');
		action.setParams({ orderId: component.get('v.recordId') });
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let operations = [];
				response.getReturnValue().forEach((item) => {
					operations.push({
						label: item.Operation_Text__c + ' ' + item.Operation_Shot_Text__c,
						value: item.Id
					});
				});
				component.set('v.operationObjects', response.getReturnValue());
				component.set('v.operations', operations);
			} else if (state === 'ERROR') {
				console.log(response.getError());
			} else {
				console.log(response.getError());
			}
		});
		$A.enqueueAction(action);
	},
	submitRequest: function (component) {
		let cart = component.get('v.cart');
		let cartOfObjects = [];
		let canSubmit = true;
		cart.forEach((item) => {
			if (!item.Order_Operation__c) {
				canSubmit = false;
			}
			cartOfObjects.push({
				sobjectType: 'Spare_Part_Request__c',
				Id: item.Id,
				Order__c: item.Order__c,
				Available_Quantity__c: item.Available_Quantity__c,
				UM__c: item.UM__c,
				Request_Material_Quantity__c: item.Request_Material_Quantity__c,
				Request_Status__c: item.Request_Status__c,
				Operation__c: item.Operation__c,
				Order_Operation__c: item.Order_Operation__c
			});
		});
		if (canSubmit == true) {
			let action = component.get('c.saveOrSubmitRequests');
			action.setParams({
				action: 'submit',
				requests: cartOfObjects
			});
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						type: 'success',
						title: 'Request Submitted',
						duration: '5000',
						message: 'Request has been submitted successfully.'
					});
					toastEvent.fire();
					$A.get('e.force:refreshView').fire();
				} else if (state === 'ERROR') {
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						type: 'error',
						title: 'Unable to Submit Request',
						duration: '5000',
						message: 'Unable to submit request, please try again.'
					});
					toastEvent.fire();
				} else {
					console.log(state);
				}
			});
			$A.enqueueAction(action);
		} else {
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				type: 'warning',
				title: 'Unable to Submit Request',
				duration: '5000',
				message:
					'One or more components do not have an operation set on them. Please make sure every component has an operation before submitting.'
			});
			toastEvent.fire();
		}
	},

	saveRequestDraft: function (component) {
		let cart = component.get('v.cart');
		let cartOfObjects = [];
		cart.forEach((item) => {
			cartOfObjects.push({
				sobjectType: 'Spare_Part_Request__c',
				Id: item.Id,
				Order__c: item.Order__c,
				Available_Quantity__c: item.Available_Quantity__c,
				UM__c: item.UM__c,
				Request_Material_Quantity__c: item.Request_Material_Quantity__c,
				Request_Status__c: item.Request_Status__c,
				Operation__c: item.Operation__c,
				Order_Operation__c: item.Order_Operation__c
			});
		});
		let action = component.get('c.saveOrSubmitRequests');
		action.setParams({
			action: 'save',
			requests: cartOfObjects
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					type: 'success',
					title: 'Draft Saved',
					duration: '5000',
					message: 'Draft has been saved successfully.'
				});
				toastEvent.fire();
			} else if (state === 'ERROR') {
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					type: 'error',
					duration: '5000',
					title: 'Unable to Save Draft',
					message: 'Unable to save draft, please try again.'
				});
				toastEvent.fire();
			} else {
				console.log(state);
			}
		});
		$A.enqueueAction(action);
	},

	checkResponsiblePerson: function (component) {
		let action = component.get('c.hasResponsiblePerson');
		action.setParams({ orderId: component.get('v.recordId') });
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				component.set('v.hasResponsiblePerson', response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},

	deleteRequest: function (component) {
		let id = component.get('v.requestToDelete');
		let action = component.get('c.deleteRequestFromCart');
		action.setParams({ requestId: id });
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					type: 'success',
					title: 'Component Removed',
					message: 'The component has been removed from your cart successfully.'
				});
				toastEvent.fire();
				$A.get('e.force:refreshView').fire();
			} else {
				console.log(state);
			}
		});
		$A.enqueueAction(action);
	}
});