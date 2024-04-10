({
	handlerPreventEnter: function (component, isActive) {
		var preventEnter = $A.getCallback((event) => {
			event.preventDefault();
			if (event.keyCode === 13) {
				component.set('v.pressKey.enter', true);
			}
		});

		if (isActive) {
			window.addEventListener('keyup', preventEnter);
		} else {
			window.removeEventListener('keyup', preventEnter);
		}
	},
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},
	startLoading: function (component) {
		component.set('v.isLoading', true);
	},
	stopLoading: function (component) {
		component.set('v.isLoading', false);
	},
	disabledFieldsCheckingGas: function (component, checked) {
		const wcStageApprove = component.get('v.wcStageApprove');
		const wcOrderApprover = component.get('v.wcOrderApprover');
		
		component
			.find('inputField')
			.filter((f) =>
				[
					'Flamable_amt__c',
					'Oxygen_amt__c',
					'Toxic_Type__c',
					'Toxic_PPM__c',
					'AGT__c',
                    'AGT_UI__c',
					'Check_Date_UI__c',
					'Check_Time_UI__c',
					'Extend_Time_To_UI__c',
					'Extend_Applicant_or_Bearer_UI__c',
					'Extend_Authorized_Sign_UI__c'
				].includes(f.get('v.fieldName'))
			)
			.forEach((inputField) => {
				//inputField.set('v.disabled', (checked || wcStageApprove == 'Approve return work clearance' || wcStageApprove == 'Approve extend from normal hours' || wcStageApprove == 'Approve close work clearance'));
				inputField.set('v.disabled', (checked || wcOrderApprover == '3rdApprove'));
				if (checked) {
					inputField.set('v.value', null);
				}
			});
	},
	calculateWcStage: function (component) {
		const stageTemplate = {
			1: 'Approve work clearance (PREP)',
			2: 'Approve extend from normal hours',
			3: 'Approve return work clearance',
			4: 'Approve extend next day',
			5: 'Approve close work clearance'
		};

		let wcstage = null;
		if (
			component.get('v.wcDisplay.System_Status__c').includes('PREP') &&
			// component.get('v.wcDisplay.System_Status__c').includes('CLSD') &&
			component.get('v.wcDisplay.User_Status__c') &&
			component.get('v.wcDisplay.User_Status__c').includes('WCCL') &&
			component.get('v.wcDisplay.Close_Applicant_or_Bearer_UI__c') &&
			!component.get('v.wcDisplay.Close_Authorized_Sign_off_UI__c')
		) {
			wcstage = stageTemplate[5];
		} else if (
			component.get('v.wcDisplay.System_Status__c') === 'PREP' &&
			component.get('v.wcDisplay.User_Status__c') &&
			component.get('v.wcDisplay.User_Status__c').includes('EXTD') &&
			//!component.get('v.wcDisplay.User_Status__c').includes('WIP1') &&
			component.get('v.wcDisplay.Authorized_Signature_UI__c') &&
			!component.get('v.wcDisplay.Authorized_Signatory_UI__c') &&
			component.get('v.wcDisplay.Extend_No__c') &&
			Number(component.get('v.wcDisplay.Extend_No__c')) > 0
		) {
			wcstage = stageTemplate[4];
		} else if (
			component.get('v.wcDisplay.System_Status__c') === 'PREP' &&
			component.get('v.wcDisplay.User_Status__c') &&
			component.get('v.wcDisplay.User_Status__c').includes('WIP1') &&
			component.get('v.wcDisplay.Close_Applicant_or_Bearer_UI__c') &&
			!component.get('v.wcDisplay.Close_Authorized_Sign_off_UI__c')
		) {
			wcstage = stageTemplate[3];
		} else if (
			component.get('v.wcDisplay.System_Status__c') === 'PREP' &&
			//component.get('v.wcDisplay.User_Status__c') &&
			//component.get('v.wcDisplay.User_Status__c').includes('EXTH') &&
			component.get('v.wcDisplay.Extend_Applicant_or_Bearer_UI__c') &&
			!component.get('v.wcDisplay.Extend_Authorized_Sign_UI__c')
		) {
			wcstage = stageTemplate[2];
		} else if (
			component.get('v.wcDisplay.System_Status__c') === 'CRTE' &&
			!component.get('v.wcDisplay.Authorized_Signature_UI__c') &&
			!component.get('v.wcDisplay.Authorized_Signatory_UI__c')
		) {
			wcstage = stageTemplate[1];
		}

		if (!wcstage) {
			console.warn(`${component.get('v.wcDisplay.Work_Clearance__c')} is not a valid Work Clearance Stage`);
		}
		component.set('v.wcStageApprove', wcstage);
		component.set(
			'v.wcOrderApprover',
			{
				'Approve work clearance (PREP)': '1stApprove',
				'Approve extend from normal hours': '2ndApprove',
				'Approve return work clearance': '3rdApprove',
				'Approve extend next day': '1stApprove',
				'Approve close work clearance': '3rdApprove'
			}[wcstage]
		);
		console.log(component.get('v.wcOrderApprover'));
		return wcstage;
	},
    toggleBlockValvRemark: function(component, event, helper) {
		let wcRecordUi = component.get('v.wcRecordUi');
		let Block_Valv__c = component
			.find('inputField')
			.find((f) => f.get('v.fieldName') === 'Block_Valv__c')
			.get('v.value');
		if (Block_Valv__c) {
			component.set('v.isBlockValv', true);
			let cmp = component
				.find('inputField')
				.find((f) => f.get('v.fieldName') === 'Block_Valv_Remark__c');
			if (cmp && wcRecordUi && wcRecordUi.record && (!wcRecordUi.record.fields.Block_Valv_Remark__c || !wcRecordUi.record.fields.Block_Valv_Remark__c.value)) {
				cmp.set('v.value', 'Work Pack');
			}
		} else {
			component.set('v.isBlockValv', false)
		}
    },
	validateRequireFields: function(component, event, helper) {
		const wcStageApprove = component.get('v.wcStageApprove');
		const cmp = component.find('inputField');
		if (wcStageApprove == 'Approve work clearance (PREP)') {
			let Authorized_Signature_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Authorized_Signature_UI__c').get('v.value');
			let Authorized_Signatory_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Authorized_Signatory_UI__c').get('v.value');
			let Authorized_Date_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Authorized_Date_UI__c').get('v.value');
			let Authorized_Time_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Authorized_Time_UI__c').get('v.value');
			let Can_go_wrong1__c = cmp.find((f) => f.get('v.fieldName') === 'Can_go_wrong1__c').get('v.value');
			let Cause1__c = cmp.find((f) => f.get('v.fieldName') === 'Cause1__c').get('v.value');
			let Prevent1__c = cmp.find((f) => f.get('v.fieldName') === 'Prevent1__c').get('v.value');

			component.set('v.isValid', Boolean(
				Authorized_Signature_UI__c &&
				Authorized_Signatory_UI__c &&
				Authorized_Date_UI__c &&
				Authorized_Time_UI__c &&
				Can_go_wrong1__c &&
				Cause1__c &&
				Prevent1__c
			));
		} else if (wcStageApprove == 'Approve extend from normal hours') {
			let Extend_Authorized_Sign_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Extend_Authorized_Sign_UI__c').get('v.value');
			component.set('v.isValid', Boolean(Extend_Authorized_Sign_UI__c));
		} else if (wcStageApprove == 'Approve return work clearance') {
			let Close_Authorized_Sign_off_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Close_Authorized_Sign_off_UI__c').get('v.value');
			component.set('v.isValid', Boolean(Close_Authorized_Sign_off_UI__c));
		} else if (wcStageApprove == 'Approve extend next day') {
			let Authorized_Signature_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Authorized_Signature_UI__c').get('v.value');
			let Authorized_Signatory_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Authorized_Signatory_UI__c').get('v.value');
			let Authorized_Date_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Authorized_Date_UI__c').get('v.value');
			let Authorized_Time_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Authorized_Time_UI__c').get('v.value');
			let Can_go_wrong1__c = cmp.find((f) => f.get('v.fieldName') === 'Can_go_wrong1__c').get('v.value');
			let Cause1__c = cmp.find((f) => f.get('v.fieldName') === 'Cause1__c').get('v.value');
			let Prevent1__c = cmp.find((f) => f.get('v.fieldName') === 'Prevent1__c').get('v.value');

			component.set('v.isValid', Boolean(
				Authorized_Signature_UI__c &&
				Authorized_Signatory_UI__c &&
				Authorized_Date_UI__c &&
				Authorized_Time_UI__c &&
				Can_go_wrong1__c &&
				Cause1__c &&
				Prevent1__c
			));
		} else if (wcStageApprove == 'Approve close work clearance') {
			let Close_Authorized_Sign_off_UI__c = cmp.find((f) => f.get('v.fieldName') === 'Close_Authorized_Sign_off_UI__c').get('v.value');
			component.set('v.isValid', Boolean(Close_Authorized_Sign_off_UI__c));
		} else {
			component.set('v.isValid', true);
		}
	},
});