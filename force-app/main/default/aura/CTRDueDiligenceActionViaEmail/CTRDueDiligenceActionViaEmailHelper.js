({
    isEnhancedDueDiligenceValid : function(component) {
        console.log('[isEnhancedDueDiligenceValid] -----');
        component.set('v.isLoaded', false);
        var action = component.get("c.isEnhancedDueDiligenceValid");
        action.setParams({
            "recordId": component.get('v.recordId'),
            "actionBy": component.get('v.actionBy')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.canSubmit', result);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[saveActionViaEmail] error -----', errors[0].message);
                        alert(errors[0].message);
                    }
                } else {
                    console.log('[saveActionViaEmail] unknown error -----');
                    alert('Unknown error');
                }
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
    },
    saveActionViaEmail : function(component) {
        console.log('[saveActionViaEmail] -----');
        component.set('v.isLoaded', false);
        var action = component.get("c.saveActionViaEmail");
        action.setParams({
            "recordId": component.get('v.recordId'),
            "actionResult": component.get('v.actionButton'),
            "dueDiligenceComment": component.get('v.dueDiligenceComment'),
            "actionBy": component.get('v.actionBy'),
            "userId": component.get('v.userId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result == 'success') {
                    component.set('v.isSubmitted', true);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[saveActionViaEmail] error -----', errors[0].message);
                        alert(errors[0].message);
                    }
                } else {
                    console.log('[saveActionViaEmail] unknown error -----');
                    alert('Unknown error');
                }
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
    },
})