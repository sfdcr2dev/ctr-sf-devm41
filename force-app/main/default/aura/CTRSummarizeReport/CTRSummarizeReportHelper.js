({
    closeModal: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isModalOpen", false);
    },


    getSummarizeReport: function (component) {
        console.log('getSummarizeReport');
        var action = component.get('c.getSummarizeReportInfo');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "templateType": component.get('v.templateType')
        });
        console.log(component.get('v.recordId'));
        console.log(component.get('v.templateType'));

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('SUCCESS ' + response.getReturnValue());

                var sumRep = response.getReturnValue();
                component.set('v.ownerId', sumRep.SummarizeReportReassign__c);
                component.set('v.sumRepObj.SummarizeReportSubject__c', sumRep.SummarizeReportSubject__c);
                component.set('v.sumRepObj.SummarizeReportMessage__c', sumRep.SummarizeReportMessage__c);
                component.set('v.sumRepObj.SummarizeReportEmailTo__c', sumRep.SummarizeReportEmailTo__c);
                component.set('v.selectedEmailCC', sumRep.SummarizeReportEmailCC__c);



                var selectCC = component.get('v.selectedEmailCC');

                console.log('selectCC :' + selectCC);

                if (selectCC == null || selectCC == '') {
                    if (sumRep.CreditOwner__r) {
                        component.set('v.selectedEmailCC', sumRep.CreditOwner__r.Email);
                    }
                } else {
                    console.log('CreditOwner :' + sumRep.CreditOwner__c);
                    if (sumRep.CreditOwner__c != null && sumRep.CreditOwner__c != '') {
                        if (sumRep.CreditOwner__r && sumRep.CreditOwner__r.Email != null && sumRep.CreditOwner__r.Email != '') {

                            if (!selectCC.includes(sumRep.CreditOwner__r.Email)) {
                                component.set('v.selectedEmailCC', selectCC + ', ' + sumRep.CreditOwner__r.Email);
                            }
                        }
                    }

                }
                console.log('selectCC ' + component.get('v.selectedEmailCC'));

                component.set('v.uploadedFile', sumRep.SummarizeReportAttachment__c);
                var recordType = sumRep.RecordType.Name;
                // component.set('v.sumRepObj.', sumRep.);
                var isTRCR = sumRep.isTRCR__c;
                if (isTRCR == 'true') {
                    this.setRecordType(component, recordType);
                    this.getMailApprovalReport(component, sumRep);
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Do not have permission",
                        "type": "error"
                    });
                    toastEvent.fire();

                    //$A.get("e.force:closeQuickAction").fire();
                    component.set("v.isModalOpen", false);
                }

                // component.set('v.isFetchAttachments', true);
                component.set('v.showSpinner', false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getMailApprovalReport: function (component, sumRep) {
        component.set('v.emailInfo.Subject__c', sumRep.SummarizeReportSubject__c);
        component.set('v.emailInfo.EmailTo__c', this.getEmailTo(sumRep));
        component.set('v.emailInfo.EmailCC__c', sumRep.SummarizeReportEmailCC__c);
        component.set('v.emailInfo.Message__c', sumRep.SummarizeReportMessage__c);
    },

    setMailApprovalReport: function (component) {
        console.log('fileToUpload' + component.get('v.fileToUpload'));
        console.log('EmailTo__c' + component.get('v.emailInfo.EmailTo__c'));
        console.log('EmailCC__c' + component.get('v.emailInfo.EmailCC__c'));
        console.log('Subject__c' + component.get('v.emailInfo.Subject__c'));
        console.log('Message__c' + component.get('v.emailInfo.Message__c'));
        console.log('selectedEmailCC' + component.get('v.selectedEmailCC'));

        component.set('v.sumRepObj.Id', component.get('v.recordId'));
        // component.set('v.sumRepObj.SummarizeReportAttachment__c', component.get('v.fileToUpload'));
        component.set('v.sumRepObj.SummarizeReportEmailTo__c', component.get('v.emailInfo.EmailTo__c'));
        component.set('v.sumRepObj.SummarizeReportEmailCC__c', component.get('v.selectedEmailCC'));
        component.set('v.sumRepObj.SummarizeReportSubject__c', component.get('v.emailInfo.Subject__c'));
        component.set('v.sumRepObj.SummarizeReportMessage__c', component.get('v.emailInfo.Message__c'));
        // component.set('v.reqDocObj.CommitteeName__c', component.get('v.committeeName'));
    },

    saveSumRep: function (component) {
        const _THIS_ = this;
        return new Promise($A.getCallback(function (resolve, reject) {
            _THIS_.setMailApprovalReport(component);
            var subject = component.get('v.sumRepObj.SummarizeReportSubject__c');
            if (subject != '' && subject != null && subject != undefined) {
                component.set('v.requestFormObj.SummarizeReportReassign__c', component.get('v.ownerId'));
                console.log('obj' + component.get('v.sumRepObj'));
                console.log('submit' + component.get('v.isSubmit'));
                console.log('upload' + component.get('v.uploadedFile'));
                var action = component.get('c.saveSummarizeReport');
                action.setParams({
                    "reqFormItem": component.get('v.sumRepObj'),
                    "isSubmit": component.get('v.isSubmit'),
                    "uploadedList": component.get('v.sumRepObj.SummarizeReportAttachment__c'),
                    "recordId": component.get('v.recordId')
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        if (component.get('v.isSubmit')) {
                            _THIS_.showToast('The summary report has been submitted!', true);
                            component.set('v.showSpinner', false);

                        } else {
                            _THIS_.showToast('The summary report has been saved!', true);
                            component.set('v.showSpinner', false);
                            //window.location.reload();
                        }
                        resolve(state);
                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors && errors[0] && errors[0].message) {
                            _THIS_.showToast(errors[0].message, false);
                            console.log("Error message: " + errors[0].message);
                        }
                        component.set('v.showSpinner', false);
                        reject(state);
                    }
                    $A.get("e.force:closeQuickAction").fire();
                });
                $A.enqueueAction(action);
            }
            else {
                this.showToast('Subject cannot be blank', false);
                reject("INCOMPLETE");
            }
        }));
    },
    uploadFileToSharePoint: function (component) {
        component.set('v.showSpinner', true);
        var action = component.get('c.sendFiletoHeroku');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "uploadedList": component.get('v.uploadedFile')

        });
        action.setCallback(this, function (res) {
            var state2 = res.getState();
            console.log('state2:' + state2);
            if (state2 === "SUCCESS") {
                this.showToast('Files submitted!', true);

            }
            component.set('v.showSpinner', false);
            this.closeModal(component);
            //window.location.reload();
        });
        $A.enqueueAction(action);
    },

    showToast: function (message, isSuccess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": isSuccess ? "success" : "error",
            "message": message
        });
        toastEvent.fire();
    },

    getListFile: function (component) {
        var action = component.get('c.getUploadedFileName');
        action.setParams({
            "recordId": component.get('v.recordId'),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var fileName = response.getReturnValue();
                component.set('v.uploadedFile', fileName);
                console.log('fileName in get list file: ' + component.get('v.uploadedFile'));

                let oldAttachments = JSON.parse(fileName) || [];

                let attachments = oldAttachments.filter((item) => item.IsSaved);
                component.set("v.attachments", attachments);
                component.set('v.uploadedFile', JSON.stringify(attachments));

                let fileToDelList = oldAttachments.filter((item) => !item.IsSaved);
                let idFileToDelList = fileToDelList.map((item) => item.Id);
                //debugger;
                component.set("v.fileToDelList", idFileToDelList);
                component.set("v.isDelFile", true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getProfileName: function (component) {
        var action = component.get("c.getCurrentUserProfileName");
        action.setParams({
            "recID": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var profileInfo = response.getReturnValue();
                var businessUnit = profileInfo['BusinessUnit'];
                var approvalStep = profileInfo['ApprovalStep'];
                component.set('v.profile', businessUnit);
                component.set('v.approvalStep', approvalStep);
                $A.get('e.force:refreshView').fire();
                if ((component.get('v.profile') == 'TOP' || component.get('v.profile') == 'LABIX') && component.get('v.approvalStep') == 'Approved') {
                    component.set('v.templateType', 'Approved Summarize Report TOP');
                } else if ((component.get('v.profile') == 'TOP' || component.get('v.profile') == 'LABIX') && component.get('v.approvalStep') == 'Rejected') {
                    component.set('v.templateType', 'Rejected Summarize Report TOP');
                } else if ((component.get('v.profile') == 'TX' || component.get('v.profile') == 'System Administrator') && component.get('v.approvalStep') == 'Approved') {
                    component.set('v.templateType', 'Approved Summarize Report TX');
                } else if ((component.get('v.profile') == 'TX' || component.get('v.profile') == 'System Administrator') && component.get('v.approvalStep') == 'Rejected') {
                    component.set('v.templateType', 'Rejected Summarize Report TX');
                }
                this.getSummarizeReport(component);
            } else {
                console.error('Error fetching profile name');
            }
        });

        $A.enqueueAction(action);
    },

    setRecordType: function (component, recordType) {
        if (recordType.includes('Customer')) {
            component.set('v.recordType', 'Customer');
        }
        if (recordType.includes('Supplier')) {
            component.set('v.recordType', 'Supplier');
        }
    },

    getEmailTo: function (sumRep) {
        const email = [];

        if (sumRep
            && sumRep.Owner
            && sumRep.Owner.Email
        ) email.push(sumRep.Owner.Email);

        if (sumRep
            && sumRep.OwnersSectionHead__r
            && sumRep.OwnersSectionHead__r.Email
        ) email.push(sumRep.OwnersSectionHead__r.Email);

        if (sumRep
            && sumRep.OwnersCMVP__r
            && sumRep.OwnersCMVP__r.Email
        ) email.push(sumRep.OwnersCMVP__r.Email);

        const uniq = email.filter(
            (value, index, array) => array.indexOf(value) === index
        );

        return uniq.join(',');
    },

})