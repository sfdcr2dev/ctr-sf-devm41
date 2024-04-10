({
    doInit: function (component, event, helper) {
        console.log('doInit');
        console.log('v.showSpinner: ' + component.get('v.showSpinner'));
        component.set('v.showSpinner', true);

        // helper.initialize(component);
        helper.component = component;
        helper.disableEditMode(component);

        const p1 = helper.onLoadedBUProfile = helper.getCurrentUserBUProfile(component);
        const p2 = helper.onLoadedCommitteeInfo = p1.then($A.getCallback(function (bu) {
            console.log('BU Profile Name: ' + bu);
            component.set('v.buProfile', bu);
            helper.setEmailTemplateType(component);
            return helper.getCommitteeInfo(component);
        })).catch($A.getCallback(function (error) {
            helper.showToast(error.message, false);
        }));
        const p3 = helper.onLoadedGroupedCommittee = helper.getGroupedCommittee(component);
        const p4 = helper.onLoadedCurrentUser = helper.getCurrentUser(component);

        p2.then($A.getCallback(function (committeeInfo) {
            const bu = helper.getBU();
            const counterpartyType = helper.getCounterpartyType();
            const interestedProduct = helper.getInterestedProduct(bu, counterpartyType);
            const hasCrudeProduct = helper.hasCrudeProduct(interestedProduct);
            component.set('v.interestedProduct', interestedProduct);
            component.set('v.hasCrudeProduct', hasCrudeProduct);
        }));

        Promise.all([p2, p3]).then($A.getCallback(function ([committeeInfo, groupedCommittee]) {
            const bu = helper.getBU();
            const counterpartyType = helper.getCounterpartyType();
            const interestedProduct = helper.getInterestedProduct(bu, counterpartyType);
            const country = committeeInfo.Country__r && committeeInfo.Country__r.Code__c;
            const cmvp = committeeInfo.OwnersCMVP__c;
            const cmvpDecision = committeeInfo.CMVPPreScreenDecision__c;
            const creditRating = helper.getFinalCreditRating(committeeInfo);

            const lstCommittee = helper.convertToListCommittee(groupedCommittee);
            const lstCompany = (bu === "TX")
                ? helper.getTXCompany(counterpartyType, helper.getTXSalesOrg(), helper.getTXPurchasingOrg())
                : helper.getTOPCompany(counterpartyType, interestedProduct);

            if (!committeeInfo.CommitteeName__c) {
                if (bu === "TX") {
                    counterpartyType === "Customer"
                        ? helper.defaultCommitteeTXCustomer(component, lstCommittee, lstCompany, creditRating, bu, interestedProduct)
                        : helper.defaultCommitteeTXSupplier(component, lstCommittee, lstCompany, creditRating, bu, interestedProduct);
                } else {
                    counterpartyType === "Customer"
                        ? helper.defaultCommitteeTOPCustomer(component, lstCommittee, lstCompany, creditRating, cmvp, cmvpDecision, country, bu, interestedProduct)
                        : helper.defaultCommitteeTOPSupplier(component, lstCommittee, lstCompany, creditRating, cmvp, cmvpDecision, country, bu, interestedProduct);
                }
            } else {
                helper.loadCommittee(component, lstCommittee, committeeInfo);
            }
        })).catch($A.getCallback(function (error) {
            helper.showToast(error.message, false);
        })).finally($A.getCallback(function () {
            // component.set('v.showSpinner', false);
        }));

        helper.getFileList(component);
    },

    handleToggleSection: function (component, event, helper) {
        const sectionAuraId = event.currentTarget.getAttribute('data-auraid');
        console.log('[handleToggleSection] selectionAuraId ----- ', sectionAuraId);
        const sectionDiv = component.find(sectionAuraId).getElement();
        console.log('[handleToggleSection] sectionDiv ----- ', sectionDiv);
        const sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        console.log('[handleToggleSection] sectionState ----- ', sectionState);

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section');
        }
    },

    handleSelectCommittee: function (component, event, helper) {
        helper.enableEditMode(component);
    },

    handleEmailUrgentChange: function (component, event, helper) {
        const emailUrgent = component.get('v.emailUrgent');
        const subject = (emailUrgent === 'Yes') ? '[Urgent]' + component.get('v.requestFormObj.Subject__c') : component.get('v.requestFormObj.Subject__c');
        component.set('v.emailInfo.Subject__c', subject);
    },

    calTotalSecuredAmount: function (component, event, helper) {
        helper.calTotalSecuredAmount(component);
    },

    handleRadioClick: function (component, event, helper) {
        const selectedValue = event.getSource().get("v.value");
        const fieldName = event.getSource().get("v.name");
        component.set("v.requestFormObj." + fieldName, selectedValue);
    },

    handleCreditConditionChange: function (component, event, helper) {
        const creditCondition = $A.util.isArray(component.find("FinCrCond"))
            ? component.find("FinCrCond")[0].get("v.value")
            : component.find("FinCrCond").get("v.value");
        helper.setCreditConditionVisibility(component, creditCondition);
        helper.resetFinalCreditInformation(component);
    },

    handleFinalCreditRatingChange: function (component, event, helper) {
        helper.setRadioFinalInternalCreditRating(component, event.currentTarget.value);
    },

    handleLoad: function (component, event, helper) {
        try {
            const params = event.getParams();
            const recordUi = params.recordUi;
            helper.recordUi = recordUi;

            component.set("v.status", recordUi.record.fields.Status__c.value);
            component.set("v.approvalStep", recordUi.record.fields.Approval_Step__c.value);
            component.set("v.committeeOwner", recordUi.record.fields.CommitteeOwner__c.value);
            component.set("v.committeeStatus", recordUi.record.fields.CommitteeStatus__c.value);
            component.set("v.creditOwner", recordUi.record.fields.CreditOwner__c.value);
            component.set("v.creditOwnerOld", recordUi.record.fields.CreditOwner__c.value);
            component.set("v.creditOwnerSectionHead", recordUi.record.fields.CreditOwnerSectionHead__c.value);

            component.find("FinCashOnDelivery").set("v.value", recordUi.record.fields.FinCashOnDelivery__c.value)
            component.find("FinHavingCollateral").set("v.value", recordUi.record.fields.FinHavingCollateral__c.value)
            component.find("FinBuyTradeEndorsement").set("v.value", recordUi.record.fields.FinBuyTradeEndorsement__c.value)
            component.find("FinBuyTradeDCLCondition").set("v.value", recordUi.record.fields.FinBuyTradeDCLCondition__c.value)
            component.find("FinHavingOpenedCredit").set("v.value", recordUi.record.fields.FinHavingOpenedCredit__c.value)

            // const p1 = helper.getCurrentUser(component);
            // const p2 = helper.getCurrentUserCommitteeOwnerSH(component);

            // Promise.all([p1, p2])
            //     .then($A.getCallback(([currentUser, committeeOwnerSH]) => {
            //         helper.canSelectCommittee(component);
            //     }))
            //     .catch($A.getCallback((error) => {
            //         console.log(error);
            //     }));

            helper.onLoadedBUProfile.then($A.getCallback(function () {
                const creditCondition = helper.recordUi.record.fields.FinCrCond__c.value;
                helper.setCreditConditionVisibility(component, creditCondition);
            }));

            const p1 = Promise.all([
                helper.onLoadedBUProfile,
                helper.onLoadedCommitteeInfo,
                helper.onLoadedCurrentUser
            ]).then($A.getCallback(([buProfile, committeeInfo, currentUser]) => {
                const subBU = helper.getSubBU();
                const counterpartyType = helper.getCounterpartyType();
                const type = committeeInfo.Country__r && committeeInfo.Country__r.Code__c === "TH" ? "Domestic" : "International";
                const hasCrude = (String(counterpartyType).toLowerCase() === 'supplier' && String(committeeInfo.InterestedProductTypeAsSupplierTOP__c).toLowerCase().includes("crude")) ? "Crude" : "";
                const interByTX = "No";

                return helper.getTRCR(component, subBU, counterpartyType, type, hasCrude, interByTX);
            })).catch($A.getCallback((error) => {
                console.log(error);
            }));

            const p2 = Promise.all([
                helper.onLoadedBUProfile,
                helper.onLoadedCommitteeInfo,
                helper.onLoadedCurrentUser
            ]).then($A.getCallback(([buProfile, committeeInfo, currentUser]) => {
                const subBU = helper.getSubBU();
                const counterpartyType = helper.getCounterpartyType();
                const type = committeeInfo.Country__r && committeeInfo.Country__r.Code__c === "TH" ? "Domestic" : "International";
                const hasCrude = (String(counterpartyType).toLowerCase() === 'supplier' && String(committeeInfo.InterestedProductTypeAsSupplierTOP__c).toLowerCase().includes("crude")) ? "Crude" : "";
                const interByTX = "No";

                return helper.getTRCRSectionHead(component, subBU, counterpartyType, type, hasCrude, interByTX);
            })).catch($A.getCallback((error) => {
                console.log(error);
            }));

            Promise.all([p1, p2]).then($A.getCallback(([trcrList, trcrHeadList]) => {
                helper.canSelectCommittee(component, trcrList, trcrHeadList);
                helper.makeCreditOwnerWhereCondition(component, trcrList);
            })).catch($A.getCallback((error) => {
                console.log(error);
            })).finally($A.getCallback(function () {
                component.set('v.showSpinner', false);
            }));
            helper.defaultFinalCreditCondition(component, recordUi);
        } catch (ex) {
            console.error(ex);
        }
    },

    handleTypeOfBusiness : function(component, event, helper) {
        const TypeOfBusiness = component.find("TypeOfBusiness").get("v.value"); //component.find("TypeOfBusiness").getElement().value;
        if(TypeOfBusiness == 'Other'){
            component.set('v.isOtherRequired',true);
        } else {
            component.find("TypeOfBusinessOther").set("v.value",'');
            component.set('v.isOtherRequired',false);
        }
    },

    handlePreview: function (component, event, helper) {
        helper.setMailToCommittee(component);
        helper.setPreviewMailObject(component);
        // console.log('attachments length: '+ component.get('v.attachments').length);
        setTimeout($A.getCallback(function () {
            component.set('v.isModalOpen', true);
        }), 600);
    },

    handleCancel: function (component, event, helper) {
        // component.set('v.fileList', []);
        // component.set('v.fileToDelList', []);
        // component.set('v.isFetchAttachments', true);
        // helper.disableEditMode(component);
        // $A.get('e.force:refreshView').fire();

        // const action = component.get("c.doInit");
        // action.setCallback(this, function (response) {
        //     const state = response.getState();
        //     if (state === "SUCCESS") {
        //         component.set("v.isReload", true);
        //         // helper.resetForm(component);
        //         setTimeout($A.getCallback(function() {
        //             component.set("v.isReload", false);
        //         }), 1000);
        //     }
        // });
        // $A.enqueueAction(action);

        // window.setTimeout(
        //     $A.getCallback(function() {
                window.location.reload();
        //     }), 1000
        // );
    },

    handleRevert: function (component, event, helper) {
        helper.handleRevert(component);
        helper.disableEditMode(component);
    },

    handleSave: function (component, event, helper) {
        event.preventDefault();
        if (helper.getBU() === 'TX' && !helper.verifyTXCreditInsurance(component)) {
            console.log('End tx')
            return;
        }
        console.log('Before file uploader')
        // const CTRFileUploader = component.find('CTRFileUploader');
        // CTRFileUploader.onSave().then((r) => {
        //     // console.log('saved:' + JSON.stringify(component.get("v.jsonFileList")));
        //     // component.find("attachments").set("v.value", JSON.stringify(component.get("v.jsonFileList")));
        //     // component.set("v.requestFormObj.CommitteeAttachment__c", JSON.stringify(component.get("v.jsonFileList")));
        //     // component.find("requestItemLoader").saveRecord($A.getCallback(function (saveResult) {
        //     //     console.log(saveResult);
        //     // }));
        // });
        console.log('Debug submit type ', helper.submitType)
        if (helper.submitType === 'SubmitToSH') {
            // if (helper.getBU() === 'TX') {
            //     if (!helper.verifyTXCreditInsurance(component)) {
            //         return;
            //     }
            // }

            const emailInfo = component.get('v.emailInfo');
            if (
                $A.util.isEmpty(emailInfo) || 
                $A.util.isEmpty(emailInfo.Subject__c) || 
                $A.util.isEmpty(emailInfo.Message__c)
            ) {
                helper.showToast('Please recheck Email information', false);
                return;
            }
            const selectedEmailCommittees = component.get('v.selectedEmailCommittees');
            if (!selectedEmailCommittees || selectedEmailCommittees.length === 0) {
                helper.showToast('Please select Committee Name', false);
                return;
            }
            component.set('v.showSpinner', true);
            component.set('v.isSubmit', true);
            // helper.uploadFileToSharePoint(component);
            helper.disableEditMode(component);
            // helper.saveRequestFormAndSubmitToSH(component);
            component.find("CTRFileUpload").deletePendingAttachments()
                .then($A.getCallback(function () {
                    component.set(
                        "v.requestFormObj.CommitteeAttachment__c",
                        JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));
                    helper.saveRequestFormAndSubmitToSH(component);
                }));
        } else if (helper.submitType === 'Submit') {
            // if (helper.getBU() === 'TX') {
            //     if (!helper.verifyTXCreditInsurance(component)) {
            //         return;
            //     }
            // }

            const emailInfo = component.get('v.emailInfo');
            if (
                $A.util.isEmpty(emailInfo) || 
                $A.util.isEmpty(emailInfo.Subject__c) || 
                $A.util.isEmpty(emailInfo.Message__c)
            ) {
                helper.showToast('Please recheck Email information', false);
                return;
            }
            const selectedEmailCommittees = component.get('v.selectedEmailCommittees');
            if (!selectedEmailCommittees || selectedEmailCommittees.length === 0) {
                helper.showToast('Please select Committee Name', false);
                return;
            }
            component.set('v.showSpinner', true);
            component.set('v.isSubmit', true);
            helper.uploadFileToSharePoint(component);
            helper.disableEditMode(component);
            // helper.saveRequestForm(component, true);
            component.find("CTRFileUpload").deletePendingAttachments()
                .then($A.getCallback(function () {
                    component.set(
                        "v.requestFormObj.CommitteeAttachment__c",
                        JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));
                    helper.saveRequestForm(component, true);
                }));
        } else {
            const emailInfo = component.get('v.emailInfo');
            if (
                $A.util.isEmpty(emailInfo) || 
                $A.util.isEmpty(emailInfo.Subject__c) || 
                $A.util.isEmpty(emailInfo.Message__c)
            ) {
                helper.showToast('Please recheck Email information', false);
                return;
            }
            const selectedEmailCommittees = component.get('v.selectedEmailCommittees');
            if (!selectedEmailCommittees || selectedEmailCommittees.length === 0) {
                helper.showToast('Please select Committee Name', false);
                return;
            }

            component.set('v.showSpinner', true);
            // const fields = event.getParam("fields");
            component.set('v.isSubmit', false);
            helper.disableEditMode(component);
            // helper.saveRequestForm(component, false);
            component.find("CTRFileUpload").deletePendingAttachments()
                .then($A.getCallback(function () {
                    component.set(
                        "v.requestFormObj.CommitteeAttachment__c",
                        JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));
                    helper.saveRequestForm(component, false);
                }));
        }
        helper.submitType = '';
    },

    handleSubmitToSH: function (component, event, helper) {
        event.preventDefault();
        helper.submitType = "SubmitToSH";
        document.getElementById("buttonSave").click();
    },

    handleSubmit: function (component, event, helper) {
        event.preventDefault();
        helper.submitType = "Submit";
        document.getElementById("buttonSave").click();
    },

    handleChangeTXCashOnDelivery: function(component, event, helper) {
        const CashOnDelivery = component.find('FinCashOnDelivery');
        const HavingCollateral = component.find('FinHavingCollateral');
        const AmountBankGuarantee = component.find('FinAmountBankGuarantee');
        const HavingCreditTermorLetter = component.find('FinHavingCreditTermOrLetter');
        const AmountCreditTerm = component.find('FinAmountCreditTerm');
        const BuyTradeEndorsement = component.find('FinBuyTradeEndorsement');
        const AmountBuyTrade = component.find('FinAmountBuyTrade');
        const BuyTradeDCLCondition = component.find('FinBuyTradeDCLCondition');
        const AmountDCLCondition = component.find('FinAmountDCLCondition');
        const HavingOpenedCredit = component.find('FinHavingOpenedCredit');
        const AmountOpenedCredit = component.find('FinAmountOpenedCredit');

        if (CashOnDelivery.get('v.value') !== 'No') {
            HavingCollateral.set('v.value', '');
            HavingCreditTermorLetter.set('v.value', '');
            BuyTradeEndorsement.set('v.value', '');
            BuyTradeDCLCondition.set('v.value', '');
            HavingOpenedCredit.set('v.value', '');

            AmountBankGuarantee.set('v.value', '0.00');
            AmountCreditTerm.set('v.value', '0.00');
            AmountBuyTrade.set('v.value', '0.00');
            AmountDCLCondition.set('v.value', '0.00');
            AmountOpenedCredit.set('v.value', '0.00');
        }
        helper.alertTXRequiredCreditInsurance(component, event, helper);
    },

    handleChangeTXCreditInsurance: function(component, event, helper) {
        const HavingCollateral = component.find('FinHavingCollateral');
        const AmountBankGuarantee = component.find('FinAmountBankGuarantee');
        const HavingCreditTermorLetter = component.find('FinHavingCreditTermOrLetter');
        const AmountCreditTerm = component.find('FinAmountCreditTerm');
        const BuyTradeEndorsement = component.find('FinBuyTradeEndorsement');
        const AmountBuyTrade = component.find('FinAmountBuyTrade');
        const BuyTradeDCLCondition = component.find('FinBuyTradeDCLCondition');
        const AmountDCLCondition = component.find('FinAmountDCLCondition');
        const HavingOpenedCredit = component.find('FinHavingOpenedCredit');
        const AmountOpenedCredit = component.find('FinAmountOpenedCredit');

        if (HavingCollateral.get('v.value') === 'No') {
            AmountBankGuarantee.set('v.value', 0);
        }
        if (HavingCreditTermorLetter.get('v.value') === 'No') {
            AmountCreditTerm.set('v.value', 0);
        }
        if (BuyTradeEndorsement.get('v.value') === 'No') {
            AmountBuyTrade.set('v.value', 0);
        }
        if (BuyTradeDCLCondition.get('v.value') === 'No') {
            AmountDCLCondition.set('v.value', 0);
        }
        if (HavingOpenedCredit.get('v.value') === 'No') {
            AmountOpenedCredit.set('v.value', 0);
        }
        helper.alertTXRequiredCreditInsurance(component, event, helper);
    },

    handleChangeCurrency: function(component, event, helper) {
        try {
            if (helper.getBU() === 'TX') {
                component.find('FinTotalSecuredCurrency').set('v.value', component.find('TXFinCrLimitCur').get('v.value'))
            } else {
                component.find('FinTotalSecuredCurrency').set('v.value', component.find('FinCrLimitCur').get('v.value'))
            }
        } catch(ex) {
            console.error(ex);
        }
    },

    handleSelectedCommittees: function (component, event, helper) {
        console.log(JSON.parse(JSON.stringify(component.get("v.selectedCommittees"))));
        const selectedCommittees = component.get("v.selectedCommittees");
        component.set("v.requestFormObj.CommitteeName__c", selectedCommittees.join(","));
        component.set("v.committeeName", selectedCommittees.join(","));
    },

    handleSelectedEmailCommittees: function (component, event, helper) {
        console.log(JSON.parse(JSON.stringify(component.get("v.selectedEmailCommittees"))));
        const selectedEmailCommittees = component.get("v.selectedEmailCommittees");
        component.set("v.requestFormObj.EmailTo__c", selectedEmailCommittees.join(","));
        component.set("v.emailTo", selectedEmailCommittees.join(","));
    },

    handleFileListChange: function (component, event, helper) {
        try {
            console.log('do file change');
            let jsonFileList = component.get("v.jsonFileList");
            component.find("attachments").set("v.value", JSON.stringify(jsonFileList));
            component.set("v.requestFormObj.CommitteeAttachment__c", JSON.stringify(jsonFileList));
            component.find("requestItemLoader").saveRecord($A.getCallback(function (saveResult) {
                console.log(saveResult);
            }));
        } catch (ex) {
            console.error(ex);
        }
    },

    handleFileToDeleteChange: function (component, event, helper) {
        const fileToDelList = component.get('v.fileToDelList') || [];
        if (fileToDelList.length) {
            const oldAttachments = component.get('v.uploadedFile') ? JSON.parse(component.get('v.uploadedFile')) : [];

            const newAttachments = oldAttachments.filter((item) => {
                return fileToDelList.indexOf(item.Id) < 0;
            });
            component.set('v.uploadedFile', JSON.stringify(newAttachments));
            component.set("v.requestFormObj.CommitteeAttachment__c", JSON.stringify(newAttachments));
        }
    },
})