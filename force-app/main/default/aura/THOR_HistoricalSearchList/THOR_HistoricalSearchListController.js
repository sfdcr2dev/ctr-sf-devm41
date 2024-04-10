({
	doInit: function (component, event, helper) {
		// console.log({ innerHeight: window.innerHeight });
		component.set(
			'v.innerHeight',
			component.get('v.formFactor') === 'TABLET' ? `max-height: ${window.innerHeight - 240}px;` : 'max-height: 100%;'
		);
		window.setTimeout(
			$A.getCallback(function () {
				if (component.get('v.items.length') === 0) {
					helper.getCountNotificationsByFilter(component, event, helper);
					helper.handleSearch(component, event, helper);
				}
			}),
			500
		);
		helper.getMyFilter(component, event, helper);
		// console.log(component.get('v.items.length'), {
		// 	document_type: component.get('v.document_type'),
		// 	document_status: component.get('v.document_status')
		// });
	},
	// handleFilter: function (component, event, helper) {
	// 	console.warn('fitlerEnhanceEvent received!');
	// 	var params = event.getParams();
	// 	var filter = component.find('THOR_FilterEnhance').getFilterList();
	// 	component.set('v.filter', filter);
	// 	// console.log(helper.parseObject(filter));
	// 	// component.set('v.pagination.currentPosition', 1);
	// },
	navigateToDisplay: function (component, event, helper) {
		var recordId = event.currentTarget.getAttribute('data-record-id');
		var documentType = String(component.get('v.document_type')).toLowerCase();
		var pageRef = {
			type: 'standard__component',
			attributes: {
				// componentName: ''
			},
			state: {
				c__recordId: recordId
			}
		};
		switch (documentType) {
			case 'notification':
				pageRef.attributes.componentName = 'c__THOR_NotificationRecordDisplay';
				break;
			case 'order':
				pageRef.attributes.componentName = 'c__THOR_OrderRecordDisplay';
				break;
			case 'wc':
				pageRef.attributes.componentName = 'c__THOR_WorkClearanceRecordDisplay';
				break;
			case 'eqcc':
				// pageRef.attributes.componentName = `c__THOR_ApprovalSteps`;
				// pageRef.state.c__forApprovals = false;
				// pageRef.state.c__sheetGroup = component.get('v.notifications').find((f) => f.Id === recordId).sheetGroup || '';
				// // pageRef.state.c__backToTabIndex = '';
				// pageRef.state.c__uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
				// 	let r = (Math.random() * 16) | 0,
				// 		v = c == 'x' ? r : (r & 0x3) | 0x8;
				// 	return v.toString(16);
				// });
				pageRef = {
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${window.btoa(
							JSON.stringify({
								componentDef: `c:THOR_ApprovalSteps`,
								attributes: {
									recordId: recordId,
									// sheetCode: null,
									// backToTabIndex: component.get('v.backToTabIndex'),
									sheetGroup: component.get('v.notifications').find((f) => f.Id === recordId).sheetGroup || '',
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
				break;
			default:
				pageRef = null;
				break;
		}

		try {
			component.find('navService').navigate(pageRef, false);
		} catch (e) {
			console.error(e);
		}
	},
	navigateToPreviousUrl: function (component, event, helper) {
		window.history.back();
	},
	goToPage: function (component, event, helper) {
		component.set('v.pagination.currentPosition', event.getSource().get('v.value'));

		// helper.handleSearch(component, event, helper);
		helper.fetchItems(component, event, helper);
		helper.buildPaginationItems(component, event, helper);
	}
});