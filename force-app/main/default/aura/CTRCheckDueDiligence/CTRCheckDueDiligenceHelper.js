({
    retrieveRiskLevel : function(component) {
        component.set('v.isLoaded', false);
        var action = component.get("c.retrieveRiskLevel");
        action.setParams({
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('[retrieveRiskLevel] result -----', result);
                for(var i=0; i<result.length; i++) {
                    if(!$A.util.isEmpty(result[i].disabled) && !result[i].disabled) {
                        component.set('v.hasPermission', true);
                        break;
                    }
                }
                component.set('v.riskLevelList', result);
                if(!$A.util.isEmpty(component.get('v.riskLevelBySystem'))) {
                    var riskLevelBySystem = component.get('v.riskLevelBySystem');
                    this.updateRiskLevel(component, riskLevelBySystem.fieldName, riskLevelBySystem.value);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[retrieveRiskLevel] error -----', errors[0].message);
                        this.showToast('Error', 'error', errors[0].message);
                    }
                } else {
                    console.log('[retrieveRiskLevel] unknown error -----');
                    this.showToast('Error', 'error', 'Unknown error');
                }
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
    },

    updateRiskLevel : function(component, fieldName, value) {
        console.log('[updateRiskLevel] ' + fieldName + ' -----', value);
        var riskLevelList = component.get('v.riskLevelList');
        for(var i=0; i<riskLevelList.length; i++) {
            if(riskLevelList[i].fieldName == fieldName) {
                for(var j=0; j<riskLevelList[i].options.length; j++) {
                    if(riskLevelList[i].options[j].value == value) {
                        riskLevelList[i].options[j].isSelected = true;
                    } else {
                        riskLevelList[i].options[j].isSelected = false;
                    }
                }
            }
        }
        console.log('[updateRiskLevel] riskLevelList -----', Object.assign({}, riskLevelList));
        component.set('v.riskLevelList', riskLevelList);
    },

    updateDueDiligence : function(component, type) {
        if(!$A.util.isEmpty(component.get('v.riskLevelList'))) {
            component.set('v.isLoaded', false);
            var riskLevelInfo = {};
            var riskLevelList = component.get('v.riskLevelList');
            for(var i=0; i<riskLevelList.length; i++) {
                for(var j=0; j<riskLevelList[i].options.length; j++) {
                    if(riskLevelList[i].options[j].isSelected == true) {
                        riskLevelInfo[riskLevelList[i].fieldName] = riskLevelList[i].options[j].value;
                        break;
                    }
                }
                if($A.util.isEmpty(riskLevelInfo[riskLevelList[i].fieldName])) {
                    riskLevelInfo[riskLevelList[i].fieldName] = '';
                }
            }
            riskLevelInfo['Id'] = component.get('v.recordId');
            if(type == 'submit') {
                // update more fields
            }
            console.log('[updateDueDiligence] riskLevelInfo -----', riskLevelInfo);
            var action = component.get("c.updateDueDiligence");
            action.setParams({
                "riskLevelInfo": JSON.stringify(riskLevelInfo)
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    this.closeModal(component);
                    
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if(errors) {
                        if(errors[0] && errors[0].message) {
                            console.log('[updateDueDiligence] error -----', errors[0].message);
                            this.showToast('Error', 'error', errors[0].message);
                        }
                    } else {
                        console.log('[updateDueDiligence] unknown error -----');
                        this.showToast('Error', 'error', 'Unknown error');
                    }
                }
                component.set('v.isLoaded', true);
            });
            $A.enqueueAction(action);
        }
    },

    closeModal : function(component) {
        component.set("v.isLoaded", true);
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
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