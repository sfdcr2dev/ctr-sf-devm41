({
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},
	getNotifications: function (component, event, helper) {
		var action = component.get('c.getNotificationsByFilter');
		// console.log(helper.parseObject(component.get('v.filter.THOR_FilterHomeNotificationFrom')))

		action.setParams({
			filter: component.get('v.filter.THOR_FilterHomeNotificationFrom') || {}
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				const { status_new } = result;
				// console.log(status_new);
				component.set('v.results.notifications', status_new);
				component.set(
					'v.notifications',
					status_new.records.map((m) => {
						m.info = `${m.Type__c} . ${m.Functional_Location__r ? m.Functional_Location__r.Name : ''} . ${
							m.Priority__c
						} . ${m.Requested_Date__c ? new Date(m.Requested_Date__c).toLocaleDateString('en-GB') : ''}`;
						return m;
					})
				);
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
		});

		$A.enqueueAction(action);
	},
	getOrders: function (component, event, helper) {
		var action = component.get('c.getOrdersByFilter');
		// console.log(helper.parseObject(component.get('v.filter.THOR_FilterHomeOrderFrom')))

		action.setParams({
			filter: component.get('v.filter.THOR_FilterHomeOrderFrom') || {}
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				const { status_new } = result;
				// console.log(status_new);
				component.set('v.results.orders', status_new);
				component.set(
					'v.orders',
					status_new.records.map((m) => {
						m.info = `${m.Order_Type__c} . ${m.Functional_Location__r ? m.Functional_Location__r.Name : ''} . ${
							m.Priority__c
						} . ${new Date(m.CreatedDate).toLocaleDateString('en-GB')}`;
						return m;
					})
				);
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
		});

		$A.enqueueAction(action);
	}
});