<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CTRDueDiligenceResultReview</label>
    <protected>false</protected>
    <values>
        <field>Description__c</field>
        <value xsi:type="xsd:string">Due Diligence Review Section</value>
    </values>
    <values>
        <field>LongValue__c</field>
        <value xsi:type="xsd:string">{
    &quot;TOPDomestic&quot;: {
        &quot;cmReview&quot;: {
            &quot;button&quot;: &quot;Trader Review&quot;,
            &quot;section&quot;: &quot;Trader Review&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EnhanceDueDiligenceProceedByTrader__c&quot;: &quot;Review Due Diligence Result&quot;,
                &quot;EnhanceDueDiligenceCommentByTrader__c&quot;: &quot;Trader Comment&quot;,
                &quot;TraderEnhanceDueDiligenceBy__c&quot;: &quot;Trader Review By&quot;,
                &quot;TraderEnhanceDueDiligenceDateTime__c&quot;: &quot;Trader Review Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;Trader&quot;
        },
        &quot;enhanceDueDiligence&quot;: {
            &quot;button&quot;: &quot;Enhance Due Diligence&quot;,
            &quot;section&quot;: &quot;Enhanced Due Diligence Result by EDD Working Team&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EnhanceDueDiligenceResult__c&quot;: &quot;Do you want to continue?&quot;,
                &quot;EnhanceDueDiligenceCommentByEDD__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;EnhanceDueDiligenceBy__c&quot;: &quot;Enhanced Due Diligence By&quot;,
                &quot;EnhanceDueDiligenceDateTime__c&quot;: &quot;Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;EDDTeam&quot;
        },
        &quot;complianceAdvice&quot;: {
            &quot;button&quot;: &quot;Compliance Advice&quot;,
            &quot;section&quot;: &quot;Compliance Advice by GLGC&quot;,
            &quot;reviewInfo&quot;: {
                &quot;ComplianceAdviceResult__c&quot;: &quot;May this company proceed with the counterparty registration process?&quot;,
                &quot;ComplianceAdviceComment__c&quot;: &quot;Compliance Advice&quot;,
                &quot;ComplianceAdviceBy__c&quot;: &quot;Compliance Advice By&quot;,
                &quot;ComplianceAdviceDateTime__c&quot;: &quot;Compliance Advice Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;GLGC&quot;
        },
        &quot;cpxxReview&quot;: {
            &quot;button&quot;: &quot;Review Due Diligence Result&quot;,
            &quot;section&quot;: &quot;Enhanced Due Diligence Result by CPCE&quot;,
            &quot;reviewInfo&quot;: {
                &quot;CPXXReviewDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;CPXXReviewDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;CPXXReviewDueDiligenceBy__c&quot;: &quot;Enhanced Due Diligence By&quot;,
                &quot;CPXXReviewDueDiligenceDateTime__c&quot;: &quot;Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;CPCE&quot;
        },
        &quot;cmvpReview&quot;: {
            &quot;button&quot;: &quot;Review Due Diligence Result&quot;,
            &quot;section&quot;: &quot;Review Enhanced Due Diligence by CMVP&quot;,
            &quot;reviewInfo&quot;: {
                &quot;CMVPReviewDueDiligenceResult__c&quot;: &quot;Review Enhanced Due Diligence Result&quot;,
                &quot;CMVPReviewDueDiligenceComment__c&quot;: &quot;Review Enhanced Due Diligence Comment&quot;,
                &quot;CMVPReviewDueDiligenceBy__c&quot;: &quot;Review Enhanced Due Diligence By&quot;,
                &quot;CMVPReviewDueDiligenceDateTime__c&quot;: &quot;Review Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;VP&quot;
        },
        &quot;evpcReview&quot;: {
            &quot;button&quot;: &quot;Endorse Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Endorse Enhanced Due Diligence by EVPC&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EVPCReviewEDDResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;EVPCReviewEDDComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;EVPCReviewEDDBy__c&quot;: &quot;Endorsed Enhanced Due Diligence By&quot;,
                &quot;EVPCReviewEDDDateTime__c&quot;: &quot;Endorsed Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;EVPC&quot;
        },
        &quot;endorseDueDiligence&quot;: {
            &quot;button&quot;: &quot;Endorse Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Record Enhanced Due Diligence Result from AMM by Trader&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EndorseDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;EndorseDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment from AMM by Trader&quot;,
                &quot;EndorseDueDiligenceBy__c&quot;: &quot;Record Enhanced Due Diligence Result By Trader&quot;,
                &quot;EndorseDueDiligenceDateTime__c&quot;: &quot;Record Enhanced Due Diligence Result Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;AMM&quot;
        },
        &quot;approveDueDiligence&quot;: {
            &quot;button&quot;: &quot;Approve Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Approve Enhanced Due Diligence by CEO&quot;,
            &quot;reviewInfo&quot;: {
                &quot;ApproveDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;ApproveDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;ApproveDueDiligenceBy__c&quot;: &quot;Approved Enhanced Due Diligence By&quot;,
                &quot;ApproveDueDiligenceDateTime__c&quot;: &quot;Approved Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;CEO&quot;
        }
    },
    &quot;TOPInternational&quot;: {
        &quot;cmReview&quot;: {
            &quot;button&quot;: &quot;Trader Review&quot;,
            &quot;section&quot;: &quot;Trader Review&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EnhanceDueDiligenceProceedByTrader__c&quot;: &quot;Review Due Diligence Result&quot;,
                &quot;EnhanceDueDiligenceCommentByTrader__c&quot;: &quot;Trader Comment&quot;,
                &quot;TraderEnhanceDueDiligenceBy__c&quot;: &quot;Trader Review By&quot;,
                &quot;TraderEnhanceDueDiligenceDateTime__c&quot;: &quot;Trader Review Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;Trader&quot;
        },
        &quot;enhanceDueDiligence&quot;: {
            &quot;button&quot;: &quot;Enhance Due Diligence&quot;,
            &quot;section&quot;: &quot;Enhanced Due Diligence Result by EDD Working Team&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EnhanceDueDiligenceResult__c&quot;: &quot;Do you want to continue?&quot;,
                &quot;EnhanceDueDiligenceCommentByEDD__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;EnhanceDueDiligenceBy__c&quot;: &quot;Enhanced Due Diligence By&quot;,
                &quot;EnhanceDueDiligenceDateTime__c&quot;: &quot;Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;EDDTeam&quot;
        },
        &quot;complianceAdvice&quot;: {
            &quot;button&quot;: &quot;Compliance Advice&quot;,
            &quot;section&quot;: &quot;Compliance Advice by GLGC&quot;,
            &quot;reviewInfo&quot;: {
                &quot;ComplianceAdviceResult__c&quot;: &quot;May this company proceed with the counterparty registration process?&quot;,
                &quot;ComplianceAdviceComment__c&quot;: &quot;Compliance Advice&quot;,
                &quot;ComplianceAdviceBy__c&quot;: &quot;Compliance Advice By&quot;,
                &quot;ComplianceAdviceDateTime__c&quot;: &quot;Compliance Advice Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;GLGC&quot;
        },
        &quot;cpxxReview&quot;: {
            &quot;button&quot;: &quot;Review Due Diligence Result&quot;,
            &quot;section&quot;: &quot;Enhanced Due Diligence Result by CPCE&quot;,
            &quot;reviewInfo&quot;: {
                &quot;CPXXReviewDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;CPXXReviewDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;CPXXReviewDueDiligenceBy__c&quot;: &quot;Enhanced Due Diligence By&quot;,
                &quot;CPXXReviewDueDiligenceDateTime__c&quot;: &quot;Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;CPCE&quot;
        },
        &quot;cmvpReview&quot;: {
            &quot;button&quot;: &quot;Review Due Diligence Result&quot;,
            &quot;section&quot;: &quot;Review Enhanced Due Diligence by SA09&quot;,
            &quot;reviewInfo&quot;: {
                &quot;CMVPReviewDueDiligenceResult__c&quot;: &quot;Review Enhanced Due Diligence Result&quot;,
                &quot;CMVPReviewDueDiligenceComment__c&quot;: &quot;Review Enhanced Due Diligence Comment&quot;,
                &quot;CMVPReviewDueDiligenceBy__c&quot;: &quot;Review Enhanced Due Diligence By&quot;,
                &quot;CMVPReviewDueDiligenceDateTime__c&quot;: &quot;Review Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;VP&quot;
        },
        &quot;evpcReview&quot;: {
            &quot;button&quot;: &quot;Endorse Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Endorse Enhanced Due Diligence by EVPC&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EVPCReviewEDDResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;EVPCReviewEDDComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;EVPCReviewEDDBy__c&quot;: &quot;Endorsed Enhanced Due Diligence By&quot;,
                &quot;EVPCReviewEDDDateTime__c&quot;: &quot;Endorsed Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;EVPC&quot;
        },
        &quot;endorseDueDiligence&quot;: {
            &quot;button&quot;: &quot;Endorse Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Record Enhanced Due Diligence Result from AMM by Trader&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EndorseDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;EndorseDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment from AMM by Trader&quot;,
                &quot;EndorseDueDiligenceBy__c&quot;: &quot;Record Enhanced Due Diligence Result By Trader&quot;,
                &quot;EndorseDueDiligenceDateTime__c&quot;: &quot;Record Enhanced Due Diligence Result Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;AMM&quot;
        },
        &quot;approveDueDiligence&quot;: {
            &quot;button&quot;: &quot;Approve Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Approve Enhanced Due Diligence by CEO&quot;,
            &quot;reviewInfo&quot;: {
                &quot;ApproveDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;ApproveDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;ApproveDueDiligenceBy__c&quot;: &quot;Approved Enhanced Due Diligence By&quot;,
                &quot;ApproveDueDiligenceDateTime__c&quot;: &quot;Approved Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;CEO&quot;
        }
    },
    &quot;TX&quot;: {
        &quot;cmReview&quot;: {
            &quot;button&quot;: &quot;Trader Review&quot;,
            &quot;section&quot;: &quot;Trader Review&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EnhanceDueDiligenceProceedByTrader__c&quot;: &quot;Review Due Diligence Result&quot;,
                &quot;EnhanceDueDiligenceCommentByTrader__c&quot;: &quot;Trader Comment&quot;,
                &quot;TraderEnhanceDueDiligenceBy__c&quot;: &quot;Trader Review By&quot;,
                &quot;TraderEnhanceDueDiligenceDateTime__c&quot;: &quot;Trader Review Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;Trader&quot;
        },
        &quot;enhanceDueDiligence&quot;: {
            &quot;button&quot;: &quot;Enhance Due Diligence&quot;,
            &quot;section&quot;: &quot;Enhanced Due Diligence Result by EDD Working Team&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EnhanceDueDiligenceResult__c&quot;: &quot;Do you want to continue?&quot;,
                &quot;EnhanceDueDiligenceCommentByEDD__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;EnhanceDueDiligenceBy__c&quot;: &quot;Enhanced Due Diligence By&quot;,
                &quot;EnhanceDueDiligenceDateTime__c&quot;: &quot;Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;EDDTeam&quot;
        },
        &quot;complianceAdvice&quot;: {
            &quot;button&quot;: &quot;Compliance Advice&quot;,
            &quot;section&quot;: &quot;Compliance Advice by GLGC&quot;,
            &quot;reviewInfo&quot;: {
                &quot;ComplianceAdviceResult__c&quot;: &quot;May this company proceed with the counterparty registration process?&quot;,
                &quot;ComplianceAdviceComment__c&quot;: &quot;Compliance Advice&quot;,
                &quot;ComplianceAdviceBy__c&quot;: &quot;Compliance Advice By&quot;,
                &quot;ComplianceAdviceDateTime__c&quot;: &quot;Compliance Advice Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;GLGC&quot;
        },
        &quot;cpxxReview&quot;: {
            &quot;button&quot;: &quot;Review Due Diligence Result&quot;,
            &quot;section&quot;: &quot;Enhanced Due Diligence Result by CPCE&quot;,
            &quot;reviewInfo&quot;: {
                &quot;CPXXReviewDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;CPXXReviewDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;CPXXReviewDueDiligenceBy__c&quot;: &quot;Enhanced Due Diligence By&quot;,
                &quot;CPXXReviewDueDiligenceDateTime__c&quot;: &quot;Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;CPCE&quot;
        },
        &quot;cmvpReview&quot;: {
            &quot;button&quot;: &quot;Review Due Diligence Result&quot;,
            &quot;section&quot;: &quot;Review Enhanced Due Diligence by TXMD&quot;,
            &quot;reviewInfo&quot;: {
                &quot;CMVPReviewDueDiligenceResult__c&quot;: &quot;Review Enhanced Due Diligence Result&quot;,
                &quot;CMVPReviewDueDiligenceComment__c&quot;: &quot;Review Enhanced Due Diligence Comment&quot;,
                &quot;CMVPReviewDueDiligenceBy__c&quot;: &quot;Review Enhanced Due Diligence By&quot;,
                &quot;CMVPReviewDueDiligenceDateTime__c&quot;: &quot;Review Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;VP&quot;
        },
        &quot;evpcReview&quot;: {
            &quot;button&quot;: &quot;Endorse Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Endorse Enhanced Due Diligence by EVPC&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EVPCReviewEDDResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;EVPCReviewEDDComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;EVPCReviewEDDBy__c&quot;: &quot;Endorsed Enhanced Due Diligence By&quot;,
                &quot;EVPCReviewEDDDateTime__c&quot;: &quot;Endorsed Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;EVPC&quot;
        },
        &quot;endorseDueDiligence&quot;: {
            &quot;button&quot;: &quot;Endorse Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Record Enhanced Due Diligence Result from AMM by Trader&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EndorseDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;EndorseDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment from AMM by Trader&quot;,
                &quot;EndorseDueDiligenceBy__c&quot;: &quot;Record Enhanced Due Diligence Result By Trader&quot;,
                &quot;EndorseDueDiligenceDateTime__c&quot;: &quot;Record Enhanced Due Diligence Result Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;AMM&quot;
        },
        &quot;approveDueDiligence&quot;: {
            &quot;button&quot;: &quot;Approve Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Approve Enhanced Due Diligence by CEO&quot;,
            &quot;reviewInfo&quot;: {
                &quot;ApproveDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;ApproveDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;ApproveDueDiligenceBy__c&quot;: &quot;Approved Enhanced Due Diligence By&quot;,
                &quot;ApproveDueDiligenceDateTime__c&quot;: &quot;Approved Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;CEO&quot;
        }
    },
    &quot;LABIX&quot;: {
        &quot;cmReview&quot;: {
            &quot;button&quot;: &quot;Trader Review&quot;,
            &quot;section&quot;: &quot;Trader Review&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EnhanceDueDiligenceProceedByTrader__c&quot;: &quot;Review Due Diligence Result&quot;,
                &quot;EnhanceDueDiligenceCommentByTrader__c&quot;: &quot;Trader Comment&quot;,
                &quot;TraderEnhanceDueDiligenceBy__c&quot;: &quot;Trader Review By&quot;,
                &quot;TraderEnhanceDueDiligenceDateTime__c&quot;: &quot;Trader Review Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;Trader&quot;
        },
        &quot;enhanceDueDiligence&quot;: {
            &quot;button&quot;: &quot;Enhance Due Diligence&quot;,
            &quot;section&quot;: &quot;Enhanced Due Diligence Result by EDD Working Team&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EnhanceDueDiligenceResult__c&quot;: &quot;Do you want to continue?&quot;,
                &quot;EnhanceDueDiligenceCommentByEDD__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;EnhanceDueDiligenceBy__c&quot;: &quot;Enhanced Due Diligence By&quot;,
                &quot;EnhanceDueDiligenceDateTime__c&quot;: &quot;Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;EDDTeam&quot;
        },
        &quot;complianceAdvice&quot;: {
            &quot;button&quot;: &quot;Compliance Advice&quot;,
            &quot;section&quot;: &quot;Compliance Advice by GLGC&quot;,
            &quot;reviewInfo&quot;: {
                &quot;ComplianceAdviceResult__c&quot;: &quot;May this company proceed with the counterparty registration process?&quot;,
                &quot;ComplianceAdviceComment__c&quot;: &quot;Compliance Advice&quot;,
                &quot;ComplianceAdviceBy__c&quot;: &quot;Compliance Advice By&quot;,
                &quot;ComplianceAdviceDateTime__c&quot;: &quot;Compliance Advice Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;GLGC&quot;
        },
        &quot;cpxxReview&quot;: {
            &quot;button&quot;: &quot;Review Due Diligence Result&quot;,
            &quot;section&quot;: &quot;Enhanced Due Diligence Result by CPCE&quot;,
            &quot;reviewInfo&quot;: {
                &quot;CPXXReviewDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;CPXXReviewDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;CPXXReviewDueDiligenceBy__c&quot;: &quot;Enhanced Due Diligence By&quot;,
                &quot;CPXXReviewDueDiligenceDateTime__c&quot;: &quot;Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;CPCE&quot;
        },
        &quot;cmvpReview&quot;: {
            &quot;button&quot;: &quot;Review Due Diligence Result&quot;,
            &quot;section&quot;: &quot;Review Enhanced Due Diligence by DMD&quot;,
            &quot;reviewInfo&quot;: {
                &quot;CMVPReviewDueDiligenceResult__c&quot;: &quot;Review Enhanced Due Diligence Result&quot;,
                &quot;CMVPReviewDueDiligenceComment__c&quot;: &quot;Review Enhanced Due Diligence Comment&quot;,
                &quot;CMVPReviewDueDiligenceBy__c&quot;: &quot;Review Enhanced Due Diligence By&quot;,
                &quot;CMVPReviewDueDiligenceDateTime__c&quot;: &quot;Review Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;VP&quot;
        },
        &quot;evpcReview&quot;: {
            &quot;button&quot;: &quot;Endorse Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Endorse Enhanced Due Diligence by EVPC&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EVPCReviewEDDResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;EVPCReviewEDDComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;EVPCReviewEDDBy__c&quot;: &quot;Endorsed Enhanced Due Diligence By&quot;,
                &quot;EVPCReviewEDDDateTime__c&quot;: &quot;Endorsed Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;EVPC&quot;
        },
        &quot;endorseDueDiligence&quot;: {
            &quot;button&quot;: &quot;Endorse Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Record Enhanced Due Diligence Result from AMM by Trader&quot;,
            &quot;reviewInfo&quot;: {
                &quot;EndorseDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;EndorseDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment from AMM by Trader&quot;,
                &quot;EndorseDueDiligenceBy__c&quot;: &quot;Record Enhanced Due Diligence Result By Trader&quot;,
                &quot;EndorseDueDiligenceDateTime__c&quot;: &quot;Record Enhanced Due Diligence Result Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;AMM&quot;
        },
        &quot;approveDueDiligence&quot;: {
            &quot;button&quot;: &quot;Approve Enhanced Due Diligence&quot;,
            &quot;section&quot;: &quot;Approve Enhanced Due Diligence by CEO&quot;,
            &quot;reviewInfo&quot;: {
                &quot;ApproveDueDiligenceResult__c&quot;: &quot;Enhanced Due Diligence Result&quot;,
                &quot;ApproveDueDiligenceComment__c&quot;: &quot;Enhanced Due Diligence Comment&quot;,
                &quot;ApproveDueDiligenceBy__c&quot;: &quot;Approved Enhanced Due Diligence By&quot;,
                &quot;ApproveDueDiligenceDateTime__c&quot;: &quot;Approved Enhanced Due Diligence Date/Time&quot;
            },
            &quot;actorStep&quot;: &quot;CEO&quot;
        }
    }
}</value>
    </values>
    <values>
        <field>Value__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
