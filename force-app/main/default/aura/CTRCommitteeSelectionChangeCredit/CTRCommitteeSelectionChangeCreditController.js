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
        const p7 = p3.then($A.getCallback(() => {
            const subBU = helper.getSubBU();
            const counterpartyType = helper.getCounterpartyType();
            const type = helper.isDomesticOrInternational();
            const hasCrude = helper.hasCrudeProduct() ? "Crude" : "";
            const interByTX = helper.isInterByTX() ? "Yes" : "No";

            return helper.getCEO(subBU, counterpartyType, type, hasCrude, interByTX);
        })).catch($A.getCallback((error) => {
            helper.showToast(error.message, 'error');
        }));

        Promise.all([p3, p4, p5, p6, p7]).then($A.getCallback(function ([committeeInfo, groupedCommittees, trcrList, trcrHeadList, ceoList]) {
            const subBU = helper.getSubBU();

            const lstCommittee = helper.convertGroupedCommitteesToList(groupedCommittees);
            const lstCompany = [subBU];

            if (String(committeeInfo.EmailAuthorization__c).toLowerCase() === "ceo required") {
                component.set("v.emailInfo.EmailTo__c", helper.getCEOEmail());
                component.set("v.requestFormObj.EmailTo__c", helper.getCEOEmail());
                helper.loadCommittee(lstCommittee, lstCompany, committeeInfo);
            } else if (String(committeeInfo.EmailAuthorization__c).toLowerCase() === "committee required") {
                if (!committeeInfo.CommitteeName__c) {
                    helper.defaultCommittee(lstCommittee, lstCompany, committeeInfo);
                } else {
                    helper.loadCommittee(lstCommittee, lstCompany, committeeInfo);
                }
            } else {
                helper.loadCommittee(lstCommittee, lstCompany, committeeInfo);
            }

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
        helper.setPreviewEMailInfo();
        component.set("v.isModalOpen", true);
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
        event.preventDefault();

        const emailAuthorization = component.find("EmailAuthorization").get("v.value");
        const emailAuthorizationLowerCase = String(emailAuthorization).toLowerCase();

        const emailInfo = component.get('v.emailInfo');
        if (
            (emailAuthorizationLowerCase === "ceo required" ||
                emailAuthorizationLowerCase === "committee required") &&
            ($A.util.isEmpty(emailInfo) ||
                $A.util.isEmpty(emailInfo.Subject__c) ||
                $A.util.isEmpty(emailInfo.Message__c))
        ) {
            helper.showToast('Please recheck Email information', 'error');
            return;
        }

        const selectedEmailCommittees = component.get('v.selectedEmailCommittees');
        if (
            emailAuthorizationLowerCase === "committee required" &&
            (!selectedEmailCommittees || selectedEmailCommittees.length === 0)
        ) {
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

                    return helper.submitToSH();
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

                    if (emailAuthorizationLowerCase === "ceo required") {
                        return helper.submitToCEO();
                    } else if (emailAuthorizationLowerCase === "committee required") {
                        return helper.submitToCommittees();
                    } else {
                        return helper.submitNoApproval()
                    }
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
                        return helper.saveRequestFormSH();
                    } else {
                        return helper.saveRequestForm();
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

    handleChangeEmailAuthorization: function (component, event, helper) {
        const cmpEmailAuthorization = component.find("EmailAuthorization");
        if (!$A.util.isEmpty(cmpEmailAuthorization)) {
            const emailAuthorization = cmpEmailAuthorization.get("v.value");
            const emailAuthorizationLowerCase = String(emailAuthorization).toLowerCase();

            helper.toggleCommitteeSelection(emailAuthorization);
            helper.toggleMailToCommittee(emailAuthorization);

            if (emailAuthorizationLowerCase === "ceo required") {
                helper.resetCommittee();

                component.set("v.emailInfo.EmailTo__c", helper.getCEOEmail());
                component.set("v.requestFormObj.EmailTo__c", helper.getCEOEmail());
            } else if (emailAuthorizationLowerCase === "committee required") {
                const subBU = helper.getSubBU();
                const groupedCommittees = component.get("v.groupedCommittees");
                const committeeInfo = component.get("v.committeeInfo");
                const lstCommittee = helper.convertGroupedCommitteesToList(groupedCommittees);
                const lstCompany = [subBU];

                helper.defaultCommittee(lstCommittee, lstCompany, committeeInfo);
            } else {
                helper.resetCommittee();
            }
        }
    },

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
        const subject = (emailUrgent === "Yes") ? "[Urgent]" + component.get("v.requestFormObj.Subject__c") : component.get("v.requestFormObj.Subject__c");
        component.set("v.emailInfo.Subject__c", subject);
    },
})