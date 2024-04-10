({
	doInit: function (component, event, helper) {
		// alert(window.innerHeight);
		component.set(
			'v.innerHeight',
			window.innerHeight
				? window.innerHeight - (component.get('v.formFactor') === 'TABLET' ? 122 : 282)
				: component.get('v.innerHeight')
		);

		component.set('v.recordId', component.get('v.pageReference.state.c__recordId') || component.get('v.recordId'));
		component.set(
			'v.backToTabIndex',
			component.get('v.pageReference.state.c__backToTabIndex') || component.get('v.backToTabIndex')
		);
		component.set('v.sheetCode', component.get('v.pageReference.state.c__sheetCode') || component.get('v.sheetCode'));
		component.set(
			'v.sheetGroup',
			component.get('v.pageReference.state.c__sheetGroup') || component.get('v.sheetGroup')
		);
		component.set('v.forApprovals', component.get('v.forApprovals') || false);
		console.log('record id---'+component.get('v.recordId'));
		var action = component.get('c.retrieveProcessInstanceSteps');
		action.setParams({
			processInstanceId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				console.log('test----'+component.get('v.recordId'), result);
				if (component.get('v.recordId') !== result.Id) {
					component.set('v.recordId', result.Id);
					component.set('v.eqccStepId', result.Id);
					component.set('v.stepId', component.get('v.recordId'));
				}
				console.log('record id--2-'+component.get('v.recordId'));
				console.log('eqccStepId---'+component.get('v.eqccStepId'));
				// let step = result ? result[0] : null;
				// if (step) {
				// 	component.set('v.step', step);
				// 	component.set('v.eqccStepId', step.recordId);
				// 	component.set('v.recordId', step.recordId);
				// 	//helper.checkPrivilege(component, event, helper, step.recordId);
				// } else {
				// 	component.set('v.stepId', component.get('v.recordId'));
				// 	component.set('v.eqccStepId', component.get('v.recordId'));
				// 	//helper.checkPrivilege(component, event, helper, recordId);
				// }
				helper.redirectToForm(component, result.FormNameLWC__c || '');
			} else if (state === 'ERROR') {
				var errors = response.getError();
				console.error(JSON.parse(JSON.stringify(errors)));
			}
		});
		$A.enqueueAction(action);

		helper.reverseEQCCStepList(component);
	},

	forceRefresh: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	},

	forceRefreshSteps: function (component, event, helper) {
		window.location.reload(true);
	},

	stopLoading: function (component, event, helper) {
		var target = event.getParam('target');
		if (target === 'stopLoading') {
			component.set('v.isLoading', false);
		}
	},
	handleClickBack: function (component, event, helper) {
		window.history.back();
	},
	handlepercentage: function (component, event, helper) {
		var params = event.getParams();
		// console.log(JSON.parse(JSON.stringify(params)));
		if (params.percentage != component.get('v.percentage')) {
			component.set('v.percentage', params.percentage || 0);
		}
	},
	handleClickStep: function (component, event, helper) {
		const { recordId, formGroup } = event.target.dataset;
		// console.log('handleClickStep', { recordId, formGroup });
		var forApprovals = component.get('v.forApprovals');
		if (forApprovals == null || forApprovals === undefined) {
			forApprovals = true;
		}

		if (recordId && formGroup) {
			component.find('navService').navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${window.btoa(
							JSON.stringify({
								componentDef: `c:THOR_ApprovalSteps`,
								attributes: {
									recordId: recordId,
									// sheetCode: null,
									sheetGroup: formGroup,
									forApprovals: forApprovals,
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
				true
			);
		}
	}
});