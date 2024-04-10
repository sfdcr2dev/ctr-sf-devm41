({
	helperInit: function (component, event, helper) {
		helper.getNotificationRelated(component, 'New');
		helper.getNotificationRelated(component, 'In Progress');
	},
	getNotificationRelated: function (component, status) {
		// var helper = this;
		component.set(
			`v.config.${
				{
					New: 'newIsLoading',
					'In Progress': 'inprogressIsLoading'
				}[status]
			}`,
			true
		);
		const recordId = component.get('v.orderId');
		var action = component.get('c.getNotificationRelatedByStatus');
		action.setParams({
			recordId,
			filter: {
				Notification_Status__c: {
					New: `Notification_Status__c = 'New'`,
					'In Progress': `Notification_Status__c IN ('In Progress', 'Closed')`
				}[status]
			}
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				// Title
				component.set(
					`v.config.${
						{
							New: 'newTitle',
							'In Progress': 'inprogressTitle'
						}[status]
					}`,
					`You have ${result.length} ${
						{
							New: 'New',
							'In Progress': 'Execution'
						}[status]
					} Notifications`
				);

				// Label
				component.set(
					`v.config.${
						{
							New: 'newLabel',
							'In Progress': 'inprogressLabel'
						}[status]
					}`,
					`Notification type, FL, Priority, Create on, Description`
				);

				// Record
				component.set(
					`v.config.${
						{
							New: 'newList',
							'In Progress': 'inprogressList'
						}[status]
					}`,
					result.map((m) => {
						m.info = `${m.Type__c} . ${m.Functional_Location__r ? m.Functional_Location__r.Name : ''} . ${
							m.Priority__c
						} . ${new Date(m.Requested_Date__c).toLocaleDateString('en-GB')}`;
						return m;
					})
				);
			} else {
				var errors = response.getError();
				console.error(errors);
			}

			component.set('v.isLoading', false);
			component.set(
				`v.config.${
					{
						New: 'newIsLoading',
						'In Progress': 'inprogressIsLoading'
					}[status]
				}`,
				false
			);
		});

		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	}
});