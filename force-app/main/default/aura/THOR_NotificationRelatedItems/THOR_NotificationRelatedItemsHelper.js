({
	getRelatedObjects: function (component) {
		var action = component.get('c.getRelatedObjects');
		action.setParams({
			notificationIdentifier: component.get('v.notificationId')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				const result = response.getReturnValue();
        // console.log(result)
				component.set('v.notificationObj', result.notificationObj);
				component.set('v.hasEditAccess', result.hasEditAccess || false);

				var returnedlist = result.relatedItems;
				var itemsRelated = [];
				var columns = {
					'Object Part Code group': 'Object_Part_Code_Group_Text__c',
					'Object Part Code text': 'Object_Part_Code_Text__c',
					'Items Create on': 'CreatedDate',
					'Integration Status': 'Integration_Status__c'
				};
				returnedlist.forEach((element, index) => {
					var item = {
						recordId: element.recordId,
						isLoading: false
					};
					element.dropableBody.forEach((ee, ii) => {
						item[columns[ee.label]] = ee.value;
					});
					itemsRelated.push(item);
				});
				component.set('v.itemsRelated', itemsRelated);
			} else if (state === 'ERROR') {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log('Error message: ' + errors[0].message);
					}
				} else {
					console.log('Unknown error');
				}
			}
			component.set('v.isLoading', false);
		});
		if (component.get('v.itemsRelated.length')) {
			component.set(
				'v.itemsRelated',
				component.get('v.itemsRelated').map((m) => {
					if (m.Integration_Status__c === 'In Progress') m.isLoading = true;
					return m;
				})
			);
		}
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},

	handleSetInterval: function (component) {
		var helper = this;
		component.set(
			'v.interval',
			setInterval(
				$A.getCallback(() => {
					if (
						component.get('v.itemsRelated') &&
						component
							.get('v.itemsRelated')
							.some((s) => s.Integration_Status__c && s.Integration_Status__c == 'In Progress')
					) {
						helper.getRelatedObjects(component);
					} else if (component.get('v.interval')) {
						console.warn('clearInterval');
						clearInterval(component.get('v.interval'));
						component.set('v.interval', null);
					}
				}),
				5000
			)
		);
	}
});