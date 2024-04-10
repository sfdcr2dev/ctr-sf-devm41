({
    constants: {},
    // Utility method
    util: {
        // For showing toast message.
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
        // For formatting abbreviation currency.
        shortenCurrency: function (number) {
            let txt = 'N/A';
            let value = Number(number);

            if (value > 1000000000) {
                txt = Math.round(value / 1000000000) + 'B';
            } else if (value > 1000000) {
                txt = Math.round(value / 1000000) + 'M';
            } else if (value >  1000) {
                txt = Math.round(value / 1000) + 'K';
            } else if (value <= 1000) {
                txt = Math.round(value) + '';
            }
            return txt;
        },
    },
    // Debounce function to prevent double sumitting.
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
    // Initialize global variables used in component.
    initializeComponent: function (component, event, helper) {
        component.set('v.constants', helper.constants);

        helper.modal = component.find("overlayLib");
        helper.today = $A.localizationService.formatDate(new Date(), 'YYYY-MM-DD');
    },
    // Call remote function to fetch all picklist values.
    getRiskAssessmentSelectOptions: function (component, event, helper, resolve) {
        let action = component.get('c.getRiskAssessmentSelectOptions');

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.options', result);

                if (typeof (resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
            }
        });

        $A.enqueueAction(action);
    },
    // Call remote function to fetch all custom metadata types.
    getRiskAssessmentCustomMetadata: function (component, event, helper, resolve) {
        let action = component.get('c.getRiskAssessmentCustomMetadata');

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.metadata', result);

                if (typeof (resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
            }
        });

        $A.enqueueAction(action);
    },
    // Call remote function to fetch all attachments.
    getContentDocumentLinks: function (component, event, helper, resolve) {
        let action = component.get('c.getContentDocumentLinks');

        action.setParams({
            ortl: component.get('v.risk')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.attachments', helper.filterInitialRiskAttacthments(component, event, helper, result));

                if (typeof (resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
            }
        });

        $A.enqueueAction(action);
    },
    // Construct data structure used to render Risk Table.
    makeRiskLevelOptions: function (component, event, helper, options, metadata) {
        options.InitialLikelihood.forEach(function (likelihood) {
            metadata.LikelihoodCaption.forEach(function (caption) {
                if (String(likelihood.value).toLowerCase() === String(caption.DeveloperName).toLowerCase()) {
                    likelihood.Caption1__c = caption.Caption1__c;
                    likelihood.Caption2__c = caption.Caption2__c;
                    likelihood.Caption3__c = caption.Caption3__c;
                    likelihood.Caption4__c = caption.Caption4__c;
                }
            });
        });

        options.InitialSeverity.forEach(function (severity) {
            severity.ConsequenceDescription = [];
            options.InitialRiskConsequence.forEach(function (consequence) {
                metadata.ConsequenceDescription.forEach(function (effect) {
                    if (String(severity.value).toLowerCase() === String(effect.Severity__c).toLowerCase()
                        && String(consequence.value).toLowerCase() === String(effect.Consequence__c).toLowerCase()) {
                        severity.ConsequenceDescription.push(effect);
                    }
                })
            });

            severity.RiskLevel = [];
            options.InitialLikelihood.forEach(function (likelihood) {
                metadata.RiskLevel.forEach(function (level) {
                    if (String(severity.value).toLowerCase() === String(level.Severity__c).toLowerCase()
                        && String(likelihood.value).toLowerCase() === String(level.Likelihood__c).toLowerCase()) {
                            level.EstValueMUSD__c = helper.util.shortenCurrency(level.EstValueUSD__c);
                            severity.RiskLevel.push(level);
                    }
                });
            });
        });
        component.set('v.options', options);
    },
    // Make color for selected item.
    highlightConsequenceDescription: function (component, event, helper) {
        helper.updateAfterSelectSeverityConsequenceLikelihood(component, event, helper);
    },
    // Make color for selected item.
    highlightRiskLevel: function (component, event, helper) {
        helper.updateAfterSelectSeverityConsequenceLikelihood(component, event, helper);
    },
    // Update values that related to risk consequence, severity and likelihood.
    // And make color for selected item.
    updateAfterSelectSeverityConsequenceLikelihood: function(component, event, helper) {
//        let consequence = component.get('v.risk.IntRiskCons__c');
//        let severity = component.get('v.risk.InitialSeverity__c');
//        let likelihood = component.get('v.risk.IntlLikelihood__c');
//
//        let metadata = component.get('v.metadata');
////        metadata.ConsequenceEffect.forEach(function (effect) {
////            if (String(severity).toLowerCase() === String(effect.Severity__c).toLowerCase()
////                && String(consequence).toLowerCase() === String(effect.Consequence__c).toLowerCase()) {
////                let risk = component.get('v.risk');
////                //risk.IntConsEffect__c = effect.Consequence_Effect__c;
////                //component.set('v.consequenceEffect', effect.Consequence_Effect__c);
////                component.set('v.risk', risk);
////            }
////        });
//
//        metadata.RiskLevel.forEach(function (level) {
//            if (String(severity).toLowerCase() === String(level.Severity__c).toLowerCase()
//                && String(likelihood).toLowerCase() === String(level.Likelihood__c).toLowerCase()) {
//                let risk = component.get('v.risk');
//                risk.InitialRisk__c = level.RiskLevel__c;
//                component.set('v.risk', risk);
//                component.set('v.estimatedValueInUSD', helper.util.shortenCurrency(level.EstValueUSD__c) + 'USD');
//                component.set('v.estimatedValueInTHB', helper.util.shortenCurrency(level.EstValueTHB__c) + 'THB');
//            }
//        });

        // Initial Risk Assessment
        let initialSeverity = component.get('v.risk.InitialSeverity__c');
        let initialLikelihood = component.get('v.risk.IntlLikelihood__c');
        // Final Risk Assessment
        //let finalSeverity = component.get('v.risk.FinalSeverity__c');
        //let finalLikelihood = component.get('v.risk.FinalLikelihood__c');

        let metadata = component.get('v.metadata');
        metadata.RiskLevel.forEach(function (level) {
            // Initial Risk Assessment
            if (String(initialSeverity).toLowerCase() === String(level.Severity__c).toLowerCase()
                && String(initialLikelihood).toLowerCase() === String(level.Likelihood__c).toLowerCase()) {
                let risk = component.get('v.risk');
                risk.InitialRisk__c = level.RiskLevel__c;
                component.set('v.risk', risk);
                component.set('v.initialEstimatedValueInUSD', helper.util.shortenCurrency(level.EstValueUSD__c));
                component.set('v.initialEstimatedValueInTHB', helper.util.shortenCurrency(level.EstValueTHB__c));
            }
            // Final Risk Assessment
            //if (String(finalSeverity).toLowerCase() === String(level.Severity__c).toLowerCase()
            //    && String(finalLikelihood).toLowerCase() === String(level.Likelihood__c).toLowerCase()) {
            //    let risk = component.get('v.risk');
            //    risk.FinalRisk__c = level.RiskLevel__c;
            //    component.set('v.risk', risk);
            //    component.set('v.finalEstimatedValueInUSD', helper.util.shortenCurrency(level.EstValueUSD__c));
            //    component.set('v.finalEstimatedValueInTHB', helper.util.shortenCurrency(level.EstValueTHB__c));
            //}
        });
    },
    // Call remote function to rename attachment.
    renameUploadedFile: function (component, event, helper, resolve) {
        let action = component.get('c.renameUploadedFile');
        let files = event.getParam('files');

        action.setParams({
            ortl: component.get('v.risk'),
            documentId: files[0].documentId,
            title: helper.generateUploadedFileName(component, event, helper)
        });

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.attachments', helper.filterInitialRiskAttacthments(component, event, helper, result));

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
    // Contruct filename to specific format.
    generateUploadedFileName: function (component, event, helper, resolve) {
        let risk = component.get('v.risk');
        let nextRunningNo = '01';

        let attachments = component.get('v.attachments');
        if ($A.util.isArray(attachments) && attachments.length > 0) {
            let maxRunningNo = 1;
            // Find max running no in all attachment. Format are [Risk No]_Initial_[XX] or [Risk No]_Final_[XX]
            attachments.forEach(function (value) {
                let titles = value.ContentDocument.Title.split('_');
                let runningNo = Number(titles[titles.length - 1]);
                if (!isNaN(runningNo)) {
                    maxRunningNo = (runningNo > maxRunningNo) ? runningNo : maxRunningNo;
                }
            });
            nextRunningNo = String(maxRunningNo + 1).padStart(2, '0');
        }

        return risk.Name + '_Initial_' + nextRunningNo;
    },
    // Filter only initial risk attachments to display.
    filterInitialRiskAttacthments: function (component, event, helper, attachments) {
        let risk = component.get('v.risk');
        let fileName = risk.Name + '_Initial_';
        return attachments.filter(function (value) {
            let title = value.ContentDocument.Title;
            return title.startsWith(fileName);
        });
    },
    // Filter only initial risk attendees to display.
    filterInitialRiskAttendees: function (component, event, helper, attendees) {
        return attendees.filter(function (value) {
            return value.Type__c == 'Initial Risk Assessment';
        });
    },
    // Call remote function to update initial risk assessment.
    updateInitialRiskAssessment: function (component, event, helper, resolve) {
        let action = component.get('c.updateInitialRiskAssessment');
        let recordLoader = component.find('recordLoader');

        action.setParams({
            ortl: component.get('v.risk'),
            attendees: component.get('v.attendees'),
            deleteAttendees: component.get('v.deleteAttendees'),
        });

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();

                recordLoader.reloadRecord(true);
                this.util.showToast('success', 'Success', $A.get("$Label.c.ORTLRskInUpdSc"));
                this.closeModal(component, event, helper);

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
    // Call remote function to get attendees related to risk records.
    getAttendees: function (component, event, helper, resolve) {
        let action = component.get('c.getAttendees');

        action.setParams({
            ortl: component.get('v.risk')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.attendees', helper.filterInitialRiskAttendees(component, event, helper, result));

                if (typeof (resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
            }
        });

        $A.enqueueAction(action);
    },
    // Utility function to close modal
    closeModal: function (component, event, helper) {
        this.modal.notifyClose();
    },
    // Add blank attendee to list when click add attendee.
    addAttendee: function (component, event, helper) {
        let attendees = component.get('v.attendees');
        attendees.push({
            'Type__c': 'Initial Risk Assessment',
            'AttendeeName__c': '',
        });
        component.set('v.attendees', attendees);
    },
    // Remove selected attendee from list when click remove attendee.
    deleteAttendee: function (component, event, helper) {
        let elm = event.currentTarget;
        let index = elm.dataset.index;
        let attendees = component.get('v.attendees');
        let deleteAttendees = component.get('v.deleteAttendees');

        if (!$A.util.isEmpty(attendees[index].Id)) {
            deleteAttendees.push(attendees[index]);
        }
        attendees.splice(index, 1);

        component.set('v.attendees', attendees);
        component.set('v.deleteAttendees', deleteAttendess);
    },
    // Call salesforce api to preview attachment.
    previewAttachment: function (component, event, helper) {
        let clickeFiledId = event.currentTarget.dataset['contentDocumentId'];
        component.find('navService').navigate(
            {
                type: 'standard__namedPage',
                attributes: {
                    pageName: 'filePreview',
                },
                state: {
                    recordIds: clickeFiledId,
                    selectedRecordId: clickeFiledId
                }
            },
            false
        );
    },
})