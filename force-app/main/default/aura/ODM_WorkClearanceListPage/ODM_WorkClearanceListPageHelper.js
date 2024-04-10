({
	startLoading: function (component) {
		component.set('v.isLoadingWorkClearanceList', true);
	},
	stopLoading: function (component) {
		component.set('v.isLoadingWorkClearanceList', false);
	},
	getUser: function (component, event, helper) {
		var action = component.get("c.getUser");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				let user = response.getReturnValue();
				component.set("v.user", user);
				component.set("v.filterDefaultWc.Main_Work_Center__c", user.Main_Work_Center__c);
				component.set("v.filterDefaultVeriWc.Main_Work_Center__c", user.Main_Work_Center__c);
				component.set("v.filterDefaultInspecWc.Main_Work_Center__c", user.Main_Work_Center__c);

				component.set("v.isLoadedMainWorkCenter", true);

				window.setTimeout(
					$A.getCallback(function () {
						if ('Verification' == component.get('v.listPage')) {
							//if (component.get('v.veri_wclist.length') !== 0) {
								var filter = component.find('ODM_WorkClearanceVerificationFilter').getFilterList();
								component.set(
									'v.veri_filter',
									Object.keys(filter).reduce(
										(acc, key) => {
											acc[key] = filter[key];
											return acc;
										}, {
										Work_Clearance_Status__c: 'Created;In Progress;Inactive'
									}
									)
								);
							//}
							helper.getWcVerificationList(component, event, helper);
						} else if ('Inspection' == component.get('v.listPage')) {
							//if (component.get('v.inspect_wclist.length') !== 0) {
								var filter = component.find('ODM_WorkClearanceInspectionFilter').getFilterList();
								component.set(
									'v.inspect_filter',
									Object.keys(filter).reduce(
										(acc, key) => {
											acc[key] = filter[key];
											return acc;
										}, {
										Work_Clearance_Status__c: 'Created;In Progress;Inactive'
									}
									)
								);
							//}
							helper.getWcInspectionList(component, event, helper);
						} else if ('WorkClearance' == component.get('v.listPage')) {
							//if (component.get('v.wclist.length') !== 0) {
								var filter = component.find('ODM_WorkClearanceFilter').getFilterList();
								component.set(
									'v.filter',
									Object.keys(filter).reduce(
										(acc, key) => {
											acc[key] = filter[key];
											return acc;
										},
										{
											Work_Clearance_Status__c: 'Created;In Progress;Inactive'
										}
									)
								);
							//}
							helper.getWcList(component, event, helper);
						}
					}),
					1000
				);
			}
		});
		$A.enqueueAction(action);
	},
	getWcList: function (component, event, helper) {
		var action = component.get('c.getWcList');

		let filter = component.get('v.filter');
		if (filter.Main_Work_Center__c === 'MFOP') {
			delete filter.Main_Work_Center__c;
		}

		action.setParams({
			filter: Object.keys(filter).length
				? filter
				: {
						Work_Clearance_Status__c: 'Created;In Progress;Inactive'
				  },
			offset: component.get('v.offset'),
			rowlimit: component.get('v.rowlimit'),
			isSharingSettings: true
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(JSON.stringify(result));
				try {
					// console.log(result);
					const { data, count } = result;
					component.set('v.totalrecord', count);
					component.set('v.totalpage', Math.ceil(component.get('v.totalrecord') / component.get('v.rowlimit')));
					component.set('v.wclist', helper.formatWcList(data));
					helper.calculatePagination(component);
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
	getWcVerificationList: function (component, event, helper) {
		var action = component.get('c.getWcVerificationList');

		let filter = component.get('v.veri_filter');
		if (filter.Main_Work_Center__c === 'MFOP') {
			delete filter.Main_Work_Center__c;
		}

		action.setParams({
			filter: Object.keys(filter).length
				? filter
				: {
						Work_Clearance_Status__c: 'Created;In Progress;Inactive'
				  },
			offset: component.get('v.veri_offset'),
			rowlimit: component.get('v.veri_rowlimit'),
			isSharingSettings: true
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(JSON.stringify(result));
				try {
					// console.log(result);
					const { data, count } = result;
					component.set('v.veri_totalrecord', count);
					component.set('v.veri_totalpage', Math.ceil(component.get('v.veri_totalrecord') / component.get('v.veri_rowlimit')));
					component.set('v.veri_wclist', helper.formatWcList(data));
					helper.calculateVerificationPagination(component);
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
	getWcVerificationAllList: function (component, event, helper) {
		var action = component.get('c.getWcVerificationAllList');

		let filter = component.get('v.veri_filter');
		if (filter.Main_Work_Center__c === 'MFOP') {
			delete filter.Main_Work_Center__c;
		}

		action.setParams({
			filter: Object.keys(filter).length
				? filter
				: {
						Work_Clearance_Status__c: 'Created;In Progress;Inactive'
				  },
			offset: component.get('v.veri_offset'),
			rowlimit: component.get('v.veri_rowlimit'),
			isSharingSettings: true
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(JSON.stringify(result));
				try {
					// console.log(result);
					const { data, count } = result;
					component.set('v.veri_totalrecord', count);
					component.set('v.veri_totalpage', Math.ceil(component.get('v.veri_totalrecord') / component.get('v.veri_rowlimit')));
					component.set('v.veri_wclist', helper.formatWcList(data));
					helper.calculateVerificationPagination(component);
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
	getWcInspectionList: function (component, event, helper) {
		var action = component.get('c.getWcInspectionList');

		let filter = component.get('v.inspect_filter');
		if (filter.Main_Work_Center__c === 'MFOP') {
			delete filter.Main_Work_Center__c;
		}

		action.setParams({
			filter: Object.keys(filter).length
				? filter
				: {
						Work_Clearance_Status__c: 'Created;In Progress;Inactive'
				  },
			offset: component.get('v.inspect_offset'),
			rowlimit: component.get('v.inspect_rowlimit'),
			isSharingSettings: true
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(JSON.stringify(result));
				try {
					// console.log(result);
					const { data, count } = result;
					component.set('v.inspect_totalrecord', count);
					component.set('v.inspect_totalpage', Math.ceil(component.get('v.inspect_totalrecord') / component.get('v.inspect_rowlimit')));
					component.set('v.inspect_wclist', helper.formatWcList(data));
					helper.calculateInspectionPagination(component);
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
	getWcInspectionDoneList: function (component, event, helper) {
		var action = component.get('c.getWcInspectionDoneList');

		let filter = component.get('v.inspect_filter');
		if (filter.Main_Work_Center__c === 'MFOP') {
			delete filter.Main_Work_Center__c;
		}

		action.setParams({
			filter: Object.keys(filter).length
				? filter
				: {
						Work_Clearance_Status__c: 'Created;In Progress;Inactive'
				  },
			offset: component.get('v.inspect_offset'),
			rowlimit: component.get('v.inspect_rowlimit'),
			isSharingSettings: true
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(JSON.stringify(result));
				try {
					// console.log(result);
					const { data, count } = result;
					component.set('v.inspect_totalrecord', count);
					component.set('v.inspect_totalpage', Math.ceil(component.get('v.inspect_totalrecord') / component.get('v.inspect_rowlimit')));
					component.set('v.inspect_wclist', helper.formatWcList(data));
					helper.calculateInspectionPagination(component);
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
	calculatePagination: function (component) {
		const runningNunmber =
			component.get('v.totalpage') - component.get('v.currentpage') >= 0 &&
			component.get('v.totalpage') - component.get('v.currentpage') < 6
				? component.get('v.totalpage') - 5 <= 0
					? 1
					: component.get('v.totalpage') - 5
				: component.get('v.currentpage') - 2 <= 0
				? component.get('v.currentpage')
				: component.get('v.currentpage') - 2;
			component.set(
				'v.pagination',
				Array(component.get('v.totalpage') < 6 ? component.get('v.totalpage') : 6)
					.fill(
						(component.get('v.currentpage') - 1) * component.get('v.rowlimit') <= 2000
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
	calculateVerificationPagination: function (component) {
		const runningNunmber =
			component.get('v.veri_totalpage') - component.get('v.veri_currentpage') >= 0 &&
			component.get('v.veri_totalpage') - component.get('v.veri_currentpage') < 6
				? component.get('v.veri_totalpage') - 5 <= 0
					? 1
					: component.get('v.veri_totalpage') - 5
				: component.get('v.veri_currentpage') - 2 <= 0
				? component.get('v.veri_currentpage')
				: component.get('v.veri_currentpage') - 2;
			component.set(
				'v.veri_pagination',
				Array(component.get('v.veri_totalpage') < 6 ? component.get('v.veri_totalpage') : 6)
					.fill(
						(component.get('v.veri_currentpage') - 1) * component.get('v.veri_rowlimit') <= 2000
							? runningNunmber
							: 2000 / component.get('v.veri_rowlimit') - 2
					)
					.map((pageno, index, arr) => {
						if (index === arr.length - 1) {
							// last index
							return component.get('v.veri_totalpage');
						}
						return pageno + index;
					})
		);
		// console.log(JSON.parse(JSON.stringify(component.get('v.pagination'))));
	},
	calculateInspectionPagination: function (component) {
		const runningNunmber =
			component.get('v.inspect_totalpage') - component.get('v.inspect_currentpage') >= 0 &&
			component.get('v.inspect_totalpage') - component.get('v.inspect_currentpage') < 6
				? component.get('v.inspect_totalpage') - 5 <= 0
					? 1
					: component.get('v.inspect_totalpage') - 5
				: component.get('v.inspect_currentpage') - 2 <= 0
				? component.get('v.inspect_currentpage')
				: component.get('v.inspect_currentpage') - 2;
			component.set(
				'v.inspect_pagination',
				Array(component.get('v.inspect_totalpage') < 6 ? component.get('v.inspect_totalpage') : 6)
					.fill(
						(component.get('v.inspect_currentpage') - 1) * component.get('v.inspect_rowlimit') <= 2000
							? runningNunmber
							: 2000 / component.get('v.inspect_rowlimit') - 2
					)
					.map((pageno, index, arr) => {
						if (index === arr.length - 1) {
							// last index
							return component.get('v.inspect_totalpage');
						}
						return pageno + index;
					})
		);
		// console.log(JSON.parse(JSON.stringify(component.get('v.pagination'))));
	},
	formatWcList: function(data) {
		return data.map((m) => {
			m.Requested_Date__c = m.Requested_Date__c
				? new Date(m.Requested_Date__c).toLocaleDateString('en-GB')
				: '';
			m.name = m.Work_Clearance__c;
			m.Verification_Status__c = m.Verification_Status__c|| '';

			/*m.info = [
				'Area__c',
				'Functional_Location__c',
				'FunctionalLocation__r.Description__c',
				'Problem__c',
				'Work_Detial__c'
			]
				.map((k) => {
					if (k.includes('.') && m[k.split('.')[0]]) {
						m[k] = m[k.split('.')[0]][k.split('.')[1]];
					}
					return m[k] || '';
				})
				.join(' . ');
			*/
			let temp = [
				'Area__c',
				'Functional_Location__c',
				'FunctionalLocation__r.Description__c',
				'Problem__c',
				'Work_Detail__c',
			]
				.map((k) => {
					if (k.includes('.') && m[k.split('.')[0]]) {
						m[k] = m[k.split('.')[0]][k.split('.')[1]];
					}
					return m[k] || '';
				})
			let info = [];
			info[0] = temp[0];
			info[1] = temp[1] + ' ' + temp[2];
			info[2] = temp[3];
			info[3] = temp[4];
			m.CreatedDateText = $A.localizationService.formatDate(m.CreatedDate, 'DD/MM/YYYY');
			m.AuthorizedDateText = m.Authorized_Date_UI__c ? $A.localizationService.formatDate(m.Authorized_Date_UI__c, 'DD/MM/YYYY') : '';
			m.info = info.join(' . ');
			m.description = m.Description__c || '';
			// console.log('verificationStatus' + m.verificationStatus);
			// console.log('verificationStatus' + m.Verification_Status__c);

			return m;
		});
	},
});