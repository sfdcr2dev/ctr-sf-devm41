({
	fireEvent: function (component) {
		console.warn('fitlerEnhanceEvent send!');

		var cmpEvent = component.getEvent('fitlerEnhanceEvent');
		cmpEvent.setParams({
			message: 'Send!',
			filterPage: component.get('v.filterPage')
		});
		cmpEvent.fire();
	},
	getMyFilter: function (component) {
		var helper = this;
		var action = component.get('c.getMyFilter');
		action.setParams({
			filterType: component.get(`v.filterType.${component.get('v.filterPage')}`),
			formPage: component.get('v.filterPage')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(result);
				if (result) {
					var isActive = result.IsActive__c;
					component.set('v.recordId', result.Id);
					component.set('v.isActive', result.IsActive__c);

					delete result.IsActive__c;
					delete result.Id;
					component.set('v.filterMap', result);
					if (isActive) helper.fireEvent(component);
				}
			} else if (state === 'ERROR') {
				var errors = response.getError();
				console.error(errors);
			}
			helper.stopLoading(component);
		});
		$A.enqueueAction(action);
	},
	setMyFilter: function(component, filter) {
		var helper = this;
		var action = component.get('c.setMyFilter');
		action.setParams({
			filterType: component.get(`v.filterType.${component.get('v.filterPage')}`),
			formPage: component.get('v.filterPage'),
			filter: filter,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(result);
				if (result) {
					var isActive = result.IsActive__c;
					component.set('v.recordId', result.Id);
					component.set('v.isActive', result.IsActive__c);

					delete result.IsActive__c;
					delete result.Id;
					component.set('v.filterMap', result);
					if (isActive) helper.fireEvent(component);
				}
			} else if (state === 'ERROR') {
				var errors = response.getError();
				console.error(errors);
			}
			helper.stopLoading(component);
		});
		$A.enqueueAction(action);
	},
	generateFormFilter: function (component) {
		$A.createComponents(
			[
				[
					`lightning:inputField`,
					{
						'aura:id': 'Filter_type__c',
						class: 'slds-hide',
						fieldName: 'Filter_type__c',
						value: component.get(`v.filterType.${component.get('v.filterPage')}`)
					}
				],
				[
					`c:${component.get('v.filterPage')}`,
					{
						'aura:id': 'filterForm'
					}
				]
			],
			function (cmp, status, errorMessage) {
				//Add the new components to the body array
				if (status === 'SUCCESS') {
					component.set('v.formBody', cmp);
					// try {
					// 	console.log(
					// 		component
					// 			.get('v.formBody.1')
					// 			.find('inputField')
					// 			.reduce((acc, e) => {
					// 				acc.push(e.get('v.fieldName'));
					// 				return acc;
					// 			}, [])
					// 	);
					// } catch (err) {
					// 	console.error(err);
					// }
				} else {
					console.error('Status: ' + status, 'Error: ' + errorMessage);
				}
			}
		);
	},
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},
	startLoading: function (component) {
		component.set('v.isLoading', true);
	},
	stopLoading: function (component) {
		component.set('v.isLoading', false);
	}
});