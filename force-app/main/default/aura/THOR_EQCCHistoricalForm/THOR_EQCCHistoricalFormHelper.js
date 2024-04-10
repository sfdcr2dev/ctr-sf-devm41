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
		var status = 'In Progress';
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
								document_type: 'EQCC',
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
		// //console.log({ fields });
		action.setParams({
			filterType: 'EQCCHistorical',
			fields
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				setTimeout(
					$A.getCallback(() => {
						component.set('v.filterId', result.Id);
						component.set('v.form', result);
					}),
					1000
				);
			} else {
				var error = response.getError();
				console.error(helper.parseObject(error));
			}
		});
		$A.enqueueAction(action);
	}
});