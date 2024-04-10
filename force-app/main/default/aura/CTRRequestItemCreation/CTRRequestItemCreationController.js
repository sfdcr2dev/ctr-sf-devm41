({
    doInit : function(component, event, helper) {
        /*
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "CTRRequestFormItem__c"
        });
        createAcountContactEvent.fire();*/
        
        var action = component.get("c.getRequestItemRecordType");
        // Set spinner action On!
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                    console.log('yrdyrdyrdy');
            } else {
                console.error("Error fetching Blob file");
            }
        });
        $A.enqueueAction(action);
    }
})