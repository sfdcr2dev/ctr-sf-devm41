({
	doInit: function (component, event, helper) {
		window.setTimeout(
			$A.getCallback(function () {
				if (component.get('v.workClearances_new.length') === 0) {
					helper.getWithoutNotiAndOrderWorkClearances(component, event, helper);
				}
				if (component.get('v.workClearances_new_count') === 0) {
					helper.getCountWithoutNotiAndOrderWorkClearances(component, event, helper);
				}
				if (component.get('v.workClearances_execution.length') === 0) {
					helper.getInProgressWorkClearancesByFilter(component, event, helper);
				}
				if (component.get('v.workClearances_execution_count') === 0) {
					helper.getCountInProgressWorkClearancesByFilter(component, event, helper);
				}
			}),
			500
		);
	},

	handleFilter: function (component, event, helper) {
		console.warn('fitlerEnhanceEvent received!');
		var params = event.getParams();
		var filter = component.find('THOR_FilterEnhance').getFilterList();
		component.set('v.filter', filter);
		// console.log(helper.parseObject(filter))
		helper.getWithoutNotiAndOrderWorkClearances(component, event, helper);
		helper.getCountWithoutNotiAndOrderWorkClearances(component, event, helper);
		helper.getInProgressWorkClearancesByFilter(component, event, helper);
		helper.getCountInProgressWorkClearancesByFilter(component, event, helper);
	},

	navigateToDisplay: function (component, event, helper) {
		var recordId = event.currentTarget.getAttribute('data-record-id');

		component.find('navService').navigate(
			// {
			// 	type: 'standard__webPage',
			// 	attributes: {
			// 		url: `/one/one.app#${btoa(
			// 			JSON.stringify({
			// 				componentDef: `c:THOR_WorkClearanceRecordDisplay`,
			// 				attributes: {
			// 					recordId: recordId,
			// 					uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
			// 						let r = (Math.random() * 16) | 0,
			// 							v = c == 'x' ? r : (r & 0x3) | 0x8;
			// 						return v.toString(16);
			// 					})
			// 				}
			// 			})
			// 		)}`
			// 	}
			// },
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__THOR_WorkClearanceRecordDisplay'
				},
				state: {
					c__recordId: recordId
				}
			},
			false
		);
	},

	redirectWorkClearanceAll: function (component, event, helper) {
		var status = event.getSource().get('v.name');
		var navService = component.find('navService');
		navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${btoa(
						JSON.stringify({
							componentDef: `c:THOR_NotificationListPaging`,
							attributes: {
								document_type: 'WorkClearance',
								document_status: status,
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
});