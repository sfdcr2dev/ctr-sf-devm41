({
    closeModal: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isModalOpen", false);
    },

    getRecordTypes: function (component) {
        var action = component.get('c.getRecordType');
        action.setParams({
            "recordId": component.get('v.recordId'),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordInfo = response.getReturnValue();
                var profile = recordInfo.BusinessUnit;
                var recordType = recordInfo.RecordTypeName;
                //console.log('recordType'+recordType);
                var status = recordInfo.Status;
                var approvalStep = recordInfo.ApprovalStep;

                component.set('v.profile', profile);
                component.set('v.status', status);
                component.set('v.approvalStep', approvalStep);

                console.log('recordType: ' + JSON.stringify(recordInfo));
                // if (component.get('v.profile') == 'TOP' || component.get('v.profile') == 'LABIX') {
                //     if (recordType.includes('Customer')) {
                //         if (component.get('v.approvalStep') == 'Summary Report' && component.get('v.status') == 'Approved') {
                //             component.set('v.recordType', 'Customer');
                //             component.set('v.templateType', 'Approved Customer TOP');
                //         } else if (component.get('v.status') == 'Rejected' || (component.get('v.approvalStep') == 'Inform Counterparty' && component.get('v.status') == 'Rejected')) {
                //             component.set('v.recordType', 'Customer');
                //             component.set('v.templateType', 'Rejected Customer TOP');
                //         }
                //     } else if (recordType.includes('Supplier')) {
                //         if (component.get('v.approvalStep') == 'Summary Report' && component.get('v.status') == 'Approved') {
                //             component.set('v.recordType', 'Supplier');
                //             component.set('v.templateType', 'Approved Supplier TOP');
                //         } else if (component.get('v.status') == 'Rejected' || (component.get('v.approvalStep') == 'Inform Counterparty' && component.get('v.status') == 'Rejected')) {
                //             component.set('v.recordType', 'Supplier');
                //             component.set('v.templateType', 'Rejected Supplier TOP');
                //         }
                //     }
                // } else if (component.get('v.profile') == 'TX' || component.get('v.profile') == 'System Administrator') {
                //     if (recordType.includes('Customer')) {
                //         if (component.get('v.approvalStep') == 'Summary Report' && component.get('v.status') == 'Approved') {
                //             component.set('v.recordType', 'Customer');
                //             component.set('v.templateType', 'Approved Customer TOP');
                //         } else if (component.get('v.status') == 'Rejected' || (component.get('v.approvalStep') == 'Inform Counterparty' && component.get('v.status') == 'Rejected')) {
                //             component.set('v.recordType', 'Customer');
                //             component.set('v.templateType', 'Rejected Customer TOP');
                //         }
                //     } else if (recordType.includes('Supplier')) {
                //         if (component.get('v.approvalStep') == 'Summary Report' && component.get('v.status') == 'Approved') {
                //             component.set('v.recordType', 'Supplier');
                //             component.set('v.templateType', 'Approved Supplier TOP');
                //         } else if (component.get('v.status') == 'Rejected' || (component.get('v.approvalStep') == 'Inform Counterparty' && component.get('v.status') == 'Rejected')) {
                //             component.set('v.recordType', 'Supplier');
                //             component.set('v.templateType', 'Rejected Supplier TOP');
                //         }
                //     }
                // }
                console.log('recordType: ' + component.get('v.recordType'));
                this.handleRecordType(component, status, approvalStep, recordType);
                // component.set('v.showSpinner', false);
                this.getEmailToRec(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleRecordType: function (component, status, approvalStep, recordType) {
        if (component.get('v.profile') == 'TOP' || component.get('v.profile') == 'LABIX') {
            if (recordType.includes('Customer')) {
                this.handleCustomerTOP(component, status, approvalStep, 'Customer');
            } else if (recordType.includes('Supplier')) {
                this.handleSupplierTOP(component, status, approvalStep, 'Supplier');
            }
        } else if (component.get('v.profile') == 'TX' || component.get('v.profile') == 'System Administrator') {
            if (recordType.includes('Customer')) {
                this.handleCustomerTX(component, status, approvalStep, 'Customer');
            } else if (recordType.includes('Supplier')) {
                this.handleSupplierTX(component, status, approvalStep, 'Supplier');
            }
        }
    },

    handleCustomerTOP: function (component, status, approvalStep, recordType) {
        if ((approvalStep == 'Summary Report' && status == 'Approved') || (status == 'Rejected' || (approvalStep == 'Inform Counterparty' && status == 'Rejected'))) {
            component.set('v.recordType', recordType);
            component.set('v.templateType', (status == 'Approved') ? 'Approved ' + recordType + ' TOP' : 'Rejected ' + recordType + ' TOP');
        }
    },

    handleSupplierTOP: function (component, status, approvalStep, recordType) {
        if ((approvalStep == 'Summary Report'|| (status == 'Rejected' || (approvalStep == 'Inform Counterparty' && status == 'Rejected') || (approvalStep == 'Inform Counterparty' && status == 'Approved')))) {
            component.set('v.recordType', recordType);
            component.set('v.templateType', (status == 'Approved') ? 'Approved ' + recordType + ' TOP' : 'Rejected ' + recordType + ' TOP');
        }
    },
    handleCustomerTX: function (component, status, approvalStep, recordType) {
        if ((approvalStep == 'Summary Report' && status == 'Approved') || (status == 'Rejected' || (approvalStep == 'Inform Counterparty' && status == 'Rejected'))) {
            component.set('v.recordType', recordType);
            component.set('v.templateType', (status == 'Approved') ? 'Approved ' + recordType + ' TX' : 'Rejected ' + recordType + ' TX');
        }
    },

    handleSupplierTX: function (component, status, approvalStep, recordType) {
        if ((approvalStep == 'Summary Report' || (status == 'Rejected' || (approvalStep == 'Inform Counterparty' && status == 'Rejected')))) {
            component.set('v.recordType', recordType);
            component.set('v.templateType', (status == 'Approved') ? 'Approved ' + recordType + ' TX' : 'Rejected ' + recordType + ' TX');
        }
    },

    getEmailToRec: function (component) {
        console.log('Rec id ' + component.get('v.recordId'))
        var action = component.get('c.getEmailToInfo');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "templateType": component.get('v.templateType')
        });

        console.log(component.get('v.recordId'));
        console.log(component.get('v.templateType'));

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var emailToRec = response.getReturnValue();
                console.log('emailToRec.EmailPageEmailTo__c ' + emailToRec.EmailPageEmailTo__c);
                console.log('emailToRec.EmailPageEmailTo__c ' + emailToRec.EmailPageAttachment__c)
                component.set('v.emailToObj.EmailPageSubject__c', emailToRec.EmailPageSubject__c);
                component.set('v.emailToObj.EmailPageMessage__c', emailToRec.EmailPageMessage__c);
                component.set('v.emailToObj.EmailPageEmailTo__c', emailToRec.EmailPageEmailTo__c);
                component.set('v.selectedEmailCC', emailToRec.EmailPageEmailCC__c);
                component.set('v.uploadedFile', emailToRec.EmailPageAttachment__c);

                console.log('uploadedFile ' + component.get('v.uploadedFile'));
                this.getEmailInfo(component, emailToRec);
                component.set('v.isFetchAttachments', true);
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

    getEmailInfo: function (component, emailToRec) {
        component.set('v.emailInfo.Subject__c', emailToRec.EmailPageSubject__c);
        component.set('v.emailInfo.EmailTo__c', emailToRec.CTRRequestFormHeader__r.Email__c);
        component.set('v.emailInfo.EmailCC__c', emailToRec.EmailPageEmailCC__c);
        component.set('v.emailInfo.Message__c', emailToRec.EmailPageMessage__c);
    },

    setEmailTo: function (component) {
        component.set('v.emailToObj.Id', component.get('v.recordId'));
        component.set('v.emailToObj.EmailPageAttachment__c', component.get('v.fileToUpload'));
        console.log('emailto ' + component.get('v.emailInfo.EmailTo__c'));
        if (component.get('v.emailInfo.EmailTo__c') == null || component.get('v.emailInfo.EmailTo__c') == '') {
            component.set('v.emailToObj.EmailPageEmailTo__c', component.get('v.DefaultEmail'));
        } else {
            component.set('v.emailToObj.EmailPageEmailTo__c', component.get('v.emailInfo.EmailTo__c'));
        }
        component.set('v.emailToObj.EmailPageEmailCC__c', component.get('v.selectedEmailCC'));
        component.set('v.emailToObj.EmailPageSubject__c', component.get('v.emailInfo.Subject__c'));
        component.set('v.emailToObj.EmailPageMessage__c', component.get('v.emailInfo.Message__c'));
    },

    saveEmail: function (component) {
        this.setEmailTo(component);

        var action = component.get('c.saveEmailTo');
        action.setParams({
            "reqFormItem": component.get('v.emailToObj'),
            "isSubmit": component.get('v.isSubmit'),
            "uploadedList": component.get('v.uploadedFile'),
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (component.get('v.isSubmit')) {
                    this.showToast('The email has been submitted!', true);

                } else {
                    this.showToast('Record saved successfully', true);
                    component.set('v.showSpinner', false);
                    //window.location.reload();
                }
                // component.set('v.showSpinner', false);
                // window.location.reload();

                console.log('Before refreshing view');
                // Navigate to the same record page to refresh
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get('v.recordId'),
                    "slideDevName": "detail"
                });
                navEvt.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
                component.set('v.showSpinner', false);
            }
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
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
})