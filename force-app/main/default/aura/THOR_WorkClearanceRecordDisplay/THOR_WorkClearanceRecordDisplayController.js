({
	closeWorkClearance: function (component, event, helper) {
		//var openModalEvent = $A.get('e.c:THOR_openWorkClearanceEditModal');
		//openModalEvent.setParam('modal', 'THOR_WorkClearanceCloseModal');
		//openModalEvent.fire();

		try {
			component.find('navService').navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${window.btoa(
							JSON.stringify({
								componentDef: `c:THOR_WorkClearanceCloseModal`,
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

	continue: function (component, event, helper) {
		//var openModalEvent = $A.get('e.c:THOR_openWorkClearanceEditModal');
		//openModalEvent.setParam('modal', 'THOR_WorkClearanceContinueModal');
		//openModalEvent.fire();

		try {
			component.find('navService').navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${window.btoa(
							JSON.stringify({
								componentDef: `c:THOR_WorkClearanceContinueModal`,
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

	discardWorkClearance: function (component, event, helper) {
		var isDiscard = event && event.getSource().get('v.name') === 'discard';
		if (isDiscard) {
			var navService = component.find('navService');
			event.preventDefault();
			component.find('recordLoader').deleteRecord();
			let work = component.get('v.workClearance');
			if (work.Notification__c) {
				navService.navigate(
					{
						type: 'standard__component',
						attributes: {
							componentName: 'c__THOR_NotificationRecordDisplay'
						},
						state: {
							c__recordId: work.Notification__c
						}
					},
					false
				);
			} else if (work.Order__c) {
				navService.navigate(
					{
						type: 'standard__component',
						attributes: {
							componentName: 'c__THOR_OrderRecordDisplay'
						},
						state: {
							c__recordId: work.Order__c
						}
					},
					false
				);
			} else {
				navService.navigate(
					{
						type: 'standard__navItemPage',
						attributes: {
							apiName: 'Work_Clearances'
						}
					},
					true
				);
			}
		}

		component.set('v.isModalAction.discard', !component.get('v.isModalAction.discard'));
	},

	pinMap: function(component, event, helper) {
		// helper.getWorkClearance(component, event, helper);
		component.set('v.isModalAction.pinMap', !component.get('v.isModalAction.pinMap'));
	},

	savePinMap: function(component, event, helper) {
		helper.getWCAfterClickSavePinMap(component, event, helper);
		helper.makeToast('success', 'Success', 'Work Clearance Location have been save successfully');
		component.set('v.isModalAction.pinMap', !component.get('v.isModalAction.pinMap'));

		console.log('cmp.get lat:',component.get('v.lat'),'- cmp.get lng:',component.get('v.lng'));
		var latitude = component.get('v.lat');
		var longitude = component.get('v.lng');

	},

	doInit: function (component, event, helper) {
		let pageref = component.get('v.pageReference');
		if (pageref) {
			let { c__recordId, c__isHistorical } = pageref.state;
			if (!component.get('v.recordId')) {
				component.set('v.recordId', c__recordId);
			} else if (c__recordId && c__recordId != component.get('v.recordId')) {
				component.set('v.recordId', c__recordId);
			}
			component.set('v.isHistorical', c__isHistorical == true || false);
		}
		component.find('recordLoader').reloadRecord(true);

		//		let pageref = component.get('v.pageReference');
		//		if (pageref && !component.get('v.recordId')) {
		//			let { c__recordId } = pageref.state;
		//			component.set('v.recordId', c__recordId);
		//		}

		helper.handleSetInterval(component);
		helper.handleSetTimeout(component);

		helper.getWorkClearance(component, event, helper);
		helper.getUserRecordEditAccess(component);

		//		var recordLoader = component.find('recordLoader');

		//		var intervalGetInfo = setInterval(
		//			$A.getCallback(() => {
		//
		//				try {
		//					if (component.find('recordLoader')) {
		//						component.find('recordLoader').reloadRecord(true)
		//					};
		//				} catch(e) {
		//					console.log(e);
		//				}
		//				recordLoader.reloadRecord(true);
		//			}),
		//			5000
		//		);
		//		component.set('v.interval', intervalGetInfo);
	},

	extendDay: function (component, event, helper) {
		//var openModalEvent = $A.get('e.c:THOR_openWorkClearanceEditModal');
		//openModalEvent.setParam('modal', 'THOR_WorkClearanceExtendDayModal');
		//openModalEvent.fire();

		try {
			component.find('navService').navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${window.btoa(
							JSON.stringify({
								componentDef: `c:THOR_WorkClearanceExtendDayModal`,
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

	extendHours: function (component, event, helper) {
		//var openModalEvent = $A.get('e.c:THOR_openWorkClearanceEditModal');
		//openModalEvent.setParam('modal', 'THOR_WorkClearanceExtendHoursModal');
		//openModalEvent.fire();

		try {
			component.find('navService').navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${window.btoa(
							JSON.stringify({
								componentDef: `c:THOR_WorkClearanceExtendHoursModal`,
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

	extendDuringRepair: function (component, event, helper) {
		var isExtendDuringRepair = event && event.getSource().get('v.name') === 'extendDuringRepair';
		if (isExtendDuringRepair) {
			console.log({ isExtendDuringRepair });
			component.find('extendDuringRepairButton').submit_click();
			// component.find('extendDuringRepairForm').submit();
		} else {
			component.set('v.isModalAction.extendDuringRepair', !component.get('v.isModalAction.extendDuringRepair'));
		}
	},

	fireModalEvent: function (component, event) {
		//var openModalEvent = $A.get('e.c:THOR_openWorkClearanceEditModal');
		//openModalEvent.setParam('modal', 'THOR_WorkClearanceEditModal');
		//openModalEvent.fire();
		try {
			component.find('navService').navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${window.btoa(
							JSON.stringify({
								componentDef: `c:THOR_WorkClearanceEditModal`,
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

	handleRecordUpdated: function (component, event, helper) {
		try {
			// console.log('handleRecordUpdated');
			// console.log(component.get('v.workClearanceRecord.Integration_Status__c'));
			component.set(
				'v.isAlertIntegration', //!component.get('v.workClearanceRecord.Integration_Status__c') ||
				component.get('v.workClearanceRecord.Integration_Status__c') === 'Failed'
			);

			let statusBefore = component.get('v.integrationStatus');
			let statusAfter = component.get('v.workClearanceRecord.Integration_Status__c');
			let systemStatusBefore = component.get('v.systemStatus');
			let systemStatusAfter = component.get('v.workClearanceRecord.System_Status__c');
			component.set('v.integrationStatus', statusAfter);
			if (statusBefore != statusAfter) {
				helper.getWorkClearance(component, event, helper);
			}

			let isClosed = component.get('v.workClearanceRecord.User_Status__c');
			if (String(isClosed).indexOf('WCCL') > -1) {
				component.set('v.isClosed', true);
			}
			if (
				component.get('v.workClearanceRecord.User_Status__c') &&
				component.get('v.workClearanceRecord.User_Status__c').includes('EXTH') // &&
				//component.get('v.workClearanceRecord.User_Status__c').includes('EXTD')
			) {
				component.set('v.isUserStatusExtendDuringRepair', true);
			}
			if (component.get('v.workClearanceRecord.System_Status__c') == 'CLSD') {
				component.set('v.isClosed', true);
			}

			//let lastUserAction = component.get('v.workClearanceRecord.Last_User_Action__c');
			let lastUserAction = component.get('v.workClearanceRecord.User_Status__c');
			if (lastUserAction && (lastUserAction.indexOf('WIP1') > -1 || lastUserAction.indexOf('WIP2') > -1)) {
				component.set('v.isTemporaryClosed', true);
			}

			let workClearanceNumber = component.get('v.workClearanceRecord.Name');
			if (workClearanceNumber.length <= 9) {
				component.set('v.hasWorkClearanceNumber', true);
			}

			//			if (component.get('v.workClearanceRecord.Integration_Status__c') === 'Failed' || component.get('v.workClearanceRecord.Integration_Status__c') === 'Success') {
			//				clearInterval(component.get('v.interval'));
			//				component.set('v.interval', null);
			//			}
			//
			//			let pageref = component.get('v.pageReference');
			//			if (pageref) {
			//				let { c__recordId } = pageref.state;
			//				if (c__recordId && c__recordId != component.get('v.recordId')) {
			//					$A.get('e.force:refreshView').fire();
			//				}
			//			}
		} catch (e) {
			console.log(e);
		}
	},

	recordLoadError: function (component, event, helper) {
		console.log('Error');
	},

	closeAlertIntegration: function (component, event, helper) {
		component.set('v.isAlertIntegration', false);
	},

	handleSelectButtonMenu: function (component, event, helper) {
		var selectedFunc = event.getParam('value');
		if (selectedFunc) $A.enqueueAction(component.get(selectedFunc));
	},

	handleLoad: function (component, event, helper) {
		console.log('handleLoad');
		var recordUi = event.getParam('recordUi');
		console.log(JSON.parse(JSON.stringify(recordUi)));
	},

	handleSubmit: function (component, event, helper) {
		// event.preventDefault();
		helper.startLoading(component);
		console.log('handleSubmit');
		console.log(JSON.parse(JSON.stringify(event.getParams())));
	},

	handleSuccess: function (component, event, helper) {
		helper.stopLoading(component);
		helper.makeToast('success', 'Success', 'Work Clearance have been resended');
		$A.get('e.force:refreshView').fire();
	},

	handleError: function (component, event, helper) {
		helper.stopLoading(component);
		try {
			var paramsErr = event.getParams();
			const {
				output: { fieldErrors, errors, params }
			} = paramsErr;
			// console.error({ paramsErr: JSON.parse(JSON.stringify(paramsErr)), fieldErrors, errors });
			// const getError = (obj) => (Array.isArray(obj) ? obj[0] : {});
			// const { fieldLabel, message } = getError((Object.keys(fieldErrors).length ? fieldErrors : null) || errors);
			const { errorCode, fieldLabel, message } =
				(Object.keys(fieldErrors).length && fieldErrors[Object.keys(fieldErrors)[0]][0]) ||
				(errors ? errors[0] : params);

			if (fieldLabel) {
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: fieldLabel || errorCode,
					type: 'error',
					message: message || 'Something went wrong!'
				});
				toastEvent.fire();
			}
		} catch (error) {
			console.error(error);
		}
	},

	handleTimeoutFormError: function (component, event, helper) {
		helper.stopLoading(component);
		try {
			var params = event.getParams();
			const {
				output: { fieldErrors, errors }
			} = params;
			const { errorCode, fieldLabel, message } =
				(Object.keys(fieldErrors).length && fieldErrors[Object.keys(fieldErrors)[0]][0]) || errors[0];

			if (errorCode == 'INSUFFICIENT_ACCESS') {
				return;
			}

			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				title: fieldLabel || errorCode,
				type: 'error',
				message: message
			});
			toastEvent.fire();
		} catch (e) {
			console.error(e);
		}
	},

	openPDF: function (component, event, helper) {
		var recordId = component.get('v.recordId');
		var url = '/apex/WorkclearancePdf?id=' + recordId;
		var urlEvent = $A.get('e.force:navigateToURL');
		urlEvent.setParams({
			url: url
		});
		urlEvent.fire();
	},

	preview: function (component, event, helper) {
		var index = event.currentTarget.id;

		$A.get('e.lightning:openFiles').fire({
			recordIds: [index]
		});
	},

	recordLoadError: function (component, event, helper) {
		console.log('recordLoadError');
	},

	resendWorkClearance: function (component, event, helper) {
		var isResend = event && event.getSource().get('v.name') === 'resend';
		if (isResend && component.find('recordEditForm')) {
			component.find('recordEditForm').submit();
		}
		component.set('v.isModalAction.resend', !component.get('v.isModalAction.resend'));
	},

	viewMore: function (component, event, helper) {
		component.set('v.showViewMore', false);
	},

	viewLess: function (component, event, helper) {
		component.set('v.showViewMore', true);
	}
});