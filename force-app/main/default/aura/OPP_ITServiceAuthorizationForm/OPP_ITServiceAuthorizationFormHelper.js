({
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},
	hanldeAfterCloseModal: function (component, event, helper) {
		event.preventDefault();
		if (component.get('v.formFactor') === 'PHONE') {
			var navService = component.find('navService');
			navService.navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: '/apex/previous_back'
					}
				},
				true
			);
		} else {
			var navigateToURL = $A.get('e.force:navigateToURL');
			navigateToURL.setParams({
				isredirect: true,
				url: '/lightning/n/DG_Service'
			});
			navigateToURL.fire();
		}
	},
	deleteDGRequestCaseById: function (component, caseId) {
		var action = component.get('c.deleteDGRequestCaseById');
		action.setParams({
			recordId: caseId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
			} else {
				var errors = response.getError();
				errors.forEach(function (error) {
					console.error(error);
				});
			}
		});
		$A.enqueueAction(action);
	},
	getRequesterType: function (component, userId) {
		var helper = this;
		var action = component.get('c.requesterType');
		action.setParams({
			recordId: userId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				const { User_Type__c } = result;
				component.set('v.pisUserType', User_Type__c);
			} else {
				component.set('v.pisUserType', null);
				var errors = response.getError();
				console.error(helper.parseObject(errors));
			}
		});
		if (userId) {
			$A.enqueueAction(action);
		} else {
			// do something...
		}
	},
	getIsEmployee: function (component) {
		var action = component.get('c.isEmployee');
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.isEmployee', result);
			}
		});
		$A.enqueueAction(action);
	},
	getCaseInfo: function (component, event, helper) {
		var action = component.get('c.getAuthorizationCase');
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.case', result);
                
                var requester = component.get('v.case.Requester__c');
                console.log('requesterType >>'+requester);
                if(requester){
                    helper.getRequesterType(component, requester);
                }
			}
		});
		$A.enqueueAction(action);
	},
	getCaseRecordTpyeInfoes: function (component, event, helper) {
		var action = component.get('c.getCaseRecordTpyeInfoes');
		action.setStorable();
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.recordTypeIdsMap.Case', result);
			}
		});
		$A.enqueueAction(action);
	},
	getCaseLineItemRecordTpyeInfoes: function (component, event, helper) {
		var action = component.get('c.getCaseLineItemRecordTpyeInfoes');
		action.setStorable();
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.recordTypeIdsMap.OPP_Case_Line_Items__c', result);
			}
		});
		$A.enqueueAction(action);
	},
	getPicklistValuesMap: function (component, sobjectName, fieldName) {
		var action = component.get('c.getCasePicklistValues');
		action.setParams({
			sobjectName: sobjectName,
			fieldName: fieldName
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set(
					`v.picklistMap.${sobjectName}.${fieldName}`,
					Object.keys(result).map((key) => ({
						label: result[key],
						value: key
					}))
				);
			} else {
				var error = response.getError();
				console.error(error);
			}
		});
		$A.enqueueAction(action);
	},
	getDescribeFieldResult: function (component, sObjectName, fields) {
		var action = component.get('c.getDescribeFieldResult');
		action.setParams({
			sObjectName: sObjectName,
			fields: fields
		});
		action.setStorable();
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set(`v.describeFields.${sObjectName}`, result);
			} else {
				var error = response.getError();
				console.error(error);
			}
		});
		$A.enqueueAction(action);
	},
	createCaseLineItem: function (component, event, helper) {
		// console.log(JSON.parse(JSON.stringify(event.getParams())));
		var params = event.getParams();
		var response = params.response;
		var caseId = response.id;

		// var records = component.get('v.case.User_Type__c') === 'External Consultant'
		// 	? component.get('v.records_authority').concat(component.get('v.records_network'))
		// 	: component.get('v.records_authority')
		var records = component.get('v.records_authority');

		var action = component.get('c.saveCaseLineItem');
		action.setParams({
			records: records,
			caseId: caseId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Success!',
					message: $A.get(component.get('v.autoApproval') ? '$Label.c.DG_Service_Auto_Submit_Success' : '$Label.c.DG_Service_Save_as_Draft'),
					duration: '5000',
					key: 'info_alt',
					type: 'success',
					mode: 'pester'
				});
				toastEvent.fire();

				helper.hanldeAfterCloseModal(component, event, helper);
			} else if (state === 'ERROR') {
				var error = response.getError();
				error.forEach((e) => {
					console.error(e);
					component.find('messages').setError(e.message);
				});
				helper.deleteDGRequestCaseById(component, caseId);
			}

			component.set('v.isLoading', false);
		});
		$A.enqueueAction(action);
	},
	uploadFile: function (component, event, helper) {
		var params = event.getParams();
		var response = params.response;
		component.get('v.uploadedFiles').forEach((file) => {
			var action = component.get('c.uploadFile');
			action.setParams({
				base64: file.base64,
				filename: file.filename,
				recordId: response.id
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === 'SUCCESS') {
					var result = response.getReturnValue();
				} else if (state === 'ERROR') {
					var error = response.getError();
					error.forEach((e) => console.error(e));
				}
				component.set('v.isLoading', false);
			});
			if (component.get('v.case.User_Type__c') !== 'Employee') {
				$A.enqueueAction(action);
			}
		});
	},
	findCmp: function (component, auraId, name) {
		var cmp = component.find(auraId);
		if (cmp) {
			cmp = Array.isArray(cmp) ? cmp : [cmp];
			cmp = cmp.find((f) => f.get('v.name') == name);
			cmp.showHelpMessageIfInvalid();
			cmp.reportValidity();
		}
		return cmp;
	}
});