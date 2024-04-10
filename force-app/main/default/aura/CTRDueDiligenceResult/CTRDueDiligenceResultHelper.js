({
    retrieveDueDiligenceResult : function(component) {
        component.set('v.isLoaded', false);
        var action = component.get("c.retrieveDueDiligenceResult");
        action.setParams({
            "recordId": component.get('v.recordId'),
            "displayRiskBySystem": component.get('v.displayRiskBySystem')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result)) {
                    var originalResult = JSON.parse(result);
                    console.log('[retrieveDueDiligenceResult] originalResult -----', originalResult);
                    component.set('v.dueDiligenceResultList', originalResult.resultList);
                    component.set('v.riskLevelBySystem', originalResult.riskLevelBySystem);
                } else {
                    console.log('[retrieveDueDiligenceResult] result -----', result);
                    this.showToast('Warning', 'warning', 'Due Diligence Result not found');
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[retrieveDueDiligenceResult] error -----', errors[0].message);
                        this.showToast('Error', 'error', errors[0].message);
                    }
                } else {
                    console.log('[retrieveDueDiligenceResult] unknown error -----');
                    this.showToast('Error', 'error', 'Unknown error');
                }
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
    },

    showToast : function(title, type, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"type": type,
			"message": message
		});
		toastEvent.fire();
	},
})