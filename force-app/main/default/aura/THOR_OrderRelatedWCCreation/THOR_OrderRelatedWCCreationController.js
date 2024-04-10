({
	doInit: function (component, event, helper) {
		component.set('v.form.Order__c', component.get('v.orderId'));
        helper.getAreas(component, event, helper);
	},
	toggleModal: function (component, event, helper) {
		// component.set('v.isShowModal', !component.get('v.isShowModal'));
		// if (component.get('v.isShowModal')) {
		// 	helper.startLoading(component);
		// 	helper.getOrderDetailById(component, event, helper);
		// 	//$A.enqueueAction(component.get('c.doInit'));
		// }

		if (!component.get('v.isShowModal')) {
			component.find('navService').navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${window.btoa(
							JSON.stringify({
								componentDef: `c:THOR_OrderRelatedWCCreation`,
								attributes: {
									isShowModal: true,
									orderId: component.get('v.orderId'),
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
		} else {
			if ($A.get('$Browser.isAndroid')) {
				component.find('navService').navigate(
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
		}
	},
	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.form.${params.fieldName}`, params.value);
		//if(params.fieldName === 'Requester_PISUser__c') {
		//	$A.enqueueAction(component.get('c.handlePISUser'));
		//}
	},
	handleFocus: function (component, event, helper) {
		event.stopPropagation();
		event.preventDefault();
		var fieldName = event.getSource().get('v.name');

		component.set(`v.isToggleSubModal.${fieldName}`, !component.get(`v.isToggleSubModal.${fieldName}`));
		switch (fieldName) {
			case 'Requester_UI__c':
			case 'Thaioil_Supervisor_Indicator_UI__c':
				helper.getPISRequester(component, '', fieldName);
				break;
			case 'Applicant_or_Bearer_UI__c':
			case 'Bearer1_UI__c':
			case 'Bearer2_UI__c':
			case 'Bearer3_UI__c':
			case 'Bearer4_UI__c':
				helper.getApplicantOrBearer(component, '', fieldName);
				break;
			case 'Safety_Permit1_UI__c':
			case 'Safety_Permit2_UI__c':
			case 'Safety_Permit3_UI__c':
				helper.getSafetyPermit(component, '', fieldName);
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
	handleLoad: function (component, event, helper) {
		helper.stopLoading(component);
		var recordUi = event.getParam('recordUi');
		const {
			objectInfo: { fields }
		} = recordUi;

		component.set('v.objectInfoFields', fields);
	},
	handleSearch: function (component, event, helper) {
		var targetInput = event.getSource();
		const fieldName = targetInput.get('v.name');
		const value = targetInput.get('v.value');

		if (fieldName === 'Thaioil_Supervisor_Indicator_UI__c' || fieldName === 'Requester_UI__c') {
			helper
				.debounce(
					component,
					$A.getCallback(() => {
						helper.getPISRequester(component, value, fieldName);
					}),
					300
				)
				.apply(this);
		} else if (
			fieldName === 'Applicant_or_Bearer_UI__c' ||
			fieldName === 'Bearer1_UI__c' ||
			fieldName === 'Bearer2_UI__c' ||
			fieldName === 'Bearer3_UI__c' ||
			fieldName === 'Bearer4_UI__c'
		) {
			helper
				.debounce(
					component,
					$A.getCallback(() => {
						helper.getApplicantOrBearer(component, value, fieldName);
					}),
					300
				)
				.apply(this);
		} else if (
			fieldName === 'Safety_Permit1_UI__c' ||
			fieldName === 'Safety_Permit2_UI__c' ||
			fieldName === 'Safety_Permit3_UI__c'
		) {
			helper
				.debounce(
					component,
					$A.getCallback(() => {
						helper.getSafetyPermit(component, value, fieldName);
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
	handleSubmit: function (component, event, helper) {
		event.preventDefault();
		var fields = event.getParam('fields');

		event.getSource().submit(fields);
	},
	handleSuccess: function (component, event, helper) {
		helper.makeToast('success', 'Success', 'Work Clearance Created');

		var params = event.getParams();
		const {
			response: { id }
		} = params;

		if (id) {
			//			var navService = component.find('navService');
			//			navService.navigate(
			//				{
			//					type: 'standard__component',
			//					attributes: {
			//						componentName: 'c__THOR_WorkClearanceRecordDisplay'
			//					},
			//					state: {
			//						c__recordId: id
			//					}
			//				},
			//				false
			//			);
			var navService = component.find('navService');
			navService.navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${btoa(
							JSON.stringify({
								componentDef: `c:THOR_WorkClearanceRecordDisplay`,
								attributes: {
									recordId: id,
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
		} else {
			// todos something...
			helper.stopLoading(component);
		}
	},
	handleError: function (component, event, helper) {
		//alert('Error')
		helper.makeToast('error', 'Error', 'Cannot Create Work Clearance');
		var error = event.getParam('error');
		console.error(JSON.parse(JSON.stringify(error)));
	},
	handleSectionToggle: function (cmp, event) {},
	onSubmitFooter: function (component, event, helper) {
		component.find('accordion').set('v.activeSectionName', 'collapseA');
		setTimeout(function () {
			component.find('utilityLwcButton').submit_click();
		}, 500);
	},
	showRow: function (component, event, helper) {
		//alert(JSON.stringify(component.get("v.isStep1")));
		var isStep1 = component.get('v.isStep1');
		var isStep2 = component.get('v.isStep2');
		var isStep3 = component.get('v.isStep3');

		let buttonAdd = component.find('disablebuttonid');
		let buttonRemove = component.find('disablebuttonhide');

		if (isStep1 == false) {
			component.set('v.isStep1', true);
			buttonRemove.set('v.disabled', false);
		} else {
			if (isStep2 == false) {
				component.set('v.isStep2', true);
			} else {
				if (isStep3 == false) {
					component.set('v.isStep3', true);
					buttonAdd.set('v.disabled', true);
				}
			}
		}
	},

	hideRow: function (component, event, helper) {
		//alert(JSON.stringify(component.get("v.isStep1")));
		var isStep1 = component.get('v.isStep1');
		var isStep2 = component.get('v.isStep2');
		var isStep3 = component.get('v.isStep3');

		let buttonAdd = component.find('disablebuttonid');
		let buttonRemove = component.find('disablebuttonhide');

		if (isStep3 == true) {
			component.set('v.isStep3', false);
			buttonAdd.set('v.disabled', false);
			component.find('Can_go_wrong6__c').set('v.value', '');
			component.find('Cause6__c').set('v.value', '');
			component.find('Prevent6__c').set('v.value', '');
		} else {
			if (isStep2 == true) {
				component.set('v.isStep2', false);
				buttonAdd.set('v.disabled', false);
				component.find('Can_go_wrong5__c').set('v.value', '');
				component.find('Cause5__c').set('v.value', '');
				component.find('Prevent5__c').set('v.value', '');
			} else {
				if (isStep1 == true) {
					component.set('v.isStep1', false);
					buttonAdd.set('v.disabled', false);
					buttonRemove.set('v.disabled', true);
					component.find('Can_go_wrong4__c').set('v.value', '');
					component.find('Cause4__c').set('v.value', '');
					component.find('Prevent4__c').set('v.value', '');
				}
			}
		}
	}
});