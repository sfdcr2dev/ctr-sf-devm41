({
	doRender: function (component, event, helper) {
		var userStatusTemp = component.get('v.userStatusTemp');
		if (!userStatusTemp) {
			var userStatus = component.get('v.userStatus');
			if (userStatus) {
				component.set('v.userStatusTemp', userStatus);
			}
		}
	},

	doInit: function (component, event, helper) {
		let action = component.get('c.getPMActivityTypeAndOrderType');
		$A.enqueueAction(action);
	},

	showModal: function (component, event, helper) {
		component.set('v.showModal', 'true');
		// let action = component.get('c.getPMActivityTypeAndOrderType');
		// $A.enqueueAction(action);
	},

	handleChange: function (component, event, helper) {
		var { fieldName, value } = event.getParams();
		component.set(`v.form.${fieldName}`, value);
	},
	handleFocus: function (component, event, helper) {
		event.stopPropagation();
		event.preventDefault();
		event.getSource().blur();
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
	},
	handleLoad: function (component, event, helper) {
		var recordUi = event.getParam('recordUi');
		const {
			objectInfo: { fields },
			record
		} = recordUi;
		component.set('v.objectInfoFields', fields);

		if (Object.keys(component.get('v.form')).length == 0) {
			component.set(
				'v.form',
				Object.keys(record.fields).reduce((l, key) => ((l[key] = record.fields[key].value), l), {})
			);
		}
	},
	handleError: function (component, event, helper) {
		component.set('v.isLoading', false);
		try {
			var params = event.getParams();
			const {
				output: { fieldErrors }
			} = params;
			const { errorCode, fieldLabel, message } =
				fieldErrors && Object.keys(fieldErrors).length ? fieldErrors[Object.keys(fieldErrors)[0]][0] : {};
			if (message) {
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: fieldLabel,
					type: 'error',
					message: message
				});
				toastEvent.fire();
			}
		} catch (e) {
			console.error(e);
		}
	},
	handleSuccess: function (component, event, helper) {
		component.set('v.isLoading', false);
		// helper.makeToast('success', 'Success', 'Changes have been saved successfully');
		component.set('v.showModal', false);
		//$A.get('e.force:refreshView').fire();

		// var recordSavedEvent = component.getEvent('recordSavedEvent');
		// recordSavedEvent.setParams({
		// 	target: 'recordSaved'
		// });
		// recordSavedEvent.fire();

		if ($A.get('$Browser.isAndroid')) {
			var navService = component.find('navLink');
			navService.navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: '/apex/previous_back'
					}
				},
				true
			);
		} else {
			window.history.back(true);
		}
	},

	submitRecordEditFrom: function (component, event, helper) {
		component.find('utilityLwcButton').submit_click();
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault(); // stop the form from submitting
		component.set('v.isLoading', true);

		var userStatus = component.get('v.userStatusTemp');

		var fields = event.getParam('fields');
		fields['User_Status__c'] = userStatus;
		component.set('v.userStatus', userStatus);
		component.set('v.userStatusTemp', '');
		component.find('editOrderForm').submit(fields);
	},

	hideModal: function (component, event) {
		component.set('v.showModal', 'false');
	},

	openConfimCancelModal: function (component, event) {
		component.set('v.showCancelConfirmModal', 'true');
	},

	noConfirmCancelEdit: function (component, event) {
		component.set('v.showCancelConfirmModal', 'false');
	},

	yesConfirmCancelEdit: function (component, event, helper) {
		component.set('v.showCancelConfirmModal', 'false');
		// component.set('v.showModal', 'false');
		component.set('v.userStatusTemp', '');

		if ($A.get('$Browser.isAndroid')) {
			var navService = component.find('navLink');
			navService.navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: '/apex/previous_back'
					}
				},
				true
			);
		} else {
			window.history.back(true);
		}
	},

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
					if (returnedValue.MainWorkCenter__c) {
						component.set('v.mainWorkCenterValue', returnedValue.MainWorkCenter__c);
					} else {
						component.set('v.mainWorkCenterValue', '');
					}
					if (returnedValue.Planning_Plant__c) {
						component.set('v.planningPlantValue', returnedValue.Planning_Plant__c);
					} else {
						component.set('v.planningPlantValue', '');
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
			let equipment = component.find('Equipment__c');
			equipment.set('v.value', null);
			component.set('v.mainWorkCenterValue', '');
			component.set('v.mainWorkCenterPlantValue', '');
			component.set('v.planningPlantValue', '');
		}
	},

	selectUserStatus: function (component, event, helper) {
		component.set('v.setUserStatus', true);
	},

	closeUserStatusModal: function (component, event, helper) {
		var target = event.getParam('target');
		if (target == 'closeModal') {
			component.set('v.setUserStatus', false);
		} else if (target == 'setUserStatus') {
			var key = event.getParam('key');

			var userStatusTemp = '';
			key.forEach((status) => {
				userStatusTemp += status + ' ';
			});

			if (!userStatusTemp) {
				userStatusTemp = ' ';
			}

			component.set('v.userStatusTemp', userStatusTemp);
			component.set('v.setUserStatus', false);
		}
	},

	openPMActivityTypeModal: function (component, event, helper) {
		component.find('lightningInputPMActivityType').blur();
		component.set('v.pmActivityTypeModal', true);
	},

	closeModal: function (component, event, helper) {
		component.set('v.pmActivityTypeModal', false);
		component.set('v.mainWorkCenterModal', false);
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

	getPMActivityTypeAndOrderType: function (component, event, helper) {
		let action = component.get('c.getOrderById');
		action.setParams({
			orderId: component.get('v.recordId')
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let returnedValue = response.getReturnValue();
				if (returnedValue.PM_Activity_Type__c) {
					component.set('v.pmActivityTypeValue', returnedValue.PM_Activity_Type__c);
				} else {
					component.set('v.pmActivityTypeValue', '');
				}

				if (returnedValue.Main_Work_Center__c) {
					component.set('v.mainWorkCenterValue', returnedValue.Main_Work_Center__c);
				} else {
					component.set('v.mainWorkCenterValue', '');
				}

				if (returnedValue.mainWorkCenterPlant__c) {
					component.set('v.mainWorkCenterPlantValue', returnedValue.mainWorkCenterPlant__c);
				} else {
					component.set('v.mainWorkCenterPlantValue', '');
				}

				helper.retrievePMActivityTypeOptions(component, event, returnedValue.Order_Type__c);
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

	openMainWorkCenterModal: function (component, event, helper) {
		component.find('Main_Work_Center__c').blur();
		helper.retrieveMainWorkCenterOptions(component, event);
		component.set('v.mainWorkCenterModal', true);
	},
	clearMainWorkCenterValue: function (component, event, helper) {
		component.set('v.mainWorkCenterValue', '');
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

	selectMainWorkCenterPlant: function (component, event, helper) {
		var buttonValue = event.getSource().get('v.value');
		component.set('v.mainWorkCenterPlantValue', buttonValue);
		component.set('v.mainWorkCenterPlantModal', false);
	}
});