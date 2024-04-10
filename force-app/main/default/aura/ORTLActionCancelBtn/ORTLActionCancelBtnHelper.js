({
    /** 
     * This function used to call another component to show custom modal
     * by way, content is component that you call 
     */
    showModal: function (component, event, helper) {
        $A.createComponent("c:ORTLActionCancel", {
            recordId: component.get('v.recordId')
        },
            function (content, status) {
                if (status === "SUCCESS") {
                    
                    component.find('overlayLib').showCustomModal({
                        // header: "Cancel "+component.get('v.recordId'),
                        body: content,
                        showCloseButton: true,
                        //cssClass: "",
                    })
                    helper.closeQuickAction(component, event, helper)
                }
            });
    },
    closeQuickAction: function (component, event, helper) {
        let dismissActionPanel = $A.get("e.force:closeQuickAction")
        if (dismissActionPanel) {
            dismissActionPanel.fire()
        }
    },

    /** This function used to close modal when click cancle button */
    // closeModal: function(component, event, helper) {
    //     component.find("overlayLib").notifyClose();
    // },

    /**
     * verify permission for edit owner record.
     */
    // canCancelOwner : function(component, event, helper) {
    //     try {
    //         let action = component.get('c.canCancelOwner');
    //         action.setParams({
    //             action: {
    //                 Id: component.get('v.recordId')
    //             }
    //         });
    //         action.setCallback(this, function (response) {
    //             let state = response.getState();
    //             if (state === 'SUCCESS') {
    //                 let result = response.getReturnValue();
    //                 component.set('v.canCancel', result);
    //                 console.log('result =>',component.get('v.canCancel'));

    //                 let formFactor = component.get('v.formFactor');
    //                 if (formFactor === 'DESKTOP') {
                        
    //                     if (component.get('v.canCancel')){
    //                         helper.showModal(component, event, helper)
    //                     }
    //                     // else{
    //                     //     component.find('notifLib').showToast({
    //                     //         "variant":"error",
    //                     //         "title": "You Can Not Cancle Action ",
    //                     //         "message": "Only Owner and ORTL Admin can cancle action"
    //                     //     });

    //                     //     helper.closeModal(component, event, helper);
    //                     //     // $A.get('e.force:refreshView').fire();
    //                     // }
    //                 }

    //             } else {
    //                 let errors = response.getError();
    //                 console.error(errors);
    //             }
    //         });
    //         $A.enqueueAction(action);
    //     } catch(ex) {
    //         console.log(ex.message);
    //     }
    // },

    // getActionName: function(component, event, helper) {
    //     let action = component.get('c.getActionName');
    //     action.setParams({
    //         actionId: component.get('v.recordId')
    //     });
    //     action.setCallback(this, function (response) {
    //         let state = response.getState();

    //         if (state === 'SUCCESS') {
    //             let result = response.getReturnValue();
    //             console.log(result);
    //             component.set('v.actionName', result.Name);
    //             console.log('v.actionName',component.get('v.actionName'));

    //         }
    //     });
    //     $A.enqueueAction(action);
    // },

})