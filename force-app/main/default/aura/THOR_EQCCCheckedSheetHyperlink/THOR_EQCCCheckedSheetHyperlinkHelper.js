({
	navigate: function (component) {
		var processId = component.get('v.currentStepId');
		var pageRef = component.get('v.pageReference');
		let navLink = component.find('navService');

		// pageRef = {
		// 	type: 'standard__component',
		// 	attributes: {
		// 		componentName: 'c__THOR_ApprovalSteps'
		// 	},
		// 	state: {
		// 		c__recordId: processId,
		// 		c__forApprovals: false,
		// 		c__backToTabIndex: component.get('v.backToTabIndex'),
		// 		c__sheetGroup: component.get('v.checkedSheetGroup')
		// 	}
		// };
		// navLink.navigate(pageRef, false);

    navLink.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_ApprovalSteps`,
							attributes: {
								recordId: processId,
								sheetCode: null,
								sheetGroup: component.get('v.checkedSheetGroup'),
								forApprovals: false,
								backToTabIndex: component.get('v.backToTabIndex'),
								uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
									let r = (Math.random() * 16) | 0,
										v = c == 'x' ? r : (r & 0x3) | 0x8;
									return v.toString(16);
								})
							}
						})
					)}`
				}
			},
			false
		);
	},

	getIdAndNavigate: function (component) {
		let action = component.get('c.getIdOfCurrentStep');

		action.setParams({
			headerSheetId: component.get('v.headerSheetId')
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let returnValue = response.getReturnValue();
				component.set('v.currentStepId', returnValue);
				this.navigate(component);
			} else if (state === 'INCOMPLETE') {
				// do something
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