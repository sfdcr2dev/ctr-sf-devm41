({
    /**
     * Initialize Function used to Fetch the value as soon as the component is started.
     * call helper method named getActioName
     */
    doInit: function (component, event, helper) {
        helper.getActionName(component, event, helper);
        helper.canCancelOwner(component, event, helper);
    },

    /** Call helper function checkTextareaChange that is check text area input from user */
    handleCheckTextareaChange: function(component, event, helper){
        console.log('--Input reason--');
        helper.checkTextareaChange(component, event, helper);
    },

    /** Set the value to the attribute.*/
    openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },

    /** Call helper function closeModal that is action for close */
    clickCloseModal: function(component, event, helper) {
        console.log('--Clicked Close Modal--');
        helper.closeModal(component, event, helper);
    },

    /** Call helper function submiDetails that is action for submit */
    clickSubmitDetails: function(component, event, helper) {
        console.log('--Clicked Submit--');
        helper.submiDetails(component, event, helper);
    },

    /** Event Handler for check text area input when user fill in*/
    handleClick: function(cmp) {
        var textarea = cmp.find("mytextarea");
        //textarea.focus();
        textarea.setRangeText('Some new text', 0, 0, 'select');
    },

    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})