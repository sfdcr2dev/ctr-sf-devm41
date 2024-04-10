({
    doInit: function (component, event, helper) {
        component.set('v.isLoaded', true);
        helper.retrieveDueDiligenceReviewSection(component);
    },

    handleToggleSection: function (component, event, helper) {
        var sectionAuraId = event.currentTarget.getAttribute('data-auraid');
        console.log('[handleToggleSection] selectionAuraId -----', sectionAuraId);

        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        // console.log('[handleToggleSection] sectionDiv -----', sectionDiv);
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        // console.log('[handleToggleSection] sectionState -----', sectionState);
        // -1 open/close section
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section'); // slds-is-close 
        }
    },

    handleEdit : function(component, event, helper) {
        console.log('[handleEdit] name -----', event.getSource().get("v.name"));
        var name = event.getSource().get("v.name");
        component.set('v.currentSection', name);
        // helper.handleEditMode(component, true);
        helper.validateActor(component);
    },

    handleCancel : function(component, event, helper) {
        component.find('inputField').forEach(function(f) {
            if(!f.get('v.disabled')) {
                f.reset();
            }
        });

        // var inputRadio = component.find("inputRadio");
		// for(var i=0; i<inputRadio.length; i++) {
		// 	if(inputRadio[i] !== undefined) {
        //         if(inputRadio[i].get('v.disabled') !== undefined && inputRadio[i].get('v.disabled') == false) {
        //             console.log(inputRadio[i].get('v.name') + ' -----', inputRadio[i].get('v.disabled'));
        //             component.set('v.' + inputRadio[i].get('v.name'), '');
        //         }
        //     }
        // }
        helper.handleEditMode(component, false);
        // $A.get('e.force:refreshView').fire();
    },

    handleLoad : function(component, event, helper) {

    },

    handleSubmit : function(component, event, helper) {
        component.set("v.isLoaded", false);
        event.preventDefault();
        var fields = event.getParam('fields');
        var fieldsToUpdate = {};
        console.log('[handleSubmit] fields -----', Object.assign({}, fields));
        var reviewResult = '';
        var actionByApiName = '';
        var actionDateTimeApiName = '';
        var isRejected = false;
        var allValid = true;
        console.log('[handleSubmit] isSupplier -----', component.get('v.isSupplier'));
        if(component.get('v.isCMReview')) {
            reviewResult = fields['EnhanceDueDiligenceProceedByTrader__c'];
            fieldsToUpdate['EnhanceDueDiligenceProceedByTrader__c'] = reviewResult;
            fieldsToUpdate['EnhanceDueDiligenceCommentByTrader__c'] = fields['EnhanceDueDiligenceCommentByTrader__c'];
            actionByApiName = 'TraderEnhanceDueDiligenceBy__c';
            actionDateTimeApiName = 'TraderEnhanceDueDiligenceDateTime__c';
            if(!$A.util.isEmpty(reviewResult) && reviewResult == 'Not Proceed') {
                isRejected = true;
            }
            if($A.util.isEmpty(reviewResult) || $A.util.isEmpty(fields['EnhanceDueDiligenceCommentByTrader__c'])) allValid = false;
        } else if(component.get('v.isEnhanceDueDiligence')) {
            reviewResult = fields['EnhanceDueDiligenceResult__c'];
            fieldsToUpdate['EnhanceDueDiligenceResult__c'] = reviewResult;
            fieldsToUpdate['EnhanceDueDiligenceCommentByEDD__c'] = fields['EnhanceDueDiligenceCommentByEDD__c'];
            actionByApiName = 'EnhanceDueDiligenceBy__c';
            actionDateTimeApiName = 'EnhanceDueDiligenceDateTime__c';
            if(!$A.util.isEmpty(reviewResult) && reviewResult == 'No') {
                isRejected = true;
            }
            if($A.util.isEmpty(reviewResult) || $A.util.isEmpty(fields['EnhanceDueDiligenceCommentByEDD__c'])) allValid = false;
        } else if(component.get('v.isComplianceAdvice')) {
            reviewResult = fields['ComplianceAdviceResult__c'];
            fieldsToUpdate['ComplianceAdviceResult__c'] = reviewResult;
            fieldsToUpdate['ComplianceAdviceComment__c'] = fields['ComplianceAdviceComment__c'];
            actionByApiName = 'ComplianceAdviceBy__c';
            actionDateTimeApiName = 'ComplianceAdviceDateTime__c';
            if(!$A.util.isEmpty(reviewResult) && reviewResult == 'Yes') {
                if(component.get('v.isSupplier')) { // 26/03/2024
                    if(component.get('v.isTX')) {
                        fieldsToUpdate['Approval_Step__c'] = 'Select Committee';
                    } else {
                        fieldsToUpdate['Status__c'] = 'Approved';
                        fieldsToUpdate['Approval_Step__c'] = 'Inform Counterparty';
                    }
                } else {
                    fieldsToUpdate['Approval_Step__c'] = 'Credit Rating';
                }
            }
            if($A.util.isEmpty(reviewResult) || $A.util.isEmpty(fields['ComplianceAdviceComment__c'])) allValid = false;
        } else if(component.get('v.isCPXXReview')) {
            // reviewResult = component.get('v.cpxxReviewResult');
            // fieldsToUpdate['CPXXReviewDueDiligenceResult__c'] = reviewResult;
            fieldsToUpdate['CPXXReviewDueDiligenceComment__c'] = fields['CPXXReviewDueDiligenceComment__c'];
            actionByApiName = 'CPXXReviewDueDiligenceBy__c';
            actionDateTimeApiName = 'CPXXReviewDueDiligenceDateTime__c';
            if(/*$A.util.isEmpty(reviewResult) ||*/ $A.util.isEmpty(fields['CPXXReviewDueDiligenceComment__c'])) allValid = false;
        } else if(component.get('v.isCMVPReview')) {
            reviewResult = fields['CMVPReviewDueDiligenceResult__c'];
            fieldsToUpdate['CMVPReviewDueDiligenceResult__c'] = reviewResult;
            fieldsToUpdate['CMVPReviewDueDiligenceComment__c'] = fields['CMVPReviewDueDiligenceComment__c'];
            actionByApiName = 'CMVPReviewDueDiligenceBy__c';
            actionDateTimeApiName = 'CMVPReviewDueDiligenceDateTime__c';
            // if((!$A.util.isEmpty(component.get("v.recordObject.CPXXReviewDueDiligenceResult__c")) && component.get("v.recordObject.CPXXReviewDueDiligenceResult__c") != 'Proceed') || 
            if(!$A.util.isEmpty(reviewResult) && reviewResult != 'Proceed') {
                isRejected = true;
            }
            if(/*$A.util.isEmpty(reviewResult) ||*/ $A.util.isEmpty(fields['CMVPReviewDueDiligenceComment__c'])) allValid = false;
        } else if(component.get('v.isEVPCReview')) {
            reviewResult = fields['EVPCReviewEDDResult__c'];
            fieldsToUpdate['EVPCReviewEDDResult__c'] = reviewResult;
            fieldsToUpdate['EVPCReviewEDDComment__c'] = fields['EVPCReviewEDDComment__c'];
            actionByApiName = 'EVPCReviewEDDBy__c';
            actionDateTimeApiName = 'EVPCReviewEDDDateTime__c';
            if(!$A.util.isEmpty(reviewResult) && reviewResult == 'Rejected') {
                isRejected = true;
            }
            if($A.util.isEmpty(reviewResult) || $A.util.isEmpty(fields['EVPCReviewEDDComment__c'])) allValid = false;
        } else if(component.get('v.isEndorseDueDiligence')) {
            reviewResult = fields['EndorseDueDiligenceResult__c'];
            fieldsToUpdate['EndorseDueDiligenceResult__c'] = reviewResult;
            fieldsToUpdate['EndorseDueDiligenceComment__c'] = fields['EndorseDueDiligenceComment__c'];
            actionByApiName = 'EndorseDueDiligenceBy__c';
            actionDateTimeApiName = 'EndorseDueDiligenceDateTime__c';
            if(!$A.util.isEmpty(reviewResult) && reviewResult == 'Rejected') {
                isRejected = true;
            }
            if($A.util.isEmpty(reviewResult) || $A.util.isEmpty(fields['EndorseDueDiligenceComment__c'])) allValid = false;
        } else if(component.get('v.isApproveDueDiligence')) {
            reviewResult = fields['ApproveDueDiligenceResult__c'];
            fieldsToUpdate['ApproveDueDiligenceResult__c'] = reviewResult;
            fieldsToUpdate['ApproveDueDiligenceComment__c'] = fields['ApproveDueDiligenceComment__c'];
            actionByApiName = 'ApproveDueDiligenceBy__c';
            actionDateTimeApiName = 'ApproveDueDiligenceDateTime__c';
            if(!$A.util.isEmpty(reviewResult) && reviewResult == 'Rejected') {
                isRejected = true;
            } else {
                if(component.get('v.isSupplier')) { // 26/03/2024
                    if(component.get('v.isTX')) {
                        fieldsToUpdate['Approval_Step__c'] = 'Select Committee';
                    } else {
                        fieldsToUpdate['Status__c'] = 'Approved';
                        fieldsToUpdate['Approval_Step__c'] = 'Inform Counterparty';
                    }
                } else {
                    fieldsToUpdate['Approval_Step__c'] = 'Credit Rating';
                }
            }
            if($A.util.isEmpty(reviewResult) || $A.util.isEmpty(fields['ApproveDueDiligenceComment__c'])) allValid = false;
        }

        if(isRejected) {
            fieldsToUpdate['Status__c'] = 'Rejected';
            fieldsToUpdate['Approval_Step__c'] = 'Inform Counterparty';
        }
        fieldsToUpdate[actionByApiName] = $A.get("$SObjectType.CurrentUser.Id");
        fieldsToUpdate[actionDateTimeApiName] = new Date().toISOString();
        console.log('[handleSubmit] fieldsToUpdate -----', Object.assign({}, fieldsToUpdate));
        if(allValid) {
            component.find('recordEditForm').submit(fieldsToUpdate);
        } else {
            component.set("v.isLoaded", true);
            helper.showToast('Warning', 'warning', 'Please complete all required fields.');
        }
    },

    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        console.log('[handleSuccess] record -----', Object.assign({}, record));
        var section = 'Due Diligence Review Result';
        if(component.get('v.isCMReview')) {
            section = component.get('v.sectionLabelMap.cmReview.section');
        } else if(component.get('v.isEnhanceDueDiligence')) {
            section = component.get('v.sectionLabelMap.enhanceDueDiligence.section');
        } else if(component.get('v.isComplianceAdvice')) {
            section = component.get('v.sectionLabelMap.complianceAdvice.section');
        } else if(component.get('v.isCPXXReview')) {
            section = component.get('v.sectionLabelMap.cpxxReview.section');
        } else if(component.get('v.isCMVPReview')) {
            section = component.get('v.sectionLabelMap.cmvpReview.section');
        } else if(component.get('v.isEVPCReview')) {
            section = component.get('v.sectionLabelMap.evpcReview.section');
        } else if(component.get('v.isEndorseDueDiligence')) {
            section = component.get('v.sectionLabelMap.endorseDueDiligence.section');
        } else if(component.get('v.isApproveDueDiligence')) {
            section = component.get('v.sectionLabelMap.approveDueDiligence.section');
        }
        helper.showToast('Success', 'success', section + ' has been submitted successfully.');
        component.find('recordLoader').reloadRecord(true);
        helper.handleEditMode(component, false);
        component.set("v.isLoaded", true);
    },

    handleError : function(component, event, helper) {
        helper.showToast('Error', 'error', event.getParam("message"));
        component.set("v.isLoaded", true);
    },

    handleRecordUpdated : function(component, event, helper) {
        component.set("v.isLoaded", false);
        console.log('[handleRecordUpdated] recordObject -----', Object.assign({}, component.get("v.recordObject")));
        helper.hideAllButtons(component);
        // if(!$A.util.isEmpty(component.get("v.recordObject.EnhanceDueDiligenceProceedByTrader__c"))) {
        //     component.set("v.cmReviewResult", component.get("v.recordObject.EnhanceDueDiligenceProceedByTrader__c"));
        // }
        // if(!$A.util.isEmpty(component.get("v.recordObject.ComplianceAdviceResult__c"))) {
        //     component.set("v.complianceAdviceResult", component.get("v.recordObject.ComplianceAdviceResult__c"));
        // }
        // if(!$A.util.isEmpty(component.get("v.recordObject.CPXXReviewDueDiligenceResult__c"))) {
        //     component.set("v.cpxxReviewResult", component.get("v.recordObject.CPXXReviewDueDiligenceResult__c"));
        // }
        // if(!$A.util.isEmpty(component.get("v.recordObject.CMVPReviewDueDiligenceResult__c"))) {
        //     component.set("v.cmvpReviewResult", component.get("v.recordObject.CMVPReviewDueDiligenceResult__c"));
        // }
        // if(!$A.util.isEmpty(component.get("v.recordObject.EVPCReviewEDDResult__c"))) {
        //     component.set("v.evpcReviewResult", component.get("v.recordObject.EVPCReviewEDDResult__c"));
        // }
        // if(!$A.util.isEmpty(component.get("v.recordObject.EndorseDueDiligenceResult__c"))) {
        //     component.set("v.endorseDueDiligenceResult", component.get("v.recordObject.EndorseDueDiligenceResult__c"));
        // }
        // if(!$A.util.isEmpty(component.get("v.recordObject.ApproveDueDiligenceResult__c"))) {
        //     component.set("v.approveDueDiligenceResult", component.get("v.recordObject.ApproveDueDiligenceResult__c"));
        // }
        if(!$A.util.isEmpty(component.get("v.recordObject.Status__c"))) {
            component.set("v.isRejected", component.get("v.recordObject.Status__c") == 'Rejected');
        }
        if(!$A.util.isEmpty(component.get("v.recordObject.FinalRiskLevel__c"))) {
            component.set("v.isHighHighRisk", component.get("v.recordObject.FinalRiskLevel__c") == 'Very High Risk');
        }
        if(!$A.util.isEmpty(component.get("v.recordObject.RecordType.DeveloperName"))) {
            console.log('[handleRecordUpdated] RecordType.DeveloperName -----', component.get("v.recordObject.RecordType.DeveloperName"));
            if(component.get("v.recordObject.RecordType.DeveloperName").includes('Supplier')) {
                component.set("v.isSupplier", true);
            }
        }

        console.log('[handleRecordUpdated] isHighHighRisk -----', component.get('v.isHighHighRisk'));
        if(component.get('v.isHighHighRisk')) {
            helper.sectionForHighHighRisk(component);
        } else {
            helper.sectionForLowRisk(component);
        }

        console.log('[handleRecordUpdated] sectionToDisplay -----', 'displayCMReview:' + component.get('v.displayCMReview') + 
                                                                    '/displayEnhanceDueDiligence:' + component.get('v.displayEnhanceDueDiligence') + 
                                                                    '/displayComplianceAdvice:' + component.get('v.displayComplianceAdvice') + 
                                                                    '/displayCPXXReview:' + component.get('v.displayCPXXReview') + 
                                                                    'displayCMVPReview:' + component.get('v.displayCMVPReview') + 
                                                                    '/displayEVPCReview:' + component.get('v.displayEVPCReview') + 
                                                                    '/displayEndorseDueDiligence:' + component.get('v.displayEndorseDueDiligence') + 
                                                                    '/displayApproveDueDiligence:' + component.get('v.displayApproveDueDiligence'));
        helper.setupSection(component);
        component.set("v.isLoaded", true);
    },
})