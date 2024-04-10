({
	doInit: function (component, event, helper) {
		helper.doInit(component, event);
	},

	callReInit: function (component, event, helper) {
		helper.doInit(component, event);
	},

	preventMe: function (component, event, helper) {
		// We have successfully preventedDefault
		// Do things here, like changing href to page we want, etc...

		// First check if this is a PDF preview, if not, do normal nav
		if (component.get('v.toThisComponent') != 'previewMe') {
			if (component.get('v.toThisComponent') === 'ToDo') {
				//helper.makeToast('info', 'Under Development', 'The page is under development, please check back later.');
			} else {
				var evnt = component.getEvent('navagationHelper');
				evnt.setParams({
					toThisComponent: component.get('v.toThisComponent'),
					theRecordId: component.get('v.orderId')
				});
				evnt.fire();
			}

			// if it is a PDF preview, we need to get it's Id and display it
		} else {
			let action = component.get('c.getAttachmentId');
			action.setParams({
				relatedId: component.get('v.orderId')
			});
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					let fileId = response.getReturnValue()[0].ContentDocumentId;
					if (fileId) {
						$A.get('e.lightning:openFiles').fire({
							recordIds: [fileId]
						});
					} else {
						console.log('File not found: ' + fileId);
					}
				} else if (state === 'INCOMPLETE') {
					// do something
				} else if (state === 'ERROR') {
					let errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.error('Error message: ' + errors[0].message + errors[0]);
						}
					} else {
						console.log('Unknown error');
					}
				}
			});
			$A.enqueueAction(action);
		}

		event.preventDefault();
	}
});