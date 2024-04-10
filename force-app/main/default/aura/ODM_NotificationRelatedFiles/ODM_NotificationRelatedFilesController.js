({
	doInit: function (component, event, helper) {
		helper.retrieveRelated(component);
		helper.handleSetInterval(component);
	},

	preview: function (component, event, helper) {
		// this check is for mobile, when closing the modal this method is fired again
		// but event.target is undefined ONLY on clicking close on mobile
		if (event.target) {
			var clickeFiledId = event.currentTarget.id;
			var filetype = event.target.dataset.filetype;
			if (filetype === 'MP4') {
				let act = component.find('VideoFile');
				// if there are more than one videos attached
				// loop through them and check if the id matches the one clicked
				if (act.length >= 2) {
					for (let i = 0; i < act.length; i++) {
						const fileId = act[i].get('v.fileId');
						if (fileId === clickeFiledId) {
							act[i].showModalAction();
						}
					}
				} else {
					act.showModalAction();
				}
			} else {
				$A.get('e.lightning:openFiles').fire({
					recordIds: [clickeFiledId]
				});
			}
		}
	},

	deleteMe: function (component, event, helper) {
		if (confirm('Are you sure you would like to delete this file?')) {
			var attactmentId = event.getSource().get('v.name');
			let action = component.get('c.deleteFile');
			action.setParams({ fileId: attactmentId });
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						// title: title,
						message: 'File Deleted',
						type: 'success'
					});
					toastEvent.fire();
					// alert('File Deleted');
					$A.enqueueAction(component.get('c.doInit'));
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
	},

	resendAttachment: function (component, event, helper) {
		var attactmentId = event.getSource().get('v.name');
		const attactmentObj = component.get('v.filesRelated').find((f) => f.document.ContentDocumentId === attactmentId);
		attactmentObj.Integration_Status__c = 'In Progress';
		attactmentObj.isCanResend = false;
		component.set('v.filesRelated', component.get('v.filesRelated'));

		helper.calloutNotiFile(component, { attactmentId, flag: 'Created' });
		// console.log(JSON.parse(JSON.stringify(attactmentObj), { attactmentId }));
	},

	handleRefresh: function (component, event, helper) {
		// $A.get('e.force:refreshView').fire();
		helper.retrieveRelated(component);
	}
});