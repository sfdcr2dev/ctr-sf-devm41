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
	
	handleError: function (component, event, helper) {
		//alert('Error')
		helper.makeToast('error', 'Error', 'Cannot Create Work Clearance');

		var error = event.getParam("error")
		console.log(JSON.parse(JSON.stringify(error)));

		console.log(error.message); // main error message

		// top level error messages
		error.data.output.errors.forEach(
			function (msg) {
				console.log(msg.errorCode);
				console.log(msg.message);
			}
		);

		// field specific error messages
		Object.keys(error.data.output.fieldErrors).forEach(
			function (field) {
				error.data.output.fieldErrors[field].forEach(
					function (msg) {
						console.log(msg.fieldName);
						console.log(msg.errorCode)
						console.log(msg.message)
					}
				)
			})
	},

	handleExtendDateChanged: function (component, event, helper) {
		let cmp = component.find('Extend_Date__c');
		let cmpReqestExtendTime = component.find('Request_Extend_Date__c');
		cmpReqestExtendTime.set('v.value', cmp.get('v.value'));
	},

	handleExtendTimeChanged: function (component, event, helper) {
		let cmp = component.find('Extend_Time__c');
		let extendTime = event.currentTarget.value;
		cmp.set('v.value', extendTime);

		let cmpReqestExtendTime = component.find('Request_Extend_Time__c');
		cmpReqestExtendTime.set('v.value', extendTime);
	},

	handleExtendTimeFlagCheckBoxChange: function (component, event, helper) {
		console.log('test');
		//let value = event.getParams() ? event.getParams().value : '';
		let { value } = event.getParams();
		let flag = value[0] ? value[0] : '';
		//component.find('Extend_Time_Flag__c').set('v.value', flag);
		component.set('v.canSubmit', flag);
		//component.find('Extend_No__c').set('v.value', '01');
	},

	handleFLSelected: function (component, event, helper) {
	},

	handleLoad: function (component, event, helper) {
		console.log(component.find('Extend_No__c').get('v.value'))
		let cmpExtendNo = component.find('Extend_No__c')
		let extendNo = cmpExtendNo.get('v.value')
		let extNo = 0;
		if (!isNaN(Number(extendNo))) {
			extendNo = extNo = Number(extendNo) + 1;
			extendNo = ("00" + String(extendNo)).slice(-2);
			cmpExtendNo.set('v.value', extendNo);
		}

		var recordUi = event.getParam('recordUi');
		var userStatus = recordUi.record.fields.User_Status__c ? recordUi.record.fields.User_Status__c.value : '';
		if (!(String(userStatus).indexOf("EXTH") > -1)) {
			component.set("v.form.User_Status__c", userStatus + " EXTH");
		}
		component.set("v.form.Last_User_Action__c", "EXOT");
//		if (extNo > 1) {
//			component.set("v.form.Last_User_Action__c", "EXOT2");
//		}

		var extendDateTemp = recordUi.record.fields.Extend_Date__c.value ? recordUi.record.fields.Extend_Date__c.value : '';
		var extendTimeTemp = recordUi.record.fields.Extend_Time__c.value ? recordUi.record.fields.Extend_Time__c.value : '';

		component.set('v.extendDateTemp', extendDateTemp);
		component.set('v.extendTimeTemp', extendTimeTemp);

		let cmpExtendDate = component.find('Extend_Date__c')
		var todayDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		cmpExtendDate.set('v.value', todayDate)

		let cmpRequestExtendDate = component.find('Request_Extend_Date__c')
		cmpRequestExtendDate.set('v.value', todayDate)

		let cmpExtendTime = component.find('Extend_Time__c')
		var todayTime = $A.localizationService.formatDate(new Date(), "HH:mm:ss");
		cmpExtendTime.set('v.value', todayTime)

		let cmpRequestExtendTime = component.find('Request_Extend_Time__c')
		cmpRequestExtendTime.set('v.value', todayTime)

		//let cmpExtendTimeUI = component.find('Extend_Time_UI__c');
		//cmpExtendTimeUI.set('v.value', todayTime)

		component.set("v.extendTimeUI", todayTime)
	},

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

		var extendDateTemp = component.get('v.extendDateTemp');
		var extendTimeTemp = component.get('v.extendTimeTemp');
		var extendDateTimeTemp = new Date(extendDateTemp + 'T' + extendTimeTemp.replace('Z', '+07:00'));
		var extendDate = component.find('Extend_Date__c').get('v.value');
		var extendTime = component.find('Extend_Time__c').get('v.value');
		var extendDateTime = new Date(component.find('Extend_Date__c').get('v.value') + 'T' + component.find('Extend_Time__c').get('v.value') + '.000+07:00');
		var today = new Date();
		if (today > extendDateTime) {
			helper.makeToast('error', 'Error', 'Extend Date must greater than ' + $A.localizationService.formatDate(today, "dd/MM/yyyy HH:mm:ss"));
			event.preventDefault();
			return;
		}
		if (!isNaN(extendDateTimeTemp) && $A.localizationService.formatDate(extendDateTime, "yyyyMMdd") <= $A.localizationService.formatDate(extendDateTimeTemp, "yyyyMMdd")) {
			helper.makeToast('error', 'Error', 'Extend Date must greater than ' + $A.localizationService.formatDate(extendDateTimeTemp, "dd/MM/yyyy HH:mm:ss"));
			event.preventDefault();
			return;
		}
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
		if (event.getParam('modal') === 'THOR_WorkClearanceExtendDayModal') {
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