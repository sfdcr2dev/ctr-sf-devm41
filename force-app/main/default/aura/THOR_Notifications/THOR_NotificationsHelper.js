({
	setNotificationStatus: function (component, event) {
		let action = component.get('c.setNotificationStatus');
		action.setParams({
			notificationId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				// var toastEvent = $A.get('e.force:showToast');
				// toastEvent.setParams({
				// 	type: 'Success',
				// 	title: 'Success!',
				// 	message: 'Notification closed'
				// });
				// toastEvent.fire();
				setTimeout(
					$A.getCallback(() => {
						// location.reload(true);
						// $A.get('e.force:refreshView').fire();
						component.find('notificationLoader').reloadRecord(true);
					}),
					1000
				);
				// if (component.get('v.formFactor') === 'DESKTOP') {
				// 	window.location.reload(false);
				// } else {
				// }
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
		});
		$A.enqueueAction(action);
	}
});