({
	retrieveComponentRequest: function (component) {
		var action = component.get('c.retrieveComponentRequest');
		action.setParams({
			componentRequestId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				let componentRequest = response.getReturnValue();
				// console.log(componentRequest);
				component.set('v.componentRequest', componentRequest);
			} else if (state === 'ERROR') {
				var errors = response.getError();
				console.error(errors);
				// if (errors) {
				// 	if (errors[0] && errors[0].message) {
				// 		console.log('Error message: ' + errors[0].message);
				// 	}
				// } else {
				// 	console.log('Unknown error');
				// }
			}
		});

		$A.enqueueAction(action);
	}
});