({
	parseObject: function (obj) {
		return JSON.parse(JSON.stringify(obj));
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
		var action = component.get('c.getITStationeryCase');
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
				component.set('v.recordTypeIdsMap', result);
				// component.set("v.case.RecordTypeId",
				//     component.get('v.recordTypeIdsMap.Hardware_Catalog.recordTypeId'))
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
					`v.picklistMap.${fieldName}`,
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
		var params = event.getParams();
		var caseId = params.response.id;

		var records = ['Standard Items'].includes(component.get('v.case.Stationery_Type__c'))
			? component.get('v.records').filter((f) => f.Stationery_Item__c)
			: component
					.get('v.recordsOther')
					.filter((f) => f.Stationery_Other__c)
					.map((m) => {
						m.Stationery_Item__c = 'Other';
						return m;
					});
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

				$A.enqueueAction(component.get('c.closeModal'));
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
	getRequesterType: function (component, requesterId) {
		var helper = this;

		requesterId = Array.isArray(requesterId) ? requesterId[0] : requesterId;
		var action = component.get('c.requesterType');
		action.setParams({
			recordId: requesterId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.case.Requester_Type__c', result.User_Type__c);
				var requester = result.User_Type__c.replace('Section Head', 'SectHead').trim();
				helper.changeRecordType(component, requester);
			} else if (state === 'ERROR') {
				var error = response.getError();
				console.error(helper.parseObject(error));
			}
		});

		if (requesterId) {
			$A.enqueueAction(action);
		} else {
			component.set('v.case.Requester_Type__c', null);
			component.set(`v.case.RecordTypeId`, null);
		}
	},
	changeRecordType: function (component, requester) {
		var developName = component.get('v.case.Stationery_Type__c') === 'Standard Items' ? '_STAT' : '_STAT_NON';
		component.set(`v.case.RecordTypeId`, component.get(`v.recordTypeIdsMap.${requester + developName}.recordTypeId`));
        
        console.log(requester + developName);
	}
});