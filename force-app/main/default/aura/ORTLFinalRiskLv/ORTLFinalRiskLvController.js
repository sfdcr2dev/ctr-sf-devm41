({
    // Bind to component init event.
    doInit: function (component, event, helper) {
        let p2 = new Promise(function (resolve, reject) {
            // Fetch all custom metadata types: Consequence Description, Risk Level, Estimated Value and Likelihood Caption.
            helper.getRiskAssessmentCustomMetadata(component, event, helper, resolve);
        });

        //p2.then(function (values) {
        //    helper.displayEstimatedRiskValue(component, event, helper);
        //});

        // Update values that related to risk consequence, severity and likelihood.
        helper.displayEstimatedRiskValue(component, event, helper);
    },
    // force:recordData recordUpdated event listener.
    handleRecordUpdated: function (component, event, helper) {
        // Update values that related to risk consequence, severity and likelihood.
        helper.displayEstimatedRiskValue(component, event, helper);

        //if (component.get('v.metadata')) {
        //    helper.displayEstimatedRiskValue(component, event, helper);
        //} else {
        //    let p2 = new Promise(function (resolve, reject) {
        //        helper.getRiskAssessmentCustomMetadata(component, event, helper, resolve);
        //    });
        //    p2.then(function (values) {
        //        helper.displayEstimatedRiskValue(component, event, helper);
        //    });
        //}
    },
})