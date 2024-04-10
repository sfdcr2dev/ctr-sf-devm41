({
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},
	getOrders: function (component, event, helper) {
		var action = component.get('c.getOrdersByFilter');
		action.setParams({
			filter: component.get('v.filter') || {}
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				const { status_new, status_inprogess } = result;
				component.set('v.orders', result);
				component.set('v.orders_length', status_new.count + status_inprogess.count);

				component.set(
					'v.orders_new',
					status_new.records.map((m) => {
						m.info = `${m.Order_Type__c} . ${m.Functional_Location__r ? m.Functional_Location__r.Name : ''} . ${
							m.Priority__c
						} . ${new Date(m.CreatedDate).toLocaleDateString('en-GB')}`;
						return m;
					})
				);
				component.set(
					'v.orders_execution',
					status_inprogess.records.map((m) => {
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