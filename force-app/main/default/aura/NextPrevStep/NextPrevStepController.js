({
	doInit: function(component, event, helper) {
        
        var getWorkProcessId = component.get("v.recordId");
        var getWorkProcessNo = component.get("v.RecordData.No__c");
        
    },
    
    goToNextStep: function(component, event, helper) {
        
        var projectId = component.get("v.RecordData.Project__c");
        var workProcessNo = component.get("v.RecordData.No__c");
        
        var action = component.get("c.getNextStep");
        
        action.setParams({ "ProjectId" : projectId , "StepNo" : workProcessNo});  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var nextUrl = response.getReturnValue();
            
            if(state === 'SUCCESS') {
                var checkUrl = nextUrl.includes("view");
                if(checkUrl) {
                    window.open(nextUrl,'_top');
                }
                else if(!checkUrl) {
        			var navLink = component.find("navLink");
                    var pageRef = {
                        type: 'standard__recordPage',
                        attributes: {
                            actionName: 'view',
                            recordId : nextUrl
                        },
                    };
                    navLink.navigate(pageRef, true);
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
    
    goToPrevStep: function(component, event, helper) {
        
        var projectId = component.get("v.RecordData.Project__c");
        var workProcessNo = component.get("v.RecordData.No__c");
        
        var prevAction = component.get("c.getPrevStep");
        
        prevAction.setParams({ "ProjectId" : projectId , "StepNo" : workProcessNo});  
        
        prevAction.setCallback(this, function(response) {
            var state = response.getState();
            var prevUrl = response.getReturnValue();
            
            if(state === 'SUCCESS') {
                var checkUrl = prevUrl.includes("view");
                if(checkUrl) {
                    window.open(prevUrl,'_top');
                }
                else if(!checkUrl) {
        			var navLink = component.find("navLink");
                    var pageRef = {
                        type: 'standard__recordPage',
                        attributes: {
                            actionName: 'view',
                            recordId : prevUrl
                        },
                    };
                    navLink.navigate(pageRef, true);
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
        $A.enqueueAction(prevAction);
    },
    
    closeModel: function(component, event, helper) {
        
        // Set isModalOpen attribute to false  
        component.set("v.isGuidelineOpen", false);
        
    }
    
})