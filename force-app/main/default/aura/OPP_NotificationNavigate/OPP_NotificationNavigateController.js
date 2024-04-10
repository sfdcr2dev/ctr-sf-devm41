({
    handleRecord: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
           // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
            console.log("You loaded a record in " + 
            component.get("v.simpleRecord.URL__c"));	
        var url = component.get("v.simpleRecord.URL__c");
        if(url != null){
            //console.log("null");
            var evt = $A.get("e.force:navigateToURL");
            evt.setParams({
                url: component.get("v.simpleRecord.URL__c")
            });
            evt.fire();
        }
            
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    handleClick: function(component, event, helper) {
        var url = component.get("v.simpleRecord.URL__c");
        if(url != null){
            var evt = $A.get("e.force:navigateToURL");
            evt.setParams({
                url: component.get("v.simpleRecord.URL__c")
            });
            evt.fire();
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error!',
                message : 'Cannot redirect to URL!',
                duration : '5000',
                key : 'info_alt',
                type : 'error',
                mode : 'pester'
            });
            toastEvent.fire();
        }
    },
    myTaskClick: function(component, event, helper) {
        var evt = $A.get("e.force:navigateToURL");
        evt.setParams({
            url: "/lightning/n/opp_mytasks"
        });
        evt.fire();
    },
    homeClick: function(component, event, helper) {
        var evt = $A.get("e.force:navigateToURL");
        evt.setParams({
            url: "/lightning/n/spacex"
        });
        evt.fire();
    }
     
})