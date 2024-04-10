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
                /* For Initial Risk Assessment */
                component.set('v.attachments', helper.filterInitialRiskAttacthments(component, event, helper, result));

                /* For Final Risk Assessment */
                //component.set('v.attachments', helper.filterFinalRiskAttacthments(component, event, helper, result));

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
        /* For Initial Risk Assessment */
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
                metadata.ConsequenceDescription.forEach(function (desc) {
                    if (String(severity.value).toLowerCase() === String(desc.Severity__c).toLowerCase()
                        && String(consequence.value).toLowerCase() === String(desc.Consequence__c).toLowerCase()) {
                        severity.ConsequenceDescription.push(desc);
                    }
                })
            });

            severity.RiskLevel = [];
            options.InitialLikelihood.forEach(function (likelihood) {
                metadata.RiskLevel.forEach(function (level) {
                    if (String(severity.value).toLowerCase() === String(level.Severity__c).toLowerCase()
                        && String(likelihood.value).toLowerCase() === String(level.Likelihood__c).toLowerCase()) {
                        severity.RiskLevel.push(level);
                    }
                });
            });
        });

        /* For Final Risk Assessment */
        options.FinalLikelihood.forEach(function (likelihood) {
            metadata.LikelihoodCaption.forEach(function (caption) {
                if (String(likelihood.value).toLowerCase() === String(caption.DeveloperName).toLowerCase()) {
                    likelihood.Caption1__c = caption.Caption1__c;
                    likelihood.Caption2__c = caption.Caption2__c;
                    likelihood.Caption3__c = caption.Caption3__c;
                    likelihood.Caption4__c = caption.Caption4__c;
                }
            });
        });
        options.FinalSeverity.forEach(function (severity) {
            severity.ConsequenceDescription = [];
            options.FinalRiskConsequence.forEach(function (consequence) {
                metadata.ConsequenceDescription.forEach(function (desc) {
                    if (String(severity.value).toLowerCase() === String(desc.Severity__c).toLowerCase()
                        && String(consequence.value).toLowerCase() === String(desc.Consequence__c).toLowerCase()) {
                        severity.ConsequenceDescription.push(desc);
                    }
                })
            });

            severity.RiskLevel = [];
            options.FinalLikelihood.forEach(function (likelihood) {
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
        /* For Initial Risk Assessment */
        let initialSeverity = component.get('v.risk.InitialSeverity__c');
        let initialLikelihood = component.get('v.risk.IntlLikelihood__c');

        /* For Final Risk Assessment */
        //let finalSeverity = component.get('v.risk.FinalSeverity__c');
        //let finalLikelihood = component.get('v.risk.FinalLikelihood__c');

        let metadata = component.get('v.metadata');
        metadata.RiskLevel.forEach(function (level) {
            /* For Initial Risk Assessment */
            if (String(initialSeverity).toLowerCase() === String(level.Severity__c).toLowerCase()
                && String(initialLikelihood).toLowerCase() === String(level.Likelihood__c).toLowerCase()) {
                let risk = component.get('v.risk');
                risk.InitialRisk__c = level.RiskLevel__c;
                risk.InitialValueUSD__c = level.EstValueUSD__c;
                component.set('v.risk', risk);
                component.set('v.initialEstimatedValueInUSD', helper.util.shortenCurrency(level.EstValueUSD__c));
                component.set('v.initialEstimatedValueInTHB', helper.util.shortenCurrency(level.EstValueTHB__c));
            }

            /* For Final Risk Assessment */
            //if (String(finalSeverity).toLowerCase() === String(level.Severity__c).toLowerCase()
            //    && String(finalLikelihood).toLowerCase() === String(level.Likelihood__c).toLowerCase()) {
            //    let risk = component.get('v.risk');
            //    risk.FinalRisk__c = level.RiskLevel__c;
            //    risk.FinalValueUSD__c = level.EstValueUSD__c;
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
                /* For Initial Risk Assessment */
                component.set('v.attachments', helper.filterInitialRiskAttacthments(component, event, helper, result));

                /* For Final Risk Assessment */
                //component.set('v.attachments', helper.filterFinalRiskAttacthments(component, event, helper, result));

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

        /* For Initial Risk Assessment */
        return risk.Name + '_Initial_' + nextRunningNo;

        /* For Final Risk Assessment */
        //return risk.Name + '_Final_' + nextRunningNo;
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
        let risk = component.get('v.risk');
        (String(risk.IntConsEffect__c).toLowerCase() != 'other') && (risk.IniOtherConsEff__c = '');

        action.setParams({
            ortl: risk,
            attendees: component.get('v.attendees'),
            deleteAttendees: component.get('v.deleteAttendees'),
        });

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();

                recordLoader.reloadRecord(true);
                // Custom Label
                this.util.showToast('success', 'Success', $A.get("$Label.c.ORTLRskInUpdSc"));
                this.closeModal(component, event, helper);

                $A.get('e.force:refreshView').fire();

                if (typeof (resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
                if ($A.util.isArray(error) && $A.util.isArray(error[0].pageErrors) && error[0].pageErrors[0].message) {
                    this.util.showToast('error', 'Error', error[0].pageErrors[0].message);
                } else if ($A.util.isArray(error) && $A.util.isArray(error[0].fieldErrors) && error[0].fieldErrors[0].message) {
                    this.util.showToast('error', 'Error', error[0].fieldErrors[0].message);
                } else {
                    this.util.showToast('error', 'Error', $A.get("$Label.c.ORTLErrorMsg"));
                }
            }
        });

        $A.enqueueAction(action);
    },
    // Filter only final risk attachments to display.
    filterFinalRiskAttacthments: function (component, event, helper, attachments) {
        let risk = component.get('v.risk');
        let fileName = risk.Name + '_Final_';
        return attachments.filter(function (value) {
            let title = value.ContentDocument.Title;
            return title.startsWith(fileName);
        });
    },
    // Filter only final risk attendees to display.
    filterFinalRiskAttendees: function (component, event, helper, attendees) {
        return attendees.filter(function (value) {
            return value.Type__c == 'Final Risk Assessment';
        });
    },
    // Call remote function to update risk risk assessment.
    updateFinalRiskAssessment: function (component, event, helper, resolve) {
        let action = component.get('c.updateFinalRiskAssessment');
        let recordLoader = component.find('recordLoader');
        let risk = component.get('v.risk');
        risk.RiskStatus__c = 'Closed';

        action.setParams({
            ortl: risk,
            attendees: component.get('v.attendees'),
            deleteAttendees: component.get('v.deleteAttendees'),
        });

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();

                recordLoader.reloadRecord(true);
                // Custom Label
                this.util.showToast('success', 'Success', $A.get("$Label.c.ORTLRskFnUpdSc"));
                this.showConfirmationModal(component, event, helper);

                $A.get('e.force:refreshView').fire();

                if (typeof (resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
                if ($A.util.isArray(error) && $A.util.isArray(error[0].pageErrors) && error[0].pageErrors[0].message) {
                    this.util.showToast('error', 'Error', error[0].pageErrors[0].message);
                } else if ($A.util.isArray(error) && $A.util.isArray(error[0].fieldErrors) && error[0].fieldErrors[0].message) {
                    this.util.showToast('error', 'Error', error[0].fieldErrors[0].message);
                } else {
                    this.util.showToast('error', 'Error', $A.get("$Label.c.ORTLErrorMsg"));
                }
            }
        });

        $A.enqueueAction(action);
    },
    // Call remote function to get attendees related to risk records.
    getAttendees: function (component, event, helper, resolve) {
        let action = component.get('c.getAttendees');

        action.setParams({
            ortl: {
                Id: component.get('v.recordId')
            }
        });
        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                /* For Initial Risk Assessment */
                component.set('v.attendees', helper.filterInitialRiskAttendees(component, event, helper, result));
                component.set('v.remoteAttendees', helper.filterInitialRiskAttendees(component, event, helper, result));

                /* For Final Risk Assessment */
                //component.set('v.attendees', helper.filterFinalRiskAttendees(component, event, helper, result));
                //component.set('v.remoteAttendees', helper.filterFinalRiskAttendees(component, event, helper, result));

                if (typeof (resolve) === 'function') {
                    /* For Initial Risk Assessment */
                    resolve(helper.filterInitialRiskAttendees(component, event, helper, result));

                    /* For Final Risk Assessment */
                    //resolve(helper.filterFinalRiskAttendees(component, event, helper, result));
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
            }
        });

        $A.enqueueAction(action);
    },
    // Call remote function to get ORTL Admin users in Org.
    getOrtlAdmins: function(component, event, helper, resolve) {
        let action = component.get('c.getOrtlAdmins');
        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.ortlAdmins', result);

                if (typeof (resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
            }
        });

        $A.enqueueAction(action);
    },
    /* For Final Risk Assessment */
    // Call remote function to get actions related to risk records.
    getActions: function(component, event, helper, resolve) {
        let action = component.get('c.getActions');

        action.setParams({
            ortl: {
                Id: component.get('v.recordId')
            }
        });
        action.setCallback(this, function(response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.remoteActions', result);

                if (typeof(resolve) === 'function') {
                    resolve(result);
                }
            } else if (state === 'ERROR') {
                let error = response.getError();
            }
        });

        $A.enqueueAction(action);
    },
    /* For Final Risk Assessment */
    // Default attendees from all actions that related to risk record.
    defaultAttendees: function(component, event, helper) {
        /* For Initial Risk Assessment */
        if (component.get('v.risk.Threat__c') == 'Frequent Violation of PTM limits') {
            let attendees = [];
            let ortlAdmins = component.get('v.ortlAdmins');
            if ($A.util.isArray(ortlAdmins)) {
                ortlAdmins.forEach(function(value) {
                    attendees.push({
                        'Type__c': 'Initial Risk Assessment',
                        'AttendeeName__c': value.AssigneeId,
                    });
                });
            }
            component.set('v.attendees', attendees);
        }

        /* For Final Risk Assessment */
        //let remoteActions = component.get('v.remoteActions');
        //let attendees = [];
        //
        //let uniqueAttendees = remoteActions.filter(function(item, index, items) {
        //    return index === items.findIndex(function(value) {
        //        return value.OwnerId === item.OwnerId;
        //    });
        //});
        //uniqueAttendees.forEach(function(value) {
        //    attendees.push({
        //        'Type__c': 'Final Risk Assessment',
        //        'AttendeeName__c': value.OwnerId,
        //    });
        //});
        //
        //component.set('v.attendees', attendees);
    },
    // Utility function to close modal
    closeModal: function (component, event, helper) {
        this.modal.notifyClose();
    },
    // Add blank attendee to list when click add attendee.
    addAttendee: function (component, event, helper) {
        let attendees = component.get('v.attendees');
        attendees.push({
            /* For Initial Risk Assessment */
            'Type__c': 'Initial Risk Assessment',

            /* For Final Risk Assessment */
            //'Type__c': 'Final Risk Assessment',
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
        component.set('v.deleteAttendees', deleteAttendees);
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
    // Verify duplicated attendees in list.
    verifyDuplicatedAttendee: function(component, event, helper) {
        let regex = /attendee-(\d+)/;
        let cmp = event.getSource();
        let className = cmp.get('v.class');
        let matches = regex.exec(className);
        let clickIndex = matches[1];

        let attendees = component.get('v.attendees');
        attendees.forEach(function(value, index) {
            if (clickIndex == index) {
                return;
            }
            if (attendees[clickIndex].AttendeeName__c == value.AttendeeName__c) {
                // Custom Label
                helper.util.showToast('error', 'Error', $A.get("$Label.c.ORTLRskDupAtdEr"));
                attendees[clickIndex].AttendeeName__c = '';
                cmp.reset();
            }
        });

        component.set('v.attendees', attendees);
    },
    // Display confirmation modal when click save final risk assessment.
    showConfirmationModal: function (component, event, helper) {
        let risk = component.get('v.risk');
        $A.createComponents(
            [
                ['c:ORTLFinalRiskCf', {
                    message: helper.getMessageConfirmation(component, event, helper),
                    finalRiskLevel: risk.FinalRisk__c,
                }],
                ['c:ORTLFinalRiskCfFt', {}],
            ],
            function (content, status) {
                if (status === "SUCCESS") {
                    let modalBody = content[0];
                    let modalFooter = content[1];
                    component.find('overlayLib').showCustomModal({
                        header: "Final Risk Assessment",
                        body: modalBody,
                        footer: modalFooter,
                        showCloseButton: false,
                        cssClass: "",
                    });
                    helper.closeModal(component, event, helper);
                }
            }
        );
    },
    // Construct message to display in confirmation modal.
    getMessageConfirmation: function(component, event, helper) {
        let message = '';
        let risk = component.get('v.risk');
        let isSeverityChanged = false;
        let isLikelihoodChanged = false;

        if (risk.InitialSeverity__c != risk.FinalSeverity__c) {
            isSeverityChanged = true;
        }
        if (risk.IntlLikelihood__c != risk.FinalLikelihood__c) {
            isLikelihoodChanged = true;
        }

        if (isSeverityChanged && isLikelihoodChanged) { // Severity and Likelihood changed
            message = $A.get("$Label.c.ORTLBothChg");
        } else if (isSeverityChanged && !isLikelihoodChanged) { // Severity changed but Likelihood not changed
            message = $A.get("$Label.c.ORTLSeverityChg");
        } else if (!isSeverityChanged && isLikelihoodChanged) { // Severity not changed but Likelihood changed
            message = $A.get("$Label.c.ORTLLikelihdChg");
        } else { // Severity and Likelihood not changed
            message = $A.get("$Label.c.ORTLNoChg");
        }

        return message;
    },
    // Default Consequence, Consequence Effect from Initial Consequence, Initial Consequence Effect respectively
    defaultFinalRiskValue: function(component, event, helper) {
        let risk = component.get('v.risk');
        if (!risk.FinRiskCons__c) {
            risk.FinRiskCons__c = risk.IntRiskCons__c
        }
        if (!risk.FinConsEffect__c) {
            risk.FinConsEffect__c = risk.IntConsEffect__c
        }
        if (!risk.FinOtherConsEffect__c) {
            risk.FinOtherConsEffect__c = risk.IniOtherConsEff__c
        }
        component.set('v.risk', risk);
    },
    // Verify if there is no blank attendee.
    verifyBlankAttendees: function(component, event, helper) {
        let attendees = component.get('v.attendees');
        let foundIndex = -1;
        if ($A.util.isArray(attendees)) {
            foundIndex = attendees.findIndex(function(value) {
                return $A.util.isEmpty(value.AttendeeName__c);
            });
        }
        return (foundIndex === -1);
    },
    // At least one attendee must be added.
    hasAttendee: function(component, event, helper) {
        let attendees = component.get('v.attendees');
        return $A.util.isArray(attendees) && attendees.length > 0;
    },
    // Consequence can not be blank
    isBlankConsequence: function(component, event, helper) {
        /* For Initial Risk Assessment */
        let consequence = component.get('v.risk.IntRiskCons__c');
        return $A.util.isEmpty(consequence);

        /* For Final Risk Assessment */
        // return false;
    },
    // Consequence effect can not be blank
    isBlankConsequenceEffect: function(component, event, helper) {
        /* For Initial Risk Assessment */
        let consequenceEfect = component.get('v.risk.IntConsEffect__c');
        return $A.util.isEmpty(consequenceEfect);

        /* For Final Risk Assessment */
        // return false;
    },
    // Other can not be blank if consequence effect is Other
    isBlankConsequenceEffectOther: function(component, event, helper) {
        /* For Initial Risk Assessment */
        let consequenceEffect = component.get('v.risk.IntConsEffect__c');
        let consequenceEffectOther = component.get('v.risk.IniOtherConsEff__c');
        return consequenceEffect == 'Other' && $A.util.isEmpty(consequenceEffectOther);

        /* For Final Risk Assessment */
        // return false;
    },
    /**
    * verify permission for edit risk record.
    */
   canEditRisk : function(component, event, helper) {
       try {
           let action = component.get('c.canEditRisk');
           action.setParams({
               ortl: {
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