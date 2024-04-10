({
	doInit: function (component, event, helper) {
		window.setTimeout(
			$A.getCallback(function () {
				if (component.get('v.records.length') === 0) {
					console.warn('doInit');
					console.log(component.get('v.document_type'));
					console.log(component.get('v.document_status'));
					helper.getCountNotificationsByFilter(component, event, helper);
					helper.getNotificationsByFilter(component, event, helper);
				}
			}),
			1000
		);
	},
	handleFilter: function (component, event, helper) {
		console.warn('fitlerEnhanceEvent received!');
		var params = event.getParams();
		var filter = component.find('THOR_FilterEnhance').getFilterList();
		component.set('v.filter', filter);
		component.set('v.pagination.currentPosition', 1);

		helper.getCountNotificationsByFilter(component, event, helper);
		helper.getNotificationsByFilter(component, event, helper);
	},
	navigateToDisplay: function (component, event, helper) {
		var recordId = event.currentTarget.getAttribute('data-record-id');
		var documentType = String(component.get('v.document_type')).toLowerCase();

		var pageRef;
		var auraComponent;
		switch (documentType) {
			case 'notification':
			case 'homenotification':
				auraComponent = `c__THOR_NotificationRecordDisplay`;
				break;
			case 'order':
			case 'homeorder':
				auraComponent = `c__THOR_OrderRecordDisplay`;
				break;
			case 'workclearance':
				auraComponent = `c__THOR_WorkClearanceRecordDisplay`;
				break;
			case 'eqcc':
				auraComponent = event.currentTarget.getAttribute('data-page-ref');
				if (auraComponent === 'c__THOR_ApprovalSteps') {
					var eqccStep = component.get(`v.eqccStep.${recordId}`);
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
					};
				}
				break;
			default:
				break;
		}

		if (auraComponent) {
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
		}
	},
	// navigateToPreviousUrl: function (component, event, helper) {
	// 	window.history.back();
	// },
	goToPage: function (component, event, helper) {
		helper.startLoading(component);
		component.set('v.pagination.currentPosition', event.getSource().get('v.value'));
		helper.getNotificationsByFilter(component, event, helper);
		helper.buildPaginationItems(component, event, helper);
	}
});