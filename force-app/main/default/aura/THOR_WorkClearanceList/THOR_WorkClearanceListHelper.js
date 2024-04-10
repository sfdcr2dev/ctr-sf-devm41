({
	getCountInProgressWorkClearancesByFilter: function (component, event, helper) {
		var action = component.get('c.getCountInProgressWorkClearancesByFilter');
		action.setParams({
			filter: component.get('v.filter') || {}
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				component.set('v.workClearances_execution_count', result);
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
		});

		$A.enqueueAction(action);
	},

	getCountWithoutNotiAndOrderWorkClearances: function (component, event, helper) {
		var action = component.get('c.getCountWithoutNotiAndOrderWorkClearancesByFilter');
		action.setParams({
			filter: component.get('v.filter') || {}
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				component.set('v.workClearances_new_count', result);
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
		});

		$A.enqueueAction(action);
	},

	getInProgressWorkClearancesByFilter: function (component, event, helper) {
		component.set('v.workClearances_execution_loading', true);
		var action = component.get('c.getInProgressWorkClearancesByFilter');
		action.setParams({
			filter: component.get('v.filter') || {},
			offset: 0,
			rowlimit: 3
		});
		action.setCallback(this, function (response) {
			component.set('v.workClearances_execution_loading', false);
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				component.set(
					'v.workClearances_execution',
					result.map((m) => {
						let extendNo = m.Extend_No__c ? '/' + m.Extend_No__c : '';
						m.Name = m.Name + extendNo;
						m.info = `${m.Notification__r ? m.Notification__r.Name : ''} . ${m.Order__r ? m.Order__r.Name : ''} . ${
							m.Functional_Location__c || ''
						} .  ${m.Priority__c ? m.Priority__c : ''} . ${
							m.Main_Work_Center__r ? m.Main_Work_Center__r.Name : ''
						} . ${m.Description__c ? m.Description__c : ''}`;
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

	getWithoutNotiAndOrderWorkClearances: function (component, event, helper) {
		component.set('v.workClearances_new_loading', true);
		var action = component.get('c.getWithoutNotiAndOrderWorkClearancesByFilter');
		action.setParams({
			filter: component.get('v.filter') || {},
			offset: 0,
			rowlimit: 3
		});
		action.setCallback(this, function (response) {
			component.set('v.workClearances_new_loading', false);
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
        console.log(result);
				component.set(
					'v.workClearances_new',
					result.map((m) => {
						let extendNo = m.Extend_No__c ? '/' + m.Extend_No__c : '';
						m.Name = m.Name + extendNo;
						m.info = `${m.Functional_Location__c || ''} . ${
							m.Main_Work_Center__r ? m.Main_Work_Center__r.Name : ''
						} . ${m.Description__c || ''}`;
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

	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	}
});