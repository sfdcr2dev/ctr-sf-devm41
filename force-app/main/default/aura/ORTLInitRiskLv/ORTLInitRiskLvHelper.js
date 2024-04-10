({
    util: {
        // For formatting abbreviation currency.
        shortenCurrency: function (number) {
            let txt = 'N/A';
            let value = Number(number);

            if (value > 1000000000) {
                txt = Math.round(value / 1000000000) + 'B';
            } else if (value > 1000000) {
                txt = Math.round(value / 1000000) + 'M';
            } else if (value > 1000) {
                txt = Math.round(value / 1000) + 'K';
            } else if (value <= 1000) {
                txt = Math.round(value) + '';
            }
            return txt;
        },
    },
    // Call remote function to fetch all custom metadata types.
    getRiskAssessmentCustomMetadata: function (component, event, helper, resolve) {
        let action = component.get('c.getRiskAssessmentCustomMetadata');

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.metadata', result);

                if (typeof (resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
            }
        });

        $A.enqueueAction(action);
    },
    // Update values that related to risk consequence, severity and likelihood.
    // And make color related to risk level.
    displayEstimatedRiskValue: function (component, event, helper) {
//        let initialSeverity = component.get('v.risk.InitialSeverity__c');
//        let initialLikelihood = component.get('v.risk.IntlLikelihood__c');
//        let finalSeverity = component.get('v.risk.FinalSeverity__c');
//        let finalLikelihood = component.get('v.risk.FinalLikelihood__c');
//
//        let metadata = component.get('v.metadata');
//        metadata.RiskLevel.forEach(function (level) {
//            if (String(initialSeverity).toLowerCase() === String(level.Severity__c).toLowerCase()
//                && String(initialLikelihood).toLowerCase() === String(level.Likelihood__c).toLowerCase()) {
//                component.set('v.initialEstimatedValueInUSD', helper.util.shortenCurrency(level.EstValueUSD__c));
//                component.set('v.initialEstimatedValueInTHB', helper.util.shortenCurrency(level.EstValueTHB__c));
//            }
//            if (String(finalSeverity).toLowerCase() === String(level.Severity__c).toLowerCase()
//                && String(finalLikelihood).toLowerCase() === String(level.Likelihood__c).toLowerCase()) {
//                component.set('v.finalEstimatedValueInUSD', helper.util.shortenCurrency(level.EstValueUSD__c));
//                component.set('v.finalEstimatedValueInTHB', helper.util.shortenCurrency(level.EstValueTHB__c));
//            }
//        });
        component.set('v.initialEstimatedValueInUSD', helper.util.shortenCurrency(component.get('v.risk.InitialValueUSD__c')));
        component.set('v.finalEstimatedValueInUSD', helper.util.shortenCurrency(component.get('v.risk.FinalValueUSD__c')));
    },
})