({
    hanldeAfterCloseModal: function (component, event, helper) {
        if (component.get('v.formFactor') === 'PHONE') {
            // $A.get('e.force:refreshView').fire();
            $A.enqueueAction(component.get('c.closeModal'));
        }
        else {

            var evt = $A.get("e.force:navigateToURL");
            evt.setParams({
                url: "/lightning/n/DG_Service"
            });
            evt.fire();
        }
    },
    getCase: function (component, event, helper) {
        var action = component.get("c.getIncidentCase");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.case", result);
                // component.find('Requester').set('v.value', result.Requester__c);
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
    createCaseLineItem: function (component, event, helper) {
        // console.log(JSON.parse(JSON.stringify(event.getParams())));
        var params = event.getParams();
        var response = params.response;
        var caseId = response.id;

        var records = component.get("v.records")
        var action = component.get("c.saveCaseLineItem");
        action.setParams({
            'records': records.filter(f => f.Incident_Item__c),
            'caseId': caseId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {

                if (component.get('v.autoApproval')) {
                    component.find('flowData').startFlow('autoSubmitRequest', [
                        {
                            name: 'recordId',
                            type: 'String',
                            value: caseId
                        }])
                    component.set('v.autoApproval', false)
                }

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
                component.set(`v.picklistMap.${fieldName}`, Object.keys(result).map(key => ({
                    label: result[key],
                    value: key
                })));
            }
            else {
                var error = response.getError();
                console.error(error);
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
})