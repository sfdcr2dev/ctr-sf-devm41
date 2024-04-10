({
    // Bind to component init event.
    doInit: function (component, event, helper) {
        // Initialize global constants
        helper.initializeComponent(component, event, helper);
        helper.canEditRisk(component, event, helper);

        let p1 = new Promise(function (resolve, reject) {
            // Fetch all picklist values: Consequence, Severity and Likelihood.
            helper.getRiskAssessmentSelectOptions(component, event, helper, resolve);
        });
        let p2 = new Promise(function (resolve, reject) {
            // Fetch all custom metadata types: Consequence Description, Risk Level, Estimated Value and Likelihood Caption.
            helper.getRiskAssessmentCustomMetadata(component, event, helper, resolve);
        });
        // After load picklists and custom metadata types.
        Promise.all([p1, p2]).then(function (values) {
            // Make data that used to render risk table.
            helper.makeRiskLevelOptions(component, event, helper, values[0], values[1]);
            // Update values that related to risk consequence, severity and likelihood.
            helper.updateAfterSelectSeverityConsequenceLikelihood(component, event, helper);
        });

        let p3 = new Promise(function (resolve, reject) {
            // Fetch all attendees that related to current risk record.
            helper.getAttendees(component, event, helper, resolve);
        });
        let p4 = new Promise(function (resolve, reject) {
            // Fetch all actions that related to current risk record.
            helper.getActions(component, event, helper, resolve);
            // Fetch all ORTL Admin users in Org.
            helper.getOrtlAdmins(component, event, helper, resolve);
        });
        Promise.all([p3, p4]).then(function (values) {
            let remoteAttendees = component.get('v.remoteAttendees');
            // If there is no attendees.
            // Default attendees.
            if ($A.util.isEmpty(remoteAttendees)) {
                helper.defaultAttendees(component, event, helper);
            }

            /* For Final Risk Assessment */
            // Default final risk consequence and consequence effect.
            helper.defaultFinalRiskValue(component, event, helper);
        });
    },
    // force:recordData recordUpdated event listener.
    handleRecordUpdated: function (component, event, helper) {
        // Clone object to writable (Original bind to force:recordData are readonly some fields)
        component.set('v.risk', JSON.parse(JSON.stringify(component.get('v.risk'))));

        // Fetch all risk attachments
        helper.getContentDocumentLinks(component, event, helper);
    },
    // Handle click consequence description. Enable this function set 'v.setting.enableSelectConsequence' to true
    handleClickConsequenceDescription: function (component, event, helper) {
        let elm = event.currentTarget;

        /* For Initial Risk Assessment */
        //component.set('v.risk.IntRiskCons__c', elm.dataset.consequence);
        //component.set('v.risk.InitialSeverity__c', elm.dataset.severity);

        /* For Final Risk Assessment */
        component.set('v.risk.FinRiskCons__c', elm.dataset.consequence);
        component.set('v.risk.FinalSeverity__c', elm.dataset.severity);

        // Make color on selected.
        helper.highlightConsequenceDescription(component, event, helper);
    },
    // Handle click risk level
    handleClickRiskLevel: function (component, event, helper) {
        let elm = event.currentTarget;

        /* For Initial Risk Assessment */
        //component.set('v.risk.IntlLikelihood__c', elm.dataset.likelihood);
        //component.set('v.risk.InitialSeverity__c', elm.dataset.severity);

        /* For Final Risk Assessment */
        component.set('v.risk.FinalLikelihood__c', elm.dataset.likelihood);
        component.set('v.risk.FinalSeverity__c', elm.dataset.severity);

        // Make color on selected.
        helper.highlightRiskLevel(component, event, helper);
    },
    // Handle click save final risk assessment.
    handleClickSave: function (component, event, helper) {
        // Display error if consequence is blank value.
        if (helper.isBlankConsequence(component, event, helper)) {
            // display error message.
            helper.util.showToast('error', 'Error', $A.get("$Label.c.ORTLRskBlkCsqEr"));
            return;
        }
        // Display error if consequence effect is blank value.
        if (helper.isBlankConsequenceEffect(component, event, helper)) {
            // display error message.
            helper.util.showToast('error', 'Error', $A.get("$Label.c.ORTLRskBlkCfEr"));
            return;
        }
        // Display error if consequence effect other is blank value.
        if (helper.isBlankConsequenceEffectOther(component, event, helper)) {
            // display error message.
            helper.util.showToast('error', 'Error', $A.get("$Label.c.ORTLRskBlkCfoEr"));
            return;
        }
        // Display error if there are some blank attendees.
        if (!helper.hasAttendee(component, event, helper)) {
            // display error message.
            helper.util.showToast('error', 'Error', $A.get("$Label.c.ORTLRskNoAtdEr"));
            return;
        }
        if (!helper.verifyBlankAttendees(component, event, helper)) {
            // display error message.
            helper.util.showToast('error', 'Error', $A.get("$Label.c.ORTLRskBlkAtdEr"));
            return;
        }
        // Display error if consequence effect other is blank value.
        if (helper.requireFinalRiskReason(component, event, helper)) {
            // display error message.
            helper.util.showToast('error', 'Error', $A.get("$Label.c.ORTLRskFnReasonEr"));
            return;
        }
        /* For Initial Risk Assessment */
        // Update initial risk assessment include attendees
        //helper.debounce('updateInitialRiskAssessment', $A.getCallback(function () {
        //    helper.updateInitialRiskAssessment(component, event, helper);
        //}), 500).apply(this);

        /* For Final Risk Assessment */
        // Update final risk assessment include attendees
        helper.debounce('updateFinalRiskAssessment', $A.getCallback(function () {
           helper.updateFinalRiskAssessment(component, event, helper);
        }), 500).apply(this);
    },
    // Handle after upload attachment finished event then rename file to specific format.
    handleUploadFinished: function (component, event, helper) {
        // Rename attachment.
        helper.renameUploadedFile(component, event, helper);
        // Fetch all attachments to rerender attachment list.
        helper.getContentDocumentLinks(component, event, helper);
    },
    // Handle click attachment to preview content.
    handleClickPreview: function (component, event, helper) {
        // Preview content
        helper.previewAttachment(component, event, helper);
    },
    // Handle click cancel.
    handleClickCancel: function (component, event, helper) {
        // Close modal.
        helper.closeModal(component, event, helper);
    },
    // Handle click add attendee.
    handleClickAddAttendee: function (component, event, helper) {
        // Add new attendee.
        helper.addAttendee(component, event, helper);
    },
    // Handle click delete attendee.
    handleClickDeleteAttendee: function (component, event, helper) {
        // Remove selected attendee.
        helper.deleteAttendee(component, event, helper);
    },
    // Handle select/change attendee event.
    handleChangeAttendee: function (component, event, helper) {
        // Verify attendee could not duplicated.
        setTimeout(function() {
            helper.verifyDuplicatedAttendee(component, event, helper);
        }, 500);
    },
    // Handle refresh view event.
    handleRefreshView: function (component, event, helper) {
        // reload after delete attachment.
        helper.getContentDocumentLinks(component, event, helper);
    },
})