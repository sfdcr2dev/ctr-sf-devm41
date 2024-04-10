({
	helperInit: function (component, event, helper) {
		const calcDate = () => {
			let value = ``;
			if (component.get('v.filter.CreatedDatedFrom')) {
				value += `CreatedDate >= ${component.get('v.filter.CreatedDatedFrom')}T00:00:00.000+0700`;
			}
			if (component.get('v.filter.CreatedDatedTo')) {
				value =
					(value ? value + ' AND ' : '') +
					`CreatedDate <= ${component.get('v.filter.CreatedDatedTo')}T23:59:59.000+0700`;
			}
			return `${value}`;
		};
		const userActive = () => {
			let value = ``;
			if (component.get('v.filter.userIsActive')) {
				value = `Responsible_person_PISUser__r.EN_Fullname__c = '${component.get('v.userObj.Name')}'`;
			}
			return value;
		};

		helper.getSubOrderListRelatedByStatus(component, 'New', {
			Order_Status__c: `Order_Status__c = 'New'`,
			'Responsible_person_PISUser__r.EN_Fullname__c': userActive(),
			CreatedDate: calcDate()
		});
		helper.getSubOrderListRelatedByStatus(component, 'In Progress', {
			Order_Status__c: `Order_Status__c IN ('In Progress', 'Closed')`,
			'Responsible_person_PISUser__r.EN_Fullname__c': userActive(),
			CreatedDate: calcDate()
		});
	},
	getSubOrderListRelatedByStatus: function (component, status, filter) {
		component.set(
			`v.orderMap.${
				{
					New: 'newIsLoading',
					'In Progress': 'inprogressIsLoading'
				}[status]
			}`,
			true
		);

		var helper = this;
		const recordId = component.get('v.orderId');

		var action = component.get('c.getSubOrdersListRelatedByStatus');
		action.setParams({
			recordId,
			filter
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				if (status === 'New') {
					component.set(
						`v.orderMap.newList`,
						result.map((m) => {
							m.info = `${m.Order_Type__c} . ${m.Functional_Location__r ? m.Functional_Location__r.Name : ''} . ${
								m.Priority__c
							} . ${new Date(m.CreatedDate).toLocaleDateString('en-GB')}`;
							return m;
						})
					);
					component.set(`v.orderMap.newTitle`, `You have ${result.length} New Sub Orders`);
					component.set(`v.orderMap.newLabel`, `Order number, Order Type, FL, Priority, Create on, Description`);
				} else if (['In Progress', 'Closed'].includes(status)) {
					component.set(
						`v.orderMap.inprogressList`,
						result.map((m) => {
							m.info = `${m.Order_Type__c} . ${m.Functional_Location__r ? m.Functional_Location__r.Name : ''} . ${
								m.Priority__c
							} . ${new Date(m.CreatedDate).toLocaleDateString('en-GB')}`;
							return m;
						})
					);
					component.set(`v.orderMap.inprogressTitle`, `You have ${result.length} Execution Sub Orders`);
					component.set(`v.orderMap.inprogressLabel`, `Order number, Order Type, FL, Priority, Create on, Description`);
				}
			} else {
				var errors = response.getError();
				console.error(errors);
			}
			component.set('v.isLoading', false);
			component.set(
				`v.orderMap.${
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
	},

	navigateBack: function (component) {
		var pageRef = component.get('v.pageReference');
		let navLink = component.find('navLink');
		pageRef = {
			type: 'standard__component',
			attributes: {
				componentName: 'c__THOR_OrderRecordDisplay'
			},
			state: {
				c__recordId: component.get('v.orderId')
			}
		};
		navLink.navigate(pageRef, true);
	}
});