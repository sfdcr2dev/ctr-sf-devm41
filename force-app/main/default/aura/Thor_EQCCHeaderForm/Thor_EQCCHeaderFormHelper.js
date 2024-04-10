({
	populateCheckedSheets: function (component) {
		let equipment = component.get('v.lookupEquipments')
			? component.find('equipment').get('v.value')
			: component.find('equipmentOptions').get('v.value');
		let functionalLocation = component.find('fl').get('v.value');
		let action = component.get('c.retrieveCheckedSheets');

		if (equipment || functionalLocation) {
			action.setParams({
				funcLocationId: functionalLocation ? functionalLocation : null,
				equipmentId: equipment ? equipment : null
			});

			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					let options = [];
					let sheets = response.getReturnValue();

					sheets.forEach((sheet) => {
						options.push({
							label: sheet.Sheet_Code__c + ', ' + sheet.Form_Name__c,
							value: sheet.Id + ',' + sheet.Sheet_Code__c + ',' + sheet.Form_Name__c
						});
					});
					component.set('v.options', options);

					//populate Notification and Order fields if needed
					let isLookup = component.get('v.lookupNotifications');
					let notification;
					let order;
					if (isLookup) {
						notification = component.find('notification');
						order = component.find('order');
					} else {
						notification = component.find('notificationOptions');
						order = component.find('orderOptions');
					}

					if ((!order || !order.get('v.value')) && (!notification || !notification.get('v.value'))) {
						component.set('v.lookupNotifications', false);
						component.set('v.lookupOrders', false);
						let notificationAction = component.get('c.retrieveNotifications');

						notificationAction.setParams({
							equipmentId: equipment ? equipment : null,
							funcLocationId: functionalLocation ? functionalLocation : null
						});

						notificationAction.setCallback(this, function (response) {
							let state = response.getState();
							if (state === 'SUCCESS') {
								let options = [];
								component.set('v.notificationOptions', options);
								let notifications = response.getReturnValue();

								notifications.forEach((notification) => {
									options.push({
										label: notification.Notification_Number__c, //TODO check whether use Name or Notification_Number__c
										value: notification.Id
									});
								});
								if (options.length > 0) {
									component.set('v.notificationOptions', options);
								}
							} else {
								let errors = response.getError();
								if (errors) {
									if (errors[0] && errors[0].message) {
										component.find('notifLib').showToast({
											variant: 'error',
											title: errors[0].message
										});
									}
								}
							}
							component.set('v.isLoading', false);
						});
						component.set('v.isLoading', true);
						$A.enqueueAction(notificationAction);

						let orderAction = component.get('c.retrieveOrders');
						orderAction.setParams({
							equipmentId: equipment ? equipment : null,
							funcLocationId: functionalLocation ? functionalLocation : null
						});
						orderAction.setCallback(this, function (response) {
							let state = response.getState();
							if (state === 'SUCCESS') {
								let options = [];
								component.set('v.orderOptions', options);
								let orders = response.getReturnValue();

								orders.forEach((order) => {
									// Some mock orders don't have Order_Number__c
									if (!order.Order_Number__c) {
										order.Order_Number__c = order.Name;
									}
									options.push({
										label: order.Order_Number__c, //TODO check whether use Name or Order_Number__c
										value: order.Id
									});
								});
								if (options.length > 0) {
									component.set('v.orderOptions', options);
								}
							} else {
								let errors = response.getError();
								if (errors) {
									if (errors[0] && errors[0].message) {
										component.find('notifLib').showToast({
											variant: 'error',
											title: errors[0].message
										});
									}
								}
							}
							component.set('v.isLoading', false);
						});
						component.set('v.isLoading', true);
						$A.enqueueAction(orderAction);
					}
				}
				component.set('v.isLoading', false);
			});
			component.set('v.isLoading', true);
			$A.enqueueAction(action);
		} else {
			component.set('v.lookupNotifications', true);
			component.set('v.lookupOrders', true);
		}
	},

	completeEQCCFromNotification: function (component, notificationId) {
		let action = component.get('c.retrieveEQCCNotification');
		action.setParams({
			notificationId: notificationId
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let notification = response.getReturnValue();
				let sheets = component.get('v.sheetsToRelate');

				if (notification.Functional_Location__c) {
					component.find('fl').set('v.value', notification.Functional_Location__c);
					//disable field only when Notification or Order are not provided
					if (component.get('v.lookupNotifications') && sheets && sheets.length > 0) {
						component.find('fl').set('v.disabled', true);
					}
				}
				if (notification.Equipment__c) {
					//disable field only when Notification or Order are not provided
					if (component.get('v.lookupOrders')) {
						component.find('equipment').set('v.value', notification.Equipment__c);
						if (sheets && sheets.length > 0) {
							component.find('equipment').set('v.disabled', true);
						}
					} else {
						component.find('equipmentOptions').set('v.value', notification.Equipment__c);
					}
				}

				this.populateCheckedSheets(component);
			} else {
				let errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.find('notifLib').showToast({
							variant: 'error',
							title: errors[0].message
						});
					}
				}
			}
			component.set('v.isLoading', false);
		});
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},

	completeEQCCFromOrder: function (component, orderId) {
		let action = component.get('c.retrieveEQCCOrder');
		action.setParams({
			orderId: orderId
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let order = response.getReturnValue();
				let sheets = component.get('v.sheetsToRelate');

				if (order.Functional_Location__c) {
					component.find('fl').set('v.value', order.Functional_Location__c);
					//disable field only when Notification or Order are not provided
					if (component.get('v.lookupOrders') && sheets && sheets.length > 0) {
						component.find('fl').set('v.disabled', true);
					}
				}
				if (order.Equipment__c) {
					//disable field only when Notification or Order are not provided
					if (component.get('v.lookupEquipments')) {
						component.find('equipment').set('v.value', order.Equipment__c);
						if (sheets && sheets.length > 0) {
							component.find('equipment').set('v.disabled', true);
						}
					} else {
						component.find('equipmentOptions').set('v.value', order.Equipment__c);
					}
				}

				if (component.get('v.orderOperationId')) {
					this.populateCheckedSheetsFromOperation(component, component.get('v.orderOperationId'));
				} else {
					this.populateCheckedSheets(component);
				}
			} else {
				let error = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.find('notifLib').showToast({
							variant: 'error',
							title: errors[0].message
						});
					}
				}
			}
			component.set('v.isLoading', false);
		});
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},

	populateOrderOperation: function (component, orderOperationId) {
		let action = component.get('c.retrieveOrderOperation');
		action.setParams({
			orderOperationId: orderOperationId
		});

		action.setCallback(this, function (response) {
			let state = response.getState();

			if (state === 'SUCCESS') {
				let options = [];
				let orderOperation = response.getReturnValue();

				options.push({
					label: orderOperation.Operation_Text__c + ', ' + orderOperation.Operation_Shot_Text__c,
					value:
						orderOperation.Id + ',' + orderOperation.Operation_Text__c + ', ' + orderOperation.Operation_Shot_Text__c
				});

				component.set('v.orderOperationOptions', options);
				if (options.length > 0) {
					component.find('orderOperationOptions').set('v.value', options[0].value);
					component.find('orderOperationOptions').set('v.disabled', true);
				} else {
					component.find('orderOperationOptions').set('v.disabled', true);
				}

				this.populateCheckedSheetsFromOperation(component, orderOperationId);
			}
			component.set('v.isLoading', false);
		});
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},

	populateOperationOptions: function (component, orderId) {
		let action = component.get('c.retrieveOrderOperations');
		action.setParams({
			orderId: orderId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				let options = [];
				let orderOperations = response.getReturnValue();

				orderOperations.forEach((orderOperation) => {
					options.push({
						label: orderOperation.Operation_Text__c + ', ' + orderOperation.Operation_Shot_Text__c,
						value:
							orderOperation.Id + ',' + orderOperation.Operation_Text__c + ', ' + orderOperation.Operation_Shot_Text__c
					});
				});

				if (options.length > 0) {
					component.set('v.orderOperationOptions', options);
				} else {
					component.find('orderOperationOptions').set('v.disabled', true);
				}
				let incomingSheets = component.get('v.incomingSheets');
				if (incomingSheets && incomingSheets.length > 0) {
					component.find('orderOperationOptions').set('v.disabled', true);
				}
			}
			component.set('v.isLoading', false);
		});
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},

	populateCheckedSheetsFromOperation: function (component, orderOperationId) {
		let action = component.get('c.retrieveCheckedSheetsFromOrderOperation');

		action.setParams({
			orderOperationId: orderOperationId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				let options = [];
				let sheets = response.getReturnValue();
				sheets.forEach((sheet) => {
					options.push({
						label: sheet.Sheet_Code__c + ', ' + sheet.Form_Name__c,
						value: sheet.Id + ',' + sheet.Sheet_Code__c + ',' + sheet.Form_Name__c
					});
				});
				component.set('v.options', options);
			}
			component.set('v.isLoading', false);
		});
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},

	navigateToComponent: function (component, componentName, recordId) {
		let navLink = component.find('navService');
		let pageRef = {
			type: 'standard__component',
			attributes: {
				componentName: componentName
			},
			state: {
				c__recordId: recordId
			}
		};
		navLink.navigate(pageRef, true);
	},

	navigateToHome: function (component) {
		let navLink = component.find('navService');
		let pageRef = {
			type: 'standard__navItemPage',
			attributes: {
				apiName: 'Home'
			}
		};
		navLink.navigate(pageRef, true);
	},

	updateEditEQCCHeader: function (component, fields, selectedSheetsIds, recordId, duplicatedCheckedSheetsIds) {
		let action = component.get('c.updateEQCCHeader');

		action.setParams({
			sheetIds: selectedSheetsIds,
			headerId: recordId,
			sheetHeader: fields,
			duplicatedCheckedSheets: duplicatedCheckedSheetsIds
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let headerId = response.getReturnValue();

				if (!headerId) {
					component.set('v.hasMWC', false);
					component.find('notifLib').showToast({
						variant: 'warning',
						title: 'Contact System Admin',
						message: 'There is no main work center information, please contact System Admin'
					});
				} else {
					// this is what saves the record after edit
					component.find('header-edit-form').submit(fields);
				}
			} else {
				let errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.find('notifLib').showToast({
							variant: 'error',
							title: errors[0].message
						});
					}
				}
				return false;
			}
			component.set('v.isLoading', false);
		});
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},
	checkFLMainWorkCenter: function (component, fl) {
		let action = component.get('c.hasMainWorkCenter');

		if (fl) {
			action.setParams({
				funcLocation: fl
			});
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					if (response.getReturnValue()) {
						component.set('v.hasMWC', true);
					} else {
						component.set('v.hasMWC', false);
					}
				} else {
					let errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							component.find('notifLib').showToast({
								variant: 'error',
								title: errors[0].message
							});
						}
					}
				}
				component.set('v.isLoading', false);
			});
			component.set('v.isLoading', true);
			$A.enqueueAction(action);
		}
	},
	checkOwnerOrAdmin: function (component) {
		let action = component.get('c.isOwnerOrAdmin');
		const recordId = component.get('v.recordId');
		if (recordId != '') {
			action.setParams({
				headerId: recordId
			});

			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					component.set('v.ownerOrAdmin', response.getReturnValue());
				} else if (state === 'INCOMPLETE') {
					// do something
				} else if (state === 'ERROR') {
					let errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.error('Error message: ' + errors[0].message);
						}
					} else {
						console.log('Unknown error');
					}
				}
			});

			$A.enqueueAction(action);
		} else {
			component.set('v.ownerOrAdmin', true);
		}
	}
});