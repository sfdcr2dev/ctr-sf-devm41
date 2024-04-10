({
    doInit: function (component, event, helper) {
        component.set('v.constants', helper.constants);

        let pageref = component.get('v.pageReference');
        if (pageref && !component.get('v.recordId')) {
            let { c__recordId } = pageref.state;
            component.set('v.recordId', c__recordId);
        }

        helper.getFormQuestions(component, event, helper);
        helper.getFormAnswers(component, event, helper);
        helper.getPISUser(component, event, helper);
        helper.canEditOrSubmit(component, event, helper);
        // helper.getMySavePermitToWork(component, event, helper);

    },
    handleSelectButtonMenu: function (component, event, helper) {
        var selectedFunc = event.getParam('value');
        if (selectedFunc) {
            $A.enqueueAction(component.get(selectedFunc));
        }

    },
    toggleSaveDraftModal: function (component, event, helper) {
        component.set('v.isDraftModalOpen', true)
        // helper.savePermitToWork(component, event, helper);

    },
    closeSaveDraftModel: function (component, event, helper) {
        component.set("v.isDraftModalOpen", false);
    },
    handleSaveDraft: function (component, event, helper) {
        component.set("v.isDraftModalOpen", false);
        helper.savePermitToWork(component, event, helper);

    },
    toggleSubmitModal: function (component, event, helper) {
        component.set('v.isSubmitModalOpen', true)
    },
    closeSubmitModel: function (component, event, helper) {
        component.set("v.isSubmitModalOpen", false);

    },
    handleDisagree: function (component, event, helper) {
        // component.set("v.isDraftModalOpen", false);
        // helper.savePermitToWork(component, event, helper);

    },
    // toggleDisagreeModal: function (component, event, helper) {
    //     component.set('v.isDisagreeModalOpen', true);

    // },
    closeDisagreeModel: function (component, event, helper) {
        helper.closeReasonForDisagreeModal(component, event, helper);
    },
    handleDisagreeSubmit: function (component, event, helper) {
        component.set("v.isDisagreeModalOpen", false);
        // alert('in handle handleDisagreeSubmit');
        //helper.displaySelectedFormQuestions(component, event, helper);
        component.set("v.status", "Disagree");
        helper.submitPermitToWork(component, event, helper);
        component.set("v.disableSaveDraft", true);

        var compEvent = component.getEvent("sampleComponentEvent");
        compEvent.setParams({ "message": "Static Text" });
        compEvent.fire();
    },
    handleSubmit: function (component, event, helper) {
        // alert('in handle submit ');
        //component.set("v.status", "Agree");
        //component.set("v.modalAnswer", "");
        //helper.submitPermitToWork(component, event, helper);
        //component.set("v.isGreen", true);
        //component.set("v.disableSaveDraft", true);

        if (helper.checkStatusAnswer(component, event, helper) == 'Disagree') {
            helper.showReasonForDisagreeModal(component, event, helper);
        } else {
            component.set("v.status", "Agree");
            component.set("v.modalAnswer", "");
            component.set("v.isGreen", true);
            component.set("v.disableSaveDraft", true);

            helper.submitPermitToWork(component, event, helper);
        }
    },
    handleSubmitDisagree: function (component, event, helper) {
        if (!helper.checkReasonForDisagreeIsBlank(component, event, helper)) {
            component.set("v.status", "Disagree");
            component.set("v.isGreen", true);
            component.set("v.disableSaveDraft", true);

            helper.submitPermitToWork(component, event, helper);
        } else {
            component.set("v.isBlankReasonForDisagree", true);
        }
    },
    handleSelectPermitToWork: function (component, event, helper) {
        let ptwHeaderId = event.currentTarget.getAttribute('data-record-id');
        component.set('v.selectedFormQuestions', ptwHeaderId);
        helper.displaySelectedFormQuestions(component, event, helper);
    },
    handleSuggestLookupChanged: function (component, event, helper) {
        const { value, displayValue } = event.getParams();
        if (displayValue) {
            console.log('displayValue', displayValue);
            let displayedFormQuestions = component.get('v.displayedFormQuestions');
            let name = displayedFormQuestions.find(function (value) {
                return value.Question__c == 'Name';
            })
            name.Answer__c = displayValue;
            component.set('v.displayedFormQuestions', displayedFormQuestions);
            //component.set('v.value', displayValue);
        }
    },
    handleVerificationChanged: function (component, event, helper) {
        helper.checkIsValidRequireFields(component, event, helper);
    },
    handleReasonForDisagreeChange: function (component, event, helper) {
        component.set('v.isBlankReasonForDisagree', false);
    },
    handleUploadFinished: function (component, event, helper) {
        helper.showToast('success', 'Success', 'File uploaded successfully');
        component.find('verificationRelatedFiles') && component.find('verificationRelatedFiles').refresh();
    },
})