({
	/*
        Moved init to helper so we can call it on reInit if we need
    */
	doInit: function (component, event) {
		let action = component.get('c.getRelatedRecord');
		let recordId = component.get('v.recordId');
		let fromRecord = component.get('v.fromRecord');
		let relatedField = component.get('v.relatedField');
		let relatedObject = component.get('v.relatedObject');
		if (action) {
			action.setParams({
				notifId: recordId,
				fromRecord: fromRecord,
				relatedField: relatedField
			});
			action.setCallback(this, function (response) {
				let state = response.getState();
				// console.log('state ' + state);
				if (state === 'SUCCESS') {
					try {
						let returnedRecord = response.getReturnValue()[0];
						// https://stackoverflow.com/questions/6393943/convert-javascript-string-in-dot-notation-into-an-object-reference
						function index(obj, i) {
							return obj[i];
						}
						let theRelatedField = relatedField.split('.').reduce(index, returnedRecord);
						let theRelatedId = returnedRecord[relatedObject];
						// console.log('theRelatedField ' + theRelatedField);
						// console.log('theRelatedId ' + theRelatedId);
						component.set('v.orderName', theRelatedField);
						component.set('v.orderId', theRelatedId);
					} catch (err) {
						let returnedRecord = response.getReturnValue()[0];
						// Either there is no related, or it's Work_Clearance__c
						// if it's Work_Clearance set the name and Id
						if (relatedObject == 'Work_Clearance__c' && returnedRecord !== undefined) {
							// console.log('theRelatedField ' + returnedRecord.Name);
							// console.log('theRelatedId ' + returnedRecord.Id);
							component.set('v.orderName', returnedRecord.Name);
							component.set('v.orderId', returnedRecord.Id);

							// if NOT work clerance, we set to blank so Sub Orders work
						} else {
							component.set('v.orderName', '');
						}
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
	},

	makeToast: function (type, title, message) {
		var toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			title: title,
			message: message,
			type: type
		});
		toastEvent.fire();
	}
});