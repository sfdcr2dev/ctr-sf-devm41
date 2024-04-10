({
	doInit: function (component, event, helper) {
		helper.getFaultCodeAndMainWorkCenter(component, event);
	},
	redirectBack: function (component, event, helper) {
		component.find('navService').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: '/apex/previous_back'
				}
			},
			true
		);
	},
	redirectPage: function (component, event, helper) {
		component.find('navService').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:ODM_NotificationCreatePage`,
							attributes: {
								isRedirectPage: true,
								uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
									let r = (Math.random() * 16) | 0,
										v = c == 'x' ? r : (r & 0x3) | 0x8;
									return v.toString(16);
								})
							}
						})
					)}`
				}
			},
			false
		);
	},
	handlePISUser: function (component, event, helper) {
		var PISUserId = component.get('v.formData.Requester_PISUser__c'); // function PISUserId
		PISUserId = Array.isArray(PISUserId) ? PISUserId[0] : PISUserId;
		helper.getDepartmentResp(component, PISUserId);
	},
	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.formData.${params.fieldName}`, params.value);
		if (params.fieldName === 'Requester_PISUser__c') {
			$A.enqueueAction(component.get('c.handlePISUser'));
		}
	},
	handleFromChange: function (component, event, helper) {
		var params = event.getParams();
		const { expression, index } = params;
		var oldValue = Array.isArray(params.oldValue) ? params.oldValue[0] : params.oldValue;
		var value = Array.isArray(params.value) ? params.value[0] : params.value;

		if (index === 'mainWorkCenterPlant__c' && !value && oldValue) {
			component.set('v.formData.Main_Work_Center__c', null);
			component.set('v.formOptionDisplay.Main_Work_Center__c', []);
		} else if (index === 'Requester_PISUser__c' && !value) {
			$A.enqueueAction(component.get('c.handlePISUser'));
		}
	},
	handleSeletedButton: function (component, event, helper) {
		var targetSource = event.getSource();
		var fieldName = targetSource.get('v.name');
		var value = targetSource.get('v.value');
		component.set(`v.isToggleSubModal.${fieldName}`, !component.get(`v.isToggleSubModal.${fieldName}`));
		component.set(`v.formData.${fieldName}`, value);

		// if (fieldName === 'Requester_PISUser__c') {
		// 	$A.enqueueAction(component.get('c.handlePISUser'));
		// }
	},
	handleSearch: function (component, event, helper) {
		var targetInput = event.getSource();
		const fieldName = targetInput.get('v.name');
		const value = targetInput.get('v.value');

		if (['Main_Work_Center__c', 'mainWorkCenterPlant__c'].includes(fieldName)) {
			helper
				.debounce(
					component,
					$A.getCallback(() => {
						if (component.get(`v.formOption.${fieldName}`)) {
							component.set(
								`v.formOptionDisplay.${fieldName}`,
								component.get(`v.formOption.${fieldName}`).filter((f) => {
									return (
										(f.Name && f.Name.toLowerCase().includes(value.toLowerCase())) ||
										(f.Description__c && f.Description__c.toLowerCase().includes(value.toLowerCase()))
									);
								})
							);
						}
					}),
					300
				)
				.apply(this);
		}
	},
	handleFocus: function (component, event, helper) {
		event.stopPropagation();
		event.preventDefault();
		var fieldName = event.getSource().get('v.name');

		component.set(`v.isToggleSubModal.${fieldName}`, !component.get(`v.isToggleSubModal.${fieldName}`));
		switch (fieldName) {
			case 'mainWorkCenterPlant__c':
				helper.getMainWorkCenterPlants(component);
				break;
			case 'Main_Work_Center__c':
				helper.getMainWorkCenters(component);
				break;
			// case 'Requester_PISUser__c':
			// 	helper.getPISRequester(component, '');
			// 	break;
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
	handleChangeFunctionLocation: function (component, event, helper) {
		// Standard InputField
		//let funcLocationId = event.getSource().get('v.value'); // function location id
		//funcLocationId = Array.isArray(funcLocationId) ? funcLocationId[0] : funcLocationId;
		// Custom Component
		let params = event.getParams();
		component.set(`v.formData.${params.fieldName}`, params.value);
		let funcLocationId = params.value; // function location id

		helper.getEquipmentByFL(component, funcLocationId);
		helper.getFunctionLocationDetail(component, funcLocationId);
	},
	onClickSubmit: function (component, event, helper) {
		component.set('v.pressKey', {
			enter: false,
			click: true
		});
		component.find('utilityLwcButton').submit_click();
	},
	handleLoad: function (component, event, helper) {
		helper.stopLoading(component);
		var recordUi = event.getParam('recordUi');
		const {
			objectInfo: { fields }
		} = recordUi;
		// console.log(helper.parseObject(fields));

		component.set('v.notificationRecordUi', JSON.parse(JSON.stringify(recordUi)));
		component.set('v.formData.Functional_Location__c', recordUi.record.fields.Functional_Location__c.value);
		component.set('v.formData.Requester_PISUser__c', recordUi.record.fields.Requester_PISUser__c.value);
		component.set('v.formData.Department_Resp__c', recordUi.record.fields.Department_Resp__c.value);
		helper.getPISUsers(component, event, helper);

		component.set('v.objectInfoFields', fields);
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault();
		var fields = event.getParam('fields');
		// console.log(helper.parseObject(fields));

		setTimeout(
			$A.getCallback(() => {
				if (!component.get('v.pressKey.enter') && component.get('v.pressKey.click')) {
					helper.startLoading(component);

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
							event.getSource().submit(fields);
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
				}
			}),
			150
		);
	},
	handleSuccess: function (component, event, helper) {
		var params = event.getParams();
		const {
			response: { id }
		} = params;

		if (id) {
			new Promise(
				$A.getCallback((resolve, reject) => {
					if (component.get('v.formFactor') === 'DESKTOP') {
						resolve();
					}

					component.set('v.isToggleModal', !component.get('v.isToggleModal'));
					setTimeout(
						$A.getCallback(() => {
							resolve();
						}),
						300
					);
				})
			).then(() => {
				var navService = component.find('navService');
				navService.navigate(
					{
						type: 'standard__component',
						attributes: {
							componentName: 'c__ODM_NotificationRecordDisplay'
						},
						state: {
							c__recordId: id
						}
					},
					true
				);
			});
		} else {
			// todos something...
			helper.stopLoading(component);
		}
	},
	handleError: function (component, event, helper) {
		var error = event.getParams();
		console.error(helper.parseObject(error));
		helper.stopLoading(component);
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
});