({
	startLoading: function (component) {
    component.set('v.isLoading', true);
  },
	stopLoading: function (component) {
    component.set('v.isLoading', false);
  },
	makeToast: function (type, title, message) {
		var toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			title: title,
			message: message,
			type: type
		});
		toastEvent.fire();
	},
	handleSetTimeout: function (component) {
		setTimeout(
			$A.getCallback(() => {
				console.warn('Timeout');
				// component.get('v.workClearanceRecord.Integration_Status__c');
				console.log(component.get('v.workClearanceRecord.Integration_Status__c'));
				console.log(component.find('recordTimeoutForm'));
				if (component.get('v.workClearanceRecord.Integration_Status__c') === 'In Progress') {
					component.find('recordTimeoutForm').submit();
				}
			}),
			120 * 1000
		);
	},
	handleSetInterval: function (component) {
		var intervalGetInfo = setInterval(
			$A.getCallback(() => {
				if (
					component.find('recordLoader') &&
					component.get('v.workClearanceRecord.Integration_Status__c') &&
					component.get('v.workClearanceRecord.Integration_Status__c') === 'In Progress'
				) {
					component.find('recordLoader').reloadRecord(true);
				} else if (
					component.get('v.interval') &&
					component.find('recordLoader') &&
					component.get('v.workClearanceRecord.Integration_Status__c') !== 'In Progress'
				) {
					console.warn('clearInterval');
					clearInterval(component.get('v.interval'));
					component.set('v.interval', null);
				}
			}),
			5000
		);
		component.set('v.interval', intervalGetInfo);
	},
	getUserRecordEditAccess: function (component) {
		let action = component.get('c.getUserRecordEditAccess');
		action.setParams({
			recordId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let returnValue = response.getReturnValue();
				// console.log({ hasEditAccess: returnValue });
				component.set('v.hasEditAccess', returnValue || false);
			} else if (state === 'ERROR') {
				let errors = response.getError();
				console.error(errors);
			}
		});
		$A.enqueueAction(action);
	},

	getWorkClearance: function (component, event, helper) {
		let action = component.get('c.getWorkClearanceById');

		action.setParams({ 
			workclearanceIdentifier: component.get('v.recordId')});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let returnValue = response.getReturnValue();
				/** retrieve "Lattitude and Longitude " from db to check if not null >> display those value */
				console.log('returnValue > ',returnValue);
				if(returnValue.Latitude__c != null) {
					component.set('v.lat', returnValue.Latitude__c);
				}
				if(returnValue.Longitude__c != null) {
					component.set('v.lng', returnValue.Longitude__c);
				}

				returnValue.Extend_Date_Text__c =
					returnValue.Extend_Date__c && $A.localizationService.formatDate(returnValue.Extend_Date__c, 'DD/MM/YYYY');
				returnValue.Extend_Time_Text__c =
					returnValue.Extend_Time__c &&
					$A.localizationService.formatDate(returnValue.Extend_Time__c - 25200000, 'HH:mm:ss');

				component.set('v.workClearance', returnValue);
				helper.truncWorkDetail(component);

				component.set('v.extendNo', '');
				let extendNo = returnValue.Extend_No__c;
				if (extendNo) {
					extendNo = Number(extendNo);
					if (!isNaN(extendNo)) {
						component.set('v.extendNo', String(extendNo));
					}
				}

				helper.getAreaDescriptionByCode(component, event, helper);
				helper.getPISUserName(component, event, helper);
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

			component.set('v.isLoading', false);
			//this.stopLoading(component);
		});
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},
	getWCAfterClickSavePinMap: function (component, event, helper) {
		let action = component.get('c.getWCByIdAfterClickSavePinMap');

		action.setParams({ 
			workclearanceIdentifier: component.get('v.recordId'),
			latitude: component.get('v.lat'),
			longitude: component.get('v.lng')});
			// latitude: component.get('v.workClearance.Latitude__c'),
			// longitude: component.get('v.workClearance.Longitude__c')
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				$A.get('e.force:refreshView').fire();
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

			component.set('v.isLoading', false);
			//this.stopLoading(component);
		});
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},

	getAreaDescriptionByCode: function (component, event, helper) {
		var wc = component.get('v.workClearance');
		if (!$A.util.isEmpty(wc.Area__c)) {
			let action = component.get('c.getAreaDescriptionByCode');

			action.setParams({
				areaCode: wc.Area__c
			});
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					let returnValue = response.getReturnValue();
					if (!$A.util.isEmpty(returnValue)) {
						component.set('v.workClearance.Area_Text__c', `${returnValue.Description__c}`);
					} else {
						component.set('v.workClearance.Area_Text__c', wc.Area__c);
					}
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

	getPISUserName: function(component, event, helper) {
		var wc = component.get('v.workClearance');
		if (!$A.util.isEmpty(wc.Area__c)) {
			let action = component.get('c.getPISUsers');

			let hostOrHomeIdList = [
				// wc.Requester__c,
				wc.Thaioil_Supervisor_Indicator__c,
				wc.Authorized_Signature__c,
				wc.Authorized_Signatory__c,
				wc.Extend_Applicant_or_Bearer__c,
				wc.Extend_Authorized_Sign__c,
				wc.Close_Applicant_or_Bearer__c,
				wc.Close_Authorized_Sign_off__c
			].filter(function(value) { 
				return (!$A.util.isEmpty(value)); 
			});

			action.setParams({
				hostOrHomeIdList: hostOrHomeIdList
			});
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					let returnValue = response.getReturnValue();
					if (!$A.util.isEmpty(returnValue)) {
						// if (wc.Requester__c && returnValue[wc.Requester__c]) {
						// 	wc.Requester__c = `${returnValue[wc.Requester__c].ENFIRSTNAME__c} ${returnValue[wc.Requester__c].ENLASTNAME__c}`
						// }
						if (wc.Thaioil_Supervisor_Indicator__c && returnValue[wc.Thaioil_Supervisor_Indicator__c]) {
							wc.Thaioil_Supervisor_Indicator__c = `${returnValue[wc.Thaioil_Supervisor_Indicator__c].ENFIRSTNAME__c} ${returnValue[wc.Thaioil_Supervisor_Indicator__c].ENLASTNAME__c}`
						}
						if (wc.Authorized_Signature__c && returnValue[wc.Authorized_Signature__c]) {
							wc.Authorized_Signature__c = `${returnValue[wc.Authorized_Signature__c].ENFIRSTNAME__c} ${returnValue[wc.Authorized_Signature__c].ENLASTNAME__c}`
						}
						if (wc.Authorized_Signatory__c && returnValue[wc.Authorized_Signatory__c]) {
							wc.Authorized_Signatory__c = `${returnValue[wc.Authorized_Signatory__c].ENFIRSTNAME__c} ${returnValue[wc.Authorized_Signatory__c].ENLASTNAME__c}`
						}
						if (wc.Extend_Applicant_or_Bearer__c && returnValue[wc.Extend_Applicant_or_Bearer__c]) {
							wc.Extend_Applicant_or_Bearer__c = `${returnValue[wc.Extend_Applicant_or_Bearer__c].ENFIRSTNAME__c} ${returnValue[wc.Extend_Applicant_or_Bearer__c].ENLASTNAME__c}`
						}
						if (wc.Extend_Authorized_Sign__c && returnValue[wc.Extend_Authorized_Sign__c]) {
							wc.Extend_Authorized_Sign__c = `${returnValue[wc.Extend_Authorized_Sign__c].ENFIRSTNAME__c} ${returnValue[wc.Extend_Authorized_Sign__c].ENLASTNAME__c}`
						}
						if (wc.Close_Applicant_or_Bearer__c && returnValue[wc.Close_Applicant_or_Bearer__c]) {
							wc.Close_Applicant_or_Bearer__c = `${returnValue[wc.Close_Applicant_or_Bearer__c].ENFIRSTNAME__c} ${returnValue[wc.Close_Applicant_or_Bearer__c].ENLASTNAME__c}`
						}
						if (wc.Close_Authorized_Sign_off__c && returnValue[wc.Close_Authorized_Sign_off__c]) {
							wc.Close_Authorized_Sign_off__c = `${returnValue[wc.Close_Authorized_Sign_off__c].ENFIRSTNAME__c} ${returnValue[wc.Close_Authorized_Sign_off__c].ENLASTNAME__c}`
						}
						component.set('v.workClearance', wc);
						let wc1 = component.get('v.workClearance');
					}
				}
			});
			$A.enqueueAction(action);
		}
	},

	truncWorkDetail: function (component) {
		let workClearance = component.get('v.workClearance');
		if (workClearance) {
			let workDetail = workClearance.Work_Detail__c;
			let userStatus = workClearance.User_Status__c;
			//let type = workClearance.Type__c;

			component.set('v.workDetail', workDetail);
			//component.set('v.userStatus', userStatus);
			//component.set('v.type', type);

			if (workDetail) {
				workDetail = workDetail.replace(/\n/g, '<br />');
			}

			component.set('v.allText', workDetail);

			if (workDetail && workDetail.length > 200) {
				let truncatedText = workDetail.slice(0, 200);
				component.set('v.showViewMore', true);
				component.set('v.showViewLess', true);
				component.set('v.truncatedText', truncatedText);
			}
		}
	}
});