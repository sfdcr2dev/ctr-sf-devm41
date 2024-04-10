({
    
	doInit : function(component, event, helper) {

        var getICRID = component.get("v.recordId");
        
        component.set("v.ReviewTitle", 'Ask to Review');
        component.set("v.ActiveStatusTitle", 'Active Committee'); 
        component.set("v.isShowActive", false); 
        
        var action = component.get("c.getCurrentStatus");
        
        action.setParams({ "ICRId" : getICRID });  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var status = response.getReturnValue();
            console.log('Status : ' + status);
            if(state === 'SUCCESS') {
                
                if(response.getReturnValue() == 'Cancel') {
                    component.set("v.isCancelAvailable", true);
                    component.set("v.isDisappointAvailable", false);
                }
                else if(response.getReturnValue() == 'CancelDisappoint') {
                    component.set("v.isCancelAvailable", true);
                    component.set("v.isDisappointAvailable", true);
                }
                else if(response.getReturnValue() == 'Disappoint') {
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", true);
                    component.set("v.isAskToReviewAvailable", true);
                }
                else if(response.getReturnValue() == 'Review') {
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", false);
                    component.set("v.isAskToReviewAvailable", true);
                }
                else if(response.getReturnValue() == 'ReviewAMM') {
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", false);
                    component.set("v.isAskToReviewAvailable", true);
                    component.set("v.ReviewTitle", 'Resend to Review');
                    component.set("v.ReviewSentTitle", '** This ICR has been sent for review.');
                }
                else if(response.getReturnValue() == 'DisappointAMM') {
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", true);
                    component.set("v.isAskToReviewAvailable", true);
                }
                else if(response.getReturnValue() == 'ReviewDisappointAMM') {
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", true);
                    component.set("v.isAskToReviewAvailable", true);
                    component.set("v.ReviewTitle", 'Resend to Review');
                    component.set("v.ReviewSentTitle", '** This ICR has been sent for review.');
                }
                else if(response.getReturnValue() == 'None') {
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", false);
                }
                else if(response.getReturnValue() == 'ReviewCEO') {
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", false);
                    component.set("v.isAskToReviewAvailable", true);
                }
                else if(response.getReturnValue() == 'ReviewNone') {
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", false);
                    component.set("v.isAskToReviewAvailable", true);
                    component.set("v.ReviewTitle", 'Resend to Review');
                    component.set("v.ReviewSentTitle", '** This ICR has been sent for review.');
                }
                else if(response.getReturnValue() == 'Active') {
        			component.set("v.isShowActive", true); 
                	component.set("v.isActiveCommittee", true);
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", false);   
                    component.set("v.isExpirePermission", true);    
        			component.set("v.ActiveStatusTitle", 'Active Committee'); 
                }
                else if(response.getReturnValue() == 'DisableActive') {
        			component.set("v.isShowActive", true); 
                	component.set("v.isActiveCommittee", true);
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", false);
                    component.set("v.isExpirePermission", false);        
        			component.set("v.ActiveStatusTitle", 'Active Committee'); 
                }
                else if(response.getReturnValue() == 'Expired') {
        			component.set("v.isShowActive", true); 
                	component.set("v.isActiveCommittee", false); 
                    component.set("v.isCancelAvailable", false);
                    component.set("v.isDisappointAvailable", false);  
        			component.set("v.ActiveStatusTitle", 'Expired Committee');   
                }
                
            }
            else if(state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        reject(Error("Error message: " + errors[0].message));
                    }
                }
                else {
                    reject(Error("Unknown error"));
                }
            }
        })
        $A.enqueueAction(action);
        
	},
    
    goToCancel: function(component, event, helper) {
        
        var getICRName = component.get("v.RecordData.Name");
        component.set("v.ICRName", getICRName);
        component.set("v.isCancelOpen", true);
        
    },
    
    changeToCancel: function(component, event, helper) {
        
        component.set("v.isLoading", true); 
        var ICRID = component.get("v.recordId");
        var ICRStatus = component.get("v.RecordData.Status__c");
        var reason = component.get("v.CancelReason");
        
        if(reason.length == 0) {
            component.set("v.isCancelReasonFill", false);
        	component.set("v.isLoading", false); 
        }
        else {
            var action = component.get("c.cancelStatus");
        
            action.setParams({ "ICRId" : ICRID, "cancelReason" : reason });  
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var changeSuccess = response.getReturnValue();
                console.log('changeSuccess : ' + changeSuccess);
                
                if(state === 'SUCCESS') {
                    
                    if(changeSuccess == true) {
                        window.location.reload();
                    }
                    
                }
                else if(state === 'ERROR'){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            reject(Error("Error message: " + errors[0].message));
                        }
                    }
                    else {
                        reject(Error("Unknown error"));
                    }
                }
            })
            $A.enqueueAction(action);
        }
    },
    
    goToExpire: function(component, event, helper) {
        
        var getICRName = component.get("v.RecordData.Name");
        component.set("v.ICRName", getICRName);
        component.set("v.isExpireOpen", true);
        
    },
    
    changeToExpired: function(component, event, helper) {
        
        component.set("v.isLoading", true); 
        var ICRID = component.get("v.recordId");
        var isActive = component.get("v.RecordData.Active__c");
        
        var action = component.get("c.expiredCommittee");
        
        action.setParams({ "ICRId" : ICRID });  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var changeSuccess = response.getReturnValue();
            console.log('changeSuccess : ' + changeSuccess);
            
            if(state === 'SUCCESS') {
                
                if(changeSuccess == true) {
        			window.location.reload();
                }
                
            }
            else if(state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        reject(Error("Error message: " + errors[0].message));
                    }
                }
                else {
                    reject(Error("Unknown error"));
                }
            }
        })
        $A.enqueueAction(action);
        
    },
    
    goToDisappoint: function(component, event, helper) {
        
        var getICRName = component.get("v.RecordData.Name");
        component.set("v.ICRName", getICRName);
        component.set("v.isDisappointOpen", true);
        
        var getICRAMM = component.get("v.RecordData.Type__c");
        var getAMMConclusion = component.get("v.RecordData.AMM_Conclusion__c");
        
        if(getICRAMM == 'AMM' && getAMMConclusion != 'Disappoint') {
        	component.set("v.isAMMConclusionError", true);
        }
        console.log('getICRAMM : ' + getICRAMM);
        console.log('getAMMConclusion : ' + getAMMConclusion);
        
    },
    
    changeToDisappoint: function(component, event, helper) {
        
        component.set("v.isLoading", true); 
        var ICRID = component.get("v.recordId");
        var ICRStatus = component.get("v.RecordData.Status__c");
        
        var action = component.get("c.disappointStatus");
        
        action.setParams({ "ICRId" : ICRID });  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var changeSuccess = response.getReturnValue();
            
            if(state === 'SUCCESS') {
                
                if(changeSuccess == true) {
        			window.location.reload();
                }
                else {
        			component.set("v.isErrorMsg", true);
                    component.set("v.ErrorMsg", "Please s");
                }
                
            }
            else if(state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        reject(Error("Error message: " + errors[0].message));
                    }
                }
                else {
                    reject(Error("Unknown error"));
                }
            }
        })
        $A.enqueueAction(action);
        
    },
    
    askToReview: function(component, event, helper) {
        
        component.set("v.isLoading", true); 
        var ICRID = component.get("v.recordId");
        
        var reviewAction = component.get("c.getAskToReview");
        
        reviewAction.setParams({ "ICRId" : ICRID });  
        
        reviewAction.setCallback(this, function(responseAction) {
            var state = responseAction.getState();
            var reviewSuccess = responseAction.getReturnValue();   
            
            if(state === 'SUCCESS') {
                
                if(reviewSuccess == true) {
        			component.set("v.isLoading", false); 
        			window.location.reload();
                }
                
            }
            else if(state === 'ERROR'){
                var errors = responseAction.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        reject(Error("Error message: " + errors[0].message));
                    }
                }
                else {
                    reject(Error("Unknown error"));
                }
            }
        })
        $A.enqueueAction(reviewAction);
        
    },
    
    closeModal: function(component, event, helper) {
        
        var reason = component.get("v.CancelReason");
        
        component.set("v.CancelReason", "");
        // Set isModalOpen attribute to false  
        component.set("v.isCancelOpen", false);
        component.set("v.isDisappointOpen", false);
        component.set("v.isExpireOpen", false);
        
        //$A.get('e.force:refreshView').fire();
        
    }
    
})