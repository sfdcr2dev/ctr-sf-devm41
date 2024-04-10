({
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

	doRender: function (component, event, helper) {
		var userStatusTemp = component.get('v.userStatusTemp');
		if (!userStatusTemp) {
			var userStatus = component.get('v.userStatus');
			if (userStatus) {
				component.set('v.userStatusTemp', userStatus);
			}
		}
	},

	handleFLSelected: function (component, event, helper) {
	},

//	handleLoad: function (component, event, helper) {
//		
//		let cmpExtendNo = component.find('Extend_No__c')
//		let extendNo = cmpExtendNo.get('v.value')
//		let extNo = 0;
//		if (!isNaN(Number(extendNo))) {
//			extendNo = extNo = Number(extendNo) + 1;
//		}
//		
//		var recordUi = event.getParam('recordUi');
//		var userStatus = recordUi.record.fields.User_Status__c.value;
//		if (!(String(userStatus).indexOf("EXTH") > -1)) {
//			component.set("v.form.User_Status__c", userStatus + " EXTH");
//		}
//		component.set("v.form.Last_User_Action__c", "EXTH");
//		if (extNo > 1) {
//			component.set("v.form.Last_User_Action__c", "EXTH");
//		}
//	},

	handleSubmit: function (component, event, helper) {
		//		event.preventDefault(); // stop the form from submitting
		//
		//		var userStatus = component.get('v.userStatusTemp');
		//
		//		var fields = event.getParam('fields');
		//		fields['User_Status__c'] = userStatus;
		//		component.set('v.userStatus', userStatus);
		//		component.set('v.userStatusTemp', '');
		//		component.find('editOrderForm').submit(fields);
	},

	handleSuccess: function (component, event, helper) {
		helper.makeToast('success', 'Success', 'Changes have been saved successfully');
		component.set('v.showModal', 'false');

		var recordSavedEvent = component.getEvent('recordSavedEvent');
		recordSavedEvent.setParams({
			target: 'recordSaved'
		});
		recordSavedEvent.fire();

		//$A.get('e.force:refreshView').fire();

		var recordId = component.get("v.recordId");
		var navService = component.find("navService");

		navService.navigate({
			type: "standard__webPage",
			attributes: {
				url: `/one/one.app#${btoa(JSON.stringify({
					componentDef: `c:THOR_WorkClearanceRecordDisplay`,
					attributes: {
						recordId: recordId,
						uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
							let r = Math.random() * 16 | 0,
								v = c == 'x' ? r : (r & 0x3 | 0x8);
							return v.toString(16);
						})
					}
				}))}`
			}
		}, false);
	},

	handleError: function (component, event, helper) {
		helper.makeToast('error', 'Error', 'Cannot Save Work Clearance');

		var error = event.getParam("error")
		console.log(JSON.parse(JSON.stringify(error)));
	},

	handleExtendTimeToChanged: function (component, event, helper) {
		let cmp = component.find('Extend_Time_To_UI__c');
		let extendTimeTo = event.currentTarget.value;
		cmp.set('v.value', extendTimeTo);
	},
	
	handleFocus: function (component, event, helper) {
		event.stopPropagation();
		event.preventDefault();
		var fieldName = event.getSource().get('v.name');

		component.set(`v.isToggleSubModal.${fieldName}`, !component.get(`v.isToggleSubModal.${fieldName}`));
		switch (fieldName) {
			case 'Thaioil_Supervisor_Indicator_UI__c':
			case 'Extend_Applicant_or_Bearer_UI__c':
				helper.getPISRequester(component, '', fieldName);
				break;
			case 'Applicant_or_Bearer_UI__c':
			case 'Close_Applicant_or_Bearer_UI__c':
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

		let cmpExtendNo = component.find('Extend_No__c')
		let extendNo = cmpExtendNo.get('v.value')
		let extNo = 0;
		if (!isNaN(Number(extendNo))) {
			extendNo = extNo = Number(extendNo) + 1;
		}

		var recordUi = event.getParam('recordUi');
		var userStatus = recordUi.record.fields.User_Status__c ? recordUi.record.fields.User_Status__c.value : '';
//		if (!(String(userStatus).indexOf("EXTH") > -1)) {
//			component.set("v.form.User_Status__c", userStatus + " EXTH");
//		}
		component.set("v.form.Last_User_Action__c", "EXTH");
		if (extNo > 1) {
			component.set("v.form.Last_User_Action__c", "EXOT2");
		}

		//let cmp = component.find('Extend_Time_To_UI__c');
		//cmp.set('v.value', '00:00:00');
	},

	handleChange: function (component, event, helper) {
        var params = event.getParams();
        component.set(`v.form.${params.fieldName}`, params.value);
        //if(params.fieldName === 'Requester_PISUser__c') {
        //	$A.enqueueAction(component.get('c.handlePISUser'));
        //}
    },
	
	handleSearch: function (component, event, helper) {
		var targetInput = event.getSource();
		const fieldName = targetInput.get('v.name');
		const value = targetInput.get('v.value');

		if (fieldName === 'Thaioil_Supervisor_Indicator_UI__c'
			|| fieldName === 'Extend_Applicant_or_Bearer_UI__c')
		{
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
			fieldName === 'Applicant_or_Bearer_UI__c'
			|| fieldName === 'Close_Applicant_or_Bearer_UI__c'
			|| fieldName === 'Bearer1_UI__c'
			|| fieldName === 'Bearer2_UI__c'
			|| fieldName === 'Bearer3_UI__c'
			|| fieldName === 'Bearer4_UI__c'
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
			fieldName === 'Safety_Permit1_UI__c'
			|| fieldName === 'Safety_Permit2_UI__c'
			|| fieldName === 'Safety_Permit3_UI__c'
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

	hideModal: function (component, event) {
		component.set('v.showModal', 'false');
	},

	noConfirmCancelEdit: function (component, event) {
		component.set('v.showCancelConfirmModal', 'false');
	},

	openConfimCancelModal: function (component, event) {
		component.set('v.showCancelConfirmModal', 'true');
	},

	selectUserStatus: function (component, event, helper) {
		component.set('v.setUserStatus', true);
	},

	showModal: function (component, event, helper) {
		if (event.getParam('modal') === 'THOR_WorkClearanceExtendHoursModal') {
			component.set('v.showModal', true);
		}
	},

	submitRecordEditFrom: function (component, event, helper) {
		component.find('utilityLwcButton').submit_click();
	},

	yesConfirmCancelEdit: function (component, event, helper) {
		//component.set('v.showCancelConfirmModal', 'false');
		//component.set('v.showModal', 'false');
		//component.set('v.userStatusTemp', '');

		var recordId = component.get("v.recordId");
		var navService = component.find("navService");

		navService.navigate({
			type: "standard__webPage",
			attributes: {
				url: `/one/one.app#${btoa(JSON.stringify({
					componentDef: `c:THOR_WorkClearanceRecordDisplay`,
					attributes: {
						recordId: recordId,
						uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
							let r = Math.random() * 16 | 0,
								v = c == 'x' ? r : (r & 0x3 | 0x8);
							return v.toString(16);
						})
					}
				}))}`
			}
		}, false);
	},
})