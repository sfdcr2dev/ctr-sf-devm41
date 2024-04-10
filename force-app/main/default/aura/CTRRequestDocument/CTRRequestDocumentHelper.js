({
    closeModal: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isReqDoc", false);
    },
    

    setMailApprovalReport: function (component) {
        component.set('v.reqDocObj.Id', component.get('v.recordId'));
        //component.set('v.reqDocObj.CustomerAttachment__c', component.get('v.fileToUpload'));
        component.set('v.reqDocObj.CustomerEmailTo__c', component.get('v.emailInfo.EmailTo__c'));
        component.set('v.reqDocObj.CustomerEmailCC__c', component.get('v.selectedEmailCC'));
        component.set('v.reqDocObj.CustomerSubject__c', component.get('v.emailInfo.Subject__c'));
        component.set('v.reqDocObj.CustomerMessage__c', component.get('v.emailInfo.Message__c'));

        // component.set('v.reqDocObj.CommitteeName__c', component.get('v.committeeName'));
    },

    saveReqDoc: function (component) {
        //this.setMailApprovalReport(component);
		component.set('v.reqDocObj.Id', component.get('v.recordId'));
        //component.set('v.reqDocObj.CustomerAttachment__c', component.get('v.fileToUpload'));
        component.set('v.reqDocObj.CustomerEmailTo__c', component.get('v.emailInfo.EmailTo__c'));
        component.set('v.reqDocObj.CustomerEmailCC__c', component.get('v.selectedEmailCC'));
        component.set('v.reqDocObj.CustomerSubject__c', component.get('v.emailInfo.Subject__c'));
        component.set('v.reqDocObj.CustomerMessage__c', component.get('v.emailInfo.Message__c'));
        console.log('submit---'+component.get('v.isSubmit'));
        var action = component.get('c.saveRequestDoc');
        action.setParams({
            "reqFormItem": component.get('v.reqDocObj'),
            "isSubmit": component.get('v.isSubmit'),
            "uploadedList": component.get('v.uploadedFile')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(component.get('v.isSubmit'))
                {
                    this.showToast('Email sent.', true);
                }
                else
                {
                    this.showToast('Record saved successfully', true);
                }
                
                this.closeModal(component);
                component.set('v.showSpinner', false);
                helper.uploadFileToSharePoint(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
                component.set('v.showSpinner', false);
            }
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
                /*
                var fileName = response.getReturnValue();
                component.set('v.uploadedFile', fileName);
                console.log('fileName in get list file: ' + component.get('v.uploadedFile'));*/
                
                var fileName = response.getReturnValue();
                component.set('v.uploadedFile', fileName);
                console.log('fileName in get list file: ' + component.get('v.uploadedFile'));

                let oldAttachments = JSON.parse(fileName) || [];
                
                let attachments = oldAttachments.filter((item) => item.IsSaved);
                component.set("v.attachments", attachments);
                
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

    uploadFileToSharePoint: function (component) {
        component.set('v.showSpinner', true);
        var action = component.get('c.sendFiletoHeroku');
        action.setParams({
                "recordId": component.get('v.recordId'),
                "uploadedList": component.get('v.uploadedFile'),
                "reqFormItem": component.get('v.reqDocObj')
                
            });
        action.setCallback(this, function (res) {
            var state2 = res.getState();
            console.log('state2:'+state2);
            if (state2 === "SUCCESS") 
            {
                this.showToast('Files submitted!', true);
    
            }
            component.set('v.showSpinner', false);
            this.closeModal(component);
        //window.location.reload();
        });
        $A.enqueueAction(action);
    },
})