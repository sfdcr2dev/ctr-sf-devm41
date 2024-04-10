({
	doInit: function (component, event, helper) {
		var currentUserId = $A.get('$SObjectType.CurrentUser.Id');
		component.set('v.currentUserId', currentUserId);
		component.set('v.today', $A.localizationService.formatDate(new Date(), 'YYYY-MM-DD'));
		if (!component.get('v.notificationId')) {
			var recordId = component.get('v.recordId');
			if (recordId) {
				component.set('v.notificationId', recordId);
			}
		}

		if (component.get('v.notificationId')) {
			let action = component.get('c.assignValues');
			$A.enqueueAction(action);
		}
	},
	handleCancel: function (component, event, helper) {
		var target = event.getSource();
		if (target.get('v.name') === 'Yes') {
			helper.onCancel(component);
		}
		component.set('v.isToggleSubModal.CancelButton', !component.get('v.isToggleSubModal.CancelButton'));
	},
	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.form.${params.fieldName}`, params.value);
	},
	// closeModal: function (component, event, helper) {
	// 	helper.closeModal(component, false);
	// },
	createOrderSuccess: function (component, event, helper) {
		/**
		 * @Description Thor2 - Integration improvement
		 Sync noti after sap send to update
		 */
		const { id } = event.getParams().response;
		if (id) {
			console.log(id);
			// var notificationEditRecordForm = component.find('notificationRecordEditForm');
			// notificationEditRecordForm.submit();
			component.find('navLink').navigate(
				{
					type: 'standard__component',
					attributes: {
						componentName: 'c__THOR_OrderRecordDisplay'
					},
					state: {
						c__recordId: id
					}
				},
				true
			);
		}
		// helper.showSuccessToast(component, event, helper);
	},

	handleRecordUpdated: function (component, event, helper) {
		if (component.get('v.notificationRecord.Order__c')) {
			component.set('v.notificationHasOrder', true);
			component.set('v.isLoading', false);
		}
	},
	showSuccessToastNotification: function (component, event, helper) {
		helper.showSuccessToast(component, event, helper);
	},

	handleLoad: function (component, event, helper) {
		var recordUi = event.getParam('recordUi');
		const {
			objectInfo: { fields }
		} = recordUi;
		// console.log(helper.parseObject(fields));

		component.set('v.objectInfoFields', fields);
	},
	handleSubmit: function (component, event, helper) {
		component.set('v.isLoading', true);
		// event.preventDefault();

		// event.getSource().submit();
	},
	showSuccesToastOrder: function (component, event, helper) {
		component.set('v.isLoading', false);

		var createdOrder = event.getParams().response;
		helper.showSuccessToast(component, event, helper);
		if (createdOrder) {
			// helper.closeModal(component, true);
			component.find('navLink').navigate(
				{
					type: 'standard__component',
					attributes: {
						componentName: 'c__THOR_OrderRecordDisplay'
					},
					state: {
						c__recordId: createdOrder.id
					}
				},
				true
			);
		}
	},
	showErrorToast: function (component, event, helper) {
		component.set('v.isLoading', false);

		var params = event.getParams();
		const {
			output: { fieldErrors }
		} = params;
		const { errorCode, fieldLabel, message } =
			fieldErrors && Object.keys(fieldErrors).length ? fieldErrors[Object.keys(fieldErrors)[0]][0] : {};
		console.log({ fieldLabel, message }, `${message}`.includes('DUPLICATE_VALUE'));
		if (`${message}`.includes('DUPLICATE_VALUE')) {
			component.find('lightning-message').setError('Something went wrong. Please try again.');
		} else {
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				type: 'error',
				duration: '5000',
				mode: 'dismissible',
				title: 'Error!',
				message: 'Something went wrong when creating the record.'
			});
			toastEvent.fire();
		}
	},
	showErrorToastNotification: function (component, event, helper) {
		try {
			var params = event.getParams();
			console.log(JSON.parse(JSON.stringify(params)));
			const {
				output: { fieldErrors }
			} = params;
			const { errorCode, fieldLabel, message } =
				fieldErrors && Object.keys(fieldErrors).length ? fieldErrors[Object.keys(fieldErrors)[0]][0] : {};

			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				type: 'error',
				duration: '5000',
				mode: 'dismissible',
				title: 'Error!',
				message: 'Something went wrong when creating the relation between notification and order.',
				messageTemplate: '{1}',
				messageTemplateData: [message]
			});
			toastEvent.fire();
		} catch (e) {
			console.error(e);
		}
	},
	// showConfirmation: function (component, event, helper) {
	// 	component.set('v.showConfirmation', true);
	// },
	// closeConfirmation: function (component, event, helper) {
	// 	var key = event.getParam('key');
	// 	if (key == 'closeConfirmation') {
	// 		component.set('v.showConfirmation', false);
	// 	} else {
	// 		if ($A.get('$Browser.isAndroid')) {
	// 			var navService = component.find('navLink');
	// 			navService.navigate(
	// 				{
	// 					type: 'standard__webPage',
	// 					attributes: {
	// 						url: '/apex/previous_back'
	// 					}
	// 				},
	// 				true
	// 			);
	// 		} else {
	// 			window.history.back(true);
	// 		}
	// 	}
	// },
	handleFLSelected: function (component, event, helper) {
		let fl = component.find('fl').get('v.value');
		if (fl) {
			let action = component.get('c.retrieveEquipmentsByFunctionalLocation');
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
						component.set('v.equipmentValue', equipments[0].Id);
						//component.find('equipment').set('v.value', equipments[0].Name);
					} else {
						component.set('v.equipmentValue', null);
						//component.find('equipment').set('v.value', null);
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
			let action2 = component.get('c.retrieveFunctionalLocationById');
			action2.setParams({
				flId: fl
			});
			action2.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					let returnedValue = response.getReturnValue();
					if (returnedValue.Planning_Plant__c) {
						component.set('v.planningPlantValue', returnedValue.Planning_Plant__c);
					} else {
						component.set('v.planningPlantValue', '');
					}
					if (returnedValue.MainWorkCenter__c) {
						component.set('v.mainWorkCenterValue', returnedValue.MainWorkCenter__c);
					} else {
						component.set('v.mainWorkCenterValue', '');
					}
					if (returnedValue.mainWorkCenterPlant__c) {
						component.set('v.mainWorkCenterPlantValue', returnedValue.mainWorkCenterPlant__c);
					} else {
						component.set('v.mainWorkCenterPlantValue', '');
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
			$A.enqueueAction(action2);
		} else {
			component.set('v.lookupEquipments', true);
			let equipment = component.find('equipment');
			equipment.set('v.value', null);
			component.set('v.planningPlantValue', '');
			component.set('v.mainWorkCenterValue', '');
			component.set('v.mainWorkCenterPlantValue', '');
		}
	},
	handleFLSelected2: function (component, event, helper) {
		let fl = component.find('Functional_Location__c').get('v.value');
		if (fl) {
			let action = component.get('c.retrieveEquipmentsByFunctionalLocation');
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
						component.set('v.equipmentValue', equipments[0].Id);
					} else {
						component.set('v.equipmentValue', null);
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
			let action2 = component.get('c.retrieveFunctionalLocationById');
			action2.setParams({
				flId: fl
			});
			action2.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					let returnedValue = response.getReturnValue();
					if (returnedValue.Planning_Plant__c) {
						component.set('v.planningPlantValue', returnedValue.Planning_Plant__c);
					} else {
						component.set('v.planningPlantValue', '');
					}
					if (returnedValue.MainWorkCenter__c) {
						component.set('v.mainWorkCenterValue', returnedValue.MainWorkCenter__c);
					} else {
						component.set('v.mainWorkCenterValue', '');
					}
					if (returnedValue.mainWorkCenterPlant__c) {
						component.set('v.mainWorkCenterPlantValue', returnedValue.mainWorkCenterPlant__cs);
					} else {
						component.set('v.mainWorkCenterPlantValue', '');
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
			$A.enqueueAction(action2);
		} else {
			component.set('v.lookupEquipments', true);
			let equipment = component.find('Equipment__c');
			equipment.set('v.value', null);
			component.set('v.planningPlantValue', '');
			let functionalLocation = component.find('Functional_Location__c');
			functionalLocation.set('v.value', null);
			component.set('v.mainWorkCenterValue', '');
			component.set('v.mainWorkCenterPlantValue', '');
		}
	},
	openPMActivityTypeModal: function (component, event, helper) {
		component.find('lightningInputPMActivityType').blur();
		let orderType = component.find('Order_Type__c').get('v.value');
		helper.retrievePMActivityTypeOptions(component, event, orderType);
		component.set('v.pmActivityTypeModal', true);
	},
	closePMActivityModal: function (component, event, helper) {
		component.set('v.pmActivityTypeModal', false);
	},
	clearPMActivityTypeValue: function (component, event, helper) {
		component.set('v.pmActivityTypeValue', '');
	},
	handleOnKeyUpPMActivityType: function (component, event, helper) {
		var isEnterKey = event.keyCode === 13;
		if (isEnterKey) {
			let action = component.get('c.handlePMActivityTypeSearch');
			$A.enqueueAction(action);
		}
	},
	handlePMActivityTypeSearch: function (component, event, helper) {
		var queryTerm = component.find('enter-search-pmActivityType').get('v.value');
		if (queryTerm != '') {
			let action = component.get('c.searchPMActivityTypeByNameAndDescription');
			action.setParams({
				searchText: queryTerm,
				pmActivityTypes: component.get('v.pmActivityTypeOptions')
			});
			action.setCallback(this, function (response) {
				let state = response.getState();
				console.log(state);
				if (state === 'SUCCESS') {
					let returnValue = response.getReturnValue();
					component.set('v.pmActivityTypesFilteredAndSearched', returnValue);
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
				component.set('v.isLoading', false);
			});
			component.set('v.isLoading', true);
			$A.enqueueAction(action);
		} else {
			component.set('v.pmActivityTypesFilteredAndSearched', component.get('v.pmActivityTypeOptions'));
		}
	},
	selectPMActivityType: function (component, event, helper) {
		var buttonValue = event.getSource().get('v.value');
		component.set('v.pmActivityTypeValue', buttonValue);
		component.set('v.pmActivityTypeModal', false);
	},
	handleOnChange: function (component, event, helper) {
		let orderType = component.find('Order_Type__c').get('v.value');
		helper.retrievePMActivityTypeOptions(component, event, orderType);
	},
	assignValues: function (component, event, helper) {
		let notificationId = component.get('v.notificationId');
		if (notificationId) {
			var action = component.get('c.getParentNotification');
			action.setParams({
				recordId: notificationId
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === 'SUCCESS') {
					// have to set values here, doing it in markup doesn't work
					let parentNotification = response.getReturnValue();
					component.set('v.form', parentNotification);

					component.find('Order_Type__c').set('v.value', parentNotification.Type__c + '01');
					component.find('Functional_Location__c').set('v.value', parentNotification.Functional_Location__c);
					component.find('Equipment__c').set('v.value', parentNotification.Equipment__c);
					if (parentNotification.Functional_Location__c) {
						component
							.find('Planning_Plant__c')
							.set('v.value', parentNotification.Functional_Location__r.Planning_Plant__c);
					}
					if (parentNotification.Main_Work_Center__c) {
						component.set('v.mainWorkCenterValue', parentNotification.Main_Work_Center__c);
					}
					if (parentNotification.mainWorkCenterPlant__c) {
						component.set('v.mainWorkCenterPlantValue', parentNotification.mainWorkCenterPlant__c);
					}
				} else if (state === 'ERROR') {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							helper.makeToast('error', 'Error', errors[0].message);
						}
					} else {
						helper.makeToast('error', 'Error', 'Unknown Error, please check dev logs.');
					}
				}
				component.set('v.isLoading', false);
			});
			component.set('v.isLoading', true);
			$A.enqueueAction(action);
		}
	},

	openMainWorkCenterModal: function (component, event, helper) {
		component.find('Main_Work_Center__c').blur();
		helper.retrieveMainWorkCenterOptions(component, event);
		component.set('v.mainWorkCenterModal', true);
	},
	closeMainWorkCenterModal: function (component, event, helper) {
		component.set('v.mainWorkCenterModal', false);
	},
	handleOnKeyUpMainWorkCenter: function (component, event, helper) {
		var isEnterKey = event.keyCode === 13;
		if (isEnterKey) {
			let action = component.get('c.handleMainWorkCenterSearch');
			$A.enqueueAction(action);
		}
	},
	handleMainWorkCenterSearch: function (component, event, helper) {
		var queryTerm = component.find('enter-search-mainWorkCenter').get('v.value');
		if (queryTerm != '') {
			let action = component.get('c.searchMainWorkCenterByNameAndDescription');
			action.setParams({
				searchText: queryTerm,
				mainWorkCenters: component.get('v.mainWorkCenterOptions')
			});
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					let returnValue = response.getReturnValue();
					component.set('v.mainWorkCentersFilteredAndSearched', returnValue);
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
				component.set('v.isLoading', false);
			});
			component.set('v.isLoading', true);
			$A.enqueueAction(action);
		} else {
			component.set('v.mainWorkCentersFilteredAndSearched', component.get('v.mainWorkCenterOptions'));
		}
	},
	selectMainWorkCenter: function (component, event, helper) {
		var buttonValue = event.getSource().get('v.value');
		component.set('v.mainWorkCenterValue', buttonValue);
		component.set('v.mainWorkCenterModal', false);
	},

	clearMainWorkCenterValue: function (component, event, helper) {
		component.set('v.mainWorkCenterValue', '');
	},

	clearMainWorkCenterPlantValue: function (component, event, helper) {
		component.set('v.mainWorkCenterValue', '');
		component.set('v.mainWorkCenterPlantValue', '');
		component.set('v.mainWorkCenterOptions', null);
		component.set('v.mainWorkCentersFilteredAndSearched', null);
	},

	openMainWorkCenterPlantModal: function (component, event, helper) {
		component.find('mainWorkCenterPlant__c').blur();
		helper.retrieveMainWorkCenterPlantOptions(component, event);
		component.set('v.mainWorkCenterPlantModal', true);
	},

	closeMainWorkCenterPlantModal: function (component, event, helper) {
		component.set('v.mainWorkCenterPlantModal', false);
	},

	handleOnKeyUpMainWorkCenterPlant: function (component, event, helper) {
		var isEnterKey = event.keyCode === 13;
		if (isEnterKey) {
			let action = component.get('c.handleMainWorkCenterPlantSearch');
			$A.enqueueAction(action);
		}
	},

	handleMainWorkCenterPlantSearch: function (component, event, helper) {
		var queryTerm = component.find('enter-search-mainWorkCenterPlant').get('v.value');
		if (queryTerm != '') {
			let action = component.get('c.searchMainWorkCenterPlantByNameAndDescription');
			action.setParams({
				searchText: queryTerm,
				mainWorkCenterPlants: component.get('v.mainWorkCenterPlantOptions')
			});
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					let returnValue = response.getReturnValue();
					component.set('v.mainWorkCenterPlantsFilteredAndSearched', returnValue);
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
			component.set('v.mainWorkCenterPlantsFilteredAndSearched', component.get('v.mainWorkCenterPlantOptions'));
		}
	},

	handleSearch: function (component, event, helper) {
		var targetInput = event.getSource();
		const fieldName = targetInput.get('v.name');
		const value = targetInput.get('v.value');

		if (['Requester_PISUser__c', 'Responsible_person_PISUser__c'].includes(fieldName)) {
			helper
				.debounce(
					component,
					$A.getCallback(() => {
						helper.getPISRequester(component, fieldName, value);
					}),
					300
				)
				.apply(this);
		}
	},

	handleSeletedButton: function (component, event, helper) {
		var targetSource = event.getSource();
		var fieldName = targetSource.get('v.name');
		var value = targetSource.get('v.value');
		component.set(`v.isToggleSubModal.${fieldName}`, !component.get(`v.isToggleSubModal.${fieldName}`));
		component.set(`v.form.${fieldName}`, value);

		//		if (fieldName === 'Requester_PISUser__c') {
		//			$A.enqueueAction(component.get('c.handlePISUser'));
		//		}
	},

	handleFocus: function (component, event, helper) {
		event.stopPropagation();
		event.preventDefault();
		var fieldName = event.getSource().get('v.name');

		component.set(`v.isToggleSubModal.${fieldName}`, !component.get(`v.isToggleSubModal.${fieldName}`));
		switch (fieldName) {
			case 'Requester_PISUser__c':
			case 'Responsible_person_PISUser__c':
				helper.getPISRequester(component, fieldName, '');
				break;
			default:
				break;
		}

		setTimeout(
			$A.getCallback(function () {
				var autoFocusSearchInput = component.find('search-input');
				autoFocusSearchInput = Array.isArray(autoFocusSearchInput) ? autoFocusSearchInput : [autoFocusSearchInput];
				autoFocusSearchInput.forEach((cmp) => cmp.focus());
			}),
			300
		);
	},

	selectMainWorkCenterPlant: function (component, event, helper) {
		var buttonValue = event.getSource().get('v.value');
		component.set('v.mainWorkCenterPlantValue', buttonValue);
		component.set('v.mainWorkCenterPlantModal', false);
	},
	onClickSubmit: function (component, event, helper) {
		component.find('utilityLwcButton').submit_click();
	}
});