({
    hanldeAfterCloseModal: function (component, event, helper) {
        event.preventDefault();
        if (component.get('v.formFactor') === 'PHONE') {
            var navService = component.find('navService');
            navService.navigate({
                type: 'standard__webPage',
                attributes: {
                    url: '/apex/previous_back'
                }
            }, true);
        } else {
            var navigateToURL = $A.get("e.force:navigateToURL");
            navigateToURL.setParams({
                isredirect: true,
                url: "/lightning/n/DG_Service"
            });
            navigateToURL.fire();
        }
    },
    deleteDGRequestCaseById: function (component, caseId) {
        var action = component.get("c.deleteDGRequestCaseById");
        action.setParams({
            recordId: caseId
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

            } else {
                var errors = response.getError();
                errors.forEach(function (error) { console.error(error); });
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
    getCase: function (component, event, helper) {
        var action = component.get("c.getHardwareCase");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.case", result);
                // component.find('Requester').set('v.value', result.Requester__c);
                // helper.getPicklistValuesITAsset(component)
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
        var action = component.get("c.getCaseRecordTpyeInfoes");
        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.recordTypeIdsMap", result);
                component.set("v.case.RecordTypeId",
                    component.get('v.recordTypeIdsMap.Hardware_Catalog.recordTypeId'))
            }
        });
        $A.enqueueAction(action);
    },
    createCaseLineItem: function (component, event, helper) {
        // console.log(JSON.parse(JSON.stringify(event.getParams())));
        var params = event.getParams();
        var response = params.response;
        var caseId = response.id;

        var records = component.get("v.records").filter(f => f.Hardware_Item__c)
        var recordsOther = component.get("v.recordsOther").filter(f => f.Hardware_Other__c)

        var action = component.get("c.saveCaseLineItem");
        action.setParams({
            'records': component.get('v.case.Hardware_Type__c') === 'Standard Hardware' ? records : recordsOther,
            'caseId': caseId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Success!',
                    message: $A.get(component.get('v.autoApproval') ? '$Label.c.DG_Service_Auto_Submit_Success' : '$Label.c.DG_Service_Save_as_Draft'),
                    duration: '5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();

                helper.hanldeAfterCloseModal(component, event, helper)
            }
            else if (state === 'ERROR') {
                var error = response.getError();
                error.forEach(e => {
                    console.error(e)
                    component.find('messages').setError(e.message)
                });
                helper.deleteDGRequestCaseById(component, caseId)
            }

            component.set("v.isLoading", false)
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
    getPicklistValuesMap: function (component, sobjectName, fieldName) {
        var action = component.get("c.getCasePicklistValues");
        action.setParams({
            'sobjectName': sobjectName,
            'fieldName': fieldName
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set(`v.picklistMap.${sobjectName}.${fieldName}`, Object.keys(result).map(key => ({
                    label: result[key], value: key
                })));
            }
            else {
                var error = response.getError();
                console.error(error);
            }
        });
        $A.enqueueAction(action);
    },
    getPicklistValuesITAsset: function (component, requesterId, index) {
        // var requesterId = Array.isArray(component.get("v.case.Requester__c"))
        //     ? component.get("v.case.Requester__c.0")
        //     : component.get("v.case.Requester__c")
        var action = component.get("c.getPicklistValuesITAsset")
        action.setParams({
            'requesterId': requesterId
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set(`v.picklistMap.OPP_Case_Line_Items__c.OPP_IT_Asset__c.${index}`, [
                    // {
                    //     value: '',
                    //     label: '--None--',
                    //     selected: true,
                    // },
                    ...result.map(m => ({
                        value: m.Id,
                        label: m.Name,
                        description: m.Asset_Type__c
                    }))
                ])
                // console.log(JSON.parse(JSON.stringify(component.get('v.picklistMap.OPP_Case_Line_Items__c'))))

            } else {
                var error = response.getError();
                console.error(error);
            }
        })
        if (requesterId) {
            $A.enqueueAction(action);
        }
        else {
            if (index) component.set(`v.picklistMap.OPP_Case_Line_Items__c.OPP_IT_Asset__c.${index}`, [])
        }
    },
    reportValidity: function (component, fieldName, message) {
        var cmp = component.find(fieldName);
        if (cmp && cmp.isValid()) {
            cmp.setCustomValidity(message)
            cmp.reportValidity();
        }

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
        //var developName = hardwareType === 'Standard Hardware' ? '_HW' : '_HW_NON';
		//component.set(`v.case.RecordTypeId`, component.get(`v.recordTypeIdsMap.${requester + developName}.recordTypeId`));

		var developName = component.get('v.case.Hardware_Type__c') === 'Standard Hardware' ? '_HW' : '_HW_NON';
		component.set(`v.case.RecordTypeId`, component.get(`v.recordTypeIdsMap.${requester + developName}.recordTypeId`));
        console.log(requester + developName);
	}
})