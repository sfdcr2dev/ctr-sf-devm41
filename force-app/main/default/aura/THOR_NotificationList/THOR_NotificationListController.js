({
	doInit: function (component, event, helper) {
		window.setTimeout(
			$A.getCallback(function () {
				if (component.get('v.filter') && Object.keys(component.get('v.filter')).length === 0) {
					helper.getNotifications(component, event, helper);
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

		helper.getNotifications(component, event, helper);
	},
	navigateToDisplay: function (component, event, helper) {
		var recordId = event.currentTarget.getAttribute('data-record-id');
		var navService = component.find('navService');
		navService.navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__THOR_NotificationRecordDisplay'
				},
				state: {
					c__recordId: recordId
				}
			},
			false
		);
	},
	redirectNotiAll: function (component, event, helper) {
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
								document_type: 'Notification',
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