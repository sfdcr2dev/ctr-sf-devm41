({
    getCase: function (component, event, helper) {
        var action = component.get("c.getProjectCase");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.case", result);
                //alert(component.set("v.case", result));
                // component.find('Requester').set('v.value', result.Requester__c);
                
                var requester = component.get('v.case.Requester__c');
                console.log('requesterType >>'+requester);
                if(requester){
                    helper.getRequesterType(component, requester);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getIsEmployee: function (component) {
        var action = component.get("c.isEmployee");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.isEmployee", result);
            }
        });
        $A.enqueueAction(action);
    },
    getDescribeFieldResult: function (component, sObjectName, fields) {
        var action = component.get("c.getDescribeFieldResult");
        action.setParams({
            sObjectName: sObjectName,
            fields: fields
        })
        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set(`v.describeFields.${sObjectName}`, result);
            }
            else {
                var error = response.getError();
                console.error(error);
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
		var developName = '_PROJ';//component.get('v.case.Stationery_Type__c') === 'Standard Items' ? '_STAT' : '_STAT_NON';
		component.set(`v.case.RecordTypeId`, component.get(`v.recordTypeIdsMap.${requester + developName}.recordTypeId`));
		console.log(requester + developName);
	}
})