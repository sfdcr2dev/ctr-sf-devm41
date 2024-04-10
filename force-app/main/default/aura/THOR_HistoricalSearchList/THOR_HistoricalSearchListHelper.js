({
	handleSearch: function (component, event, helper) {
		// console.log({ filterRecordId: component.get('v.filterRecordId') });
		var action = component.get('c.doHistoricalSearch');
		action.setParams({
			recordId: component.get('v.filterRecordId'),
			offset: (component.get('v.pagination.currentPosition') - 1) * component.get('v.pagination.itemsPerPage'),
			rowlimit: 400
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				try {
					if (String(component.get('v.document_type')).toLowerCase() === 'notification') {
						component.set(
							'v.items',
							result.map((m) => {
								m.info = `${m.Notification_Status__c}. ${m.Type__c}. ${
									m.Functional_Location__r ? m.Functional_Location__r.Name : ''
								}. ${m.Priority__c} . ${
									m.Requested_Date__c ? new Date(m.Requested_Date__c).toLocaleDateString('en-GB') : ''
								}`;
								return m;
							})
						);
					} else if (String(component.get('v.document_type')).toLowerCase() === 'order') {
						component.set(
							'v.items',
							result.map((m) => {
								m.info = `${m.Order_Status__c}. ${m.Order_Type__c}. ${
									m.Functional_Location__r ? m.Functional_Location__r.Name : ''
								}. ${m.Priority__c}. ${new Date(m.CreatedDate).toLocaleDateString('en-GB')}`;

								return m;
							})
						);
					} else if (String(component.get('v.document_type')).toLowerCase() === 'wc') {
						component.set(
							'v.items',
							result.map((m) => {
								let extendNo = m.Extend_No__c ? '/' + m.Extend_No__c : '';
								m.Name = m.Name + extendNo;
								m.info = `${m.Work_Clearance_Status__c || ''}. ${
									m.Functional_Location__c || (m.FunctionalLocation__r ? m.FunctionalLocation__r.Name : '')
								}. ${m.Priority_Map__c ? m.Priority_Map__c : ''}. ${
									m.Main_Work_Center__r ? m.Main_Work_Center__r.Code__c : ''
								}`;
								return m;
								//   . ${m.Main_Work_Center__r ? m.Main_Work_Center__r.Name : ''} . ${m.Description__c ? m.Description__c : ''}`
							})
						);
					} else if (String(component.get('v.document_type')).toLowerCase() === 'eqcc') {
						component.set(
							'v.items',
							result
								.reduce((list, item) => list.concat(item.sheets), [])
								.map((item) => ({
									Id: item.eqccSteps && item.eqccSteps[0] ? item.eqccSteps[0].Id : '',
									sheetGroup: item.sheet.Group__c,
									info: `=> ${item.headerSheetName}, ${item.sheet.Sheet_Code__c}, ${item.sheet.Form_Name__c}, ${item.status} ,`,
									description: `${item.requester}, ${new Date(item.createdDatetime).toLocaleDateString(
										'en-GB'
									)},  ${new Date(item.createdDatetime).toLocaleTimeString('en-GB')}, ${new Date(
										item.lastModifiedDatetime
									).toLocaleDateString('en-GB')},  ${new Date(item.lastModifiedDatetime).toLocaleTimeString('en-GB')} `
								}))
						);
					}
					// console.log(helper.parseObject(result));
					// console.log(helper.parseObject(component.get('v.items')));

					helper.fetchItems(component, event, helper);
					helper.buildPaginationItems(component);

					helper.buildDescriptionLabel(component);
				} catch (e) {
					console.error(e);
				}
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
		});
		$A.enqueueAction(action);
	},
	fetchItems: function (component, event, helper) {
		let result = [];
		let firstIndex = (component.get('v.pagination.currentPosition') - 1) * component.get('v.pagination.itemsPerPage');
		let lastIndex =
			component.get('v.items.length') >
			component.get('v.pagination.itemsPerPage') * component.get('v.pagination.currentPosition')
				? component.get('v.pagination.itemsPerPage') * component.get('v.pagination.currentPosition')
				: component.get('v.items.length');
		for (var i = firstIndex; i < lastIndex; i++) {
			result.push(component.get(`v.items.${i}`));
		}
		component.set('v.notifications', result);
	},
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},

	getCountNotificationsByFilter: function (component, event, helper) {
		var action = component.get(this.getCountController(component, event, helper));
		action.setParams({
			recordId: component.get('v.filterRecordId') || {}
		});
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				if (result >= 400) {
					component.find('notifLib').showNotice({
						variant: 'warning',
						header: 'แจ้งเตือน!',
						message: `ระบบจะแสดงผลลัพธ์ที่ 400 รายการ จาก ${result} รายการ หากไม่พบข้อมูลที่ต้องการ กรุณาระบุเงื่อนไขการค้นหาเพิ่มเติม`,
						closeCallback: function () {
							// alert('You closed the alert!');
						}
					});
					// var toastEvent = $A.get('e.force:showToast');
					// toastEvent.setParams({
					// 	type: 'warning',
					// 	title: 'แจ้งเตือน!',
					// 	duration: '30000',
					// 	message: `ระบบจะแสดงผลลัพธ์ที่ 400 รายการ จาก ${result} รายการ หากไม่พบข้อมูลที่ต้องการ กรุณาระบุเงื่อนไขการค้นหาเพิ่มเติม`
					// });
					// toastEvent.fire();
				}

				component.set('v.pagination.totalRows', result);
				helper.buildSubHeaderLabel(component);
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
		});
		$A.enqueueAction(action);
	},

	buildSubHeaderLabel: function (component) {
		var key = String(component.get('v.document_type') + '|' + component.get('v.document_status')).toLowerCase();

		var label = `Search Result for Notification (${component.get('v.pagination.totalRows')})`;
		switch (key) {
			case 'notification|new':
				label = `Search Result for Notification (${component.get('v.pagination.totalRows')})`;
				break;
			case 'order|new':
				label = `Search Result for Order (${component.get('v.pagination.totalRows')})`;
				break;
			case 'wc|new':
				label = `Search Result for Work Clearance (${component.get('v.pagination.totalRows')})`;
				break;
			case 'eqcc|inprogress':
			case 'eqcc|in progress':
				label = `Search Result for EQCC Form (${component.get('v.pagination.totalRows')})`;
				break;
		}

		component.set('v.label.subheader', label);
	},
	buildDescriptionLabel: function (component) {
		var key = String(component.get('v.document_type') + '|' + component.get('v.document_status')).toLowerCase();

		var label = `Notification number, Notification Status, Notification type, FL, Priority, Request date, Description`;
		var label2 = ``;
		switch (key) {
			case 'notification|new':
			case 'homenotification|new':
				label = `Notification number, Notification Status, Notification type, FL, Priority, Request date, Description`;
				break;
			case 'notification|inprogress':
			case 'notification|in progress':
			case 'homenotification|inprogress':
			case 'homenotification|in progress':
				label = `Notification number,  Notification Status, Notification type, FL, Priority, Create on, Description`;
				break;
			case 'order|new':
			case 'homeorder|new':
				label = `Order number, Order Status, Order type, FL, Priority, Create on, Description`;
				break;
			case 'order|inprogress':
			case 'order|in progress':
			case 'homeorder|inprogress':
			case 'homeorder|in progress':
				label = `Order number, Order Status, Order type, FL, Priority, Create on, Description`;
				break;
			case 'wc|new':
				label = `Work Clerance number, Work Clerance Status, FL, Priority, Main work center, Description`;
				break;
			case 'eqcc|inprogress':
			case 'eqcc|in progress':
				label = ` => Header sheet name, EQCC Code, EQCC Name, Status, Requestor, Create on,Last modify date`;
				break;
		}

		component.set('v.label.description', label);
		component.set('v.label.description2', label2);
	},
	buildPaginationItems: function (component) {
		var currentPosition = component.get('v.pagination.currentPosition');
		var totalPages = Math.ceil(component.get('v.items.length') / component.get('v.pagination.itemsPerPage'));
		var displaySize = component.get('v.pagination.displaySize');

		var items = [];
		component.set('v.pagination.totalPages', totalPages);
		if (totalPages - currentPosition < displaySize) {
			for (var i = Math.max(1, totalPages - displaySize + 1); i <= totalPages; i++) {
				items.push(i);
			}
		} else {
			for (var i = currentPosition; i <= currentPosition + displaySize - 3; i++) {
				items.push(i);
			}

			items.push('...', totalPages);
		}

		component.set('v.pagination.items', items);
	},

	getCountController: function (component, event, helper) {
		var key = String(component.get('v.document_type') + '|' + component.get('v.document_status')).toLowerCase();

		var ctrl = 'c.getCountNewNotificationsByFilter';
		switch (key) {
			case 'notification|new':
				ctrl = 'c.getCountNewNotificationsByFilter';
				break;
			case 'order|new':
				ctrl = 'c.getCountNewOrdersByFilter';
				break;
			case 'wc|new':
				ctrl = 'c.getCountNewWorkClearanceByFilter';
				break;
			case 'eqcc|inprogress':
			case 'eqcc|in progress':
				ctrl = 'c.getCountInProgressEQCCsByFilter';
				break;
		}

		return ctrl;
	},
	getCountAllController: function (component, event, helper) {
		var key = String(component.get('v.document_type')).toLowerCase();
		var ctrl = 'c.getCountNotifications';
		switch (key) {
			case 'notification':
			case 'homenotification':
				ctrl = 'c.getCountNotifications';
				break;
			case 'order':
				ctrl = 'c.getCountOrders';
				break;
			case 'homeorder':
				ctrl = 'c.getCountOrders';
				break;
			case 'eqcc':
				ctrl = 'c.getCountEQCCs';
				break;
		}
		return ctrl;
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
				}

				component.set('v.isActive', true);
				if (
					filter &&
					Object.keys(filter).length === 0 &&
					Object.getPrototypeOf(filter) === Object.prototype &&
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