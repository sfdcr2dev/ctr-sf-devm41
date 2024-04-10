({
	doInit: function (component, event, helper) {
		window.setTimeout(
			$A.getCallback(function () {
				if (!component.get('v.withoutNotificationsList.length')) {
					helper.getWithoutNotificationOrOrderEQCCsByFilter(component, event, helper);
				}
				if (!component.get('v.inProgressList.length')) {
					helper.getInProgressEQCCsByFilter(component, event, helper);
				}
			}),
			500
		);
	},
	handleRefresh: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	},
	handleFilter: function (component, event, helper) {
		console.warn('THOR_FilterEnhanceEvent received!');
		var params = event.getParams();
		var filter = component.find('THOR_FilterEnhance').getFilterList();
		component.set('v.filter', filter);
		helper.getWithoutNotificationOrOrderEQCCsByFilter(component, event, helper);
		helper.getInProgressEQCCsByFilter(component, event, helper);
	},
	navigateToDisplay: function (component, event, helper) {
		var recordId = event.currentTarget.getAttribute('data-record-id');
		var auraComponent = event.currentTarget.getAttribute('data-page-ref');
		var eqccStep = component.get(`v.eqccStep.${recordId}`);
		var pageRef;
		if (auraComponent === 'c__THOR_ApprovalSteps') {
			pageRef = {
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_ApprovalSteps`,
							attributes: {
								recordId: eqccStep.Id,
								sheetCode: null,
								sheetGroup: eqccStep.Form_Group__c,
								forApprovals: false,
								uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
									let r = (Math.random() * 16) | 0,
										v = c == 'x' ? r : (r & 0x3) | 0x8;
									return v.toString(16);
								})
							}
						})
					)}`
				}
			};
		}
		component.find('navService').navigate(
			pageRef || {
				type: 'standard__component',
				attributes: {
					componentName: auraComponent
				},
				state: {
					c__recordId: recordId
				}
			},
			false
		);
	},
	handleViewAll: function (component, event, helper) {
		var navService = component.find('navService');
		navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${btoa(
						JSON.stringify({
							componentDef: `c:THOR_NotificationListPaging`,
							attributes: {
								document_type: 'EQCC',
								document_status: event.getSource().get('v.name'),
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
	}

	// handleClickBack: function (component, event, helper) {
	// 	window.history.back();
	// }
});