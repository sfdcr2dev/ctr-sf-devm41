({
    enableEditMode: function (component) {
        component.set('v.isEdit', true);
    },

    disableEditMode: function (component) {
        component.set('v.isEdit', false);
    },

    getGroupedCommittee: function (component) {
        return new Promise($A.getCallback(function(resolve, reject) {
            const action = component.get("c.getGroupedCommittees");
            action.setCallback(this, function (response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    const groupedCommittees = response.getReturnValue();
                    component.set("v.groupedCommittees", groupedCommittees);
                    resolve(groupedCommittees)
                } else {
                    console.error("Error fetching committees: " + state);
                    reject(response.getError())
                }
            });
            $A.enqueueAction(action);
        }))
    },

    getCommitteeInfo: function (component) {
        console.log('Debug template type ',component.get('v.templateType'))
        const _THIS_ = this;
        return new Promise($A.getCallback(function(resolve, reject) {
            const action = component.get('c.getCommitteeInfo');
            action.setParams({
                "recordId": component.get('v.recordId'),
                "templateType": component.get('v.templateType')
            });
            action.setCallback(this, function (response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    const committeeInfo = response.getReturnValue();
                    if (committeeInfo) {
                        _THIS_.setPropertiesFromCommitteeInfo(component, committeeInfo);
                    }
                    resolve(committeeInfo);
                } else {
                    console.log('get committee info error: ' + JSON.stringify(response.getError()));
                    reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        }))
    },

    setPropertiesFromCommitteeInfo: function (component, committeeInfo) {
        component.set('v.emailTo', committeeInfo.EmailTo__c);
        component.set('v.selectedEmailCC', committeeInfo.EmailCC__c);
        component.set('v.emailUrgent', committeeInfo.EmailUrgent__c ? 'Yes' : 'No');
        component.set('v.uploadedFile', committeeInfo.CommitteeAttachment__c);
        component.set('v.requestFormObj', {
            CommitteeAttachment__c: committeeInfo.CommitteeAttachment__c,
            BuyTradeDCLCondition__c: committeeInfo.BuyTradeDCLCondition__c,
            BuyTradeEndorsement__c: committeeInfo.BuyTradeEndorsement__c,
            HavingCollateral__c: committeeInfo.HavingCollateral__c,
            CashOnDelivery__c: committeeInfo.CashOnDelivery__c,
            HavingOpenedCredit__c: committeeInfo.HavingOpenedCredit__c,
            AmountBankGuarantee__c: committeeInfo.AmountBankGuarantee__c || 0.00,
            AmountBuyTrade__c: committeeInfo.AmountBuyTrade__c || 0.00,
            AmountDCLCondition__c: committeeInfo.AmountDCLCondition__c || 0.00,
            AmountOpenedCredit__c: committeeInfo.AmountOpenedCredit__c || 0.00,
            AmountCreditTerm__c: committeeInfo.AmountCreditTerm__c || 0.00,
            FinBuyTradeDCLCondition__c: committeeInfo.FinBuyTradeDCLCondition__c,
            FinBuyTradeEndorsement__c: committeeInfo.FinBuyTradeEndorsement__c,
            FinHavingCollateral__c: committeeInfo.FinHavingCollateral__c,
            FinCashOnDelivery__c: committeeInfo.FinCashOnDelivery__c,
            FinHavingOpenedCredit__c: committeeInfo.FinHavingOpenedCredit__c,
            Name: committeeInfo.Name,
            FinAmountBankGuarantee__c: committeeInfo.FinAmountBankGuarantee__c || 0.00,
            FinAmountBuyTrade__c: committeeInfo.FinAmountBuyTrade__c || 0.00,
            FinAmountDCLCondition__c: committeeInfo.FinAmountDCLCondition__c || 0.00,
            FinAmountOpenedCredit__c: committeeInfo.FinAmountOpenedCredit__c || 0.00,
            FinAmountCreditTerm__c: committeeInfo.FinAmountCreditTerm__c || 0.00,
            FinTotalSecuredCurrency__c: committeeInfo.FinTotalSecuredCurrency__c,
            FinHavingCreditTermOrLetter__c: committeeInfo.FinHavingCreditTermOrLetter__c,
            OtherCondition__c: committeeInfo.OtherCondition__c,
            Currency__c: committeeInfo.Currency__c,
            CommitteeName__c: committeeInfo.CommitteeName__c,
            FinCrCond__c: committeeInfo.FinCrCond__c,
            FinPaymentCond__c: committeeInfo.FinPaymentCond__c,
            FinOtherCondition__c: committeeInfo.FinOtherCondition__c,
        })
        component.set('v.subBU', committeeInfo.SubBU__c);
        component.set('v.creditOwner', committeeInfo.CreditOwner__c);
        component.set('v.committeeInfo', committeeInfo);
        component.set('v.counterpartyType', this.getCounterpartyType());
        this.getMailToCommittee(component, committeeInfo);
        this.setMailToCommittee(component);
        this.calTotalSecuredAmount(component);
    },

    setMailToCommittee: function (component) {
        console.log('Debug set email to committee ',JSON.stringify(component.get('v.emailInfo')))
        const emailUrgent = component.get('v.emailUrgent') === 'Yes';
        component.set('v.requestFormObj.EmailUrgent__c', emailUrgent);
        component.set('v.requestFormObj.EmailTo__c', component.get('v.emailTo'));

        const defaultCCEmail = 'ccemailcommitteetestuser@278tumlkpac10g9kik3znxpnfa13iz7hj9w1rudnbh2cj8m2pw.1m-2nh5eam.cs117.apex.sandbox.salesforce.com';

        let selectedEmailCC = component.get('v.selectedEmailCC');
        //if (!selectedEmailCC || selectedEmailCC === '') {
        //    selectedEmailCC = defaultCCEmail;
        //} else if (!selectedEmailCC.includes(defaultCCEmail)) {
        //    selectedEmailCC += ', ' + defaultCCEmail;
        //}
        component.set('v.requestFormObj.EmailCC__c', selectedEmailCC);

        component.set('v.requestFormObj.Subject__c', component.get('v.emailInfo.Subject__c'));
        component.set('v.requestFormObj.Message__c', component.get('v.emailInfo.Message__c'));
        component.set('v.requestFormObj.CommitteeName__c', component.get('v.committeeName'));
    },

    setPreviewMailObject: function(component) {
        const requestFormObj = component.get('v.requestFormObj');
        const committeeInfo = component.get('v.committeeInfo');

        const emailTo = !$A.util.isEmpty(component.get('v.emailTo')) ? String(component.get('v.emailTo')) : '';
        const emailCC = !$A.util.isEmpty(component.get('v.selectedEmailCC')) ? String(component.get('v.selectedEmailCC')) : '';
        const subject = !$A.util.isEmpty(component.get('v.emailInfo.Subject__c')) ? String(component.get('v.emailInfo.Subject__c')) : '';
        const message = !$A.util.isEmpty(component.get('v.emailInfo.Message__c')) ? String(component.get('v.emailInfo.Message__c')) : '';
        let replacedMessage = message;
        if (committeeInfo
            && committeeInfo.CTRRequestFormHeader__r
            && committeeInfo.CTRRequestFormHeader__r.Customer__r
            && committeeInfo.CTRRequestFormHeader__r.Customer__r.Name
        ) {
            replacedMessage = replacedMessage.replace('{$AccountName$}', committeeInfo.CTRRequestFormHeader__r.Customer__r.Name);
        }
        if (committeeInfo
            && committeeInfo.RecordType
            && committeeInfo.RecordType.Name
        ) {
            const recordType = committeeInfo.RecordType.Name.toLowerCase().includes('customer')
                ? 'Customer'
                : committeeInfo.RecordType.Name.toLowerCase().includes('supplier')
                    ? 'Supplier'
                    : '';
            replacedMessage = replacedMessage.replace('{$RecordType$}', recordType);
        }
        if (requestFormObj
            && requestFormObj.FinCrCond__c
        ) {
            replacedMessage = replacedMessage.replace('{$FinalCreditCondition$}', requestFormObj.FinCrCond__c);
        }
        if (requestFormObj
            && requestFormObj.FinOtherCondition__c
        ) {
            replacedMessage = replacedMessage.replace('{$FinalOtherCondition$}', requestFormObj.FinOtherCondition__c);
        }
        if (requestFormObj
            && requestFormObj.FinPaymentCond__c
        ) {
            replacedMessage = replacedMessage.replace('{$FinalPaymentCondition$}', requestFormObj.FinPaymentCond__c);
        }

        component.set('v.previewMailObj', {
            EmailTo__c: emailTo,
            EmailCC__c: emailCC,
            Subject__c: subject,
            Message__c: replacedMessage,
        });
        component.set('v.fileList', component.find("CTRFileUpload").getMergedAttachments());
    },

    getMailToCommittee: function (component, committeeInfo) {
        if (!committeeInfo.Subject__c.includes('[RequestNo.:')) {
            const part = committeeInfo.Subject__c.split(":");
            if (part.length === 1) {
                part[0] = `[RequestNo.:${committeeInfo.Name}] : ${part[0]}`;
            } else {
                part[0] = part[0].trim();
                part[0] = `${part[0]}[RequestNo.:${committeeInfo.Name}] `;
            }
            committeeInfo.Subject__c = part.join(":");
        }
        console.log('Debug get mail to committee ',committeeInfo)
        component.set("v.emailInfo", {
            Subject__c: committeeInfo.Subject__c,
            EmailTo__c: committeeInfo.EmailTo__c,
            EmailCC__c: committeeInfo.EmailCC__c,
            Message__c: committeeInfo.Message__c,
        })
    },

    saveRequestForm: function (component, isSubmit) {
        console.log('Debug save form ',JSON.stringify(component.get('v.requestFormObj')))
        if (isSubmit) {
            this.saveRequestFormAction(component, 'c.saveReqFormItem', 'The request form has been submitted to Committee!', true);
        } else {
            const creditOwner = component.get('v.creditOwner');
            const creditOwnerOld = component.get('v.creditOwnerOld');
            if (creditOwner && creditOwner != creditOwnerOld) {
                component.set('v.requestFormObj.CreditOwner__c', creditOwner);
                this.saveRequestFormAction(component, 'c.saveReqFormItem', 'The request form has been reassigned to delegated person!', false);
            } else {
                component.set('v.requestFormObj.CreditOwner__c', creditOwnerOld );
                this.saveRequestFormAction(component, 'c.saveReqFormItem', 'The request form has been saved!', false);
            }
        }
    },

    saveRequestFormAndSubmitToSH: function (component) {
        const bu = component.get('v.buProfile');
        const message = (bu === 'TX') ? 'The request form has been submitted to FA Manager successfully' : (bu === 'LABIX') ? 'The request form has been submitted to FALB Manager successfully' : 'The request form has been submitted to TRCR Section Head successfully';
        this.saveRequestFormAction(component, 'c.saveReqFormItemAndSubmitToSH', message, true);
    },

    saveRequestFormAction: function (component, actionName, successMessage, isSubmit) {
        this.setMailToCommittee(component);
        console.log('Debug before save request ',actionName,JSON.stringify(component.get('v.requestFormObj')));
        debugger;
        const uploadList = component.get('v.uploadedFile');
        let action = component.get(actionName);
        action.setParams({
            "recordId": component.get('v.recordId'),
            "reqFormObj": component.get('v.requestFormObj'),
            "isSubmit": isSubmit,
            "uploadedList": (uploadList !== "[]") ? uploadList : "",
            "templateType": component.get('v.templateType'),
            "profile": component.get('v.buProfile')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let insertedReqForm = response.getReturnValue();
                this.showToast(successMessage, true);
                component.set('v.showSpinner', false);
                window.setTimeout(
                    $A.getCallback(function() {
                        window.location.reload();
                    }), 3000
                );
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function (message, isSuccess) {
        const toastTitle = isSuccess ? "Success!" : "Error!";
        const toastType = isSuccess ? "success" : "error";
        const toastParams = {
            title: toastTitle,
            type: toastType,
            message: message
        };

        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },

    getFileList: function (component) {
        let action = component.get('c.getUploadedFileName');
        action.setParams({
            "recordId": component.get('v.recordId'),
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let fileName = response.getReturnValue();
                component.set('v.uploadedFile', fileName);
                console.log('fileName in get list file: ' + component.get('v.uploadedFile'));

                let oldAttachments = JSON.parse(fileName) || [];

                let attachments = oldAttachments.filter((item) => item.IsSaved);
                component.set("v.attachments", attachments);
                component.set('v.uploadedFile', JSON.stringify(attachments));

                let fileToDelList = oldAttachments.filter((item) => !item.IsSaved);
                let idFileToDelList = fileToDelList.map((item) => item.Id);

                component.set("v.fileToDelList", idFileToDelList);
                let haveToDeleteFile = idFileToDelList.length > 0;
                component.set("v.isDelFile", haveToDeleteFile);
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getCurrentUserBUProfile: function (component) {
        return new Promise($A.getCallback(function (resolve, reject) {
            let action = component.get("c.getCurrentUserBUProfile")
            action.setParams({
                "recordId": component.get('v.recordId'),
            })
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue())
                } else {
                    reject(response.getError())
                }
            })
            $A.enqueueAction(action)
        }))
    },

    getCurrentUser: function (component) {
        return new Promise($A.getCallback(function (resolve, reject) {
            let action = component.get("c.getCurrentUser")
            action.setParams({
                "recordId": component.get('v.recordId'),
            })
            action.setCallback(this, function (response) {
                let state = response.getState()
                if (state === "SUCCESS") {
                    component.set("v.currentUser", response.getReturnValue())
                    resolve(response.getReturnValue())
                } else {
                    reject(response.getError())
                }
            })
            $A.enqueueAction(action)
        }));
    },

    // getCurrentUserCommitteeOwnerSH: function (component) {
    //     return new Promise($A.getCallback(function (resolve, reject) {
    //         let action = component.get("c.getCurrentUserCommitteeOwnerSH")
    //         action.setParams({
    //             "recordId": component.get('v.recordId'),
    //         })
    //         action.setCallback(this, function (response) {
    //             let state = response.getState()
    //             if (state === "SUCCESS") {
    //                 component.set("v.committeeOwnerSH", response.getReturnValue())
    //                 resolve(response.getReturnValue())
    //             } else {
    //                 reject(response.getError())
    //             }
    //         });
    //         $A.enqueueAction(action);
    //     }));
    // },

    getTRCR: function (component, salesOrg, counterpartyType, type, hasCrude, interByTX) {
        return new Promise($A.getCallback(function (resolve, reject) {
            let action = component.get("c.getTRCR")
            action.setParams({
                "salesOrg": salesOrg,
                "recordType": counterpartyType,
                "type": type,
                "hasCrude": hasCrude,
                "interByTX": interByTX,
            })
            action.setCallback(this, function (response) {
                let state = response.getState()
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue())
                } else {
                    reject(response.getError())
                }
            });
            $A.enqueueAction(action);
        }));
    },

    getTRCRSectionHead: function (component, salesOrg, counterpartyType, type, hasCrude, interByTX) {
        return new Promise($A.getCallback(function (resolve, reject) {
            let action = component.get("c.getTRCRSectionHead")
            action.setParams({
                "salesOrg": salesOrg,
                "recordType": counterpartyType,
                "type": type,
                "hasCrude": hasCrude,
                "interByTX": interByTX,
            })
            action.setCallback(this, function (response) {
                let state = response.getState()
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue())
                } else {
                    reject(response.getError())
                }
            });
            $A.enqueueAction(action);
        }));
    },

    setEmailTemplateType: function (component) {
        const buProfile = component.get("v.buProfile");
        const buMapping = {
            "TOP": "Committee TOP",
            "TX": "Committee TX",
            "LABIX": "Committee LABIX"
        };
		
        console.log ('buProfile : ' +buProfile,buMapping[buProfile]);
        component.set('v.templateType', buMapping[buProfile] || 'Committee TOP');
    },

    calTotalSecuredAmount: function (component) {
        const requestFormObj = component.get('v.requestFormObj');
        const amount1 = Number(requestFormObj.FinAmountBankGuarantee__c);
        const amount2 = Number(requestFormObj.FinAmountBuyTrade__c);
        const amount3 = Number(requestFormObj.FinAmountDCLCondition__c);
        const amount4 = Number(requestFormObj.FinAmountOpenedCredit__c);
        const amount5 = Number(requestFormObj.FinAmountCreditTerm__c);
        console.log('Cal total amount ',amount1,amount2,amount3,amount4,amount5)
        const totalAmount = (amount1 + amount2 + amount3 + amount4 + amount5).toFixed(2).split(".");
        const formattedTotalAmount = totalAmount[0].replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + (totalAmount[1] ? "." + totalAmount[1] : "")
        component.set('v.totalAmount', formattedTotalAmount);
        console.log('result totalAmount ' + formattedTotalAmount);
    },

    handleRevert: function (component) {
        let action = component.get('c.revertToTRCR');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "comment": component.get('v.requestFormObj.Comment__c'),
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let isReverted = response.getReturnValue();
                if (isReverted) {
                    this.showToast('The request has been reverted to Credit Team!', true);
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.showToast('Cannot revert to Credit Team', false);
                }
            } else if (state === "ERROR") {
                console.log('Error when revert to Credit Team');
            }
        });
        $A.enqueueAction(action);
    },

    uploadFileToSharePoint: function (component) {
        console.log('uploadFileToSharePoint---v.showSpinner', component.get('v.showSpinner'));
        console.log('uploadFileToSharePoint---v.uploadedFile', component.get('v.uploadedFile'));

        component.set('v.showSpinner', true);
        let action = component.get('c.sendFiletoHeroku');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "uploadedList": component.get('v.uploadedFile')

        });
        action.setCallback(this, function (res) {
            let state2 = res.getState();
            console.log('state2:' + state2);
            if (state2 === "SUCCESS") {
                this.showToast('Files submitted!', true);

            }
            component.set('v.showSpinner', false);
            // this.closeModal(component);
            //window.location.reload();
        });
        $A.enqueueAction(action);
    },

    setRadioFinalInternalCreditRating: function (component, internalCreditRating) {
        try {
            component.find("FinIntCrRating").set("v.value", internalCreditRating)
            if (internalCreditRating == "A") {
                component.find("A").getElement() && (component.find("A").getElement().checked = true)
                component.find("TXA").getElement() && (component.find("TXA").getElement().checked = true)
            } else if (internalCreditRating == "B") {
                component.find("B").getElement() && (component.find("B").getElement().checked = true)
                component.find("TXB").getElement() && (component.find("TXB").getElement().checked = true)
            } else if (internalCreditRating == "C") {
                component.find("C").getElement() && (component.find("C").getElement().checked = true)
                component.find("TXC").getElement() && (component.find("TXC").getElement().checked = true)
            } else if (internalCreditRating == "D") {
                component.find("D").getElement() && (component.find("D").getElement().checked = true)
                component.find("TXD").getElement() && (component.find("TXD").getElement().checked = true)
            } else if (internalCreditRating == "N/A") {
                component.find("NA").getElement() && (component.find("NA").getElement().checked = true)
                component.find("TXNA").getElement() && (component.find("TXNA").getElement().checked = true)
            } else if (internalCreditRating == "G/S") {
                component.find("GS").getElement() && (component.find("GS").getElement().checked = true)
                component.find("TXGS").getElement() && (component.find("TXGS").getElement().checked = true)
            } else if (internalCreditRating == "C+") {
                component.find("CPlus").getElement() && (component.find("CPlus").getElement().checked = true)
                component.find("TXCPlus").getElement() && (component.find("TXCPlus").getElement().checked = true)
            }
        } catch(ex) {
            console.error(ex)
        }
    },

    setCreditConditionVisibility: function(component, creditCondition) {
        const buProfile = component.get("v.buProfile")

        if (buProfile == 'TOP' || buProfile == 'LABIX') {
            if (creditCondition == 'Open Account') {
                component.set("v.isCreditLimitDisable", true);
                component.set("v.isTradeCreditDisable", false);
            } else if (
                creditCondition == 'Open Account With Collateral'
                || creditCondition == 'L/C'
                || creditCondition == 'Domestic L/C'
            ) {
                component.set("v.isTradeCreditDisable", true);
                component.set("v.isCreditLimitDisable", true);
            } else if (
                creditCondition == 'Cash in Advance'
                || creditCondition == 'Others'
            ) {
                component.set("v.isTradeCreditDisable", false);
                component.set("v.isCreditLimitDisable", false);
            }
        }
    },

    resetFinalCreditInformation: function(component) {

        component.find("FinCrLimit").set("v.value", '')
        component.find("FinCrLimitCur").set("v.value", '')
        component.find("FinTradeCrIns").set("v.value", '')
        component.find("FinTradeCrInsCu").set("v.value", '')
        component.find("TermOfPayment").set("v.value", '')
        component.find("FinPaymentCond").set("v.value", '')

        component.find("TXTermOfPayment").set("v.value", '')
        component.find("TXFinRiskCategory").set("v.value", '')
        component.find("TXFinCrLimit").set("v.value", '')
        component.find("TXFinCrLimitCur").set("v.value", '')
    },

    getFinalCreditRating: function(committeeInfo) {
        const bu = this.getBU();
        const TraderWaive__c = committeeInfo.TraderWaive__c && committeeInfo.TraderWaive__c.toLowerCase() === "yes";
        const AgreeAsTraderCommentSH__c = committeeInfo.Approval_SHAgree__c && committeeInfo.Approval_SHAgree__c.toLowerCase() === "yes";
        const AgreeAsTraderCommentVP__c = committeeInfo.Approval_VPAgree__c && committeeInfo.Approval_VPAgree__c.toLowerCase() === "yes";
        const ExemptionResult__c = AgreeAsTraderCommentSH__c && AgreeAsTraderCommentVP__c;
        const InternalCreditRating__c = committeeInfo.InternalCreditRating__c;
        const InternalCreditRatingTOP__c = committeeInfo.InternalCreditRatingTOP__c;
        const ApprovalTrader_CreditRating__c = committeeInfo.ApprovalTrader_CreditRating__c;
        const FinIntCrRating__c = committeeInfo.FinIntCrRating__c;

        if (FinIntCrRating__c) return FinIntCrRating__c;

        if (TraderWaive__c && ExemptionResult__c) {
            return ApprovalTrader_CreditRating__c;
        }

        return bu === "TX" ? InternalCreditRating__c : InternalCreditRatingTOP__c;
    },

    defaultFinalCreditCondition: function(component, recordUi) {
        try {
            const bu = this.getBU();
            const fields = recordUi.record.fields
            // console.log('Debug record fields',JSON.stringify(fields));
            const TraderWaive__c = (fields.TraderWaive__c.value) && fields.TraderWaive__c.value.toLowerCase() === "yes"
            const AgreeAsTraderCommentSH__c = (fields.Approval_SHAgree__c.value) && fields.Approval_SHAgree__c.value.toLowerCase() === "yes"
            const AgreeAsTraderCommentVP__c = (fields.Approval_VPAgree__c.value) && fields.Approval_VPAgree__c.value.toLowerCase() === "yes"
            const ExemptionResult__c = AgreeAsTraderCommentSH__c && AgreeAsTraderCommentVP__c

            const FinalPerformanceBond__c = fields.FinalPerformanceBond__c.value
            const FinCrCond__c = fields.FinCrCond__c.value
            const FinCrLimit__c = fields.FinCrLimit__c.value
            const FinCrLimitCur__c = fields.FinCrLimitCur__c.value
            const FinTradeCrIns__c = fields.FinTradeCrIns__c.value
            const FinTradeCrInsCu__c = fields.FinTradeCrInsCu__c.value
            const TermOfPayment__c = fields.TermOfPayment__c.value
            const FinPaymentCond__c = fields.FinPaymentCond__c.value
            const FinRiskCategory__c = fields.FinRiskCategory__c.value
            const FinIntCrRating__c = fields.FinIntCrRating__c.value
            const FinOtherCondition__c = fields.FinOtherCondition__c.value
            const FinCashOnDelivery__c = fields.FinCashOnDelivery__c.value
            const FinHavingCollateral__c = fields.FinHavingCollateral__c.value
            const FinHavingCreditTermOrLetter__c = fields.FinHavingCreditTermOrLetter__c.value
            console.log('Debug FinHavingCreditTermOrLetter__c ',FinHavingCreditTermOrLetter__c)
            const FinBuyTradeEndorsement__c = fields.FinBuyTradeEndorsement__c.value
            const FinBuyTradeDCLCondition__c = fields.FinBuyTradeDCLCondition__c.value
            const FinHavingOpenedCredit__c = fields.FinHavingOpenedCredit__c.value
            const FinAmountBankGuarantee__c = fields.FinAmountBankGuarantee__c.value
            const FinAmountCreditTerm__c = fields.FinAmountCreditTerm__c.value
            const FinAmountBuyTrade__c = fields.FinAmountBuyTrade__c.value
            const FinAmountDCLCondition__c = fields.FinAmountDCLCondition__c.value
            const FinAmountOpenedCredit__c = fields.FinAmountOpenedCredit__c.value
            const FinTotalSecuredCurrency__c = fields.FinTotalSecuredCurrency__c.value

            const PerformanceBond__c = fields.PerformanceBond__c.value
            const Credit_Condition__c = fields.Credit_Condition__c.value
            const CreditLimit__c = fields.CreditLimit__c.value
            const CreditLimitCurrency__c = fields.CreditLimitCurrency__c.value
            const Trade_Credit_Insurance__c = fields.Trade_Credit_Insurance__c.value
            const TradeCreditInsuranceCurrency__c = fields.TradeCreditInsuranceCurrency__c.value
            const PaymentTerm__c = fields.PaymentTerm__c.value
            const PaymentCondition__c = fields.PaymentCondition__c.value
            const RiskCategory__c = fields.RiskCategory__c.value
            const InternalCreditRating__c = (bu === "TOP") ? fields.InternalCreditRatingTOP__c.value : fields.InternalCreditRating__c.value;
            const OtherCondition__c = fields.OtherCondition__c.value
            const CashOnDelivery__c = fields.CashOnDelivery__c.value
            const HavingCollateral__c = fields.HavingCollateral__c.value
            const HavingCreditTermOrLetter__c = fields.HavingCreditTermOrLetter__c.value
            const BuyTradeEndorsement__c = fields.BuyTradeEndorsement__c.value
            const BuyTradeDCLCondition__c = fields.BuyTradeDCLCondition__c.value
            const HavingOpenedCredit__c = fields.HavingOpenedCredit__c.value
            const AmountBankGuarantee__c = fields.AmountBankGuarantee__c.value
            const AmountCreditTerm__c = fields.AmountCreditTerm__c.value
            const AmountBuyTrade__c = fields.AmountBuyTrade__c.value
            const AmountDCLCondition__c = fields.AmountDCLCondition__c.value
            const AmountOpenedCredit__c = fields.AmountOpenedCredit__c.value
            // const TotalSecuredCurrency__c = fields.TotalSecuredCurrency__c.value

            const TDPerformanceBond__c = fields.TDPerformanceBond__c.value
            const ApprovalTrader_CreditCondition__c = fields.ApprovalTrader_CreditCondition__c.value
            const ApprovalTrader_CreditLimit__c = fields.ApprovalTrader_CreditLimit__c.value
            const ApprovalTrader_CreditLimitCurrency__c = fields.ApprovalTraderCreditLimitCurrency__c.value
            const ApprovalTrader_TradeCreditInsurance__c = fields.ApprovalTrader_TradeCreditInsurance__c.value
            const ApprovalTrader_TradeCreditCurrency__c = fields.ApprovalTraderTradeCreditCurrency__c.value
            const ApprovalTrader_PaymentTerm__c = fields.ApprovalTrader_PaymentTerm__c.value
            const ApprovalTrader_PaymentCondition__c = fields.ApprovalTrader_PaymentCondition__c.value
            const ApprovalTraderRiskCategory__c = fields.ApprovalTraderRiskCategory__c.value
            const ApprovalTrader_CreditRating__c = fields.ApprovalTrader_CreditRating__c.value
            // if (FinCrCond__c) return

            if (bu === "TX") {
                !FinCrCond__c && component.find("TXFinCrCond").set("v.value", Credit_Condition__c)
                !TermOfPayment__c && component.find("TXTermOfPayment").set("v.value", PaymentTerm__c)
                !FinRiskCategory__c && component.find("TXFinRiskCategory").set("v.value", RiskCategory__c)
                !FinCrLimit__c && component.find("TXFinCrLimit").set("v.value", CreditLimit__c)
                !FinCrLimitCur__c && component.find("TXFinCrLimitCur").set("v.value", CreditLimitCurrency__c)
                !FinIntCrRating__c && component.find("TXFinIntCrRating").set("v.value", InternalCreditRating__c)
                !FinOtherCondition__c && component.find("TXFinOtherCondition").set("v.value", OtherCondition__c)

                !FinCashOnDelivery__c && component.find("FinCashOnDelivery").set("v.value", CashOnDelivery__c)

                if(component.find("FinCashOnDelivery").get('v.value') == 'No') {
                    if(!FinHavingCollateral__c) {
                        component.find("FinHavingCollateral").set("v.value", HavingCollateral__c)
                        component.find("FinAmountBankGuarantee").set("v.value", AmountBankGuarantee__c)
                    }
                    if(!FinHavingCreditTermOrLetter__c) {
                        component.find("FinHavingCreditTermOrLetter").set("v.value", HavingCreditTermOrLetter__c)
                        component.find("FinAmountCreditTerm").set("v.value", AmountCreditTerm__c)
                    }
                    if(!FinBuyTradeEndorsement__c) {
                        component.find("FinBuyTradeEndorsement").set("v.value", BuyTradeEndorsement__c)
                        component.find("FinAmountBuyTrade").set("v.value", AmountBuyTrade__c)
                    }
                    if(!FinBuyTradeDCLCondition__c) {
                        component.find("FinBuyTradeDCLCondition").set("v.value", BuyTradeDCLCondition__c)
                        component.find("FinAmountDCLCondition").set("v.value", AmountDCLCondition__c)
                    }
                    if(!FinHavingOpenedCredit__c) {
                        component.find("FinHavingOpenedCredit").set("v.value", HavingOpenedCredit__c)
                        component.find("FinAmountOpenedCredit").set("v.value", AmountOpenedCredit__c)
                    }
                    !FinTotalSecuredCurrency__c && component.find("FinTotalSecuredCurrency").set("v.value", FinCrLimitCur__c) //
                }
                
                this.calTotalSecuredAmount(component);
            } else {
                if (!TraderWaive__c) {
                    // TX has no Waive will default from TRCR
                    console.log('TraderWaive__c ',PerformanceBond__c)
                    !FinalPerformanceBond__c && component.find("FinalPerformanceBond").set("v.value", PerformanceBond__c)
                    !FinCrCond__c && component.find("FinCrCond").set("v.value", Credit_Condition__c)
                    !FinCrLimit__c && component.find("FinCrLimit").set("v.value", CreditLimit__c)
                    !FinCrLimitCur__c && component.find("FinCrLimitCur").set("v.value", CreditLimitCurrency__c)
                    !FinTradeCrIns__c && component.find("FinTradeCrIns").set("v.value", Trade_Credit_Insurance__c)
                    !FinTradeCrInsCu__c && component.find("FinTradeCrInsCu").set("v.value", TradeCreditInsuranceCurrency__c)
                    !TermOfPayment__c && component.find("TermOfPayment").set("v.value", PaymentTerm__c)
                    !FinPaymentCond__c && component.find("FinPaymentCond").set("v.value", PaymentCondition__c)
                    !FinIntCrRating__c && component.find("FinIntCrRating").set("v.value", InternalCreditRating__c)
                    // !FinIntCrRating__c && this.setRadioFinalInternalCreditRating(component, InternalCreditRating__c)
                    !FinCrCond__c && component.find("TXFinCrCond").set("v.value", Credit_Condition__c)
                    !TermOfPayment__c && component.find("TXTermOfPayment").set("v.value", PaymentTerm__c)
                    !FinRiskCategory__c && component.find("TXFinRiskCategory").set("v.value", RiskCategory__c)
                    !FinCrLimit__c && component.find("TXFinCrLimit").set("v.value", CreditLimit__c)
                    !FinCrLimitCur__c && component.find("TXFinCrLimitCur").set("v.value", CreditLimitCurrency__c)
                    !FinIntCrRating__c && component.find("TXFinIntCrRating").set("v.value", InternalCreditRating__c)
                    if(!FinOtherCondition__c && component.find("FinOtherCondition")) { component.find("FinOtherCondition").set("v.value", OtherCondition__c) }
                    this.setCreditConditionVisibility(component, Credit_Condition__c)
                } else if (ExemptionResult__c) {
                    console.log('ExemptionResult__c ',TDPerformanceBond__c)
                    !FinalPerformanceBond__c && component.find("FinalPerformanceBond").set("v.value", TDPerformanceBond__c)
                    !FinCrCond__c && component.find("FinCrCond").set("v.value", ApprovalTrader_CreditCondition__c)
                    !FinCrLimit__c && component.find("FinCrLimit").set("v.value", ApprovalTrader_CreditLimit__c)
                    !FinCrLimitCur__c && component.find("FinCrLimitCur").set("v.value", ApprovalTrader_CreditLimitCurrency__c)
                    !FinTradeCrIns__c && component.find("FinTradeCrIns").set("v.value", ApprovalTrader_TradeCreditInsurance__c)
                    !FinTradeCrInsCu__c && component.find("FinTradeCrInsCu").set("v.value", ApprovalTrader_TradeCreditCurrency__c)
                    !TermOfPayment__c && component.find("TermOfPayment").set("v.value", ApprovalTrader_PaymentTerm__c)
                    !FinPaymentCond__c && component.find("FinPaymentCond").set("v.value", ApprovalTrader_PaymentCondition__c)
                    !FinIntCrRating__c && component.find("FinIntCrRating").set("v.value", ApprovalTrader_CreditRating__c)
                    // !FinIntCrRating__c && this.setRadioFinalInternalCreditRating(component, ApprovalTrader_CreditRating__c)
                    !FinCrCond__c && component.find("TXFinCrCond").set("v.value", ApprovalTrader_CreditCondition__c)
                    !TermOfPayment__c && component.find("TXTermOfPayment").set("v.value", ApprovalTrader_PaymentTerm__c)
                    !FinRiskCategory__c && component.find("TXFinRiskCategory").set("v.value", ApprovalTraderRiskCategory__c)
                    !FinCrLimit__c && component.find("TXFinCrLimit").set("v.value", ApprovalTrader_CreditLimit__c)
                    !FinCrLimitCur__c && component.find("TXFinCrLimitCur").set("v.value", ApprovalTrader_CreditLimitCurrency__c)
                    !FinIntCrRating__c && component.find("TXFinIntCrRating").set("v.value", ApprovalTrader_CreditRating__c)
                    this.setCreditConditionVisibility(component, ApprovalTrader_CreditCondition__c)
                } else {
                    console.log('Else ',PerformanceBond__c)
                    !FinalPerformanceBond__c && component.find("FinalPerformanceBond").set("v.value", PerformanceBond__c)
                    !FinCrCond__c && component.find("FinCrCond").set("v.value", Credit_Condition__c)
                    !FinCrLimit__c && component.find("FinCrLimit").set("v.value", CreditLimit__c)
                    !FinCrLimitCur__c && component.find("FinCrLimitCur").set("v.value", CreditLimitCurrency__c)
                    !FinTradeCrIns__c && component.find("FinTradeCrIns").set("v.value", Trade_Credit_Insurance__c)
                    !FinTradeCrInsCu__c && component.find("FinTradeCrInsCu").set("v.value", TradeCreditInsuranceCurrency__c)
                    !TermOfPayment__c && component.find("TermOfPayment").set("v.value", PaymentTerm__c)
                    !FinPaymentCond__c && component.find("FinPaymentCond").set("v.value", PaymentCondition__c)
                    !FinIntCrRating__c && component.find("FinIntCrRating").set("v.value", InternalCreditRating__c)
                    // !FinIntCrRating__c && this.setRadioFinalInternalCreditRating(component, InternalCreditRating__c)
                    !FinCrCond__c && component.find("TXFinCrCond").set("v.value", Credit_Condition__c)
                    !TermOfPayment__c && component.find("TXTermOfPayment").set("v.value", PaymentTerm__c)
                    !FinRiskCategory__c && component.find("TXFinRiskCategory").set("v.value", RiskCategory__c)
                    !FinCrLimit__c && component.find("TXFinCrLimit").set("v.value", CreditLimit__c)
                    !FinCrLimitCur__c && component.find("TXFinCrLimitCur").set("v.value", CreditLimitCurrency__c)
                    !FinIntCrRating__c && component.find("TXFinIntCrRating").set("v.value", InternalCreditRating__c)
                    this.setCreditConditionVisibility(component, Credit_Condition__c)
                }
            }
        } catch (ex) {
            console.log('Debug ex',ex)
        }
    },

    convertToListCommittee: function(groupedCommittee) {
        const lstCommittee = [];
        groupedCommittee.forEach(function(item) {
            lstCommittee.push(...item.committees);
        });
        return lstCommittee;
    },

    getTOPCompany: function (type, products) {
        const company = [];

        if (!$A.util.isArray(products)) {
            company.push("TOP");
            return company;
        }

        products.forEach((product) => {
            switch (type) {
                case "Customer":
                    switch (product) {
                        case "Crude":
                        case "Petroleum Products":
                            company.push("TOP");
                            break;
                        case "Petrochemical Products":
                            company.push("TPX");
                            break;
                        case "Lube Base Products":
                            company.push("TLB");
                            break;
                        case "LABIX Products":
                            company.push("LABIX");
                            break;
                        default:
                            company.push("TOP", "TPX", "TLB", "LABIX");
                            break;
                    }
                    break;
                case "Supplier":
                    switch (product) {
                        case "Crude":
                        case "B100/Ethanol":
                        case "Petroleum and Components":
                            company.push("TOP");
                            break;
                        case "Normal Paraffin":
                            company.push("LABIX");
                            break;
                        default:
                            company.push("TOP", "TPX", "TLB", "LABIX");
                            break;
                    }
                    break;
            }
        });

        return company;
    },

    getTXCompany: function (type, salesOrg, purchasingOrg) {
        let company = [];
        let defaultCompany = ["TXTH"];

        switch (type) {
            case "Customer":
                switch (salesOrg) {
                    case "2000":
                        company = ["TXTH"];
                        break;
                    case "9100":
                        company = ["TSV"];
                        break;
                    case "9200":
                        company = ["TSR"];
                        break;
                    case "9300":
                        company = ["JSKem"];
                        break;
                    case "9400":
                        company = ["TXIndia"];
                        break;
                }
                break;
            case "Supplier":
                switch (purchasingOrg) {
                    case "A000":
                        company = ["TXTH"];
                        break;
                    case "H100":
                        company = ["TSV"];
                        break;
                    case "I100":
                        company = ["TSR"];
                        break;
                    case "S100":
                        company = ["JSKem"];
                        break;
                    case "N100":
                        company = ["TXIndia"];
                        break;
                }
                break;
        }

        return company.length > 0 ? company : defaultCompany;
    },

    getTXSalesOrg: function () {
        const committeeInfo = this.component.get("v.committeeInfo")
        return committeeInfo.SalesOrganizationTX__c
    },

    getTXPurchasingOrg: function () {
        const committeeInfo = this.component.get("v.committeeInfo")
        return committeeInfo.PurchasingOrganizationTX__c
    },

    loadCommittee: function(component, lstCommittee, committeeInfo) {
        const buProfile = this.getBU()
        const selectedCommittees = committeeInfo.CommitteeName__c.split(",")
        const lstFilteredCommittees = lstCommittee.filter((item) => {
            return String(item.BU__c).includes(buProfile)
        })
        component.set("v.selectedCommittees", selectedCommittees)
        component.set("v.lstCommittees", lstFilteredCommittees)
    },

    // canSelectCommittee: function(component) {
    //     const status = component.get('v.status');
    //     const approvalStep = component.get('v.approvalStep');
    //     const committeeOwner = component.get('v.committeeOwner');
    //     const committeeOwnerSH = component.get('v.committeeOwnerSH');
    //     const committeeStatus = component.get('v.committeeStatus');
    //     const currentUser = component.get('v.currentUser');

    //     let canSelectCommittee = false;
    //     if (status === 'In Review' && approvalStep === 'Select Committee') {
    //         if (!committeeStatus || committeeStatus === 'Draft' || committeeStatus === 'Reverted to Credit Team') {
    //             canSelectCommittee = currentUser === committeeOwner;
    //         }
    //         if (committeeStatus === 'Waiting Section Head Review') {
    //             canSelectCommittee = currentUser === committeeOwnerSH;
    //         }
    //     }

    //     component.set('v.canSelectCommittee', canSelectCommittee);
    // },

    canSelectCommittee: function(component, trcrList, trcrHeadList) {
        const status = component.get('v.status');
        const approvalStep = component.get('v.approvalStep');
        const creditOwner = component.get('v.creditOwner');
        const creditOwnerSectionHead = component.get('v.creditOwnerSectionHead');
        const committeeStatus = component.get('v.committeeStatus');
        const currentUser = component.get('v.currentUser');
        const bu = this.getBU();

        let canSelectCommittee = false;
        if (bu === 'TX') {
            if (status === 'In Review' && approvalStep === 'Select Committee') {
                if (!committeeStatus || committeeStatus === 'Draft') {
                    if (currentUser === creditOwner) {
                        component.set('v.canSelectCommittee', true);
                    }
                }
            }
        } else {
            if (status === 'In Review' && approvalStep === 'Select Committee') {
                if (!committeeStatus || committeeStatus === 'Draft' || committeeStatus === 'Reverted to Credit Team') {
                    if (!creditOwner) {
                        canSelectCommittee = trcrList.findIndex((item) => {
                            return currentUser === item.Id;
                        }) > -1;

                        if (canSelectCommittee) {
                            // component.set("v.requestFormObj.CreditOwner__c", currentUser);
                            component.set("v.creditOwner", currentUser);
                            component.set("v.creditOwnerOld", currentUser);
                        }
                    } else if (currentUser === creditOwner) {
                        canSelectCommittee = true;
                    }

                    // if (!creditOwnerSectionHead) {
                    //     const creditOwnerSectionHead = trcrHeadList[0];
                    //     component.set("v.creditOwnerSectionHead", creditOwnerSectionHead.Id);
                    //     component.set("v.requestFormObj.CreditOwnerSectionHead__c", creditOwnerSectionHead.Id);
                    // }
                }
                if (committeeStatus === 'Waiting Section Head Review') {
                    if (!creditOwnerSectionHead) {
                        canSelectCommittee = trcrHeadList.findIndex((item) => {
                            return currentUser === item.Id;
                        }) > -1;

                        // if (canSelectCommittee) {
                        //     component.set("v.requestFormObj.CreditOwnerSectionHead__c", currentUser);
                        // }
                    } else if (currentUser === creditOwnerSectionHead) {
                        canSelectCommittee = true;
                    }
                }
            }

            component.set('v.canSelectCommittee', canSelectCommittee);
        }
    },

    makeCreditOwnerWhereCondition: function(component, trcrList) {
        const trcrIdList = trcrList.map((item) => {
            return `'${item.Id.trim()}'`;
        });
        if (trcrIdList.length > 0) {
            component.set('v.TRCROwnerWhereCondition', `AND Id IN (${trcrIdList.join(',')})`);
        }
    },

    getBU: function() {
        return this.component.get("v.buProfile");
    },

    getSubBU: function() {
        return this.component.get("v.subBU");
    },

    getRequestType: function() {
        const committeeInfo = this.component.get("v.committeeInfo")
        if (committeeInfo.RecordType && committeeInfo.RecordType.Name) {
            const recordTypeName = committeeInfo.RecordType.Name
            return recordTypeName.includes("New")
                ? "Initial"
                : recordTypeName.includes("Extend")
                    ? "Extend"
                    : ""
        }
        return ""
    },

    getCounterpartyType: function() {
        const committeeInfo = this.component.get("v.committeeInfo")
        const recordTypeName = committeeInfo.RecordType.Name
        return recordTypeName.includes("Customer")
            ? "Customer"
            : (recordTypeName.includes("Supplier"))
                ? "Supplier"
                : ""
    },

    hasCrudeProduct: function(products) {
        const hasCrudeProduct = String(products)
            .split(",")
            .map((item) => item.trim().toLowerCase())
            .includes("crude")
        return hasCrudeProduct;
    },

    getInterestedProduct: function(bu, counterpartyType) {
        const committeeInfo = this.component.get("v.committeeInfo")
        let interestedProduct = ""
        if (bu === "TX") {
            if (counterpartyType === "Supplier") {
                interestedProduct = committeeInfo.InterestedProductTypeAsSupplierTX__c
            } else {
                interestedProduct = committeeInfo.InterestedProductTypeAsCustomerTX__c
            }
        } else {
            if (counterpartyType === "Supplier") {
                interestedProduct = committeeInfo.InterestedProductTypeAsSupplierTOP__c
            } else {
                interestedProduct = committeeInfo.InterestedProductTypeAsCustomerTOP__c
            }
        }
        return interestedProduct ? interestedProduct.split(",") : []
    },

    defaultCommitteeTXCustomer: function(component, lstCommittee, lstCompany, creditRating, buProfile) {
        const selectedCommittees = []
        const includedCommittees = []
        const lstFilteredCommittees = lstCommittee.filter((item) => {
            return String(item.BU__c).includes(buProfile)
        })
        lstCompany.forEach((company) => {
            const fieldName = company + "__c"
            lstFilteredCommittees.forEach((item) => {
                if (item[fieldName]) {
                    const rating = item[fieldName].split(",")
                    if (rating.indexOf(creditRating) > -1) {
                        selectedCommittees.push(item.DeveloperName)
                    }
                    const requiredCreditRating = "*" + creditRating;
                    if (rating.indexOf(requiredCreditRating) > -1) {
                        includedCommittees.push(item.DeveloperName)
                    }
                }
            })
        })

        component.set("v.includedCommittees", includedCommittees)
        component.set("v.selectedCommittees", selectedCommittees)
        component.set("v.lstCommittees", lstFilteredCommittees)
    },

    defaultCommitteeTXSupplier: function(component, lstCommittee, lstCompany, creditRating, buProfile) {
        const selectedCommittees = []
        const includedCommittees = []
        const lstFilteredCommittees = lstCommittee.filter((item) => {
            return String(item.BU__c).includes(buProfile)
        })
        lstCompany.forEach((company) => {
            const fieldName = company + "__c"
            lstFilteredCommittees.forEach((item) => {
                if (item[fieldName]) {
                    const rating = item[fieldName].split(",")
                    if (rating.indexOf(creditRating) > -1) {
                        selectedCommittees.push(item.DeveloperName)
                    }
                    const requiredCreditRating = "*" + creditRating;
                    if (rating.indexOf(requiredCreditRating) > -1) {
                        includedCommittees.push(item.DeveloperName)
                    }
                }
            })
        })

        component.set("v.includedCommittees", includedCommittees)
        component.set("v.selectedCommittees", selectedCommittees)
        component.set("v.lstCommittees", lstFilteredCommittees)
    },

    defaultCommitteeTOPCustomer: function(component, lstCommittee, lstCompany, creditRating, cmvpOwner, cmvpPreScreenDecision, country, buProfile) {
        const selectedCommittees = []
        const lstFilteredCommittees = lstCommittee.filter((item) => {
            return String(item.BU__c).includes(buProfile)
        })
        lstCompany.forEach((company) => {
            const fieldName = company + "__c"
            lstFilteredCommittees.forEach((item) => {
                if (item[fieldName]) {
                    const rating = item[fieldName].split(",")
                    if (rating.indexOf(creditRating) > -1) {
                        if (item.Parent__c === "CMVP") {
                            if (cmvpOwner && cmvpPreScreenDecision === "Pass" && country === "TH") {
                                selectedCommittees.push(item.DeveloperName)
                            }
                        } else if (item.Parent__c === "SA09") {
                            if (cmvpOwner && cmvpPreScreenDecision === "Pass" && country !== "TH") {
                                selectedCommittees.push(item.DeveloperName)
                            }
                        } else {
                            selectedCommittees.push(item.DeveloperName)
                        }
                    }
                }
            })
        })

        component.set("v.selectedCommittees", selectedCommittees)
        component.set("v.lstCommittees", lstFilteredCommittees)
    },

    defaultCommitteeTOPSupplier: function(component, lstCommittee, lstCompany, creditRating, cmvpOwner, cmvpPreScreenDecision, country, buProfile) {
        const selectedCommittees = []
        const lstFilteredCommittees = lstCommittee.filter((item) => {
            return String(item.BU__c).includes(buProfile)
        })
        lstCompany.forEach((company) => {
            const fieldName = company + "__c"
            lstFilteredCommittees.forEach((item) => {
                if (item[fieldName]) {
                    const rating = item[fieldName].split(",")
                    if (rating.indexOf(creditRating) > -1) {
                        if (item.Parent__c === "CMVP") {
                            if (cmvpOwner && cmvpPreScreenDecision === "Pass" && country === "TH") {
                                selectedCommittees.push(item.DeveloperName)
                            }
                        } else if (item.Parent__c === "SA09") {
                            if (cmvpOwner && cmvpPreScreenDecision === "Pass" && country !== "TH") {
                                selectedCommittees.push(item.DeveloperName)
                            }
                        } else {
                            selectedCommittees.push(item.DeveloperName)
                        }
                    }
                }
            })
        })

        component.set("v.selectedCommittees", selectedCommittees)
        component.set("v.lstCommittees", lstFilteredCommittees)
    },

    resetForm: function(component) {
        // typeof(component.find("FinCrCond").reset) === 'function' && component.find("FinCrCond").reset();
        // typeof(component.find("FinCrLimit").reset) === 'function' && component.find("FinCrLimit").reset();
        // typeof(component.find("FinCrLimitCur").reset) === 'function' && component.find("FinCrLimitCur").reset();
        // typeof(component.find("FinTradeCrIns").reset) === 'function' && component.find("FinTradeCrIns").reset();
        // typeof(component.find("FinTradeCrInsCu").reset) === 'function' && component.find("FinTradeCrInsCu").reset();
        // typeof(component.find("FinIntCrRating").reset) === 'function' && component.find("FinIntCrRating").reset();
        // typeof(component.find("FinIntCrRating").reset) === 'function' && component.find("FinIntCrRating").reset();
        // typeof(component.find("FinPaymentTerm").reset) === 'function' && component.find("FinPaymentTerm").reset();
        // typeof(component.find("FinPaymentCond").reset) === 'function' && component.find("FinPaymentCond").reset();
        // typeof(component.find("FinalPerformanceBond").reset) === 'function' && component.find("FinalPerformanceBond").reset();
        // typeof(component.find("RemarkPerformanceBond").reset) === 'function' && component.find("RemarkPerformanceBond").reset();
        // typeof(component.find("CashOnDelivery").reset) === 'function' && component.find("CashOnDelivery").reset();
        // typeof(component.find("HavingCollateral").reset) === 'function' && component.find("HavingCollateral").reset();
        // typeof(component.find("HavingCreditTermorLetter").reset) === 'function' && component.find("HavingCreditTermorLetter").reset();
        // typeof(component.find("BuyTradeEndorsement").reset) === 'function' && component.find("BuyTradeEndorsement").reset();
        // typeof(component.find("BuyTradeDCLCondition").reset) === 'function' && component.find("BuyTradeDCLCondition").reset();
        // typeof(component.find("HavingOpenedCredit").reset) === 'function' && component.find("HavingOpenedCredit").reset();
        // typeof(component.find("Currency").reset) === 'function' && component.find("Currency").reset();
        // typeof(component.find("TXFinCrCond").reset) === 'function' && component.find("TXFinCrCond").reset();
        // typeof(component.find("TXFinPaymentTerm").reset) === 'function' && component.find("TXFinPaymentTerm").reset();
        // typeof(component.find("TXFinRiskCategory").reset) === 'function' && component.find("TXFinRiskCategory").reset();
        // typeof(component.find("TXFinCrLimit").reset) === 'function' && component.find("TXFinCrLimit").reset();
        // typeof(component.find("TXFinCrLimitCur").reset) === 'function' && component.find("TXFinCrLimitCur").reset();
        // typeof(component.find("TXFinIntCrRating").reset) === 'function' && component.find("TXFinIntCrRating").reset();
        // typeof(component.find("OtherCondition").reset) === 'function' && component.find("OtherCondition").reset();

        this.defaultFinalCreditCondition(component, this.recordUi);
    },

    alertTXRequiredCreditInsurance: function(component, event, helper) {
        const obj = component.get('v.requestFormObj');
        const counterpartyType = this.getCounterpartyType();
        if (obj.FinCashOnDelivery__c === 'Yes') {
            return true;
        }

        if (counterpartyType === 'Supplier') {
            if (
                !(obj.FinHavingCollateral__c === 'Yes'
                || obj.FinHavingCreditTermOrLetter__c === 'Yes')
            ) {
                component.set('v.isShowRequiredMsg', true);
                return false;
            }
        } else {
            if (
                !(obj.FinHavingCollateral__c === 'Yes'
                || obj.FinBuyTradeDCLCondition__c === 'Yes'
                || obj.FinBuyTradeEndorsement__c === 'Yes'
                || obj.FinHavingOpenedCredit__c === 'Yes')
            ) {
                component.set('v.isShowRequiredMsg', true);
                return false;
            }
        }
        component.set('v.isShowRequiredMsg', false);
    },

    verifyTXCreditInsurance: function(component, event, helper) {
        const obj = component.get('v.requestFormObj');
        const counterpartyType = this.getCounterpartyType();
        if (obj.FinCashOnDelivery__c === 'Yes') {
            return true;
        }

        if (counterpartyType === 'Supplier') {
            if (
                !(obj.FinHavingCollateral__c === 'Yes'
                || obj.FinHavingCreditTermOrLetter__c === 'Yes')
            ) {
                this.showToast('Please select ‘Yes’ at least one.', false);
                return false;
            }
        } else {
            if (
                !(obj.FinHavingCollateral__c === 'Yes'
                || obj.FinBuyTradeDCLCondition__c === 'Yes'
                || obj.FinBuyTradeEndorsement__c === 'Yes'
                || obj.FinHavingOpenedCredit__c === 'Yes')
            ) {
                this.showToast('Please select ‘Yes’ at least one.', false);
                return false;
            }
        }

        if (obj.FinHavingCollateral__c === 'Yes' && obj.FinAmountBankGuarantee__c <= 0) {
            this.showToast('Amount need to be more than zero', false);
            return false;
        }
        if (obj.FinHavingCreditTermOrLetter__c === 'Yes' && obj.FinAmountCreditTerm__c <= 0) {
            this.showToast('Amount need to be more than zero', false);
            return false;
        }
        if (obj.FinBuyTradeEndorsement__c === 'Yes' && obj.FinAmountBuyTrade__c <= 0) {
            this.showToast('Amount need to be more than zero', false);
            return false;
        }
        if (obj.FinBuyTradeDCLCondition__c === 'Yes' && obj.FinAmountDCLCondition__c <= 0) {
            this.showToast('Amount need to be more than zero', false);
            return false;
        }
        if (obj.FinHavingOpenedCredit__c === 'Yes' && obj.FinAmountOpenedCredit__c <= 0) {
            this.showToast('Amount need to be more than zero', false);
            return false;
        }

        return true;
    },
})