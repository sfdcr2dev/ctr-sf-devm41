({
	helperInit: function (component, event, helper) {
		helper.getOrderOperationRelated(component);
	},
	getOrderOperationRelated: function (component) {
		// var helper = this;
		component.set(`v.config.newIsLoading`, true);
		const recordId = component.get('v.orderId');
		var action = component.get('c.getOrderOperationRelated');
		action.setParams({
			recordId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				// Title
				component.set(`v.config.newTitle`, `You have ${result.length} Related Operations`);

				// Label
				component.set(`v.config.newLabel`, `Operation No, Sub Operation, Main Work Center, Operation Short Text`);

				// Record
				component.set(
					`v.config.newList`,
					result.map((m) => {
						m.info = `${m.Operation__r ? m.Operation__r.Name : ''} . ${m.SubOperation__c || ''} . ${
							m.Main_Work_Center_Text__c || ''
						} . ${m.Operation_Shot_Text__c || ''}`;
						return m;
					})
				);
			} else {
				var errors = response.getError();
				console.error(errors);
			}

			component.set('v.isLoading', false);
			component.set(`v.config.newIsLoading`, false);
		});

		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	}
});