({
    doInit: function (component, event, helper) {
        helper.component = component;
        helper.disableEditMode();
        helper.setIsDataLoading(true);

        const p1 = helper.onLoadedBUProfile = helper.getCurrentUserBUProfile();
        const p2 = helper.onLoadedRequestCounterpartyType = helper.getRequestCounterpartyType();
        const p3 = helper.onLoadedCommitteeInfo = Promise.all([p1, p2]).then($A.getCallback(function () {
            return helper.getCommitteeInfo();
        })).catch($A.getCallback(function (error) {
            helper.showToast(error.message, 'error');
        }));
        const p4 = helper.onLoadedGroupedCommittees = helper.getGroupedCommittees();
        const p5 = p3.then($A.getCallback(() => {
            const subBU = helper.getSubBU();
            const counterpartyType = helper.getCounterpartyType();
            const type = helper.isDomesticOrInternational();
            const hasCrude = helper.hasCrudeProduct() ? "Crude" : "";
            const interByTX = helper.isInterByTX() ? "Yes" : "No";

            return helper.getTRCR(subBU, counterpartyType, type, hasCrude, interByTX);
        })).catch($A.getCallback((error) => {
            helper.showToast(error.message, 'error');
        }));
        const p6 = p3.then($A.getCallback(() => {
            const subBU = helper.getSubBU();
            const counterpartyType = helper.getCounterpartyType();
            const type = helper.isDomesticOrInternational();
            const hasCrude = helper.hasCrudeProduct() ? "Crude" : "";
            const interByTX = helper.isInterByTX() ? "Yes" : "No";

            return helper.getTRCRSectionHead(subBU, counterpartyType, type, hasCrude, interByTX);
        })).catch($A.getCallback((error) => {
            helper.showToast(error.message, 'error');
        }));

        Promise.all([p3, p4, p5, p6]).then($A.getCallback(function ([committeeInfo, groupedCommittee, trcrList, trcrHeadList]) {
            const subBU = helper.getSubBU();

            const lstCommittee = helper.convertGroupedCommitteesToList(groupedCommittee);
            const lstCompany = [subBU];

            if (!committeeInfo.CommitteeName__c) {
                helper.defaultCommittee(lstCommittee, lstCompany, committeeInfo);
            } else {
                helper.loadCommittee(lstCommittee, lstCompany, committeeInfo);
            }

            // if (!committeeInfo.FinCrCond__c) {
            //     helper.defaultFinalCreditCondition(component);
            // } else {
            //     helper.setFinalCreditConditionVisibility(committeeInfo.FinCrCond__c);
            // }

            helper.canEdit(trcrList, trcrHeadList);
            helper.setCreditOwnerWhereCondition(trcrList);
        })).catch($A.getCallback(function (error) {
            helper.showToast(error.message, 'error');
        })).finally($A.getCallback(function () {
            helper.setIsDataLoading(false);
        }));
    },

    handleClickSelectCommittee: function (component, event, helper) {
        helper.enableEditMode();
    },

    handleClickToggleSection: function (component, event, helper) {
        const sectionAuraId = event.currentTarget.getAttribute("data-auraid");
        const sectionDiv = component.find(sectionAuraId).getElement();
        const sectionState = sectionDiv.getAttribute("class").search("slds-is-open");

        if (sectionState == -1) {
            sectionDiv.setAttribute("class", "slds-section slds-is-open");
        } else {
            sectionDiv.setAttribute("class", "slds-section");
        }
    },

    handleClickPreview: function (component, event, helper) {
        console.log('Preview email')
        helper.setPreviewEMailInfo();
        component.set("v.isModalOpen", true);
        console.log('Preview email end',component.get('v.isModalOpen'))
    },

    handleClickCancel: function (component, event, helper) {
        window.location.reload();
    },

    handleClickRevert: function (component, event, helper) {
        helper.setIsDataSaving(true);
        helper.revertToTRCR()
            .then($A.getCallback(function () {
                helper.disableEditMode();
                window.setTimeout(
                    $A.getCallback(function () {
                        window.location.reload();
                    }), 3000
                );
            }))
            .finally($A.getCallback(function () {
                helper.setIsDataSaving(false);
            }));
    },

    handleClickSubmitToSH: function (component, event, helper) {
        event.preventDefault();
        helper.submitType = "SubmitToSH";
        document.getElementById("buttonSave").click();
    },

    handleClickSubmitToCommittees: function (component, event, helper) {
        event.preventDefault();
        helper.submitType = "SubmitToCommittee";
        document.getElementById("buttonSave").click();
    },

    handleSave: function (component, event, helper) {
        debugger
        event.preventDefault();
        let bu = helper.getBU();
        let counterpartyType = helper.getCounterpartyType();

        if (!(bu === 'TX'
            && (counterpartyType === 'Customer' || counterpartyType === 'Supplier'))
        ) {
            return;
        }

        const emailInfo = component.get('v.emailInfo');
        if (
            $A.util.isEmpty(emailInfo) ||
            $A.util.isEmpty(emailInfo.Subject__c) ||
            $A.util.isEmpty(emailInfo.Message__c)
        ) {
            helper.showToast('Please recheck Email information', 'error');
            return;
        }

        const selectedEmailCommittees = component.get('v.selectedEmailCommittees');
        if (!selectedEmailCommittees || selectedEmailCommittees.length === 0) {
            helper.showToast('Please select Committee Name', 'error');
            return;
        }

        if (helper.submitType === 'SubmitToSH') {
            component.find("CTRFileUpload").deletePendingAttachments()
                .then($A.getCallback(function () {
                    component.set(
                        "v.requestFormObj.CommitteeAttachment__c",
                        JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));

                    helper.setIsDataSaving(true);
                    helper.disableEditMode();

                    return helper.submitToSH(component);
                }))
                .then($A.getCallback(function () {
                    window.setTimeout(
                        $A.getCallback(function () {
                            window.location.reload();
                        }), 3000
                    );
                }))
                .catch($A.getCallback(function (error) {
                    helper.showToast(error.message, 'error');
                }))
                .finally($A.getCallback(function () {
                    helper.setIsDataSaving(false);
                }));
        } else if (helper.submitType === 'SubmitToCommittee') {
            component.find("CTRFileUpload").deletePendingAttachments()
                .then($A.getCallback(function () {
                    component.set(
                        "v.requestFormObj.CommitteeAttachment__c",
                        JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));

                    helper.setIsDataSaving(true);
                    helper.disableEditMode();

                    return helper.submitToCommittees(component);
                }))
                .then($A.getCallback(function () {
                    helper.uploadFileToSharePoint();
                    window.setTimeout(
                        $A.getCallback(function () {
                            window.location.reload();
                        }), 3000
                    );
                }))
                .catch($A.getCallback(function (error) {
                    helper.showToast(error.message, 'error');
                }))
                .finally($A.getCallback(function () {
                    helper.setIsDataSaving(false);
                }));
        } else {
            component.find("CTRFileUpload").deletePendingAttachments()
                .then($A.getCallback(function () {
                    component.set(
                        "v.requestFormObj.CommitteeAttachment__c",
                        JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));

                    helper.setIsDataSaving(true);
                    helper.disableEditMode();

                    const committeeStatus = component.get("v.committeeStatus");
                    if (committeeStatus === "Waiting Section Head Review") {
                        return helper.saveRequestFormSH(component);
                    } else {
                        return helper.saveRequestForm(component);
                    }
                }))
                .then($A.getCallback(function () {
                    window.setTimeout(
                        $A.getCallback(function () {
                            window.location.reload();
                        }), 3000
                    );
                }))
                .catch($A.getCallback(function (error) {
                    helper.showToast(error.message, 'error');
                }))
                .finally($A.getCallback(function () {
                    helper.setIsDataSaving(false);
                }));
        }
        helper.submitType = '';
    },

    // handleChangeTypeOfBusiness: function (component, event, helper) {
    //     const typeOfBusiness = component.find("TypeOfBusiness").get("v.value");
    //     if (typeOfBusiness == "Other") {
    //         component.set("v.requiredTypeOfBusinessOther", true);
    //     } else {
    //         component.find("TypeOfBusinessOther").set("v.value", "");
    //         component.set("v.requiredTypeOfBusinessOther", false);
    //     }
    // },

    // handleChangeFinalCreditCondition: function (component, event, helper) {
    //     const creditCondition = $A.util.isArray(component.find("FinCrCond"))
    //         ? component.find("FinCrCond")[0].get("v.value")
    //         : component.find("FinCrCond").get("v.value");
    //     helper.setFinalCreditConditionVisibility(creditCondition);
    //     helper.resetFinalCreditCondition();
    // },

    // handleChangeTXCashOnDelivery: function (component, event, helper) {
    //     const CashOnDelivery = component.find("TXFinCashOnDelivery");
    //     const HavingCollateral = component.find("TXFinHavingCollateral");
    //     const AmountBankGuarantee = component.find("TXFinAmountBankGuarantee");
    //     // const HavingCreditTermorLetter = component.find("TXFinHavingCreditTermOrLetter");
    //     const AmountCreditTerm = component.find("TXFinAmountCreditTerm");
    //     const BuyTradeEndorsement = component.find("TXFinBuyTradeEndorsement");
    //     const AmountBuyTrade = component.find("TXFinAmountBuyTrade");
    //     const BuyTradeDCLCondition = component.find("TXFinBuyTradeDCLCondition");
    //     const AmountDCLCondition = component.find("TXFinAmountDCLCondition");
    //     const HavingOpenedCredit = component.find("TXFinHavingOpenedCredit");
    //     const AmountOpenedCredit = component.find("TXFinAmountOpenedCredit");

    //     if (CashOnDelivery.get("v.value") !== "No") {
    //         HavingCollateral.set("v.value", "");
    //         // HavingCreditTermorLetter.set("v.value", "");
    //         BuyTradeEndorsement.set("v.value", "");
    //         BuyTradeDCLCondition.set("v.value", "");
    //         HavingOpenedCredit.set("v.value", "");

    //         AmountBankGuarantee.set("v.value", "0.00");
    //         AmountCreditTerm.set("v.value", "0.00");
    //         AmountBuyTrade.set("v.value", "0.00");
    //         AmountDCLCondition.set("v.value", "0.00");
    //         AmountOpenedCredit.set("v.value", "0.00");
    //     }
    //     helper.alertTXRequiredCreditInsurance();
    // },

    // handleChangeTXCreditInsurance: function (component, event, helper) {
    //     const HavingCollateral = component.find("TXFinHavingCollateral");
    //     const AmountBankGuarantee = component.find("TXFinAmountBankGuarantee");
    //     // const HavingCreditTermorLetter = component.find("TXFinHavingCreditTermOrLetter");
    //     const AmountCreditTerm = component.find("TXFinAmountCreditTerm");
    //     const BuyTradeEndorsement = component.find("TXFinBuyTradeEndorsement");
    //     const AmountBuyTrade = component.find("TXFinAmountBuyTrade");
    //     const BuyTradeDCLCondition = component.find("TXFinBuyTradeDCLCondition");
    //     const AmountDCLCondition = component.find("TXFinAmountDCLCondition");
    //     const HavingOpenedCredit = component.find("TXFinHavingOpenedCredit");
    //     const AmountOpenedCredit = component.find("TXFinAmountOpenedCredit");

    //     if (HavingCollateral.get("v.value") === "No") {
    //         AmountBankGuarantee.set("v.value", 0);
    //     }
    //     // if (HavingCreditTermorLetter.get("v.value") === "No") {
    //     //     AmountCreditTerm.set("v.value", 0);
    //     // }
    //     if (BuyTradeEndorsement.get("v.value") === "No") {
    //         AmountBuyTrade.set("v.value", 0);
    //     }
    //     if (BuyTradeDCLCondition.get("v.value") === "No") {
    //         AmountDCLCondition.set("v.value", 0);
    //     }
    //     if (HavingOpenedCredit.get("v.value") === "No") {
    //         AmountOpenedCredit.set("v.value", 0);
    //     }
    //     helper.alertTXRequiredCreditInsurance(component, event, helper);
    // },

    // handleChangeCurrency: function (component, event, helper) {
    //     try {
    //         if (helper.getBU() === "TX") {
    //             component.find("FinTotalSecuredCurrency").set("v.value", component.find("TXFinCrLimitCur").get("v.value"))
    //         } else {
    //             component.find("FinTotalSecuredCurrency").set("v.value", component.find("FinCrLimitCur").get("v.value"))
    //         }
    //     } catch (ex) {
    //         console.error(ex);
    //     }
    // },
    handleChangeSelectedCommittees: function (component, event, helper) {
        const selectedCommittees = component.get("v.selectedCommittees");
        component.set("v.requestFormObj.CommitteeName__c", selectedCommittees.join(","));
    },

    handleChangeSelectedEmailCommittees: function (component, event, helper) {
        const selectedEmailCommittees = component.get("v.selectedEmailCommittees");
        component.set("v.emailInfo.EmailTo__c", selectedEmailCommittees.join(","));
        component.set("v.requestFormObj.EmailTo__c", selectedEmailCommittees.join(","));
    },

    handleChangeEmailUrgent: function (component, event, helper) {
        const emailUrgent = component.get("v.emailUrgent");
        var currSubject = component.get("v.requestFormObj.Subject__c");
        var subject = currSubject;
        if (currSubject && currSubject.includes("[Urgent]")) {
            if (emailUrgent === "No") {
                subject = currSubject.replace('[Urgent]', '');
            }
        } else {
            if (emailUrgent === "Yes") {
                subject = "[Urgent]" + currSubject;
            }
        }
        // const subject = (emailUrgent === "Yes") ? "[Urgent]" + component.get("v.requestFormObj.Subject__c") : component.get("v.requestFormObj.Subject__c").replace('[Urgent]','');
        component.set("v.emailInfo.Subject__c", subject);
    },

    calTotalSecuredAmount: function (component, event, helper) {
        helper.calTotalSecuredAmount();
    },
    
    handleCheckboxChange: function (component, event, helper) {
        debugger
        let requestFormObj = component.get("v.requestFormObj");
        let id = event.getSource().getLocalId();
        requestFormObj[id] = event.getSource().get("v.checked");
        component.get("v.requestFormObj");
    },
})