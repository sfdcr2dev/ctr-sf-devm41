({
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},

	parseListEqcc: function (list, type) {
		list = list.map((m) => {
			m.Name = `${m.FunctionalLocation__r ? m.FunctionalLocation__r.Name : ''}, ${
				m.Equipment__r ? m.Equipment__r.Name : ''
			}`;

			if (['inprogress', 'in progress'].includes(type.toLowerCase())) {
				m.Name = `${m.Notification__r ? m.Notification__r.Notification_Number__c : ''}, ${
					m.Order__r ? m.Order__r.Order_Number__c : ''
				}, ${m.Name}, ${
					m.Notification__r ? m.Notification__r.Description__c || '' : m.Order__r ? m.Order__r.Description__c || '' : ''
				}`;
			}
			m.infos = m.Header_Sheets__r.map((h) => {
				return {
					text: `\t=> ${h.Name}, ${h.Sheet__r.Sheet_Code__c || ''}, ${h.Sheet__r.Form_Name__c || ''}, ${
						h.Status__c || ''
					}, ${h.Requester__c || ''}, ${new Date(h.CreatedDate).toLocaleDateString('en-GB')}, ${new Date(
						h.LastModifiedDate
					).toLocaleDateString('en-GB')}`,
					recordId: h.Id
				};
			});
			return m;
		});
		return list;
	},
	getWithoutNotificationOrOrderEQCCsByFilter: function (component, event, helper) {
		var action = component.get('c.getWithoutNotificationOrOrderEQCCsByFilter');
		action.setParams({
			filter: component.get('v.filter') || {},
			offset: 0,
			rowlimit: component.get('v.eqccMapConfig.new.limit')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				let result = response.getReturnValue();

				component.set('v.withoutNotificationsList', helper.parseListEqcc(result, 'new'));
				// console.log(helper.parseObject(component.get('v.withoutNotificationsList')));
				helper.getEqccCurrentStep(
					component,
					component
						.get('v.withoutNotificationsList')
						.reduce((l, item) => [...l, ...item.Header_Sheets__r.map((m) => m.Id)], [])
				);
			} else if (state === 'ERROR') {
				var errors = response.getError();
				console.error(errors);
			}
			component.set('v.eqccMapConfig.new.isLoading', false);
		});
		component.set('v.eqccMapConfig.new.isLoading', true);
		$A.enqueueAction(action);
		helper.getCountList(component, 'getCountWithoutNotificationOrOrderEQCCsByFilter');
	},
	getInProgressEQCCsByFilter: function (component, event, helper) {
		var action = component.get('c.getInProgressEQCCsByFilter');
		action.setParams({
			filter: component.get('v.filter') || {},
			offset: 0,
			rowlimit: component.get('v.eqccMapConfig.inprogress.limit')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				let result = response.getReturnValue();

				component.set('v.inProgressList', helper.parseListEqcc(result, 'inprogress'));
				// console.log(helper.parseObject(component.get('v.inProgressList')));
				helper.getEqccCurrentStep(
					component,
					component.get('v.inProgressList').reduce((l, item) => [...l, ...item.Header_Sheets__r.map((m) => m.Id)], [])
				);
			} else if (state === 'ERROR') {
				var errors = response.getError();
				console.error(errors);
			}
			component.set('v.eqccMapConfig.inprogress.isLoading', false);
		});
		component.set('v.eqccMapConfig.inprogress.isLoading', true);
		$A.enqueueAction(action);
		helper.getCountList(component, 'getCountInProgressEQCCsByFilter');
	},
	getCountList: function (component, methodName) {
		var action = component.get(`c.${methodName}`);
		action.setParams({
			filter: component.get('v.filter') || {}
		});
		action.setCallback(this, (response) => {
			var state = response.getState();
			if (state === 'SUCCESS') {
				let result = response.getReturnValue();
				if (methodName === 'getCountWithoutNotificationOrOrderEQCCsByFilter') {
					component.set('v.withoutNotificationsListCount', result);
				} else if (methodName === 'getCountInProgressEQCCsByFilter') {
					component.set('v.inProgressListCount', result);
				}
			} else if (state === 'ERROR') {
				console.error(response.getError());
			}
		});
		$A.enqueueAction(action);
	},
	getEqccCurrentStep: function (component, headerSheetIds) {
		var action = component.get('c.getEqccCurrentStep');
		action.setParams({
			headerSheetIds
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				Object.keys(result).forEach((key) => {
					component.set(`v.eqccStep.${key}`, result[key]);
				});
				// console.log(JSON.parse(JSON.stringify(component.get('v.eqccStep'))));
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
		});
		$A.enqueueAction(action);
	}
});