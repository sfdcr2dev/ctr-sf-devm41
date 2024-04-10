({
	doInit: function (component, event, helper) {
		if (component.get('v.orderId')) {
			let action = component.get('c.assignValues');
			$A.enqueueAction(action);
		}
	},
	onClickSubmit: function (component, event, helper) {
		component.find('utilityLwcButton').submit_click();
	},
	handleLoad: function (component, event, helper) {
		var recordUi = event.getParam('recordUi');
		const {
			objectInfo: { fields }
		} = recordUi;
		component.set('v.objectInfoFields', fields);
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault();
		component.set('v.isLoading', true);
		event.getSource().submit();
	},
	handleSuccess: function (component, event, helper) {
		component.set('v.isLoading', false);

		const createdRecord = event.getParams().response;
		var action = component.get('c.changeOrderNumberToName');
		action.setParams({
			recordId: createdRecord.id
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				helper.makeToast('success', 'Success', 'New sub order succesfully created');
				var handleViewEvent = component.getEvent('closeModalEvent');
				handleViewEvent.setParams({
					key: 'close'
				});
				handleViewEvent.fire();
				var subOrder = event.getParams().response;
				var pageRef = component.get('v.pageReference');
				let navLink = component.find('navLink');
				pageRef = {
					type: 'standard__component',
					attributes: {
						componentName: 'c__THOR_OrderRecordDisplay'
					},
					state: {
						c__recordId: subOrder.id
					}
				};
				navLink.navigate(pageRef, true);
				// pass
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
	},
	handleError: function (component, event, helper) {
		component.set('v.isLoading', false);
		var params = event.getParams();
		const {
			output: { fieldErrors }
		} = params;
		const { errorCode, fieldLabel, message } =
			fieldErrors && Object.keys(fieldErrors).length ? fieldErrors[Object.keys(fieldErrors)[0]][0] : {};

		var toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			title: fieldLabel,
			type: 'error',
			message: message
		});
		toastEvent.fire();
	},
	openConfimCancelModal: function (component, event) {
		component.set('v.showCancelConfirmModal', 'true');
	},
	noConfirmCancelEdit: function (component, event) {
		component.set('v.showCancelConfirmModal', 'false');
	},
	yesConfirmCancelEdit: function (component, event, helper) {
		// var handleViewEvent = component.getEvent('closeModalEvent');
		// handleViewEvent.setParams({
		// 	key: 'close'
		// });
		// handleViewEvent.fire();

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
			component.set('v.planningPlantValue', '');
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
	closeMainWorkCenterModal: function (component, event, helper) {
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
	handleOnChange: function (component, event, helper) {
		let orderType = component.find('Order_Type__c').get('v.value');
		helper.retrievePMActivityTypeOptions(component, event, orderType);
	},
	assignValues: function (component, event, helper) {
		if (component.get('v.orderId')) {
			var action = component.get('c.getParentOrder');
			action.setParams({
				recordId: component.get('v.orderId')
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === 'SUCCESS') {
					// have to set values here, doing it in markup doesn't work
					var parentOrder = response.getReturnValue();
					parentOrder.Responsible_person_PISUser__c = null;
					component.set('v.form', parentOrder);

					try {
						if (parentOrder.Functional_Location__c) {
							component.find('Functional_Location__c').set('v.value', parentOrder.Functional_Location__c);
							if (parentOrder.Functional_Location__r.Planning_Plant__c) {
								component
									.find('Planning_Plant__c')
									.set('v.value', parentOrder.Functional_Location__r.Planning_Plant__c);
							}
						}
						if (parentOrder.Main_Work_Center__c) {
							component.set('v.mainWorkCenterValue', parentOrder.Main_Work_Center__c);
						}
						if (parentOrder.mainWorkCenterPlant__c) {
							component.set('v.mainWorkCenterPlantValue', parentOrder.mainWorkCenterPlant__c);
						}
						if (parentOrder.PM_Activity_Type__c) {
							component.set('v.pmActivityTypeValue', parentOrder.PM_Activity_Type__c);
						} else {
							component.set('v.pmActivityTypeValue', '');
						}
						if (parentOrder.Order_Type__c) {
							component.find('Order_Type__c').set('v.value', parentOrder.Order_Type__c);
						}
						if (parentOrder.Description__c) {
							component.find('Description__c').set('v.value', parentOrder.Description__c);
						}
						if (parentOrder.Equipment__c) {
							component.find('Equipment__c').set('v.value', parentOrder.Equipment__c);
						}
						if (parentOrder.Start_Date__c) {
							component.find('Start_Date__c').set('v.value', parentOrder.Start_Date__c);
						}
						if (parentOrder.Finished_Date__c) {
							component.find('Finished_Date__c').set('v.value', parentOrder.Finished_Date__c);
						}
						if (parentOrder.Priority__c) {
							component.find('Priority__c').set('v.value', parentOrder.Priority__c);
						}
						// if (parentOrder.Requester_PISUser__c) {
						// 	component.find('Requester_PISUser__c').set('v.value', parentOrder.Requester_PISUser__c);
						// }
						// if (parentOrder.Responsible_person__c) {
						// 	component.find('Responsible_person__c').set('v.value', parentOrder.Responsible_person__c);
						// }
					} catch (error) {
						console.log(error);
					}
					// } else if (state === 'ERROR') {
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

	selectMainWorkCenterPlant: function (component, event, helper) {
		var buttonValue = event.getSource().get('v.value');
		component.set('v.mainWorkCenterPlantValue', buttonValue);
		component.set('v.mainWorkCenterPlantModal', false);
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
	handleChange: function (component, event, helper) {
		var { fieldName, value } = event.getParams();
		component.set(`v.form.${fieldName}`, value);
	},
	handleFormChange: function (component, event, helper) {
		var params = event.getParams();
		const { expression, index, oldValue, value } = params;
		const fieldName = index;
		if (['Requester_PISUser__c', 'Responsible_person_PISUser__c'].includes(fieldName)) {
			var pisUserId = Array.isArray(value) && value ? value[0] : value || null;
			var userId = component.get(`v.pisUserMap.${pisUserId}.User__c`) || null;
			component.set(`v.form.${fieldName.replace('__c', '__r')}.User__c`, userId);
		}
	},
	handleSeletedButton: function (component, event, helper) {
		var targetSource = event.getSource();
		var fieldName = targetSource.get('v.name');
		var value = targetSource.get('v.value');
		component.set(`v.isToggleSubModal.${fieldName}`, !component.get(`v.isToggleSubModal.${fieldName}`));
		component.set(`v.form.${fieldName}`, value);
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
	}
});