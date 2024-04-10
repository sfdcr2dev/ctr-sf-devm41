({
	doInit: function (component, event, helper) {
		helper.getRelatedWorkClearances(component, event, helper);
		helper.hasWriteAccess(component, event, helper);
	},

	goToWorkClearance: function (component, event, helper) {
		var recordId = event.currentTarget.getAttribute('data-record-id');
		var isHistorical = event.currentTarget.getAttribute('data-is-historical') === 'true';
		var navService = component.find('navService');

		navService.navigate(
			// {
			// 	type: 'standard__webPage',
			// 	attributes: {
			// 		url: `/one/one.app#${btoa(
			// 			JSON.stringify({
			// 				componentDef: `c:THOR_WorkClearanceRecordDisplay`,
			// 				attributes: {
			// 					recordId: recordId,
			// 					isHistorical: isHistorical,
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
					c__recordId: recordId,
					c__isHistorical: isHistorical
					// uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
					// 	let r = (Math.random() * 16) | 0,
					// 		v = c == 'x' ? r : (r & 0x3) | 0x8;
					// 	return v.toString(16);
					// })
				}
			},

			false
		);
	},

	toggleAccordion: function (component, event, helper) {
		let index;
		if (typeof event.getSource === 'function') {
			index = event.getSource().get('v.value');
		}
		if (typeof event.currentTarget.dataset === 'object') {
			index = event.currentTarget.dataset.index;
		}
		let workClearances = component.get('v.RelatedWorkClearances');
		workClearances[index].WorkClearance.showHistory = !workClearances[index].WorkClearance.showHistory;
		component.set('v.RelatedWorkClearances', workClearances);

		event.stopPropagation();
	}
});