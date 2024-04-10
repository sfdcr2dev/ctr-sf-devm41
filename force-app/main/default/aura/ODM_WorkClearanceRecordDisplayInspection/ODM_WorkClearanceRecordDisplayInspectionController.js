({
	doInit: function (component, event, helper) {
		component.set('v.constants', helper.constants);

		let pageref = component.get('v.pageReference');
		if (pageref && !component.get('v.recordId')) {
			let { c__recordId } = pageref.state;
			component.set('v.recordId', c__recordId);
		}

		let ptwHeaderId = component.get('v.ptwInspectionId');
		if (!$A.util.isEmpty(ptwHeaderId)) {
			component.set('v.selectedFormQuestions', ptwHeaderId);
		}

		component.set('v.isLoadingList', true);
		component.set('v.isLoadingRecord', true);
		helper.getWorkClearanceById(component, event, helper);
		helper.getPISUser(component, event, helper);
		helper.getFormQuestions(component, event, helper);
		helper.getFormAnswers(component, event, helper, function(component, event, helper) {
			let formAnswers = component.get('v.formAnswers');
			
			// console.log('formAnswers >>>>>',component.get('v.formAnswers'),'--->',formAnswers[0].Status__c);
			// if(formAnswers[0].Status__c === 'หยุดงานถาวร'){
			// 	console.log('หยุดงานถาวร');
			// 	component.set('v.hideCreatePermitToWorkBtn', true);
			// 	console.log('หยุดงานถาวร, hideCreatePermitToWorkBtn >>>>>',component.get('v.hideCreatePermitToWorkBtn'));
			// }
			if (!formAnswers || ($A.util.isArray(formAnswers) && formAnswers.length === 0)) {
				helper.createNewInspection(component, event, helper);
			}
			else{
				console.log('formAnswers >>>>>',component.get('v.formAnswers'),'--->',formAnswers[0].Status__c);
				if(formAnswers[0].Status__c === 'หยุดงานถาวร'){
					console.log('หยุดงานถาวร');
					component.set('v.hideCreatePermitToWorkBtn', true);
					console.log('หยุดงานถาวร, hideCreatePermitToWorkBtn >>>>>',component.get('v.hideCreatePermitToWorkBtn'));
				}
			}
		});
		helper.hasWriteAccess(component, event, helper);
	},
	handleSave: function (component, event, helper) {
		helper.savePermitToWork(component, event, helper);
	},
	handleNew: function (component, event, helper) {
		// component.set('v.hideCreatePermitToWorkBtn', true);
		// console.log('hideCreatePermitToWorkBtn >>>>>',component.get('v.hideCreatePermitToWorkBtn'));
		helper.createNewInspection(component, event, helper);
	
		
	},
	handleSelectPermitToWork: function (component, event, helper) {
//		let ptwHeaderId;
//		try {
//			component.set('v.isLoadingRecord', true);
//			ptwHeaderId = event.currentTarget.getAttribute('data-record-id');
		
//			helper.displaySelectedFormQuestions(component, event, helper, ptwHeaderId);
//		} catch (ex) {
//			helper.showToast('error', 'Cannot load Permit to Work Inspection, Please contact System Administrator.', `${ex.message}`);
//		} finally {
//			setTimeout($A.getCallback(function () {
//				component.set('v.selectedFormQuestions', ptwHeaderId);	
//				component.set('v.isLoadingRecord', false);
//			}), 1000);
//		}

		let recordId = component.get('v.recordId');
		let ptwHeaderId = event.currentTarget.getAttribute('data-record-id');
		component.find('navService').navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__ODM_WorkClearanceRecordDisplay'
				},
				state: {
					c__recordId: recordId,
					c__tabName: 'Inspection',
					c__ptwInspectionId: ptwHeaderId
				}
			},
			false
		);
	},
	handleSelectButtonMenu: function (component, event, helper) {
		var selectedFunc = event.getParam('value');
		if (selectedFunc) {
			$A.enqueueAction(component.get(selectedFunc));
		}
	},
	handleFormAnswerChanged: function (component, event, helper) {
		console.log('Changed');
	},
	handleInputFieldChanged: function (component, event, helper) {
		const { value } = event.getParams();
		component.set('v.hasChanged', true);
		
		if (helper.isInspectionQuestionChanged(component, event, helper)) {
			if (String(value).toLowerCase() == 'no') {
				helper.createCommentLocal(component, event, helper);
			} else {
				helper.deleteCommentLocal(component, event, helper);
			}
			helper.calculateComplianceScore(component, event, helper);
			helper.setPermissionsAndActions(component, event, helper);
		} else if (helper.isPTWTypeOrWorkTypeChanged(component, event, helper)) {
			helper.setSectionAndDependencyPicklist(component, event, helper);
		}
	},
	handleFileUploadFinished: function (component, event, helper) {
		helper.getFilesRelated(component, event, helper);
	},
	handleConfirmStopWork: function (component, event, helper) {
		helper.stopWork(component, event, helper);
	},
	handleCloseConfirmStopWorkModal: function (component, event, helper) {
		helper.closeConfirmStopWorkModal(component, event, helper);
	},
	handleOpenConfirmSavePTWModal: function (component, event, helper) {
		const args = event.getParam('arguments');
		component.set('v.redirectToTabName', args[0]);
		helper.openConfirmSavePTWModal(component, event, helper);
	},
	handleConfirmSavePTW: function (component, event, helper) {
		helper.savePermitToWork(component, event, helper, function(component, event, helper) {
			let recordId = component.get('v.recordId');
			component.find('navService').navigate(
				{
					type: 'standard__component',
					attributes: {
						componentName: 'c__ODM_WorkClearanceRecordDisplay'
					},
					state: {
						c__recordId: recordId,
						c__tabName: component.get('v.redirectToTabName'),
					}
				},
				false
			);
		});
	},
	handleCloseConfirmSavePTWModal: function (component, event, helper) {
		helper.closeConfirmSavePTWModal(component, event, helper);
	},
	previewFile: function (component, event, helper) {
		if (event.target) {
			var clickeFiledId = event.currentTarget.id;
			$A.get('e.lightning:openFiles').fire({
				recordIds: [clickeFiledId]
			});
		}
	},
	deleteMe: function (component, event, helper) {
		if (confirm('Are you sure you would like to delete this file?')) {
			helper.deleteFile(component, event, helper);
		}
	},
	allowWork: function (component, event, helper) {
		helper.allowWork(component, event, helper);
	},
	saveDraft: function (component, event, helper) {
		helper.savePermitToWork(component, event, helper);
	},
	holdWork: function (component, event, helper) {
		helper.holdWork(component, event, helper);
	},
	stopWork: function (component, event, helper) {
		helper.openConfirmStopWorkModal(component, event, helper);
	},
	getRecordChangeStatus: function (component, event, helper) {
		return component.get('v.hasChanged');
	},
    handleUploadFinished: function (component, event, helper) {
        helper.showToast('success', 'Success', 'File uploaded successfully');
        component.find('inspectionRelatedFiles') && component.find('inspectionRelatedFiles').refresh();
    },
//	handleChanged: function (component, event, helper) {
//        try {
//            let evt = component.getEvent('valueChangeEvent')
//            evt.setParams({
//                fieldName: component.get('v.fieldName'),
//                value: component.get('v.value'),
//                oldValue: component.get('v.oldValue'),
//                questionId: component.get('v.questionId'),
//            })
//            evt.fire()
//            component.set('v.oldValue', component.get('v.value'))
//        } catch (ex) {
//            console.error(ex)
//        }
//    },
})