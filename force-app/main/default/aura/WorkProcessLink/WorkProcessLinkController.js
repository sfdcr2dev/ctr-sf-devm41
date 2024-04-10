({
	doInit: function(component, event, helper) {
        
        var getWorkProcessId = component.get("v.recordId");
        var getWorkProcessNo = component.get("v.RecordData.No__c");
        
    },
    
    goToRoadmap: function(component, event, helper) {
        
        var currentProjectId = component.get("v.recordId");
        var projectId = component.get("v.RecordData.Project__c");
        
        if(projectId == null) {
            projectId = currentProjectId;
        }
        
        var workProcessNo = component.get("v.RecordData.No__c");
        
        var action = component.get("c.gotoProjectRoadmap");
        
        action.setParams({ "ProjectId" : projectId});  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var roadmapUrl = response.getReturnValue();
            
            if(state === 'SUCCESS') {
                var checkUrl = roadmapUrl.includes("aloha");
                if(checkUrl) {
                    window.open(roadmapUrl,'_self');
                }
                else if(!checkUrl) {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                      "url": roadmapUrl
                    });
                    urlEvent.fire();
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
    
    goToWorkProcessGroup: function(component, event, helper) {
        
        var currentProjectId = component.get("v.recordId");
        
        var projectId = component.get("v.RecordData.Project__c");
        var workProcessNo = component.get("v.RecordData.No__c");
        
        if(projectId == null) {
            projectId = currentProjectId;
        }
        
        var action = component.get("c.gotoWorkProcessGroup");
        
        action.setParams({ "ProjectId" : projectId});  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var workProcessGroupUrl = response.getReturnValue();
            
            if(state === 'SUCCESS') {
                var checkUrl = workProcessGroupUrl.includes("aloha");
                if(checkUrl) {
                    window.open(workProcessGroupUrl,'_self');
                }
                else if(!checkUrl) {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                      "url": workProcessGroupUrl
                    });
                    urlEvent.fire();
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
})