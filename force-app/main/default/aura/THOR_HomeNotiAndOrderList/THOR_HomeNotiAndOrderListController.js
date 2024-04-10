({
	doInit: function (component, event, helper) {
		setTimeout(
			$A.getCallback(function () {
				if (component.get('v.notifications.length') === 0) {
					// console.log('doInit run!, notifications', component.get('v.notifications.length'));
					helper.getNotifications(component, event, helper);
				}
				if (component.get('v.orders.length') === 0) {
					// console.log('doInit run!, orders', component.get('v.orders.length'));
					helper.getOrders(component, event, helper);
				}
			}),
			500
		);
		// helper.getNotifications(component, event, helper)
		// helper.getOrders(component, event, helper)
	},
	handleFilter: function (component, event, helper) {
		console.warn('fitlerEnhanceEvent received!');
		var params = event.getParams();
		const { filterPage } = params;
		component.find('THOR_FilterEnhance').forEach(function (cmp) {
			component.set(`v.filter.${cmp.get('v.filterPage')}`, cmp.getFilterList());
		});

		if (filterPage == 'THOR_FilterHomeNotificationFrom') {
			helper.getNotifications(component, event, helper);
		} else if (filterPage == 'THOR_FilterHomeOrderFrom') {
			helper.getOrders(component, event, helper);
		}
	},
	navigateToDisplay: function (component, event, helper) {
		var recordId = event.currentTarget.getAttribute('data-record-id');
		var componentDef = event.currentTarget.getAttribute('data-component-def');
		var navService = component.find('navService');
		navService.navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: componentDef
				},
				state: {
					c__recordId: recordId
				}
			},
			false
		);
	},
	redirectNotiAll: function (component, event, helper) {
		var navService = component.find('navService');
		navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${btoa(
						JSON.stringify({
							componentDef: `c:THOR_NotificationListPaging`,
							attributes: {
								document_type: 'HomeNotification',
								document_status: 'New',
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
	redirectOrderAll: function (component, event, helper) {
		var navService = component.find('navService');
		navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${btoa(
						JSON.stringify({
							componentDef: `c:THOR_NotificationListPaging`,
							attributes: {
								document_type: 'HomeOrder',
								document_status: 'New',
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