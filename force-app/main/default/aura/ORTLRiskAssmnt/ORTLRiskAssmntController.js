({
    // Bind to component init event.
    doInit: function (component, event, helper) {
        // Initialize global constants
        helper.initializeComponent(component, event, helper);

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
            helper.makeRiskLevelOptions(component, event, helper, values[0], values[1])
        });
    },
    // force:recordData recordUpdated event listener.
    handleRecordUpdated: function (component, event, helper) {
        // Clone object to writable (Original bind to force:recordData are readonly some fields)
        component.set('v.risk', JSON.parse(JSON.stringify(component.get('v.risk'))));

        helper.getAttendees(component, event, helper);
        helper.getContentDocumentLinks(component, event, helper);
    },
    // Handle click consequence description.
    handleClickConsequenceDescription: function (component, event, helper) {
        let elm = event.currentTarget;
        component.set('v.risk.IntRiskCons__c', elm.dataset.consequence);
        component.set('v.risk.InitialSeverity__c', elm.dataset.severity);

        helper.highlightConsequenceDescription(component, event, helper);
    },
    // Handle click likelihood
    handleClickLikelihood: function (component, event, helper) {
        let elm = event.currentTarget;
        component.set('v.risk.InitialSeverity__c', elm.dataset.severity);
        component.set('v.risk.IntlLikelihood__c', elm.dataset.likelihood);

        helper.highlightRiskLevel(component, event, helper);
    },
    // Handle click save final risk assessment.
    handleClickSave: function (component, event, helper) {
        // Update initial risk assessment include attendees
        helper.debounce('updateInitialRiskAssessment', $A.getCallback(function () {
            helper.updateInitialRiskAssessment(component, event, helper);
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
})