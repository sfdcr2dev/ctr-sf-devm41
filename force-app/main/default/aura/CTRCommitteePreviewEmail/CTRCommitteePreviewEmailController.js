({
    doInit: function (component, event, helper) {
        var emailTo = component.get('v.email.EmailTo__c');

        component.set('v.formattedEmailTo', emailTo);
        if (emailTo && emailTo.includes(',')) {
            let formattedEmailTo = emailTo.replace(/,/g, ",\n");
            component.set('v.formattedEmailTo', formattedEmailTo);
            // component.set('v.formattedEmailTo', 'Multiple Recipients cannot be displayed, Please check email from previous page');
        }
    },

    closeModal: function (component, event, helper) {
        component.set("v.isModalOpen", false);
    },
})