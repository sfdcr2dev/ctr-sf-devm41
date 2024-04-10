({
    /**
     * Initialize Function used to Fetch the value as soon as the component is started.
     * get value record detail and set default value to attribute after component render.
     */
    doInit: function (component, event, helper) {
        helper.initializeComponent(component, event, helper);
        helper.getRelevantUsers(component, event, helper);
        helper.getActionOwner(component, event, helper);
        helper.canEditAction(component, event, helper);
    },

    /** Event Handler when add relavant use's action is changed or add relavant user*/
    handleClickAddRelevantUser: function (component, event, helper) {
        helper.addRelevantUser(component, event, helper);
    },

    /** Event Handler when add relavant use's action is changed or delete relavant user*/
    handleClickDeleteRelevantUser: function (component, event, helper) {
        helper.deleteRelevantUser(component, event, helper)
    },

    /** Event Handler when click save button*/
    handleClickSave: function (component, event, helper) {
        helper.debounce('updateRelevantUsers', $A.getCallback(function () {
            helper.updateRelevantUsers(component, event, helper);
        }), 500).apply(this);
    },

    /** Event Handler when click cancel button*/
    handleClickCancel: function (component, event, helper) {
        helper.closeModal(component, event, helper);
    },

    /** Event Handler to pass value to display relavant user after check dupplicate already*/
    handleChangeRelevantUser: function (component, event, helper) {
        setTimeout(function() {
            helper.verifyDuplicatedRelevantUser(component, event, helper);
        }, 500);
    },
})