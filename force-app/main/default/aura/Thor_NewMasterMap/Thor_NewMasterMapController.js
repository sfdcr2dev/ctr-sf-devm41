({
    doInit : function(component, event, helper) {
        let recId = component.get("v.recordId");
        if (recId) {
            component.set("v.modalContext", "Edit");
            component.set("v.isEdit", true);
        }
    },

	cancelDialog: function(component, event, helper) {
        var recId = component.get("v.recordId");
        if (!recId) {
            var homeEvt = $A.get("e.force:navigateToObjectHome");
            homeEvt.setParams({
                "scope": "Master_Map__c"
            });
            homeEvt.fire();
        } else {
            helper.navigateTo(component, recId);
        }
    },
    
    handleSubmit: function(component, event, helper) {
        component.find('recordEditForm').submit();
    },
    
    handleSuccess: function(component, event, helper) {
        let resultsToast = $A.get("e.force:showToast");
            
        resultsToast.setParams({
            "title": "Saved",
            "type": "success",
            "message": "The record was saved."
        });
        resultsToast.fire();
        var action = component.get('c.cancelDialog');
        $A.enqueueAction(action);
    }
})