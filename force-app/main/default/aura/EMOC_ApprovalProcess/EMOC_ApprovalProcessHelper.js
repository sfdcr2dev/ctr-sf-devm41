({
	getDetail : function(component,event,helper) {
        var processId = component.get('v.recordId');
        var sobjecttype = component.get('v.sobjecttype');
        var action = component.get("c.getDetailApproval");
        action.setParams({ 
            "Id": processId,
            "sobjecttype": sobjecttype
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.Submitter',result.Submitter);
                component.set('v.DateSubmited',result.DateSubmited);
                component.set('v.ActualApprover',result.ActualApprover);
                component.set('v.AssignedTo',result.AssignedTo);
                component.set('v.status',result.status);
                component.set('v.objectName',result.objectName); // TableEnumOrId
                component.set('v.subjectName',result.subjectName);
                component.set('v.MOCType',result.MOCType); 
                component.set('v.checkBtnHold',result.checkBtnHold);
                component.set('v.checkBtnReject',result.checkBtnReject);
                component.set('v.checkBtnSendback',result.checkBtnSendback);
                component.set('v.StatusFunctionalOverride',result.StatusFunctionalOverride);
                component.set('v.StatusCommonWorkflow',result.StatusCommonWorkflow);
                component.set('v.checkSequence',result.checkSequence);
                component.set('v.labelApprove',result.labelApprove);
                component.set('v.RecordTypeName',result.RecordTypeName);
            }
        }); 
        $A.enqueueAction(action);
	},
    goToApproval : function(component, event, helper, State) {
        var getID = component.get("v.recordId");
        var getComment = component.get("v.comment");
        var action = component.get('c.callApprovedOrRejectProcess');
        var sobjecttype = component.get("v.sobjecttype");
        action.setParams({
                            "recordId": component.get("v.recordId"), 
                            "comment": component.get("v.comment"),
                            "State" : State,
            				"sobjecttype": component.get("v.sobjecttype")
                        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": resp,
                  "slideDevName": "detail"
                });
                navEvt.fire();
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);     
                    }
                } else {
                    console.log("Unknown error");
                }
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(component, event, helper, messageType, message, title) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title : title,
            message: message,
            messageTemplate: '',
            duration:' 10000',
            key: 'info_alt',
            type: messageType,
            mode: 'dismissible'
        });
        toastEvent.fire();
    }    
})