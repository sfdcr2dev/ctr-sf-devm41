({
	updateDocument: function (component, Id, fName) {
		var action = component.get('c.updateFiles');
		action.setParams({
			documentId: Id,
			title: fName
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == 'SUCCESS') {
				this.showToast('success', 'Success', 'Name changed successfully');
				$A.util.addClass(component.find('changeNameModal'), 'hide-me');

				setTimeout(
					$A.getCallback(() => {
						$A.get('e.force:refreshView').fire();
					}),
					500
				);
				// var evnt = component.getEvent('refreshFileList');
				// evnt.fire();
			} else if (state === 'ERROR') {
				this.showToast('error', 'Error', 'There was an error changing the name, please try again.');
			}
		});
		$A.enqueueAction(action);
	},

	showToast: function (type, title, message) {
		var toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			title: title,
			message: message,
			type: type
		});
		toastEvent.fire();
	},

	checkWriteAccess: function (component) {
		let action = component.get('c.hasWriteAccess');

		action.setParams({
			recordId: component.get('v.notificationId')
		});

		action.setCallback(this, function (response) {
			let state = response.getState();

			if (state === 'SUCCESS') {
				component.set('v.hasWriteAccess', response.getReturnValue());
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