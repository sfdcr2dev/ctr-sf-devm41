({
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},
	startLoading: function (component) {
		component.set('v.isLoading', true);
	},
	stopLoading: function (component) {
		component.set('v.isLoading', false);
	},

	redirectAll: function (component, event) {
		// alert('direct');
		var status = 'New';
		var filterId = component.get('v.filterId');
		var navService = component.find('navService');
		navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${btoa(
						JSON.stringify({
							componentDef: `c:THOR_HistoricalSearchList`,
							attributes: {
								document_type: 'WC',
								document_status: status,
								filterRecordId: filterId,
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
	getMyFilterHistoricalSearch: function (component, event, helper) {
		var action = component.get('c.getMyFilterHistoricalSearch');
		var fields = component.find('inputField').map((m) => m.get('v.fieldName'));
		// console.log('FIELD:' +{ fields });
		action.setParams({
			filterType: 'WorkClearanceHistorical',
			fields
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(result);

				component.set('v.filterId', result.Id);
				component.set('v.form', result);
				const { NotificationTypeMulti__c, OrderTypeMulti__c, StatusMulti__c, PriorityMulti__c } = result;
				try {
					setTimeout(
						$A.getCallback(() => {
							$('#picklistNotiType_WCForm')
								.val(NotificationTypeMulti__c ? NotificationTypeMulti__c.split(';') : null)
								.trigger('change');
							$('#picklistOrderType_WCForm')
								.val(OrderTypeMulti__c ? OrderTypeMulti__c.split(';') : null)
								.trigger('change');
							$('#picklistWcStatus_WCForm')
								.val(StatusMulti__c ? StatusMulti__c.split(';') : null)
								.trigger('change');
							$('#picklistPriority_WCForm')
								.val(PriorityMulti__c ? PriorityMulti__c.split(';') : null)
								.trigger('change');
						}, 500)
					);
				} catch (error) {
					console.error(error);
				}
			} else {
				var error = response.getError();
				console.error(helper.parseObject(error));
			}
		});
		$A.enqueueAction(action);
	}
});