({
    getRecordTypes: function (component) {
        var action = component.get('c.getRecordTypeForLead');
        console.log('recordid '+component.get('v.recordId'));
        action.setParams({
            "recordId": component.get('v.recordId'),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getRecordTypes s');
                var recordType = response.getReturnValue();
                console.log('recordType: ' + recordType);
                if (recordType.includes('TX') || recordType.includes('Tx') ) {
                    //component.set('v.recordType', 'Customer');
                    //component.set('v.headerModal', 'Email to Customer');
                    component.set('v.templateType', 'Lead TX');
                } else if (recordType.includes('TOP')) {
                    //component.set('v.recordType', 'Supplier');
                    //component.set('v.headerModal', 'Email to Supplier');
                    component.set('v.templateType', 'Lead TOP');
                }
                /*
                if (recordType.includes('Customer')) {
                    component.set('v.recordType', 'Customer');
                    component.set('v.headerModal', 'Email to Customer');
                    component.set('v.templateType', 'Customer');
                } else if (recordType.includes('Supplier')) {
                    component.set('v.recordType', 'Supplier');
                    component.set('v.headerModal', 'Email to Supplier');
                    component.set('v.templateType', 'Supplier');
                }else{ // TOP?
                    component.set('v.recordType', 'Customer');
                    component.set('v.headerModal', 'Email to Customer');
                    component.set('v.templateType', 'Customer');
                } */
                console.log('recordType: ' + component.get('v.recordType'));
                // component.set('v.showSpinner', false);
                this.getEmailToRec(component);
            } else if (state === "ERROR") {
                console.log('getRecordTypes e');
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },getEmailToRec: function (component) {
        var action = component.get('c.getEmailToInfoForLead');
        console.log('type '+component.get('v.templateType'));
        action.setParams({
            "recordId": component.get('v.recordId'),
            "templateType": component.get('v.templateType')
        });
        action.setCallback(this, function (response) {
            console.log('getEmailToRec');
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getEmailToRec s');
                var emailToRec = response.getReturnValue();
                component.set('v.emailToObj.EmailPageSubject__c', emailToRec.EmailPageSubject__c);
                component.set('v.emailToObj.EmailPageMessage__c', emailToRec.EmailPageMessage__c);
                component.set('v.emailToObj.EmailPageEmailTo__c', emailToRec.EmailPageEmailTo__c);
                component.set('v.selectedEmailCC', emailToRec.EmailPageEmailCC__c);
                component.set('v.uploadedFile', emailToRec.EmailPageAttachment__c);

                this.getEmailInfo(component, emailToRec);
                component.set('v.isFetchAttachments', true);
                component.set('v.showSpinner', false);
            } else if (state === "ERROR") {
                console.log('getEmailToRec e');
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },getEmailInfo: function (component, emailToRec) {
        console.log('getEmailInfo?');
        component.set('v.emailInfo.Subject__c', emailToRec.EmailPageSubject__c);
        console.log('emailToRec.EmailPageSubject__c ?'+emailToRec.EmailPageSubject__c);
        component.set('v.emailInfo.EmailTo__c', emailToRec.Email);
        console.log('emailToRec.Email__c ?'+emailToRec.Email);
        component.set('v.emailInfo.EmailCC__c', emailToRec.EmailPageEmailCC__c);
        console.log('emailToRec.EmailPageEmailCC__c ?'+emailToRec.EmailPageEmailCC__c);
        component.set('v.emailInfo.Message__c', emailToRec.EmailPageMessage__c);
        console.log('emailToRec.EmailPageMessage__c ?'+emailToRec.EmailPageMessage__c);
    },
    setEmailTo: function (component) {
        console.log('setEmailTo ? in');
        component.set('v.emailToObj.Id', component.get('v.recordId'));
        component.set('v.emailToObj.EmailPageAttachment__c', component.get('v.fileToUpload'));
        component.set('v.emailToObj.EmailPageEmailTo__c', component.get('v.emailInfo.EmailTo__c'));
        /*
        if(component.get('v.selectedEmailCC') == null ||component.get('v.selectedEmailCC') == ''){
            component.set('v.emailToObj.EmailPageEmailCC__c', 'ccemailcommitteetestuser@278tumlkpac10g9kik3znxpnfa13iz7hj9w1rudnbh2cj8m2pw.1m-2nh5eam.cs117.apex.sandbox.salesforce.com');
        }else if(!component.get('v.selectedEmailCC').includes('ccemailcommitteetestuser@278tumlkpac10g9kik3znxpnfa13iz7hj9w1rudnbh2cj8m2pw.1m-2nh5eam.cs117.apex.sandbox.salesforce.com')){
            component.set('v.emailToObj.EmailPageEmailCC__c', component.get('v.selectedEmailCC')+', ccemailcommitteetestuser@278tumlkpac10g9kik3znxpnfa13iz7hj9w1rudnbh2cj8m2pw.1m-2nh5eam.cs117.apex.sandbox.salesforce.com');
        }else{
        	component.set('v.emailToObj.EmailPageEmailCC__c', component.get('v.selectedEmailCC'));
        }*/
        
        
        component.set('v.emailToObj.EmailPageEmailCC__c', component.get('v.selectedEmailCC'));
        component.set('v.emailToObj.EmailPageSubject__c', component.get('v.emailInfo.Subject__c'));
        component.set('v.emailToObj.EmailPageMessage__c', component.get('v.emailInfo.Message__c'));
        console.log('setEmailTo ? out');
    },

    saveEmail: function (component) {
        //alert('isUploadSuccess '+component.get('v.isUploadSuccess'));
        this.setEmailTo(component);
		console.log('saveEmail');
        var action = component.get('c.saveEmailToForLead');
        console.log('upload'+component.get('v.uploadedFile'));
        console.log('Code update?');
        action.setParams({
            "LeadRec": component.get('v.emailToObj'),
            "isSubmit": component.get('v.isSubmit'),
            "uploadedList": component.get('v.uploadedFile'),
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            console.log('before state');
            
            var state = response.getState();
            console.log('state '+state);
            
            if (state === "SUCCESS") {
                console.log('saveEmail s');
                if (component.get('v.isSubmit')) {
                    console.log('isSubmit ?');
                    this.showToast('The email has been submitted!', true);
                } else {
                    console.log('isNotSubmit ?');
                    this.showToast('Record saved successfully', true);
                }
                console.log('showSpinner ?');
                component.set('v.showSpinner', false);
                //window.location.reload();
            } else if (state === "ERROR") {
                console.log('saveEmail e');
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

    showToast: function (message, isSuccess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": isSuccess ? "success" : "error",
            "message": message
        });
        toastEvent.fire();
    },getListFile: function (component) {
        //alert('getListFile');
        var action = component.get('c.getUploadedFileNameForLead');
        action.setParams({
            "recordId": component.get('v.recordId'),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('getListFile s');
                var fileName = response.getReturnValue();
                component.set('v.uploadedFile', fileName);
                console.log('fileName in get list file: ' + component.get('v.uploadedFile'));
            } else if (state === "ERROR") {
                //alert('getListFile e');
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    
    
    
    
    
	closeModal: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isModalOpen", false);
    },

})