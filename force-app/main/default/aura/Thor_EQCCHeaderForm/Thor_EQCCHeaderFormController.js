({
	doInit: function (component, event, helper) {
		let notificationId;
		let orderId;
		let orderOperationId;
		helper.checkOwnerOrAdmin(component);

		if (component.get('v.isModal')) {
			let incomingSheets = component.get('v.incomingSheets');
			let sheetsToRelate = [];
			let sheetsName = [];
			if (incomingSheets.length > 0) {
				incomingSheets.forEach((headerSheet) => {
					let headerSheets = headerSheet.sheets;

					headerSheets.forEach((wrapperSheet) => {
						sheetsToRelate.push({
							id: wrapperSheet.sheet.Id,
							label: wrapperSheet.sheet.Sheet_Code__c + ', ' + wrapperSheet.sheet.Form_Name__c,
							value:
								wrapperSheet.sheet.Id + ',' + wrapperSheet.sheet.Sheet_Code__c + ',' + wrapperSheet.sheet.Form_Name__c,
							isDeletable: wrapperSheet.isManuallyCreated,
							isDisabled: wrapperSheet.isPolluted,
							status: wrapperSheet.status
						});
						sheetsName.push({
							id: wrapperSheet.sheet.Id,
							name: wrapperSheet.sheet.Form_Name__c
						});
					});
				});
				component.set('v.sheetsToRelate', sheetsToRelate);
				console.log('sheetsName 1234 ' + sheetsName);
				component.set('v.sheetsName', sheetsName);
			}

			try {
				let notification = component.find('notification');
				notification.set('v.value', component.get('v.notificationId'));
				notification.set('v.disabled', true);
			} catch (err) {
				let notification = component.find('notificationOptions');
				notification.set('v.value', component.get('v.notificationId'));
				notification.set('v.disabled', true);
			}

			notificationId = component.get('v.notificationId');

			try {
				component.find('order').set('v.value', orderId);
				component.find('order').set('v.disabled', true);
				component.find('notification').set('v.disabled', true);
			} catch (err) {
				component.find('orderOptions').set('v.value', orderId);
				component.find('orderOptions').set('v.disabled', true);
				component.find('notificationOptions').set('v.disabled', true);
			}
			component.set('v.lookupOperations', false);
			orderId = component.get('v.orderId');
		} else {
			let pageRef = component.get('v.pageReference');

			let recordId = pageRef.state.c__recordId;
			if (pageRef.state.c__orderId) {
				component.set('v.orderId', pageRef.state.c__orderId);
			}
			if (pageRef.state.c__notificationId) {
				component.set('v.notificationId', pageRef.state.c__notificationId);
			}
			let sheetsToRelate = [];
			let sheetsName = [];
			let existingSheets;
			if (pageRef.state.c__sheetsToRelate) {
				existingSheets = JSON.parse(pageRef.state.c__sheetsToRelate);
				component.set('v.hasSheets', true);
			}

			if (recordId) {
				component.set('v.recordId', recordId);

				existingSheets.forEach((headerSheet) => {
					let headerSheets = headerSheet.sheets;

					headerSheets.forEach((wrapperSheet) => {
						sheetsToRelate.push({
							id: wrapperSheet.sheet.Id,
							label: wrapperSheet.sheet.Sheet_Code__c + ', ' + wrapperSheet.sheet.Form_Name__c,
							value:
								wrapperSheet.sheet.Id + ',' + wrapperSheet.sheet.Sheet_Code__c + ',' + wrapperSheet.sheet.Form_Name__c,
							isDeletable: wrapperSheet.isManuallyCreated,
							status: wrapperSheet.status
						});
						sheetsName.push({
							id: wrapperSheet.sheet.Id,
							name: wrapperSheet.sheet.Form_Name__c
						});
					});
				});

				component.set('v.sheetsToRelate', sheetsToRelate);
				component.set('v.sheetsName', sheetsName);
			}

			notificationId = pageRef.state.c__notificationId;
			orderId = pageRef.state.c__orderId;
		}

		try {
			component.find('notification').set('v.disabled', true);
			component.find('order').set('v.disabled', true);
		} catch (err) {}

		//let flaction = component.get("c.handleFLSelected");
		if (notificationId) {
			try {
				component.find('notification').set('v.value', notificationId);
			} catch (err) {
				component.find('notificationOptions').set('v.value', notificationId);
			}

			try {
				component.find('order').set('v.disabled', true);
			} catch (err) {
				component.find('orderOptions').set('v.disabled', true);
			}
			helper.completeEQCCFromNotification(component, notificationId);
		}

		if (orderId) {
			try {
				component.find('order').set('v.value', orderId);
				component.find('notification').set('v.disabled', true);
			} catch (err) {
				component.find('orderOptions').set('v.value', orderId);
				component.find('notificationOptions').set('v.disabled', true);
			}
			component.set('v.lookupOperations', false);

			helper.completeEQCCFromOrder(component, orderId);
			orderOperationId = component.get('v.orderOperationId');
			if (orderOperationId) {
				helper.populateOrderOperation(component, orderOperationId);
			} else {
				helper.populateOperationOptions(component, orderId);
			}
		} else {
			try {
				component.find('orderOperationOptions').set('v.disabled', true);
			} catch (err) {
				component.find('operation').set('v.disabled', true);
			}
		}
	},

	populateCheckedSheets: function (component, event, helper) {
		component.set('v.options', []);
		helper.populateCheckedSheets(component);
	},

	handleSheetSelected: function (component, event, helper) {
		let sheet = component.find('sheet').get('v.value').split(',');
		let sheetIdToAdd = sheet[0];
		let sheetLabel = sheet[1] + ', ' + sheet[2];
		let selectedSheets = component.get('v.sheetsToRelate');
		let sheetNames = component.get('v.sheetsName');
		let isFromOperation = component.find('orderOperationOptions')
			? component.find('orderOperationOptions').get('v.value')
			: false;

		let isRejected = false;
		let alreadyAdded = selectedSheets.find((sheet) => {
			if (sheet.status === 'Rejected') {
				isRejected = true;
			}
			return sheet.id === sheetIdToAdd && sheet.status !== 'Rejected';
		});
		if (!alreadyAdded) {
			selectedSheets.push({
				id: sheetIdToAdd,
				label: sheetLabel,
				isDeletable: true,
				isDuplicated: isRejected //already exists but a Rejected version
				//isDeletable: !isFromOperation
			});
			component.set('v.sheetsToRelate', selectedSheets);
		}

		let sheetsToRelate = component.get('v.sheetsToRelate');
		if (sheetsToRelate) {
			component.find('fl').set('v.disabled', true);
			if (component.get('v.lookupEquipments')) {
				component.find('equipment').set('v.disabled', true);
			} else {
				component.find('equipmentOptions').set('v.disabled', true);
			}
		}

		if (isFromOperation || sheet) {
			let orderOperationOptions = component.find('orderOperationOptions');
			if (orderOperationOptions) {
				orderOperationOptions.set('v.disabled', true);
			}
			let operation = component.find('operation');
			if (operation) {
				operation.set('v.disabled', true);
			}
		}

		sheetNames.push({
			id: sheetIdToAdd,
			name: sheet[2]
		});
		component.set('v.sheetsName', sheetNames);
	},

	handleRemoveSheet: function (component, event, helper) {
		let sheetToRemove = event.getSource().get('v.name');
		let selectedSheets = component.get('v.sheetsToRelate');
		selectedSheets = selectedSheets.filter((sheet) => sheet.id !== sheetToRemove);

		let selectedSheetsName = component.get('v.sheetsName');
		console.log(selectedSheetsName);
		selectedSheetsName = selectedSheetsName.filter((sheet) => sheet.id !== sheetToRemove);
		console.log(selectedSheetsName);
		component.set('v.sheetsToRelate', selectedSheets);
		component.set('v.sheetsName', selectedSheetsName);

		if (selectedSheets === undefined || selectedSheets.length === 0) {
			component.find('fl').set('v.disabled', false);
			if (!component.get('v.isModal')) {
				if (component.get('v.lookupEquipments')) {
					component.find('equipment').set('v.disabled', false);
				} else {
					component.find('equipmentOptions').set('v.disabled', false);
				}
			}

			let isFromOperation = component.find('orderOperationOptions')
				? component.find('orderOperationOptions').get('v.value')
				: false;
			if (isFromOperation && !component.get('v.isModal')) {
				component.find('orderOperationOptions').set('v.disabled', false);
			}
		}
	},

	handleSheetCreation: function (component, event, helper) {
		event.preventDefault();
		let fields = event.getParam('fields');
		let selectedSheets = component.get('v.sheetsToRelate');
		// to update
		let selectedSheetsIds = selectedSheets.map((sheet) => sheet.id);
		// to create
		let duplicatedIds = selectedSheets.filter((sheet) => sheet.isDuplicated).map((sheet) => sheet.id);

		if (!component.get('v.lookupNotifications')) {
			fields['Notification__c'] = component.find('notificationOptions').get('v.value');
		}

		if (!component.get('v.lookupOrders')) {
			fields['Order__c'] = component.find('orderOptions').get('v.value');
		}

		if (!component.get('v.lookupEquipments')) {
			fields['Equipment__c'] = component.find('equipmentOptions').get('v.value');
		}

		let orderOperation = component.find('orderOperationOptions')
			? component.find('orderOperationOptions').get('v.value')
				? component.find('orderOperationOptions').get('v.value').split(',')[0]
				: ''
			: '';
		if (orderOperation) {
			fields['Order_Operation__c'] = orderOperation;
		}

		if (component.get('v.sheetsName')) {
			let formNames = component.get('v.sheetsName');
			console.log('formNames ' + formNames);
			let formName = '';
			formNames.forEach(function (item, index, array) {
				formName += item.name + ',';
			});
			console.log('formName ' + formName);
			fields['Form_Name_Text__c'] = formName;
		}

		// we have a record Id so that means we're editing the page instead of creating a new one
		if (component.get('v.recordId')) {
			helper.updateEditEQCCHeader(component, fields, selectedSheetsIds, component.get('v.recordId'), duplicatedIds);

			// this is what saves the record after edit
			//component.find("header-edit-form").submit(fields);

			// return so we exit the function instead of continue
			return true;
		}

		let action = component.get('c.createEQCCHeaderWithSheets');
		action.setParams({
			sheetHeader: fields,
			sheetIds: selectedSheetsIds,
			orderOperationId: orderOperation
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let headerId = response.getReturnValue();

				if (headerId) {
					component.find('notifLib').showToast({
						variant: 'success',
						title: 'Checked Sheet Created'
					});

					helper.navigateToComponent(component, 'c__THOR_EQCCHeaderRecordDisplay', headerId);
				} else {
					component.find('notifLib').showToast({
						variant: 'warning',
						title: 'Contact System Admin',
						message: 'There is no main work center information, please contact System Admin'
					});
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
	},

	handleSheetSuccess: function (component, event, helper) {
		if (component.get('v.recordId') && component.get('v.hasMWC')) {
			component.find('notifLib').showToast({
				variant: 'success',
				title: 'Success',
				message: 'Saved successfully'
			});
			let recordId = component.get('v.recordId');
			let navLink = component.find('navService');
			let pageRef = {
				type: 'standard__component',
				attributes: {
					componentName: 'c__THOR_EQCCHeaderRecordDisplay'
				},
				state: {
					c__recordId: recordId
				}
			};
			navLink.navigate(pageRef, true);
		}
		component.set('v.isLoading', false);
	},

	handleNotificationSelected: function (component, event, helper) {
		let isLookup = component.get('v.lookupNotifications');
		let order;
		let notificationValue;

		if (isLookup) {
			order = component.find('order');
			notificationValue = component.find('notification').get('v.value');
		} else {
			order = component.find('orderOptions');
			notificationValue = component.find('notificationOptions').get('v.value');
		}

		if (notificationValue) {
			order.set('v.value', '');
			order.set('v.disabled', true);
			helper.completeEQCCFromNotification(component, notificationValue);
		} else {
			order.set('v.disabled', false);
		}
	},

	handleOrderSelected: function (component, event, helper) {
		let isLookup = component.get('v.lookupOrders');
		let notification;
		let orderValue;

		if (isLookup) {
			notification = component.find('notification');
			orderValue = component.find('order').get('v.value');
		} else {
			notification = component.find('notificationOptions');
			orderValue = component.find('orderOptions').get('v.value');
		}

		if (orderValue) {
			notification.set('v.value', '');
			notification.set('v.disabled', true);

			component.set('v.lookupOperations', false);

			helper.completeEQCCFromOrder(component, orderValue);
			helper.populateOperationOptions(component, orderValue);
		} else {
			notification.set('v.disabled', false);
		}
	},

	handleFLSelected: function (component, event, helper) {
		let fl = component.find('fl').get('v.value');

		if (fl) {
			let action = component.get('c.retrieveEquipmentsFromFunctionalLocation');
			action.setParams({
				funcLocationId: fl
			});

			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					component.set('v.lookupEquipments', false);
					let options = [];
					component.set('v.equipmentOptions', options);

					let equipments = response.getReturnValue();
					equipments.forEach((equipment) => {
						options.push({
							label: equipment.Name,
							value: equipment.Id
						});
					});

					component.set('v.equipmentOptions', options);
					if (equipments.length > 0) {
						component.set('v.equipmentValue', options[0].value);
						if (component.get('v.isModal')) {
							if (component.get('v.hasSheets')) {
								component.find('fl').set('v.disabled', true);
							}
							let equipment = component.find('equipmentOptions');
							if (equipment) {
								equipment.set('v.disabled', true);
							}
						}
					} else {
						component.find('equipmentOptions').set('v.disabled', true);
						if (component.get('v.hasSheets')) {
							component.find('fl').set('v.disabled', true);
						}
					}

					if (!component.get('v.isModal') || !component.get('v.orderOperationId')) {
						helper.populateCheckedSheets(component);
					}
					helper.checkFLMainWorkCenter(component, fl);
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
		} else {
			let equipment = component.find('equipmentOptions');
			component.set('v.lookupEquipments', true);
			if (equipment) {
				equipment.set('v.value', null);
			}

			component.find('equipment').set('v.disabled', false);
			component.find('equipment').set('v.value', null);

			let operation = component.find('orderOperationOptions');
			component.set('v.lookupOperations', true);
			if (operation) {
				operation.set('v.value', null);
			}

			helper.populateCheckedSheets(component);
		}
	},

	handleEquipmentSelected: function (component, event, helper) {
		let equipment = component.get('v.lookupEquipments')
			? component.find('equipment').get('v.value')
			: component.find('equipmentOptions').get('v.value');

		if (equipment) {
			let action = component.get('c.retrieveFunctionalLocationFromEquipment');
			action.setParams({
				equipmentId: equipment
			});

			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					let equipmentWithFL = response.getReturnValue();

					let fl = component.find('fl');
					fl.set('v.value', equipmentWithFL.FL__c);
					fl.set('v.disabled', true);

					helper.populateCheckedSheets(component);
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
		} else {
			let fl = component.find('fl');
			fl.set('v.value', null);
			fl.set('v.disabled', false);

			helper.populateCheckedSheets(component);
		}
	},

	handleOperationSelected: function (component, event, helper) {
		component.set('v.options', []);
		let orderOperationValue = component.find('orderOperationOptions').get('v.value').split(',');

		helper.populateCheckedSheetsFromOperation(component, orderOperationValue[0]);
	},

	handleRefresh: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	},

	doneRendering: function (component, event, helper) {
		let alreadyFired = component.get('v.doneRender');
		let fl = component.find('fl').get('v.value');
		if (!alreadyFired) {
			if (fl) {
				$A.enqueueAction(component.get('c.handleFLSelected'));
				component.set('v.doneRender', true);
			}

			let notification;
			let notificationVal;
			try {
				notification = component.find('notification');
				notificationVal = notification.get('v.value');
			} catch (err) {
				notification = component.find('notificationOptions');
				notificationVal = notification.get('v.value');
			}

			let order;
			let orderVal;
			try {
				order = component.find('order');
				orderVal = order.get('v.value');
			} catch (err) {
				order = component.find('orderOptions');
				orderVal = order.get('v.value');
			}

			if (notificationVal && !orderVal) {
				order.set('v.disabled', true);
			}
			if (orderVal && !notificationVal) {
				notification.set('v.disabled', true);
			}
		}
	},

	cancelConfirm: function (component, event, helper) {
		var parent = component.get('v.parent');
		parent.closeModal();
	},

	preventTyping: function (component, event, helper) {
		let sheet = event.getParam('value');
		if (sheet && !(sheet.length > 10)) {
			component.find('sheet').set('v.value', '');
		}
	},
	handleClickBack: function (component, event, helper) {
		window.history.back();
	}
});