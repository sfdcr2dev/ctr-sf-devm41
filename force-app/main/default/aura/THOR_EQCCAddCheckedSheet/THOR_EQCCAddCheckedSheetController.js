({
    doInit: function (component, event, helper) {
        let action = component.get("c.retrieveSuggestedCheckedSheets");
        action.setParams({
            headerId: component.get("v.eqccHeaderId") 
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            
            if (state === 'SUCCESS') {
                let sheets = response.getReturnValue();
                component.set('v.sheets', sheets);

                component.set('v.isLoading', false);
                let modal = component.find('modal');
                $A.util.removeClass(modal, "slds-is-relative");
            } else {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.find("notifLib").showToast({
                            variant: "error",
                            title: errors[0].message
                        });
                    }
                }
                component.set('v.isLoading', false);
            }
        });
        
        $A.enqueueAction(action);
    },

    handleHeaderSheetCreation: function(component, event, helper) {
        let modal = component.find('modal');
        $A.util.addClass(modal, "slds-is-relative");
        component.set('v.isLoading', true);
        let sheet = event.currentTarget.dataset.sheet;
        let header = component.get('v.eqccHeaderId');
        let action = component.get('c.associateCheckedSheetToHeader');
        action.setParams({
            sheetId: sheet,
            headerId: header
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.isLoading', false);
                component.find("notifLib").showToast({
                    variant: "success",
                    title: "EQCC Checked Sheet associated"
                });
                component.set('v.isLoading', false);
                $A.util.removeClass(modal, "slds-is-relative");
                let headerSheetId = response.getReturnValue();
                //helper.close(component, event, helper);
                helper.getStepIdAndNavigate(component, headerSheetId);
            } else {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.isLoading', false);
                        component.find("notifLib").showToast({
                            variant: "error",
                            title: errors[0].message
                        });
                    }
                }
                component.set('v.isLoading', false);
                $A.util.removeClass(modal, "slds-is-relative");
                helper.close(component, event, helper);
            }
        });
        
        $A.enqueueAction(action);
    },

    handleClose: function(component, event, helper) {
        helper.close(component, event, helper);
    }
})