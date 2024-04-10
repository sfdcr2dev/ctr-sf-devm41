({
	getUser: function (component, event, helper) {
		var action = component.get("c.getUser");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				let user = response.getReturnValue();
				component.set("v.user", user);
				component.set("v.filterDefaultNoti.Main_Work_Center__c", user.Main_Work_Center__c);
				component.set("v.isLoadedMainWorkCenter", true);

				window.setTimeout($A.getCallback(function () {
					let odmFilterEnhance = component.find('ODM_FilterEnhance');
					if (odmFilterEnhance && typeof (odmFilterEnhance.updateFilterList) === 'function') {
						let filter = odmFilterEnhance.getFilterList();
						component.set(
							'v.filter',
							Object.keys(filter).reduce((acc, key) => {
								acc[key] = filter[key];
								return acc;
							}, {
								Notification_Status__c: 'New;In Progress'
							})
						);
					}
					helper.getNotificationList(component, event, helper);
				}), 1000);
			}
		});
		$A.enqueueAction(action);
	},
	startLoading: function (component) {
		component.set('v.isLoadingNotificationList', true);
	},
	stopLoading: function (component) {
		component.set('v.isLoadingNotificationList', false);
	},
	getNotificationList: function (component, event, helper) {
		var action = component.get('c.getNotificationList');

		let filter = component.get('v.filter');
		if (filter.Main_Work_Center__c === 'MFOP') {
			delete filter.Main_Work_Center__c;
		}

		action.setParams({
			filter: Object.keys(filter).length
				? filter
				: {
					Notification_Status__c: 'New;In Progress'
				},
			offset: component.get('v.offset'),
			rowlimit: component.get('v.rowlimit'),
			isSharingSettings: true
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				try {
					// console.log(result);
					const { data, count } = result;
					component.set('v.totalrecord', count);
					component.set('v.totalpage', Math.ceil(component.get('v.totalrecord') / component.get('v.rowlimit')));
					component.set(
						'v.notification_list',
						data.map((m) => {
							m.Requested_Date__c = m.Requested_Date__c
								? new Date(m.Requested_Date__c).toLocaleDateString('en-GB')
								: '';
							m.info = ['Notification_Status__c', 'Type__c', 'Functional_Location__r.Name', 'Requested_Date__c']
								.map((k) => {
									if (k.includes('.') && m[k.split('.')[0]]) {
										m[k] = m[k.split('.')[0]][k.split('.')[1]];
									}
									return m[k] || '';
								})
								.join(' . ');
							m.description = m.Description__c || '';
							return m;
						})
					);

					// helper.calculatePaignation(component);
				} catch (error) {
					console.log(error);
				}
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
			component.set('v.isInitialized', true);
			helper.stopLoading(component);
		});

		$A.enqueueAction(action);
		helper.startLoading(component);
	},
	// calculatePaignation: function (component) {
	// 	const runningNunmber =
	// 		component.get('v.totalpage') - component.get('v.currentpage') >= 0 &&
	// 			component.get('v.totalpage') - component.get('v.currentpage') < 6
	// 			? component.get('v.totalpage') - 5 < 0
	// 				? 1
	// 				: component.get('v.totalpage') - 5
	// 			: component.get('v.currentpage') - 2 <= 0
	// 				? component.get('v.currentpage')
	// 				: component.get('v.currentpage') - 2;
	// 	component.set(
	// 		'v.pagination',
	// 		Array(component.get('v.totalpage') < 6 ? component.get('v.totalpage') : 6)
	// 			.fill(
	// 				(component.get('v.currentpage') - 1) * component.get('v.rowlimit') <= 2000
	// 					? runningNunmber
	// 					: 2000 / component.get('v.rowlimit') - 2
	// 			)
	// 			.map((pageno, index, arr) => {
	// 				if (index === arr.length - 1) {
	// 					// last index
	// 					return component.get('v.totalpage');
	// 				}
	// 				return pageno + index;
	// 			})
	// 	);
	// 	// console.log(JSON.parse(JSON.stringify(component.get('v.pagination'))));
	// },
})