({
	startLoading: function (component) {
		component.set('v.isLoading', true);
	},
	stopLoading: function (component) {
		component.set('v.isLoading', false);
	},
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},
	getNotificationsByFilter: function (component, event, helper) {
		var action = component.get(helper.getListController(component));
		action.setParams({
			filter: component.get('v.filter') || {},
			offset: (component.get('v.pagination.currentPosition') - 1) * component.get('v.pagination.itemsPerPage'),
			rowlimit: component.get('v.pagination.itemsPerPage')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				if (
					String(component.get('v.document_type')).toLowerCase() === 'notification' ||
					String(component.get('v.document_type')).toLowerCase() === 'homenotification'
				) {
					component.set(
						'v.records',
						result.map((m) => {
							m.info = `${m.Type__c} . ${m.Functional_Location__r ? m.Functional_Location__r.Name : ''}  . ${
								m.Priority__c
							} . ${m.Requested_Date__c ? new Date(m.Requested_Date__c).toLocaleDateString('en-GB') : ''}`;
							return m;
						})
					);
				}

				if (
					String(component.get('v.document_type')).toLowerCase() === 'order' ||
					String(component.get('v.document_type')).toLowerCase() === 'homeorder'
				) {
					component.set(
						'v.records',
						result.map((m) => {
							m.info = `${m.Order_Type__c} . ${m.Functional_Location__r ? m.Functional_Location__r.Name : ''}  . ${
								m.Priority__c
							} . ${new Date(m.CreatedDate).toLocaleDateString('en-GB')}`;
							return m;
						})
					);
				}

				if (String(component.get('v.document_type')).toLowerCase() === 'eqcc') {
					let headerSheetIds = [];
					component.set(
						'v.records',
						result.map((m) => {
							m.Name = `${m.FunctionalLocation__r ? m.FunctionalLocation__r.Name : ''}, ${
								m.Equipment__r ? m.Equipment__r.Name : ''
							}`;

							if (['inprogress', 'in progress'].includes(component.get('v.document_status').toLowerCase())) {
								m.Name = `${m.Notification__r ? m.Notification__r.Notification_Number__c : ''}, ${
									m.Order__r ? m.Order__r.Order_Number__c : ''
								}, ${m.Name}, ${
									m.Notification__r
										? m.Notification__r.Description__c || ''
										: m.Order__r
										? m.Order__r.Description__c || ''
										: ''
								}`;
							}
							m.infos = m.Header_Sheets__r.map((h) => {
								headerSheetIds = [...headerSheetIds, h.Id];
								return {
									text: `\t=> ${h.Name}, ${h.Sheet__r.Sheet_Code__c || ''}, ${h.Sheet__r.Form_Name__c || ''}, ${
										h.Status__c || ''
									}, ${h.Requester__c || ''}, ${new Date(h.CreatedDate).toLocaleDateString('en-GB')}, ${new Date(
										h.LastModifiedDate
									).toLocaleDateString('en-GB')}`,
									recordId: h.Id
								};
							});
							return m;
						})
					);
					helper.getEqccCurrentStep(component, headerSheetIds);
					// console.log([...component.get('v.records')]);
				}

				if (String(component.get('v.document_type')).toLowerCase() === 'workclearance') {
					const isWithout = component.get('v.document_status').toLowerCase().includes('without');
					component.set(
						'v.records',
						result.map((m) => {
							let extendNo = m.Extend_No__c ? '/' + m.Extend_No__c : '';
							m.Name = m.Name + extendNo;
							// ${m.Order__r ? (!isWithout ? m.Order__r.Name || '' + ' . ' : '') : ''}
							m.Description__c = `${!isWithout ? (m.Notification__r ? m.Notification__r.Name : '') + ' . ' : ''}
              ${!isWithout ? (m.Order__r ? m.Order__r.Name : '') + ' . ' : ''}
              ${m.Functional_Location__c || ''} .
              ${!isWithout ? m.Priority_Map__c + ' . ' : ''}
							${m.Main_Work_Center__r ? m.Main_Work_Center__r.Name : ''} .
							${m.Description__c || ''}`;
							return m;
						})
					);
				}
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}

			helper.stopLoading(component);
		});
		$A.enqueueAction(action);
	},

	getCountNotificationsByFilter: function (component, event, helper) {
		var action = component.get(helper.getCountController(component));
		action.setParams({
			filter: component.get('v.filter') || {}
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				component.set('v.pagination.totalRows', result);

				this.buildPaginationItems(component, event, helper);
				this.buildSubHeaderLabel(component, event, helper);
				this.buildDescriptionLabel(component, event, helper);
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
		});
		$A.enqueueAction(action);
	},
	getEqccCurrentStep: function (component, headerSheetIds) {
		var action = component.get('c.getEqccCurrentStep');
		action.setParams({
			headerSheetIds
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.eqccStep', result);
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(error);
			}
		});
		$A.enqueueAction(action);
	},

	buildSubHeaderLabel: function (component, event, helper) {
		var key = String(component.get('v.document_type') + '|' + component.get('v.document_status')).toLowerCase();
		var label = `You have ${component.get('v.pagination.totalRows')} New Notifications`;
		switch (key) {
			case 'notification|new':
			case 'homenotification|new':
				label = `You have ${component.get('v.pagination.totalRows')} New Notifications`;
				break;
			case 'notification|inprogress':
			case 'notification|in progress':
			case 'homenotification|inprogress':
			case 'homenotification|in progress':
				label = `You have ${component.get('v.pagination.totalRows')} Execution Notifications`;
				break;
			case 'order|new':
			case 'homeorder|new':
				label = `You have ${component.get('v.pagination.totalRows')} New Orders`;
				break;
			case 'order|inprogress':
			case 'order|in progress':
			case 'homeorder|inprogress':
			case 'homeorder|in progress':
				label = `You have ${component.get('v.pagination.totalRows')} Execution Orders`;
				break;
			case 'workclearance|without notification and order':
			case 'workclearance|withoutnotificationandorder':
				label = `You have ${component.get('v.pagination.totalRows')} Without Notification and Order Work Clearances`;
				break;
			case 'workclearance|inprogress':
			case 'workclearance|in progress':
				label = `You have ${component.get('v.pagination.totalRows')} Execution Work Clearances`;
				break;
			case 'eqcc|withoutnotificationororder':
			case 'eqcc|without notification or order':
				label = `You have ${component.get('v.pagination.totalRows')} EQCC without Notification or Order`;
				break;
			case 'eqcc|inprogress':
			case 'eqcc|in progress':
				label = `You have ${component.get('v.pagination.totalRows')} In Progress EQCC`;
				break;
		}
		component.set('v.label.subheader', label);
	},
	buildDescriptionLabel: function (component, event, helper) {
		var key = String(component.get('v.document_type') + '|' + component.get('v.document_status')).toLowerCase();
		var label = `Notification number, Notification type, FL, Priority, Request date, Description`;
		var label2 = ``;
		switch (key) {
			case 'notification|new':
			case 'homenotification|new':
				label = `Notification number, Notification type, FL, Priority, Request date, Description`;
				break;
			case 'notification|inprogress':
			case 'notification|in progress':
			case 'homenotification|inprogress':
			case 'homenotification|in progress':
				label = `Notification number, Notification type, FL, Priority, Create on, Description`;
				break;
			case 'order|new':
			case 'homeorder|new':
				label = `Order number, Order type, FL, Priority, Create on, Description`;
				break;
			case 'order|inprogress':
			case 'order|in progress':
			case 'homeorder|inprogress':
			case 'homeorder|in progress':
				label = `Order number, Order type, FL, Priority, Create on, Description`;
				break;
			case 'workclearance|without notification and order':
			case 'workclearance|withoutnotificationandorder':
				label = `Work Clearance number, FL, Main Work Center, Description`;
				break;
			case 'workclearance|inprogress':
			case 'workclearance|in progress':
				label = `Work Clearance number, Notification Number, Order Number, FL, Priority, Main Work Center, Description`;
				break;
			case 'eqcc|withoutnotificationororder':
			case 'eqcc|without notification or order':
				label = `FL,Equipment`;
				//label2 = `=> Header Sheet Name,Sheet Code, Status, Requester, Create on`;
				label2 = `=> Header sheet name, EQCC Code, EQCC Name, Status, Requestor, Create on, Last modify date`;
				break;
			case 'eqcc|inprogress':
			case 'eqcc|in progress':
				label = `Notification number,Order number,FL,Equipment,Description`;
				//label2 = `=> Header Sheet Name, Sheet Code, Status, Requester, Create on`;
				label2 = `=> Header sheet name, EQCC Code, EQCC Name, Status, Requestor, Create on, Last modify date`;
				break;
		}
		component.set('v.label.description', label);
		component.set('v.label.description2', label2);
	},
	buildPaginationItems: function (component, event, helper) {
		var currentPosition = component.get('v.pagination.currentPosition');
		var totalPages = Math.ceil(component.get('v.pagination.totalRows') / component.get('v.pagination.itemsPerPage'));
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
	getListController: function (component) {
		var key = String(component.get('v.document_type') + '|' + component.get('v.document_status')).toLowerCase();
		var ctrl = 'c.getNewNotificationsByFilter';
		switch (key) {
			case 'notification|new':
			case 'homenotification|new':
				ctrl = 'c.getNewNotificationsByFilter';
				break;
			case 'notification|inprogress':
			case 'notification|in progress':
			case 'homenotification|inprogress':
			case 'homenotification|in progress':
				ctrl = 'c.getInProgressNotificationsByFilter';
				break;
			case 'order|new':
			case 'homeorder|new':
				ctrl = 'c.getNewOrdersByFilter';
				break;
			case 'order|inprogress':
			case 'order|in progress':
			case 'homeorder|inprogress':
			case 'homeorder|in progress':
				ctrl = 'c.getInProgressOrdersByFilter';
				break;
			case 'workclearance|without notification and order':
			case 'workclearance|withoutnotificationandorder':
				ctrl = 'c.getWithoutNotiAndOrderWorkClearancesByFilter';
				break;
			case 'workclearance|inprogress':
			case 'workclearance|in progress':
				ctrl = 'c.getInProgressWorkClearancesByFilter';
				break;
			case 'eqcc|withoutnotificationororder':
			case 'eqcc|without notification or order':
				ctrl = 'c.getWithoutNotificationOrOrderEQCCsByFilter';
				break;
			case 'eqcc|inprogress':
			case 'eqcc|in progress':
				ctrl = 'c.getInProgressEQCCsByFilter';
				break;
		}
		return ctrl;
	},
	getCountController: function (component) {
		var key = String(component.get('v.document_type') + '|' + component.get('v.document_status')).toLowerCase();
		var ctrl = 'c.getCountNewNotificationsByFilter';
		switch (key) {
			case 'notification|new':
			case 'homenotification|new':
				ctrl = 'c.getCountNewNotificationsByFilter';
				break;
			case 'notification|inprogress':
			case 'notification|in progress':
			case 'homenotification|inprogress':
			case 'homenotification|in progress':
				ctrl = 'c.getCountInProgressNotificationsByFilter';
				break;
			case 'order|new':
			case 'homeorder|new':
				ctrl = 'c.getCountNewOrdersByFilter';
				break;
			case 'order|inprogress':
			case 'order|in progress':
			case 'homeorder|inprogress':
			case 'homeorder|in progress':
				ctrl = 'c.getCountInProgressOrdersByFilter';
				break;
			case 'workclearance|without notification and order':
			case 'workclearance|withoutnotificationandorder':
				ctrl = 'c.getCountWithoutNotiAndOrderWorkClearancesByFilter';
				break;
			case 'workclearance|inprogress':
			case 'workclearance|in progress':
				ctrl = 'c.getCountInProgressWorkClearancesByFilter';
				break;
			case 'eqcc|withoutnotificationororder':
			case 'eqcc|without notification or order':
				ctrl = 'c.getCountWithoutNotificationOrOrderEQCCsByFilter';
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
			case 'homeorder':
				ctrl = 'c.getCountOrders';
				break;
			case 'eqcc':
				ctrl = 'c.getCountEQCCs';
				break;
		}
		return ctrl;
	}
});