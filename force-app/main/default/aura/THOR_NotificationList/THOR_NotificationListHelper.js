({
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},
	getNotifications: function (component, event, helper) {
		var action = component.get('c.getNotificationsByFilter');
		action.setParams({
			filter: component.get('v.filter') || {}
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				const { status_new, status_inprogess } = result;
				component.set('v.notifications', result);
				component.set('v.notifications_length', status_new.count + status_inprogess.count);

				component.set(
					'v.notifications_new',
					status_new.records.map((m) => {
						m.info = `${m.Type__c} . ${m.Functional_Location__r ? m.Functional_Location__r.Name : ''} . ${
							m.Priority__c
						} . ${m.Requested_Date__c ? new Date(m.Requested_Date__c).toLocaleDateString('en-GB') : ''}`;
						return m;
					})
				);
				component.set(
					'v.notifications_execution',
					status_inprogess.records.map((m) => {
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
	}
});