({
	getRelatedWorkClearances: function (component, event, helper) {
		let action = component.get("c.getRelatedWorkClearances");

		action.setParams({ orderIdentifier: component.get("v.recordId") });
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === "SUCCESS") {
				let returnValue = response.getReturnValue();
				component.set("v.RelatedWorkClearances", returnValue);
			} else if (state === "INCOMPLETE") {
				// do something
			} else if (state === "ERROR") {
				let errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.error("Error message: " +
							errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
		});

		$A.enqueueAction(action);
	},

	hasWriteAccess: function (component, event, helper) {
		let action = component.get('c.hasWriteAccess')

		action.setParams({
			recordId: component.get('v.recordId')
		});

		action.setCallback(this, function (response) {
			let state = response.getState()

			if (state === 'SUCCESS') {
				component.set('v.hasWriteAccess', response.getReturnValue());
			} else if (state === "ERROR") {
				let errors = response.getError()
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.error("Error message: " +
							errors[0].message)
					}
				} else {
					console.log("Unknown error")
				}
			}
		});

		$A.enqueueAction(action);
	}
})