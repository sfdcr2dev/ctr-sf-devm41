({
	closeModal: function (component, event, helper) {},

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
                
    handleChange: function (component, event, helper) {
        var params = event.getParams();
        component.set(`v.form.${params.fieldName}`, params.value);
        //if(params.fieldName === 'Requester_PISUser__c') {
        //	$A.enqueueAction(component.get('c.handlePISUser'));
        //}
    },

	handleError: function (component, event, helper) {
		//alert('Error')
		helper.makeToast('error', 'Error', 'Cannot Create Work Clearance');

		var error = event.getParam('error');

		console.log(JSON.parse(JSON.stringify(error)));

		console.log('Errormsg');
		console.log(error.message); // main error message

		// top level error messages
		error.data.output.errors.forEach(function (msg) {
			console.log(msg.errorCode);
			console.log(msg.message);
		});

		// field specific error messages
		Object.keys(error.data.output.fieldErrors).forEach(function (field) {
			error.data.output.fieldErrors[field].forEach(function (msg) {
				console.log(msg.fieldName);
				console.log(msg.errorCode);
				console.log(msg.message);
			});
		});
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

	handleFunctionalLocationChanged: function (component, event, helper) {
		helper.getFunctionalLocationDetailById(component, event, helper);
	},

	handleLoad: function (component, event, helper) {
		helper.stopLoading(component);

		if (!component.get('v.isInitLoaded')) {
			var recordUi = event.getParam('recordUi');
			const {
				objectInfo: { fields },
				record
			} = recordUi;

			component.set('v.objectInfoFields', fields);
			component.set('v.recordInfo', record.fields);

			// console.log(JSON.parse(JSON.stringify(component.set('v.recordInfo'))));

			component.set('v.userStatusTemp', component.get('v.recordInfo.User_Status__c.value'));
			[
				'Priority__c',
				'High_Risk_Work__c',
				'FunctionalLocation__c',
				'Requester_UI__c',
				'Thaioil_Supervisor_Indicator_UI__c',
				'Applicant_or_Bearer_UI__c',
				'Bearer1_UI__c',
				'Bearer2_UI__c',
				'Bearer3_UI__c',
				'Bearer4_UI__c',
				'Safety_Permit1_UI__c',
				'Safety_Permit2_UI__c',
				'Safety_Permit3_UI__c',
                'Can_go_wrong4__c',
                'Cause4__c',
                'Prevent4__c',
                'Can_go_wrong5__c',
                'Cause5__c',
                'Prevent5__c',
                'Can_go_wrong6__c',
                'Cause6__c',
                'Prevent6__c'
			].forEach((fieldName) => {
				component.set(`v.form.${fieldName}`, component.get(`v.recordInfo.${fieldName}.value`));
			});

            if (component.get('v.form.Can_go_wrong4__c')) {
                component.set('v.isStep1', true);
            }
            if (component.get('v.form.Can_go_wrong5__c')) {
                let buttonRemove = component.find('disablebuttonhide');
                component.set('v.isStep1', true);
                component.set('v.isStep2', true);
                buttonRemove.set('v.disabled',false);
            }
            if (component.get('v.form.Can_go_wrong6__c')) {
                let buttonAdd = component.find('disablebuttonid');
                let buttonRemove = component.find('disablebuttonhide');
                component.set('v.isStep1', true);
                component.set('v.isStep2', true);
                component.set('v.isStep3', true);
                buttonAdd.set('v.disabled',true);
                buttonRemove.set('v.disabled',false);
            }
			/**
			var priority = recordUi.record.fields.Priority__c.value;
			component.set('v.form.Priority__c', priority);

			var fl = recordUi.record.fields.FunctionalLocation__c.value;
			component.set('v.form.FunctionalLocation__c', fl);

			var requester = recordUi.record.fields.Requester_UI__c.value;
			component.set('v.form.Requester_UI__c', requester);

			var supervisor = recordUi.record.fields.Thaioil_Supervisor_Indicator_UI__c.value;
			component.set('v.form.Thaioil_Supervisor_Indicator_UI__c', supervisor);
			// component.set('v.form.Requester_UI__c', requester);

			var applicant = recordUi.record.fields.Applicant_or_Bearer_UI__c.value;
			component.set('v.form.Applicant_or_Bearer_UI__c', applicant);

			var bearer1 = recordUi.record.fields.Bearer1_UI__c.value;
			component.set('v.form.Bearer1_UI__c', bearer1);

			var bearer2 = recordUi.record.fields.Bearer2_UI__c.value;
			component.set('v.form.Bearer2_UI__c', bearer2);

			var bearer3 = recordUi.record.fields.Bearer3_UI__c.value;
			component.set('v.form.Bearer3_UI__c', bearer3);

			var bearer4 = recordUi.record.fields.Bearer4_UI__c.value;
			component.set('v.form.Bearer4_UI__c', bearer4);

			var safetypermit1 = recordUi.record.fields.Safety_Permit1_UI__c.value;
			component.set('v.form.Safety_Permit1_UI__c', safetypermit1);

			var safetypermit2 = recordUi.record.fields.Safety_Permit2_UI__c.value;
			component.set('v.form.Safety_Permit2_UI__c', safetypermit2);

			var safetypermit3 = recordUi.record.fields.Safety_Permit3_UI__c.value;
			component.set('v.form.Safety_Permit3_UI__c', safetypermit3);
       */

			//			var lastUserAction = recordUi.record.fields.Last_User_Action__c.value;
			//			var integrationStatus = recordUi.record.fields.Integration_Status__c.value;
			//			component.set('v.form.Last_User_Action__c', 'EXTD');
			//			if (lastUserAction == 'CRTE' && integrationStatus == 'Failed') {
			//				component.set('v.form.Last_User_Action__c', 'CRTE');
			//			}

			// When Creation Fail Last Action Be Created
			// Else Append EXTD
			var lastUserAction = recordUi.record.fields.Last_User_Action__c
				? recordUi.record.fields.Last_User_Action__c.value
				: '';
			var integrationStatus = recordUi.record.fields.Integration_Status__c
				? recordUi.record.fields.Integration_Status__c.value
				: '';
			if (lastUserAction) {
				if (lastUserAction.indexOf('CRTE') > -1 && integrationStatus == 'Failed') {
					component.set('v.form.Last_User_Action__c', 'CRTE');
				} else {
					component.set('v.form.Last_User_Action__c', lastUserAction + ' EXTD');
				}
			}

			component.set('v.isInitLoaded', true);
		}
	},

	handleNotificationChanged: function (component, event, helper) {
		helper.getNotificationDetailById(component, event, helper);
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
		//		event.preventDefault(); // stop the form from submitting

		//		var userStatus = component.get('v.userStatusTemp');
		//
		//		var fields = event.getParam('fields');
		//		fields['User_Status__c'] = userStatus;
		//		component.set('v.userStatus', userStatus);
		//		component.set('v.userStatusTemp', '');
		//		component.find('editOrderForm').submit(fields);
		//var fields = event.getParam('fields')
		//component.find('editWorkClearanceForm').submit(fields);

		event.preventDefault(); // stop the form from submitting
		//component.set('v.isLoading', true);

		let action = component.get('c.getUserName');
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let userName = response.getReturnValue();

				var oldWorkDetail = component.get('v.oldWorkDetail');
				var newWorkDetail = component.get('v.newWorkDetail');

				var workDetail = '';

				if (oldWorkDetail != null) {
					workDetail = oldWorkDetail;
				}

				if (newWorkDetail != '') {
					if (!workDetail.includes('*')) {
						if (workDetail != '') {
							workDetail += '\n\n* ' + userName + ': ';
						} else {
							workDetail = '* ' + userName + ': ';
						}
					} else {
						workDetail = workDetail.replace('* ', '') + '\n\n* ' + userName + ': ';
					}

					workDetail = workDetail + newWorkDetail;
				}
				var userStatus = component.get('v.userStatusTemp');

				var fields = event.getParam('fields');
				fields['Work_Detail__c'] = workDetail;
				fields['User_Status__c'] = userStatus;
				component.find('editWorkClearanceForm').submit(fields);
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

	handleSuccess: function (component, event, helper) {
		helper.makeToast('success', 'Success', 'Work Clearance have been saved successfully');
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
		if (event.getParam('modal') === 'THOR_WorkClearanceEditModal') {
			component.set('v.showModal', 'true');
		}
	},
	showRow: function(component, event, helper) {
		//alert(JSON.stringify(component.get("v.isStep1")));
		var isStep1 = component.get("v.isStep1");
		var isStep2 = component.get("v.isStep2");
		var isStep3 = component.get("v.isStep3");

		let buttonAdd = component.find('disablebuttonid');
    	let buttonRemove = component.find('disablebuttonhide');
		
        if(isStep1 == false){
			component.set("v.isStep1", true);
			buttonRemove.set('v.disabled',false);

		}
		else{
            if (isStep2 == false){
                component.set("v.isStep2", true);
				
            }
            else{
                if (isStep3 == false){
                    component.set("v.isStep3", true);
					buttonAdd.set('v.disabled',true);
					
                }
            }
        }
    },
	hideRow: function(component, event, helper) {
		//alert(JSON.stringify(component.get("v.isStep1")));
        var isStep1 = component.get("v.isStep1");
		var isStep2 = component.get("v.isStep2");
		var isStep3 = component.get("v.isStep3");

		let buttonAdd = component.find('disablebuttonid');
    	let buttonRemove = component.find('disablebuttonhide');
    	
		if (isStep3 == true){
            component.set("v.isStep3", false);
			buttonAdd.set('v.disabled',false);
            component.find('Can_go_wrong6__c').set('v.value', '');
            component.find('Cause6__c').set('v.value', '');
            component.find('Prevent6__c').set('v.value', '');
		}
		else{
            if (isStep2 == true){
				component.set("v.isStep2", false);
				buttonAdd.set('v.disabled',false);
                component.find('Can_go_wrong5__c').set('v.value', '');
                component.find('Cause5__c').set('v.value', '');
                component.find('Prevent5__c').set('v.value', '');
            }
            else{
                if (isStep1 == true){
                    component.set("v.isStep1", false);
					buttonAdd.set('v.disabled',false);
					buttonRemove.set('v.disabled',true);
                    component.find('Can_go_wrong4__c').set('v.value', '');
                    component.find('Cause4__c').set('v.value', '');
                    component.find('Prevent4__c').set('v.value', '');
                }
            }
        }
	},

	submitRecordEditFrom: function (component, event, helper) {
		component.find('utilityLwcButton').submit_click();
	},

	yesConfirmCancelEdit: function (component, event, helper) {
		component.set('v.showCancelConfirmModal', 'false');
		component.set('v.showModal', 'false');
		component.set('v.userStatusTemp', '');
        
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
	}
});