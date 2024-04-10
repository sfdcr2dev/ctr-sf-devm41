({
	startLoading: function (component) {
		component.set('v.notification_list_loaded', true);
	},
	stopLoading: function (component) {
		component.set('v.notification_list_loaded', false);
	},
	getNotificationList: function (component, event, helper) {     
		//alert('filterRecordId' + String(component.get('v.filterRecordId')));
		var action = component.get('c.getHistoricalNotificationList');
		action.setParams({
		
			filter: component.get('v.filterRecordId'),
			offset: component.get('v.offset'),
			rowlimit: component.get('v.rowlimit'),
			isSharingSettings: false
		});
		// console.log('filter' + component.get('v.filterRecordId'));
		// alert('SUCCESS');
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				try {
					console.log(JSON.stringify(result));
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

					// for (var i = 0; i < 5; i++) {
					// 	var lst = component.get('v.notification_list').concat(component.get('v.notification_list'));
					// 	component.set('v.notification_list', lst);
					// }
					// component.set(
					// 	'v.notification_list',
					// 	component.get('v.notification_list').splice(0, component.get('v.rowlimit'))
					// );

					helper.calculatePaignation(component);
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
	calculatePaignation: function (component) {
		const runningNunmber =
			component.get('v.totalpage') - component.get('v.currentpage') >= 0 &&
			component.get('v.totalpage') - component.get('v.currentpage') < 6
				? component.get('v.totalpage') - 5 < 0
					? 1
					: component.get('v.totalpage') - 5
				: component.get('v.currentpage') - 2 <= 0
				? component.get('v.currentpage')
				: component.get('v.currentpage') - 2;
		component.set(
			'v.pagination',
			Array(component.get('v.totalpage') < 6 ? component.get('v.totalpage') : 6)
				.fill(
					component.get('v.currentpage') * component.get('v.rowlimit') <= 2000
						? runningNunmber
						: 2000 / component.get('v.rowlimit') - 2
				)
				.map((pageno, index, arr) => {
					if (index === arr.length - 1) {
						// last index
						return component.get('v.totalpage');
					}
					return pageno + index;
				})
		);
		// console.log(JSON.parse(JSON.stringify(component.get('v.pagination'))));
	},
	getMyFilter: function (component, event, helper) {
		var action = component.get('c.getMyFilter');
		action.setParams({
			recordId: component.get('v.filterRecordId') || {}
		});
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log('result=' + result);

				var keys = ['Id', 'Name', 'Filter_type__c', 'Breakdown__c'];
				var filter = {};
				for (var i in result) {
					if (keys.indexOf(i) >= 0) {
						continue;
					}
					if (!Object.prototype.hasOwnProperty.call(result, i)) {
						continue;
					}
					filter[i] = result[i];
					// console.log('filter=' + JSON.stringify(filter));

				}
				component.set('v.isActive', true);
				if (
					filter &&
					Object.keys(filter).length === 0 &&
					Object.getPrototypeOf(filter) === Object.prototype&&
					!result.Breakdown__c
				) {
					component.set('v.isActive', false);
				}
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
		});
		$A.enqueueAction(action);
	}
});