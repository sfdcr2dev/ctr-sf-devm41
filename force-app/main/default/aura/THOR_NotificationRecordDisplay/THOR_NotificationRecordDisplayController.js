({
	doInit: function (component, event, helper) {
		let pageref = component.get('v.pageReference');
		if (pageref && !component.get('v.recordId')) {
			let { c__recordId } = pageref.state;
			component.set('v.recordId', c__recordId);
		}

		helper.handleSetInterval(component);
		helper.handleSetTimeout(component);
    component.find('recordLoader').reloadRecord(true);
	},

	doneRendering: function (component, event, helper) {
		// init isn't fired again after using lightning navigation
		// so we do things in here, after render which IS called on navigation
		let pageref = component.get('v.pageReference');
		if (pageref) {
			// let recordId = pageref.state.c__recordId;

			// if (recordId) {
			// 	let cmpRecordId = component.get('v.recordId');

			// 	if (recordId != cmpRecordId) {
			// 		component.set('v.recordId', recordId);
			// 		component.set('v.isLoading', true);
			// 	}
			// }

			let backToTabIndex = pageref.state.c__backToTabIndex;
			if (backToTabIndex && component.get('v.selected') == null) {
				component.set('v.selected', backToTabIndex);
			}

			if (component.get('v.selected') == null) {
				component.set('v.selected', 0);
			}
		}
	},

	reInit: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	},

	navigateHelper: function (component, event) {
		let toComponent = event.getParam('toThisComponent');
		let recordId = event.getParam('theRecordId');
		let fromRecordId = component.get('v.recordId');

		recordId = toComponent === 'c__THOR_FunctionalLocationHistoryListDisplayer' ? recordId.Id : recordId;
		component.find('navLink').navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: toComponent
				},
				state: {
					c__recordId: recordId,
					c__fromRecordId: fromRecordId
				}
			},
			false
		);
	},

	viewMore: function (component, event, helper) {
		component.set('v.showViewMore', false);
	},

	viewLess: function (component, event, helper) {
		component.set('v.showViewMore', true);
	},

	handleRecordUpdated: function (component, event, helper) {
		const eventParams = event.getParams();

		let { changeType, changedFields } = eventParams;
		if (changeType === 'CHANGED' && changedFields && changedFields['Integration_Status__c']) {
      component.set(`v.notificationRecord.Integration_Status__c`, changedFields['Integration_Status__c'].value);

			helper.handleSetInterval(component);
			helper.handleSetTimeout(component);
		}
		component.set(
			'v.isAlertIntegration',
			!component.get('v.notificationRecord.Integration_Status__c') ||
				component.get('v.notificationRecord.Integration_Status__c') === 'Failed'
		);

		helper.truncHistoryDetail(component);
		component.set('v.isLoading', false);
	},

	redirectToHome: function (component, event) {
		let navLink = component.find('navLink');
		if (component.get('v.formFactor') === 'DESKTOP') {
			navLink.navigate(
				{
					type: 'standard__navItemPage',
					attributes: {
						apiName: 'Notifications'
					}
				},
				true
			);
			component.destroy();
		} else {
			navLink.navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: '/apex/previous_back'
					}
				},
				true
			);
		}
	},

	stopLoading: function (component, event, helper) {
		var target = event.getParam('target');
		if (target === 'stopLoading') {
			component.set('v.isLoading', false);
		}
	},

	reload: function (component, event) {
		var target = event.getParam('target');
		if (target == 'recordSaved') {
			var recordId = component.get('v.recordId');
			component.set('v.recordId', '');
			component.set('v.recordId', recordId);
		}
	},

	closeAlertIntegration: function (component, event, helper) {
		component.set('v.isAlertIntegration', false);
	},
	handleResendFormError: function (component, event, helper) {
		try {
			var params = event.getParams();
			const {
				output: { fieldErrors }
			} = params;
			const { errorCode, fieldLabel, message } =
				fieldErrors && Object.keys(fieldErrors).length ? fieldErrors[Object.keys(fieldErrors)[0]][0] : {};

			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				title: fieldLabel,
				type: 'error',
				message: message
			});
			toastEvent.fire();
		} catch (e) {
			console.error(e);
		}
	}
});