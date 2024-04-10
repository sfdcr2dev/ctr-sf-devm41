({
	constants: {
		'STATUS': {
			'DRAFT': 'Draft',
			'IN_PROCESS': 'ดำเนินการได้',
			'ON_HOLD': 'หยุดงานชั่วคราว',
			'STOP': 'หยุดงานถาวร',
		},
		'DATA_TYPE': {
			'DATE': 'Date',
			'TEXT': 'Text',
			'NUMBER': 'Number',
			'PERCENT': 'Percent',
			'TEXT_AREA': 'Text Area',
			'PICKLIST': 'Picklist',
			'LOOKUP': 'Lookup',
		},
		'SECTION': {
			'PERMIT_TO_WORK_INSPECTION_HEADER': 'Permit to Work Inspection header',
			'PERMIT_TO_WORK_PREPARATION_APPROVAL': 'Permit to Work Preparation & Approval',
			'HAZARDS_IDENTIFICATION_MITIGATIONS_MEASURES': 'Hazards Identification & Mitigations Measures',
			'PRECAUTIONS': 'Precautions',
			'GAS_TESTS': 'Gas Tests',
			'ISOLATION_AND_INHIBIT_OVERRIDE': 'Isolation and Inhibit/ Override',
			'WORKING_IN_CONFINED_SPACE': 'Working in Confined Space (การทำงานในสถานที่อับอากาศ)',
			'LIFTING': 'Lifting (งานยก)',
			'PERMIT_TO_WORK_OPENING_REVALIDATION_AND_EXECUTION': 'Permit to Work Opening/ Revalidation and Execution',
			'COMMENTS_RECOMMENDATIONS': 'COMMENTS / RECOMMENDATIONS:',
		},
		'FIELD': {
			'DATE_OF_INSPECTION': 'DATE_OF_INSPECTION', // 'Date of Inspection'
			'PTW_TYPE': 'PTW_TYPE', // 'PTW Type*'
			'PTW_SUB_TYPE': 'PTW_SUB_TYPE', // 'PTW Sub-Type'
			'WORK_TYPE': 'WORK_TYPE', // 'Work Type*'
			'STATUS': 'STATUS', // 'Status'
			'SAFETY_PERMIT_NO': 'SAFETY_PERMIT_NO', // 'Safety Permit No.'
			'CLEARANCE_CERTIFICATE_NO': 'CLEARANCE_CERTIFICATE_NO', // 'Clearance Certificate No.'
			'WORK_LOCATION': 'WORK_LOCATION', // 'Work Location (FL)'
			'PERFORMING_AUTHORITY': 'PERFORMING_AUTHORITY', // 'Performing Authority:(ชื่อเจ้าของงาน)'
			'DEPARTMENT': 'DEPARTMENT', // 'Department'
			'CONTRACTOR_COMPANY': 'CONTRACTOR_COMPANY', // 'Contractor Company'
			'WORK_TASK_DESCRIPTION': 'WORK_TASK_DESCRIPTION', // 'Work/Task Description:'
			'INSPECTION_QUESTION_14': 'INSPECTION_QUESTION_14', // '14. มีการจัดทำ Isolation Work Pack หรือเอกสารที่เกี่ยวข้องกับการตัดแยกปิดกั้นหรือไม่?'
			'INSPECTION_QUESTION_15': 'INSPECTION_QUESTION_15', // '15. ใบอนุญาตให้ทำงาน (Clearance Certificate) หรือเอกสารที่เกี่ยวข้อง มีการระบุการตัดแยกปิดกั้นระบบหรือไม่?'
			'INSPECTION_QUESTION_16': 'INSPECTION_QUESTION_16', // '16. การตัดแยกปิดกั้นทั้งหมดนั้นแข็งแรงแน่นหนาหรือไม่?'
			'INSPECTION_QUESTION_17': 'INSPECTION_QUESTION_17', // '17. การตัดแยกมีการทำ LOTO ครบถ้วนหรือไม่?'
			'INSPECTION_QUESTION_18': 'INSPECTION_QUESTION_18', // '18. มีการตรวจการทำ LOTO และลงในนาม Isolation Certificate ครบถ้วนทุกหน่วยงานที่เกี่ยวข้อหรือไม่?'
			'INSPECTION_QUESTION_19': 'INSPECTION_QUESTION_19', // '19. มีการยับยั้งระบบ (Inhibit/ Override) เพียงพอและปลอดภัยสำหรับงานที่ทำและสอดคล้องกับ PTW และบันทึกผลในห้องควบคุมหรือไม่?'
			'INSPECTION_QUESTION_38': 'INSPECTION_QUESTION_38', // '38. งาน Potential High Risk Work ได้จัดทำ Check list ส่วนที่ 1 และส่วนที่ 2 ครบถ้วนหรือไม่?'
			'AUDITOR_NAME': 'AUDITOR_NAME', // '(Auditor) Name:*'
			'NO_COMPLIANCE': 'NO_COMPLIANCE', // 'No. Compliance :'
			'NO_NON_COMPLIANCE': 'NO_NON_COMPLIANCE', // 'No. Non-Compliance:'
			'PERCENT_COMPLIANCE': 'PERCENT_COMPLIANCE', // '% Compliance :'
			'REASON_FOR_TERMINATION': 'REASON_FOR_TERMINATION', // 'Reason for Termination'
		},
	},
	hasWriteAccess: function (component, event, helper) {
		let recordId = component.get('v.recordId');

		if (recordId) {
			let action = component.get('c.hasWriteAccess');

			action.setParams({
				workclearanceId: recordId
			});

			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					component.set('v.hasWriteAccess', response.getReturnValue());
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
	},
	setPermissionsAndActions: function (component, event, helper) {
		let hasWriteAccess = component.get('v.hasWriteAccess');
		let ptwHeaderId = component.get('v.selectedFormQuestions');
		if (ptwHeaderId == 'New') {
			ptwHeaderId = '';
		}

		let status = helper.constants.STATUS.DRAFT;
		let formAnswers = component.get('v.formAnswers');
		//if ($A.util.isArray(formAnswers) && formAnswers.length > 0) {
			let formAnswer = formAnswers.find((value) => value.Id == ptwHeaderId);
			if (formAnswer) {
				status = formAnswer.Status__c;
			}
		//}

		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		//let questions = displayedFormQuestions.filter((value) => value.Question_API__c.indexOf('INSPECTION_QUESTION') > -1);
		let isPTWTypeConfinedSpace = component.get('v.isPTWTypeConfinedSpace');
		let isWorkTypeLifting = component.get('v.isWorkTypeLifting');
		let isPTWTypeColdWork = component.get('v.isPTWTypeColdWork');
		let isWorkTypeGeneral = component.get('v.isWorkTypeGeneral');

		let sections = [
			helper.constants.SECTION.PERMIT_TO_WORK_PREPARATION_APPROVAL,
			helper.constants.SECTION.HAZARDS_IDENTIFICATION_MITIGATIONS_MEASURES,
			helper.constants.SECTION.PRECAUTIONS,
			helper.constants.SECTION.ISOLATION_AND_INHIBIT_OVERRIDE,
			helper.constants.SECTION.PERMIT_TO_WORK_OPENING_REVALIDATION_AND_EXECUTION,
		];

		if (isPTWTypeConfinedSpace) {
			sections.push(helper.constants.SECTION.WORKING_IN_CONFINED_SPACE);
		}

		if (isWorkTypeLifting) {
			sections.push(helper.constants.SECTION.LIFTING);
		}

		if (!isPTWTypeColdWork) {
			sections.push(helper.constants.SECTION.GAS_TESTS);
		}

		let questions = displayedFormQuestions.filter(function (value) {
			return sections.indexOf(value.Section__c) > -1;
		});
		let hasBlankAnswer = questions.find((value) => $A.util.isEmpty(value.Answer__c));
		let hasNoAnswer = questions.find((value) => value.Answer__c == 'No');

		//let canSaveDraft = hasWriteAccess && (status != helper.constants.STATUS.STOP);
		//let canAllowWork = hasWriteAccess && (status == helper.constants.STATUS.DRAFT || status == helper.constants.STATUS.ON_HOLD) && !hasBlankAnswer;
		//let canHoldWork = hasWriteAccess && (status == helper.constants.STATUS.IN_PROCESS);
		//let canStopWork = hasWriteAccess && (status == helper.constants.STATUS.IN_PROCESS || status == helper.constants.STATUS.ON_HOLD);

		let canSaveDraft = hasWriteAccess && (status != helper.constants.STATUS.STOP && status != helper.constants.STATUS.IN_PROCESS);
		let canAllowWork = hasWriteAccess && (status != helper.constants.STATUS.STOP && status != helper.constants.STATUS.IN_PROCESS) && !hasBlankAnswer;
		let canHoldWork = hasWriteAccess && (status != helper.constants.STATUS.STOP && status != helper.constants.STATUS.IN_PROCESS && status != helper.constants.STATUS.ON_HOLD) && !hasBlankAnswer && hasNoAnswer;
		let canStopWork = hasWriteAccess && (status != helper.constants.STATUS.STOP && status != helper.constants.STATUS.IN_PROCESS) && !hasBlankAnswer && hasNoAnswer;

		component.set('v.canSaveDraft', canSaveDraft);
		component.set('v.canAllowWork', canAllowWork);
		component.set('v.canHoldWork', canHoldWork);
		component.set('v.canStopWork', canStopWork);

		if (status == helper.constants.STATUS.STOP || status == helper.constants.STATUS.IN_PROCESS) {
			displayedFormQuestions.forEach((q) => q.Disabled = true);

			let displayedFormQuestionComments = component.get('v.displayedFormQuestionComments');
			displayedFormQuestions.forEach((c) => c.Disabled = true);
		}
	},
	getWorkClearanceById: function(component, event, helper) {
		let action = component.get('c.getWorkClearanceById');
		// console.log('getWorkClearanceById : action',action);

		action.setParams({
			workClearanceId: component.get('v.recordId') //recordId จากหน้า Ui saleforce
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let results = response.getReturnValue();
				if ($A.util.isArray(results) && results.length > 0) {
					component.set('v.workClearance', results[0]);
					console.log('getWorkClearanceById : v.workClearance',results[0]);
				} else {
					component.set('v.workClearance', {})
				}
			}
		});

		$A.enqueueAction(action);
	},
	getPISUser: function(component, event, helper) {
		let action = component.get('c.getPISUser');
		// console.log('getWorkClearanceById : action',action);

		action.setParams({
			workClearanceId: component.get('v.recordId') //recordId จากหน้า Ui saleforce
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let results = response.getReturnValue();
				if ($A.util.isArray(results) && results.length > 0) {
					//component.set('v.pisuserFullName', results[0]);
					//console.log('getWorkClearanceById : pisusers', results[0]);

					component.set('v.PISUser', results[0]);
					//console.log('PISUser >>>>>',component.get('v.PISUser'));
				}

			}
		});

		$A.enqueueAction(action);
	},
	getFormQuestions: function (component, event, helper) {
		let version = '';
		let action = component.get('c.getFormQuestions');

		action.setParams({
			'version': version
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let results = response.getReturnValue();
				let formQuestions = [];
				let versions = [];
				let sections = [];
				let dataTypes = [];

				if ($A.util.isArray(results) && results.length > 0) {
					results.forEach(function (value) {
						if (String(value.Answer_type__c) === helper.constants.DATA_TYPE.PICKLIST) {
							let options = !$A.util.isEmpty(value.Value__c) && String(value.Value__c).split(',');
							value.Picklist = options || [];
							value.Picklist = value.Picklist.map((s) => s.trim());
							value.PicklistMaster = value.Picklist;
						} else if (String(value.Answer_type__c) === helper.constants.DATA_TYPE.LOOKUP) {
							let lookupConfig = JSON.parse(value.Value__c);
							value.fetchSObjectName = lookupConfig.fetchSObjectName || 'PISUsers__c';
							value.nameDisplayFormat = lookupConfig.nameDisplayFormat || '{EN_Fullname__c}';
							value.descriptionDisplayFormat = lookupConfig.descriptionDisplayFormat || '{Home Id: HOME_ID__c, Host Id: HOST_ID__c}';
						}
//						if (String(value.Question_API__c) === helper.constants.FIELD.AUDITOR_NAME) {
//							let lookupConfig = JSON.parse(value.Value__c);
//							// value.Answer__c = lookupConfig.component.get('v.PISUser');
//							value.Answer__c = component.get('v.PISUser').EN_Fullname__c;
//							console.log('value.Answer__c >>>>',typeof(value.Answer__c));
//						}

						formQuestions.push(value);
					});

					component.set('v.formQuestions', formQuestions);
					component.set('v.versions', helper.getVersions(formQuestions).reverse());
					component.set('v.sections', helper.getSections(formQuestions));
					component.set('v.dataTypes', helper.getDataTypes(formQuestions));
					component.set('v.version', component.get('v.versions')[0]);

					console.log(component.get('v.versions'));
					console.log(component.get('v.sections'));
					console.log(component.get('v.dataTypes'));
					console.log('v.formQuestions >>>>>',component.get('v.formQuestions'));
				}
			}
		});

		$A.enqueueAction(action);
	},
	getFormAnswers: function (component, event, helper, callback) {
		//----------------------------

		let action = component.get('c.getFormAnswers');

		action.setParams({
			'workClearanceId': component.get('v.recordId')
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let formAnswers = response.getReturnValue();

				if ($A.util.isArray(formAnswers) && formAnswers.length > 0) {

					formAnswers.forEach(function (header) {
						$A.util.isArray(header.PTW_Answer__r) && header.PTW_Answer__r.forEach(function (answer) {
							if (!answer.Question__r) {
								return;
							}

							switch (answer.Question__r.Question_API__c) {
								case helper.constants.FIELD.PTW_TYPE:
									header.Type = answer.Answer__c;
									break;
								case helper.constants.FIELD.DATE_OF_INSPECTION:
									header.InspectionDate = answer.Answer__c;
									header.InspectionDateFormat = $A.localizationService.formatDate(answer.Answer__c);
									break;
								case helper.constants.FIELD.WORK_TYPE:
									header.WorkType = answer.Answer__c;
									break;
								case helper.constants.FIELD.AUDITOR_NAME:
									header.AuditorName = answer.Answer__c;
									header.AuditorNameText = answer.Answer__c;
                                    //answer.Question__r.Answer__c = component.get('v.PISUser');
									break;
							}
						});
					});

					component.set('v.formAnswers', formAnswers);

					helper.getFilesRelated(component, event, helper);

					console.log('v.formAnswers >>>>',component.get('v.formAnswers'));
				}

				setTimeout($A.getCallback(function () {
					component.set('v.isLoadingList', false);
					component.set('v.isLoadingRecord', false);
				}), 3000)

				if (typeof(callback) === 'function') {
					callback(component, event, helper);
				}
			}
		});

		$A.enqueueAction(action);
	},
	getFilesRelated: function (component, event, helper) {
		let action = component.get('c.getFilesRelated');

		action.setParams({
			'workClearanceId': component.get('v.recordId')
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let filesRelated = response.getReturnValue();
				component.set('v.filesRelated', filesRelated);
				helper.displaySelectedFormQuestions(component, event, helper);
			}
		});

		$A.enqueueAction(action);
	},
	displaySelectedFormQuestions: function (component, event, helper, headerId) {
		let formQuestions = component.get('v.formQuestions');
		let formAnswers = component.get('v.formAnswers');
		let filesRelated = component.get('v.filesRelated');
		let ptwHeaderId = headerId || component.get('v.selectedFormQuestions');
		if (ptwHeaderId == 'New') {
			ptwHeaderId = '';
		}

		let formAnswer = formAnswers.find((value) => value.Id == ptwHeaderId);
		let formVersionQuestion = [];
		let formVersionQuestionComment = [];
		if (formAnswer) {
			
			console.log('formAnswer >>>>>',formAnswer);
			let version = formAnswer.Version__c;
			formVersionQuestion = formQuestions.filter((value) => value.Version__c == version);
			formVersionQuestion = JSON.parse(JSON.stringify(formVersionQuestion));
			formVersionQuestion.forEach(function (q) {
				let answer = (formAnswer.PTW_Answer__r) ? formAnswer.PTW_Answer__r.find((a) => q.Id == a.Question__c && !a.Parent_Answer__c) : false;
				q.PTW_Header__c = ptwHeaderId;
				q.Answer__c = (answer) ? answer.Answer__c : '';
			});

			formVersionQuestionComment = formAnswer.PTW_Answer__r.filter((value) => value.Parent_Answer__c);
			formVersionQuestionComment.forEach(function (a) {
				a.Files = $A.util.isArray(filesRelated) ? filesRelated.filter((f) => a.Id == f.LinkedEntityId) : [];
			});
			formVersionQuestionComment.forEach(function (a) {
				let question = formVersionQuestion.find((value) => value.Id == a.Question__c);
				if (question) {
					let questionNo = String(question.Question__c).split('.');
					a.QuestionNo = ($A.util.isArray(questionNo) && !isNaN(questionNo[0])) ? questionNo[0] : '';
					a.Parent_Answer_Key__c = question.Id;
					a.Flag = 'Remote';
				}
			});
			formVersionQuestionComment.sort(helper.sortQuestionNo);
		} else {
			let version = component.get('v.version') || 1;
			let workClearanceId = component.get('v.recordId');
			let workClearance = component.get('v.workClearance');
			//let pisuserFullName = component.get('v.pisuserFullName');

			let { ptwType, ptwSubType, workType } = getDefaultHeaderValue(formAnswers);

			formVersionQuestion = formQuestions.filter((value) => value.Version__c == version);
			formVersionQuestion = JSON.parse(JSON.stringify(formVersionQuestion));
			formVersionQuestion.forEach(function (q) {
				q.Work_Clearance__c = workClearanceId;

				if (q.Question_API__c == helper.constants.FIELD.DATE_OF_INSPECTION) {
					q.Answer__c = $A.localizationService.formatDate(new Date(), 'YYYY-MM-DD');
				}
				if (q.Question_API__c == helper.constants.FIELD.PTW_TYPE) {
					q.Answer__c = ptwType;
				}
				if (q.Question_API__c == helper.constants.FIELD.PTW_SUB_TYPE) {
					q.Answer__c = ptwSubType;
				}
				if (q.Question_API__c == helper.constants.FIELD.WORK_TYPE) {
					q.Answer__c = workType;
				}
				if (q.Question_API__c == helper.constants.FIELD.CLEARANCE_CERTIFICATE_NO) {
					q.Answer__c = workClearance.Name;
				}
				if (q.Question_API__c == helper.constants.FIELD.SAFETY_PERMIT_NO) {
					let safetyPermits = [];
					if (workClearance.Safety_Permit1_UI__r && workClearance.Safety_Permit1_UI__r.Name) {
						safetyPermits.push(workClearance.Safety_Permit1_UI__r.Name);
					}
					if (workClearance.Safety_Permit2_UI__r && workClearance.Safety_Permit2_UI__r.Name) {
						safetyPermits.push(workClearance.Safety_Permit2_UI__r.Name);
					}
					if (workClearance.Safety_Permit3_UI__r && workClearance.Safety_Permit3_UI__r.Name) {
						safetyPermits.push(workClearance.Safety_Permit3_UI__r.Name);
					}
					q.Answer__c = safetyPermits.join(', ');
				}
				if (q.Question_API__c == helper.constants.FIELD.WORK_LOCATION) {
					if (workClearance.FunctionalLocation__r) {
						q.Answer__c = workClearance.FunctionalLocation__r.Name;
					}
				}
				if (q.Question_API__c == helper.constants.FIELD.PERFORMING_AUTHORITY) {
					if (workClearance.Thaioil_Supervisor_Indicator_UI__r) {
						q.Answer__c = workClearance.Thaioil_Supervisor_Indicator_UI__r.EN_Fullname__c;
					}
				}
				if (q.Question_API__c == helper.constants.FIELD.WORK_TASK_DESCRIPTION) {
					q.Answer__c = workClearance.Work_Clearance_Description__c;
				}
				//new
				if (q.Question_API__c == helper.constants.FIELD.AUDITOR_NAME) {
					//console.log('component.get(v.PISUser) >>>',component.get('v.PISUser'));
					q.Answer__c = component.get('v.PISUser').EN_Fullname__c;
					//console.log('q.Answer__c >>>',q.Answer__c);
				}
				if (q.Question_API__c == helper.constants.FIELD.DEPARTMENT) {
					if (workClearance.Thaioil_Supervisor_Indicator_UI__r) {
						q.Answer__c = workClearance.Thaioil_Supervisor_Indicator_UI__r.SECTIONS__c;
					}
				}
			});
		}

		formVersionQuestion.forEach(function (q) {
			let disabledFileds = [
				helper.constants.FIELD.STATUS,
				helper.constants.FIELD.SAFETY_PERMIT_NO,
				helper.constants.FIELD.CLEARANCE_CERTIFICATE_NO,
				helper.constants.FIELD.WORK_LOCATION,
				helper.constants.FIELD.PERFORMING_AUTHORITY,
				helper.constants.FIELD.DEPARTMENT,
				helper.constants.FIELD.WORK_TASK_DESCRIPTION,
				//helper.constants.FIELD.INSPECTION_QUESTION_18,
			];
			if (disabledFileds.indexOf(q.Question_API__c) > -1) {
				q.Disabled = true;
			}
			//if (q.Question_API__c == helper.constants.FIELD.INSPECTION_QUESTION_18) {
			//	q.Answer__c = 'N/A';
			//}
		});
		component.set('v.PTWHeaderId', ptwHeaderId);
		component.set('v.displayedFormQuestions', formVersionQuestion);
		component.set('v.displayedFormQuestionComments', formVersionQuestionComment);
		component.set('v.sections', helper.getSections(formVersionQuestion));

		//helper.setSectionAndDependencyPicklist(component, event, helper);
		helper.calculateComplianceScore(component, event, helper);
		helper.setPermissionsAndActions(component, event, helper);

		console.log(component.get('v.displayedFormQuestions'));

		function getDefaultHeaderValue(formAnswers) {
			let ptwType = '';
			let ptwSubType = '';
			let workType = '';

			if ($A.util.isArray(formAnswers) && formAnswers.length > 0) {
				let ptwTypeAnswer = formAnswers[0].PTW_Answer__r.find((value) => value.Question__r.Question_API__c == helper.constants.FIELD.PTW_TYPE);
				if (ptwTypeAnswer) {
					ptwType = ptwTypeAnswer.Answer__c;
				}
				let ptwSubTypeAnswer = formAnswers[0].PTW_Answer__r.find((value) => value.Question__r.Question_API__c == helper.constants.FIELD.PTW_SUB_TYPE);
				if (ptwSubTypeAnswer) {
					ptwSubType = ptwSubTypeAnswer.Answer__c;
				}
				let workTypeAnswer = formAnswers[0].PTW_Answer__r.find((value) => value.Question__r.Question_API__c == helper.constants.FIELD.WORK_TYPE);
				if (workTypeAnswer) {
					workType = workTypeAnswer.Answer__c;
				}
			}

			return {
				ptwType: ptwType,
				ptwSubType: ptwSubType,
				workType: workType,
			}
		}
	},
	savePermitToWork: function (component, event, helper, callback) {
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let displayedFormQuestionComments = component.get('v.displayedFormQuestionComments');
		let deletedFormQuestionComments = $A.util.isArray(component.get('v.deletedFormQuestionComments')) ? component.get('v.deletedFormQuestionComments') : [];
		let status = component.get('v.status');
		let formName = component.get('v.formName');
		let action = component.get('c.savePermitToWork');
		let findHeader = displayedFormQuestions.find((value) => !$A.util.isEmpty(value.PTW_Header__c));
		let headerId = (findHeader) ? findHeader.PTW_Header__c : '';
		let findWorkClearance = displayedFormQuestions.find((value) => !$A.util.isEmpty(value.Work_Clearance__c));
		let workClearanceId = (findWorkClearance) ? findWorkClearance.Work_Clearance__c : '';
		let findVersion = displayedFormQuestions.find((value) => !$A.util.isEmpty(value.Version__c));
		let version = (findVersion) ? findVersion.Version__c : '';

		action.setParams({
			'jsonAnswer': JSON.stringify({
				'HeaderId': headerId,
				'WorkClearanceId': workClearanceId,
				'Version': version,
				'FormName': formName,
				'Status': status,
				'Inspection': [
					...displayedFormQuestions,
					...displayedFormQuestionComments,
					...deletedFormQuestionComments
						.filter((value) => value.Flag == 'Remote')
				],
			})
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let saveResults = response.getReturnValue();

				component.set('v.selectedFormQuestions', saveResults);
				component.set('v.hasChanged', false);
				component.set('v.deletedFormQuestionComments', []);
				helper.showToast('success', 'Success', 'Permit to Work has been saved, successfully');
				helper.isInitialized = false;
				helper.getFormAnswers(component, event, helper);

				component.getEvent("sampleComponentEvent").fire();

				if (typeof(callback) === 'function') {
					callback(component, event, helper);
				}
			} else if (state === 'ERROR') {
				let error = response.getError();
				let errorMessage = '';
				error.forEach(function (value) {
					for (let i in value.fieldErrors) {
						errorMessage += `Field Error: ${i}, Error Code: ${value.fieldErrors[i][0].statusCode}, Error Message: ${value.fieldErrors[i][0].message}`
					}
				});
				helper.showToast('error', 'Cannot save Permit to Work Inspection, Please contact System Administrator.', `${errorMessage}`)
			}
			setTimeout($A.getCallback(function() {
				component.set('v.isLoadingRecord', false);
			}), 5000)
		});

		component.set('v.isLoadingRecord', true);
		$A.enqueueAction(action);
	},
	isInspectionQuestionChanged: function (component, event, helper) {
		const { fieldName } = event.getParams();
		return fieldName.indexOf('INSPECTION_QUESTION') > -1
	},
	isPTWTypeOrWorkTypeChanged: function (component, event, helper) {
		const { fieldName } = event.getParams();
		return fieldName.indexOf(helper.constants.FIELD.PTW_TYPE) > -1 || fieldName.indexOf(helper.constants.FIELD.WORK_TYPE) > -1;
	},
	createCommentLocal: function (component, event, helper) {
		const { questionId } = event.getParams();

		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let displayedFormQuestionComments = component.get('v.displayedFormQuestionComments');
		let deletedFormQuestionComments = component.get('v.deletedFormQuestionComments');
		let commentIndex = deletedFormQuestionComments.findIndex((value) => value.Question__c == questionId);
		if (commentIndex > -1) {
			deletedFormQuestionComments[commentIndex].Action = '';
			displayedFormQuestionComments.push(deletedFormQuestionComments[commentIndex]);
			deletedFormQuestionComments.splice(commentIndex, 1);
		} else {
			let newComment = {
				'Answer__c': '',
				'Parent_Answer_Key__c': questionId,
				'QuestionNo': '',
				'Question_Text__c': '',
				'Question__c': questionId,
				'Flag': 'Local',
			};

			let question = displayedFormQuestions.find((value) => value.Id == newComment.Question__c);
			if (question) {
				let questionNo = String(question.Question__c).split('.');
				newComment.QuestionNo = ($A.util.isArray(questionNo) && !isNaN(questionNo[0])) ? questionNo[0] : '';
				newComment.Question_Text__c = question.Question__c;
			}
			displayedFormQuestionComments.push(newComment);
		}

		displayedFormQuestionComments.sort(helper.sortQuestionNo);

		component.set('v.displayedFormQuestionComments', displayedFormQuestionComments);
	},
	deleteCommentLocal: function (component, event, helper) {
		const { questionId } = event.getParams();

		let displayedFormQuestionComments = component.get('v.displayedFormQuestionComments');
		let commentIndex = displayedFormQuestionComments.findIndex((value) => value.Question__c == questionId);
		if (commentIndex > -1) {
			let deletedFormQuestionComments = component.get('v.deletedFormQuestionComments');
			displayedFormQuestionComments[commentIndex].Action = 'Delete';
			deletedFormQuestionComments.push(displayedFormQuestionComments[commentIndex]);
			component.set('v.deletedFormQuestionComments', deletedFormQuestionComments);

			displayedFormQuestionComments.splice(commentIndex, 1);
		}
		component.set('v.displayedFormQuestionComments', displayedFormQuestionComments);
	},
	saveDraft: function (component, event, helper) {
		component.set('v.status', helper.constants.STATUS.DRAFT);
		helper.savePermitToWork(component, event, helper);
	},
	allowWork: function (component, event, helper) {
		component.set('v.status', helper.constants.STATUS.IN_PROCESS);
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let answer = displayedFormQuestions.find(function (value) {
			return value.Question_API__c == helper.constants.FIELD.STATUS
		});
		answer.Answer__c = helper.constants.STATUS.IN_PROCESS;
		helper.savePermitToWork(component, event, helper);
	},
	holdWork: function (component, event, helper) {
		component.set('v.status', helper.constants.STATUS.ON_HOLD);
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let answer = displayedFormQuestions.find(function (value) {
			return value.Question_API__c == helper.constants.FIELD.STATUS
		});
		answer.Answer__c = helper.constants.STATUS.ON_HOLD;
		helper.savePermitToWork(component, event, helper);
	},
	stopWork: function (component, event, helper) {
		component.set('v.status', helper.constants.STATUS.STOP);
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let answer = displayedFormQuestions.find(function (value) {
			return value.Question_API__c == helper.constants.FIELD.STATUS
		});
		answer.Answer__c = helper.constants.STATUS.STOP;
		helper.savePermitToWork(component, event, helper, function(component, event, helper) {
			helper.closeConfirmStopWorkModal(component, event, helper);
		});
	},
	getVersions: function (formQuestions) {
		let versions = [];
		formQuestions.forEach((value) => { versions.push(value.Version__c) });
		return versions.filter((value, index, self) => self.indexOf(value) === index);
	},
	getSections: function (formQuestions) {
		let sections = [];
		formQuestions.forEach((value) => { sections.push(value.Section__c) });
		return sections.filter((value, index, self) => self.indexOf(value) === index);
	},
	getDataTypes: function (formQuestions) {
		let dataTypes = [];
		formQuestions.forEach((value) => { dataTypes.push(value.Answer_type__c) });
		return dataTypes.filter((value, index, self) => self.indexOf(value) === index);
	},
	showToast: function (type, title, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			mode: 'dismissible',
			duration: 10000,
			title: title,
			message: message,
			type: type,
		});
		toastEvent.fire();
	},
	calculateComplianceScore: function (component, event, helper) {
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let isPTWTypeConfinedSpace = component.get('v.isPTWTypeConfinedSpace');
		let isWorkTypeLifting = component.get('v.isWorkTypeLifting');
		let isPTWTypeColdWork = component.get('v.isPTWTypeColdWork');
		let isWorkTypeGeneral = component.get('v.isWorkTypeGeneral');

		let sections = [
			helper.constants.SECTION.PERMIT_TO_WORK_PREPARATION_APPROVAL,
			helper.constants.SECTION.HAZARDS_IDENTIFICATION_MITIGATIONS_MEASURES,
			helper.constants.SECTION.PRECAUTIONS,
			helper.constants.SECTION.ISOLATION_AND_INHIBIT_OVERRIDE,
			helper.constants.SECTION.PERMIT_TO_WORK_OPENING_REVALIDATION_AND_EXECUTION,
		];

		if (isPTWTypeConfinedSpace) {
			sections.push(helper.constants.SECTION.WORKING_IN_CONFINED_SPACE);
		}

		if (isWorkTypeLifting) {
			sections.push(helper.constants.SECTION.LIFTING);
		}

		if (!isPTWTypeColdWork) {
			sections.push(helper.constants.SECTION.GAS_TESTS);
		}

		let questions = displayedFormQuestions.filter(function (value) {
			//            return value.Section__c == helper.constants.SECTION.PERMIT_TO_WORK_PREPARATION_APPROVAL ||
			//                value.Section__c == helper.constants.SECTION.HAZARDS_IDENTIFICATION_MITIGATIONS_MEASURES ||
			//                value.Section__c == helper.constants.SECTION.PRECAUTIONS ||
			//                value.Section__c == helper.constants.SECTION.GAS_TESTS ||
			//                value.Section__c == helper.constants.SECTION.ISOLATION_AND_INHIBIT_OVERRIDE ||
			//                value.Section__c == helper.constants.SECTION.WORKING_IN_CONFINED_SPACE ||
			//                value.Section__c == helper.constants.SECTION.LIFTING ||
			//                value.Section__c == helper.constants.SECTION.PERMIT_TO_WORK_OPENING_REVALIDATION_AND_EXECUTION
			return sections.indexOf(value.Section__c) > -1;
		});

		let numberOfNotAvailable = questions.filter((value) => value.Answer__c == 'N/A').length;
		let numberOfYes = questions.filter((value) => value.Answer__c == 'Yes').length;
		let numberOfNo = questions.filter((value) => value.Answer__c == 'No').length;
		let numberOfYesAndNo = numberOfYes + numberOfNo;
		let percentOfCompliance = (numberOfYesAndNo > 0) ? numberOfYes / numberOfYesAndNo : 0;

		let fieldNoCompliance = displayedFormQuestions.find((value) => value.Question_API__c == helper.constants.FIELD.NO_COMPLIANCE);
		fieldNoCompliance && (fieldNoCompliance.Answer__c = numberOfYes);
		let fieldNoNonCompliance = displayedFormQuestions.find((value) => value.Question_API__c == helper.constants.FIELD.NO_NON_COMPLIANCE);
		fieldNoNonCompliance && (fieldNoNonCompliance.Answer__c = numberOfNo);
		let fieldPercentCompliance = displayedFormQuestions.find((value) => value.Question_API__c == helper.constants.FIELD.PERCENT_COMPLIANCE);
		fieldPercentCompliance && (fieldPercentCompliance.Answer__c = percentOfCompliance);

		setTimeout(function() {
			component.set('v.displayedFormQuestions', displayedFormQuestions);
		}, 2000)
	},
	isPTWTypeConfinedSpace: function (component, event, helper) {
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let type = false;
		for (let key in displayedFormQuestions) {
			if (displayedFormQuestions[key].Question_API__c == helper.constants.FIELD.PTW_TYPE
				&& displayedFormQuestions[key].Answer__c == 'Confined Space Entry') {
				type = true;
				break;
			}
		}
		return type;
	},
	isWorkTypeLifting: function (component, event, helper) {
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let type = false;
		for (let key in displayedFormQuestions) {
			if (displayedFormQuestions[key].Question_API__c == helper.constants.FIELD.WORK_TYPE
				&& displayedFormQuestions[key].Answer__c == 'Crane/Lifting') {
				type = true;
				break;
			}
		}
		return type;
	},
	isPTWTypeColdWork: function (component, event, helper) {
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let type = false;
		for (let key in displayedFormQuestions) {
			if (displayedFormQuestions[key].Question_API__c == helper.constants.FIELD.PTW_TYPE
				&& displayedFormQuestions[key].Answer__c == 'Cold Work') {
				type = true;
				break;
			}
		}
		return type;
	},
	isWorkTypeGeneral: function (component, event, helper) {
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let type = false;
		for (let key in displayedFormQuestions) {
			if (displayedFormQuestions[key].Question_API__c == helper.constants.FIELD.WORK_TYPE
				&& displayedFormQuestions[key].Answer__c == 'งานทั่วไป') {
				type = true;
				break;
			}
		}
		return type;
	},
	getPTWType: function (component, event, helper) {
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let ptwType = '';
		for (let key in displayedFormQuestions) {
			if (displayedFormQuestions[key].Question_API__c == helper.constants.FIELD.PTW_TYPE) {
				ptwType = displayedFormQuestions[key].Answer__c;
				break;
			}
		}
		return ptwType;
	},
	getWorkType: function (component, event, helper) {
		let displayedFormQuestions = component.get('v.displayedFormQuestions');
		let workType = [''];
		for (let key in displayedFormQuestions) {
			if (displayedFormQuestions[key].Question_API__c == helper.constants.FIELD.WORK_TYPE) {
				workType = displayedFormQuestions[key].Answer__c || '';
				workType = workType.split(',');
				break;
			}
		}
		return workType;
	},
	setSectionAndDependencyPicklist: function (component, event, helper) {
		let displayedFormQuestions = component.get('v.displayedFormQuestions');

		let answerPtwSubType;
		let answerWorkType;
		let answerQuestion14;
		let answerQuestion15;
		let answerQuestion16;
		let answerQuestion17;
		let answerQuestion18;
		let answerQuestion19;
		let answerQuestion38;
		let status;
		
		for (let key in displayedFormQuestions) {
			switch (displayedFormQuestions[key].Question_API__c) {
				case helper.constants.FIELD.PTW_SUB_TYPE:
					answerPtwSubType = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.WORK_TYPE:
					answerWorkType = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_14:
					answerQuestion14 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_15:
					answerQuestion15 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_16:
					answerQuestion16 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_17:
					answerQuestion17 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_18:
					answerQuestion18 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_19:
					answerQuestion19 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_38:
					answerQuestion38 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.STATUS:
					status = displayedFormQuestions[key];
					break;
			}

			if (answerPtwSubType && answerWorkType && answerQuestion38) {
				break;
			}
		}

		let ptwType = helper.getPTWType(component, event, helper);
		switch (String(ptwType).toLowerCase()) {
			case 'hot work':
				component.set('v.isPTWTypeColdWork', false);
				component.set('v.isPTWTypeConfinedSpace', false);

				if (answerPtwSubType) {
					answerPtwSubType.Picklist = ['', 'HW Open Frame', 'HW Non-Open Frame'];
					answerPtwSubType.Disabled = false;
				}
				if (answerWorkType) {
					answerWorkType.Picklist = answerWorkType.PicklistMaster;
					answerWorkType.Disabled = false;
				}
				break;
			case 'cold work':
				component.set('v.isPTWTypeColdWork', true);
				component.set('v.isPTWTypeConfinedSpace', false);

				if (answerPtwSubType) {
					answerPtwSubType.Picklist = [];
					answerPtwSubType.Disabled = true;
				}
				if (answerWorkType) {
					answerWorkType.Picklist = ['', 'งานทั่วไป', 'Digging', 'Work at Height'];
					answerWorkType.Disabled = false;
				}
				break;
			case 'confined space entry':
				component.set('v.isPTWTypeColdWork', false);
				component.set('v.isPTWTypeConfinedSpace', true);

				if (answerPtwSubType) {
					answerPtwSubType.Picklist = answerPtwSubType.PicklistMaster;
					answerPtwSubType.Disabled = false;
				}
				if (answerWorkType) {
					answerWorkType.Picklist = answerWorkType.PicklistMaster;
					answerWorkType.Disabled = false;
				}
				break;
			default:
				component.set('v.isPTWTypeColdWork', false);
				component.set('v.isPTWTypeConfinedSpace', false);

				if (answerPtwSubType) {
					answerPtwSubType.Picklist = [];
					answerPtwSubType.Disabled = true;
				}
				if (answerWorkType) {
					answerWorkType.Picklist = [];
					answerWorkType.Disabled = true;
				}
				break;
		}
		if (status.Answer__c == helper.constants.STATUS.STOP || status.Answer__c == helper.constants.STATUS.IN_PROCESS) {
			answerWorkType.Disabled = true;
		}

		let workType = helper.getWorkType(component, event, helper);

		component.set('v.isWorkTypeGeneral', false);
		component.set('v.isWorkTypeLifting', false);

		if (helper.isInitialized) {

			if (workType.indexOf('งานทั่วไป') > -1) {
				component.set('v.isWorkTypeGeneral', true);
	
				if (answerQuestion38) {
					answerQuestion38.Answer__c = (workType.length === 1) ? 'N/A' : '';
					answerQuestion38.Disabled = (workType.length === 1);
				}
			} else {
				if (answerQuestion38) {
				answerQuestion38.Answer__c = '';
				answerQuestion38.Disabled = false;
				}
			}
		}
		helper.isInitialized = true;

		if (workType.indexOf('Crane/Lifting') > -1) {
			component.set('v.isWorkTypeLifting', true);
		}

		/*
		switch (String(workType).toLowerCase()) {
			case 'งานทั่วไป':
				component.set('v.isWorkTypeGeneral', true);
				component.set('v.isWorkTypeLifting', false);

				if (answerQuestion38) {
					answerQuestion38.Answer__c = 'N/A';
					answerQuestion38.Disabled = true;
				}
				break;
			case 'crane/lifting':
				component.set('v.isWorkTypeGeneral', false);
				component.set('v.isWorkTypeLifting', true);

				if (answerQuestion38) {
					//answerQuestion38.Answer__c = '';
					answerQuestion38.Disabled = false;
				}
				break;
			default:
				component.set('v.isWorkTypeGeneral', false);
				component.set('v.isWorkTypeLifting', false);

				if (answerQuestion38) {
					//answerQuestion38.Answer__c = '';
					answerQuestion38.Disabled = false;
				}
				break;
		}
		*/

		component.set('v.displayedFormQuestions', displayedFormQuestions);
	},
	deleteFile: function (component, event, helper) {
		var attactmentId = event.getSource().get('v.name');
		let action = component.get('c.deleteFile');
		action.setParams({ fileId: attactmentId });
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					// title: title,
					message: 'File Deleted',
					type: 'success'
				});
				toastEvent.fire();

				helper.getFilesRelated(component, event, helper);
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
	sortQuestionNo: function (a, b) {
		if (Number(a.QuestionNo) > Number(b.QuestionNo)) {
			return 1;
		} else if (Number(a.QuestionNo) < Number(b.QuestionNo)) {
			return -1;
		} else {
			return 0;
		}
	},
	createNewInspection: function(component, event, helper) {
		try {
			component.set('v.isLoadingRecord', true);
			component.set('v.hasChanged', true);
			helper.displaySelectedFormQuestions(component, event, helper, 'New');
			helper.defaultValues(component, event, helper);
		} catch (ex) {
			helper.showToast('error', 'Cannot load Permit to Work Inspection, Please contact System Administrator.', `${ex.message}`);
		} finally {
			setTimeout($A.getCallback(function () {
				component.set('v.selectedFormQuestions', 'New');
				component.set('v.isLoadingRecord', false);
			}), 1000);
		}
	},
	defaultValues: function(component, event, helper) {
		let displayedFormQuestions = component.get('v.displayedFormQuestions');

		let answerQuestion14;
		let answerQuestion15;
		let answerQuestion16;
		let answerQuestion17;
		let answerQuestion18;
		let answerQuestion19;

		for (let key in displayedFormQuestions) {
			switch (displayedFormQuestions[key].Question_API__c) {
				case helper.constants.FIELD.INSPECTION_QUESTION_14:
					answerQuestion14 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_15:
					answerQuestion15 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_16:
					answerQuestion16 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_17:
					answerQuestion17 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_18:
					answerQuestion18 = displayedFormQuestions[key];
					break;
				case helper.constants.FIELD.INSPECTION_QUESTION_19:
					answerQuestion19 = displayedFormQuestions[key];
					break;
			}
		}

		if (answerQuestion14) {
			answerQuestion14.Answer__c = 'N/A';
		}
		if (answerQuestion15) {
			answerQuestion15.Answer__c = 'N/A';
		}
		if (answerQuestion16) {
			answerQuestion16.Answer__c = 'N/A';
		}
		if (answerQuestion17) {
			answerQuestion17.Answer__c = 'N/A';
		}
		if (answerQuestion18) {
			answerQuestion18.Answer__c = 'N/A';
		}
		if (answerQuestion19) {
			answerQuestion19.Answer__c = 'N/A';
		}
	},
	openConfirmStopWorkModal: function(component, event, helper) {
		scroll(0, 0);
		$A.util.addClass(component, 'show-modal');
		component.set('v.isConfirmStopWorkModalOpen', true);
	},
	closeConfirmStopWorkModal: function(component, event, helper) {
		$A.util.removeClass(component, 'show-modal');
		component.set('v.isConfirmStopWorkModalOpen', false);
	},
	openConfirmSavePTWModal: function (component, event, helper) {
		scroll(0, 0);
		$A.util.addClass(component, 'show-modal');
		component.set('v.isConfirmSavePTWModalOpen', true);
	},
	closeConfirmSavePTWModal: function (component, event, helper) {
		$A.util.removeClass(component, 'show-modal');
		component.set('v.isConfirmSavePTWModalOpen', false);
	},
});