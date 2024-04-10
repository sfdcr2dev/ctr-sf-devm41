({
    doInit: function (component, event, helper) {
        var action = component.get('c.getActionButton');
        action.setParams({
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('actionButton SF ' + response.getReturnValue());
                component.set('v.actionButton', response.getReturnValue());
                component.set('v.actionFromSFDC', 'ReplyToCreditTeam');
                helper.getCTRCommitteeApprovalId(component, event, helper);
                helper.getListFile(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);

        //var userId = $A.get("$SObjectType.CurrentUser.Id");
        //component.set("v.userId", userId); top -> trce tx->fa labix falb
        //component.set('v.actionButton','ReplyFA');//change to helper to set action
    }
})