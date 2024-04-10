({
	doInit: function (component, event, helper) {
		let pageref = component.get('v.pageReference');
		if (pageref && !component.get('v.recordId')) {
			let { c__recordId, c__tabName, c__ptwInspectionId } = pageref.state;
			component.set('v.ptwInspectionId', c__ptwInspectionId);
			component.set('v.recordId', c__recordId);
			component.set('v.whichPage', c__tabName || 'detail');
		}

		helper.handleSetInterval(component);
		helper.handleSetTimeout(component);
		helper.hasWriteAccess(component);
		helper.canApproveOrReject(component);
		helper.checkAbleVerify(component, event);
		//helper.checkAbleInspec(component,event);
		// helper.checkDisagree(component);

		component.find('recordData').reloadRecord(true);
	},
	handleRecordUpdated: function (component, event, helper) {
		const eventParams = event.getParams();

		let { changeType, changedFields } = eventParams;
		if (changeType === 'LOADED') {
			let recordUi = component.get('v.workClearanceRecordUi');
			component.set('v.workClearanceRecordUi', JSON.parse(JSON.stringify(recordUi)));
			helper.hasPendingApproval(component);
			helper.getPISUsers(component, event, helper);
			component.set('v.isLoadingRecordUi', false);
		}
		if (changeType === 'CHANGED' && changedFields && changedFields['Integration_Status__c']) {
			component.set(`v.workClearanceRecord.Integration_Status__c`, changedFields['Integration_Status__c'].value);
            
			let recordUi = component.get('v.workClearanceRecordUi');
			component.set('v.workClearanceRecordUi', JSON.parse(JSON.stringify(recordUi)));
			helper.hasPendingApproval(component);
			helper.getPISUsers(component, event, helper);

			helper.handleSetInterval(component);
			helper.handleSetTimeout(component);
			helper.hasWriteAccess(component);
		}
		component.set('v.isAlertIntegration',
			!component.get('v.workClearanceRecord.Integration_Status__c')
			|| component.get('v.workClearanceRecord.Integration_Status__c') === 'Failed'
		);

		//        helper.truncHistoryDetail(component);
		component.set('v.isLoadingRecord', false);
	},
	doneRendering: function (component, event, helper) {

	},
	reInit: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	},
	handleSelectButtonMenu: function (component, event, helper) {
		var selectedFunc = event.getParam('value');
		if (selectedFunc) {
			$A.enqueueAction(component.get(selectedFunc));
		}
	},
	showApproveModal: function (component, event, helper) {
		try {
			component.find('navService').navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${window.btoa(
							JSON.stringify({
								componentDef: `c:ODM_WorkClearanceApprove`,
								attributes: {
									recordId: component.get('v.recordId'),

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
		} catch (err) {
			alert(err.message || err);
		}
	},
	toggleRejectModal: function (component, event, helper) {
		component.set('v.isModalAction.reject', !component.get('v.isModalAction.reject'))
	},
	rejectWorkClearance: function (component, event, helper) {
		$A.enqueueAction(component.get('c.toggleRejectModal'));
		component.find('recordRejectForm').submit();
		$A.get('e.force:refreshView').fire();
	},
	resendNotification: function (component, event, helper) {
		component.find('recordResendForm').submit();
		$A.get('e.force:refreshView').fire();
	},
	closeAlertIntegration: function (component, event, helper) {
		component.set('v.isAlertIntegration', false);
	},
	handleLoadRecordEdit: function (component, event, helper) {
		//let recordUi = event.getParam('recordUi');
		//component.set('v.workClearanceRecordUi', JSON.parse(JSON.stringify(recordUi)));
		//helper.hasPendingApproval(component);
		//helper.getPISUsers(component, event, helper);
		//component.set('v.isLoadingRecordUi', false);
	},
	handleRejectFormError: function (component, event, helper) {

	},
	handleResendFormError: function (component, event, helper) {

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
		} catch (error) {
			console.error(error);
		}
	},
	goToNotification: function (component, event, helper) {
		const recordId = event.currentTarget.getAttribute('data-record-id');
		component.find('navService').navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__ODM_NotificationRecordDisplay'
				},
				state: {
					c__recordId: recordId
				}
			},
			false
		);
	},

	handleEvent: function (component, event, helper) {
		console.log('Event:handleAgreeDisagree');
		helper.handleAgreeDisagree(component, event);

	},

	openDetail: function (component, event, helper) {
		if (component.get('v.whichPage', 'Inspection') && component.find('ODM_WorkClearanceRecordDisplayInspection') && component.find('ODM_WorkClearanceRecordDisplayInspection').isRecordChanged()) {
			component.find('ODM_WorkClearanceRecordDisplayInspection').openConfirmSavePTWModal('detail');
			return;
		}
		component.set('v.whichPage', 'detail');
		console.log(component.get('v.whichPage'));

		//setTimeout($A.getCallback(function() {
		//    helper.applyVerificationCSS(component, event, component.get('v.color'));
		//}), 10);
		var btnDetail = component.find('detailButton');
		var btnVerification = component.find('verificationButton');
		var btnInspection = component.find('inspectionButton');
		$A.util.removeClass(btnVerification, 'focusBtnOnCurrentPage');
		$A.util.removeClass(btnInspection, 'focusBtnOnCurrentPage');
		$A.util.addClass(btnDetail, 'focusBtnOnCurrentPage');
	},

	openVerification: function (component, event, helper) {
		if (component.get('v.whichPage', 'Inspection') && component.find('ODM_WorkClearanceRecordDisplayInspection') && component.find('ODM_WorkClearanceRecordDisplayInspection').isRecordChanged()) {
			component.find('ODM_WorkClearanceRecordDisplayInspection').openConfirmSavePTWModal('verification');
			return;
		}
		component.set('v.whichPage', 'verification');
		// var color = 'red';
		// helper.applyVerificationCSS(component, event, color);
		//setTimeout($A.getCallback(function() {
		//    helper.applyVerificationCSS(component, event, component.get('v.color'));
		//}), 10);
		var btnDetail = component.find('detailButton');
		var btnVerification = component.find('verificationButton');
		var btnInspection = component.find('inspectionButton');
		$A.util.removeClass(btnDetail, 'focusBtnOnCurrentPage');
		$A.util.removeClass(btnInspection, 'focusBtnOnCurrentPage');
		$A.util.addClass(btnVerification, 'focusBtnOnCurrentPage');
	},
	openInspection: function (component, event, helper) {
		if (component.get('v.whichPage', 'Inspection') && component.find('ODM_WorkClearanceRecordDisplayInspection') && component.find('ODM_WorkClearanceRecordDisplayInspection').isRecordChanged()) {
			component.find('ODM_WorkClearanceRecordDisplayInspection').openConfirmSavePTWModal('Inspection');
			return;
		}

		// alert('test check open ---'+component.get('v.disableInspec'));
		if (component.get('v.disableInspec') == false) {
			let recordId = component.get('v.recordId');
			component.find('navService').navigate(
				{
					type: 'standard__component',
					attributes: {
						componentName: 'c__ODM_WorkClearanceRecordDisplay'
					},
					state: {
						c__recordId: recordId,
						c__tabName: 'Inspection'
					}
				},
				false
			);
		}
		// var color = 'red';
		// helper.applyVerificationCSS(component, event, color);
	},
	changetoRed: function (component, event, helper) {
		//component.set('v.whichPage', 'Inspection');
		// var color = 'red';
		// helper.applyVerificationCSS(component, event, color);
		helper.checkAbleVerify(component, event);

	},
	pinMap: function (component, event, helper) {
		//component.set('v.isModalAction.pinMap', !component.get('v.isModalAction.pinMap'));
		//let urlEvent = $A.get('e.force:navigateToURL');
		//urlEvent.setParams({
		//    'url': 'https://thaioil--qas--c.visualforce.com/apex/WAP_Home?editingWorkClearance=' + component.get('v.workClearanceRecord.Name')
		//});
		//urlEvent.fire();

		try {
			component.find('recordDataPinMap').saveRecord(
				$A.getCallback(function(saveResult) {
					let workClearanceNumber = component.get('v.workClearanceRecord.Name');
					let navService = component.find('navService');
					navService.navigate(
						{
							type: 'standard__webPage',
							attributes: {
								url: '/apex/WAP_Home?editingWorkClearance=' + workClearanceNumber
							},
						},
						false
					);
				})
			)
		} catch(ex) {
			console.log(ex)
		}
		
	},

	savePinMap: function (component, event, helper) {
		helper.makeToast('success', 'Success', 'Work Clearance Location have been save successfully');
		component.set('v.isModalAction.pinMap', !component.get('v.isModalAction.pinMap'));
	},
})