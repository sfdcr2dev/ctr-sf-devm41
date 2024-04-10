({
	checkPrivilege: function (component, event, helper, recordId) {
		var action = component.get('c.checkPrivilege');
		action.setParams({
			stepId: recordId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				component.set('v.isCan', response.getReturnValue());
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
	reverseEQCCStepList: function (component) {
		var action = component.get('c.reverseEQCCStepList');
		action.setParams({
			recordId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(result);
				component.set('v.eqccStep', result);
				var thisStep = component.get('v.eqccStep').find((f) => f.Id === component.get('v.recordId'));
				if (thisStep) {
					component.set('v.percentage', component.get('v.percentage') || thisStep.Percentage__c);
					component.set('v.isCurrent', thisStep.Is_Current__c);
				}
			} else if (state === 'ERROR') {
				var errors = response.getError();
				console.error(JSON.parse(JSON.stringify(errors)));
			}
		});

		$A.enqueueAction(action);
	},
	setTimmer: function (component) {
		component._timeInterval = 1;
		var timmer = window.setInterval(
			$A.getCallback(() => {
				component.set('v.printDisplay', `The component is marking ${component._timeInterval}s`);
				component._timeInterval = component._timeInterval + 1;
			}),
			1000
		);
		component.set('v.timmer', timmer);
	},
	redirectToForm: function (component, formName) {
		var helper = this;
		console.log(component.get('v.sheetGroup'), formName);
		component.set('v.isLoading', true);
		helper.setTimmer(component);

		$A.createComponent(
			formName ||
				{
					1: 'c:eqccCheckedSheet',
					2: 'c:eqccCheckedSheet2',
					21: 'c:eqccCheckedSheet21',
					31: 'c:eqccCheckedSheet31',
					33: 'c:eqccCheckedSheet33',
					41: 'c:eqccCheckedSheet41'
				}[component.get('v.sheetGroup')],
			{
				recordId: component.get('v.forApprovals')
					? component.get('v.step') != null
						? component.get('v.step.recordId')
						: component.get('v.stepId')
					: component.get('v.recordId'),
				readOnly: component.get('v.readOnly'),
				isCan: component.get('v.isCan'),
				onpercentage: component.getReference('c.handlepercentage')
			},
			function (formsComponent, status, errorMessage) {
				//Add the new button to the body array
				if (status === 'SUCCESS') {
					window.clearInterval(component.get('v.timmer'));
					component.set('v.printDisplay', null);
					component.set('v.isLoading', false);
					component.set('v.body', formsComponent);
				} else if (status === 'INCOMPLETE') {
					// Show offline error
					console.log('No response from server or client is offline.');
				} else if (status === 'ERROR') {
					// Show error message
					console.error('Error: ' + errorMessage);
					window.clearInterval(component.get('v.timmer'));
					component.set('v.errorMessage', errorMessage);
					component.set('v.isLoading', false);
				}
			}
		);
	}
});