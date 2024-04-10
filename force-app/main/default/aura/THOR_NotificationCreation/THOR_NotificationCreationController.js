({
	doInit: function (component, event, helper) {
		// helper.handlerPreventEnter(component, true);
		component.set('v.form', {
			Priority__c: 'Normal',
			Required_Start__c: new Date().toISOString(),
			Requested_Date__c: $A.localizationService.formatDate(new Date(), 'YYYY-MM-DD')
		});
		helper.startLoading(component);

		if (component.get('v.orderId')) {
			helper.getOrdersDetailById(component, component.get('v.orderId'));
		}
	},
	redirectBack: function (component, event, helper) {
		// window.history.back(true);
		var navService = component.find('navService');
		navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: '/apex/previous_back'
				}
			},
			true
		);
	},
	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.form.${params.fieldName}`, params.value);
		if (params.fieldName === 'Requester_PISUser__c') {
			$A.enqueueAction(component.get('c.handlePISUser'));
		}
	},
	// toggleModal: function (component, event, helper) {
	// 	// Create notification under order
	// 	var params = event.getParams();
	// 	if (Object.keys(params).length) {
	// 		const _args = params.arguments;
	// 		if (_args) {
	// 			component.set('v.orderId', _args.orderId);
	// 			helper.getOrdersDetailById(component, _args.orderId);
	// 		}
	// 	}

	// 	component.set('v.isToggleModal', !component.get('v.isToggleModal'));
	// 	component.set('v.isToggleSubModal', {});

	// 	// de-active listen prevent enter type
	// 	if (!component.get('v.isToggleModal')) {
	// 		helper.handlerPreventEnter(component, false);
	// 	}
	// },

	handleSearch: function (component, event, helper) {
		var targetInput = event.getSource();
		const fieldName = targetInput.get('v.name');
		const value = targetInput.get('v.value');

		if (fieldName === 'Requester_PISUser__c') {
			helper
				.debounce(
					component,
					$A.getCallback(() => {
						helper.getPISRequester(component, value);
					}),
					300
				)
				.apply(this);
		} else if (['Main_Work_Center__c', 'mainWorkCenterPlant__c'].includes(fieldName)) {
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
	handleFunctionLocation: function (component, event, helper) {
		var funcLocationId = event.getSource().get('v.value'); // function location id
		funcLocationId = Array.isArray(funcLocationId) ? funcLocationId[0] : funcLocationId;
		helper.getEquipmentByFL(component, funcLocationId);
		helper.getFunctionLocationDetail(component, funcLocationId);
	},
	handlePISUser: function (component, event, helper) {
		var PISUserId = component.get('v.form.Requester_PISUser__c'); // function PISUserId
		PISUserId = Array.isArray(PISUserId) ? PISUserId[0] : PISUserId;
		helper.getDepartmentResp(component, PISUserId);
	},
	handleSeletedButton: function (component, event, helper) {
		var targetSource = event.getSource();
		var fieldName = targetSource.get('v.name');
		var value = targetSource.get('v.value');
		component.set(`v.isToggleSubModal.${fieldName}`, !component.get(`v.isToggleSubModal.${fieldName}`));
		component.set(`v.form.${fieldName}`, value);

		if (fieldName === 'Requester_PISUser__c') {
			$A.enqueueAction(component.get('c.handlePISUser'));
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
			case 'Requester_PISUser__c':
				helper.getPISRequester(component, '');
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
	handleFromChange: function (component, event, helper) {
		var params = event.getParams();
		const { expression, index } = params;
		var oldValue = Array.isArray(params.oldValue) ? params.oldValue[0] : params.oldValue;
		var value = Array.isArray(params.value) ? params.value[0] : params.value;
		// console.log(helper.parseObject(params), !value && oldValue, {
		// 	value,
		// 	oldValue
		// });
		if (index === 'mainWorkCenterPlant__c' && !value && oldValue) {
			component.set('v.form.Main_Work_Center__c', null);
			component.set('v.formOptionDisplay.Main_Work_Center__c', []);
		} else if (index === 'Requester_PISUser__c' && !value) {
			$A.enqueueAction(component.get('c.handlePISUser'));
		}
	},

	handleLoad: function (component, event, helper) {
		helper.stopLoading(component);
		var recordUi = event.getParam('recordUi');
		const {
			objectInfo: { fields }
		} = recordUi;
		// console.log(helper.parseObject(fields));

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
					event.getSource().submit(fields);
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
							componentName: 'c__THOR_NotificationRecordDisplay'
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
	onClickSubmit: function (component, event, helper) {
		component.set('v.pressKey', {
			enter: false,
			click: true
		});
		component.find('utilityLwcButton').submit_click();
	}
});