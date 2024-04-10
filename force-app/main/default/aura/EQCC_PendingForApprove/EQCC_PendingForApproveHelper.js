({
    setMyApprovalFilter: function (component, event, helper) {
    // alert('what' + JSON.stringify(component.get("v.filter")));
         component.set("v.isLoading", true);
         // alert('yo' +component.get("v.isLoading"));
      
        var action = component.get("c.retrieveProcessInstanceStepsForApproveForUserFilter");

  action.setParams({
            filterMap: component.get("v.filter") || {}
        });
 // alert('hello' + JSON.stringify(component.get("v.filter")));
       
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let stepsForApprove = response.getReturnValue();
                // console.log(JSON.stringify(stepsForApprove));
                 //lert('step' + stepsForApprove);
                let stepsForApproveHeader = [];

                if (stepsForApprove.length > 0) {
                    let dropableBody = stepsForApprove[0].dropableBody;

                    console.log(dropableBody);

                    dropableBody.forEach((element) => {
                        stepsForApproveHeader.push(element.label);
                    });
                }

                component.set("v.stepsForApproveHeader", stepsForApproveHeader);
                component.set("v.stepsForApprove", stepsForApprove);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.isLoading", false);
        });

        $A.enqueueAction(action);
    },
    parseObject: function (obj) {
        return obj ? JSON.parse(JSON.stringify(obj)) : obj;
    },
})