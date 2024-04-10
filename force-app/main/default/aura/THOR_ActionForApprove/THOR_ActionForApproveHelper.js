({
    submitApproveReject : function(component, event, helper, stepId, approveReject) {
        var action = component.get("c.approveOrReject");
        var comment = component.find("commentArea").get('v.value');
        action.setParams({
            stepId: stepId,
            approveReject: approveReject,
            comments: comment
        });

        var p = helper.executeAction(component, action);

        p.then(function(response){
            var toastEvent = $A.get("e.force:showToast");
            let stepCount = component.get('v.stepCount');
            let sheetCode = component.get('v.sheetCode');
            let message = '';
            if (sheetCode) {
                message = sheetCode + ': ';
            }
            if (approveReject === 'Approve'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": message + 'Step ' + stepCount + ' has been approved.',
                    "type": "success"
                });
                toastEvent.fire();
            }
            else {
                toastEvent.setParams({
                    "title": "Needs Revision",
                    "message": message + 'Step ' + stepCount + ' has been moved to revise.',
                    "type": "info"
                });
                toastEvent.fire();
            }

            helper.reInit(component, event, helper);
            /*component.find("commentArea").set('v.value', '');
            var nextAction = component.get("c.doInit");
            nextAction.setParams({
                component, event, helper
            });
            $A.enqueueAction(nextAction);*/
        }).catch(function(err){
            if (err) {
                if (err[0] && err[0].message) {
                    console.log("Error message: " +
                    err[0].message);
                }
            } else {
                console.log("Unknown error");
            }
        });
    },
    executeAction : function(component, action){
        return new Promise(function (resolve, reject) {
            action.setCallback(this, function (response) {
                if (response.getState() === 'SUCCESS') {
                    resolve(response.getReturnValue());
                } else if (response.getState() === 'ERROR') {
                    reject(response.getError());
                }
            });

            $A.enqueueAction(action);
        });
    },
    canApprove : function(component, event, stepId) {
        var action = component.get("c.canApprove");
        action.setParams({
            relatedId: stepId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedItems = response.getReturnValue();
                console.log('approvable? ' + returnedItems);
                component.set('v.canApprove', returnedItems);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }

                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    submitReassign : function(component, event, helper, stepId, approveReject, user) {
        var action = component.get("c.reassign");

        action.setParams({
            relatedId: stepId,
            userId: user
        });

        var p = helper.executeAction(component, action);

        p.then(function(response){
            var nextAction = component.get("c.doInit");
            nextAction.setParams({
                component, event, helper
            });
            $A.enqueueAction(nextAction);
        }).catch(function(err){
            if (err) {
                if (err[0] && err[0].message) {
                    console.log("Error message: " +
                    err[0].message);
                }
            } else {
                console.log("Unknown error");
            }
        });
    },
    reInit: function(component, event, helper) {
        var action = component.get("c.getApprovalSteps");
        action.setParams({
            relatedId: component.get("v.eqccStepId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedItems = response.getReturnValue();
                component.set("v.historyCount", returnedItems.length);
                component.set("v.approvalItems", returnedItems);
                // this show the step count for the approval (has nothing to do with eqcc step)
                component.set("v.stepCount", (returnedItems.length - 1));
                if (returnedItems.length > 0) {
                    component.set('v.sheetCode', returnedItems[0].Code);
                } else {
                    //check wheter the form is rejected
                    let rejectedAction = component.get('c.getRejectedHeaderSheet');
                    rejectedAction.setParams({
                        stepId: component.get("v.eqccStepId")
                    });

                    rejectedAction.setCallback(this, function(response){
                       let state = response.getState();
                        if (state === 'SUCCESS') {
                            let rejectedForm = response.getReturnValue();

                            if (rejectedForm) {
                                component.set('v.rejectedForm', rejectedForm);
                                component.set('v.isRejected', true);
                                component.set("v.historyCount", 1);
                            }
                        }
                    });
                    
                    $A.enqueueAction(rejectedAction);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }

                } else {
                    console.log("Unknown error");
                }
            }
            this.stopLoading(component);
        });
        $A.enqueueAction(action);

        helper.canApprove(component, event, component.get('v.eqccStepId'));
    },

    stopLoading : function(component) {
        var stopLoadingEvent = component.getEvent("stopLoadingEvent");
        stopLoadingEvent.setParams({
            "target": "stopLoading"
        });
        stopLoadingEvent.fire();
    }
})