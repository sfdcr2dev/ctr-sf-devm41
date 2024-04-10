({
	doInit: function(component, event, helper) {
        
        var getWorkProcessNo = component.get("v.recordId");
        
    },
    
    openGuideline: function(component, event, helper) {
        
        var getWorkProcessNo = component.get("v.RecordData.No__c");
        
        var action = component.get("c.getUserTheme");
        
        //action.setParams({ "workProcessNo" : getWorkProcessNo });  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //var guideline = response.getReturnValue();
            var theme = response.getReturnValue();
            
            if(state === 'SUCCESS') {
                
                if(theme == 'app') {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                      "url": '/apex/Guideline_VFPage?WorkProcessNo='+getWorkProcessNo
                    });
                    urlEvent.fire();
                }
                else {
                    var action = component.get("c.getWorkProcessName");
                
                    action.setParams({ "workProcessNo" : getWorkProcessNo });  
                    
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        var name = response.getReturnValue();
                        
                        if(state === 'SUCCESS') {
                            // Set isModalOpen attribute to true
                            component.set("v.WorkProcessName", name);
                            
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
                    
                    // Set isModalOpen attribute to true
                    component.set("v.isGuidelineOpen", true);
                    
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
    
    openProcedure: function(component, event, helper) {
        
        var getWorkProcessNo = component.get("v.RecordData.No__c");
        
        var action = component.get("c.getProcedureForWorkProcess");
        
        action.setParams({ "workProcessNo" : getWorkProcessNo });  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var procedureUrl = response.getReturnValue();
            
            if(state === 'SUCCESS') {
                var checkUrl = procedureUrl.includes("AttachedContentDocuments");
                if(checkUrl) {
                    window.open(procedureUrl,'_blank');
                }
                else if(!checkUrl) {
                    var urlEvent = $A.get("e.force:navigateToSObject");
                    urlEvent.setParams({
                      "recordId": procedureUrl,
      				  "slideDevName": "related"
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
    
    closeModel: function(component, event, helper) {
        
        // Set isModalOpen attribute to false  
        component.set("v.isGuidelineOpen", false);
        
    }
    
})