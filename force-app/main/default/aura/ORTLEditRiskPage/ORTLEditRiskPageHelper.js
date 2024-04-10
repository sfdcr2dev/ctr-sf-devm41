({
    /** Navigate or ridirect to view record page  */
    navigateToPage: function (component) {
        component.find('navService').navigate(
            {
                type: 'standard__recordPage',
                attributes: {
                    recordId: component.get('v.recordId'),
                    objectApiName: "ORTLRisk__c",
                    actionName: "view"
                }
            },
            false
        );
    },

	// Debounce function to prevent double sumitting.
    debounce: function (funcname, func, wait) {
        let DEBOUNCE = this.debounce;
        return $A.getCallback(function () {
            if (!DEBOUNCE.timer) {
                DEBOUNCE.timer = {};
            }

            let context = this;
            let args = arguments;
            clearTimeout(DEBOUNCE.timer[funcname]);
            DEBOUNCE.timer[funcname] = setTimeout(function () {
                //DEBOUNCE.timer[funcname] = null;
                func.apply(context, args);
            }, wait);
        });
    },

    /**
     * This function used to connect apex controller and call method to get records
     * pass parameter and set fields form with response
     */
    getFunctionLocationDetail: function (component, event, helper, funcLocationId) {
        if (funcLocationId) {
            let action = component.get('c.getFunctionLocationDetail');
            action.setParams({
                funcLocationId: funcLocationId
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let result = response.getReturnValue();
                    component.set('v.apu', result.APU__c);
                    component.set('v.unit', result.Unit__c);
                    component.set('v.plantsection', result.PlantSection__c);
                    component.set('v.discipline', result.Discipline__c);
                    component.set('v.planningplant', result.Planning_Plant_Text__c);
                    component.set('v.formData.APU__c', result.APU__c);
                    component.set('v.formData.PlantSection__c', result.PlantSection__c);
                    component.set('v.formData.Discipline__c', result.Discipline__c);
                    component.set('v.formData.txtPlanningPlant__c', result.Planning_Plant_Text__c);
                } else {
                    let errors = response.getError();
                    console.error(errors);
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set('v.apu', '');
            component.set('v.unit', '');
            component.set('v.plantsection', '');
            component.set('v.discipline', '');
            component.set('v.planningplant', '');
            component.set('v.formData.APU__c', '');
            component.set('v.formData.PlantSection__c', '');
            component.set('v.formData.Discipline__c', '');
            component.set('v.formData.txtPlanningPlant__c', '');
        }
    },

    /**
     * This function used to connect apex controller and call method to get records
     * pass parameter and set fields form with response
     */
    getRelatedRisk: function (component, event, helper) {
        let action = component.get('c.getRelatedRisk');
        action.setParams({
            ortl: {
                Id: component.get('v.recordId')
            }
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.relatedRisk', result);
            } else {
                let errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },

    /**
     * Show message after record updated.
     * Risk "(Risk's Name)" was updated.
     */
    handleSuccessToast : function(component, event, helper) {
        let riskName = component.get('v.formData.Name');
        component.find('notifLib').showToast({
            "variant":"success",
            //"title": "Risk \"" + riskName + "\" was updated.",
            //"message": "The record has been updated successfully.",
            "title": String($A.get("$Label.c.ORTLRskEditHSc")).replace(/{!\s*ORTLRisk__c.Name\s*}/, riskName),
            "message": $A.get("$Label.c.ORTLRskEditSc"),
        });
    },

    /**
     * verify permission for edit owner record.
     */
    canEditOwner : function(component, event, helper) {
        try {
            let action = component.get('c.canEditOwner');
            action.setParams({
                ortl: {
                    Id: component.get('v.recordId')
                }
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let result = response.getReturnValue();
                    component.set('v.canEditOwner', result);
                } else {
                    let errors = response.getError();
                    console.error(errors);
                }
            });
            $A.enqueueAction(action);
        } catch(ex) {
            console.log(ex.message);
        }
    },

    /**
     * verify permission for edit risk record.
     */
    canEditRisk : function(component, event, helper) {
        try {
            let action = component.get('c.canEditRisk');
            action.setParams({
                ortl: {
                    Id: component.get('v.recordId')
                }
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let result = response.getReturnValue();

                    if (!result) {
                        //helper.util.showToast('Error', 'error', 'Unauthorized Access.');
                        component.find('notifLib').showToast({
                            "variant":"error",
                            "title": "Error",
                            "message": $A.get("$Label.c.ORTLRskUnAuthEr"),
                        });
                        helper.navigateToPage(component);
                    }
                } else {
                    let errors = response.getError();
                    console.error(errors);
                }
            });
            $A.enqueueAction(action);
        } catch(ex) {
            console.log(ex.message);
        }
    },
})