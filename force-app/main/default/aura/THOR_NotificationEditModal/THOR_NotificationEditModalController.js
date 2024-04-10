({
	doInit: function (component, event, helper) {
		// showModal: function (component, event, helper) {
		// component.set('v.showModal', 'true');
		helper.getFaultCodeAndMainWorkCenter(component, event);
		helper.retrieveMainWorkCenterPlantOptions(component, event);
	},

	doRender: function (component, event, helper) {
		// component.set('v.oldHistoryDetail', component.get('v.notificationRecord.History_Detail__c'));
		// component.set('v.userStatus', component.get('v.notificationRecord.User_Status__c'));
		// component.set('v.type', component.get('v.notificationRecord.Type__c'));

		var userStatusTemp = component.get('v.userStatusTemp');
		if (!userStatusTemp) {
			var userStatus = component.get('v.userStatus');
			if (userStatus) {
				component.set('v.userStatusTemp', userStatus);
			}
		}
	},

	handleOnError: function (component, event, helper) {
		var params = event.getParams();
		try {
			const {
				output: { fieldErrors }
			} = params;
			console.error(JSON.parse(JSON.stringify(fieldErrors)));
			const { errorCode, fieldLabel, message } =
				fieldErrors && Object.keys(fieldErrors).length ? fieldErrors[Object.keys(fieldErrors)[0]][0] : {};

			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				title: fieldLabel,
				type: 'error',
				message: message
			});
			toastEvent.fire();
		} catch (e) {
			console.error(e);
		}

		component.set('v.isLoading', false);
	},
	handleSuccess: function (component, event, helper) {
		component.set('v.isLoading', false);
		// helper.makeToast('success', 'Success', 'Changes have been saved successfully');
		component.set('v.showModal', false);
		component.set('v.newHistoryDetail', '');

		window.history.back(true);

		// var params = event.getParams();
		// const {
		// 	response: { id }
		// } = params;
		// var navService = component.find('navLink');
		// navService.navigate(
		// 	{
		// 		type: 'standard__component',
		// 		attributes: {
		// 			componentName: 'c__THOR_NotificationRecordDisplay'
		// 		},
		// 		state: {
		// 			c__recordId: id
		// 		}
		// 	},
		// 	true
		// );

		// var recordSavedEvent = component.getEvent('recordSavedEvent');
		// recordSavedEvent.setParams({
		// 	target: 'recordSaved'
		// });
		// recordSavedEvent.fire();
	},

	submitRecordEditFrom: function (component, event, helper) {
		component.find('utilityLwcButton').submit_click();
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault(); // stop the form from submitting
		component.set('v.isLoading', true);

		let action = component.get('c.getUserName');
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let userName = response.getReturnValue();

				var oldHistoryDetail = component.get('v.oldHistoryDetail');
				var newHistoryDetail = component.get('v.newHistoryDetail');

				var historyDetail = '';

				if (oldHistoryDetail != null) {
					historyDetail = oldHistoryDetail;
				}

				if (newHistoryDetail != '') {
					if (!historyDetail.includes('*')) {
						if (historyDetail != '') {
							historyDetail += '\n\n* ' + userName + ':\n';
						} else {
							historyDetail = '* ' + userName + ':\n';
						}
					} else {
						historyDetail = historyDetail.replace('* ', '') + '\n\n* ' + userName + ':\n';
					}

					historyDetail = historyDetail + newHistoryDetail;
				}

				var userStatus = component.get('v.userStatusTemp');

				var fields = event.getParam('fields');
				fields['History_Detail__c'] = historyDetail;
				fields['User_Status__c'] = userStatus;
				if (!fields['Fault_Code__c']) {
					fields['Fault_Code__c'] = '';
				}
				component.set('v.userStatus', userStatus);
				component.set('v.userStatusTemp', '');
				component.find('editNotificationForm').submit(fields);
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
		component.set('v.showModal', 'false');
		component.set('v.userStatusTemp', '');
		component.set('v.newHistoryDetail', '');
		helper.getFaultCodeAndMainWorkCenter(component, event);

		window.history.back(true);
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
			});

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
			});
			$A.enqueueAction(action2);
		} else {
			component.set('v.lookupEquipments', true);
			let equipment = component.find('Equipment__c');
			equipment.set('v.value', null);
			component.set('v.mainWorkCenterValue', '');
			component.set('v.planningPlantValue', '');
			component.set('v.mainWorkCenterPlantValue', '');
		}
	},

	handleOnLoad: function (component, event, helper) {
		var recordUi = event.getParam('recordUi');
		const {
			record: { fields }
		} = recordUi;
		// console.log(JSON.parse(JSON.stringify(fields)));
		component.set('v.form.Equipment__c', fields.Equipment__c.value);
		component.set('v.form.Functional_Location__c', fields.Functional_Location__c.value);
		// helper.retrieveCodeGroup(component);
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

	searchCodeGroup: function (component, event, helper) {
		var queryTerm = event.getSource().get('v.value').toLowerCase();

		helper
			.debounce(
				component,
				$A.getCallback(() => {
					component.set(
						'v.formOption.Code_Group__c',
						component
							.get('v.codeGroupOptions')
							.filter(
								(f) => f.Description__c.toLowerCase().includes(queryTerm) || f.Code__c.toLowerCase().includes(queryTerm)
							)
					);
				}),
				300
			)
			.apply(this);
	},
	selectCodeGroup: function (component, event, helper) {
		var target = event.getSource();

		// var description = target.get('v.title');
		// console.log({ value, description });
		component.set('v.form.Code_Group__c', target.get('v.value'));
		component.set('v.formModal.Code_Group__c', !target.get('v.value'));
		component.set('v.formModal.Fault_Code__c', !!target.get('v.value'));
		helper.retrieveFaultCodeOptions(component);
	},
	toggleCodeGroupModal: function (component, event, helper) {
		component.find('lightningInputFaultCode').blur();

		let equipment = component.get('v.lookupEquipments')
			? component.find('Equipment__c').get('v.value')
			: component.find('equipmentOptions').get('v.value');
		let functionalLocation = component.find('fl').get('v.value');
		Promise.all([
			helper.getCatelogProfileByEquipIdOrFuncId(component, equipment),
			helper.getCatelogProfileByEquipIdOrFuncId(component, functionalLocation)
		])
			.then(
				$A.getCallback((res) => {
					component.set('v.catalogProfileId', res[0] || res[1]);
					// console.log({ res, catalogProfileId: component.get('v.catalogProfileId') });
					component.set('v.formModal.Code_Group__c', !component.get('v.formModal.Code_Group__c'));
					helper.retrieveCodeGroup(component);

					// var hasCatelogProfile = res.some((s) => s);
					// if (hasCatelogProfile) {
					// 	helper.retrieveFaultCodeOptions(component);
					// 	component.set('v.formModal.Fault_Code__c', true);
					// }
				})
			)
			.catch((e) => {
				console.error(e);
			});
	},

	openFaultCodeModal: function (component, event, helper) {
		component.find('lightningInputFaultCode').blur();
		component.set('v.formModal.Fault_Code__c', true);
	},
	closeModal: function (component, event, helper) {
		component.set('v.formModal.Fault_Code__c', false);
	},
	selectFaultCode: function (component, event, helper) {
		component.set('v.form.Fault_Code__c', event.getSource().get('v.value'));
		component.set('v.form.Fault_Code_Description__c', event.getSource().get('v.title'));
		component.set('v.formModal.Fault_Code__c', false);
	},

	handleOnKeyUpFaultCode: function (component, event, helper) {
		// console.log(event.getSource().get('v.value'));
		// if (event.getSource().get('v.value')) {
		// }
		helper
			.debounce(
				component,
				$A.getCallback(() => {
					$A.enqueueAction(component.get('c.handleFaultCodeSearch'));
				}),
				300
			)
			.apply(this);
	},

	handleFaultCodeSearch: function (component, event, helper) {
		var queryTerm = component.find('enter-search-faultCode').get('v.value').toLowerCase();

		component.set(
			'v.formOption.Fault_Code__c',
			queryTerm
				? component
						.get('v.faultCodeOptions')
						.filter(
							(f) =>
								f.name.toLowerCase().includes(queryTerm) ||
								(f.description && f.description.toLowerCase().includes(queryTerm))
						)
				: component.get('v.faultCodeOptions')
		);
	},

	clearFaultCodeValue: function (component, event, helper) {
		component.set('v.form.Fault_Code__c', null);
		component.set('v.form.Fault_Code_Description__c', null);
	},

	openMainWorkCenterModal: function (component, event, helper) {
		component.find('Main_Work_Center__c').blur();
		helper.retrieveMainWorkCenterOptions(component, event);
		component.set('v.mainWorkCenterModal', true);
	},

	closeMainWorkCenterModal: function (component, event, helper) {
		component.set('v.mainWorkCenterModal', false);
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
			});
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