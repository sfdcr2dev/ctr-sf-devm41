({
    /** Function for show message popup when action succes or error */
    constants: {},
    util: {
        showToast: function (type, title, message) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                mode: 'dismissible',
                duration: 10000,
                title: title,
                message: message,
                type: type,
            });
            toastEvent.fire();
        },
    },

    /** This function forces a function to wait a certain amount of time before running again.*/
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

    /** Default value to display in form */
    initializeComponent: function (component, event, helper) {
        component.set('v.constants', helper.constants);

        helper.modal = component.find("overlayLib");
        helper.today = $A.localizationService.formatDate(new Date(), 'YYYY-MM-DD');
    },

    /**
     * this function used to connect apex controller and call getRelevantUsers method
     * set value to display with response
     */
    getRelevantUsers: function (component, event, helper, resolve) {
        let action = component.get('c.getRelevantUsers');

        action.setParams({
            actionId: component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.relevantUsers', result);

                if ($A.util.isEmpty(result)) {
                    helper.addRelevantUser(component, event, helper);
                }

                if (typeof (resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
            }
        });

        $A.enqueueAction(action);
    },

    /**
    * this function used to connect apex controller and call getRelevantUsers method
    * set value to display with response
    */
   getActionOwner: function (component, event, helper, resolve) {
       let action = component.get('c.getActionOwner');

       action.setParams({
           actionId: component.get('v.recordId')
       });
       action.setCallback(this, function (response) {
           let state = response.getState();

           if (state === 'SUCCESS') {
               let result = response.getReturnValue();
               component.set('v.ownerId', result);

               if (typeof (resolve) === 'function') {
                   resolve(result);
               }
           } else if (state === 'ERROR') {
               let error = response.getError();
           }
       });

       $A.enqueueAction(action);
   },

    /**
     * Function called when relavant user response from apex controller is empty
     * set value to display with empty string
     */
    addRelevantUser: function (component, event, helper) {
        let relevantUsers = component.get('v.relevantUsers');
        relevantUsers.push({
            'RelevantUser__c': '',
        });
        component.set('v.relevantUsers', relevantUsers);
    },

    /** Get and Set the value that the user has entered for the item to be deleted. */
    deleteRelevantUser: function (component, event, helper) {
        let elm = event.currentTarget;
        let index = elm.dataset.index;
        let relevantUsers = component.get('v.relevantUsers');
        let deleteRelevantUsers = component.get('v.deleteRelevantUsers');

        if (!$A.util.isEmpty(relevantUsers[index].Id)) {
            deleteRelevantUsers.push(relevantUsers[index]);
        }
        relevantUsers.splice(index, 1);

        component.set('v.relevantUsers', relevantUsers);
        component.set('v.deleteRelevantUsers', deleteRelevantUsers);
    },

    /**
     * This function used to connect apex controller and call updateRelevantUsers method.
     * pass parameter with action id, list of lastest relavant user,list of relavant user that want to delete.
     * The response is a list of users involved after deletion (if any).
     */
    updateRelevantUsers: function (component, event, helper, resolve) {
        let action = component.get('c.updateRelevantUsers');

        action.setParams({
            actionId: component.get('v.recordId'),
            relevantUsers: component.get('v.relevantUsers'),
            deleteRelevantUsers: component.get('v.deleteRelevantUsers'),
        });

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();

                this.util.showToast('success', 'Success', $A.get("$Label.c.ORTLActAddRelSc"));
                this.closeModal(component, event, helper);

                $A.get('e.force:refreshView').fire();

                if (typeof (resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
                this.util.showToast('error', 'Error', $A.get("$Label.c.ORTLErrorMsg"));
            }
        });

        $A.enqueueAction(action);
    },

    /** Set the value to the attribute.  */
    closeModal: function (component, event, helper) {
        this.modal.notifyClose();
    },

    /** Check the list of relavant users for duplicates. */
    verifyDuplicatedRelevantUser: function(component, event, helper) {
        let regex = /relevant-(\d+)/;
        let cmp = event.getSource();
        let className = cmp.get('v.class');
        let matches = regex.exec(className);
        let clickIndex = matches[1];
        let ownerId = component.get('v.ownerId')

        let relevantUsers = component.get('v.relevantUsers');
        relevantUsers.forEach(function(value, index) {
            if (relevantUsers[clickIndex].RelevantUser__c == ownerId) {
                helper.util.showToast('error', 'Error', $A.get("$Label.c.ORTLActDupRelEr"));
                relevantUsers[clickIndex].RelevantUser__c = '';
                cmp.reset();
            }
            if (clickIndex == index) {
                return;
            }
            if (relevantUsers[clickIndex].RelevantUser__c == value.RelevantUser__c) {
                // Custom Label
                helper.util.showToast('error', 'Error', $A.get("$Label.c.ORTLActDupRelEr"));
                relevantUsers[clickIndex].RelevantUser__c = '';
                cmp.reset();
            }
        });

        component.set('v.relevantUsers', relevantUsers);
    },
    /**
    * verify permission for edit action record.
    */
    canEditAction : function(component, event, helper) {
       try {
           let action = component.get('c.canEditAction');
           action.setParams({
               action: {
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
                       helper.closeModal(component, event, helper);
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