({

    /**
     * This function used to connect apex class call getActionName method.
     * pass parameter with action id 
     * set action name with result from callback
     */
    getActionName: function(component, event, helper) {
        let action = component.get('c.getActionName');
        action.setParams({
            actionId: component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                console.log(result);
                component.set('v.actionName', result.Name);
                console.log('v.actionName',component.get('v.actionName'));

            }
            // else if (state === 'ERROR') {
            //     let error = response.getError();
            // }
        });

        $A.enqueueAction(action);
    },

    /**
     * This function used to check text area input from user 
     * when user is filling in or deleting, if character has more than 1 character then submit button is enable
     */
    checkTextareaChange: function(component, event, helper) {
        var reason = component.find("field").get("v.value");
        console.log('reason=>',reason);
        if(reason.trim() != '' ){
            component.set('v.canClickSubmitBtn',false);

            console.log('have reason');
            console.log('disable btn=>',component.get('v.canClickSubmitBtn'));
        }
        if(reason.length <= 1 ){
            component.set('v.canClickSubmitBtn',true);

            console.log('have reason');
            console.log('disable btn=>',component.get('v.canClickSubmitBtn'));
        }
    },

    /** This function used to close modal when click cancle button */
    closeModal: function(component, event, helper) {
        component.find("overlayLib").notifyClose();
    },

    /**
     * This function used to connect apex controller call cancelAction method.
     * pass parameter with action id and cancel reason
     * show message popup after submit
     */
    submiDetails: function(component, event, helper) {

        var action = component.get('c.cancelAction');
        let reasons = component.find('field').get("v.value");
        console.log('reason=>',reasons);

        action.setParams({
            actionId: component.get('v.recordId'),
            reason: reasons,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('result=>',result);

                component.find('notifLib').showToast({
                    "variant":"success",
                    "title": "Success",
                    "message": $A.get("$Label.c.ORTLActCancSc")
                });
                helper.closeModal(component, event, helper);
                $A.get('e.force:refreshView').fire();
            }
            else if (state === 'ERROR') {
                let error = response.getError();
                component.find('notifLib').showToast({
                    "variant":"error",
                    "title": "Error",
                    "message": $A.get("$Label.c.ORTLActCancEr")
                });
            }
        });
        $A.enqueueAction(action);
    },

    
    /**
     * verify permission for edit owner record.
     */
    canCancelOwner : function(component, event, helper) {
        // window.setTimeout(
        //     $A.getCallback(function() {
        //         cmp.set("v.visible", true);
        //     }), 5000
        // );
        try {
            let action = component.get('c.canCancelOwner');
            action.setParams({
                action: {
                    Id: component.get('v.recordId')
                }
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let result = response.getReturnValue();
                        component.set('v.canCancel', result);
                        console.log('Can Cancel =>',component.get('v.canCancel'));
                        helper.loading(component, event, helper);

                    // window.setTimeout(
                    //     $A.getCallback(function() {
                    //         component.set('v.canCancel', result);
                    //         console.log('Can Cancel =>',component.get('v.canCancel'));
                    //     }), 0
                    // );

                    // let formFactor = component.get('v.formFactor');
                    // if (formFactor === 'DESKTOP') {
                        
                    //     if (component.get('v.canCancel')){
                    //         // helper.showModal(component, event, helper)
                    //     }
                    // }

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

    loading : function(component, event, helper) {
        if (component.get('v.canCancel')){
            component.set('v.loaded',false);
        }
        else{
            component.set('v.loaded',true);
        }
    }
})