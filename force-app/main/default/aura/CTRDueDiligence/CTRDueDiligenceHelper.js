({
	retrieveDueDiligenceReviewSection : function(component) {
		component.set('v.isLoaded', false);
        var action = component.get("c.retrieveDueDiligenceReviewSection");
        action.setParams({
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result)) {
					console.log('[retrieveDueDiligenceReviewSection] result -----', JSON.parse(result));
					var resultJSON = JSON.parse(result);
                    component.set('v.sectionLabelMap', resultJSON.sectionMap);
					component.set('v.isTX', resultJSON.isTX); // 26/03/2024
                } else {
					console.log('[retrieveDueDiligenceReviewSection] result -----', result);
                    this.showToast('Warning', 'warning', 'Label not found');
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[retrieveDueDiligenceReviewSection] error -----', errors[0].message);
                        this.showToast('Error', 'error', errors[0].message);
                    }
                } else {
                    console.log('[retrieveDueDiligenceReviewSection] unknown error -----');
                    this.showToast('Error', 'error', 'Unknown error');
                }
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
	},

    handleEditMode : function(component, isEdit) {
		console.log('[handleEditMode] currentSection -----', component.get('v.currentSection'));
        component.set('v.' + component.get('v.currentSection'), isEdit);
        component.set('v.isEdit', isEdit);
		this.setupSection(component)
    },

	validateActor : function(component) {
		const sectionLabelMap = component.get('v.sectionLabelMap');
		console.log('sectionLabelMap -----', Object.assign({}, sectionLabelMap));
		var actorStep;
		switch(component.get('v.currentSection')) {
			case 'isCMReview':
				actorStep = sectionLabelMap.cmReview.actorStep;
				break;
			case 'isEnhanceDueDiligence':
				actorStep = sectionLabelMap.enhanceDueDiligence.actorStep;
				break;
			case 'isComplianceAdvice':
				actorStep = sectionLabelMap.complianceAdvice.actorStep;
				break;
			case 'isCPXXReview':
				actorStep = sectionLabelMap.cpxxReview.actorStep;
				break;
			case 'isCMVPReview':
				actorStep = sectionLabelMap.cmvpReview.actorStep;
				break;
			case 'isEVPCReview':
				actorStep = sectionLabelMap.evpcReview.actorStep;
				break;
			case 'isEndorseDueDiligence':
				actorStep = sectionLabelMap.endorseDueDiligence.actorStep;
				break;
			case 'isApproveDueDiligence':
				actorStep = sectionLabelMap.approveDueDiligence.actorStep;
				break;
		}
		if(!$A.util.isEmpty(actorStep)) {
			component.set('v.isLoaded', false);
			var action = component.get("c.validateActor");
			action.setParams({
				"recordId": component.get('v.recordId'),
				"actorStep": actorStep,
				"userId": $A.get("$SObjectType.CurrentUser.Id"),
				"process": "DueDiligence"
			});
			action.setCallback(this, function(response) {
				var state = response.getState();
				if(state === "SUCCESS") {
					var result = response.getReturnValue();
					console.log('[validateActor] result -----', result);
					this.handleEditMode(component, result);
					if(!result) {
						this.showToast('Error', 'error', 'You don\'t have permission to submit a review');
					}
				} else if (state === "ERROR") {
					var errors = response.getError();
					if(errors) {
						if(errors[0] && errors[0].message) {
							console.log('[validateActor] error -----', errors[0].message);
							this.showToast('Error', 'error', errors[0].message);
						}
					} else {
						console.log('[validateActor] unknown error -----');
						this.showToast('Error', 'error', 'Unknown error');
					}
				}
				component.set('v.isLoaded', true);
			});
			$A.enqueueAction(action);
		}
	},

	sectionForHighHighRisk : function(component) {
		console.log('[sectionForHighHighRisk] -----');
		if($A.util.isEmpty(component.get("v.recordObject.EVPCReviewEDDBy__c"))) {
			if(component.get("v.recordObject.Status__c") == 'In Review' && component.get("v.recordObject.Approval_Step__c") == 'Due Diligence') {
				component.set('v.displayEVPCReview', true);
				component.set('v.displayEVPCReviewButton', true);
			}
		} else {
			component.set('v.displayEVPCReview', true);
			if(component.get("v.recordObject.EVPCReviewEDDResult__c") != 'Rejected') {
				if(/*component.get("v.recordObject.CPXXReviewDueDiligenceResult__c") == 'Proceed' &&*/ component.get("v.recordObject.CMVPReviewDueDiligenceResult__c") == 'Proceed') {
					if($A.util.isEmpty(component.get("v.recordObject.EndorseDueDiligenceBy__c"))) {
						component.set('v.displayEndorseDueDiligence', true);
						component.set('v.displayEndorseDueDiligenceButton', true);
					} else {
						component.set('v.displayEndorseDueDiligence', true);
						if($A.util.isEmpty(component.get("v.recordObject.ApproveDueDiligenceBy__c"))) {
							component.set('v.displayApproveDueDiligence', true);
							component.set('v.displayApproveDueDiligenceButton', true);
						} else {
							component.set('v.displayApproveDueDiligence', true);
						}
					}
				}
			}
		}
	},

	sectionForLowRisk : function(component) {
		console.log('[sectionForLowRisk] -----');
		if($A.util.isEmpty(component.get("v.recordObject.TraderEnhanceDueDiligenceBy__c"))) {
			if(component.get("v.recordObject.Status__c") == 'In Review' && component.get("v.recordObject.Approval_Step__c") == 'Due Diligence') {
				component.set('v.displayCMReview', true);
				component.set('v.displayCMReviewButton', true);
			}
        } else {
            component.set('v.displayCMReview', true);
            if(component.get("v.recordObject.EnhanceDueDiligenceProceedByTrader__c") != 'Not Proceed') {
                if($A.util.isEmpty(component.get("v.recordObject.EnhanceDueDiligenceBy__c"))) {
                    component.set('v.displayEnhanceDueDiligence', true);
                    component.set('v.displayEnhanceDueDiligenceButton', true);
                } else {
                    component.set('v.displayEnhanceDueDiligence', true);
                    if($A.util.isEmpty(component.get("v.recordObject.ComplianceAdviceBy__c"))) {
                        component.set('v.displayComplianceAdvice', true);
                        component.set('v.displayComplianceAdviceButton', true);
                    } else {
                        component.set('v.displayComplianceAdvice', true);
                        if(component.get("v.recordObject.ComplianceAdviceResult__c") != 'Yes') {
                            if($A.util.isEmpty(component.get("v.recordObject.CPXXReviewDueDiligenceBy__c"))) {
                                component.set('v.displayCPXXReview', true);
                                component.set('v.displayCPXXReviewButton', true);
                            } else {
                                component.set('v.displayCPXXReview', true);
                                if($A.util.isEmpty(component.get("v.recordObject.CMVPReviewDueDiligenceBy__c"))) {
                                    component.set('v.displayCMVPReview', true);
                                    component.set('v.displayCMVPReviewButton', true);
                                } else {
                                    component.set('v.displayCMVPReview', true);
                                    if($A.util.isEmpty(component.get("v.recordObject.EVPCReviewEDDBy__c"))) {
                                        component.set('v.displayEVPCReview', true);
                                        component.set('v.displayEVPCReviewButton', true);
                                    } else {
                                        component.set('v.displayEVPCReview', true);
                                        if(component.get("v.recordObject.EVPCReviewEDDResult__c") != 'Rejected') {
                                            if(/*component.get("v.recordObject.CPXXReviewDueDiligenceResult__c") == 'Proceed' &&*/ component.get("v.recordObject.CMVPReviewDueDiligenceResult__c") == 'Proceed') {
                                                if($A.util.isEmpty(component.get("v.recordObject.EndorseDueDiligenceBy__c"))) {
                                                    component.set('v.displayEndorseDueDiligence', true);
                                                    component.set('v.displayEndorseDueDiligenceButton', true);
                                                } else {
                                                    component.set('v.displayEndorseDueDiligence', true);
                                                    if($A.util.isEmpty(component.get("v.recordObject.ApproveDueDiligenceBy__c"))) {
                                                        component.set('v.displayApproveDueDiligence', true);
                                                        component.set('v.displayApproveDueDiligenceButton', true);
                                                    } else {
                                                        component.set('v.displayApproveDueDiligence', true);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            component.set("v.isRejected", true);
                        }
                    }
                }
            }
        }
	},

	setupSection : function(component) {
		component.set('v.displayCMReviewSection', (component.get('v.displayCMReview') && component.get('v.isCMReview')) || 
			(component.get('v.displayCMReview') && !component.get('v.isCMReview') && !$A.util.isEmpty(component.get("v.recordObject.TraderEnhanceDueDiligenceBy__c"))));
		component.set('v.displayEnhanceDueDiligenceSection', (component.get('v.displayEnhanceDueDiligence') && component.get('v.isEnhanceDueDiligence')) || 
			(component.get('v.displayEnhanceDueDiligence') && !component.get('v.isEnhanceDueDiligence') && !$A.util.isEmpty(component.get("v.recordObject.EnhanceDueDiligenceBy__c"))));
		component.set('v.displayComplianceAdviceSection', (component.get('v.displayComplianceAdvice') && component.get('v.isComplianceAdvice')) || 
			(component.get('v.displayComplianceAdvice') && !component.get('v.isComplianceAdvice') && !$A.util.isEmpty(component.get("v.recordObject.ComplianceAdviceBy__c"))));
		component.set('v.displayCPXXReviewSection', (component.get('v.displayCPXXReview') && component.get('v.isCPXXReview')) || 
			(component.get('v.displayCPXXReview') && !component.get('v.isCPXXReview') && !$A.util.isEmpty(component.get("v.recordObject.CPXXReviewDueDiligenceBy__c"))));
		component.set('v.displayCMVPReviewSection', (component.get('v.displayCMVPReview') && component.get('v.isCMVPReview')) || 
			(component.get('v.displayCMVPReview') && !component.get('v.isCMVPReview') && !$A.util.isEmpty(component.get("v.recordObject.CMVPReviewDueDiligenceBy__c"))));
		component.set('v.displayEVPCReviewSection', (component.get('v.displayEVPCReview') && component.get('v.isEVPCReview')) || 
			(component.get('v.displayEVPCReview') && !component.get('v.isEVPCReview') && !$A.util.isEmpty(component.get("v.recordObject.EVPCReviewEDDBy__c"))));
		component.set('v.displayEndorseDueDiligenceSection', (component.get('v.displayEndorseDueDiligence') && component.get('v.isEndorseDueDiligence')) || 
			(component.get('v.displayEndorseDueDiligence') && !component.get('v.isEndorseDueDiligence') && !$A.util.isEmpty(component.get("v.recordObject.EndorseDueDiligenceBy__c"))));
		component.set('v.displayApproveDueDiligenceSection', (component.get('v.displayApproveDueDiligence') && component.get('v.isApproveDueDiligence')) || 
			(component.get('v.displayApproveDueDiligence') && !component.get('v.isApproveDueDiligence') && !$A.util.isEmpty(component.get("v.recordObject.ApproveDueDiligenceBy__c"))));
	},

	hideAllButtons : function(component) {
		component.set('v.displayCMReviewButton', false);
		component.set('v.displayEnhanceDueDiligenceButton', false);
		component.set('v.displayComplianceAdviceButton', false);
		component.set('v.displayCPXXReviewButton', false);
		component.set('v.displayCMVPReviewButton', false);
		component.set('v.displayEVPCReviewButton', false);
		component.set('v.displayEndorseDueDiligenceButton', false);
		component.set('v.displayApproveDueDiligenceButton', false);
	},

    showToast : function(title, type, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"type": type,
			"message": message
		});
		toastEvent.fire();
	},
})