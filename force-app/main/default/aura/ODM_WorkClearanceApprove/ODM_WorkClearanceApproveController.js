({
	doInit: function (component, event, helper) {
		// Default fields 3-What's analysis (6)
		for (var indexVar = 2; indexVar <= 6; indexVar++) {
			component.set('v.threeWhatOptionsList', [
				...component.get('v.threeWhatOptionsList'),
				{
					indexVar: indexVar,
					Can_go_wrong: {
						fieldName: `Can_go_wrong${indexVar}__c`
					},
					Cause: {
						fieldName: `Cause${indexVar}__c`
					},
					Prevent: {
						fieldName: `Prevent${indexVar}__c`
					}
				}
			]);
		}
	},
	handleAddRemove: function (component, event, helper) {
		const targetName = event.getSource().get('v.name');
		// console.log({ targetName });
		var indexVar = component.get('v.threeWhatOptionsList.length') + 2;
		if (targetName === 'add' && indexVar <= 6) {
			component.set('v.threeWhatOptionsList', [
				...component.get('v.threeWhatOptionsList'),
				{
					indexVar: indexVar,
					Can_go_wrong: {
						fieldName: `Can_go_wrong${indexVar}__c`
					},
					Cause: {
						fieldName: `Cause${indexVar}__c`
					},
					Prevent: {
						fieldName: `Prevent${indexVar}__c`
					}
				}
			]);
		} else if (targetName === 'remove' && indexVar > 2) {
			component.get('v.threeWhatOptionsList').splice(indexVar - 3, 1);
			component.set('v.threeWhatOptionsList', component.get('v.threeWhatOptionsList'));
		}
	},
	handleCheckingGas: function (component, event, helper) {
		const target = event.getSource();
		const checked = target.get('v.value');

		component.set('v.isCheckingGas', checked);
		helper.disabledFieldsCheckingGas(component, component.get('v.isCheckingGas'));
	},
	handleChecked: function (component, event, helper) {
		const target = event.getSource();
		const fieldName = target.get('v.name');
		const checked = target.get('v.checked');
		// console.log({ [fieldName]: checked });

		try {
			component
				.find('inputField')
				.find((f) => f.get('v.fieldName') === fieldName)
				.set('v.value', checked ? 'X' : null);
			
			helper.toggleBlockValvRemark(component, event, helper);
		} catch (error) {
			console.error(error);
		}
	},
	handleChange: function (component, event, helper) {
		const { fieldName, value } = event.getParams();
		component.set(`v.form.${fieldName}`, value);
		// console.log({ [fieldName]: value });
		// console.log(helper.parseObject(component.get('v.form')));
		try {
			component
				.find('inputField')
				.find((f) => f.get('v.fieldName') === fieldName)
				.set('v.value', value);
			
			helper.toggleBlockValvRemark(component, event, helper);
			helper.validateRequireFields(component, event, helper);
		} catch (error) {
			console.error(error);
		}
	},
	handleSectiontoggle: function (component, event, helper) {
		const params = event.getParams();
		const selectedList = params.openSections;
		const wcStageApprove = component.get('v.wcStageApprove');
		// console.log(selectedList);
		if (
			selectedList.includes('C') &&
			(
				component
					.find('inputField')
					.find((f) => f.get('v.fieldName') === 'IsCheckingGas__c')
					.get('v.value') ||
				wcStageApprove == 'Approve return work clearance' ||
				wcStageApprove == 'Approve extend from normal hours' ||
				wcStageApprove == 'Approve close work clearance'
			)
		) {
			window.setTimeout(
				$A.getCallback(() => {
					helper.disabledFieldsCheckingGas(component, component.get('v.form.IsCheckingGas__c'));
					component.find('btnCancel').focus();
				}),
				500
			);
		}
		if (selectedList.includes('B')) {
			helper.toggleBlockValvRemark(component, event, helper);
		}
	},
	handleCancel: function (component, event, helper) {
		component.find('navService').navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__ODM_WorkClearanceRecordDisplay'
				},
				state: {
					c__recordId: component.get('v.recordId')
				}
			},
			true
		);
	},
	handleSubmitBtn: function (component, event, helper) {
		component.set('v.pressKey', {
			enter: false,
			click: true
		});
		component.set(
			'v.activeSections',
			component.find('accordionSection').map((cmp) => cmp.get('v.name'))
		);
		window.setTimeout(
			$A.getCallback(() => {
				component.find('utilityLwcButton').submit_click();
			}),
			300
		);
	},
	handleError: function (component, event, helper) {
		helper.stopLoading(component);
		var error = event.getParam('error');
		console.error(helper.parseObject(error));
	},
	handleLoad: function (component, event, helper) {
		if (component.get('v.isInitialized')) return;

		const recordUi = event.getParam('recordUi');
		component.set('v.recordUi', recordUi);
		component.set('v.wcRecordUi', recordUi);
		// console.log(helper.parseObject(component.get('v.recordUi')));

		// 1. Checking work clearance statge
		helper.calculateWcStage(component);

		// 2. Defualt value on custom thorSuggestFilterLookup
		[
			'Authorized_Signature_UI__c',
			'Safety_Permit1_UI__c',
			'Safety_Permit2_UI__c',
			'Safety_Permit3_UI__c',
			'AGT_UI__c',
			'Authorized_Signatory_UI__c',
			'Extend_Authorized_Sign_UI__c',
			'Close_Authorized_Sign_off_UI__c',
			'Reduce_Pressure__c',
			'Block_gas__c',
			'Block_Valv__c',
			'Spade_off__c',
			'Ventilation__c',
			'Stop_machine__c',
			'Tag_Out__c',
			'Isolate_Elec__c',
			'Isolate_Breaker__c',
			'Lock_off_RCU__c',
			'Operation_Stand_by__c',
			'Fire_Watch_Stand_By__c',
			'IsCheckingGas__c'
		].forEach((fieldName) => {
			component.set(`v.form.${fieldName}`, component.get(`v.recordUi.record.fields.${fieldName}.value`));
		});
		// console.log(helper.parseObject(component.get('v.form')));
		try {
			component.find('inputCheckbox').forEach((inputCheckbox) => {
				inputCheckbox.set('v.checked', component.get(`v.form.${inputCheckbox.get('v.name')}`) === 'X');
			});
		} catch (error) {
			console.error(error);
		}
            
        component.set('v.isCheckingGas', component.get(`v.recordUi.record.fields.IsCheckingGas__c.value`));

		// 3 Assign recordUi to object field properties
		component.set('v.recordUi', component.get('v.recordUi.objectInfo.fields'));

		// 4 Default values for properties [Authorized_Date_UI__c, Authorized_Time_UI__c]
		try {
			component
				.find('inputField')
				.find((f) => f.get('v.fieldName') === 'Authorized_Date_UI__c')
				.set('v.value', $A.localizationService.formatDate(new Date(), 'YYYY-MM-DD'));
			component
				.find('inputField')
				.find((f) => f.get('v.fieldName') === 'Authorized_Time_UI__c')
				.set('v.value', $A.localizationService.formatTime(new Date()));
		} catch (error) {
			console.error('Can not assign default value when work clerance is not "Approve work clearance (PREP)"');
			console.error(error);
		}

		//if (!component.get('v.isInitialized')) {
		//	component.set('v.isInitialized', true);
		//	component.set('v.activeSections', ['A']);
		//}

		if (!component.get('v.isInitialized')) {
			component.set('v.isInitialized', true);
			if (component.get('v.wcOrderApprover') == '3rdApprove') {
				component.set('v.activeSections', ['C']);
			}
		}
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault();
		const fields = event.getParam('fields');

		// 3-What's analysis default before submit
		const wcstage = helper.calculateWcStage(component);
		//if (wcstage != 'Approve extend next day') {
			fields.Can_go_wrong1__c = fields.Can_go_wrong1__c || null;
			fields.Can_go_wrong2__c = fields.Can_go_wrong2__c || null;
			fields.Can_go_wrong3__c = fields.Can_go_wrong3__c || null;
			fields.Can_go_wrong4__c = fields.Can_go_wrong4__c || null;
			fields.Can_go_wrong5__c = fields.Can_go_wrong5__c || null;
			fields.Can_go_wrong6__c = fields.Can_go_wrong6__c || null;
			fields.Cause1__c = fields.Cause1__c || null;
			fields.Cause2__c = fields.Cause2__c || null;
			fields.Cause3__c = fields.Cause3__c || null;
			fields.Cause4__c = fields.Cause4__c || null;
			fields.Cause5__c = fields.Cause5__c || null;
			fields.Cause6__c = fields.Cause6__c || null;
			fields.Prevent1__c = fields.Prevent1__c || null;
			fields.Prevent2__c = fields.Prevent2__c || null;
			fields.Prevent3__c = fields.Prevent3__c || null;
			fields.Prevent4__c = fields.Prevent4__c || null;
			fields.Prevent5__c = fields.Prevent5__c || null;
			fields.Prevent6__c = fields.Prevent6__c || null;
		//}
		if (wcstage == 'Approve work clearance (PREP)') {
			fields.Last_User_Action__c = 'OPEXTD';
		} else if (wcstage == 'Approve extend from normal hours') {
			fields.Last_User_Action__c =
				component.get('v.wcDisplay.Extend_No__c') && Number(component.get('v.wcDisplay.Extend_No__c')) > 0
					? 'OPEXOT2'
					: 'OPEXTH';
		} else if (wcstage == 'Approve return work clearance') {
			fields.Last_User_Action__c =
				component.get('v.wcDisplay.Extend_No__c') && Number(component.get('v.wcDisplay.Extend_No__c')) > 0
					? 'OPWIP2'
					: 'OPWIP1';
		} else if (wcstage == 'Approve extend next day') {
			fields.Last_User_Action__c = 'OPEXOT';
		} else if (wcstage == 'Approve close work clearance') {
			fields.Last_User_Action__c =
				component.get('v.wcDisplay.Extend_No__c') && Number(component.get('v.wcDisplay.Extend_No__c')) > 0
					? 'OPWCCL2'
					: 'OPWCCL';
		}

		setTimeout(
			$A.getCallback(() => {
				if (!component.get('v.pressKey.enter') && component.get('v.pressKey.click')) {
					// console.log(helper.parseObject(fields));
					helper.startLoading(component);
					event.getSource().submit(fields);
				}
			}),
			150
		);
	},
	handleSuccess: function (component, event, helper) {
		helper.stopLoading(component);
		component.find('navService').navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__ODM_WorkClearanceRecordDisplay'
				},
				state: {
					c__recordId: component.get('v.recordId')
				}
			},
			true
		);
		// var params = event.getParams();
		// console.log(helper.parseObject(params));
		// const {
		// 	response: { id }
		// } = params;
	},
	handleApproveChange: function (component, event, helper) {
		helper.validateRequireFields(component, event, helper);
	},
});